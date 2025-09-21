@@ .. @@
 -- Allow service role full access to users table
 CREATE POLICY "Service role can manage users" ON users 
   FOR ALL TO service_role 
   USING (true);
 
+-- Allow authenticated users to insert their own data
+CREATE POLICY "Users can insert own data" ON users 
+  FOR INSERT TO authenticated 
+  WITH CHECK (auth.uid() = id);
+
 -- Create a function to safely create the first super admin
 CREATE OR REPLACE FUNCTION create_super_admin(