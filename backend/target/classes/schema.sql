-- =============================================
-- TABLE NEWSLETTER_SUBSCRIBERS
-- Pour la communauté PureSkin Étudiant
-- =============================================

CREATE TABLE IF NOT EXISTS newsletter_subscribers (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    university VARCHAR(255),
    study_field VARCHAR(100),
    graduation_year INTEGER,
    skin_type VARCHAR(50),
    source VARCHAR(50) DEFAULT 'homepage',
    student_verified BOOLEAN DEFAULT false,
    promo_code_used VARCHAR(50),
    guide_downloaded BOOLEAN DEFAULT false,
    weekly_tips_active BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    subscription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_email_sent TIMESTAMP,
    email_count INTEGER DEFAULT 0,
    unsubscribe_reason TEXT,
    unsubscribe_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_newsletter_email_active ON newsletter_subscribers(email, is_active);
CREATE INDEX IF NOT EXISTS idx_newsletter_subscription_date ON newsletter_subscribers(subscription_date);
CREATE INDEX IF NOT EXISTS idx_newsletter_source ON newsletter_subscribers(source);
CREATE INDEX IF NOT EXISTS idx_newsletter_student_verified ON newsletter_subscribers(student_verified);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_newsletter_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER newsletter_updated_at_trigger
    BEFORE UPDATE ON newsletter_subscribers
    FOR EACH ROW
    EXECUTE FUNCTION update_newsletter_updated_at();

-- Vue pour statistiques
CREATE OR REPLACE VIEW newsletter_stats AS
SELECT 
    COUNT(*) as total_subscribers,
    COUNT(*) FILTER (WHERE is_active = true) as active_subscribers,
    COUNT(*) FILTER (WHERE student_verified = true) as verified_students,
    COUNT(*) FILTER (WHERE guide_downloaded = true) as guide_downloads,
    COUNT(*) FILTER (WHERE weekly_tips_active = true) as weekly_tips_active,
    DATE_TRUNC('month', subscription_date) as month,
    COUNT(*) FILTER (WHERE DATE_TRUNC('month', subscription_date) = DATE_TRUNC('month', CURRENT_DATE)) as this_month
FROM newsletter_subscribers
GROUP BY DATE_TRUNC('month', subscription_date);

-- =============================================
-- TABLE PAYMENTS
-- Pour les transactions de paiement PureSkin
-- =============================================

CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    order_id VARCHAR(100) UNIQUE NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(50),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'XAF',
    payment_method VARCHAR(100),
    status VARCHAR(50) NOT NULL, -- 'PENDING', 'SUCCESS', 'FAILED', 'CANCELLED'
    payment_reference VARCHAR(255),
    faroty_transaction_id VARCHAR(255),
    faroty_wallet_id VARCHAR(255),
    products JSONB, -- Liste des produits achetés avec quantités
    shipping_address JSONB,
    billing_address JSONB,
    metadata JSONB, -- Informations supplémentaires
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    expires_at TIMESTAMP
);

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_customer_email ON payments(customer_email);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);
CREATE INDEX IF NOT EXISTS idx_payments_amount ON payments(amount);
CREATE INDEX IF NOT EXISTS idx_payments_faroty_transaction_id ON payments(faroty_transaction_id);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_payments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER payments_updated_at_trigger
    BEFORE UPDATE ON payments
    FOR EACH ROW
    EXECUTE FUNCTION update_payments_updated_at();

-- Vue pour statistiques des paiements
CREATE OR REPLACE VIEW payment_stats AS
SELECT 
    COUNT(*) as total_transactions,
    COUNT(*) FILTER (WHERE status = 'SUCCESS') as successful_transactions,
    COUNT(*) FILTER (WHERE status = 'FAILED') as failed_transactions,
    COUNT(*) FILTER (WHERE status = 'PENDING') as pending_transactions,
    COALESCE(SUM(amount), 0) as total_revenue,
    COALESCE(SUM(amount) FILTER (WHERE status = 'SUCCESS'), 0) as successful_revenue,
    DATE_TRUNC('day', created_at) as date,
    COUNT(*) FILTER (WHERE DATE_TRUNC('day', created_at) = DATE_TRUNC('day', CURRENT_DATE)) as today_transactions
FROM payments
GROUP BY DATE_TRUNC('day', created_at);
CREATE OR REPLACE VIEW newsletter_community_stats AS
SELECT 
    COUNT(*) as total_subscribers,
    COUNT(CASE WHEN subscription_date >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as recent_signups,
    COUNT(CASE WHEN student_verified = true THEN 1 END) as verified_students,
    COUNT(CASE WHEN guide_downloaded = true THEN 1 END) as guide_downloads,
    COUNT(CASE WHEN promo_code_used IS NOT NULL THEN 1 END) as promo_codes_issued,
    AVG(email_count) as avg_emails_per_subscriber,
    MAX(subscription_date) as latest_signup
FROM newsletter_subscribers 
WHERE is_active = true;
