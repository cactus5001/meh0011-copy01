'use client'

import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Navbar } from '@/components/navbar'
import { Shield } from 'lucide-react'

export default function AdminSetupPage() {
  // SECURITY: Public admin creation is disabled for security reasons
  // Admin accounts must be manually seeded in the database
  return (
    <div className="min-h-screen bg-gradient-to-b from-red-50 to-white">
      <Navbar />
      
      <div className="container py-16">
        <div className="max-w-md mx-auto">
          <Card className="border-red-200">
            <CardHeader className="text-center">
              <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Shield className="h-8 w-8 text-red-600" />
              </div>
              <CardTitle className="text-2xl text-red-800">Admin Creation Disabled</CardTitle>
              <CardDescription>
                For security reasons, admin accounts must be manually created
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4 text-sm">
                <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
                  <h4 className="font-medium text-red-800 mb-2">Security Notice:</h4>
                  <p className="text-red-700">
                    Public admin creation has been disabled to prevent unauthorized access. 
                    Admin accounts are now pre-configured for security.
                  </p>
                </div>
                
                <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                  <h4 className="font-medium text-blue-800 mb-2">How to Access Admin Panel:</h4>
                  <ol className="list-decimal list-inside space-y-1 text-blue-700">
                    <li>Use the pre-configured admin credentials</li>
                    <li>Login at <a href="/auth/login" className="underline">/auth/login</a></li>
                    <li>Access admin dashboard after successful login</li>
                  </ol>
                </div>
                
                <div className="text-center pt-4">
                  <Button asChild>
                    <a href="/auth/login">Go to Login</a>
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}