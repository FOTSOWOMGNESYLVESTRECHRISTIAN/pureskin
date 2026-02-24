-- =============================================
-- DONNÉES CORRIGÉES PURESKIN ÉTUDIANT
-- Sans slugs dupliqués
-- =============================================

-- =============================================
-- CATÉGORIES
-- =============================================
INSERT INTO categories (name, slug, description, icon) VALUES
('Visage', 'visage', 'Soins complets pour le visage', '/icons/face.svg'),
('Corps', 'corps', 'Hydratation et soin du corps', '/icons/body.svg'),
('Solaire', 'solaire', 'Protection solaire pour tous types', '/icons/sun.svg'),
('Hydratation', 'hydratation', 'Produits hydratants intenses', '/icons/drop.svg'),
('Anti-acné', 'anti-acne', 'Solutions contre les imperfections', '/icons/shield.svg'),
('Nettoyage', 'nettoyage', 'Nettoyants et démaquillants', '/icons/clean.svg');

-- =============================================
-- PRODUITS (avec slugs uniques)
-- =============================================
INSERT INTO products (category_id, name, slug, description, price, original_price, image, badge, stock_quantity, is_active, is_featured, rating_average, review_count) VALUES
-- Visage
(1, 'Sérum Hydratant Étudiant', 'serum-hydratant-etudiant', 'Sérum hydratant intense avec acide hyaluronique et vitamine C.', 24.99, 34.99, '/images/serum-hydratant.jpg', 'best-seller', 150, true, true, 4.5, 234),
(1, 'Crème Hydratante Légère', 'creme-hydratante-legere', 'Crème jour texture gel, non grasse, parfaite pour peaux mixtes.', 22.99, 32.99, '/images/creme-hydratante.jpg', 'best-seller', 110, true, true, 4.3, 189),
(1, 'Baume Lèvres Protecteur', 'baume-levres-protecteur', 'Baume lèvres avec SPF 30. Protège du froid et du soleil.', 6.99, NULL, '/images/baume-levres.jpg', NULL, 300, true, false, 4.7, 156),
(1, 'Roll-on Anti-Cernes', 'roll-on-anti-cernes', 'Roll-on rafraîchissant pour cernes et poches. Effet glacé.', 13.99, 19.99, '/images/roll-on-cernes.jpg', 'new', 85, true, false, 4.2, 78),
(1, 'Contour des Yeux', 'contour-des-yeux', 'Crème contour des yeux anti-âge et anti-poches.', 18.99, 26.99, '/images/contour-yeux.jpg', 'promo', 70, true, false, 4.4, 92),
(1, 'Masque Visage Hydratant', 'masque-visage-hydratant', 'Masque tissu hydratant à l''aloe vera. Effet coup d''éclat.', 8.99, 14.99, '/images/masque-hydratant.jpg', 'new', 120, true, false, 4.6, 145),
(1, 'Gommage Doux Visage', 'gommage-doux-visage', 'Gommage enzymatique doux, sans grains, respectueux des peaux sensibles.', 14.99, 21.99, '/images/gommage-doux.jpg', 'best-seller', 90, true, true, 4.5, 201),
(1, 'Huile Démaquillante', 'huile-demaquillante-visage', 'Huile démaquillante qui élimine même le maquillage waterproof.', 16.99, NULL, '/images/huile-demaquillante.jpg', NULL, 120, true, false, 4.3, 167),
(1, 'Tonique Rafraîchissant', 'tonique-rafraichissant', 'Tonique sans alcool à l''eau de rose. Apaise et prépare la peau.', 12.99, 18.99, '/images/tonique.jpg', NULL, 95, true, false, 4.4, 123),
(1, 'Sérum Anti-Âge', 'serum-anti-age-visage', 'Sérum anti-âge préventif pour les 20-30 ans. Rétinol doux.', 28.99, 39.99, '/images/serum-anti-age.jpg', 'premium', 60, true, false, 4.6, 89),

-- Solaire
(3, 'Crème Solaire SPF 50+', 'creme-solaire-spf50', 'Protection solaire très haute protection, non grasse.', 18.99, NULL, '/images/creme-solaire.jpg', 'essentiel', 200, true, true, 4.8, 312),
(3, 'Brume Solaire SPF 30', 'brume-solaire-spf30', 'Brume solaire pratique pour les retouches. Texture invisible.', 15.99, 22.99, '/images/brume-solaire.jpg', 'new', 80, true, false, 4.5, 98),
(3, 'Stick Solaire Teinté SPF 50', 'stick-solaire-teinte', 'Stick solaire teinté pour unifier et protéger en un geste.', 14.99, 19.99, '/images/stick-solaire.jpg', 'new', 65, true, false, 4.3, 76),
(3, 'Après-Soleil Apaisant', 'apres-soleil-apaisant', 'Lotion après-soleil à l''aloe vera. Apaise les coups de soleil.', 16.99, 24.99, '/images/apres-soleil.jpg', NULL, 90, true, false, 4.7, 134),
(3, 'Protection Lèvres SPF 50', 'protection-levres-spf50', 'Stick lèvres protection solaire maximale. Résistant à l''eau.', 7.99, NULL, '/images/stick-levres.jpg', NULL, 150, true, false, 4.4, 89),
(3, 'Solaire Peaux Sensibles', 'solaire-peaux-sensibles', 'Crème solaire spécialement formulée pour les peaux sensibles.', 21.99, 29.99, '/images/solaire-sensible.jpg', NULL, 70, true, false, 4.6, 112),
(3, 'Solaire Sport SPF 50+', 'solaire-sport-spf50', 'Protection solaire très résistante, parfaite pour le sport.', 19.99, NULL, '/images/solaire-sport.jpg', NULL, 85, true, false, 4.7, 145),
(3, 'Auto-bronzant Visage', 'auto-bronzant-visage', 'Auto-bronzant progressif pour teint hâlé naturel.', 17.99, 25.99, '/images/auto-bronzant.jpg', 'promo', 55, true, false, 4.2, 67),
(3, 'Gouttes Solaire SPF 50', 'gouttes-solaire-spf50', 'Gouttes solaires invisibles à mélanger à votre crème habituelle.', 22.99, 32.99, '/images/gouttes-solaire.jpg', 'new', 45, true, false, 4.5, 43),
(3, 'Poudre Solaire Matifiante', 'poudre-solaire-matifiante', 'Poudre solaire matifiante pour retouches tout au long de la journée.', 16.99, 23.99, '/images/poudre-solaire.jpg', NULL, 60, true, false, 4.3, 78),

-- Anti-acné
(5, 'Soin Anti-Boutons', 'soin-anti-boutons', 'Gel-crème anti-imperfections, action rapide sur les boutons.', 19.99, 29.99, '/images/anti-boutons.jpg', 'urgent', 60, true, true, 4.4, 278),
(5, 'Nettoyant Anti-Acné', 'nettoyant-anti-acne', 'Gel nettoyant purifiant à l''acide salicylique. Combat les imperfections.', 14.99, 21.99, '/images/nettoyant-acne.jpg', 'best-seller', 95, true, false, 4.5, 234),
(5, 'Masque Anti-Acné', 'masque-anti-acne', 'Masque à l''argile et au thé vert. Purifie et resserre les pores.', 9.99, 15.99, '/images/masque-acne.jpg', NULL, 110, true, false, 4.3, 189),
(5, 'Sérum Anti-Taches', 'serum-anti-taches', 'Sérum éclaircissant à la vitamine C et niacinamide. Unifie le teint.', 24.99, 34.99, '/images/serum-taches.jpg', 'premium', 50, true, false, 4.6, 98),
(5, 'Crème Correctrice', 'creme-correctrice', 'Crème correctrice pour imperfections localisées. Action ciblée.', 12.99, 18.99, '/images/creme-correctrice.jpg', NULL, 75, true, false, 4.2, 145),
(5, 'Patchs Anti-Boutons', 'patchs-anti-boutons', 'Patchs hydrocolloïdes pour boutons. Accélèrent la cicatrisation.', 8.99, 14.99, '/images/patchs-boutons.jpg', 'new', 130, true, false, 4.4, 167),
(5, 'Exfoliant Doux', 'exfoliant-doux-acne', 'Exfoliant enzymatique doux pour peaux sensibles à tendance acnéique.', 16.99, 24.99, '/images/exfoliant-doux.jpg', NULL, 80, true, false, 4.5, 123),
(5, 'Eau Micellaire Purifiante', 'eau-micellaire-purifiante', 'Eau micellaire purifiante sans alcool. Démaquille et purifie.', 11.99, 16.99, '/images/eau-micellaire.jpg', NULL, 140, true, false, 4.3, 201),
(5, 'Sérum Régulateur', 'serum-regulateur', 'Sérum régulateur de sébum. Matifie et réduit l''excès de sébum.', 22.99, 32.99, '/images/serum-regulateur.jpg', 'best-seller', 65, true, false, 4.4, 156),
(5, 'Crème SOS Boutons', 'creme-sos-boutons', 'Crème SOS pour boutons enflammés. Action apaisante immédiate.', 15.99, 22.99, '/images/creme-sos.jpg', NULL, 55, true, false, 4.6, 89),

-- Nettoyage
(6, 'Nettoyant Doux 3-en-1', 'nettoyant-doux-3-en-1', 'Démaquille, nettoie et tonifie en une seule étape.', 15.99, 22.99, '/images/nettoyant-doux.jpg', 'new', 100, true, true, 4.6, 312),
(6, 'Huile Démaquillante Nettoyante', 'huile-demaquillante-nettoyante', 'Huile démaquillante qui élimine même le maquillage waterproof.', 16.99, NULL, '/images/huile-demaquillante.jpg', NULL, 120, true, false, 4.5, 267),
(6, 'Gel Moussant Purifiant', 'gel-moussant-purifiant', 'Gel moussant purifiant au tea tree. Nettoie en profondeur.', 13.99, 19.99, '/images/gel-moussant.jpg', NULL, 85, true, false, 4.4, 189),
(6, 'Lait Démaquillant', 'lait-demaquillant', 'Lait démaquillant doux pour peaux sèches et sensibles.', 14.99, 21.99, '/images/lait-demaquillant.jpg', NULL, 90, true, false, 4.5, 145),
(6, 'Eau Micellaire Universelle', 'eau-micellaire-universelle', 'Eau micellaire pour tous types de peau. Démaquille et apaise.', 9.99, 14.99, '/images/eau-micellaire.jpg', NULL, 160, true, false, 4.3, 234),
(6, 'Mouchoir Démaquillant', 'mouchoir-demaquillant', 'Mouchoirs démaquillants pratiques pour voyager et retouches.', 7.99, 11.99, '/images/mouchoir-demaquillant.jpg', 'new', 200, true, false, 4.2, 178),
(6, 'Double Nettoyant', 'double-nettoyant', 'Set double nettoyage : huile + gel pour un nettoyage parfait.', 25.99, 35.99, '/images/double-nettoyant.jpg', 'best-seller', 70, true, false, 4.7, 201),
(6, 'Mousse Nettoyante', 'mousse-nettoyante', 'Mousse nettoyante onctueuse et parfumée. Nettoie en douceur.', 12.99, 18.99, '/images/mousse-nettoyante.jpg', NULL, 110, true, false, 4.4, 156),
(6, 'Gommage Nettoyant', 'gommage-nettoyant', 'Gommage nettoyant quotidien micro-grains. Exfolie en douceur.', 15.99, 22.99, '/images/gommage-nettoyant.jpg', NULL, 80, true, false, 4.3, 123),
(6, 'Démaquillant Yeux', 'demaquillant-yeux', 'Démaquillant yeux biphasé pour maquillage waterproof résistant.', 11.99, 16.99, '/images/demaquillant-yeux.jpg', NULL, 95, true, false, 4.5, 167);

-- =============================================
-- ARTICLES DE BLOG
-- =============================================
INSERT INTO blog_posts (title, slug, excerpt, content, featured_image, author, author_avatar, reading_time, category, tags, view_count, is_published, published_at) VALUES
('Les 5 étapes indispensables d''une routine skincare étudiante', 'les-5-etapes-indispensables-routine-skincare-etudiante', 
'Découvrez la routine skincare parfaite adaptée au budget et au rythme de vie étudiant.', 
'Une routine skincare complète ne doit pas être compliquée ni coûteuse...', 
'/images/blog-routine-etudiante.jpg', 'Dr. Marie Laurent', '/images/authors/marie-laurent.jpg', 7, 'Routine', 'routine,etudiant,budget', 2456, true, CURRENT_TIMESTAMP - INTERVAL '2 days'),

('Comment gérer l''acné pendant les examens ?', 'comment-gerer-acne-pendant-examens', 
'Le stress des examens peut provoquer des poussées d''acné. Découvrez nos astuces.', 
'Le stress libère du cortisol qui stimule la production de sébum...', 
'/images/blog-acne-examens.jpg', 'Dr. Paul Martin', '/images/authors/paul-martin.jpg', 5, 'Acné', 'acne,examens,stress', 1823, true, CURRENT_TIMESTAMP - INTERVAL '5 days'),

('Budget skincare : les produits qui en valent vraiment la peine', 'budget-skincare-produits-qui-en-valent-la-peine', 
'Investir dans les bons produits sans se ruiner. Notre sélection des meilleurs produits.', 
'Le skincare ne doit pas coûter une fortune. Certains produits abordables...', 
'/images/blog-budget-skincare.jpg', 'Sophie Dubois', '/images/authors/sophie-dubois.jpg', 8, 'Budget', 'budget,skincare,etudiant', 3124, true, CURRENT_TIMESTAMP - INTERVAL '1 week'),

('Protection solaire : pourquoi c''est non négociable même en hiver', 'protection-solaire-pourquoi-non-negociable-hiver', 
'Les UV sont présents toute l''année. Découvrez pourquoi la protection solaire est essentielle.', 
'Même par temps nuageux en hiver, 80% des UV traversent les nuages...', 
'/images/blog-solaire-hiver.jpg', 'Dr. Thomas Petit', '/images/authors/thomas-petit.jpg', 6, 'Solaire', 'solaire,hiver,protection', 1567, true, CURRENT_TIMESTAMP - INTERVAL '10 days'),

('Les meilleurs ingrédients naturels pour peaux étudiantes', 'meilleurs-ingredients-naturels-peaux-etudiantes', 
'Découvrez les ingrédients naturels efficaces et adaptés aux peaux jeunes.', 
'L''aloe vera, le thé vert, l''hamamélis... Ces ingrédients naturels...', 
'/images/blog-ingredients-naturels.jpg', 'Emma Lefebvre', '/images/authors/emma-lefebvre.jpg', 9, 'Ingrédients', 'naturel,ingredients,bio', 987, true, CURRENT_TIMESTAMP - INTERVAL '2 weeks'),

('Skincare et sport : comment protéger sa peau pendant l''effort', 'skincare-sport-proteger-peau-effort', 
'Le sport est excellent pour la santé mais peut agresser la peau. Voici comment la protéger.', 
'La transpiration, les frottements, le soleil... Le sport peut être agressif...', 
'/images/blog-skincare-sport.jpg', 'Lucas Moreau', '/images/authors/lucas-moreau.jpg', 6, 'Sport', 'sport,effort,protection', 1234, true, CURRENT_TIMESTAMP - INTERVAL '3 weeks'),

('Comment choisir sa première crème anti-âge', 'comment-choisir-premiere-creme-anti-age', 
'À quel âge commencer la prévention anti-âge ? Nos conseils pour choisir votre première crème.', 
'La prévention anti-âge commence dès 20-25 ans. Il faut choisir des produits adaptés...', 
'/images/blog-premiere-creme-anti-age.jpg', 'Dr. Claire Bernard', '/images/authors/claire-bernard.jpg', 7, 'Anti-âge', 'anti-age,prevention,20ans', 2156, true, CURRENT_TIMESTAMP - INTERVAL '4 weeks'),

('Le double nettoyage : est-ce vraiment nécessaire ?', 'double-nettoyage-est-ce-vraiment-necessaire', 
'Le double nettoyage est tendance, mais est-il vraiment indispensable ?', 
'Le double nettoyage consiste à utiliser d''abord une huile démaquillante...', 
'/images/blog-double-nettoyage.jpg', 'Chloé Robert', '/images/authors/chloe-robert.jpg', 5, 'Nettoyage', 'nettoyage,double-nettoyage', 1876, true, CURRENT_TIMESTAMP - INTERVAL '5 weeks');

-- =============================================
-- TEMOIGNAGES
-- =============================================
INSERT INTO testimonials (customer_name, customer_email, customer_avatar, customer_university, customer_age, customer_city, comment, rating, product_name, is_verified_purchase, is_approved, helpful_count) VALUES
('Camille Martin', 'camille.m@email.com', '/images/avatars/camille.jpg', 'Sorbonne Université', 20, 'Paris', 'Le sérum hydratant est incroyable ! Ma peau est beaucoup plus douce.', 5, 'Sérum Hydratant Étudiant', true, true, 45),
('Lucas Bernard', 'lucas.b@email.com', '/images/avatars/lucas.jpg', 'Université de Paris', 22, 'Paris', 'La crème solaire SPF 50+ est parfaite. Texture légère, non grasse.', 5, 'Crème Solaire SPF 50+', true, true, 38),
('Emma Dubois', 'emma.d@email.com', '/images/avatars/emma.jpg', 'École Polytechnique', 21, 'Palaiseau', 'Le nettoyant 3-en-1 m''a fait gagner énormément de temps le matin.', 4, 'Nettoyant Doux 3-en-1', true, true, 29),
('Hugo Petit', 'hugo.p@email.com', '/images/avatars/hugo.jpg', 'Université Lyon 1', 19, 'Lyon', 'Le masque détox est super efficace après une semaine de révisions.', 5, 'Masque Détox Week-end', true, true, 52),
('Chloé Robert', 'chloe.r@email.com', '/images/avatars/chloe.jpg', 'Sciences Po Paris', 23, 'Paris', 'Le soin anti-boutons a sauvé ma peau pendant les partiels.', 4, 'Soin Anti-Boutons', true, true, 41),
('Antoine Leroy', 'antoine.l@email.com', '/images/avatars/antoine.jpg', 'Université de Montpellier', 20, 'Montpellier', 'Le baume lèvres est excellent. Je l''emporte partout avec moi.', 5, 'Baume Lèvres Protecteur', true, true, 33),
('Léa Martinez', 'lea.m@email.com', '/images/avatars/lea.jpg', 'Université Bordeaux', 22, 'Bordeaux', 'La crème hydratante légère est parfaite pour ma peau mixte.', 5, 'Crème Hydratante Légère', true, true, 47),
('Mathieu Durand', 'mathieu.d@email.com', '/images/avatars/mathieu.jpg', 'ENS Paris', 21, 'Paris', 'Le roll-on anti-cernes est mon sauveur pendant les révisions nocturnes.', 4, 'Roll-on Anti-Cernes', true, true, 36);

-- =============================================
-- ROUTINES DE SOIN
-- =============================================
INSERT INTO routines (name, slug, description, image, skin_type, skin_concerns, steps, duration_minutes, difficulty_level, products_needed, is_recommended, view_count) VALUES
('Routine Express Matin', 'routine-express-matin', 'Parfaite pour les matins pressés avant les cours.', '/images/routines/matin-express.jpg', 'Toutes', 'Aucun', 
'1. Nettoyage rapide avec le Nettoyant 3-en-1 (30s)\n2. Sérum Hydratant (30s)\n3. Crème Solaire SPF 50+ (30s)\n4. Baume Lèvres (10s)', 5, 'Débutant', 'Nettoyant 3-en-1, Sérum Hydratant, Crème Solaire, Baume Lèvres', true, 3421),

('Routine Soir Détente', 'routine-soir-detente', 'Routine relaxante après une longue journée.', '/images/routines/soir-detente.jpg', 'Toutes', 'Fatigue, stress', 
'1. Démaquillage à l''Huile Démaquillante (1min)\n2. Nettoyage doux (1min)\n3. Sérum Hydratant (30s)\n4. Crème Hydratante Légère (30s)', 3, 'Débutant', 'Huile Démaquillante, Nettoyant 3-en-1, Sérum Hydratant, Crème Hydratante', true, 2876),

('Routine Anti-Imperfections', 'routine-anti-imperfections', 'Spécialement conçue pour les peaux à tendance acnéique.', '/images/routines/anti-imperfections.jpg', 'Mixte à grasse', 'Acné, points noirs', 
'1. Nettoyage en douceur (1min)\n2. Gommage doux 2x par semaine (2min)\n3. Soin Anti-Boutons (30s)\n4. Crème Hydratante Légère (30s)', 4, 'Intermédiaire', 'Nettoyant 3-en-1, Gommage Doux, Soin Anti-Boutons, Crème Hydratante', true, 3156),

('Routine Week-end Intense', 'routine-week-end-intense', 'Soin complet pour régénérer la peau pendant le week-end.', '/images/routines/week-end-intense.jpg', 'Toutes', 'Peau terne, stress', 
'1. Double nettoyage (3min)\n2. Gommage doux (2min)\n3. Masque Détox (15min)\n4. Sérum Hydratant (1min)\n5. Crème Hydratante (1min)', 25, 'Intermédiaire', 'Huile Démaquillante, Nettoyant 3-en-1, Gommage Doux, Masque Détox, Sérum, Crème', false, 1987);

-- Afficher le résumé
SELECT 'Products' as table_name, COUNT(*) as record_count FROM products
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Blog Posts', COUNT(*) FROM blog_posts WHERE is_published = true
UNION ALL
SELECT 'Testimonials', COUNT(*) FROM testimonials WHERE is_approved = true
UNION ALL
SELECT 'Routines', COUNT(*) FROM routines
ORDER BY table_name;
