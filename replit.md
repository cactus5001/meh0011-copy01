# Wanterio Healthcare Platform - Replit Setup

## Project Overview
Wanterio is a comprehensive healthcare super-app built with Next.js 13+ and Supabase. It provides a complete platform connecting patients with doctors, pharmacies, clinics, emergency services, and more.

## Tech Stack
- **Frontend**: Next.js 13+ with App Router, TypeScript, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Auth, Real-time)  
- **UI Components**: shadcn/ui, Radix UI
- **Icons**: Lucide React
- **Authentication**: Supabase Auth with Row Level Security

## Replit Configuration

### Environment Setup
- Port: 5000 (configured in package.json scripts)
- Host: 0.0.0.0 (allows Replit proxy access)
- Environment file: `.env.local` with Supabase credentials

### Key Files Modified for Replit
- `next.config.js`: Removed static export mode, configured for dev server
- `package.json`: Updated scripts to bind to 0.0.0.0:5000
- `.env.local`: Added Supabase configuration

### Workflow Configuration
- **Name**: Frontend
- **Command**: `npm run dev`
- **Port**: 5000
- **Type**: webview

### Deployment Configuration
- **Target**: autoscale (stateless web app)
- **Build**: `npm run build`
- **Run**: `npm start`

## Recent Changes (September 21, 2025)
- Fixed Next.js configuration for Replit environment
- Configured proper port binding (0.0.0.0:5000)
- Set up Supabase environment variables
- Installed all dependencies
- Configured deployment for production

## Project Architecture
- `/app`: Next.js App Router pages (auth, dashboard, various services)
- `/components`: Reusable UI components including shadcn/ui
- `/lib`: Utility functions and Supabase client configuration
- `/providers`: React context providers for auth
- `/supabase`: Database migrations and schema
- `/types`: TypeScript type definitions

## Key Features
- Role-based dashboards (Patient, Doctor, Clinic, Driver, Admin, Moderator)
- Online pharmacy with shopping cart
- Doctor appointment booking
- Medical clinic services
- Emergency ambulance services
- Secure messaging system
- Real-time updates via Supabase

## Current Status
✅ Application successfully running on port 5000
✅ Supabase integration configured
✅ No LSP errors
✅ Fast Refresh working
✅ Deployment configured for production
✅ All dependencies installed

## Notes
- Supabase warnings about realtime-js are normal and don't affect functionality
- The app includes a configuration check and will show setup instructions if database credentials are missing
- Database migrations available in `/supabase/migrations/` folder