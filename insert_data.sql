-- Script d'insertion directe pour la base de données pureSkin
-- À exécuter directement dans PostgreSQL

-- Nettoyage des tables existantes (optionnel)
-- TRUNCATE TABLE cart_items, testimonials, routines, blog_posts, products RESTART IDENTITY CASCADE;

-- =============================================
-- PRODUITS
-- =============================================
INSERT INTO products (name, description, price, original_price, image, badge, stock_quantity, is_active) VALUES
('Sérum Hydratant Étudiant', 'Sérum hydratant intense avec acide hyaluronique et vitamine C. Peaux jeunes.', 24.99, 34.99, '/images/serum-hydratant.jpg', 'best-seller', 150, true),
('Crème Solaire SPF 50+', 'Protection solaire très haute protection, non grasse, idéale pour le quotidien.', 18.99, NULL, '/images/creme-solaire.jpg', 'essentiel', 200, true),
('Nettoyant Doux 3-en-1', 'Démaquille, nettoie et tonifie en une seule étape. Parfait pour les matins pressés.', 15.99, 22.99, '/images/nettoyant-doux.jpg', 'new', 100, true),
('Masque Détox Week-end', 'Masque détoxifiant à l''argile et au charbon actif. Idéal après les examens.', 12.99, 19.99, '/images/masque-detox.jpg', 'promo', 80, true),
('Baume Lèvres Protecteur', 'Baume lèvres avec SPF 30. Protège du froid, du vent et du soleil.', 6.99, NULL, '/images/baume-levres.jpg', NULL, 300, true),
('Gommage Doux Visage', 'Gommage enzymatique doux, sans grains, respectueux des peaux sensibles.', 14.99, 21.99, '/images/gommage-doux.jpg', 'best-seller', 90, true),
('Soin Anti-Boutons', 'Gel-crème anti-imperfections, action rapide sur les boutons et points noirs.', 19.99, 29.99, '/images/anti-boutons.jpg', 'urgent', 60, true),
('Huile Démaquillante', 'Huile démaquillante qui élimine même le maquillage waterproof.', 16.99, NULL, '/images/huile-demaquillante.jpg', NULL, 120, true),
('Crème Hydratante Légère', 'Crème hydratante texture gel, non grasse, pour peaux mixtes à grasses.', 22.99, 32.99, '/images/creme-hydratante.jpg', 'best-seller', 110, true),
('Roll-on Anti-Cernes', 'Roll-on rafraîchissant pour les cernes et poches. Effet glacé instantané.', 13.99, 19.99, '/images/roll-on-cernes.jpg', 'new', 85, true);

-- =============================================
-- ARTICLES DE BLOG
-- =============================================
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

-- =============================================
-- TEMOIGNAGES
-- =============================================
INSERT INTO testimonials (customer_name, customer_email, customer_university, customer_age, comment, rating, product_name, is_approved) VALUES
('Camille Martin', 'camille.m@email.com', 'Sorbonne Université', 20, 'Le sérum hydratant est incroyable ! Ma peau est beaucoup plus douce et les rougeurs ont diminué.', 5, 'Sérum Hydratant Étudiant', true),
('Lucas Bernard', 'lucas.b@email.com', 'Université de Paris', 22, 'La crème solaire SPF 50+ est parfaite. Texture légère, non grasse, sans traces blanches.', 5, 'Crème Solaire SPF 50+', true),
('Emma Dubois', 'emma.d@email.com', 'École Polytechnique', 21, 'Le nettoyant 3-en-1 m''a fait gagner énormément de temps le matin. Plus besoin de 3 produits !', 4, 'Nettoyant Doux 3-en-1', true),
('Hugo Petit', 'hugo.p@email.com', 'Université Lyon 1', 19, 'Le masque détox est super efficace après une semaine de révisions. Peau plus nette et lumineuse.', 5, 'Masque Détox Week-end', true),
('Chloé Robert', 'chloe.r@email.com', 'Sciences Po Paris', 23, 'Le soin anti-boutons a sauvé ma peau pendant les partiels. Action rapide sans irriter.', 4, 'Soin Anti-Boutons', true),
('Antoine Leroy', 'antoine.l@email.com', 'Université de Montpellier', 20, 'Le baume lèvres est excellent. Protège bien du soleil et du vent. Je l''emporte partout.', 5, 'Baume Lèvres Protecteur', true),
('Léa Martinez', 'lea.m@email.com', 'Université Bordeaux', 22, 'La crème hydratante légère est parfaite pour ma peau mixte. Pas d''effet brillant, bonne tenue.', 5, 'Crème Hydratante Légère', true),
('Mathieu Durand', 'mathieu.d@email.com', 'ENS Paris', 21, 'Le roll-on anti-cernes est mon sauveur pendant les révisions nocturnes. Effet décongestionnant !', 4, 'Roll-on Anti-Cernes', true);

-- =============================================
-- ROUTINES DE SOIN
-- =============================================
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

-- Afficher le résumé
SELECT 'Products' as table_name, COUNT(*) as record_count FROM products
UNION ALL
SELECT 'Blog Posts', COUNT(*) FROM blog_posts WHERE is_published = true
UNION ALL
SELECT 'Testimonials', COUNT(*) FROM testimonials WHERE is_approved = true
UNION ALL
SELECT 'Routines', COUNT(*) FROM routines
ORDER BY table_name;
