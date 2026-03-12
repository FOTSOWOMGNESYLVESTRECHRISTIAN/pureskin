-- Script pour tester la mise à jour du statut des paiements
-- Exécuter: psql -U postgres -d pureskin -f test_status_update.sql

-- Vérifier les paiements existants
SELECT '=== PAIEMENTS EXISTANTS ===' as info;
SELECT 
    id,
    order_id,
    customer_name,
    status,
    created_at,
    updated_at
FROM payments 
ORDER BY created_at DESC;

-- Tester la mise à jour via SQL direct
SELECT '=== TEST MISE À JOUR STATUT ===' as info;

UPDATE payments 
SET 
    status = 'SUCCESS',
    updated_at = CURRENT_TIMESTAMP,
    processed_at = CURRENT_TIMESTAMP
WHERE order_id = 'PS-DEMO-001' AND status != 'SUCCESS';

UPDATE payments 
SET 
    status = 'PENDING',
    updated_at = CURRENT_TIMESTAMP,
    processed_at = NULL
WHERE order_id = 'PS-DEMO-002' AND status != 'PENDING';

UPDATE payments 
SET 
    status = 'FAILED',
    updated_at = CURRENT_TIMESTAMP,
    processed_at = CURRENT_TIMESTAMP
WHERE order_id = 'PS-DEMO-003' AND status != 'FAILED';

-- Vérifier les mises à jour
SELECT '=== PAIEMENTS APRÈS MISE À JOUR ===' as info;
SELECT 
    id,
    order_id,
    customer_name,
    status,
    processed_at,
    updated_at,
    CASE 
        WHEN processed_at IS NOT NULL THEN 'Traité'
        ELSE 'Non traité'
    END as etat
FROM payments 
WHERE order_id LIKE 'PS-DEMO-%'
ORDER BY created_at DESC;

-- Statistiques après mise à jour
SELECT '=== STATISTIQUES FINALES ===' as info;
SELECT 
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as succes,
    COUNT(*) FILTER (WHERE status = 'PENDING') as en_attente,
    COUNT(*) FILTER (WHERE status = 'FAILED') as echoue,
    COUNT(*) FILTER (WHERE processed_at IS NOT NULL) as traites,
    SUM(amount) as montant_total,
    SUM(amount) FILTER (WHERE status = 'SUCCESS') as montant_reussi
FROM payments 
WHERE order_id LIKE 'PS-DEMO-%';

-- Pour tester l'API via curl, vous pouvez utiliser:
/*
curl -X PUT http://localhost:8080/api/payments/PS-DEMO-001/status \
  -H "Content-Type: application/json" \
  -d '{
    "status": "SUCCESS",
    "farotyTransactionId": "REF-001"
  }'

curl -X PUT http://localhost:8080/api/payments/PS-DEMO-002/status \
  -H "Content-Type: application/json" \
  -d '{
    "status": "PENDING",
    "farotyTransactionId": "REF-002"
  }'
*/

SELECT '=== INSTRUCTIONS TEST API ===' as info;
SELECT 'Utilisez les commandes curl ci-dessus pour tester l''API de mise à jour' as instruction;
