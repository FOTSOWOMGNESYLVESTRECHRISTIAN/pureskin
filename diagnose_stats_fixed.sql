-- Script pour diagnostiquer le problème de récupération des statistiques
-- Base de données: pureSkin (avec "S" majuscule)
-- Exécuter: psql -U postgres -d pureSkin -f diagnose_stats_fixed.sql

-- Étape 1: Vérifier la connexion à la base de données pureSkin
SELECT '=== CONNEXION À LA BASE pureSkin ===' as info;
SELECT current_database() as database_actuelle;

-- Étape 2: Vérifier si la table payments existe
SELECT '=== VÉRIFICATION TABLE payments ===' as info;
SELECT 
    table_name,
    table_schema
FROM information_schema.tables 
WHERE table_name = 'payments' 
AND table_schema = 'public';

-- Étape 3: Vérifier la structure de la table payments
SELECT '=== STRUCTURE TABLE payments ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'payments' 
ORDER BY ordinal_position;

-- Étape 4: Compter les enregistrements dans payments
SELECT '=== NOMBRE D''ENREGISTREMENTS payments ===' as info;
SELECT COUNT(*) as nombre_total_payments FROM payments;

-- Étape 5: Vérifier les données existantes
SELECT '=== DONNÉES EXISTANTES DANS payments ===' as info;
SELECT 
    id,
    order_id,
    customer_name,
    status,
    amount,
    currency,
    created_at,
    updated_at,
    processed_at
FROM payments 
ORDER BY created_at DESC 
LIMIT 10;

-- Étape 6: Vérifier les statuts disponibles
SELECT '=== STATUTS DISPONIBLES ===' as info;
SELECT 
    status,
    COUNT(*) as nombre,
    SUM(amount) as montant_total,
    AVG(amount) as montant_moyen
FROM payments 
GROUP BY status
ORDER BY COUNT(*) DESC;

-- Étape 7: Calculer manuellement les statistiques attendues
SELECT '=== STATISTIQUES CALCULÉES MANUELLEMENT ===' as info;
SELECT 
    'total_transactions' as type_statistique,
    COUNT(*) as valeur,
    'Nombre total de transactions' as description
FROM payments
UNION ALL
SELECT 
    'successful_transactions' as type_statistique,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as valeur,
    'Transactions réussies' as description
FROM payments
UNION ALL
SELECT 
    'failed_transactions' as type_statistique,
    COUNT(*) FILTER (WHERE status = 'FAILED') as valeur,
    'Transactions echouees' as description
FROM payments
UNION ALL
SELECT 
    'pending_transactions' as type_statistique,
    COUNT(*) FILTER (WHERE status = 'PENDING') as valeur,
    'Transactions en attente' as description
FROM payments
UNION ALL
SELECT 
    'total_revenue' as type_statistique,
    COALESCE(SUM(amount), 0) as valeur,
    'Revenu total (tous statuts)' as description
FROM payments
UNION ALL
SELECT 
    'successful_revenue' as type_statistique,
    COALESCE(SUM(amount) FILTER (WHERE status = 'SUCCESS'), 0) as valeur,
    'Revenu des transactions réussies' as description
FROM payments
UNION ALL
SELECT 
    'available_balance' as type_statistique,
    COALESCE(SUM(amount) FILTER (WHERE status = 'SUCCESS'), 0) as valeur,
    'Solde disponible (transactions réussies)' as description
FROM payments
UNION ALL
SELECT 
    'total_products_sold' as type_statistique,
    COALESCE(SUM(
        CASE 
            WHEN products IS NOT NULL 
                 AND products != 'null' 
                 AND products != '[]' 
                 AND products != '' 
            THEN 
                CASE 
                    WHEN products::jsonb IS NOT NULL THEN
                        (SELECT COALESCE(SUM((elem->>'quantity')::int), 0) 
                         FROM jsonb_array_elements(products::jsonb) as elem)
                    ELSE 0
                END
            ELSE 0
        END), 0) as valeur,
    'Total produits vendus' as description
FROM payments
UNION ALL
SELECT 
    'today_transactions' as type_statistique,
    COUNT(*) FILTER (WHERE DATE(created_at) = CURRENT_DATE) as valeur,
    'Transactions du jour' as description
FROM payments;

-- Étape 8: Tester la requête exacte utilisée par le backend
SELECT '=== TEST REQUÊTE BACKEND ===' as info;
SELECT 
    COUNT(p) as totalTransactions,
    COUNT(p) FILTER (WHERE p.status = 'SUCCESS') as successfulTransactions,
    COUNT(p) FILTER (WHERE p.status = 'FAILED') as failedTransactions,
    COUNT(p) FILTER (WHERE p.status = 'PENDING') as pendingTransactions,
    COALESCE(SUM(p.amount), 0) as totalRevenue,
    COALESCE(SUM(p.amount) FILTER (WHERE p.status = 'SUCCESS'), 0) as successfulRevenue
FROM payments p;

-- Étape 9: Vérifier si la requête fonctionne avec des alias
SELECT '=== TEST REQUÊTE AVEC ALIAS ===' as info;
SELECT 
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as success,
    COUNT(*) FILTER (WHERE status = 'FAILED') as failed,
    COUNT(*) FILTER (WHERE status = 'PENDING') as pending,
    COALESCE(SUM(amount), 0) as revenue,
    COALESCE(SUM(amount) FILTER (WHERE status = 'SUCCESS'), 0) as success_revenue
FROM payments;

-- Étape 10: Diagnostiquer les problèmes potentiels
SELECT '=== DIAGNOSTIC DES PROBLÈMES ===' as info;

-- Vérifier si les colonnes nécessaires existent
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'id') 
        THEN '✅ Colonne id existe'
        ELSE '❌ Colonne id manquante'
    END as id_column,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'status') 
        THEN '✅ Colonne status existe'
        ELSE '❌ Colonne status manquante'
    END as status_column,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'amount') 
        THEN '✅ Colonne amount existe'
        ELSE '❌ Colonne amount manquante'
    END as amount_column;

-- Vérifier les types de données
SELECT 
    column_name,
    data_type,
    CASE 
        WHEN data_type IN ('integer', 'bigint', 'decimal', 'numeric', 'real', 'double precision') 
        THEN '✅ Type numérique'
        ELSE '⚠️ Type non numérique (peut causer des erreurs SUM)'
    END as type_check
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name IN ('amount', 'id');

-- Étape 11: Insérer des données de test si nécessaire
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
            'PS-STATS-001',
            'Test User 1',
            'test1@example.com',
            '+237654181935',
            25000.00,
            'XAF',
            'wallet',
            'SUCCESS',
            'REF-001',
            '[{"id": 1, "name": "Test Product", "price": 25000, "quantity": 1}]',
            '{"street": "123 Test St", "city": "Test City"}',
            '{"street": "123 Test St", "city": "Test City"}',
            '{"source": "test"}',
            CURRENT_TIMESTAMP - INTERVAL '1 day',
            CURRENT_TIMESTAMP - INTERVAL '1 day'
        ),
        (
            'PS-STATS-002',
            'Test User 2',
            'test2@example.com',
            '+237698123456',
            12000.00,
            'XAF',
            'wallet',
            'PENDING',
            'REF-002',
            '[{"id": 2, "name": "Test Product 2", "price": 12000, "quantity": 1}]',
            '{"street": "456 Test Ave", "city": "Test City"}',
            '{"street": "456 Test Ave", "city": "Test City"}',
            '{"source": "test"}',
            CURRENT_TIMESTAMP - INTERVAL '2 hours',
            CURRENT_TIMESTAMP - INTERVAL '2 hours'
        );
        
        RAISE NOTICE '2 paiements de test insérés pour les statistiques';
    END IF;
END $$;

-- Étape 12: Résultats finaux
SELECT '=== RÉSULTATS FINAUX ===' as info;
SELECT 
    'Base de données' as config,
    current_database() as valeur,
    CASE 
        WHEN current_database() = 'pureSkin' THEN '✅ Correct'
        ELSE '❌ Incorrect - devrait être pureSkin'
    END as statut
UNION ALL
SELECT 
    'Table payments' as config,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN '✅ Existe'
        ELSE '❌ Manquante'
    END as valeur,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN '✅ OK'
        ELSE '❌ Créer la table'
    END as statut
UNION ALL
SELECT 
    'Données dans payments' as config,
    CAST(COUNT(*) AS TEXT) as valeur,
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Données présentes'
        ELSE '❌ Pas de données'
    END as statut
FROM payments;

SELECT '=== RECOMMANDATIONS ===' as info;
SELECT 
    '1. Vérifier la configuration de la base de données dans application.properties' as recommandation_1;
SELECT 
    '2. Assurer que le nom de la base est bien "pureSkin" avec S majuscule' as recommandation_2;
SELECT 
    '3. Vérifier que la table payments a les bonnes colonnes (id, status, amount)' as recommandation_3;
SELECT 
    '4. Tester la requête SQL directement dans la base' as recommandation_4;
SELECT 
    '5. Vérifier les logs du backend pour les erreurs SQL' as recommandation_5;
