-- =====================================================
-- SCRIPT DE MISE À JOUR BASE DE DONNÉES PURESKIN EXISTANTE
-- Pour migrer une base de données existante vers la structure finale
-- Exécuter sur la base de données pureskin existante
-- =====================================================

-- Extension UUID si nécessaire
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- MISE À JOUR DES TABLES EXISTANTES
-- =====================================================

-- Vérifier si les tables existent et les créer si nécessaire
DO $$
BEGIN
    -- Créer les tables manquantes
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'categories') THEN
        CREATE TABLE categories (
            id BIGSERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            slug VARCHAR(255) UNIQUE NOT NULL,
            description TEXT,
            image_url VARCHAR(500),
            is_active BOOLEAN DEFAULT true,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'customers') THEN
        CREATE TABLE customers (
            id BIGSERIAL PRIMARY KEY,
            first_name VARCHAR(100) NOT NULL,
            last_name VARCHAR(100) NOT NULL,
            email VARCHAR(255) UNIQUE NOT NULL,
            phone VARCHAR(20),
            address TEXT,
            city VARCHAR(100),
            postal_code VARCHAR(20),
            country VARCHAR(100) DEFAULT 'Cameroun',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'blog_posts') THEN
        CREATE TABLE blog_posts (
            id BIGSERIAL PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            slug VARCHAR(255) UNIQUE NOT NULL,
            excerpt TEXT,
            content TEXT,
            featured_image VARCHAR(500),
            author VARCHAR(255) NOT NULL,
            reading_time INTEGER,
            is_published BOOLEAN DEFAULT false,
            published_at TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'testimonials') THEN
        CREATE TABLE testimonials (
            id BIGSERIAL PRIMARY KEY,
            customer_name VARCHAR(255) NOT NULL,
            customer_email VARCHAR(255),
            rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
            testimonial_text TEXT NOT NULL,
            product_name VARCHAR(255),
            is_verified BOOLEAN DEFAULT false,
            is_featured BOOLEAN DEFAULT false,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'newsletter_subscribers') THEN
        CREATE TABLE newsletter_subscribers (
            id BIGSERIAL PRIMARY KEY,
            email VARCHAR(255) UNIQUE NOT NULL,
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            university VARCHAR(255),
            study_field VARCHAR(100),
            graduation_year INTEGER,
            skin_type VARCHAR(50),
            source VARCHAR(50) DEFAULT 'homepage',
            student_verified BOOLEAN DEFAULT false,
            promo_code_used VARCHAR(50),
            guide_downloaded BOOLEAN DEFAULT false,
            weekly_tips_active BOOLEAN DEFAULT true,
            is_active BOOLEAN DEFAULT true,
            subscription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_email_sent TIMESTAMP,
            email_count INTEGER DEFAULT 0,
            unsubscribe_reason TEXT,
            unsubscribe_date TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    END IF;
END $$;

-- =====================================================
-- MISE À JOUR DE LA TABLE PRODUCTS
-- =====================================================

-- Ajouter les colonnes manquantes à products
DO $$
BEGIN
    -- Ajouter category_id si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'category_id') THEN
        ALTER TABLE products ADD COLUMN category_id BIGINT REFERENCES categories(id);
    END IF;
    
    -- Ajouter ingredients si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'ingredients') THEN
        ALTER TABLE products ADD COLUMN ingredients TEXT;
    END IF;
    
    -- Ajouter usage_instructions si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'usage_instructions') THEN
        ALTER TABLE products ADD COLUMN usage_instructions TEXT;
    END IF;
    
    -- Ajouter benefits si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'benefits') THEN
        ALTER TABLE products ADD COLUMN benefits TEXT;
    END IF;
    
    -- Ajouter rating_average si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'rating_average') THEN
        ALTER TABLE products ADD COLUMN rating_average DECIMAL(3,2) DEFAULT 0.00;
    END IF;
    
    -- Ajouter review_count si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'review_count') THEN
        ALTER TABLE products ADD COLUMN review_count INTEGER DEFAULT 0;
    END IF;
    
    -- Ajouter updated_at si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'updated_at') THEN
        ALTER TABLE products ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;
    
    -- Renommer image en image_url si nécessaire et garder le legacy
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'image') AND 
       NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'image_url') THEN
        ALTER TABLE products RENAME COLUMN image TO image_url;
        ALTER TABLE products ADD COLUMN image VARCHAR(500); -- Champ legacy
    ELSIF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'image_url') THEN
        ALTER TABLE products ADD COLUMN image_url VARCHAR(500);
    ELSIF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'image') THEN
        ALTER TABLE products ADD COLUMN image VARCHAR(500); -- Champ legacy
    END IF;
    
    -- Mettre à jour la currency par défaut de EUR vers XAF
    UPDATE products SET price = price * 655.957 WHERE price < 1000; -- Conversion approximative
    UPDATE products SET original_price = original_price * 655.957 WHERE original_price < 1000 AND original_price IS NOT NULL;
    
    -- S'assurer que tous les produits ont un prix valide
    UPDATE products SET price = 10000.00 WHERE price IS NULL OR price <= 0;
    UPDATE products SET stock_quantity = 50 WHERE stock_quantity IS NULL;
END $$;

-- =====================================================
-- MISE À JOUR DE LA TABLE ORDERS
-- =====================================================

-- Ajouter les colonnes manquantes à orders
DO $$
BEGIN
    -- Ajouter customer_id si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'customer_id') THEN
        ALTER TABLE orders ADD COLUMN customer_id BIGINT REFERENCES customers(id);
    END IF;
    
    -- Ajouter customer_name si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'customer_name') THEN
        ALTER TABLE orders ADD COLUMN customer_name VARCHAR(255) NOT NULL DEFAULT 'Client';
    END IF;
    
    -- Ajouter customer_phone si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'customer_phone') THEN
        ALTER TABLE orders ADD COLUMN customer_phone VARCHAR(20);
    END IF;
    
    -- Ajouter les colonnes de montant si n'existent pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'subtotal') THEN
        ALTER TABLE orders ADD COLUMN subtotal DECIMAL(10,2) DEFAULT 0.00;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'shipping_cost') THEN
        ALTER TABLE orders ADD COLUMN shipping_cost DECIMAL(10,2) DEFAULT 0.00;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'tax_amount') THEN
        ALTER TABLE orders ADD COLUMN tax_amount DECIMAL(10,2) DEFAULT 0.00;
    END IF;
    
    -- Ajouter les colonnes d'adresse si n'existent pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'tracking_number') THEN
        ALTER TABLE orders ADD COLUMN tracking_number VARCHAR(100);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivered_at') THEN
        ALTER TABLE orders ADD COLUMN delivered_at TIMESTAMP;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'shipped_at') THEN
        ALTER TABLE orders ADD COLUMN shipped_at TIMESTAMP;
    END IF;
    
    -- Ajouter les champs Faroty si n'existent pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'wallet_id') THEN
        ALTER TABLE orders ADD COLUMN wallet_id VARCHAR(255);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'session_token') THEN
        ALTER TABLE orders ADD COLUMN session_token VARCHAR(255);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'faroty_user_id') THEN
        ALTER TABLE orders ADD COLUMN faroty_user_id VARCHAR(255);
    END IF;
    
    -- Ajouter updated_at si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'updated_at') THEN
        ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;
    
    -- Mettre à jour la currency par défaut
    UPDATE orders SET currency = 'XAF' WHERE currency = 'EUR' OR currency IS NULL;
    
    -- Mettre à jour les montants pour cohérence
    UPDATE orders SET 
        total_amount = (SELECT COALESCE(SUM(total_price), 0) FROM order_items WHERE order_id = orders.id),
        subtotal = (SELECT COALESCE(SUM(total_price), 0) FROM order_items WHERE order_id = orders.id) - COALESCE(shipping_cost, 0) - COALESCE(tax_amount, 0)
    WHERE total_amount != (SELECT COALESCE(SUM(total_price), 0) FROM order_items WHERE order_id = orders.id);
END $$;

-- =====================================================
-- MISE À JOUR DE LA TABLE ORDER_ITEMS
-- =====================================================

-- Ajouter les colonnes manquantes à order_items
DO $$
BEGIN
    -- Ajouter product_image si n'existe pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'order_items' AND column_name = 'product_image') THEN
        ALTER TABLE order_items ADD COLUMN product_image VARCHAR(500);
    END IF;
    
    -- Supprimer product_description si existe (redondant)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'order_items' AND column_name = 'product_description') THEN
        ALTER TABLE order_items DROP COLUMN product_description;
    END IF;
    
    -- Mettre à jour les prix des items pour cohérence
    UPDATE order_items SET total_price = unit_price * quantity WHERE total_price != unit_price * quantity;
END $$;

-- =====================================================
-- MISE À JOUR DE LA TABLE PAYMENTS
-- =====================================================

-- Si la table payments n'existe pas, la créer avec la structure correcte
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN
        CREATE TABLE payments (
            id BIGSERIAL PRIMARY KEY,
            order_id VARCHAR(100) UNIQUE NOT NULL,
            customer_name VARCHAR(255) NOT NULL,
            customer_email VARCHAR(255) NOT NULL,
            customer_phone VARCHAR(50),
            amount DECIMAL(10,2) NOT NULL,
            currency VARCHAR(10) DEFAULT 'XAF',
            payment_method VARCHAR(100),
            status VARCHAR(50) NOT NULL,
            payment_reference VARCHAR(255),
            faroty_transaction_id VARCHAR(255),
            faroty_wallet_id VARCHAR(255),
            products TEXT, -- JSON string
            shipping_address TEXT, -- JSON string
            billing_address TEXT, -- JSON string
            metadata TEXT, -- JSON string
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            processed_at TIMESTAMP,
            expires_at TIMESTAMP
        );
    ELSE
        -- Mettre à jour la table payments existante
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'currency') THEN
            ALTER TABLE payments ADD COLUMN currency VARCHAR(10) DEFAULT 'XAF';
        END IF;
        
        -- Convertir les colonnes JSONB en TEXT si nécessaire
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'products' AND data_type = 'jsonb') THEN
            ALTER TABLE payments ALTER COLUMN products TYPE TEXT USING products::TEXT;
        END IF;
        
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'shipping_address' AND data_type = 'jsonb') THEN
            ALTER TABLE payments ALTER COLUMN shipping_address TYPE TEXT USING shipping_address::TEXT;
        END IF;
        
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'billing_address' AND data_type = 'jsonb') THEN
            ALTER TABLE payments ALTER COLUMN billing_address TYPE TEXT USING billing_address::TEXT;
        END IF;
        
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'metadata' AND data_type = 'jsonb') THEN
            ALTER TABLE payments ALTER COLUMN metadata TYPE TEXT USING metadata::TEXT;
        END IF;
        
        -- Mettre à jour la currency
        UPDATE payments SET currency = 'XAF' WHERE currency = 'EUR' OR currency IS NULL;
    END IF;
END $$;

-- =====================================================
-- CRÉATION DES INDEX MANQUANTS
-- =====================================================

-- Index pour categories
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);

-- Index pour products
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_is_featured ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);

-- Index pour customers
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);

-- Index pour orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_wallet_id ON orders(wallet_id);
CREATE INDEX IF NOT EXISTS idx_orders_session_token ON orders(session_token);
CREATE INDEX IF NOT EXISTS idx_orders_faroty_user_id ON orders(faroty_user_id);

-- Index pour order_items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Index pour payments
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_customer_email ON payments(customer_email);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);
CREATE INDEX IF NOT EXISTS idx_payments_amount ON payments(amount);
CREATE INDEX IF NOT EXISTS idx_payments_faroty_transaction_id ON payments(faroty_transaction_id);

-- Index pour blog_posts
CREATE INDEX IF NOT EXISTS idx_blog_posts_slug ON blog_posts(slug);
CREATE INDEX IF NOT EXISTS idx_blog_posts_is_published ON blog_posts(is_published);
CREATE INDEX IF NOT EXISTS idx_blog_posts_published_at ON blog_posts(published_at);

-- Index pour testimonials
CREATE INDEX IF NOT EXISTS idx_testimonials_rating ON testimonials(rating);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_featured ON testimonials(is_featured);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_verified ON testimonials(is_verified);

-- Index pour newsletter_subscribers
CREATE INDEX IF NOT EXISTS idx_newsletter_email_active ON newsletter_subscribers(email, is_active);
CREATE INDEX IF NOT EXISTS idx_newsletter_subscription_date ON newsletter_subscribers(subscription_date);
CREATE INDEX IF NOT EXISTS idx_newsletter_source ON newsletter_subscribers(source);
CREATE INDEX IF NOT EXISTS idx_newsletter_student_verified ON newsletter_subscribers(student_verified);

-- =====================================================
-- CRÉATION DES TRIGGERS
-- =====================================================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Application des triggers sur toutes les tables
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at 
    BEFORE UPDATE ON categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_customers_updated_at ON customers;
CREATE TRIGGER update_customers_updated_at 
    BEFORE UPDATE ON customers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_payments_updated_at ON payments;
CREATE TRIGGER update_payments_updated_at 
    BEFORE UPDATE ON payments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_blog_posts_updated_at ON blog_posts;
CREATE TRIGGER update_blog_posts_updated_at 
    BEFORE UPDATE ON blog_posts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_testimonials_updated_at ON testimonials;
CREATE TRIGGER update_testimonials_updated_at 
    BEFORE UPDATE ON testimonials 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_newsletter_subscribers_updated_at ON newsletter_subscribers;
CREATE TRIGGER update_newsletter_subscribers_updated_at 
    BEFORE UPDATE ON newsletter_subscribers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- CRÉATION DES VUES
-- =====================================================

-- Vue détaillée des commandes
CREATE OR REPLACE VIEW order_details_view AS
SELECT 
    o.id,
    o.order_number,
    o.customer_id,
    o.customer_name,
    o.customer_email,
    o.customer_phone,
    o.status,
    o.payment_status,
    o.payment_method,
    o.subtotal,
    o.shipping_cost,
    o.tax_amount,
    o.total_amount,
    o.currency,
    o.shipping_address,
    o.billing_address,
    o.tracking_number,
    o.notes,
    o.paid_at,
    o.delivered_at,
    o.shipped_at,
    o.wallet_id,
    o.session_token,
    o.faroty_user_id,
    o.created_at,
    o.updated_at,
    COALESCE(
        json_agg(
            json_build_object(
                'id', oi.id,
                'product_id', oi.product_id,
                'product_name', oi.product_name,
                'product_image', oi.product_image,
                'unit_price', oi.unit_price,
                'quantity', oi.quantity,
                'total_price', oi.total_price,
                'created_at', oi.created_at
            )
        ) FILTER (WHERE oi.id IS NOT NULL), 
        '[]'::json
    ) as items
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.order_number, o.customer_id, o.customer_name, o.customer_email, o.customer_phone, o.status, o.payment_status, o.payment_method, o.subtotal, o.shipping_cost, o.tax_amount, o.total_amount, o.currency, o.shipping_address, o.billing_address, o.tracking_number, o.notes, o.paid_at, o.delivered_at, o.shipped_at, o.wallet_id, o.session_token, o.faroty_user_id, o.created_at, o.updated_at;

-- Vue statistiques newsletter
CREATE OR REPLACE VIEW newsletter_stats AS
SELECT 
    COUNT(*) as total_subscribers,
    COUNT(*) FILTER (WHERE is_active = true) as active_subscribers,
    COUNT(*) FILTER (WHERE student_verified = true) as verified_students,
    COUNT(*) FILTER (WHERE guide_downloaded = true) as guide_downloads,
    COUNT(*) FILTER (WHERE weekly_tips_active = true) as weekly_tips_active,
    DATE_TRUNC('month', subscription_date) as month,
    COUNT(*) FILTER (WHERE DATE_TRUNC('month', subscription_date) = DATE_TRUNC('month', CURRENT_DATE)) as this_month
FROM newsletter_subscribers
GROUP BY DATE_TRUNC('month', subscription_date);

-- =====================================================
-- FONCTIONS UTILITAIRES
-- =====================================================

-- Fonction pour calculer automatiquement le total d'une commande
CREATE OR REPLACE FUNCTION calculate_order_total(p_order_id BIGINT)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_total DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(total_price), 0) INTO v_total
    FROM order_items 
    WHERE order_id = p_order_id;
    
    UPDATE orders 
    SET 
        total_amount = v_total,
        subtotal = v_total - COALESCE(shipping_cost, 0) - COALESCE(tax_amount, 0),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_order_id;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour recalculer automatiquement les totaux
CREATE OR REPLACE FUNCTION recalculate_order_total()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        PERFORM calculate_order_total(COALESCE(NEW.order_id, OLD.order_id));
        RETURN COALESCE(NEW, OLD);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger
DROP TRIGGER IF EXISTS trigger_recalculate_order_total ON order_items;
CREATE TRIGGER trigger_recalculate_order_total
    AFTER INSERT OR UPDATE OR DELETE ON order_items
    FOR EACH ROW EXECUTE FUNCTION recalculate_order_total();

-- =====================================================
-- DONNÉES INITIALES
-- =====================================================

-- Insérer des catégories par défaut
INSERT INTO categories (name, slug, description, is_active) 
VALUES 
    ('Soins du visage', 'soins-visage', 'Produits pour le soin du visage', true),
    ('Soins du corps', 'soins-corps', 'Produits pour le soin du corps', true),
    ('Maquillage', 'maquillage', 'Produits de maquillage', true),
    ('Accessoires', 'accessoires', 'Accessoires de beauté', true)
ON CONFLICT (slug) DO NOTHING;

-- Associer les produits existants à des catégories
UPDATE products SET category_id = (SELECT id FROM categories WHERE slug = 'soins-visage' LIMIT 1) 
WHERE category_id IS NULL AND (name ILIKE '%sérum%' OR name ILIKE '%crème%' OR name ILIKE '%gel%' OR name ILIKE '%gommage%');

UPDATE products SET category_id = (SELECT id FROM categories WHERE slug = 'soins-corps' LIMIT 1) 
WHERE category_id IS NULL AND (name ILIKE '%huile%' OR name ILIKE '%lait%');

-- Insérer des articles de blog d'exemple
INSERT INTO blog_posts (title, slug, excerpt, content, featured_image, author, reading_time, is_published, published_at) 
VALUES 
    ('Les 5 étapes essentielles pour une peau parfaite', 
     'les-5-etapes-essentielles-peau-parfaite', 
     'Découvrez les routines quotidiennes pour une peau saine et éclatante.', 
     'Une peau parfaite demande de la régularité et les bons produits...', 
     '/images/blog/peau-parfaite.jpg', 
     'Dr. Marie Claire', 
     5, 
     true, 
     CURRENT_TIMESTAMP - INTERVAL '7 days'),
    ('Comment choisir son sérum selon son type de peau', 
     'comment-choisir-son-serum-type-peau', 
     'Guide complet pour sélectionner le sérum adapté à votre peau.', 
     'Les sérums sont des concentrés actifs qui ciblent des problèmes spécifiques...', 
     '/images/blog/choisir-serum.jpg', 
     'Dr. Sophie Martin', 
     8, 
     true, 
     CURRENT_TIMESTAMP - INTERVAL '3 days')
ON CONFLICT (slug) DO NOTHING;

-- =====================================================
-- VÉRIFICATION FINALE
-- =====================================================

SELECT 'MISE À JOUR BASE DE DONNÉES PURESKIN - TERMINÉE' as status;

-- Afficher le résumé des tables
SELECT 
    table_name,
    column_count,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as actual_columns
FROM (
    SELECT 'categories' as table_name, 8 as column_count
    UNION ALL SELECT 'products', 15
    UNION ALL SELECT 'customers', 9
    UNION ALL SELECT 'orders', 20
    UNION ALL SELECT 'order_items', 7
    UNION ALL SELECT 'payments', 16
    UNION ALL SELECT 'blog_posts', 10
    UNION ALL SELECT 'testimonials', 8
    UNION ALL SELECT 'newsletter_subscribers', 17
) t
ORDER BY table_name;

-- Afficher les enregistrements par table
SELECT 
    'categories' as table_name, 
    COUNT(*) as record_count 
FROM categories
UNION ALL
SELECT 
    'products' as table_name, 
    COUNT(*) as record_count 
FROM products
UNION ALL
SELECT 
    'customers' as table_name, 
    COUNT(*) as record_count 
FROM customers
UNION ALL
SELECT 
    'orders' as table_name, 
    COUNT(*) as record_count 
FROM orders
UNION ALL
SELECT 
    'order_items' as table_name, 
    COUNT(*) as record_count 
FROM order_items
UNION ALL
SELECT 
    'payments' as table_name, 
    COUNT(*) as record_count 
FROM payments
UNION ALL
SELECT 
    'blog_posts' as table_name, 
    COUNT(*) as record_count 
FROM blog_posts
UNION ALL
SELECT 
    'testimonials' as table_name, 
    COUNT(*) as record_count 
FROM testimonials
UNION ALL
SELECT 
    'newsletter_subscribers' as table_name, 
    COUNT(*) as record_count 
FROM newsletter_subscribers
ORDER BY table_name;
