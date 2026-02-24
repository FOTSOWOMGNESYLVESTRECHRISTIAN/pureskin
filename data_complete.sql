-- =============================================
-- DONNÉES COMPLÈTES PURESKIN ÉTUDIANT
-- Basée sur toutes les pages frontend
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
-- PRODUITS (10 produits par catégorie)
-- =============================================
INSERT INTO products (category_id, name, slug, description, price, original_price, image, badge, stock_quantity, is_active, is_featured, rating_average, review_count) VALUES
-- Visage
(1, 'Sérum Hydratant Étudiant', 'serum-hydratant-etudiant', 'Sérum hydratant intense avec acide hyaluronique et vitamine C. Idéal pour les peaux jeunes déshydratées.', 24.99, 34.99, '/images/serum-hydratant.jpg', 'best-seller', 150, true, true, 4.5, 234),
(1, 'Crème Hydratante Légère', 'creme-hydratante-legere', 'Crème jour texture gel, non grasse, parfaite pour peaux mixtes à grasses.', 22.99, 32.99, '/images/creme-hydratante.jpg', 'best-seller', 110, true, true, 4.3, 189),
(1, 'Baume Lèvres Protecteur', 'baume-levres-protecteur', 'Baume lèvres avec SPF 30. Protège du froid, du vent et du soleil.', 6.99, NULL, '/images/baume-levres.jpg', NULL, 300, true, false, 4.7, 156),
(1, 'Roll-on Anti-Cernes', 'roll-on-anti-cernes', 'Roll-on rafraîchissant pour cernes et poches. Effet glacé instantané.', 13.99, 19.99, '/images/roll-on-cernes.jpg', 'new', 85, true, false, 4.2, 78),
(1, 'Contour des Yeux', 'contour-yeux', 'Crème contour des yeux anti-âge et anti-poches. Texture fine et pénétrante.', 18.99, 26.99, '/images/contour-yeux.jpg', 'promo', 70, true, false, 4.4, 92),
(1, 'Masque Visage Hydratant', 'masque-visage-hydratant', 'Masque tissu hydratant à l''aloe vera. Effet coup d''éclat instantané.', 8.99, 14.99, '/images/masque-hydratant.jpg', 'new', 120, true, false, 4.6, 145),
(1, 'Gommage Doux Visage', 'gommage-doux-visage', 'Gommage enzymatique doux, sans grains, respectueux des peaux sensibles.', 14.99, 21.99, '/images/gommage-doux.jpg', 'best-seller', 90, true, true, 4.5, 201),
(1, 'Huile Démaquillante', 'huile-demaquillante', 'Huile démaquillante qui élimine même le maquillage waterproof.', 16.99, NULL, '/images/huile-demaquillante.jpg', NULL, 120, true, false, 4.3, 167),
(1, 'Tonique Rafraîchissant', 'tonique-rafraichissant', 'Tonique sans alcool à l''eau de rose. Apaise et prépare la peau.', 12.99, 18.99, '/images/tonique.jpg', NULL, 95, true, false, 4.4, 123),
(1, 'Sérum Anti-Âge', 'serum-anti-age', 'Sérum anti-âge préventif pour les 20-30 ans. Rétinol doux et antioxydants.', 28.99, 39.99, '/images/serum-anti-age.jpg', 'premium', 60, true, false, 4.6, 89),

-- Solaire
(3, 'Crème Solaire SPF 50+', 'creme-solaire-spf50', 'Protection solaire très haute protection, non grasse, idéale pour le quotidien.', 18.99, NULL, '/images/creme-solaire.jpg', 'essentiel', 200, true, true, 4.8, 312),
(3, 'Brume Solaire SPF 30', 'brume-solaire-spf30', 'Brume solaire pratique pour les retouches. Texture invisible et non collante.', 15.99, 22.99, '/images/brume-solaire.jpg', 'new', 80, true, false, 4.5, 98),
(3, 'Stick Solaire Teinté SPF 50', 'stick-solaire-teinte', 'Stick solaire teinté pour unifier et protéger en un geste.', 14.99, 19.99, '/images/stick-solaire.jpg', 'new', 65, true, false, 4.3, 76),
(3, 'Après-Soleil Apaisant', 'apres-soleil-apaisant', 'Lotion après-soleil à l''aloe vera. Apaise les coups de soleil.', 16.99, 24.99, '/images/apres-soleil.jpg', NULL, 90, true, false, 4.7, 134),
(3, 'Protection Lèvres SPF 50', 'protection-levres-spf50', 'Stick lèvres protection solaire maximale. Résistant à l''eau.', 7.99, NULL, '/images/stick-levres.jpg', NULL, 150, true, false, 4.4, 89),
(3, 'Solaire Peaux Sensibles', 'solaire-peaux-sensibles', 'Crème solaire spécialement formulée pour les peaux sensibles et réactives.', 21.99, 29.99, '/images/solaire-sensible.jpg', NULL, 70, true, false, 4.6, 112),
(3, 'Solaire Sport SPF 50+', 'solaire-sport-spf50', 'Protection solaire très résistante, parfaite pour le sport et activités nautiques.', 19.99, NULL, '/images/solaire-sport.jpg', NULL, 85, true, false, 4.7, 145),
(3, 'Auto-bronzant Visage', 'auto-bronzant-visage', 'Auto-bronzant progressif pour teint hâlé naturel toute l''année.', 17.99, 25.99, '/images/auto-bronzant.jpg', 'promo', 55, true, false, 4.2, 67),
(3, 'Gouttes Solaire SPF 50', 'gouttes-solaire-spf50', 'Gouttes solaires invisibles à mélanger à votre crème habituelle.', 22.99, 32.99, '/images/gouttes-solaire.jpg', 'new', 45, true, false, 4.5, 43),
(3, 'Poudre Solaire Matifiante', 'poudre-solaire-matifiante', 'Poudre solaire matifiante pour retouches tout au long de la journée.', 16.99, 23.99, '/images/poudre-solaire.jpg', NULL, 60, true, false, 4.3, 78),

-- Anti-acné
(5, 'Soin Anti-Boutons', 'soin-anti-boutons', 'Gel-crème anti-imperfections, action rapide sur les boutons et points noirs.', 19.99, 29.99, '/images/anti-boutons.jpg', 'urgent', 60, true, true, 4.4, 278),
(5, 'Nettoyant Anti-Acné', 'nettoyant-anti-acne', 'Gel nettoyant purifiant à l''acide salicylique. Combat les imperfections.', 14.99, 21.99, '/images/nettoyant-acne.jpg', 'best-seller', 95, true, false, 4.5, 234),
(5, 'Masque Anti-Acné', 'masque-anti-acne', 'Masque à l''argile et au thé vert. Purifie et resserre les pores.', 9.99, 15.99, '/images/masque-acne.jpg', NULL, 110, true, false, 4.3, 189),
(5, 'Sérum Anti-Taches', 'serum-anti-taches', 'Sérum éclaircissant à la vitamine C et niacinamide. Unifie le teint.', 24.99, 34.99, '/images/serum-taches.jpg', 'premium', 50, true, false, 4.6, 98),
(5, 'Crème Correctrice', 'creme-correctrice', 'Crème correctrice pour imperfections localisées. Action ciblée et rapide.', 12.99, 18.99, '/images/creme-correctrice.jpg', NULL, 75, true, false, 4.2, 145),
(5, 'Patchs Anti-Boutons', 'patchs-anti-boutons', 'Patchs hydrocolloïdes pour boutons. Accélèrent la cicatrisation.', 8.99, 14.99, '/images/patchs-boutons.jpg', 'new', 130, true, false, 4.4, 167),
(5, 'Exfoliant Doux', 'exfoliant-doux', 'Exfoliant enzymatique doux pour peaux sensibles à tendance acnéique.', 16.99, 24.99, '/images/exfoliant-doux.jpg', NULL, 80, true, false, 4.5, 123),
(5, 'Eau Micellaire Purifiante', 'eau-micellaire-purifiante', 'Eau micellaire purifiante sans alcool. Démaquille et purifie.', 11.99, 16.99, '/images/eau-micellaire.jpg', NULL, 140, true, false, 4.3, 201),
(5, 'Sérum Régulateur', 'serum-regulateur', 'Sérum régulateur de sébum. Matifie et réduit l''excès de sébum.', 22.99, 32.99, '/images/serum-regulateur.jpg', 'best-seller', 65, true, false, 4.4, 156),
(5, 'Crème SOS Boutons', 'creme-sos-boutons', 'Crème SOS pour boutons enflammés. Action apaisante immédiate.', 15.99, 22.99, '/images/creme-sos.jpg', NULL, 55, true, false, 4.6, 89),

-- Nettoyage
(6, 'Nettoyant Doux 3-en-1', 'nettoyant-doux-3-en-1', 'Démaquille, nettoie et tonifie en une seule étape. Parfait pour les matins pressés.', 15.99, 22.99, '/images/nettoyant-doux.jpg', 'new', 100, true, true, 4.6, 312),
(6, 'Huile Démaquillante Nettoyante', 'huile-demaquillante-nettoyante', 'Huile démaquillante qui élimine même le maquillage waterproof.', 16.99, NULL, '/images/huile-demaquillante.jpg', NULL, 120, true, false, 4.5, 267),
(6, 'Gel Moussant Purifiant', 'gel-moussant-purifiant', 'Gel moussant purifiant au tea tree. Nettoie en profondeur sans agresser.', 13.99, 19.99, '/images/gel-moussant.jpg', NULL, 85, true, false, 4.4, 189),
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
'Découvrez la routine skincare parfaite adaptée au budget et au rythme de vie étudiant. Simple, efficace et abordable!', 
'Une routine skincare complète ne doit pas être compliquée ni coûteuse. Pour les étudiants, il faut trouver le juste milieu entre efficacité et simplicité. Voici les 5 étapes essentielles...', 
'/images/blog-routine-etudiante.jpg', 'Dr. Marie Laurent', '/images/authors/marie-laurent.jpg', 7, 'Routine', 'routine,etudiant,budget', 2456, true, CURRENT_TIMESTAMP - INTERVAL '2 days'),

('Comment gérer l''acné pendant les examens ?', 'comment-gerer-acne-pendant-examens', 
'Le stress des examens peut provoquer des poussées d''acné. Découvrez nos astuces pour garder une peau nette.', 
'Le stress libère du cortisol qui stimule la production de sébum. Pendant les périodes d''examens, il est crucial d''adapter sa routine...', 
'/images/blog-acne-examens.jpg', 'Dr. Paul Martin', '/images/authors/paul-martin.jpg', 5, 'Acné', 'acne,examens,stress', 1823, true, CURRENT_TIMESTAMP - INTERVAL '5 days'),

('Budget skincare : les produits qui en valent vraiment la peine', 'budget-skincare-produits-qui-en-valent-la-peine', 
'Investir dans les bons produits sans se ruiner. Notre sélection des meilleurs produits skincare à petit prix.', 
'Le skincare ne doit pas coûter une fortune. Certains produits abordables sont aussi efficaces que les grandes marques...', 
'/images/blog-budget-skincare.jpg', 'Sophie Dubois', '/images/authors/sophie-dubois.jpg', 8, 'Budget', 'budget,skincare,etudiant', 3124, true, CURRENT_TIMESTAMP - INTERVAL '1 week'),

('Protection solaire : pourquoi c''est non négociable même en hiver', 'protection-solaire-pourquoi-non-negociable-hiver', 
'Les UV sont présents toute l''année. Découvrez pourquoi la protection solaire est essentielle même en hiver.', 
'Même par temps nuageux en hiver, 80% des UV traversent les nuages. La protection solaire quotidienne prévient le vieillissement...', 
'/images/blog-solaire-hiver.jpg', 'Dr. Thomas Petit', '/images/authors/thomas-petit.jpg', 6, 'Solaire', 'solaire,hiver,protection', 1567, true, CURRENT_TIMESTAMP - INTERVAL '10 days'),

('Les meilleurs ingrédients naturels pour peaux étudiantes', 'meilleurs-ingredients-naturels-peaux-etudiantes', 
'Découvrez les ingrédients naturels efficaces et adaptés aux peaux jeunes et aux budgets étudiants.', 
'L''aloe vera, le thé vert, l''hamamélis... Ces ingrédients naturels sont parfaits pour les peaux jeunes...', 
'/images/blog-ingredients-naturels.jpg', 'Emma Lefebvre', '/images/authors/emma-lefebvre.jpg', 9, 'Ingrédients', 'naturel,ingredients,bio', 987, true, CURRENT_TIMESTAMP - INTERVAL '2 weeks'),

('Skincare et sport : comment protéger sa peau pendant l''effort', 'skincare-sport-proteger-peau-effort', 
'Le sport est excellent pour la santé mais peut agresser la peau. Voici comment la protéger.', 
'La transpiration, les frottements, le soleil... Le sport peut être agressif pour la peau. Une routine adaptée est essentielle...', 
'/images/blog-skincare-sport.jpg', 'Lucas Moreau', '/images/authors/lucas-moreau.jpg', 6, 'Sport', 'sport,effort,protection', 1234, true, CURRENT_TIMESTAMP - INTERVAL '3 weeks'),

('Comment choisir sa première crème anti-âge', 'comment-choisir-premiere-creme-anti-age', 
'À quel âge commencer la prévention anti-âge ? Nos conseils pour choisir sa première crème.', 
'La prévention anti-âge commence dès 20-25 ans. Il faut choisir des produits adaptés aux peaux jeunes...', 
'/images/blog-premiere-creme-anti-age.jpg', 'Dr. Claire Bernard', '/images/authors/claire-bernard.jpg', 7, 'Anti-âge', 'anti-age,prevention,20ans', 2156, true, CURRENT_TIMESTAMP - INTERVAL '4 weeks'),

('Le double nettoyage : est-ce vraiment nécessaire ?', 'double-nettoyage-est-ce-vraiment-necessaire', 
'Le double nettoyage est tendance, mais est-il vraiment indispensable ? Analyse complète.', 
'Le double nettoyage consiste à utiliser d''abord une huile démaquillante, puis un nettoyant aqueux...', 
'/images/blog-double-nettoyage.jpg', 'Chloé Robert', '/images/authors/chloe-robert.jpg', 5, 'Nettoyage', 'nettoyage,double-nettoyage', 1876, true, CURRENT_TIMESTAMP - INTERVAL '5 weeks');
