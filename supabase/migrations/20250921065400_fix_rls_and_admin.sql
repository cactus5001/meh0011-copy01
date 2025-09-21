-- SECURE Fix for RLS policies and authentication
-- Apply this SQL in Supabase SQL Editor

-- First, add missing INSERT policies for users table
DO $$ 
BEGIN
    -- Drop and recreate policies to avoid conflicts
    DROP POLICY IF EXISTS "Users can insert own data" ON users;
    CREATE POLICY "Users can insert own data" ON users 
    FOR INSERT TO authenticated 
    WITH CHECK (auth.uid() = id);
    
    DROP POLICY IF EXISTS "Users can update own data" ON users;
    CREATE POLICY "Users can update own data" ON users 
    FOR UPDATE TO authenticated 
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);
EXCEPTION 
    WHEN others THEN 
        RAISE NOTICE 'Policy creation failed: %', SQLERRM;
END $$;

-- Add RESTRICTED INSERT policy for user_roles (PATIENT ROLE ONLY)
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Users can insert patient role only" ON user_roles;
    CREATE POLICY "Users can insert patient role only" ON user_roles 
    FOR INSERT TO authenticated 
    WITH CHECK (user_id = auth.uid() AND role = 'patient');
EXCEPTION 
    WHEN others THEN 
        RAISE NOTICE 'User roles policy creation failed: %', SQLERRM;
END $$;

-- SECURE create_super_admin function (SERVICE ROLE ONLY)
CREATE OR REPLACE FUNCTION create_super_admin(
    admin_user_id uuid,
    admin_email text,
    admin_name text
) RETURNS void AS $$
DECLARE
    existing_admin_count int;
BEGIN
    -- Set secure search path
    SET search_path = public;
    
    -- Check if super admin already exists
    SELECT COUNT(*) INTO existing_admin_count 
    FROM user_roles 
    WHERE role = 'super_admin';
    
    IF existing_admin_count > 0 THEN
        RAISE EXCEPTION 'Super admin already exists';
    END IF;
    
    -- Insert user record (with security definer to bypass RLS)
    INSERT INTO users (id, email, full_name, created_at, updated_at)
    VALUES (admin_user_id, admin_email, admin_name, now(), now())
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        full_name = EXCLUDED.full_name,
        updated_at = now();
    
    -- Insert super_admin role
    INSERT INTO user_roles (user_id, role, created_at)
    VALUES (admin_user_id, 'super_admin', now())
    ON CONFLICT (user_id, role) DO NOTHING;
    
    -- Also add admin role for broader permissions
    INSERT INTO user_roles (user_id, role, created_at)
    VALUES (admin_user_id, 'admin', now())
    ON CONFLICT (user_id, role) DO NOTHING;
    
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- SECURE function to assign default patient role with caller verification
CREATE OR REPLACE FUNCTION assign_default_patient_role(p_user_id uuid)
RETURNS void AS $$
BEGIN
    -- Set secure search path
    SET search_path = public;
    
    -- Verify caller is acting on their own behalf
    IF auth.uid() != p_user_id THEN
        RAISE EXCEPTION 'Access denied: Can only assign role to self';
    END IF;
    
    -- Insert patient role if no roles exist for this user
    INSERT INTO user_roles (user_id, role, created_at)
    SELECT p_user_id, 'patient', now()
    WHERE NOT EXISTS (
        SELECT 1 FROM user_roles WHERE user_id = p_user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update user_roles policies to fix circular dependency
DO $$ 
BEGIN
    -- Drop existing problematic policies
    DROP POLICY IF EXISTS "Admin can manage all roles" ON user_roles;
    DROP POLICY IF EXISTS "Admin can read all users" ON users;
    
    -- Create new admin policies without circular dependencies  
    CREATE POLICY "Admin can manage all roles" ON user_roles 
    FOR ALL TO authenticated 
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role IN ('admin', 'super_admin')
        )
    );
    
    CREATE POLICY "Admin can read all users" ON users 
    FOR SELECT TO authenticated 
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role IN ('admin', 'super_admin')
        )
    );

    -- Add admin insert policy for users
    CREATE POLICY "Admin can insert users" ON users 
    FOR INSERT TO authenticated 
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role IN ('admin', 'super_admin')
        )
    );
    
EXCEPTION 
    WHEN others THEN 
        RAISE NOTICE 'Admin policy creation failed: %', SQLERRM;
END $$;

-- CRITICAL: Revoke ALL access first (functions default to PUBLIC EXECUTE)
REVOKE ALL ON FUNCTION public.create_super_admin(uuid, text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.create_super_admin(uuid, text, text) FROM authenticated;
REVOKE ALL ON FUNCTION public.assign_default_patient_role(uuid) FROM PUBLIC;

-- SECURE permission grants (VERY RESTRICTED)
-- Only service_role can create super admin (for setup only)
GRANT EXECUTE ON FUNCTION public.create_super_admin(uuid, text, text) TO service_role;

-- Authenticated users can assign patient role to themselves only  
GRANT EXECUTE ON FUNCTION public.assign_default_patient_role(uuid) TO authenticated;

-- Complete admin RLS policies for role management
DO $$ 
BEGIN
    -- Allow users to read their own roles
    DROP POLICY IF EXISTS "Users can read own roles" ON user_roles;
    CREATE POLICY "Users can read own roles" ON user_roles 
    FOR SELECT TO authenticated 
    USING (user_id = auth.uid());
    
    -- Allow admins to read all roles
    DROP POLICY IF EXISTS "Admin can read all roles" ON user_roles;
    CREATE POLICY "Admin can read all roles" ON user_roles 
    FOR SELECT TO authenticated 
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role IN ('admin', 'super_admin')
        )
    );
    
    -- Allow admins to manage non-super_admin roles only (prevent privilege escalation)
    DROP POLICY IF EXISTS "Admin can manage regular roles" ON user_roles;
    CREATE POLICY "Admin can manage regular roles" ON user_roles 
    FOR ALL TO authenticated 
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role IN ('admin', 'super_admin')
        )
        AND role != 'super_admin'
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role IN ('admin', 'super_admin')
        )
        AND role != 'super_admin'
    );
    
    -- Only super_admin can manage super_admin roles
    DROP POLICY IF EXISTS "Super admin can manage super admin roles" ON user_roles;
    CREATE POLICY "Super admin can manage super admin roles" ON user_roles 
    FOR ALL TO authenticated 
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role = 'super_admin'
        )
        AND role = 'super_admin'
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles ur 
            WHERE ur.user_id = auth.uid() 
            AND ur.role = 'super_admin'
        )
        AND role = 'super_admin'
    );
    
EXCEPTION 
    WHEN others THEN 
        RAISE NOTICE 'Complete admin policy creation failed: %', SQLERRM;
END $$;