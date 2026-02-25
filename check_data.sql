-- Script pour vérifier que les données sont bien insérées
-- À exécuter dans PostgreSQL pour diagnostiquer les problèmes

-- Vérifier si la table routines existe
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name = 'routines';

-- Vérifier la structure de la table routines
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'routines' 
ORDER BY ordinal_position;

-- Vérifier s'il y a des données dans la table routines
SELECT COUNT(*) as total_routines FROM routines;

-- Afficher les routines recommandées
SELECT id, name, slug, is_recommended, created_at 
FROM routines 
WHERE is_recommended = true 
ORDER BY created_at DESC;

-- Afficher toutes les routines
SELECT id, name, slug, skin_type, difficulty_level, is_recommended, view_count, created_at 
FROM routines 
ORDER BY created_at DESC;

-- Vérifier les autres tables
SELECT 'products' as table_name, COUNT(*) as count FROM products
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'blog_posts', COUNT(*) FROM blog_posts
UNION ALL
SELECT 'testimonials', COUNT(*) FROM testimonials
UNION ALL
SELECT 'routines', COUNT(*) FROM routines
ORDER BY table_name;
