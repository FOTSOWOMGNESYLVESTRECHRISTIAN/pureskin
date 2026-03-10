-- Création de la table categories pour PostgreSQL
CREATE TABLE IF NOT EXISTS categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion des catégories de base
INSERT INTO categories (name, slug, description, icon) VALUES
('Visage', 'visage', 'Soins complets pour le visage', '/icons/face.svg'),
('Corps', 'corps', 'Hydratation et soin du corps', '/icons/body.svg'),
('Solaire', 'solaire', 'Protection solaire pour tous types', '/icons/sun.svg'),
('Hydratation', 'hydratation', 'Produits hydratants intenses', '/icons/drop.svg'),
('Anti-acné', 'anti-acne', 'Solutions contre les imperfections', '/icons/shield.svg'),
('Nettoyage', 'nettoyage', 'Nettoyants et démaquillants', '/icons/clean.svg');

-- Création de la table de jointure produits_categories
CREATE TABLE IF NOT EXISTS products_categories (
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    category_id BIGINT REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

-- Index pour optimisation
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_products_categories_product ON products_categories(product_id);
CREATE INDEX IF NOT EXISTS idx_products_categories_category ON products_categories(category_id);
