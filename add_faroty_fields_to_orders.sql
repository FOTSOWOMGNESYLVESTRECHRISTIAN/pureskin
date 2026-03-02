-- =============================================
-- AJOUT DES CHAMPS FAROTY À LA TABLE ORDAYS EXISTANTE
-- =============================================

-- Ajouter les champs Faroty à la table orders
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS wallet_id VARCHAR(255),
ADD COLUMN IF NOT EXISTS session_token VARCHAR(500),
ADD COLUMN IF NOT EXISTS faroty_user_id VARCHAR(255);

-- Ajouter des index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_orders_wallet_id ON orders(wallet_id);
CREATE INDEX IF NOT EXISTS idx_orders_session_token ON orders(session_token);
CREATE INDEX IF NOT EXISTS idx_orders_faroty_user_id ON orders(faroty_user_id);

-- Commentaires sur les nouveaux champs
COMMENT ON COLUMN orders.wallet_id IS 'ID du wallet Faroty associé à la commande';
COMMENT ON COLUMN orders.session_token IS 'Token de session de paiement Faroty';
COMMENT ON COLUMN orders.faroty_user_id IS 'ID utilisateur Faroty';

-- Mettre à jour le trigger pour updated_at si nécessaire
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Vérification des champs ajoutés
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'orders' 
AND column_name IN ('wallet_id', 'session_token', 'faroty_user_id')
ORDER BY column_name;
