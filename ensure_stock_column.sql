-- Script pour s'assurer que la table products a la colonne stock_quantity
-- et l'ajouter si elle n'existe pas

-- Vérifier si la colonne stock_quantity existe dans la table products
DO $$
BEGIN
    -- Ajouter la colonne stock_quantity si elle n'existe pas
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'products' 
        AND column_name = 'stock_quantity'
        AND table_schema = current_schema()
    ) THEN
        ALTER TABLE products 
        ADD COLUMN stock_quantity INTEGER DEFAULT 0;
        
        RAISE NOTICE 'Colonne stock_quantity ajoutée à la table products';
    ELSE
        RAISE NOTICE 'La colonne stock_quantity existe déjà dans la table products';
    END IF;
END $$;

-- Mettre à jour les produits qui n'ont pas de stock_quantity (NULL)
UPDATE products 
SET stock_quantity = 0 
WHERE stock_quantity IS NULL;

-- Afficher le nombre de produits mis à jour
DO $$
DECLARE
    updated_count INTEGER;
BEGIN
    UPDATE products 
    SET stock_quantity = 0 
    WHERE stock_quantity IS NULL;
    
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    
    RAISE NOTICE 'Produits mis à jour: %', updated_count;
END $$;

-- Créer un index sur la colonne stock_quantity pour optimiser les requêtes
CREATE INDEX IF NOT EXISTS idx_products_stock_quantity ON products(stock_quantity);

-- Créer un index sur la colonne updated_at pour optimiser les requêtes de tri
CREATE INDEX IF NOT EXISTS idx_products_updated_at ON products(updated_at);

-- Afficher un résumé des opérations effectuées
SELECT 
    'Vérification colonne stock_quantity' as operation,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'products' 
            AND column_name = 'stock_quantity'
            AND table_schema = current_schema()
        ) THEN 'SUCCESS'
        ELSE 'FAILED'
    END as status,
    CURRENT_TIMESTAMP as verification_time;

-- Afficher quelques statistiques sur les stocks
SELECT 
    COUNT(*) as total_products,
    COUNT(CASE WHEN stock_quantity > 0 THEN 1 END) as products_with_stock,
    COUNT(CASE WHEN stock_quantity = 0 THEN 1 END) as products_out_of_stock,
    COUNT(CASE WHEN stock_quantity <= 5 THEN 1 END) as products_low_stock,
    AVG(stock_quantity) as average_stock,
    MAX(stock_quantity) as max_stock,
    MIN(stock_quantity) as min_stock
FROM products;
