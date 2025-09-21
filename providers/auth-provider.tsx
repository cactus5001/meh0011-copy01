'use client'

import React, { createContext, useContext, useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase/client'
import type { User } from '@supabase/supabase-js'
import { useRouter } from 'next/navigation'
import { toast } from 'sonner'

interface AuthUser extends User {
  user_roles?: Array<{ role: string }>
}

interface AuthContextType {
  user: AuthUser | null
  userRoles: string[]
  loading: boolean
  signIn: (email: string, password: string) => Promise<void>
  signUp: (email: string, password: string, fullName: string) => Promise<void>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null)
  const [userRoles, setUserRoles] = useState<string[]>([])
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user) {
        handleUserSession(session.user)
      } else {
        setLoading(false)
      }
    })

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        if (session?.user) {
          await handleUserSession(session.user)
        } else {
          setUser(null)
          setUserRoles([])
          setLoading(false)
        }
      }
    )

    return () => subscription.unsubscribe()
  }, [])

  const handleUserSession = async (authUser: User) => {
    try {
      let roles: string[] = []

      try {
        // Try to sync user to public.users table
        const { error: upsertError } = await supabase
          .from('users')
          .upsert({
            id: authUser.id,
            email: authUser.email!,
            full_name: authUser.user_metadata?.full_name || authUser.email?.split('@')[0] || '',
            updated_at: new Date().toISOString()
          })

        if (upsertError) {
          console.error('Error syncing user:', upsertError)
          // Continue anyway - user might still be able to use the app
        }

        // Try to get user roles
        const { data: rolesData, error: rolesError } = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', authUser.id)

        if (rolesError) {
          console.error('Error fetching roles:', rolesError)
          toast.error('Failed to load user roles. Please refresh the page.')
          // Only fallback to patient role for specific errors, not all errors
          if (('code' in rolesError && rolesError.code === 'PGRST116') || rolesError.message.includes('relation') || rolesError.message.includes('not found')) {
            // Database not properly set up - use patient role as fallback
            roles = ['patient']
          } else {
            // Authentication or permission error - don't auto-assign role
            throw new Error(`Role fetch failed: ${rolesError.message}`)
          }
        } else {
          const fetchedRoles = rolesData?.map((r: { role: string }) => r.role) || []
          
          // If no roles found, try to assign default patient role safely
          if (fetchedRoles.length === 0) {
            try {
              // Use the secure function to assign patient role
              const { error: roleError } = await supabase.rpc('assign_default_patient_role', {
                p_user_id: authUser.id
              })

              if (!roleError) {
                roles = ['patient']
              } else {
                console.error('Error assigning default role:', roleError)
                roles = ['patient'] // Fallback
              }
            } catch (error) {
              console.error('Error in role assignment:', error)
              roles = ['patient'] // Fallback
            }
          } else {
            roles = fetchedRoles
          }
        }
      } catch (dbError) {
        console.error('Database error:', dbError)
        roles = ['patient'] // Fallback to patient role
      }

      const userWithRoles = {
        ...authUser,
        user_roles: roles.map(role => ({ role }))
      }

      setUser(userWithRoles)
      setUserRoles(roles)

      // Role-based redirect
      // Prioritize admin roles for redirect
      let primaryRole = roles[0]
      if (roles.includes('super_admin')) {
        primaryRole = 'super_admin'
      } else if (roles.includes('admin')) {
        primaryRole = 'admin'
      } else if (roles.includes('moderator')) {
        primaryRole = 'moderator'
      }
      
      const dashboardRoutes = {
        patient: '/dashboard/patient',
        doctor: '/dashboard/doctor',
        clinic: '/dashboard/clinic',
        driver: '/dashboard/driver',
        admin: '/dashboard/admin',
        super_admin: '/dashboard/admin',
        moderator: '/dashboard/moderator'
      }

      const redirectPath = dashboardRoutes[primaryRole as keyof typeof dashboardRoutes] || '/dashboard/patient'
      
      if (window.location.pathname === '/' || window.location.pathname.startsWith('/auth/')) {
        router.push(redirectPath)
      }

    } catch (error) {
      console.error('Error handling user session:', error)
    } finally {
      setLoading(false)
    }
  }

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password
    })

    if (error) {
      throw error
    }
  }

  const signUp = async (email: string, password: string, fullName: string) => {
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName
        }
      }
    })

    if (error) {
      throw error
    }
  }

  const signOut = async () => {
    const { error } = await supabase.auth.signOut()
    if (error) {
      throw error
    }
    
    setUser(null)
    setUserRoles([])
    router.push('/')
  }

  return (
    <AuthContext.Provider value={{
      user,
      userRoles,
      loading,
      signIn,
      signUp,
      signOut
    }}>
      {children}
    </AuthContext.Provider>
  )
}