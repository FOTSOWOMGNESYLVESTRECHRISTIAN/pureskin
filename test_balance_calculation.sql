-- Script pour tester spécifiquement le calcul du solde disponible
-- Exécuter: psql -U postgres -d pureSkin -f test_balance_calculation.sql

-- Étape 1: Vérifier les paiements SUCCESS existants
SELECT '=== PAIEMENTS SUCCESS EXISTANTS ===' as info;
SELECT 
    id,
    order_id,
    customer_name,
    status,
    amount,
    created_at,
    processed_at
FROM payments 
WHERE status = 'SUCCESS'
ORDER BY created_at DESC;

-- Étape 2: Calculer le solde disponible manuellement
SELECT '=== CALCUL MANUEL DU SOLDE ===' as info;
SELECT 
    COUNT(*) as nombre_transactions_success,
    SUM(amount) as solde_disponible_calcule,
    AVG(amount) as montant_moyen,
    MIN(amount) as montant_minimum,
    MAX(amount) as montant_maximum
FROM payments 
WHERE status = 'SUCCESS';

-- Étape 3: Tester la requête exacte du backend pour le solde
SELECT '=== REQUÊTE BACKEND POUR SOLDE ===' as info;
SELECT 
    COALESCE(SUM(CASE WHEN p.status = 'SUCCESS' THEN p.amount ELSE 0 END), 0) as available_balance_backend
FROM payments p;

-- Étape 4: Tester la requête native alternative
SELECT '=== REQUÊTE NATIVE POUR SOLDE ===' as info;
SELECT 
    COALESCE(SUM(CASE WHEN status = 'SUCCESS' THEN amount ELSE 0 END), 0) as available_balance_native
FROM payments;

-- Étape 5: Vérifier les types de données du montant
SELECT '=== VÉRIFICATION TYPES DE DONNÉES ===' as info;
SELECT 
    column_name,
    data_type,
    numeric_precision,
    numeric_scale
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'amount';

-- Étape 6: Insérer des données de test spécifiques pour le solde si nécessaire
DO $$
BEGIN
    -- Vérifier s'il y a des paiements SUCCESS
    IF (SELECT COUNT(*) FROM payments WHERE status = 'SUCCESS') = 0 THEN
        -- Insérer un paiement SUCCESS de test
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
            updated_at,
            processed_at
        ) VALUES 
        (
            'PS-BALANCE-001',
            'Test Balance User',
            'balance@test.com',
            '+237654181935',
            50000.00,
            'XAF',
            'wallet',
            'SUCCESS',
            'REF-BALANCE-001',
            '[{"id": 1, "name": "Test Product", "price": 50000, "quantity": 1}]',
            '{"street": "123 Test St", "city": "Test City"}',
            '{"street": "123 Test St", "city": "Test City"}',
            '{"source": "test"}',
            CURRENT_TIMESTAMP - INTERVAL '1 hour',
            CURRENT_TIMESTAMP - INTERVAL '1 hour',
            CURRENT_TIMESTAMP - INTERVAL '1 hour'
        );
        
        RAISE NOTICE '1 paiement SUCCESS inséré pour tester le solde';
    END IF;
END $$;

-- Étape 7: Vérifier après insertion
SELECT '=== VÉRIFICATION APRÈS INSERTION ===' as info;
SELECT 
    COUNT(*) as total_payments,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as success_payments,
    COALESCE(SUM(CASE WHEN status = 'SUCCESS' THEN amount ELSE 0 END), 0) as solde_final
FROM payments;

-- Étape 8: Simuler différents scénarios de calcul
SELECT '=== SCÉNARIOS DE CALCUL ===' as info;

-- Scénario 1: Uniquement les paiements SUCCESS
SELECT 'Scénario 1: Uniquement SUCCESS' as scenario;
SELECT 
    COALESCE(SUM(amount), 0) as solde_scenario_1
FROM payments 
WHERE status = 'SUCCESS';

-- Scénario 2: Uniquement les paiements SUCCESS avec processed_at non null
SELECT 'Scénario 2: SUCCESS avec processed_at' as scenario;
SELECT 
    COALESCE(SUM(amount), 0) as solde_scenario_2
FROM payments 
WHERE status = 'SUCCESS' 
AND processed_at IS NOT NULL;

-- Scénario 3: Calcul comme dans le backend (successfulRevenue)
SELECT 'Scénario 3: Calcul backend (successfulRevenue)' as scenario;
SELECT 
    COALESCE(SUM(CASE WHEN status = 'SUCCESS' THEN amount ELSE 0 END), 0) as solde_scenario_3
FROM payments;

-- Étape 9: Vérifier la cohérence des résultats
SELECT '=== COHÉRENCE DES RÉSULTATS ===' as info;
SELECT 
    'Méthode 1 (SUM WHERE SUCCESS)' as methode,
    COALESCE(SUM(amount), 0) as resultat
FROM payments 
WHERE status = 'SUCCESS'
UNION ALL
SELECT 
    'Méthode 2 (CASE WHEN SUCCESS)' as methode,
    COALESCE(SUM(CASE WHEN status = 'SUCCESS' THEN amount ELSE 0 END), 0) as resultat
FROM payments
UNION ALL
SELECT 
    'Méthode 3 (successfulRevenue)' as methode,
    COALESCE(SUM(CASE WHEN status = 'SUCCESS' THEN amount ELSE 0 END), 0) as resultat
FROM payments;

-- Étape 10: Instructions pour déboguer
SELECT '=== INSTRUCTIONS DÉBOGAGE ===' as info;
SELECT '1. Vérifier les logs du backend pour les messages de calcul du solde' as instruction_1;
SELECT '2. Regarder dans la console du navigateur les logs détaillés' as instruction_2;
SELECT '3. Confirmer que availableBalance est bien un nombre' as instruction_3;
SELECT '4. Tester avec différents statuts de paiement' as instruction_4;
SELECT '5. Vérifier le formatage (toLocaleString) ne cause pas d''erreur' as instruction_5;

-- Étape 11: Test de formatage
SELECT '=== TEST FORMATAGE NOMBRE ===' as info;
SELECT 
    amount,
    CAST(amount AS TEXT) as text_value,
    '50,000 XAF' as formatted_example
FROM payments 
WHERE status = 'SUCCESS'
LIMIT 1;

SELECT '=== PRÊT POUR DÉBOGAGE ===' as info;
SELECT '✅ Script de test du solde disponible terminé' as status_1;
SELECT '✅ Exécuter ce script pour vérifier le calcul' as status_2;
SELECT '✅ Comparer les résultats avec l''interface admin' as status_3;
SELECT '✅ Les logs montreront les détails du calcul' as status_4;
