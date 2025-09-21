'use client'

import { useState, useEffect } from 'react'
import { useAuth } from '@/providers/auth-provider'
import { AdminService } from '@/lib/supabase/admin'
import { PageLoadingSpinner } from '@/components/loading-spinner'
import { Navbar } from '@/components/navbar'
import { BreadcrumbNav } from '@/components/breadcrumb-nav'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { 
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Users, Search, UserPlus, Shield, ChevronLeft, ChevronRight } from 'lucide-react'
import { toast } from 'sonner'

interface User {
  id: string
  email: string
  full_name?: string
  phone?: string
  created_at: string
  user_roles: Array<{ role: string }>
}

export default function AdminUsersPage() {
  const { user, userRoles, loading: authLoading } = useAuth()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const [totalPages, setTotalPages] = useState(1)
  const [selectedRole, setSelectedRole] = useState<string>('')

  useEffect(() => {
    if (user && (userRoles.includes('admin') || userRoles.includes('super_admin'))) {
      loadUsers()
    }
  }, [user, userRoles, currentPage])

  const loadUsers = async () => {
    try {
      setLoading(true)
      const result = await AdminService.getAllUsers(currentPage, 20)
      setUsers(result.users)
      setTotalPages(result.totalPages)
    } catch (error) {
      console.error('Error loading users:', error)
      toast.error('Failed to load users')
    } finally {
      setLoading(false)
    }
  }

  const handleRoleChange = async (userId: string, newRole: string) => {
    try {
      await AdminService.assignRole(userId, newRole)
      toast.success('Role assigned successfully')
      loadUsers() // Reload to show updated roles
    } catch (error) {
      console.error('Error assigning role:', error)
      toast.error('Failed to assign role')
    }
  }

  const handleRemoveRole = async (userId: string, role: string) => {
    try {
      await AdminService.removeRole(userId, role)
      toast.success('Role removed successfully')
      loadUsers() // Reload to show updated roles
    } catch (error) {
      console.error('Error removing role:', error)
      toast.error('Failed to remove role')
    }
  }

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.full_name?.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesRole = !selectedRole || user.user_roles.some(r => r.role === selectedRole)
    return matchesSearch && matchesRole
  })

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }

  const getRoleColor = (role: string) => {
    const colors = {
      'super_admin': 'bg-red-100 text-red-800',
      'admin': 'bg-purple-100 text-purple-800',
      'moderator': 'bg-orange-100 text-orange-800',
      'doctor': 'bg-blue-100 text-blue-800',
      'clinic': 'bg-green-100 text-green-800',
      'driver': 'bg-yellow-100 text-yellow-800',
      'patient': 'bg-gray-100 text-gray-800'
    }
    return colors[role as keyof typeof colors] || 'bg-gray-100 text-gray-800'
  }

  if (authLoading || loading) {
    return <PageLoadingSpinner />
  }

  if (!user || (!userRoles.includes('admin') && !userRoles.includes('super_admin'))) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Access Denied</h1>
          <p className="text-muted-foreground">You don't have permission to access this page.</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      <Navbar />
      
      <div className="container py-8">
        <BreadcrumbNav items={[
          { label: 'Admin Dashboard', href: '/dashboard/admin' },
          { label: 'User Management' }
        ]} />

        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                <Users className="h-6 w-6 text-blue-600" />
              </div>
              <div>
                <h1 className="text-3xl font-bold">User Management</h1>
                <p className="text-muted-foreground">Manage users and assign roles</p>
              </div>
            </div>
            
            <Button asChild>
              <a href="/setup/admin">
                <UserPlus className="h-4 w-4 mr-2" />
                Add Admin
              </a>
            </Button>
          </div>

          {/* Filters */}
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="relative flex-1 max-w-md">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search users by email or name..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10"
              />
            </div>
            
            <Select value={selectedRole} onValueChange={setSelectedRole}>
              <SelectTrigger className="w-48">
                <SelectValue placeholder="Filter by role" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="">All Roles</SelectItem>
                <SelectItem value="patient">Patient</SelectItem>
                <SelectItem value="doctor">Doctor</SelectItem>
                <SelectItem value="clinic">Clinic</SelectItem>
                <SelectItem value="driver">Driver</SelectItem>
                <SelectItem value="moderator">Moderator</SelectItem>
                <SelectItem value="admin">Admin</SelectItem>
                <SelectItem value="super_admin">Super Admin</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Users Table */}
        <Card>
          <CardHeader>
            <CardTitle>Users ({filteredUsers.length})</CardTitle>
            <CardDescription>
              Manage user accounts and role assignments
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>User</TableHead>
                    <TableHead>Email</TableHead>
                    <TableHead>Roles</TableHead>
                    <TableHead>Joined</TableHead>
                    <TableHead>Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredUsers.map((user) => (
                    <TableRow key={user.id}>
                      <TableCell>
                        <div>
                          <div className="font-medium">{user.full_name || 'No name'}</div>
                          <div className="text-sm text-muted-foreground">{user.phone || 'No phone'}</div>
                        </div>
                      </TableCell>
                      <TableCell>{user.email}</TableCell>
                      <TableCell>
                        <div className="flex flex-wrap gap-1">
                          {user.user_roles.map((roleObj, index) => (
                            <Badge 
                              key={index} 
                              className={`${getRoleColor(roleObj.role)} cursor-pointer`}
                              onClick={() => handleRemoveRole(user.id, roleObj.role)}
                              title="Click to remove role"
                            >
                              {roleObj.role.replace('_', ' ')}
                            </Badge>
                          ))}
                        </div>
                      </TableCell>
                      <TableCell>{formatDate(user.created_at)}</TableCell>
                      <TableCell>
                        <Select onValueChange={(role) => handleRoleChange(user.id, role)}>
                          <SelectTrigger className="w-32">
                            <SelectValue placeholder="Add role" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="patient">Patient</SelectItem>
                            <SelectItem value="doctor">Doctor</SelectItem>
                            <SelectItem value="clinic">Clinic</SelectItem>
                            <SelectItem value="driver">Driver</SelectItem>
                            <SelectItem value="moderator">Moderator</SelectItem>
                            {userRoles.includes('super_admin') && (
                              <SelectItem value="admin">Admin</SelectItem>
                            )}
                          </SelectContent>
                        </Select>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>

            {filteredUsers.length === 0 && !loading && (
              <div className="text-center py-8">
                <Users className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                <h3 className="text-lg font-medium mb-2">No users found</h3>
                <p className="text-muted-foreground">
                  {searchTerm || selectedRole ? 'Try adjusting your filters' : 'No users in the system yet'}
                </p>
              </div>
            )}

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between mt-6">
                <p className="text-sm text-muted-foreground">
                  Page {currentPage} of {totalPages}
                </p>
                <div className="flex space-x-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                    disabled={currentPage === 1}
                  >
                    <ChevronLeft className="h-4 w-4" />
                    Previous
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
                    disabled={currentPage === totalPages}
                  >
                    Next
                    <ChevronRight className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  )
}