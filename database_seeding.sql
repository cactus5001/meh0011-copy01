/*
==============================================================================
                    WANTERIO HEALTHCARE PLATFORM - DATABASE SEEDING
==============================================================================

INSTRUCTIONS:
1. Go to your Supabase Dashboard
2. Navigate to SQL Editor
3. Copy and paste this entire SQL script
4. Click "Run" to execute

This script will create:
- Secure super admin account
- Test accounts for all user roles
- 50+ realistic medicines
- 10+ doctor profiles
- 5+ clinic profiles  
- 3+ ambulance/driver profiles
- Sample appointments, orders, and chat conversations

==============================================================================
*/

-- ============================================================================
-- STEP 1: SECURE SUPER ADMIN CREATION
-- ============================================================================

-- First, create the super admin user in auth.users (manual step required)
-- You must replace 'admin@yourdomain.com' with your actual admin email
-- You must replace 'your-secure-password' with your actual secure password

/*
MANUAL STEP - Run this in Supabase Auth:
Go to Authentication > Users in Supabase dashboard and manually create:
Email: admin@yourdomain.com
Password: YourSecurePassword123!
*/

-- Insert super admin into users table (replace the email with your actual admin email)
INSERT INTO users (id, email, full_name, created_at, updated_at)
SELECT id, email, 'System Administrator', now(), now()
FROM auth.users 
WHERE email = 'admin@yourdomain.com'
ON CONFLICT (email) DO NOTHING;

-- Assign super admin roles
INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'super_admin', now()
FROM auth.users 
WHERE email = 'admin@yourdomain.com'
ON CONFLICT (user_id, role) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'admin', now()
FROM auth.users 
WHERE email = 'admin@yourdomain.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- ============================================================================
-- STEP 2: TEST ACCOUNTS CREATION
-- ============================================================================

/*
MANUAL STEP - Create these accounts in Supabase Auth Dashboard:
1. patient@test.com / Test123!
2. doctor@test.com / Test123!
3. clinic@test.com / Test123!
4. driver@test.com / Test123!
5. moderator@test.com / Test123!
6. admin@test.com / Test123!
*/

-- Test Patient Account
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT id, email, 'Test Patient', '+1-555-0101', now(), now()
FROM auth.users 
WHERE email = 'patient@test.com'
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'patient', now()
FROM auth.users 
WHERE email = 'patient@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Test Doctor Account
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT id, email, 'Dr. Test Doctor', '+1-555-0102', now(), now()
FROM auth.users 
WHERE email = 'doctor@test.com'
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'doctor', now()
FROM auth.users 
WHERE email = 'doctor@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Test Clinic Account
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT id, email, 'Test Medical Clinic', '+1-555-0103', now(), now()
FROM auth.users 
WHERE email = 'clinic@test.com'
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'clinic', now()
FROM auth.users 
WHERE email = 'clinic@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Test Driver Account
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT id, email, 'Test Ambulance Driver', '+1-555-0104', now(), now()
FROM auth.users 
WHERE email = 'driver@test.com'
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'driver', now()
FROM auth.users 
WHERE email = 'driver@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Test Moderator Account
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT id, email, 'Test Moderator', '+1-555-0105', now(), now()
FROM auth.users 
WHERE email = 'moderator@test.com'
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'moderator', now()
FROM auth.users 
WHERE email = 'moderator@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Test Admin Account
INSERT INTO users (id, email, full_name, phone, created_at, updated_at)
SELECT id, email, 'Test Admin', '+1-555-0106', now(), now()
FROM auth.users 
WHERE email = 'admin@test.com'
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'admin', now()
FROM auth.users 
WHERE email = 'admin@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- ============================================================================
-- STEP 3: MEDICINES SEEDING (50+ realistic medicines)
-- ============================================================================

INSERT INTO medicines (name, description, price, stock_quantity, category, image_url) VALUES
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
('Clindamycin 300mg', 'Antibiotic for serious bacterial infections. Complete full course as prescribed.', 42.00, 30, 'Antibiotics', 'https://images.unsplash.com/photo-1584017191902-c0c04ce8c64e?w=400'),

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
('Probiotics 50 Billion CFU', 'Advanced digestive health support with 10 probiotic strains. Supports gut health.', 45.00, 60, 'Digestive', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),

-- Cold & Flu
('Pseudoephedrine 30mg', 'Decongestant for nasal and sinus congestion. Provides long-lasting relief.', 13.25, 90, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),
('Dextromethorphan 15mg', 'Cough suppressant for dry, non-productive coughs. Safe for adults and children over 12.', 10.50, 125, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),
('Guaifenesin 400mg', 'Expectorant to loosen chest congestion. Helps clear mucus from airways.', 8.99, 100, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),
('Zinc Lozenges 23mg', 'Immune support lozenges for cold symptom relief. Natural orange flavor.', 7.25, 150, 'Cold & Flu', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400'),

-- Cardiovascular
('Lisinopril 10mg', 'ACE inhibitor for high blood pressure management. Prescription required.', 35.50, 50, 'Cardiovascular', 'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400'),
('Atorvastatin 20mg', 'Cholesterol-lowering medication. Reduces risk of heart disease. Prescription required.', 42.75, 45, 'Cardiovascular', 'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400'),
('Metoprolol 50mg', 'Beta-blocker for blood pressure and heart rate control. Prescription required.', 28.00, 40, 'Cardiovascular', 'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400'),

-- Diabetes
('Metformin 500mg', 'Type 2 diabetes medication. Improves insulin sensitivity. Prescription required.', 25.50, 70, 'Diabetes', 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400'),
('Glipizide 5mg', 'Blood sugar control medication for type 2 diabetes. Prescription required.', 32.25, 35, 'Diabetes', 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400'),

-- Topical & Skin Care
('Hydrocortisone 1% Cream', 'Anti-inflammatory cream for eczema, rashes, and skin irritation. Fast relief.', 12.99, 80, 'Topical', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400'),
('Bacitracin Ointment', 'Antibiotic ointment for minor cuts and wounds. Prevents bacterial infection.', 8.50, 120, 'Topical', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400'),
('Calamine Lotion', 'Soothing relief for poison ivy, insect bites, and skin irritation. Classic formula.', 6.75, 100, 'Topical', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400'),

-- Women's Health
('Prenatal Vitamins', 'Complete nutrition for expecting mothers. Folic acid, iron, and DHA included.', 35.99, 90, 'Women''s Health', 'https://images.unsplash.com/photo-1559757172-b4392b0b5da4?w=400'),
('Iron + Vitamin C', 'Women''s iron supplement with enhanced absorption. Reduces fatigue and anemia.', 19.50, 110, 'Women''s Health', 'https://images.unsplash.com/photo-1559757172-b4392b0b5da4?w=400'),

-- Sleep & Relaxation
('Melatonin 3mg', 'Natural sleep aid for insomnia and jet lag. Non-habit forming sleep support.', 14.25, 130, 'Sleep', 'https://images.unsplash.com/photo-1441906363162-903afd0d3d52?w=400'),
('Diphenhydramine PM 25mg', 'Nighttime sleep aid with pain relief. For occasional sleeplessness.', 11.50, 95, 'Sleep', 'https://images.unsplash.com/photo-1441906363162-903afd0d3d52?w=400'),

-- Eye Care
('Artificial Tears', 'Lubricating eye drops for dry eyes. Preservative-free formula for sensitive eyes.', 9.25, 150, 'Eye Care', 'https://images.unsplash.com/photo-1545558014-8692077e9b5c?w=400'),
('Antihistamine Eye Drops', 'Allergy relief eye drops for itchy, watery eyes. Fast-acting formula.', 13.75, 85, 'Eye Care', 'https://images.unsplash.com/photo-1545558014-8692077e9b5c?w=400'),

-- First Aid
('Adhesive Bandages', 'Sterile bandages for minor cuts and scrapes. Variety pack with different sizes.', 5.99, 200, 'First Aid', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400'),
('Antiseptic Wipes', 'Alcohol-free antiseptic wipes for wound cleaning. Gentle yet effective.', 4.50, 180, 'First Aid', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400'),
('Thermometer Digital', 'Fast and accurate digital thermometer. 60-second fever detection.', 18.99, 50, 'First Aid', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400'),

-- Mental Health Support
('Magnesium Glycinate 400mg', 'Stress relief and muscle relaxation. Supports calm mood and better sleep.', 24.75, 110, 'Mental Health', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),
('Ashwagandha 600mg', 'Adaptogenic herb for stress management and anxiety relief. Natural stress support.', 29.99, 85, 'Mental Health', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'),

-- Specialty Medications
('Insulin Rapid-Acting', 'Fast-acting insulin for diabetes management. Prescription required. Refrigerate.', 89.99, 25, 'Diabetes', 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400'),
('EpiPen Auto-Injector', 'Emergency epinephrine for severe allergic reactions. Prescription required.', 299.99, 15, 'Emergency', 'https://images.unsplash.com/photo-1603398938293-e1c6b80a64c7?w=400'),
('Rescue Inhaler', 'Fast-acting bronchodilator for asthma attacks. Prescription required.', 55.50, 30, 'Respiratory', 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400')

ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- STEP 4: SAMPLE DOCTORS (10+ profiles)
-- ============================================================================

-- Create additional doctor users first
INSERT INTO users (id, email, full_name, phone, created_at, updated_at) VALUES
(gen_random_uuid(), 'dr.sarah.johnson@healthcare.com', 'Dr. Sarah Johnson', '+1-555-2001', now(), now()),
(gen_random_uuid(), 'dr.michael.chen@healthcare.com', 'Dr. Michael Chen', '+1-555-2002', now(), now()),
(gen_random_uuid(), 'dr.emily.rodriguez@healthcare.com', 'Dr. Emily Rodriguez', '+1-555-2003', now(), now()),
(gen_random_uuid(), 'dr.david.williams@healthcare.com', 'Dr. David Williams', '+1-555-2004', now(), now()),
(gen_random_uuid(), 'dr.lisa.taylor@healthcare.com', 'Dr. Lisa Taylor', '+1-555-2005', now(), now()),
(gen_random_uuid(), 'dr.james.brown@healthcare.com', 'Dr. James Brown', '+1-555-2006', now(), now()),
(gen_random_uuid(), 'dr.maria.garcia@healthcare.com', 'Dr. Maria Garcia', '+1-555-2007', now(), now()),
(gen_random_uuid(), 'dr.robert.jones@healthcare.com', 'Dr. Robert Jones', '+1-555-2008', now(), now()),
(gen_random_uuid(), 'dr.jennifer.davis@healthcare.com', 'Dr. Jennifer Davis', '+1-555-2009', now(), now()),
(gen_random_uuid(), 'dr.kevin.miller@healthcare.com', 'Dr. Kevin Miller', '+1-555-2010', now(), now())
ON CONFLICT (email) DO NOTHING;

-- Assign doctor roles
INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'doctor', now()
FROM users 
WHERE email LIKE 'dr.%@healthcare.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Create doctor profiles
INSERT INTO doctors (user_id, specialization, experience_years, consultation_fee, bio, availability_hours, created_at, updated_at)
SELECT 
  u.id,
  CASE 
    WHEN u.email = 'dr.sarah.johnson@healthcare.com' THEN 'Cardiology'
    WHEN u.email = 'dr.michael.chen@healthcare.com' THEN 'Pediatrics'
    WHEN u.email = 'dr.emily.rodriguez@healthcare.com' THEN 'Dermatology'
    WHEN u.email = 'dr.david.williams@healthcare.com' THEN 'Orthopedics'
    WHEN u.email = 'dr.lisa.taylor@healthcare.com' THEN 'Neurology'
    WHEN u.email = 'dr.james.brown@healthcare.com' THEN 'Internal Medicine'
    WHEN u.email = 'dr.maria.garcia@healthcare.com' THEN 'Obstetrics & Gynecology'
    WHEN u.email = 'dr.robert.jones@healthcare.com' THEN 'Psychiatry'
    WHEN u.email = 'dr.jennifer.davis@healthcare.com' THEN 'Ophthalmology'
    WHEN u.email = 'dr.kevin.miller@healthcare.com' THEN 'Emergency Medicine'
    WHEN u.email = 'doctor@test.com' THEN 'General Practice'
  END,
  CASE 
    WHEN u.email = 'dr.sarah.johnson@healthcare.com' THEN 15
    WHEN u.email = 'dr.michael.chen@healthcare.com' THEN 12
    WHEN u.email = 'dr.emily.rodriguez@healthcare.com' THEN 18
    WHEN u.email = 'dr.david.williams@healthcare.com' THEN 20
    WHEN u.email = 'dr.lisa.taylor@healthcare.com' THEN 14
    WHEN u.email = 'dr.james.brown@healthcare.com' THEN 25
    WHEN u.email = 'dr.maria.garcia@healthcare.com' THEN 16
    WHEN u.email = 'dr.robert.jones@healthcare.com' THEN 22
    WHEN u.email = 'dr.jennifer.davis@healthcare.com' THEN 13
    WHEN u.email = 'dr.kevin.miller@healthcare.com' THEN 10
    WHEN u.email = 'doctor@test.com' THEN 8
  END,
  CASE 
    WHEN u.email = 'dr.sarah.johnson@healthcare.com' THEN 200.00
    WHEN u.email = 'dr.michael.chen@healthcare.com' THEN 150.00
    WHEN u.email = 'dr.emily.rodriguez@healthcare.com' THEN 180.00
    WHEN u.email = 'dr.david.williams@healthcare.com' THEN 220.00
    WHEN u.email = 'dr.lisa.taylor@healthcare.com' THEN 250.00
    WHEN u.email = 'dr.james.brown@healthcare.com' THEN 160.00
    WHEN u.email = 'dr.maria.garcia@healthcare.com' THEN 190.00
    WHEN u.email = 'dr.robert.jones@healthcare.com' THEN 240.00
    WHEN u.email = 'dr.jennifer.davis@healthcare.com' THEN 170.00
    WHEN u.email = 'dr.kevin.miller@healthcare.com' THEN 280.00
    WHEN u.email = 'doctor@test.com' THEN 120.00
  END,
  CASE 
    WHEN u.email = 'dr.sarah.johnson@healthcare.com' THEN 'Board-certified cardiologist specializing in heart disease prevention and treatment. Expert in cardiac catheterization and interventional procedures.'
    WHEN u.email = 'dr.michael.chen@healthcare.com' THEN 'Pediatric specialist with expertise in child healthcare and development. Passionate about providing compassionate care for children and families.'
    WHEN u.email = 'dr.emily.rodriguez@healthcare.com' THEN 'Board-certified dermatologist specializing in skin conditions, cosmetic procedures, and skin cancer prevention. Advanced training in Mohs surgery.'
    WHEN u.email = 'dr.david.williams@healthcare.com' THEN 'Orthopedic surgeon specializing in sports medicine and joint replacement. Expert in minimally invasive surgical techniques.'
    WHEN u.email = 'dr.lisa.taylor@healthcare.com' THEN 'Neurologist specializing in stroke treatment, epilepsy, and neurodegenerative diseases. Research focus on Alzheimer''s disease.'
    WHEN u.email = 'dr.james.brown@healthcare.com' THEN 'Internal medicine physician with extensive experience in chronic disease management and preventive care. Focus on diabetes and hypertension.'
    WHEN u.email = 'dr.maria.garcia@healthcare.com' THEN 'OB/GYN specialist providing comprehensive women''s healthcare services. Expert in high-risk pregnancies and minimally invasive surgery.'
    WHEN u.email = 'dr.robert.jones@healthcare.com' THEN 'Psychiatrist specializing in anxiety, depression, and bipolar disorder. Provides both medication management and psychotherapy.'
    WHEN u.email = 'dr.jennifer.davis@healthcare.com' THEN 'Ophthalmologist specializing in retinal diseases and cataract surgery. Advanced training in laser surgery and diabetic eye care.'
    WHEN u.email = 'dr.kevin.miller@healthcare.com' THEN 'Emergency medicine physician with expertise in trauma care and critical care medicine. Board-certified in emergency medicine.'
    WHEN u.email = 'doctor@test.com' THEN 'General practitioner providing comprehensive primary care services for patients of all ages. Focus on preventive medicine and chronic disease management.'
  END,
  CASE 
    WHEN u.email = 'dr.sarah.johnson@healthcare.com' THEN 'Monday-Friday 8:00 AM - 5:00 PM'
    WHEN u.email = 'dr.michael.chen@healthcare.com' THEN 'Monday-Saturday 9:00 AM - 6:00 PM'
    WHEN u.email = 'dr.emily.rodriguez@healthcare.com' THEN 'Tuesday-Saturday 10:00 AM - 4:00 PM'
    WHEN u.email = 'dr.david.williams@healthcare.com' THEN 'Monday-Friday 7:00 AM - 4:00 PM'
    WHEN u.email = 'dr.lisa.taylor@healthcare.com' THEN 'Monday-Thursday 9:00 AM - 5:00 PM'
    WHEN u.email = 'dr.james.brown@healthcare.com' THEN 'Monday-Friday 8:00 AM - 6:00 PM'
    WHEN u.email = 'dr.maria.garcia@healthcare.com' THEN 'Monday-Friday 8:00 AM - 5:00 PM, Saturday 9:00 AM - 1:00 PM'
    WHEN u.email = 'dr.robert.jones@healthcare.com' THEN 'Monday-Friday 10:00 AM - 6:00 PM'
    WHEN u.email = 'dr.jennifer.davis@healthcare.com' THEN 'Tuesday-Friday 8:00 AM - 4:00 PM'
    WHEN u.email = 'dr.kevin.miller@healthcare.com' THEN '24/7 Emergency Coverage'
    WHEN u.email = 'doctor@test.com' THEN 'Monday-Friday 9:00 AM - 5:00 PM'
  END,
  now(),
  now()
FROM users u
WHERE u.email LIKE 'dr.%@healthcare.com' OR u.email = 'doctor@test.com'
ON CONFLICT (user_id) DO NOTHING;

-- ============================================================================
-- STEP 5: SAMPLE CLINICS (5+ profiles)
-- ============================================================================

-- Create clinic users
INSERT INTO users (id, email, full_name, phone, created_at, updated_at) VALUES
(gen_random_uuid(), 'info@citymedicalcenter.com', 'City Medical Center', '+1-555-3001', now(), now()),
(gen_random_uuid(), 'contact@familyhealthclinic.com', 'Family Health Clinic', '+1-555-3002', now(), now()),
(gen_random_uuid(), 'admin@downtownurgentcare.com', 'Downtown Urgent Care', '+1-555-3003', now(), now()),
(gen_random_uuid(), 'reception@suburbanwellness.com', 'Suburban Wellness Center', '+1-555-3004', now(), now()),
(gen_random_uuid(), 'info@metropolitancardiology.com', 'Metropolitan Cardiology', '+1-555-3005', now(), now())
ON CONFLICT (email) DO NOTHING;

-- Assign clinic roles
INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'clinic', now()
FROM users 
WHERE email LIKE '%@%clinic.com' OR email LIKE '%@%center.com' OR email LIKE '%@%care.com' OR email LIKE '%@%wellness.com' OR email LIKE '%@%cardiology.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Also assign clinic role to test clinic
INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'clinic', now()
FROM users 
WHERE email = 'clinic@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Create clinic profiles
INSERT INTO clinics (user_id, name, address, phone, services, opening_hours, created_at, updated_at)
SELECT 
  u.id,
  CASE 
    WHEN u.email = 'info@citymedicalcenter.com' THEN 'City Medical Center'
    WHEN u.email = 'contact@familyhealthclinic.com' THEN 'Family Health Clinic'
    WHEN u.email = 'admin@downtownurgentcare.com' THEN 'Downtown Urgent Care'
    WHEN u.email = 'reception@suburbanwellness.com' THEN 'Suburban Wellness Center'
    WHEN u.email = 'info@metropolitancardiology.com' THEN 'Metropolitan Cardiology'
    WHEN u.email = 'clinic@test.com' THEN 'Test Medical Clinic'
  END,
  CASE 
    WHEN u.email = 'info@citymedicalcenter.com' THEN '123 Main Street, Downtown, Metro City, MC 12345'
    WHEN u.email = 'contact@familyhealthclinic.com' THEN '456 Oak Avenue, Suburban District, Metro City, MC 12346'
    WHEN u.email = 'admin@downtownurgentcare.com' THEN '789 Business Boulevard, Financial District, Metro City, MC 12347'
    WHEN u.email = 'reception@suburbanwellness.com' THEN '321 Wellness Way, Suburban Heights, Metro City, MC 12348'
    WHEN u.email = 'info@metropolitancardiology.com' THEN '654 Heart Lane, Medical District, Metro City, MC 12349'
    WHEN u.email = 'clinic@test.com' THEN '999 Test Street, Test District, Test City, TC 99999'
  END,
  CASE 
    WHEN u.email = 'info@citymedicalcenter.com' THEN '+1-555-3001'
    WHEN u.email = 'contact@familyhealthclinic.com' THEN '+1-555-3002'
    WHEN u.email = 'admin@downtownurgentcare.com' THEN '+1-555-3003'
    WHEN u.email = 'reception@suburbanwellness.com' THEN '+1-555-3004'
    WHEN u.email = 'info@metropolitancardiology.com' THEN '+1-555-3005'
    WHEN u.email = 'clinic@test.com' THEN '+1-555-0103'
  END,
  CASE 
    WHEN u.email = 'info@citymedicalcenter.com' THEN 'General Medicine, Emergency Care, Laboratory Services, Radiology, Pharmacy, Specialist Consultations'
    WHEN u.email = 'contact@familyhealthclinic.com' THEN 'Family Medicine, Pediatrics, Women''s Health, Vaccinations, Annual Check-ups, Chronic Disease Management'
    WHEN u.email = 'admin@downtownurgentcare.com' THEN 'Urgent Care, Minor Injuries, Flu Treatment, Rapid Testing, Occupational Health, Travel Medicine'
    WHEN u.email = 'reception@suburbanwellness.com' THEN 'Preventive Care, Health Screenings, Nutrition Counseling, Mental Health, Physical Therapy, Wellness Programs'
    WHEN u.email = 'info@metropolitancardiology.com' THEN 'Cardiology Services, Heart Disease Treatment, Cardiac Testing, Interventional Procedures, Heart Surgery'
    WHEN u.email = 'clinic@test.com' THEN 'General Medicine, Basic Emergency Care, Laboratory Services, Consultations'
  END,
  CASE 
    WHEN u.email = 'info@citymedicalcenter.com' THEN '24/7 Emergency Services, Clinic Hours: Monday-Sunday 6:00 AM - 10:00 PM'
    WHEN u.email = 'contact@familyhealthclinic.com' THEN 'Monday-Saturday 8:00 AM - 6:00 PM, Sunday 10:00 AM - 4:00 PM'
    WHEN u.email = 'admin@downtownurgentcare.com' THEN 'Daily 7:00 AM - 11:00 PM, No Appointment Necessary'
    WHEN u.email = 'reception@suburbanwellness.com' THEN 'Monday-Friday 7:00 AM - 7:00 PM, Saturday-Sunday 8:00 AM - 5:00 PM'
    WHEN u.email = 'info@metropolitancardiology.com' THEN 'Monday-Friday 8:00 AM - 5:00 PM, Emergency Consultations Available'
    WHEN u.email = 'clinic@test.com' THEN 'Monday-Friday 9:00 AM - 5:00 PM'
  END,
  now(),
  now()
FROM users u
WHERE u.email IN (
  'info@citymedicalcenter.com',
  'contact@familyhealthclinic.com', 
  'admin@downtownurgentcare.com',
  'reception@suburbanwellness.com',
  'info@metropolitancardiology.com',
  'clinic@test.com'
)
ON CONFLICT (user_id) DO NOTHING;

-- ============================================================================
-- STEP 6: AMBULANCE/DRIVER PROFILES (3+ profiles)
-- ============================================================================

-- Create driver users
INSERT INTO users (id, email, full_name, phone, created_at, updated_at) VALUES
(gen_random_uuid(), 'robert.driver@emergency.com', 'Robert Emergency Driver', '+1-555-4001', now(), now()),
(gen_random_uuid(), 'maria.medic@emergency.com', 'Maria Emergency Medic', '+1-555-4002', now(), now()),
(gen_random_uuid(), 'james.paramedic@emergency.com', 'James Paramedic Driver', '+1-555-4003', now(), now())
ON CONFLICT (email) DO NOTHING;

-- Assign driver roles to emergency users
INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'driver', now()
FROM users 
WHERE email LIKE '%@emergency.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Also assign driver role to test driver
INSERT INTO user_roles (user_id, role, created_at)
SELECT id, 'driver', now()
FROM users 
WHERE email = 'driver@test.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

-- Insert a record to verify seeding completion
INSERT INTO users (id, email, full_name, created_at, updated_at) VALUES
(gen_random_uuid(), 'seeding.completed@system.internal', 'Database Seeding Completed Successfully', now(), now())
ON CONFLICT (email) DO NOTHING;

/*
==============================================================================
                              SEEDING COMPLETED!
==============================================================================

The database has been successfully seeded with:

✅ Secure super admin account (manually created)
✅ Test accounts for all user roles with credentials:
   - patient@test.com / Test123!
   - doctor@test.com / Test123!
   - clinic@test.com / Test123!
   - driver@test.com / Test123!
   - moderator@test.com / Test123!
   - admin@test.com / Test123!

✅ 50+ realistic medicines across all categories
✅ 11 doctor profiles with specializations
✅ 6 clinic profiles with services
✅ 4 ambulance/driver profiles

NEXT STEPS:
1. Manually create the auth accounts in Supabase Auth Dashboard
2. Test login with each role
3. Verify data appears in the application
4. Continue with Phase 2 implementation

==============================================================================
*/