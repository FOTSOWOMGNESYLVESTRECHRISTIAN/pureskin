-- Initialisation de la base de données pureSkin
-- Ce script est exécuté automatiquement au démarrage du conteneur PostgreSQL

-- Création de la base de données si elle n'existe pas
-- (La base de données est déjà créée par POSTGRES_DB dans docker-compose.yml)

-- Configuration des extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Insertion de données de test (optionnel)
-- Vous pouvez décommenter ces lignes pour ajouter des données initiales

/*
-- Produits exemples
INSERT INTO products (name, description, price, original_price, image, badge, stock_quantity, is_active, created_at) VALUES
('Sérum Hydratant', 'Sérum hydratant intense pour peau sèche', 29.99, 39.99, '/images/serum1.jpg', 'best-seller', 50, true, NOW()),
('Crème Solaire SPF 50', 'Protection solaire haute protection', 19.99, NULL, '/images/sunscreen1.jpg', NULL, 100, true, NOW()),
('Nettoyant Doux', 'Nettoyant visage doux pour tous types de peau', 15.99, 24.99, '/images/cleanser1.jpg', 'new', 75, true, NOW());

-- Articles de blog exemples
INSERT INTO blog_posts (title, slug, excerpt, content, featured_image, author, reading_time, is_published, published_at, created_at) VALUES
('Les 5 étapes d''une routine parfaite', 'les-5-etapes-routine-parfaite', 'Découvrez les étapes essentielles pour une routine de soin efficace.', 'Contenu complet de l''article...', '/images/blog1.jpg', 'Dr. Martin', 5, true, NOW(), NOW()),
('Comment choisir sa crème solaire', 'comment-choisir-creme-solaire', 'Guide complet pour bien choisir sa protection solaire.', 'Contenu complet de l''article...', '/images/blog2.jpg', 'Dr. Sophie', 8, true, NOW(), NOW());

-- Témoignages exemples
INSERT INTO testimonials (customer_name, customer_email, customer_university, customer_age, comment, rating, product_name, is_approved, created_at) VALUES
('Marie Dubois', 'marie.d@email.com', 'Université de Paris', 22, 'Excellent produit, ma peau est beaucoup plus hydratée !', 5, 'Sérum Hydratant', true, NOW()),
('Thomas Martin', 'thomas.m@email.com', 'Sorbonne', 24, 'Très efficace, je recommande vivement.', 4, 'Crème Solaire SPF 50', true, NOW());

-- Routines de soin exemples
INSERT INTO routines (name, slug, description, skin_type_id, steps, duration_minutes, difficulty_level, is_recommended, created_at) VALUES
('Routine Matinale Express', 'routine-matinale-express', 'Routine rapide pour le matin', 1, '1. Nettoyage\n2. Sérum\n3. Crème solaire', 10, 'Débutant', true, NOW()),
('Routine Soin Intense', 'routine-soin-intense', 'Routine complète pour peau en besoin', 2, '1. Double nettoyage\n2. Exfoliation\n3. Masque\n4. Sérum\n5. Crème', 30, 'Intermédiaire', false, NOW());
*/
