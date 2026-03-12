-- Script pour insérer des paiements de test dans la base de données
-- Exécuter ce script pour avoir des données à afficher dans la page admin transactions

-- Insérer des paiements de test
INSERT INTO payments (
    order_id, 
    customer_name, 
    customer_email, 
    customer_phone,
    amount, 
    currency, 
    payment_method, 
    status, 
    payment_reference,
    products,
    shipping_address,
    billing_address,
    metadata,
    created_at,
    updated_at
) VALUES 
-- Paiement réussi
(
    'PS-TEST-001',
    'Marie Dupont',
    'marie.dupont@email.com',
    '+237654181935',
    25000.00,
    'XAF',
    'faroty_wallet',
    'SUCCESS',
    'REF-001',
    '[{"id": 1, "name": "Sérum Hydratant PureSkin", "price": 15000, "quantity": 1}, {"id": 2, "name": "Gel Nettoyant Doux", "price": 10000, "quantity": 1}]',
    '{"street": "123 Rue des Jardins", "city": "Douala", "postalCode": "00237", "country": "Cameroun"}',
    '{"street": "123 Rue des Jardins", "city": "Douala", "postalCode": "00237", "country": "Cameroun"}',
    '{"source": "web", "device": "desktop"}',
    CURRENT_TIMESTAMP - INTERVAL '2 days',
    CURRENT_TIMESTAMP - INTERVAL '2 days'
),

-- Paiement en attente
(
    'PS-TEST-002',
    'Jean Martin',
    'jean.martin@email.com',
    '+237698123456',
    12000.00,
    'XAF',
    'faroty_wallet',
    'PENDING',
    'REF-002',
    '[{"id": 3, "name": "Crème Nuit Régénérante", "price": 12000, "quantity": 1}]',
    '{"street": "456 Avenue Principale", "city": "Yaoundé", "postalCode": "00237", "country": "Cameroun"}',
    '{"street": "456 Avenue Principale", "city": "Yaoundé", "postalCode": "00237", "country": "Cameroun"}',
    '{"source": "mobile", "device": "android"}',
    CURRENT_TIMESTAMP - INTERVAL '1 day',
    CURRENT_TIMESTAMP - INTERVAL '1 day'
),

-- Paiement échoué
(
    'PS-TEST-003',
    'Sophie Petit',
    'sophie.petit@email.com',
    '+237655789012',
    8000.00,
    'XAF',
    'faroty_wallet',
    'FAILED',
    'REF-003',
    '[{"id": 4, "name": "Gommage Douceur Exfoliant", "price": 8000, "quantity": 1}]',
    '{"street": "789 Boulevard Central", "city": "Bafoussam", "postalCode": "00237", "country": "Cameroun"}',
    '{"street": "789 Boulevard Central", "city": "Bafoussam", "postalCode": "00237", "country": "Cameroun"}',
    '{"source": "web", "device": "mobile"}',
    CURRENT_TIMESTAMP - INTERVAL '3 hours',
    CURRENT_TIMESTAMP - INTERVAL '3 hours'
),

-- Autre paiement réussi avec plusieurs produits
(
    'PS-TEST-004',
    'Laurent Bernard',
    'laurent.bernard@email.com',
    '+237677345678',
    35000.00,
    'XAF',
    'faroty_wallet',
    'SUCCESS',
    'REF-004',
    '[{"id": 5, "name": "Huile Corps Nourrissante", "price": 10000, "quantity": 2}, {"id": 6, "name": "Sérum Hydratant PureSkin", "price": 15000, "quantity": 1}]',
    '{"street": "321 Rue Commerce", "city": "Garoua", "postalCode": "00237", "country": "Cameroun"}',
    '{"street": "321 Rue Commerce", "city": "Garoua", "postalCode": "00237", "country": "Cameroun"}',
    '{"source": "web", "device": "desktop"}',
    CURRENT_TIMESTAMP - INTERVAL '4 hours',
    CURRENT_TIMESTAMP - INTERVAL '4 hours'
),

-- Paiement récent en attente
(
    'PS-TEST-005',
    'Camille Richard',
    'camille.richard@email.com',
    '+237688901234',
    18000.00,
    'XAF',
    'faroty_wallet',
    'PENDING',
    'REF-005',
    '[{"id": 7, "name": "Crème Nuit Régénérante", "price": 12000, "quantity": 1}, {"id": 8, "name": "Gel Nettoyant Doux", "price": 6000, "quantity": 1}]',
    '{"street": "654 Place Marché", "city": "Bamenda", "postalCode": "00237", "country": "Cameroun"}',
    '{"street": "654 Place Marché", "city": "Bamenda", "postalCode": "00237", "country": "Cameroun"}',
    '{"source": "mobile", "device": "ios"}',
    CURRENT_TIMESTAMP - INTERVAL '30 minutes',
    CURRENT_TIMESTAMP - INTERVAL '30 minutes'
);

-- Vérification des paiements insérés
SELECT '=== PAIEMENTS DE TEST INSÉRÉS ===' as info;

SELECT 
    id,
    order_id,
    customer_name,
    customer_email,
    amount,
    currency,
    status,
    payment_method,
    created_at
FROM payments 
WHERE order_id LIKE 'PS-TEST-%'
ORDER BY created_at DESC;

-- Statistiques des paiements de test
SELECT '=== STATISTIQUES DES PAIEMENTS DE TEST ===' as info;

SELECT 
    status,
    COUNT(*) as nombre,
    SUM(amount) as montant_total,
    AVG(amount) as montant_moyen
FROM payments 
WHERE order_id LIKE 'PS-TEST-%'
GROUP BY status
ORDER BY status;

-- Total des paiements de test
SELECT 
    COUNT(*) as total_paiements,
    SUM(amount) as montant_total,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as paiements_reussis,
    COUNT(*) FILTER (WHERE status = 'PENDING') as paiements_en_attente,
    COUNT(*) FILTER (WHERE status = 'FAILED') as paiements_echoues,
    SUM(amount) FILTER (WHERE status = 'SUCCESS') as montant_reussi
FROM payments 
WHERE order_id LIKE 'PS-TEST-%';
