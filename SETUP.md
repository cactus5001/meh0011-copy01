# 🚀 Wanterio Setup Guide

Follow these steps to get your healthcare platform running with a real database.

## 📋 Prerequisites

- Node.js 18+ installed
- A Supabase account (free tier works)

## 🗄️ Database Setup

### Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `wanterio-healthcare`
   - **Database Password**: Choose a strong password
   - **Region**: Select closest to your location
5. Click "Create new project" and wait for setup to complete

### Step 2: Get Your Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy these values:
   - **Project URL** (looks like: `https://abcdefgh.supabase.co`)
   - **anon public key** (starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9`)
   - **service_role secret key** (starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9`)

### Step 3: Configure Environment Variables

1. In your project root, update `.env.local`:

```env
# Replace with your actual Supabase credentials
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here

NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development
```

### Step 4: Run Database Migration

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New query"
3. Copy the entire content from `supabase/migrations/20250920133442_soft_sun.sql`
4. Paste it in the SQL editor
5. Click **Run** to execute the migration
6. You should see "Success. No rows returned" message

### Step 4.1: Fix RLS Policies (Important!)

1. Still in **SQL Editor**, create another new query
2. Copy the entire content from `supabase/migrations/20250120000001_fix_rls_recursion.sql`
3. Paste it in the SQL editor
4. Click **Run** to execute the fix
5. This fixes the infinite recursion issue in user roles

### Step 5: Configure Authentication

1. In Supabase dashboard, go to **Authentication** → **Settings**
2. Under **Email Auth**:
   - ✅ Enable email confirmations: **OFF** (for development)
   - ✅ Enable email change confirmations: **OFF** (for development)
3. Under **Site URL**, add: `http://localhost:3000`
4. Under **Redirect URLs**, add: `http://localhost:3000/**`

## 🚀 Application Setup

### Step 1: Install Dependencies

```bash
npm install
```

### Step 2: Start Development Server

```bash
npm run dev
```

### Step 3: Create Super Admin Account

1. Open your browser to `http://localhost:3000`
2. You should see a "Database not configured" warning if env vars aren't set
3. Once configured, go to `http://localhost:3000/setup/admin`
4. Fill out the super admin registration form:
   - **Full Name**: Your name
   - **Email**: Your admin email
   - **Password**: Strong password (min 8 characters)
5. Click "Create Super Admin"

### Step 4: Login as Admin

1. After successful registration, go to `http://localhost:3000/auth/login`
2. Login with your admin credentials
3. You'll be redirected to the admin dashboard at `/dashboard/admin`

## ✅ Verification

Your setup is complete when you can:

- ✅ Login as super admin
- ✅ See real user data in admin dashboard
- ✅ Browse pharmacy with real medicines
- ✅ Create new user accounts
- ✅ Assign roles to users

## 🔧 Troubleshooting

### "Database not configured" error
- Check your `.env.local` file has correct Supabase credentials
- Restart the development server after updating env vars
- Verify credentials in Supabase dashboard

### "Super admin already exists" error
- This means setup was already completed
- Just login at `/auth/login` with existing admin credentials

### Authentication errors
- Check that email confirmations are disabled in Supabase
- Verify Site URL and Redirect URLs are set correctly
- Make sure database migration was run successfully

### Database connection errors
- Verify your Supabase project is active (not paused)
- Check that the anon key and service role key are correct
- Ensure the database migration completed without errors

## 🎯 Next Steps

Once setup is complete:

1. **Create test users** via the admin dashboard
2. **Assign different roles** (patient, doctor, clinic, driver)
3. **Test all features** with different user types
4. **Add more medicines** via the admin interface (coming in Phase 2)

## 📞 Need Help?

If you encounter issues:
1. Check the browser console for error messages
2. Verify all environment variables are set correctly
3. Ensure the database migration completed successfully
4. Check Supabase logs in the dashboard

---

**🎉 Congratulations!** Your healthcare platform is now running with a real database and admin system.