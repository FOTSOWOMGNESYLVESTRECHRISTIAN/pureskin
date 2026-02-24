-- Script SQL pour PureSkin Étudiant
-- Création des tables et insertion des données d'exemple

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
-- TABLE DES PANIERS
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
-- INSERTION DES DONNÉES D'EXEMPLE
-- =============================================

-- Produits pour étudiants
INSERT INTO products (name, description, price, original_price, image, badge, stock_quantity, is_active, created_at) VALUES
('Sérum Hydratant Étudiant', 'Sérum hydratant intense spécialement formulé pour les peaux jeunes. Contient de l''acide hyaluronique et de la vitamine C.', 24.99, 34.99, '/images/serum-hydratant.jpg', 'best-seller', 150, true, CURRENT_TIMESTAMP),
('Crème Solaire SPF 50+', 'Protection solaire très haute protection, non grasse, idéale pour le quotidien et le sport.', 18.99, NULL, '/images/creme-solaire.jpg', 'essentiel', 200, true, CURRENT_TIMESTAMP),
('Nettoyant Doux 3-en-1', 'Nettoyant visage doux qui démaquille, nettoie et tonifie en une seule étape. Parfait pour les matins pressés.', 15.99, 22.99, '/images/nettoyant-doux.jpg', 'new', 100, true, CURRENT_TIMESTAMP),
('Masque Détox Week-end', 'Masque détoxifiant à l''argile et au charbon actif. Idéal pour un soin intense après une semaine d''examens.', 12.99, 19.99, '/images/masque-detox.jpg', 'promo', 80, true, CURRENT_TIMESTAMP),
('Baume Lèvres Protecteur', 'Baume lèvres protecteur avec SPF 30. Protège du froid, du vent et du soleil.', 6.99, NULL, '/images/baume-levres.jpg', NULL, 300, true, CURRENT_TIMESTAMP),
('Gommage Doux Visage', 'Gommage enzymatique doux, sans grains, respectueux des peaux sensibles.', 14.99, 21.99, '/images/gommage-doux.jpg', 'best-seller', 90, true, CURRENT_TIMESTAMP),
('Soin Anti-Boutons', 'Gel-crème anti-imperfections, action rapide sur les boutons et points noirs.', 19.99, 29.99, '/images/anti-boutons.jpg', 'urgent', 60, true, CURRENT_TIMESTAMP),
('Huile Démaquillante', 'Huile démaquillante qui élimine même le maquillage waterproof tout en respectant la peau.', 16.99, NULL, '/images/huile-demaquillante.jpg', NULL, 120, true, CURRENT_TIMESTAMP),
('Crème Hydratante Légère', 'Crème hydratante texture gel, non grasse, parfaite pour les peaux mixtes à grasses.', 22.99, 32.99, '/images/creme-hydratante.jpg', 'best-seller', 110, true, CURRENT_TIMESTAMP),
('Roll-on Anti-Cernes', 'Roll-on rafraîchissant pour les cernes et poches sous les yeux. Effet glacé instantané.', 13.99, 19.99, '/images/roll-on-cernes.jpg', 'new', 85, true, CURRENT_TIMESTAMP);

-- Articles de blog
INSERT INTO blog_posts (title, slug, excerpt, content, featured_image, author, reading_time, is_published, published_at, created_at) VALUES
('Les 5 étapes indispensables d''une routine skincare étudiante', 'les-5-etapes-indispensables-routine-skincare-etudiante', 
'Découvrez la routine skincare parfaite adaptée au budget et au rythme de vie étudiant. Simple, efficace et abordable!', 
'Une routine skincare complète ne doit pas être compliquée ni coûteuse. Pour les étudiants, il faut trouver le juste milieu entre efficacité et simplicité. Voici les 5 étapes essentielles : le nettoyage, l''hydratation, la protection solaire, l''exfoliation hebdomadaire et le soin ciblé...', 
'/images/blog-routine-etudiante.jpg', 'Dr. Marie Laurent', 7, true, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days'),

('Comment gérer l''acné pendant les examens ?', 'comment-gerer-acne-pendant-examens', 
'Le stress des examens peut provoquer des poussées d''acné. Découvrez nos astuces pour garder une peau nette.', 
'Le stress libère du cortisol qui stimule la production de sébum. Pendant les périodes d''examens, il est crucial d''adapter sa routine. Nettoyage doux matin et soir, soins anti-boutons ciblés, et surtout ne pas percer les boutons...', 
'/images/blog-acne-examens.jpg', 'Dr. Paul Martin', 5, true, CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '5 days'),

('Budget skincare : les produits qui en valent vraiment la peine', 'budget-skincare-produits-qui-en-valent-la-peine', 
'Investir dans les bons produits sans se ruiner. Notre sélection des meilleurs produits skincare à petit prix.', 
'Le skincare ne doit pas coûter une fortune. Certains produits abordables sont aussi efficaces que les grandes marques. Nous avons testé pour vous les meilleurs nettoyants, crèmes hydratantes et protections solaires à moins de 25€...', 
'/images/blog-budget-skincare.jpg', 'Sophie Dubois', 8, true, CURRENT_TIMESTAMP - INTERVAL '1 week', CURRENT_TIMESTAMP - INTERVAL '1 week'),

('Protection solaire : pourquoi c''est non négociable même en hiver', 'protection-solaire-pourquoi-non-negociable-hiver', 
'Les UV sont présents toute l''année. Découvrez pourquoi la protection solaire est essentielle même en hiver.', 
'Même par temps nuageux en hiver, 80% des UV traversent les nuages. La protection solaire quotidienne prévient le vieillissement prématuré, les taches brunes et le cancer de la peau. Choisissez un SPF 30 minimum...', 
'/images/blog-solaire-hiver.jpg', 'Dr. Thomas Petit', 6, true, CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '10 days');

-- Témoignages clients
INSERT INTO testimonials (customer_name, customer_email, customer_university, customer_age, comment, rating, product_name, is_approved, created_at) VALUES
('Camille Martin', 'camille.m@email.com', 'Sorbonne Université', 20, 'Le sérum hydratant est incroyable ! Ma peau est beaucoup plus douce et les rougeurs ont diminué. Je le recommande vivement !', 5, 'Sérum Hydratant Étudiant', true, CURRENT_TIMESTAMP - INTERVAL '3 days'),
('Lucas Bernard', 'lucas.b@email.com', 'Université de Paris', 22, 'La crème solaire SPF 50+ est parfaite. Texture légère, non grasse, elle protège bien sans laisser de traces blanches.', 5, 'Crème Solaire SPF 50+', true, CURRENT_TIMESTAMP - INTERVAL '1 week'),
('Emma Dubois', 'emma.d@email.com', 'École Polytechnique', 21, 'Le nettoyant 3-en-1 m''a fait gagner énormément de temps le matin. Plus besoin de 3 produits différents !', 4, 'Nettoyant Doux 3-en-1', true, CURRENT_TIMESTAMP - INTERVAL '2 weeks'),
('Hugo Petit', 'hugo.p@email.com', 'Université Lyon 1', 19, 'Le masque détox est super efficace après une semaine de révisions. Ma peau est plus nette et lumineuse.', 5, 'Masque Détox Week-end', true, CURRENT_TIMESTAMP - INTERVAL '4 days'),
('Chloé Robert', 'chloe.r@email.com', 'Sciences Po Paris', 23, 'Le soin anti-boutons a sauvé ma peau pendant les partiels. Action rapide sur les imperfections sans irriter.', 4, 'Soin Anti-Boutons', true, CURRENT_TIMESTAMP - INTERVAL '5 days'),
('Antoine Leroy', 'antoine.l@email.com', 'Université de Montpellier', 20, 'Le baume lèvres est excellent. Protège bien du soleil et du vent. Je l''emporte partout avec moi.', 5, 'Baume Lèvres Protecteur', true, CURRENT_TIMESTAMP - INTERVAL '1 week'),
('Léa Martinez', 'lea.m@email.com', 'Université Bordeaux', 22, 'La crème hydratante légère est parfaite pour ma peau mixte. Pas d''effet brillant, bonne tenue toute la journée.', 5, 'Crème Hydratante Légère', true, CURRENT_TIMESTAMP - INTERVAL '6 days'),
('Mathieu Durand', 'mathieu.d@email.com', 'ENS Paris', 21, 'Le roll-on anti-cernes est mon sauveur pendant les révisions nocturnes. Effet décongestionnant immédiat !', 4, 'Roll-on Anti-Cernes', true, CURRENT_TIMESTAMP - INTERVAL '3 days');

-- Routines de soin
INSERT INTO routines (name, slug, description, skin_type_id, steps, duration_minutes, difficulty_level, is_recommended, created_at) VALUES
('Routine Express Matin', 'routine-express-matin', 'Parfaite pour les matins pressés avant les cours. 5 minutes pour une peau protégée et hydratée.', 1, 
'1. Nettoyage rapide avec le Nettoyant 3-en-1 (30s)\n2. Sérum Hydratant (30s)\n3. Crème Solaire SPF 50+ (30s)\n4. Baume Lèvres (10s)', 5, 'Débutant', true, CURRENT_TIMESTAMP),

('Routine Soir Détente', 'routine-soir-detente', 'Routine relaxante après une longue journée de cours. Élimine les impuretés et prépare la peau au repos.', 2,
'1. Démaquillage à l''Huile Démaquillante (1min)\n2. Nettoyage doux avec le Nettoyant 3-en-1 (1min)\n3. Sérum Hydratant (30s)\n4. Crème Hydratante Légère (30s)', 3, 'Débutant', true, CURRENT_TIMESTAMP),

('Routine Anti-Imperfections', 'routine-anti-imperfections', 'Spécialement conçue pour les peaux à tendance acnéique. Action ciblée sur les boutons et points noirs.', 3,
'1. Nettoyage en douceur avec le Nettoyant 3-en-1 (1min)\n2. Gommage doux 2x par semaine (2min)\n3. Soin Anti-Boutons sur les zones ciblées (30s)\n4. Crème Hydratante Légère non comédogène (30s)', 4, 'Intermédiaire', true, CURRENT_TIMESTAMP),

('Routine Week-end Intense', 'routine-week-end-intense', 'Soin complet pour régénérer la peau pendant le week-end. Idéal après une semaine d''examens.', 1,
'1. Double nettoyage (Huile + Nettoyant) (3min)\n2. Gommage doux (2min)\n3. Masque Détox (15min)\n4. Sérum Hydratant (1min)\n5. Crème Hydratante (1min)', 25, 'Intermédiaire', false, CURRENT_TIMESTAMP),

('Routine Protection Sport', 'routine-protection-sport', 'Protection optimale pendant les activités sportives. Résiste à la transpiration et protège du soleil.', 2,
'1. Nettoyage rapide avant le sport (1min)\n2. Crème Solaire SPF 50+ avant de sortir (30s)\n3. Nettoyage après le sport (2min)\n4. Roll-on Anti-Cernes si besoin (30s)', 4, 'Débutant', false, CURRENT_TIMESTAMP);

-- Afficher un résumé des données insérées
DO $$
BEGIN
    RAISE NOTICE '=== Données insérées avec succès ===';
    RAISE NOTICE 'Produits: %', (SELECT COUNT(*) FROM products);
    RAISE NOTICE 'Articles de blog: %', (SELECT COUNT(*) FROM blog_posts WHERE is_published = true);
    RAISE NOTICE 'Témoignages approuvés: %', (SELECT COUNT(*) FROM testimonials WHERE is_approved = true);
    RAISE NOTICE 'Routines: %', (SELECT COUNT(*) FROM routines);
    RAISE NOTICE '====================================';
END $$;
