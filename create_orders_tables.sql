-- =============================================
-- TABLES DE COMMANDES PURESKIN ÉTUDIANT
-- =============================================

-- Table des commandes
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_phone VARCHAR(20),
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'EUR',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    wallet_id VARCHAR(255),
    session_token VARCHAR(500),
    faroty_user_id VARCHAR(255),
    shipping_address TEXT,
    shipping_city VARCHAR(100),
    shipping_postal_code VARCHAR(20),
    shipping_country VARCHAR(100) DEFAULT 'France',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMP
);

-- Table des articles de commande
CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description TEXT,
    product_image VARCHAR(500),
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_wallet_id ON orders(wallet_id);
CREATE INDEX IF NOT EXISTS idx_orders_session_token ON orders(session_token);
CREATE INDEX IF NOT EXISTS idx_orders_faroty_user_id ON orders(faroty_user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Commentaires sur les tables
COMMENT ON TABLE orders IS 'Table des commandes des clients';
COMMENT ON TABLE order_items IS 'Table des articles de chaque commande';

-- Commentaires sur les colonnes importantes
COMMENT ON COLUMN orders.order_number IS 'Numéro unique de commande (ex: PS1640678234567)';
COMMENT ON COLUMN orders.status IS 'Statut de la commande: PENDING, CONFIRMED, PROCESSING, SHIPPED, DELIVERED, CANCELLED';
COMMENT ON COLUMN orders.payment_status IS 'Statut du paiement: PENDING, PROCESSING, COMPLETED, FAILED, REFUNDED';
COMMENT ON COLUMN orders.wallet_id IS 'ID du wallet Faroty associé à la commande';
COMMENT ON COLUMN orders.session_token IS 'Token de session de paiement Faroty';
COMMENT ON COLUMN orders.faroty_user_id IS 'ID utilisateur Faroty';

-- Séquence pour les numéros de commande (optionnel, car géré par l'application)
-- CREATE SEQUENCE IF NOT EXISTS order_number_seq START WITH 1;

-- Exemple de données de test (optionnel)
-- INSERT INTO orders (order_number, customer_email, customer_first_name, customer_last_name, total_amount, status, payment_status)
-- VALUES ('PS1640678234567', 'test@example.com', 'Jean', 'Dupont', 47.70, 'PENDING', 'PENDING');

-- INSERT INTO order_items (order_id, product_id, product_name, unit_price, quantity, total_price)
-- VALUES (1, 1, 'Gel Nettoyant Doux', 12.90, 2, 25.80);
