'use client'

import { useState } from 'react'
import { supabase, isSupabaseConfigured } from '@/lib/supabase/client'
import { AdminService } from '@/lib/supabase/admin'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Navbar } from '@/components/navbar'
import { Shield, CheckCircle, AlertTriangle, Database } from 'lucide-react'
import { toast } from 'sonner'
import { useRouter } from 'next/navigation'

export default function AdminSetupPage() {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    fullName: ''
  })
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const router = useRouter()

  // Check if Supabase is configured
  const supabaseConfigured = isSupabaseConfigured()

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!supabaseConfigured) {
      toast.error('Please configure Supabase environment variables first')
      return
    }

    if (!formData.email || !formData.password || !formData.fullName) {
      toast.error('Please fill in all fields')
      return
    }

    if (formData.password !== formData.confirmPassword) {
      toast.error('Passwords do not match')
      return
    }

    if (formData.password.length < 8) {
      toast.error('Password must be at least 8 characters')
      return
    }

    setLoading(true)
    try {
      // Use the AdminService to create super admin safely
      const result = await AdminService.createSuperAdmin(
        formData.email,
        formData.password,
        formData.fullName
      )
      
      setSuccess(true)
      toast.success('Super admin account created successfully!')
      
      // Redirect to login after 3 seconds
      setTimeout(() => {
        router.push('/auth/login')
      }, 3000)
    } catch (error: any) {
      console.error('Setup error:', error)
      if (error.message.includes('already exists')) {
        toast.error('Super admin already exists. Please login instead.')
        router.push('/auth/login')
      } else {
        toast.error(error.message || 'Failed to create admin account')
      }
    } finally {
      setLoading(false)
    }
  }

  if (!supabaseConfigured) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
        <Navbar />
        
        <div className="container py-16">
          <div className="max-w-md mx-auto">
            <Card className="border-red-200">
              <CardHeader className="text-center">
                <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Database className="h-8 w-8 text-red-600" />
                </div>
                <CardTitle className="text-2xl text-red-800">Database Not Configured</CardTitle>
                <CardDescription>
                  Please set up your Supabase database first
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4 text-sm">
                  <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <h4 className="font-medium text-yellow-800 mb-2">Setup Steps:</h4>
                    <ol className="list-decimal list-inside space-y-1 text-yellow-700">
                      <li>Create a Supabase project at <a href="https://supabase.com" target="_blank" className="underline">supabase.com</a></li>
                      <li>Copy your project URL and anon key</li>
                      <li>Update the .env.local file with your credentials</li>
                      <li>Run the database migration in Supabase SQL Editor</li>
                      <li>Restart the development server</li>
                    </ol>
                  </div>
                  
                  <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                    <h4 className="font-medium text-blue-800 mb-2">Environment Variables Needed:</h4>
                    <pre className="text-xs text-blue-700 bg-blue-100 p-2 rounded">
{`NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-key`}
                    </pre>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    )
  }

  if (success) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
        <Navbar />
        
        <div className="container py-16">
          <div className="max-w-md mx-auto">
            <Card className="border-green-200">
              <CardHeader className="text-center">
                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <CheckCircle className="h-8 w-8 text-green-600" />
                </div>
                <CardTitle className="text-2xl text-green-800">Setup Complete!</CardTitle>
                <CardDescription>
                  Super admin account has been created successfully.
                </CardDescription>
              </CardHeader>
              <CardContent className="text-center">
                <p className="text-sm text-muted-foreground mb-4">
                  You will be redirected to the login page in a few seconds.
                </p>
                <Button asChild>
                  <a href="/auth/login">Go to Login</a>
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      <Navbar />
      
      <div className="container py-16">
        <div className="max-w-md mx-auto">
          <Card>
            <CardHeader className="text-center">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Shield className="h-8 w-8 text-blue-600" />
              </div>
              <CardTitle className="text-2xl">Admin Setup</CardTitle>
              <CardDescription>
                Create the first super admin account for your healthcare platform
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="mb-6 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                <div className="flex items-start space-x-2">
                  <AlertTriangle className="h-5 w-5 text-yellow-600 mt-0.5" />
                  <div className="text-sm">
                    <p className="font-medium text-yellow-800">Important:</p>
                    <p className="text-yellow-700">
                      This page should only be accessed during initial setup. 
                      The super admin will have full system access.
                    </p>
                  </div>
                </div>
              </div>

              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="fullName">Full Name</Label>
                  <Input
                    id="fullName"
                    name="fullName"
                    type="text"
                    placeholder="Enter admin full name"
                    value={formData.fullName}
                    onChange={handleInputChange}
                    disabled={loading}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="email">Email</Label>
                  <Input
                    id="email"
                    name="email"
                    type="email"
                    placeholder="Enter admin email"
                    value={formData.email}
                    onChange={handleInputChange}
                    disabled={loading}
                    required
                  />
                </div>
                
                <div className="space-y-2">
                  <Label htmlFor="password">Password</Label>
                  <Input
                    id="password"
                    name="password"
                    type="password"
                    placeholder="Create a strong password (min. 8 characters)"
                    value={formData.password}
                    onChange={handleInputChange}
                    disabled={loading}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="confirmPassword">Confirm Password</Label>
                  <Input
                    id="confirmPassword"
                    name="confirmPassword"
                    type="password"
                    placeholder="Confirm your password"
                    value={formData.confirmPassword}
                    onChange={handleInputChange}
                    disabled={loading}
                    required
                  />
                </div>

                <Button type="submit" className="w-full" disabled={loading}>
                  {loading ? (
                    <>
                      <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                      Creating Admin Account...
                    </>
                  ) : (
                    <>
                      <Shield className="h-4 w-4 mr-2" />
                      Create Super Admin
                    </>
                  )}
                </Button>
              </form>

              <div className="mt-6 text-center text-sm text-muted-foreground">
                <p>After setup, you can create additional admin accounts from the admin dashboard.</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}