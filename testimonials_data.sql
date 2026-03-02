-- =============================================
-- DONNÉES DES TÉMOIGNAGES PURESKIN ÉTUDIANT
-- Basée sur les données frontend des composants
-- =============================================

INSERT INTO testimonials (customer_name, customer_email, customer_avatar, customer_university, customer_age, customer_city, comment, rating, product_name, is_verified_purchase, is_approved, helpful_count) VALUES

-- Témoignages pour le Sérum Hydratant
('Marie Laurent', 'marie.laurent@email.com', '👩‍🎓', 'Université Paris-Sorbonne', 21, 'Paris', 
'J''adore ce sérum ! Ma peau est beaucoup plus hydratée et les ridules de déshydratation ont disparu. Parfait pour une étudiante avec budget limité.', 5, 'Sérum Hydratant Étudiant', true, true, 45),

('Sophie Martin', 'sophie.martin@email.com', '👩‍🎓', 'Université Lyon 1', 22, 'Lyon', 
'Excellent produit ! Texture légère, pénètre vite et ne laisse pas de film gras. Ma peau mixte adore !', 4, 'Sérum Hydratant Étudiant', true, true, 38),

('Emma Petit', 'emma.petit@email.com', '👩‍🎓', 'Université Bordeaux', 20, 'Bordeaux', 
'Bon rapport qualité-prix. J''ai vu une amélioration après 2 semaines d''utilisation. Le flacon dure longtemps.', 4, 'Sérum Hydratant Étudiant', true, true, 29),

-- Témoignages pour la Crème Solaire
('Léa Dubois', 'lea.dubois@email.com', '👩‍🎓', 'Université Montpellier', 23, 'Montpellier', 
'Protection solaire indispensable ! Texture non grasse, parfaite sous le maquillage. Je l''utilise tous les jours même en hiver.', 5, 'Crème Solaire SPF 50+', true, true, 67),

('Chloé Robert', 'chloe.robert@email.com', '👩‍🎓', 'Université Grenoble', 21, 'Grenoble', 
'Enfin une crème solaire qui ne me fait pas boutonner ! Protection efficace, texture légère. Indispensable pour le sud.', 5, 'Crème Solaire SPF 50+', true, true, 52),

('Lucas Moreau', 'lucas.moreau@email.com', '👨‍🎓', 'Université Lille', 22, 'Lille', 
'Très bonne protection solaire. Résiste bien à la transpiration pendant le sport. Un peu cher mais qualité au rendez-vous.', 4, 'Crème Solaire SPF 50+', true, true, 31),

-- Témoignages pour le Soin Anti-Boutons
('Julie Bernard', 'julie.bernard@email.com', '👩‍🎓', 'Université Strasbourg', 19, 'Strasbourg', 
'Produit miracle ! Les boutons disparaissent en 2-3 jours. Action ciblée efficace sans assécher le reste du visage.', 5, 'Soin Anti-Boutons', true, true, 89),

('Camille Durand', 'camille.durand@email.com', '👩‍🎓', 'Université Toulouse', 20, 'Toulouse', 
'Efficace sur les boutons mais un peu asséchant. J''applique une crème hydratante après. Bon pour les peaux grasses.', 3, 'Soin Anti-Boutons', true, true, 24),

('Manon Richard', 'manon.richard@email.com', '👩‍🎓', 'Université Nantes', 21, 'Nantes', 
'Très satisfait ! Les imperfections sont moins fréquentes et moins visibles. Le flacon est bien pratique.', 4, 'Soin Anti-Boutons', true, true, 41),

-- Témoignages pour le Nettoyant Anti-Acné
('Thomas Petit', 'thomas.petit@email.com', '👨‍🎓', 'Université Rennes', 22, 'Rennes', 
'Excellent nettoyant ! Nettoie bien sans agresser la peau. Senteur agréable. Ma peau est plus nette.', 5, 'Nettoyant Anti-Acné', true, true, 56),

('Nicolas Lefebvre', 'nicolas.lefebvre@email.com', '👨‍🎓', 'Université Aix-Marseille', 20, 'Marseille', 
'Bon produit mais un peu cher pour un nettoyant. Efficace contre les points noirs. Texture gel agréable.', 4, 'Nettoyant Anti-Acné', true, true, 33),

('Alexandre Martin', 'alexandre.martin@email.com', '👨‍🎓', 'Université Nice', 21, 'Nice', 
'Nettoyant correct, un peu asséchant. Convient aux peaux grasses mais pas aux peaux sensibles.', 3, 'Nettoyant Anti-Acné', true, true, 18),

-- Témoignages pour la Crème Hydratante Légère
('Laura Girard', 'laura.girard@email.com', '👩‍🎓', 'Université Clermont', 19, 'Clermont-Ferrand', 
'Crème parfaite pour peaux mixtes ! Hydrate sans graisser, texture gel agréable. Se fond vite dans la peau.', 5, 'Crème Hydratante Légère', true, true, 72),

('Sarah Dubois', 'sarah.dubois@email.com', '👩‍🎓', 'Université Dijon', 22, 'Dijon', 
'Très bonne crème ! Ne laisse pas de film gras, parfait sous le maquillage. Bon rapport qualité-prix.', 4, 'Crème Hydratante Légère', true, true, 48),

('Hélène Robert', 'helene.robert@email.com', '👩‍🎓', 'Université Angers', 20, 'Angers', 
'Crème correcte mais un peu légère pour l''hiver. Parfaite pour l''été. Emballage pratique.', 3, 'Crème Hydratante Légère', true, true, 27),

-- Témoignages pour le Masque Visage Hydratant
('Julie Durand', 'julie.durand@email.com', '👩‍🎓', 'Université Le Havre', 21, 'Le Havre', 
'Masque super hydratant ! Peau douce et éclatante après utilisation. Tissu bien imbibé, facile à appliquer.', 5, 'Masque Visage Hydratant', true, true, 63),

('Marie Petit', 'marie.petit@email.com', '👩‍🎓', 'Université Brest', 23, 'Brest', 
'Bon masque hydratant. Effet coup d''éclat immédiat. Un peu cher mais qualité professionnelle.', 4, 'Masque Visage Hydratant', true, true, 39),

('Claire Martin', 'claire.martin@email.com', '👩‍🎓', 'Université Limoges', 20, 'Limoges', 
'Masque agréable, hydrate bien. Parfait pour un coup d''éclat avant une soirée. Tissu bien adapté au visage.', 4, 'Masque Visage Hydratant', true, true, 51),

-- Témoignages généraux
('Émilie Lefebvre', 'emilie.lefebvre@email.com', '👩‍🎓', 'Université Poitiers', 22, 'Poitiers', 
'Découverte par hasard et je suis conquise ! Produits de qualité, adaptés aux étudiants. Service client au top.', 5, 'Plusieurs produits', true, true, 94),

('Benjamin Richard', 'benjamin.richard@email.com', '👨‍🎓', 'Université Reims', 21, 'Reims', 
'Excellente marque ! Produits efficaces, prix étudiants. J''ai recommandé à tous mes amis de résidence.', 5, 'Plusieurs produits', true, true, 87),

('Alice Girard', 'alice.girard@email.com', '👩‍🎓', 'Université Metz', 19, 'Metz', 
'Marque géniale ! Ingrédients naturels, résultats visibles. Livraison rapide, emballage soigné.', 5, 'Plusieurs produits', true, true, 76),

('David Dubois', 'david.dubois@email.com', '👨‍🎓', 'Université Amiens', 23, 'Amiens', 
'Très satisfait de mes achats. Produits adaptés aux peaux jeunes, conseils pertinents. Site facile à naviguer.', 4, 'Plusieurs produits', true, true, 58),

('Isabelle Martin', 'isabelle.martin@email.com', '👩‍🎓', 'Université Perpignan', 20, 'Perpignan', 
'Bonne expérience globale. Produits de qualité, prix raisonnables. Je renouvellerai mes achats.', 4, 'Plusieurs produits', true, true, 42);
