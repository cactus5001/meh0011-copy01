'use client'

import { useState, useEffect } from 'react'
import { useAuth } from '@/providers/auth-provider'
import { supabase, isSupabaseConfigured } from '@/lib/supabase/client'
import { PageLoadingSpinner } from '@/components/loading-spinner'
import { Navbar } from '@/components/navbar'
import { BreadcrumbNav } from '@/components/breadcrumb-nav'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { ShoppingBag, Package, Clock, CheckCircle, XCircle, Truck } from 'lucide-react'

interface OrderItem {
  id: string
  order_id: string
  quantity: number
  price: number
  medicines?: {
    id: string
    name: string
    description?: string
    category?: string
  }
}

interface Order {
  id: string
  user_id: string
  total_amount: number
  status: 'pending' | 'processing' | 'completed' | 'cancelled'
  payment_method: string
  shipping_address: string
  created_at: string
  updated_at: string
  order_items?: OrderItem[]
  users?: {
    full_name?: string
    email: string
  }
}

export default function OrdersPage() {
  const { user, loading: authLoading } = useAuth()
  const [orders, setOrders] = useState<Order[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (user) {
      loadOrders()
    }
  }, [user])

  const loadOrders = () => {
    const loadOrdersAsync = async () => {
      if (!isSupabaseConfigured()) {
        console.warn('Supabase not configured. Please set up your environment variables.')
        setOrders([])
        setLoading(false)
        return
      }

      try {
        const { data, error } = await supabase
          .from('orders')
          .select(`
            *,
            order_items (
              *,
              medicines (
                id,
                name,
                description,
                category
              )
            )
          `)
          .eq('user_id', user!.id)
          .order('created_at', { ascending: false })

        if (error) {
          console.error('Error loading orders:', error)
          toast.error('Failed to load orders')
          setOrders([])
        } else {
          setOrders(data || [])
        }
      } catch (error) {
        console.error('Error loading orders:', error)
        toast.error('Failed to load orders')
        setOrders([])
      }
      setLoading(false)
    }

    loadOrdersAsync()
  }

  const getStatusIcon = (status: Order['status']) => {
    switch (status) {
      case 'pending': return <Clock className="h-4 w-4" />
      case 'processing': return <Truck className="h-4 w-4" />
      case 'completed': return <CheckCircle className="h-4 w-4" />
      case 'cancelled': return <XCircle className="h-4 w-4" />
      default: return <Package className="h-4 w-4" />
    }
  }

  const getStatusColor = (status: Order['status']) => {
    switch (status) {
      case 'pending': return 'bg-yellow-100 text-yellow-800'
      case 'processing': return 'bg-blue-100 text-blue-800'
      case 'completed': return 'bg-green-100 text-green-800'
      case 'cancelled': return 'bg-red-100 text-red-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  if (authLoading || loading) {
    return <PageLoadingSpinner />
  }

  if (!user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Access Denied</h1>
          <p className="text-muted-foreground">Please login to view your orders.</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-orange-50 to-white">
      <Navbar />
      
      <div className="container py-8">
        <BreadcrumbNav items={[
          { label: 'Order History' }
        ]} />

        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center space-x-3 mb-4">
            <div className="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center">
              <ShoppingBag className="h-6 w-6 text-orange-600" />
            </div>
            <div>
              <h1 className="text-3xl font-bold">Order History</h1>
              <p className="text-muted-foreground">Track your medicine orders and delivery status</p>
            </div>
          </div>
        </div>

        {/* Orders List */}
        <div className="space-y-6">
          {orders.map((order) => (
            <Card key={order.id} className="hover:shadow-lg transition-shadow">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="flex items-center space-x-2">
                      <span>Order #{order.id.toUpperCase()}</span>
                    </CardTitle>
                    <CardDescription>
                      Placed on {formatDate(order.created_at)}
                    </CardDescription>
                  </div>
                  <Badge className={`${getStatusColor(order.status)} flex items-center space-x-1`}>
                    {getStatusIcon(order.status)}
                    <span>{order.status.charAt(0).toUpperCase() + order.status.slice(1)}</span>
                  </Badge>
                </div>
              </CardHeader>
              
              <CardContent>
                <div className="space-y-4">
                  {/* Order Items */}
                  <div>
                    <h4 className="font-medium mb-3">Items Ordered</h4>
                    <div className="space-y-2">
                      {order.order_items?.map((item) => (
                        <div key={item.id} className="flex items-center justify-between p-3 bg-muted/50 rounded-lg">
                          <div className="flex items-center space-x-3">
                            <div className="w-12 h-12 bg-white rounded-lg flex items-center justify-center">
                              <Package className="h-6 w-6 text-muted-foreground" />
                            </div>
                            <div>
                              <h5 className="font-medium">{item.medicines?.name || 'Unknown Medicine'}</h5>
                              <p className="text-sm text-muted-foreground">
                                Quantity: {item.quantity} × ${item.price.toFixed(2)}
                              </p>
                            </div>
                          </div>
                          <div className="text-right">
                            <p className="font-medium">${(item.quantity * item.price).toFixed(2)}</p>
                          </div>
                        </div>
                      )) || []}
                    </div>
                  </div>

                  {/* Order Summary */}
                  <div className="border-t pt-4">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                      <div>
                        <h5 className="font-medium mb-2">Delivery Address</h5>
                        <p className="text-muted-foreground">{order.shipping_address}</p>
                      </div>
                      
                      <div>
                        <h5 className="font-medium mb-2">Payment Method</h5>
                        <p className="text-muted-foreground">{order.payment_method}</p>
                      </div>
                    </div>
                    
                    <div className="flex justify-between items-center mt-4 pt-4 border-t">
                      <span className="text-lg font-semibold">Total Amount</span>
                      <span className="text-lg font-bold text-green-600">
                        ${order.total_amount.toFixed(2)}
                      </span>
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className="flex space-x-2 pt-4">
                    {order.status === 'pending' && (
                      <Button variant="outline" size="sm">
                        Cancel Order
                      </Button>
                    )}
                    
                    {order.status === 'processing' && (
                      <Button variant="outline" size="sm">
                        Track Order
                      </Button>
                    )}
                    
                    {order.status === 'completed' && (
                      <Button variant="outline" size="sm">
                        Reorder Items
                      </Button>
                    )}
                    
                    <Button variant="outline" size="sm">
                      View Details
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {orders.length === 0 && (
          <div className="text-center py-12">
            <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
              <ShoppingBag className="h-8 w-8 text-muted-foreground" />
            </div>
            <h3 className="text-lg font-medium mb-2">No orders found</h3>
            <p className="text-muted-foreground mb-4">
              You haven't placed any orders yet.
            </p>
            <Button asChild>
              <a href="/pharmacy">Browse Pharmacy</a>
            </Button>
          </div>
        )}
      </div>
    </div>
  )
}