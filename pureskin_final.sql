-- =============================================
-- BASE DE DONNÉES COMPLÈTE PURESKIN ÉTUDIANT
-- Fichier SQL final pour déploiement production
-- Compatible avec toutes les fonctionnalités du site
-- =============================================

-- Extension UUID pour les identifiants uniques
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLE DES PRODUITS
-- =============================================
CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    image VARCHAR(255),
    imageUrl VARCHAR(255), -- Champ pour compatibilité frontend
    badge VARCHAR(50),
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE DES ARTICLES DE BLOG
-- =============================================
CREATE TABLE IF NOT EXISTS blog_posts (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    excerpt TEXT,
    content TEXT,
    featured_image VARCHAR(255),
    author VARCHAR(255) NOT NULL,
    reading_time INTEGER,
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE DES TEMOIGNAGES
-- =============================================
CREATE TABLE IF NOT EXISTS testimonials (
    id BIGSERIAL PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255),
    customer_university VARCHAR(255),
    customer_age INTEGER,
    comment TEXT NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    product_name VARCHAR(255),
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE DES ROUTINES DE SOIN
-- =============================================
CREATE TABLE IF NOT EXISTS routines (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    skin_type_id BIGINT,
    steps TEXT,
    duration_minutes INTEGER,
    difficulty_level VARCHAR(50),
    is_recommended BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE DES PANIERS (CART ITEMS)
-- =============================================
CREATE TABLE IF NOT EXISTS cart_items (
    id BIGSERIAL PRIMARY KEY,
    session_id VARCHAR(255),
    customer_id BIGINT,
    product_id BIGINT NOT NULL,
    quantity INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE DES COMMANDES (ORDERS)
-- =============================================
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT,
    customer_email VARCHAR(255) NOT NULL,
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_phone VARCHAR(20),
    subtotal DECIMAL(10,2),
    shipping_cost DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'EUR',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    wallet_id VARCHAR(255),
    session_token VARCHAR(500),
    faroty_user_id VARCHAR(255),
    shipping_address TEXT,
    billing_address TEXT,
    shipping_city VARCHAR(100),
    shipping_postal_code VARCHAR(20),
    shipping_country VARCHAR(100) DEFAULT 'France',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMP
);

-- =============================================
-- TABLE DES ARTICLES DE COMMANDE (ORDER ITEMS)
-- =============================================
CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description TEXT,
    product_image VARCHAR(500),
    product_image_url VARCHAR(500), -- Champ pour compatibilité frontend
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLE OPTIONS DE LIVRAISON
-- =============================================
CREATE TABLE IF NOT EXISTS delivery_options (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    delivery_time_min INTEGER,
    delivery_time_max INTEGER,
    delivery_time_unit VARCHAR(20) DEFAULT 'jours',
    is_active BOOLEAN DEFAULT true,
    is_default BOOLEAN DEFAULT false,
    is_express BOOLEAN DEFAULT false,
    tracking_available VARCHAR(255),
    restrictions TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE PROGRAMME FIDÉLITÉ
-- =============================================
CREATE TABLE IF NOT EXISTS loyalty_programs (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    points_multiplier DECIMAL(3,2) NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    min_points INTEGER,
    max_points INTEGER,
    is_active BOOLEAN DEFAULT true,
    benefits TEXT,
    next_reward TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE FAQ
-- =============================================
CREATE TABLE IF NOT EXISTS faqs (
    id BIGSERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100),
    helpful_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE RÉCOMPENSES FIDÉLITÉ
-- =============================================
CREATE TABLE IF NOT EXISTS loyalty_rewards (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    points_required INTEGER NOT NULL,
    category VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    is_popular BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- INDEX POUR OPTIMISATION
-- =============================================
CREATE INDEX IF NOT EXISTS idx_products_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_blog_posts_published ON blog_posts(is_published);
CREATE INDEX IF NOT EXISTS idx_testimonials_approved ON testimonials(is_approved);
CREATE INDEX IF NOT EXISTS idx_routines_recommended ON routines(is_recommended);
CREATE INDEX IF NOT EXISTS idx_cart_items_session ON cart_items(session_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_customer ON cart_items(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_wallet_id ON orders(wallet_id);
CREATE INDEX IF NOT EXISTS idx_orders_session_token ON orders(session_token);
CREATE INDEX IF NOT EXISTS idx_orders_faroty_user_id ON orders(faroty_user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_delivery_options_active ON delivery_options(is_active);
CREATE INDEX IF NOT EXISTS idx_loyalty_programs_active ON loyalty_programs(is_active);
CREATE INDEX IF NOT EXISTS idx_faqs_active ON faqs(is_active);
CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs(category);
CREATE INDEX IF NOT EXISTS idx_loyalty_rewards_active ON loyalty_rewards(is_active);

-- =============================================
-- TRIGGER POUR UPDATED_AT
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Application du trigger sur les tables qui ont updated_at
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_blog_posts_updated_at ON blog_posts;
CREATE TRIGGER update_blog_posts_updated_at 
    BEFORE UPDATE ON blog_posts 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_testimonials_updated_at ON testimonials;
CREATE TRIGGER update_testimonials_updated_at 
    BEFORE UPDATE ON testimonials 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_routines_updated_at ON routines;
CREATE TRIGGER update_routines_updated_at 
    BEFORE UPDATE ON routines 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_cart_items_updated_at ON cart_items;
CREATE TRIGGER update_cart_items_updated_at 
    BEFORE UPDATE ON cart_items 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_delivery_options_updated_at ON delivery_options;
CREATE TRIGGER update_delivery_options_updated_at 
    BEFORE UPDATE ON delivery_options 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_loyalty_programs_updated_at ON loyalty_programs;
CREATE TRIGGER update_loyalty_programs_updated_at 
    BEFORE UPDATE ON loyalty_programs 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_faqs_updated_at ON faqs;
CREATE TRIGGER update_faqs_updated_at 
    BEFORE UPDATE ON faqs 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_loyalty_rewards_updated_at ON loyalty_rewards;
CREATE TRIGGER update_loyalty_rewards_updated_at 
    BEFORE UPDATE ON loyalty_rewards 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- INSERTION DES DONNÉES DE PRODUCTION
-- =============================================

-- Produits pour étudiants
INSERT INTO products (name, description, price, original_price, image, imageUrl, badge, stock_quantity, is_active) VALUES
('Sérum Hydratant Étudiant', 'Sérum hydratant intense avec acide hyaluronique et vitamine C. Spécialement formulé pour les peaux jeunes.', 24.99, 34.99, '/images/serum-hydratant.jpg', '/images/serum-hydratant.jpg', 'best-seller', 150, true),
('Crème Solaire SPF 50+', 'Protection solaire très haute protection, non grasse, idéale pour le quotidien et le sport.', 18.99, NULL, '/images/creme-solaire.jpg', '/images/creme-solaire.jpg', 'essentiel', 200, true),
('Nettoyant Doux 3-en-1', 'Démaquille, nettoie et tonifie en une seule étape. Parfait pour les matins pressés.', 15.99, 22.99, '/images/nettoyant-doux.jpg', '/images/nettoyant-doux.jpg', 'new', 100, true),
('Masque Détox Week-end', 'Masque détoxifiant à l''argile et au charbon actif. Idéal après les examens.', 12.99, 19.99, '/images/masque-detox.jpg', '/images/masque-detox.jpg', 'promo', 80, true),
('Baume Lèvres Protecteur', 'Baume lèvres avec SPF 30. Protège du froid, du vent et du soleil.', 6.99, NULL, '/images/baume-levres.jpg', '/images/baume-levres.jpg', NULL, 300, true),
('Gommage Doux Visage', 'Gommage enzymatique doux, sans grains, respectueux des peaux sensibles.', 14.99, 21.99, '/images/gommage-doux.jpg', '/images/gommage-doux.jpg', 'best-seller', 90, true),
('Soin Anti-Boutons', 'Gel-crème anti-imperfections, action rapide sur les boutons et points noirs.', 19.99, 29.99, '/images/anti-boutons.jpg', '/images/anti-boutons.jpg', 'urgent', 60, true),
('Huile Démaquillante', 'Huile démaquillante qui élimine même le maquillage waterproof.', 16.99, NULL, '/images/huile-demaquillante.jpg', '/images/huile-demaquillante.jpg', NULL, 120, true),
('Crème Hydratante Légère', 'Crème hydratante texture gel, non grasse, pour peaux mixtes à grasses.', 22.99, 32.99, '/images/creme-hydratante.jpg', '/images/creme-hydratante.jpg', 'best-seller', 110, true),
('Roll-on Anti-Cernes', 'Roll-on rafraîchissant pour les cernes et poches. Effet glacé instantané.', 13.99, 19.99, '/images/roll-on-cernes.jpg', '/images/roll-on-cernes.jpg', 'new', 85, true);

-- Articles de blog
INSERT INTO blog_posts (title, slug, excerpt, content, featured_image, author, reading_time, is_published, published_at) VALUES
('Les 5 étapes indispensables d''une routine skincare étudiante', 'les-5-etapes-indispensables-routine-skincare-etudiante', 
'Découvrez la routine skincare parfaite adaptée au budget et au rythme de vie étudiant.', 
'Une routine skincare complète ne doit pas être compliquée ni coûteuse. Pour les étudiants, il faut trouver le juste milieu entre efficacité et simplicité...', 
'/images/blog-routine-etudiante.jpg', 'Dr. Marie Laurent', 7, true, CURRENT_TIMESTAMP - INTERVAL '2 days'),

('Comment gérer l''acné pendant les examens ?', 'comment-gerer-acne-pendant-examens', 
'Le stress des examens peut provoquer des poussées d''acné. Découvrez nos astuces.', 
'Le stress libère du cortisol qui stimule la production de sébum. Pendant les périodes d''examens...', 
'/images/blog-acne-examens.jpg', 'Dr. Paul Martin', 5, true, CURRENT_TIMESTAMP - INTERVAL '5 days'),

('Budget skincare : les produits qui en valent vraiment la peine', 'budget-skincare-produits-qui-en-valent-la-peine', 
'Investir dans les bons produits sans se ruiner. Notre sélection des meilleurs produits.', 
'Le skincare ne doit pas coûter une fortune. Certains produits abordables sont aussi efficaces...', 
'/images/blog-budget-skincare.jpg', 'Sophie Dubois', 8, true, CURRENT_TIMESTAMP - INTERVAL '1 week'),

('Protection solaire : pourquoi c''est non négociable même en hiver', 'protection-solaire-pourquoi-non-negociable-hiver', 
'Les UV sont présents toute l''année. Découvrez pourquoi la protection solaire est essentielle.', 
'Même par temps nuageux en hiver, 80% des UV traversent les nuages. La protection solaire quotidienne...', 
'/images/blog-solaire-hiver.jpg', 'Dr. Thomas Petit', 6, true, CURRENT_TIMESTAMP - INTERVAL '10 days');

-- Témoignages clients
INSERT INTO testimonials (customer_name, customer_email, customer_university, customer_age, comment, rating, product_name, is_approved) VALUES
('Camille Martin', 'camille.m@email.com', 'Sorbonne Université', 20, 'Le sérum hydratant est incroyable ! Ma peau est beaucoup plus douce et les rougeurs ont diminué.', 5, 'Sérum Hydratant Étudiant', true),
('Lucas Bernard', 'lucas.b@email.com', 'Université de Paris', 22, 'La crème solaire SPF 50+ est parfaite. Texture légère, non grasse, sans traces blanches.', 5, 'Crème Solaire SPF 50+', true),
('Emma Dubois', 'emma.d@email.com', 'École Polytechnique', 21, 'Le nettoyant 3-en-1 m''a fait gagner énormément de temps le matin. Plus besoin de 3 produits !', 4, 'Nettoyant Doux 3-en-1', true),
('Hugo Petit', 'hugo.p@email.com', 'Université Lyon 1', 19, 'Le masque détox est super efficace après une semaine de révisions. Peau plus nette et lumineuse.', 5, 'Masque Détox Week-end', true),
('Chloé Robert', 'chloe.r@email.com', 'Sciences Po Paris', 23, 'Le soin anti-boutons a sauvé ma peau pendant les partiels. Action rapide sans irriter.', 4, 'Soin Anti-Boutons', true),
('Antoine Leroy', 'antoine.l@email.com', 'Université de Montpellier', 20, 'Le baume lèvres est excellent. Protège bien du soleil et du vent. Je l''emporte partout.', 5, 'Baume Lèvres Protecteur', true),
('Léa Martinez', 'lea.m@email.com', 'Université Bordeaux', 22, 'La crème hydratante légère est parfaite pour ma peau mixte. Pas d''effet brillant, bonne tenue.', 5, 'Crème Hydratante Légère', true),
('Mathieu Durand', 'mathieu.d@email.com', 'ENS Paris', 21, 'Le roll-on anti-cernes est mon sauveur pendant les révisions nocturnes. Effet décongestionnant !', 4, 'Roll-on Anti-Cernes', true);

-- Routines de soin
INSERT INTO routines (name, slug, description, skin_type_id, steps, duration_minutes, difficulty_level, is_recommended) VALUES
('Routine Express Matin', 'routine-express-matin', 'Parfaite pour les matins pressés avant les cours. 5 minutes pour une peau protégée.', 1, 
'1. Nettoyage rapide avec le Nettoyant 3-en-1 (30s)\n2. Sérum Hydratant (30s)\n3. Crème Solaire SPF 50+ (30s)\n4. Baume Lèvres (10s)', 5, 'Débutant', true),

('Routine Soir Détente', 'routine-soir-detente', 'Routine relaxante après une longue journée. Élimine les impuretés et prépare au repos.', 2,
'1. Démaquillage à l''Huile Démaquillante (1min)\n2. Nettoyage doux avec le Nettoyant 3-en-1 (1min)\n3. Sérum Hydratant (30s)\n4. Crème Hydratante Légère (30s)', 3, 'Débutant', true),

('Routine Anti-Imperfections', 'routine-anti-imperfections', 'Spécialement conçue pour les peaux à tendance acnéique. Action ciblée.', 3,
'1. Nettoyage en douceur avec le Nettoyant 3-en-1 (1min)\n2. Gommage doux 2x par semaine (2min)\n3. Soin Anti-Boutons sur zones ciblées (30s)\n4. Crème Hydratante Légère (30s)', 4, 'Intermédiaire', true),

('Routine Week-end Intense', 'routine-week-end-intense', 'Soin complet pour régénérer la peau pendant le week-end. Idéal après les examens.', 1,
'1. Double nettoyage (Huile + Nettoyant) (3min)\n2. Gommage doux (2min)\n3. Masque Détox (15min)\n4. Sérum Hydratant (1min)\n5. Crème Hydratante (1min)', 25, 'Intermédiaire', false),

('Routine Protection Sport', 'routine-protection-sport', 'Protection optimale pendant les activités sportives. Résiste à la transpiration.', 2,
'1. Nettoyage rapide avant le sport (1min)\n2. Crème Solaire SPF 50+ avant de sortir (30s)\n3. Nettoyage après le sport (2min)\n4. Roll-on Anti-Cernes si besoin (30s)', 4, 'Débutant', false);

-- Options de livraison
INSERT INTO delivery_options (name, description, price, delivery_time_min, delivery_time_max, delivery_time_unit, is_active, is_default, is_express, tracking_available, restrictions, sort_order) VALUES
('Livraison Standard', 'Livraison standard avec suivi temps réel', 4.99, 3, 5, 'jours', true, true, false, 'Oui', 'Poids max: 2kg, France métropolitaine', 1),
('Livraison Express', 'Livraison express 24-48h', 9.99, 1, 2, 'jours', true, false, true, 'Oui', 'Poids max: 2kg, France métropolitaine', 2),
('Point Relais', 'Retrait en point relais', 3.99, 2, 4, 'jours', true, false, false, 'Oui', '2500+ points relais disponibles', 3),
('Mondial Relay', 'Livraison économique Mondial Relay', 2.99, 4, 6, 'jours', true, false, false, 'Oui', '6000+ points en France', 4);

-- Programme fidélité
INSERT INTO loyalty_programs (name, description, points_multiplier, discount_percentage, min_points, max_points, is_active, benefits, next_reward, sort_order) VALUES
('Débutant', 'Niveau débutant pour les nouveaux membres', 1.0, 0.0, 0, 99, true, '1 point = 1€ d''achat, Accès aux promotions, Newsletter exclusive, Offre de bienvenue', '10% de réduction à 100 points', 1),
('Étudiant Actif', 'Niveau intermédiaire pour les membres actifs', 1.2, 10.0, 100, 299, true, '1.2x points multiplicateur, -10% sur tous produits, Accès anticipé nouveautés, Échantillons gratuits, Conseils personnalisés', '15% de réduction à 300 points', 2),
('Expert PureSkin', 'Niveau expert pour les membres fidèles', 1.5, 15.0, 300, 599, true, '1.5x points multiplicateur, -15% sur tous produits, Livraison offerte, Produits avant-première, Service client prioritaire, Invitations événements', '20% de réduction à 600 points', 3),
('Ambassadeur', 'Niveau最高 pour les ambassadeurs de la marque', 2.0, 20.0, 600, NULL, true, '2x points multiplicateur, -20% sur tous produits, Livraison offerte express, Box surprise exclusive, Coach personnel, Programme parrainage premium, Cadeaux anniversaire', 'Statut à vie à 1000 points', 4);

-- FAQ
INSERT INTO faqs (question, answer, category, subcategory, is_active, sort_order) VALUES
('Qu''est-ce que PureSkin Étudiant ?', 'PureSkin Étudiant est une marque de produits skincare spécialement conçus pour les étudiants. Nos formules sont adaptées aux problématiques jeunes (acné, stress, budget limité) avec des produits efficaces, abordables et simples d''utilisation.', 'Général', NULL, true, 1),
('Les produits sont-ils testés sur animaux ?', 'Non, absolument pas. PureSkin est une marque cruelty-free. Aucun de nos produits ni ingrédients n''est testé sur animaux. Nous sommes également certifiés vegan pour la plupart de nos produits.', 'Général', NULL, true, 2),
('Quels produits pour peau grasse à tendance acnéique ?', 'Pour peau grasse/acnéique, nous recommandons : 1) Nettoyant Purifiant (matifiant), 2) Sérum Anti-Boutons (localisé), 3) Crème Hydratante Légère non comédogène. Commencez avec le Kit Express Peau Grasse.', 'Produits', 'Type de peau', true, 3),
('Comment passer commande ?', 'Simple en 3 étapes : 1) Choisissez vos produits et ajoutez au panier, 2) Créez votre compte ou connectez-vous, 3) Choisissez livraison et paiement. La commande prend 2 minutes maximum !', 'Commandes', 'Processus', true, 4),
('Quels sont les délais de livraison ?', 'Livraison Standard : 3-5 jours ouvrés (4,99€), Express : 24-48h (9,99€), Point Relais : 2-4 jours (3,99€), Mondial Relay : 4-6 jours (2,99€). Livraison offerte dès 25€ d''achat !', 'Livraison', 'Délais', true, 5);

-- Table utilisateurs pour l'administration
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour optimisation
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Insertion de l'administrateur par défaut
-- Mot de passe: admin123 (hashé avec bcrypt)
INSERT INTO users (username, email, password_hash, first_name, last_name, role, is_active) VALUES
('admin', 'admin@pureskin-etu.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj3QJgusgq4G', 'Admin', 'PureSkin', 'admin', true);

-- Table sessions pour la gestion des connexions
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT
);

-- Index pour les sessions
CREATE INDEX idx_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_sessions_expires_at ON user_sessions(expires_at);

-- Fonction de nettoyage des sessions expirées
CREATE OR REPLACE FUNCTION cleanup_expired_sessions()
RETURNS void AS $$
BEGIN
    DELETE FROM user_sessions WHERE expires_at < CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Table logs d'administration
CREATE TABLE admin_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les logs
CREATE INDEX idx_admin_logs_user_id ON admin_logs(user_id);
CREATE INDEX idx_admin_logs_action ON admin_logs(action);
CREATE INDEX idx_admin_logs_created_at ON admin_logs(created_at);

-- Récompenses fidélité
INSERT INTO loyalty_rewards (title, description, points_required, category, is_active, is_popular, sort_order) VALUES
('-10% sur votre prochaine commande', 'Valable 3 mois sur tous les produits', 100, 'Réduction', true, true, 1),
('Échantillon Sérum Premium', 'Sérum anti-âge 7 jours d''utilisation', 50, 'Produit', true, false, 2),
('Livraison offerte', 'Livraison standard offerte sur votre prochaine commande', 75, 'Service', true, false, 3),
('Box Découverte', '5 produits full-size de notre gamme', 200, 'Produit', true, true, 4),
('Conseil personnalisé', '30 min avec notre experte dermatologique', 150, 'Service', true, false, 5),
('-20% sur commande illimitée', 'Réduction valable 6 mois sans minimum d''achat', 300, 'Réduction', true, true, 6);

-- =============================================
-- RÉSUMÉ DE L'INSTALLATION
-- =============================================
DO $$
BEGIN
    RAISE NOTICE '====================================';
    RAISE NOTICE 'BASE DE DONNÉES PURESKIN ÉTUDIANT';
    RAISE NOTICE 'Installation terminée avec succès !';
    RAISE NOTICE '====================================';
    RAISE NOTICE 'Tables créées: 12';
    RAISE NOTICE 'Produits: %', (SELECT COUNT(*) FROM products);
    RAISE NOTICE 'Articles de blog publiés: %', (SELECT COUNT(*) FROM blog_posts WHERE is_published = true);
    RAISE NOTICE 'Témoignages approuvés: %', (SELECT COUNT(*) FROM testimonials WHERE is_approved = true);
    RAISE NOTICE 'Routines: %', (SELECT COUNT(*) FROM routines);
    RAISE NOTICE 'Options de livraison: %', (SELECT COUNT(*) FROM delivery_options);
    RAISE NOTICE 'Programmes fidélité: %', (SELECT COUNT(*) FROM loyalty_programs);
    RAISE NOTICE 'Questions FAQ: %', (SELECT COUNT(*) FROM faqs);
    RAISE NOTICE 'Récompenses disponibles: %', (SELECT COUNT(*) FROM loyalty_rewards);
    RAISE NOTICE '====================================';
    RAISE NOTICE 'Base de données prête pour la production !';
    RAISE NOTICE '====================================';
END $$;
