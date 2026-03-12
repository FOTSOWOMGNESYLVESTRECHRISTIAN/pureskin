-- =====================================================
-- BASE DE DONNÉES COMPLÈTE PURESKIN ÉTUDIANT - VERSION FINALE
-- Compatible avec toutes les fonctionnalités du projet
-- Backend Spring Boot + Frontend Next.js + Faroty Payment
-- =====================================================

-- Extension UUID pour les identifiants uniques
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLE CATÉGORIES
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE PRODUITS
-- =====================================================
CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    original_price DECIMAL(10,2),
    image_url VARCHAR(500),
    image VARCHAR(500), -- Champ legacy pour compatibilité
    badge VARCHAR(100),
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    category_id BIGINT REFERENCES categories(id),
    ingredients TEXT,
    usage_instructions TEXT,
    benefits TEXT,
    rating_average DECIMAL(3,2) DEFAULT 0.00,
    review_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE CLIENTS/CUSTOMERS
-- =====================================================
CREATE TABLE IF NOT EXISTS customers (
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

-- =====================================================
-- TABLE COMMANDES (ORDERS)
-- =====================================================
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT REFERENCES customers(id),
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(20),
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    payment_status VARCHAR(50) NOT NULL DEFAULT 'pending',
    payment_method VARCHAR(50),
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    shipping_cost DECIMAL(10,2) DEFAULT 0.00,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(10) NOT NULL DEFAULT 'XAF',
    shipping_address TEXT,
    billing_address TEXT,
    tracking_number VARCHAR(100),
    notes TEXT,
    paid_at TIMESTAMP,
    delivered_at TIMESTAMP,
    shipped_at TIMESTAMP,
    -- Champs Faroty
    wallet_id VARCHAR(255),
    session_token VARCHAR(255),
    faroty_user_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE ITEMS DE COMMANDE (ORDER_ITEMS)
-- =====================================================
CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT,
    product_name VARCHAR(255) NOT NULL,
    product_image VARCHAR(500),
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE PAIEMENTS (PAYMENTS)
-- =====================================================
CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    order_id VARCHAR(100) UNIQUE NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(50),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'XAF',
    payment_method VARCHAR(100),
    status VARCHAR(50) NOT NULL, -- 'PENDING', 'SUCCESS', 'FAILED', 'CANCELLED'
    payment_reference VARCHAR(255),
    faroty_transaction_id VARCHAR(255),
    faroty_wallet_id VARCHAR(255),
    products TEXT, -- JSON string des produits
    shipping_address TEXT, -- JSON string
    billing_address TEXT, -- JSON string
    metadata TEXT, -- JSON string
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    expires_at TIMESTAMP
);

-- =====================================================
-- TABLE ARTICLES DE BLOG
-- =====================================================
CREATE TABLE IF NOT EXISTS blog_posts (
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

-- =====================================================
-- TABLE TÉMOIGNAGES (TESTIMONIALS)
-- =====================================================
CREATE TABLE IF NOT EXISTS testimonials (
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

-- =====================================================
-- TABLE NEWSLETTER SUBSCRIBERS
-- =====================================================
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
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

-- =====================================================
-- INDEX POUR OPTIMISATION
-- =====================================================

-- Index categories
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);

-- Index products
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_is_featured ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);

-- Index customers
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);

-- Index orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_wallet_id ON orders(wallet_id);
CREATE INDEX IF NOT EXISTS idx_orders_session_token ON orders(session_token);
CREATE INDEX IF NOT EXISTS idx_orders_faroty_user_id ON orders(faroty_user_id);

-- Index order_items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Index payments
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_customer_email ON payments(customer_email);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);
CREATE INDEX IF NOT EXISTS idx_payments_amount ON payments(amount);
CREATE INDEX IF NOT EXISTS idx_payments_faroty_transaction_id ON payments(faroty_transaction_id);

-- Index blog_posts
CREATE INDEX IF NOT EXISTS idx_blog_posts_slug ON blog_posts(slug);
CREATE INDEX IF NOT EXISTS idx_blog_posts_is_published ON blog_posts(is_published);
CREATE INDEX IF NOT EXISTS idx_blog_posts_published_at ON blog_posts(published_at);

-- Index testimonials
CREATE INDEX IF NOT EXISTS idx_testimonials_rating ON testimonials(rating);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_featured ON testimonials(is_featured);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_verified ON testimonials(is_verified);

-- Index newsletter_subscribers
CREATE INDEX IF NOT EXISTS idx_newsletter_email_active ON newsletter_subscribers(email, is_active);
CREATE INDEX IF NOT EXISTS idx_newsletter_subscription_date ON newsletter_subscribers(subscription_date);
CREATE INDEX IF NOT EXISTS idx_newsletter_source ON newsletter_subscribers(source);
CREATE INDEX IF NOT EXISTS idx_newsletter_student_verified ON newsletter_subscribers(student_verified);

-- =====================================================
-- TRIGGERS AUTOMATIQUES
-- =====================================================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Application des triggers sur toutes les tables avec updated_at
CREATE TRIGGER update_categories_updated_at 
    BEFORE UPDATE ON categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at 
    BEFORE UPDATE ON customers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at 
    BEFORE UPDATE ON payments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_blog_posts_updated_at 
    BEFORE UPDATE ON blog_posts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_testimonials_updated_at 
    BEFORE UPDATE ON testimonials 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_newsletter_subscribers_updated_at 
    BEFORE UPDATE ON newsletter_subscribers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VUES UTILITAIRES
-- =====================================================

-- Vue détaillée des commandes avec items
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
    
    -- Mettre à jour la commande avec le nouveau total
    UPDATE orders 
    SET 
        total_amount = v_total,
        subtotal = v_total - shipping_cost - tax_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_order_id;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour recalculer automatiquement le total lors de la modification d'items
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

-- Appliquer le trigger sur order_items
CREATE TRIGGER trigger_recalculate_order_total
    AFTER INSERT OR UPDATE OR DELETE ON order_items
    FOR EACH ROW EXECUTE FUNCTION recalculate_order_total();

-- =====================================================
-- DONNÉES INITIALES (CATÉGORIES ET PRODUITS)
-- =====================================================

-- Insérer des catégories par défaut
INSERT INTO categories (name, slug, description, is_active) 
VALUES 
    ('Soins du visage', 'soins-visage', 'Produits pour le soin du visage', true),
    ('Soins du corps', 'soins-corps', 'Produits pour le soin du corps', true),
    ('Maquillage', 'maquillage', 'Produits de maquillage', true),
    ('Accessoires', 'accessoires', 'Accessoires de beauté', true)
ON CONFLICT (slug) DO NOTHING;

-- Insérer des produits d'exemple
INSERT INTO products (name, slug, description, price, original_price, image_url, stock_quantity, is_active, is_featured, category_id) 
SELECT 
    'Sérum Hydratant PureSkin', 
    'serum-hydratant-pureskin', 
    'Sérum hydratant intense pour peau sèche et déshydratée. Riche en acide hyaluronique et extraits naturels.', 
    15000.00, 
    18000.00, 
    '/images/products/serum-hydratant.jpg', 
    50, 
    true, 
    true, 
    id 
FROM categories WHERE slug = 'soins-visage' LIMIT 1
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (name, slug, description, price, original_price, image_url, stock_quantity, is_active, is_featured, category_id) 
SELECT 
    'Crème Nuit Régénérante', 
    'creme-nuit-regenerante', 
    'Crème de nuit régénérante pour修复 et nourrir la peau pendant le sommeil.', 
    12000.00, 
    15000.00, 
    '/images/products/creme-nuit.jpg', 
    30, 
    true, 
    true, 
    id 
FROM categories WHERE slug = 'soins-visage' LIMIT 1
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (name, slug, description, price, original_price, image_url, stock_quantity, is_active, is_featured, category_id) 
SELECT 
    'Gommage Douceur Exfoliant', 
    'gommage-douceur-exfoliant', 
    'Gommage exfoliant doux pour éliminer les cellules mortes et révéler une peau éclatante.', 
    8000.00, 
    10000.00, 
    '/images/products/gommage.jpg', 
    25, 
    true, 
    false, 
    id 
FROM categories WHERE slug = 'soins-visage' LIMIT 1
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (name, slug, description, price, original_price, image_url, stock_quantity, is_active, is_featured, category_id) 
SELECT 
    'Huile Corps Nourrissante', 
    'huile-corps-nourrissante', 
    'Huile sèche nourrissante pour le corps, absorption rapide sans effet gras.', 
    10000.00, 
    12000.00, 
    '/images/products/huile-corps.jpg', 
    40, 
    true, 
    true, 
    id 
FROM categories WHERE slug = 'soins-corps' LIMIT 1
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (name, slug, description, price, original_price, image_url, stock_quantity, is_active, is_featured, category_id) 
SELECT 
    'Gel Nettoyant Doux', 
    'gel-nettoyant-doux', 
    'Gel nettoyant doux pour le visage, respecte l'équilibre naturel de la peau.', 
    6000.00, 
    8000.00, 
    '/images/products/gel-nettoyant.jpg', 
    60, 
    true, 
    false, 
    id 
FROM categories WHERE slug = 'soins-visage' LIMIT 1
ON CONFLICT (slug) DO NOTHING;

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

-- Insérer des témoignages d'exemple
INSERT INTO testimonials (customer_name, customer_email, rating, testimonial_text, product_name, is_verified, is_featured) 
VALUES 
    ('Marie Dupont', 'marie.dupont@email.com', 5, 'Produits excellents ! Ma peau n''a jamais été aussi belle. Le sérum hydratant est mon produit fétiche.', 'Sérum Hydratant PureSkin', true, true),
    ('Sophie Martin', 'sophie.martin@email.com', 4, 'Très satisfaite de mes achats. La crème de nuit est efficace et sent bon.', 'Crème Nuit Régénérante', true, false),
    ('Laura Petit', 'laura.petit@email.com', 5, 'Service client au top et produits de qualité. Je recommande vivement !', 'Gommage Douceur Exfoliant', true, true)
ON CONFLICT DO NOTHING;

-- =====================================================
-- VÉRIFICATION FINALE
-- =====================================================

SELECT 'BASE DE DONNÉES PURESKIN ÉTUDIANT - CRÉATION TERMINÉE' as status;

-- Afficher le résumé des tables créées
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
