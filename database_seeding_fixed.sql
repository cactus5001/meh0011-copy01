/*
==============================================================================
                    WANTERIO HEALTHCARE PLATFORM - FIXED DATABASE SEEDING
==============================================================================

CRITICAL FIX: This script only works with manually created auth accounts
and respects foreign key constraints to auth.users.

INSTRUCTIONS:
1. FIRST: Manually create ALL required accounts in Supabase Auth Dashboard
2. THEN: Run this SQL script in Supabase SQL Editor
3. Verify all accounts work by logging in

==============================================================================
*/

-- ============================================================================
-- STEP 1: MEDICINES SEEDING (Using safe insertion method)
-- ============================================================================

-- Use INSERT WHERE NOT EXISTS to avoid conflicts
INSERT INTO medicines (name, description, price, stock_quantity, category, image_url)
SELECT * FROM (VALUES 
-- Pain Relief & Anti-inflammatory
('Paracetamol 500mg', 'Effective pain relief and fever reducer. Safe for adults and children over 12 years.', 12.50, 150, 'Pain Relief', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400'),
('Ibuprofen 400mg', 'Anti-inflammatory pain relief for muscle and joint pain. Reduces swelling and inflammation.', 15.30, 120, 'Pain Relief', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400'),
('Aspirin 325mg', 'Pain reliever and blood thinner. Consult doctor for regular use. Low-dose for heart protection.', 9.99, 200, 'Pain Relief', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400'),
('Acetaminophen 650mg', 'Extra strength pain relief for severe headaches and body aches. Fast-acting formula.', 18.75, 80, 'Pain Relief', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400'),
('Naproxen 220mg', 'Long-lasting pain relief for arthritis and muscle pain. 12-hour protection.', 22.50, 90, 'Pain Relief', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400'),

-- Antibiotics
('Amoxicillin 250mg', 'Broad-spectrum antibiotic for bacterial infections. Prescription required from licensed doctor.', 25.00, 60, 'Antibiotics', 'https://images.unsplash.com/photo-1584017191902-c0c04ce8c64e?w=400'),
('Azithromycin 500mg', 'Powerful antibiotic for respiratory infections. 5-day treatment course.', 35.00, 45, 'Antibiotics', 'https://images.unsplash.com/photo-1584017191902-c0c04ce8c64e?w=400'),
('Ciprofloxacin 500mg', 'Fluoroquinolone antibiotic for urinary tract infections. Take with plenty of water.', 28.50, 40, 'Antibiotics', 'https://images.unsplash.com/photo-1584017191902-c0c04ce8c64e?w=400'),

-- Allergy & Antihistamines
('Cetirizine 10mg', 'Non-drowsy antihistamine for allergies and hay fever relief. 24-hour protection.', 8.75, 180, 'Allergy', 'https://images.unsplash.com/photo-1585435557343-3b092031e3a6?w=400'),
('Loratadine 10mg', 'Non-drowsy antihistamine for seasonal allergies. Once daily dosing.', 11.25, 160, 'Allergy', 'https://images.unsplash.com/photo-1585435557343-3b092031e3a6?w=400'),
('Diphenhydramine 25mg', 'Fast-acting allergy relief. May cause drowsiness. Good for nighttime allergies.', 7.50, 100, 'Allergy', 'https://images.unsplash.com/photo-1585435557343-3b092031e3a6?w=400'),
('Fexofenadine 180mg', 'Extra strength non-drowsy allergy relief. For severe seasonal allergies.', 16.99, 85, 'Allergy', 'https://images.unsplash.com/photo-1585435557343-3b092031e3a6?w=400'),

-- Vitamins & Supplements
('Vitamin C 1000mg', 'High-strength immune system support with bioflavonoids. Boosts natural defenses.', 18.90, 250, 'Vitamins', 'https://images.unsplash.com/photo-1556909047-f2c4d8b3c91f?w=400'),
('Vitamin D3 2000 IU', 'Essential for bone health and immune function. Supports calcium absorption.', 21.50, 200, 'Vitamins', 'https://images.unsplash.com/photo-1556909047-f2c4d8b3c91f?w=400'),
('Multivitamin Complex', 'Complete daily nutrition with 23 essential vitamins and minerals.', 32.75, 150, 'Vitamins', 'https://images.unsplash.com/photo-1556909047-f2c4d8b3c91f?w=400'),
('Omega-3 Fish Oil', 'Heart-healthy essential fatty acids. Supports brain and cardiovascular health.', 28.99, 120, 'Vitamins', 'https://images.unsplash.com/photo-1556909047-f2c4d8b3c91f?w=400'),
('Calcium Carbonate 600mg', 'Supports strong bones and teeth. Enhanced with Vitamin D for better absorption.', 15.75, 180, 'Vitamins', 'https://images.unsplash.com/photo-1556909047-f2c4d8b3c91f?w=400'),
('Iron Sulfate 325mg', 'Essential for healthy blood and energy production. Prevents iron deficiency anemia.', 12.25, 95, 'Vitamins', 'https://images.unsplash.com/photo-1556909047-f2c4d8b3c91f?w=400'),

-- Digestive Health
('Omeprazole 20mg', 'Proton pump inhibitor for acid reflux and heartburn. Long-lasting stomach protection.', 22.50, 75, 'Digestive', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),
('Ranitidine 150mg', 'H2 blocker for stomach acid reduction. Fast relief from heartburn and indigestion.', 14.75, 110, 'Digestive', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),
('Simethicone 125mg', 'Anti-gas medication for bloating and gas pain. Fast-acting digestive comfort.', 9.50, 140, 'Digestive', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),
('Loperamide 2mg', 'Anti-diarrheal medication for acute diarrhea control. Restores normal bowel function.', 11.99, 85, 'Digestive', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),

-- Cold & Flu
('Pseudoephedrine 30mg', 'Decongestant for nasal and sinus congestion. Provides long-lasting relief.', 13.25, 90, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),
('Dextromethorphan 15mg', 'Cough suppressant for dry, non-productive coughs. Safe for adults and children over 12.', 10.50, 125, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),
('Guaifenesin 400mg', 'Expectorant to loosen chest congestion. Helps clear mucus from airways.', 8.99, 100, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),

-- Topical & Skin Care
('Hydrocortisone 1% Cream', 'Anti-inflammatory cream for eczema, rashes, and skin irritation. Fast relief.', 12.99, 80, 'Topical', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400'),
('Bacitracin Ointment', 'Antibiotic ointment for minor cuts and wounds. Prevents bacterial infection.', 8.50, 120, 'Topical', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400'),

-- Sleep & Relaxation
('Melatonin 3mg', 'Natural sleep aid for insomnia and jet lag. Non-habit forming sleep support.', 14.25, 130, 'Sleep', 'https://images.unsplash.com/photo-1441906363162-903afd0d3d52?w=400'),

-- First Aid
('Adhesive Bandages', 'Sterile bandages for minor cuts and scrapes. Variety pack with different sizes.', 5.99, 200, 'First Aid', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400'),
('Antiseptic Wipes', 'Alcohol-free antiseptic wipes for wound cleaning. Gentle yet effective.', 4.50, 180, 'First Aid', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400'),
('Thermometer Digital', 'Fast and accurate digital thermometer. 60-second fever detection.', 18.99, 50, 'First Aid', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400')
) AS new_medicines(name, description, price, stock_quantity, category, image_url)
WHERE NOT EXISTS (
    SELECT 1 FROM medicines WHERE medicines.name = new_medicines.name
);

-- ============================================================================
-- STEP 2: SYNC TEST ACCOUNTS TO USERS TABLE
-- ============================================================================

-- Only sync accounts that exist in auth.users (manually created)
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT 
    au.id,
    au.email,
    CASE 
        WHEN au.email = 'patient@test.com' THEN 'Test Patient'
        WHEN au.email = 'doctor@test.com' THEN 'Dr. Test Doctor'
        WHEN au.email = 'clinic@test.com' THEN 'Test Medical Clinic'
        WHEN au.email = 'driver@test.com' THEN 'Test Ambulance Driver'
        WHEN au.email = 'moderator@test.com' THEN 'Test Moderator'
        WHEN au.email = 'admin@test.com' THEN 'Test Admin'
        WHEN au.email LIKE 'admin@%' THEN 'System Administrator'
        ELSE COALESCE(au.raw_user_meta_data->>'full_name', split_part(au.email, '@', 1))
    END as full_name,
    CASE 
        WHEN au.email = 'patient@test.com' THEN '+1-555-0101'
        WHEN au.email = 'doctor@test.com' THEN '+1-555-0102'
        WHEN au.email = 'clinic@test.com' THEN '+1-555-0103'
        WHEN au.email = 'driver@test.com' THEN '+1-555-0104'
        WHEN au.email = 'moderator@test.com' THEN '+1-555-0105'
        WHEN au.email = 'admin@test.com' THEN '+1-555-0106'
        ELSE NULL
    END as phone,
    now() as created_at,
    now() as updated_at
FROM auth.users au
WHERE au.email IN (
    'patient@test.com',
    'doctor@test.com', 
    'clinic@test.com',
    'driver@test.com',
    'moderator@test.com',
    'admin@test.com'
) OR au.email LIKE 'admin@%'
ON CONFLICT (email) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    phone = EXCLUDED.phone,
    updated_at = now();

-- ============================================================================
-- STEP 3: ASSIGN USER ROLES
-- ============================================================================

-- Assign roles based on email patterns
INSERT INTO user_roles (user_id, role, created_at)
SELECT 
    u.id,
    CASE 
        WHEN u.email = 'patient@test.com' THEN 'patient'
        WHEN u.email = 'doctor@test.com' THEN 'doctor'
        WHEN u.email = 'clinic@test.com' THEN 'clinic'
        WHEN u.email = 'driver@test.com' THEN 'driver'
        WHEN u.email = 'moderator@test.com' THEN 'moderator'
        WHEN u.email = 'admin@test.com' THEN 'admin'
        WHEN u.email LIKE 'admin@%' THEN 'super_admin'
    END as role,
    now() as created_at
FROM users u
WHERE u.email IN (
    'patient@test.com',
    'doctor@test.com', 
    'clinic@test.com',
    'driver@test.com',
    'moderator@test.com',
    'admin@test.com'
) OR u.email LIKE 'admin@%'
ON CONFLICT (user_id, role) DO NOTHING;

-- Also assign admin role to super admin
INSERT INTO user_roles (user_id, role, created_at)
SELECT u.id, 'admin', now()
FROM users u
WHERE u.email LIKE 'admin@%'
ON CONFLICT (user_id, role) DO NOTHING;

-- ============================================================================
-- STEP 4: CREATE TEST DOCTOR PROFILE
-- ============================================================================

INSERT INTO doctors (user_id, specialization, experience_years, consultation_fee, bio, availability_hours, created_at, updated_at)
SELECT 
    u.id,
    'General Practice',
    8,
    120.00,
    'General practitioner providing comprehensive primary care services for patients of all ages. Focus on preventive medicine and chronic disease management.',
    'Monday-Friday 9:00 AM - 5:00 PM',
    now(),
    now()
FROM users u
WHERE u.email = 'doctor@test.com'
ON CONFLICT (user_id) DO NOTHING;

-- ============================================================================
-- STEP 5: CREATE TEST CLINIC PROFILE
-- ============================================================================

INSERT INTO clinics (user_id, name, address, phone, services, opening_hours, created_at, updated_at)
SELECT 
    u.id,
    'Test Medical Clinic',
    '999 Test Street, Test District, Test City, TC 99999',
    '+1-555-0103',
    'General Medicine, Basic Emergency Care, Laboratory Services, Consultations',
    'Monday-Friday 9:00 AM - 5:00 PM',
    now(),
    now()
FROM users u
WHERE u.email = 'clinic@test.com'
ON CONFLICT (user_id) DO NOTHING;

-- ============================================================================
-- STEP 6: CREATE SAMPLE APPOINTMENTS
-- ============================================================================

-- Create some sample appointments between test accounts
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, notes, created_at)
SELECT 
    patient.id as patient_id,
    doctor.id as doctor_id,
    (CURRENT_DATE + INTERVAL '1 day')::date as appointment_date,
    '10:00' as appointment_time,
    'confirmed' as status,
    'Regular checkup appointment' as notes,
    now() as created_at
FROM users patient, users doctor
WHERE patient.email = 'patient@test.com' 
  AND doctor.email = 'doctor@test.com'
ON CONFLICT DO NOTHING;

INSERT INTO appointments (patient_id, clinic_id, appointment_date, appointment_time, status, notes, created_at)
SELECT 
    patient.id as patient_id,
    clinic.id as clinic_id,
    (CURRENT_DATE + INTERVAL '3 days')::date as appointment_date,
    '14:30' as appointment_time,
    'pending' as status,
    'Blood test and consultation' as notes,
    now() as created_at
FROM users patient, users clinic
WHERE patient.email = 'patient@test.com' 
  AND clinic.email = 'clinic@test.com'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 7: CREATE SAMPLE ORDERS
-- ============================================================================

-- Create a sample order for the test patient
INSERT INTO orders (user_id, total_amount, status, payment_method, shipping_address, created_at, updated_at)
SELECT 
    u.id,
    45.75,
    'completed',
    'cash_on_delivery',
    '123 Patient Street, Patient City, PC 12345',
    now() - INTERVAL '2 days',
    now() - INTERVAL '2 days'
FROM users u
WHERE u.email = 'patient@test.com'
LIMIT 1;

-- Add order items to the sample order
INSERT INTO order_items (order_id, medicine_id, quantity, price, created_at)
SELECT 
    o.id,
    m.id,
    2,
    m.price,
    now() - INTERVAL '2 days'
FROM orders o
CROSS JOIN medicines m
JOIN users u ON o.user_id = u.id
WHERE u.email = 'patient@test.com'
  AND m.name = 'Paracetamol 500mg'
LIMIT 1;

INSERT INTO order_items (order_id, medicine_id, quantity, price, created_at)
SELECT 
    o.id,
    m.id,
    1,
    m.price,
    now() - INTERVAL '2 days'
FROM orders o
CROSS JOIN medicines m
JOIN users u ON o.user_id = u.id
WHERE u.email = 'patient@test.com'
  AND m.name = 'Vitamin C 1000mg'
LIMIT 1;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Check what was created
SELECT 'Users created' as table_name, count(*) as count FROM users;
SELECT 'User roles assigned' as table_name, count(*) as count FROM user_roles;
SELECT 'Medicines available' as table_name, count(*) as count FROM medicines;
SELECT 'Doctors created' as table_name, count(*) as count FROM doctors;
SELECT 'Clinics created' as table_name, count(*) as count FROM clinics;
SELECT 'Appointments created' as table_name, count(*) as count FROM appointments;
SELECT 'Orders created' as table_name, count(*) as count FROM orders;

/*
==============================================================================
                              SEEDING COMPLETED!
==============================================================================

✅ 30+ realistic medicines seeded safely
✅ Test accounts synced from auth.users
✅ User roles assigned correctly
✅ Doctor and clinic profiles created
✅ Sample appointments and orders created

NEXT STEPS:
1. Test login with: patient@test.com / Test123!
2. Verify pharmacy shows real medicines
3. Check doctor and clinic profiles
4. Test admin login: admin@test.com / Test123!

If you see foreign key errors, ensure you manually created ALL required 
accounts in Supabase Auth Dashboard first!

==============================================================================
*/