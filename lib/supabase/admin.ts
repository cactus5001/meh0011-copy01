import { supabase } from './client'

// Admin-specific database operations
export class AdminService {
  // Create initial super admin user
  static async createSuperAdmin(email: string, password: string, fullName: string) {
    try {
      // Create the user account
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            full_name: fullName
          }
        }
      })

      if (authError) throw authError
      if (!authData.user) throw new Error('Failed to create user')

      // Use the safe function to create super admin
      const { error: roleError } = await supabase.rpc('create_super_admin', {
        admin_user_id: authData.user.id,
        admin_email: email,
        admin_name: fullName
      })

      if (roleError) throw roleError

      return { success: true, user: authData.user }
    } catch (error) {
      console.error('Error creating super admin:', error)
      throw error
    }
  }

  // Get all users with their roles
  static async getAllUsers(page = 1, limit = 50) {
    try {
      const offset = (page - 1) * limit

      const { data, error, count } = await supabase
        .from('users')
        .select(`
          *,
          user_roles (
            role
          )
        `, { count: 'exact' })
        .range(offset, offset + limit - 1)
        .order('created_at', { ascending: false })

      if (error) throw error

      return {
        users: data || [],
        total: count || 0,
        page,
        totalPages: Math.ceil((count || 0) / limit)
      }
    } catch (error) {
      console.error('Error fetching users:', error)
      throw error
    }
  }

  // Assign role to user
  static async assignRole(userId: string, role: string) {
    try {
      const { error } = await supabase
        .from('user_roles')
        .upsert({
          user_id: userId,
          role: role
        })

      if (error) throw error
      return { success: true }
    } catch (error) {
      console.error('Error assigning role:', error)
      throw error
    }
  }

  // Remove role from user
  static async removeRole(userId: string, role: string) {
    try {
      const { error } = await supabase
        .from('user_roles')
        .delete()
        .eq('user_id', userId)
        .eq('role', role)

      if (error) throw error
      return { success: true }
    } catch (error) {
      console.error('Error removing role:', error)
      throw error
    }
  }

  // Get system statistics
  static async getSystemStats() {
    try {
      const [
        { count: totalUsers },
        { count: totalOrders },
        { count: totalAppointments },
        { count: totalEmergencyRequests }
      ] = await Promise.all([
        supabase.from('users').select('*', { count: 'exact', head: true }),
        supabase.from('orders').select('*', { count: 'exact', head: true }),
        supabase.from('appointments').select('*', { count: 'exact', head: true }),
        supabase.from('ambulance_requests').select('*', { count: 'exact', head: true })
      ])

      return {
        totalUsers: totalUsers || 0,
        totalOrders: totalOrders || 0,
        totalAppointments: totalAppointments || 0,
        totalEmergencyRequests: totalEmergencyRequests || 0
      }
    } catch (error) {
      console.error('Error fetching system stats:', error)
      return {
        totalUsers: 0,
        totalOrders: 0,
        totalAppointments: 0,
        totalEmergencyRequests: 0
      }
    }
  }

  // Get all orders for admin management
  static async getAllOrders(page = 1, limit = 50) {
    try {
      const offset = (page - 1) * limit

      const { data, error, count } = await supabase
        .from('orders')
        .select(`
          *,
          users (
            full_name,
            email
          ),
          order_items (
            *,
            medicines (
              name,
              price
            )
          )
        `, { count: 'exact' })
        .range(offset, offset + limit - 1)
        .order('created_at', { ascending: false })

      if (error) throw error

      return {
        orders: data || [],
        total: count || 0,
        page,
        totalPages: Math.ceil((count || 0) / limit)
      }
    } catch (error) {
      console.error('Error fetching orders:', error)
      throw error
    }
  }

  // Update order status
  static async updateOrderStatus(orderId: string, status: string) {
    try {
      const { error } = await supabase
        .from('orders')
        .update({ status })
        .eq('id', orderId)

      if (error) throw error
      return { success: true }
    } catch (error) {
      console.error('Error updating order status:', error)
      throw error
    }
  }
}