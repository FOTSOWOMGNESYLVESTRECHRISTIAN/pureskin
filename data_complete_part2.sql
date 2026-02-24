-- =============================================
-- TEMOIGNAGES
-- =============================================
INSERT INTO testimonials (customer_name, customer_email, customer_avatar, customer_university, customer_age, customer_city, comment, rating, product_name, is_verified_purchase, is_approved, helpful_count) VALUES
('Camille Martin', 'camille.m@email.com', '/images/avatars/camille.jpg', 'Sorbonne Université', 20, 'Paris', 'Le sérum hydratant est incroyable ! Ma peau est beaucoup plus douce et les rougeurs ont diminué. Je l''utilise matin et soir depuis 2 mois.', 5, 'Sérum Hydratant Étudiant', true, true, 45),
('Lucas Bernard', 'lucas.b@email.com', '/images/avatars/lucas.jpg', 'Université de Paris', 22, 'Paris', 'La crème solaire SPF 50+ est parfaite. Texture légère, non grasse, sans traces blanches. Je l''emporte partout.', 5, 'Crème Solaire SPF 50+', true, true, 38),
('Emma Dubois', 'emma.d@email.com', '/images/avatars/emma.jpg', 'École Polytechnique', 21, 'Palaiseau', 'Le nettoyant 3-en-1 m''a fait gagner énormément de temps le matin. Plus besoin de 3 produits différents !', 4, 'Nettoyant Doux 3-en-1', true, true, 29),
('Hugo Petit', 'hugo.p@email.com', '/images/avatars/hugo.jpg', 'Université Lyon 1', 19, 'Lyon', 'Le masque détox est super efficace après une semaine de révisions. Ma peau est plus nette et lumineuse.', 5, 'Masque Détox Week-end', true, true, 52),
('Chloé Robert', 'chloe.r@email.com', '/images/avatars/chloe.jpg', 'Sciences Po Paris', 23, 'Paris', 'Le soin anti-boutons a sauvé ma peau pendant les partiels. Action rapide sans irriter.', 4, 'Soin Anti-Boutons', true, true, 41),
('Antoine Leroy', 'antoine.l@email.com', '/images/avatars/antoine.jpg', 'Université de Montpellier', 20, 'Montpellier', 'Le baume lèvres est excellent. Protège bien du soleil et du vent. Je l''emporte partout avec moi.', 5, 'Baume Lèvres Protecteur', true, true, 33),
('Léa Martinez', 'lea.m@email.com', '/images/avatars/lea.jpg', 'Université Bordeaux', 22, 'Bordeaux', 'La crème hydratante légère est parfaite pour ma peau mixte. Pas d''effet brillant, bonne tenue toute la journée.', 5, 'Crème Hydratante Légère', true, true, 47),
('Mathieu Durand', 'mathieu.d@email.com', '/images/avatars/mathieu.jpg', 'ENS Paris', 21, 'Paris', 'Le roll-on anti-cernes est mon sauveur pendant les révisions nocturnes. Effet décongestionnant immédiat !', 4, 'Roll-on Anti-Cernes', true, true, 36),
('Sarah Lefebvre', 'sarah.l@email.com', '/images/avatars/sarah.jpg', 'Université Lille', 19, 'Lille', 'Le gommage doux est parfait pour ma peau sensible. Pas d''irritation, peau douce après utilisation.', 5, 'Gommage Doux Visage', true, true, 28),
('Nicolas Petit', 'nicolas.p@email.com', '/images/avatars/nicolas.jpg', 'Université Grenoble', 24, 'Grenoble', 'L''huile démaquillante élimine parfaitement le maquillage waterproof. Ma peau est propre sans être tirée.', 4, 'Huile Démaquillante', true, true, 31),
('Julie Moreau', 'julie.m@email.com', '/images/avatars/julie.jpg', 'Université Nice', 20, 'Nice', 'Le contour des yeux a réduit mes poches matinales. Texture fine et pénétrante.', 4, 'Contour des Yeux', true, true, 25),
('Thomas Bernard', 'thomas.b@email.com', '/images/avatars/thomas.jpg', 'Université Strasbourg', 22, 'Strasbourg', 'Le masque hydratant est super pour un coup d''éclat avant une soirée. Peau rebondie instantanément.', 5, 'Masque Visage Hydratant', true, true, 39),
('Manon Robert', 'manon.r@email.com', '/images/avatars/manon.jpg', 'Université Toulouse', 21, 'Toulouse', 'Le sérum anti-âge préventif est parfait pour mon âge. Texture légère et absorption rapide.', 4, 'Sérum Anti-Âge', true, true, 22),
('Alexandre Dubois', 'alexandre.d@email.com', '/images/avatars/alexandre.jpg', 'Université Nantes', 23, 'Nantes', 'La brume solaire est très pratique pour les retouches dans la journée. Invisible et efficace.', 5, 'Brume Solaire SPF 30', true, true, 27),
('Clara Martinez', 'clara.m@email.com', '/images/avatars/clara.jpg', 'Université Rennes', 20, 'Rennes', 'Le stick solaire teinté unifie ma peau tout en la protégeant. Parfait pour les journées chargées.', 4, 'Stick Solaire Teinté SPF 50', true, true, 34),
('Maxime Leroy', 'maxime.l@email.com', '/images/avatars/maxime.jpg', 'Université Clermont', 19, 'Clermont-Ferrand', 'L''après-soleil apaise parfaitement les coups de soleil légers. Effet rafraîchissant.', 5, 'Après-Soleil Apaisant', true, true, 30);

-- =============================================
-- ROUTINES DE SOIN
-- =============================================
INSERT INTO routines (name, slug, description, image, skin_type, skin_concerns, steps, duration_minutes, difficulty_level, products_needed, is_recommended, view_count) VALUES
('Routine Express Matin', 'routine-express-matin', 'Parfaite pour les matins pressés avant les cours. 5 minutes pour une peau protégée et hydratée.', '/images/routines/matin-express.jpg', 'Toutes', 'Aucun', 
'1. Nettoyage rapide avec le Nettoyant 3-en-1 (30s)\n2. Sérum Hydratant (30s)\n3. Crème Solaire SPF 50+ (30s)\n4. Baume Lèvres (10s)', 5, 'Débutant', 'Nettoyant 3-en-1, Sérum Hydratant, Crème Solaire, Baume Lèvres', true, 3421),

('Routine Soir Détente', 'routine-soir-detente', 'Routine relaxante après une longue journée. Élimine les impuretés et prépare la peau au repos.', '/images/routines/soir-detente.jpg', 'Toutes', 'Fatigue, stress', 
'1. Démaquillage à l''Huile Démaquillante (1min)\n2. Nettoyage doux avec le Nettoyant 3-en-1 (1min)\n3. Sérum Hydratant (30s)\n4. Crème Hydratante Légère (30s)', 3, 'Débutant', 'Huile Démaquillante, Nettoyant 3-en-1, Sérum Hydratant, Crème Hydratante', true, 2876),

('Routine Anti-Imperfections', 'routine-anti-imperfections', 'Spécialement conçue pour les peaux à tendance acnéique. Action ciblée sur les boutons.', '/images/routines/anti-imperfections.jpg', 'Mixte à grasse', 'Acné, points noirs, pores dilatés', 
'1. Nettoyage en douceur avec le Nettoyant 3-en-1 (1min)\n2. Gommage doux 2x par semaine (2min)\n3. Soin Anti-Boutons sur zones ciblées (30s)\n4. Crème Hydratante Légère (30s)', 4, 'Intermédiaire', 'Nettoyant 3-en-1, Gommage Doux, Soin Anti-Boutons, Crème Hydratante', true, 3156),

('Routine Week-end Intense', 'routine-week-end-intense', 'Soin complet pour régénérer la peau pendant le week-end. Idéal après les examens.', '/images/routines/week-end-intense.jpg', 'Toutes', 'Peau terne, stress', 
'1. Double nettoyage (Huile + Nettoyant) (3min)\n2. Gommage doux (2min)\n3. Masque Détox (15min)\n4. Sérum Hydratant (1min)\n5. Crème Hydratante (1min)', 25, 'Intermédiaire', 'Huile Démaquillante, Nettoyant 3-en-1, Gommage Doux, Masque Détox, Sérum, Crème', false, 1987),

('Routine Protection Sport', 'routine-protection-sport', 'Protection optimale pendant les activités sportives. Résiste à la transpiration.', '/images/routines/protection-sport.jpg', 'Toutes', 'Transpiration, soleil', 
'1. Nettoyage rapide avant le sport (1min)\n2. Crème Solaire SPF 50+ avant de sortir (30s)\n3. Nettoyage après le sport (2min)\n4. Roll-on Anti-Cernes si besoin (30s)', 4, 'Débutant', 'Nettoyant 3-en-1, Crème Solaire, Roll-on Anti-Cernes', false, 1456),

('Routine Peau Sèche', 'routine-peau-seche', 'Spécialement conçue pour les peaux sèches et sensibles. Hydratation intense et protection.', '/images/routines/peau-seche.jpg', 'Sèche', 'Déshydratation, tiraillements', 
'1. Lait Démaquillant doux (1min)\n2. Tonique Rafraîchissant (30s)\n3. Sérum Hydratant (30s)\n4. Crème Hydratante riche (30s)\n5. Baume Lèvres (10s)', 4, 'Débutant', 'Lait Démaquillant, Tonique, Sérum Hydratant, Crème Hydratante, Baume Lèvres', true, 2234),

('Routine Anti-Âge Préventif', 'routine-anti-age-preventif', 'Prévention du vieillissement cutané pour les 20-30 ans. Antioxydants et protection.', '/images/routines/anti-age-preventif.jpg', 'Toutes', 'Prévention, premier signes', 
'1. Nettoyage doux (1min)\n2. Sérum Anti-Âge (30s)\n3. Contour des Yeux (30s)\n4. Crème Hydratante (30s)\n5. Crème Solaire (30s)', 3, 'Intermédiaire', 'Nettoyant 3-en-1, Sérum Anti-Âge, Contour des Yeux, Crème Hydratante, Crème Solaire', false, 1876),

('Routine Soirée Spéciale', 'routine-soiree-speciale', 'Routine glow pour un éclat maximum avant une soirée ou un événement spécial.', '/images/routines/soiree-speciale.jpg', 'Toutes', 'Éclat, événement spécial', 
'1. Double nettoyage (3min)\n2. Gommage éclat (2min)\n3. Masque hydratant (15min)\n4. Sérum éclat (1min)\n5. Crème glow (1min)', 25, 'Avancé', 'Huile Démaquillante, Nettoyant, Gommage, Masque, Sérum, Crème Glow', false, 1234);

-- =============================================
-- CLIENTS
-- =============================================
INSERT INTO customers (email, password_hash, first_name, last_name, phone, birth_date, gender, university, study_field, graduation_year, skin_type, skin_concerns, is_verified, is_active, created_at) VALUES
('camille.m@email.com', '$2a$10$...', 'Camille', 'Martin', '0612345678', '2004-03-15', 'F', 'Sorbonne Université', 'Droit', 2026, 'Mixte', 'Acné occasionnelle', true, true, CURRENT_TIMESTAMP - INTERVAL '6 months'),
('lucas.b@email.com', '$2a$10$...', 'Lucas', 'Bernard', '0623456789', '2002-07-22', 'M', 'Université de Paris', 'Informatique', 2025, 'Normale', 'Déshydratation', true, true, CURRENT_TIMESTAMP - INTERVAL '8 months'),
('emma.d@email.com', '$2a$10$...', 'Emma', 'Dubois', '0634567890', '2003-11-08', 'F', 'École Polytechnique', 'Mathématiques', 2025, 'Sèche', 'Sensibilité', true, true, CURRENT_TIMESTAMP - INTERVAL '4 months'),
('hugo.p@email.com', '$2a$10$...', 'Hugo', 'Petit', '0645678901', '2005-01-30', 'M', 'Université Lyon 1', 'Médecine', 2027, 'Grasse', 'Acné', true, true, CURRENT_TIMESTAMP - INTERVAL '3 months'),
('chloe.r@email.com', '$2a$10$...', 'Chloé', 'Robert', '0656789012', '2001-09-12', 'F', 'Sciences Po Paris', 'Sciences Politiques', 2024, 'Mixte', 'Acné, pores dilatés', true, true, CURRENT_TIMESTAMP - INTERVAL '1 year'),
('antoine.l@email.com', '$2a$10$...', 'Antoine', 'Leroy', '0667890123', '2004-06-25', 'M', 'Université de Montpellier', 'Biologie', 2026, 'Normale', 'Aucun', true, true, CURRENT_TIMESTAMP - INTERVAL '5 months'),
('lea.m@email.com', '$2a$10$...', 'Léa', 'Martinez', '0678901234', '2002-12-03', 'F', 'Université Bordeaux', 'Marketing', 2025, 'Mixte', 'Taches brunes', true, true, CURRENT_TIMESTAMP - INTERVAL '7 months'),
('mathieu.d@email.com', '$2a$10$...', 'Mathieu', 'Durand', '0689012345', '2003-04-18', 'M', 'ENS Paris', 'Physique', 2025, 'Sèche', 'Premiers signes âge', true, true, CURRENT_TIMESTAMP - INTERVAL '9 months');

-- =============================================
-- ADRESSES
-- =============================================
INSERT INTO addresses (customer_id, type, is_default, first_name, last_name, address_line1, address_line2, city, postal_code, country, phone) VALUES
(1, 'shipping', true, 'Camille', 'Martin', '15 Rue de la Sorbonne', 'Apt 4B', 'Paris', '75005', 'France', '0612345678'),
(1, 'billing', true, 'Camille', 'Martin', '15 Rue de la Sorbonne', 'Apt 4B', 'Paris', '75005', 'France', '0612345678'),
(2, 'shipping', true, 'Lucas', 'Bernard', '123 Avenue de France', NULL, 'Paris', '75013', 'France', '0623456789'),
(2, 'billing', true, 'Lucas', 'Bernard', '123 Avenue de France', NULL, 'Paris', '75013', 'France', '0623456789'),
(3, 'shipping', true, 'Emma', 'Dubois', 'Route de Saclay', 'Bâtiment X', 'Palaiseau', '91120', 'France', '0634567890'),
(3, 'billing', true, 'Emma', 'Dubois', 'Route de Saclay', 'Bâtiment X', 'Palaiseau', '91120', 'France', '0634567890');

-- =============================================
-- COMMANDES
-- =============================================
INSERT INTO orders (order_number, customer_id, status, payment_status, payment_method, subtotal, shipping_cost, tax_amount, total_amount, shipping_address, billing_address, created_at, shipped_at, delivered_at) VALUES
('PS-2024-001', 1, 'delivered', 'paid', 'credit_card', 74.97, 5.99, 16.10, 97.06, 'Camille Martin, 15 Rue de la Sorbonne, Apt 4B, 75005 Paris, France', 'Camille Martin, 15 Rue de la Sorbonne, Apt 4B, 75005 Paris, France', CURRENT_TIMESTAMP - INTERVAL '2 months', CURRENT_TIMESTAMP - INTERVAL '2 months' + INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 months' + INTERVAL '5 days'),
('PS-2024-002', 2, 'shipped', 'paid', 'paypal', 89.96, 5.99, 19.20, 115.15, 'Lucas Bernard, 123 Avenue de France, 75013 Paris, France', 'Lucas Bernard, 123 Avenue de France, 75013 Paris, France', CURRENT_TIMESTAMP - INTERVAL '1 month', CURRENT_TIMESTAMP - INTERVAL '1 month' + INTERVAL '1 day', NULL),
('PS-2024-003', 3, 'processing', 'paid', 'credit_card', 134.95, 5.99, 28.80, 169.74, 'Emma Dubois, Route de Saclay, Bâtiment X, 91120 Palaiseau, France', 'Emma Dubois, Route de Saclay, Bâtiment X, 91120 Palaiseau, France', CURRENT_TIMESTAMP - INTERVAL '2 weeks', NULL, NULL),
('PS-2024-004', 1, 'pending', 'pending', 'credit_card', 44.97, 5.99, 9.60, 60.56, 'Camille Martin, 15 Rue de la Sorbonne, Apt 4B, 75005 Paris, France', 'Camille Martin, 15 Rue de la Sorbonne, Apt 4B, 75005 Paris, France', CURRENT_TIMESTAMP - INTERVAL '3 days', NULL, NULL);

-- =============================================
-- LIGNES DE COMMANDE
-- =============================================
INSERT INTO order_items (order_id, product_id, product_name, product_image, unit_price, quantity, total_price) VALUES
-- Commande PS-2024-001
(1, 1, 'Sérum Hydratant Étudiant', '/images/serum-hydratant.jpg', 24.99, 2, 49.98),
(1, 2, 'Crème Solaire SPF 50+', '/images/creme-solaire.jpg', 18.99, 1, 18.99),
(1, 3, 'Nettoyant Doux 3-en-1', '/images/nettoyant-doux.jpg', 15.99, 1, 15.99),
-- Commande PS-2024-002
(2, 1, 'Sérum Hydratant Étudiant', '/images/serum-hydratant.jpg', 24.99, 1, 24.99),
(2, 2, 'Crème Solaire SPF 50+', '/images/creme-solaire.jpg', 18.99, 2, 37.98),
(2, 4, 'Masque Détox Week-end', '/images/masque-detox.jpg', 12.99, 2, 25.98),
-- Commande PS-2024-003
(3, 1, 'Sérum Hydratant Étudiant', '/images/serum-hydratant.jpg', 24.99, 2, 49.98),
(3, 2, 'Crème Solaire SPF 50+', '/images/creme-solaire.jpg', 18.99, 2, 37.98),
(3, 5, 'Baume Lèvres Protecteur', '/images/baume-levres.jpg', 6.99, 3, 20.97),
(3, 6, 'Gommage Doux Visage', '/images/gommage-doux.jpg', 14.99, 2, 29.98),
-- Commande PS-2024-004
(4, 1, 'Sérum Hydratant Étudiant', '/images/serum-hydratant.jpg', 24.99, 1, 24.99),
(4, 3, 'Nettoyant Doux 3-en-1', '/images/nettoyant-doux.jpg', 15.99, 1, 15.99),
(4, 5, 'Baume Lèvres Protecteur', '/images/baume-levres.jpg', 6.99, 1, 6.99);

-- =============================================
-- PROMOTIONS
-- =============================================
INSERT INTO promotions (code, name, description, discount_type, discount_value, minimum_amount, usage_limit, usage_count, starts_at, ends_at, is_active) VALUES
('ETUDIANT15', 'Réduction Étudiant', '15% de réduction pour tous les étudiants', 'percentage', 15.00, 30.00, 1000, 234, CURRENT_TIMESTAMP - INTERVAL '1 month', CURRENT_TIMESTAMP + INTERVAL '11 months', true),
('BIENVENUE10', 'Offre de bienvenue', '10% de réduction sur première commande', 'percentage', 10.00, NULL, 1, 567, CURRENT_TIMESTAMP - INTERVAL '6 months', NULL, true),
('LIVRAISON5', 'Livraison offerte', '5€ de réduction sur frais de livraison', 'fixed', 5.00, 50.00, 500, 123, CURRENT_TIMESTAMP - INTERVAL '2 weeks', CURRENT_TIMESTAMP + INTERVAL '2 weeks', true),
('SOLAR25', 'Offre solaire', '25% sur tous les produits solaires', 'percentage', 25.00, NULL, 1000, 89, CURRENT_TIMESTAMP - INTERVAL '1 week', CURRENT_TIMESTAMP + INTERVAL '3 weeks', true);

-- =============================================
-- NEWSLETTER SUBSCRIBERS
-- =============================================
INSERT INTO newsletter_subscribers (email, first_name, is_active, created_at) VALUES
('camille.m@email.com', 'Camille', true, CURRENT_TIMESTAMP - INTERVAL '6 months'),
('lucas.b@email.com', 'Lucas', true, CURRENT_TIMESTAMP - INTERVAL '8 months'),
('emma.d@email.com', 'Emma', true, CURRENT_TIMESTAMP - INTERVAL '4 months'),
('hugo.p@email.com', 'Hugo', true, CURRENT_TIMESTAMP - INTERVAL '3 months'),
('chloe.r@email.com', 'Chloé', true, CURRENT_TIMESTAMP - INTERVAL '1 year'),
('antoine.l@email.com', 'Antoine', true, CURRENT_TIMESTAMP - INTERVAL '5 months'),
('lea.m@email.com', 'Léa', true, CURRENT_TIMESTAMP - INTERVAL '7 months'),
('mathieu.d@email.com', 'Mathieu', true, CURRENT_TIMESTAMP - INTERVAL '9 months'),
('sarah.l@email.com', 'Sarah', true, CURRENT_TIMESTAMP - INTERVAL '2 months'),
('nicolas.p@email.com', 'Nicolas', true, CURRENT_TIMESTAMP - INTERVAL '1 month');

-- =============================================
-- PANIER (exemples de paniers actifs)
-- =============================================
INSERT INTO cart_items (session_id, customer_id, product_id, product_name, product_image, unit_price, quantity) VALUES
('session_abc123', NULL, 1, 'Sérum Hydratant Étudiant', '/images/serum-hydratant.jpg', 24.99, 1),
('session_abc123', NULL, 2, 'Crème Solaire SPF 50+', '/images/creme-solaire.jpg', 18.99, 2),
(NULL, 2, 3, 'Nettoyant Doux 3-en-1', '/images/nettoyant-doux.jpg', 15.99, 1),
(NULL, 2, 5, 'Baume Lèvres Protecteur', '/images/baume-levres.jpg', 6.99, 3);

-- =============================================
-- WISHLIST
-- =============================================
INSERT INTO wishlist_items (customer_id, product_id) VALUES
(1, 1), (1, 6), (1, 9),
(2, 2), (2, 7), (2, 10),
(3, 3), (3, 8), (3, 11),
(4, 4), (4, 12),
(5, 5), (5, 13);

-- Afficher le résumé final
SELECT 'Products' as table_name, COUNT(*) as record_count FROM products
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Blog Posts', COUNT(*) FROM blog_posts WHERE is_published = true
UNION ALL
SELECT 'Testimonials', COUNT(*) FROM testimonials WHERE is_approved = true
UNION ALL
SELECT 'Routines', COUNT(*) FROM routines
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Promotions', COUNT(*) FROM promotions WHERE is_active = true
ORDER BY table_name;
