-- Script rapide pour insérer des paiements de test
-- Exécuter: psql -U postgres -d pureskin -f quick_test_payments.sql

-- Vérifier d'abord si la table payments existe
SELECT '=== VÉRIFICATION TABLE PAYMENTS ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'payments' 
ORDER BY ordinal_position;

-- Compter les paiements existants
SELECT '=== PAIEMENTS ACTUELS ===' as info;
SELECT COUNT(*) as nombre_paiements FROM payments;

-- Insérer quelques paiements de test si la table est vide
DO $$
BEGIN
    IF (SELECT COUNT(*) FROM payments) = 0 THEN
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
        (
            'PS-DEMO-001',
            'Marie Dupont',
            'marie.dupont@email.com',
            '+237654181935',
            25000.00,
            'XAF',
            'faroty_wallet',
            'SUCCESS',
            'REF-001',
            '[{"id": 1, "name": "Sérum Hydratant", "price": 15000, "quantity": 1}, {"id": 2, "name": "Gel Nettoyant", "price": 10000, "quantity": 1}]',
            '{"street": "123 Rue des Jardins", "city": "Douala", "country": "Cameroun"}',
            '{"street": "123 Rue des Jardins", "city": "Douala", "country": "Cameroun"}',
            '{"source": "web"}',
            CURRENT_TIMESTAMP - INTERVAL '1 day',
            CURRENT_TIMESTAMP - INTERVAL '1 day'
        ),
        (
            'PS-DEMO-002',
            'Jean Martin',
            'jean.martin@email.com',
            '+237698123456',
            12000.00,
            'XAF',
            'faroty_wallet',
            'PENDING',
            'REF-002',
            '[{"id": 3, "name": "Crème Nuit", "price": 12000, "quantity": 1}]',
            '{"street": "456 Avenue Principale", "city": "Yaoundé", "country": "Cameroun"}',
            '{"street": "456 Avenue Principale", "city": "Yaoundé", "country": "Cameroun"}',
            '{"source": "mobile"}',
            CURRENT_TIMESTAMP - INTERVAL '2 hours',
            CURRENT_TIMESTAMP - INTERVAL '2 hours'
        ),
        (
            'PS-DEMO-003',
            'Sophie Petit',
            'sophie.petit@email.com',
            '+237655789012',
            8000.00,
            'XAF',
            'faroty_wallet',
            'FAILED',
            'REF-003',
            '[{"id": 4, "name": "Gommage", "price": 8000, "quantity": 1}]',
            '{"street": "789 Boulevard Central", "city": "Bafoussam", "country": "Cameroun"}',
            '{"street": "789 Boulevard Central", "city": "Bafoussam", "country": "Cameroun"}',
            '{"source": "web"}',
            CURRENT_TIMESTAMP - INTERVAL '30 minutes',
            CURRENT_TIMESTAMP - INTERVAL '30 minutes'
        );
        
        RAISE NOTICE '3 paiements de test insérés avec succès';
    ELSE
        RAISE NOTICE 'La table payments contient déjà des données';
    END IF;
END $$;

-- Vérifier les paiements insérés
SELECT '=== PAIEMENTS APRÈS INSERTION ===' as info;
SELECT 
    id,
    order_id,
    customer_name,
    customer_email,
    amount,
    currency,
    status,
    created_at
FROM payments 
ORDER BY created_at DESC;

-- Statistiques simples
SELECT '=== STATISTIQUES SIMPLES ===' as info;
SELECT 
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as succes,
    COUNT(*) FILTER (WHERE status = 'PENDING') as en_attente,
    COUNT(*) FILTER (WHERE status = 'FAILED') as echoue,
    SUM(amount) as montant_total
FROM payments;
