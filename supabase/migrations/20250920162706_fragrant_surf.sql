/*
  # Fix RLS Infinite Recursion Issue
  
  The user_roles table has a circular dependency in its RLS policies.
  This migration fixes the policies to prevent infinite recursion.
*/

-- Drop existing problematic policies
DROP POLICY IF EXISTS "Users can read own roles" ON user_roles;
DROP POLICY IF EXISTS "Admin can manage all roles" ON user_roles;

-- Create new policies that don't cause recursion
-- Allow users to read their own roles without checking roles table
CREATE POLICY "Users can read own roles" ON user_roles 
  FOR SELECT TO authenticated 
  USING (user_id = auth.uid());

-- Allow service role (backend) to manage all roles
CREATE POLICY "Service role can manage roles" ON user_roles 
  FOR ALL TO service_role 
  USING (true);

-- Allow authenticated users to insert their first role (patient)
CREATE POLICY "Users can insert patient role" ON user_roles 
  FOR INSERT TO authenticated 
  WITH CHECK (user_id = auth.uid() AND role = 'patient');

-- Create a separate policy for admin operations using a function
-- This function checks if a user is admin without causing recursion
CREATE OR REPLACE FUNCTION is_admin(user_uuid uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = user_uuid 
    AND role IN ('admin', 'super_admin')
  );
$$;

-- Now create admin policy using the function
CREATE POLICY "Admin can manage all roles" ON user_roles 
  FOR ALL TO authenticated 
  USING (is_admin(auth.uid()));

-- Also fix the users table policies to prevent similar issues
DROP POLICY IF EXISTS "Admin can read all users" ON users;

CREATE POLICY "Admin can read all users" ON users 
  FOR SELECT TO authenticated 
  USING (is_admin(auth.uid()));

-- Allow service role full access to users table
CREATE POLICY "Service role can manage users" ON users 
  FOR ALL TO service_role 
  USING (true);

-- Create a function to safely create the first super admin
CREATE OR REPLACE FUNCTION create_super_admin(
  admin_user_id uuid,
  admin_email text,
  admin_name text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Check if any super admin already exists
  IF EXISTS (SELECT 1 FROM user_roles WHERE role = 'super_admin') THEN
    RAISE EXCEPTION 'Super admin already exists';
  END IF;
  
  -- Insert or update user record
  INSERT INTO users (id, email, full_name, created_at, updated_at)
  VALUES (admin_user_id, admin_email, admin_name, now(), now())
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    full_name = EXCLUDED.full_name,
    updated_at = now();
  
  -- Insert super admin role
  INSERT INTO user_roles (user_id, role, created_at)
  VALUES (admin_user_id, 'super_admin', now());
END;
$$;

-- Grant execute permission on the function
GRANT EXECUTE ON FUNCTION create_super_admin TO authenticated;
GRANT EXECUTE ON FUNCTION is_admin TO authenticated;