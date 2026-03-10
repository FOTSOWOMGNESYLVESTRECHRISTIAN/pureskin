-- =============================================
-- AMÉLIORATIONS TABLE NEWSLETTER_SUBSCRIBERS
-- Pour la communauté PureSkin Étudiant
-- =============================================

-- Mettre à jour la table newsletter_subscribers existante
ALTER TABLE newsletter_subscribers 
ADD COLUMN IF NOT EXISTS first_name VARCHAR(100),
ADD COLUMN IF NOT EXISTS last_name VARCHAR(100),
ADD COLUMN IF NOT EXISTS university VARCHAR(255),
ADD COLUMN IF NOT EXISTS study_field VARCHAR(100),
ADD COLUMN IF NOT EXISTS graduation_year INTEGER,
ADD COLUMN IF NOT EXISTS skin_type VARCHAR(50),
ADD COLUMN IF NOT EXISTS source VARCHAR(50) DEFAULT 'homepage',
ADD COLUMN IF NOT EXISTS student_verified BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS promo_code_used VARCHAR(50),
ADD COLUMN IF NOT EXISTS guide_downloaded BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS weekly_tips_active BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS subscription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS last_email_sent TIMESTAMP,
ADD COLUMN IF NOT EXISTS email_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS unsubscribe_reason TEXT,
ADD COLUMN IF NOT EXISTS unsubscribe_date TIMESTAMP;

-- =============================================
-- PROCÉDURE STOCKÉE POUR INSCRIPTION
-- =============================================
CREATE OR REPLACE FUNCTION subscribe_to_newsletter(
    p_email VARCHAR(255),
    p_first_name VARCHAR(100) DEFAULT NULL,
    p_source VARCHAR(50) DEFAULT 'homepage',
    p_student_verified BOOLEAN DEFAULT false
)
RETURNS TABLE (
    success BOOLEAN,
    message TEXT,
    subscriber_id BIGINT,
    is_new_subscriber BOOLEAN
) AS $$
DECLARE
    existing_subscriber BIGINT;
    new_subscriber_id BIGINT;
    promo_code VARCHAR(50) := 'ETUDIANT30';
BEGIN
    -- Vérifier si l'email existe déjà
    SELECT id INTO existing_subscriber 
    FROM newsletter_subscribers 
    WHERE email = p_email AND is_active = true;
    
    IF existing_subscriber IS NOT NULL THEN
        -- Abonné existant
        RETURN QUERY
        SELECT false, 
               'Cet email est déjà inscrit à la communauté PureSkin'::TEXT,
               existing_subscriber,
               false;
        RETURN;
    END IF;
    
    -- Créer le nouvel abonné
    INSERT INTO newsletter_subscribers (
        email, 
        first_name, 
        source, 
        student_verified,
        promo_code_used,
        is_active,
        subscription_date
    ) VALUES (
        p_email,
        p_first_name,
        p_source,
        p_student_verified,
        promo_code,
        true,
        CURRENT_TIMESTAMP
    ) RETURNING id INTO new_subscriber_id;
    
    -- Succès
    RETURN QUERY
    SELECT true,
           format('Bienvenue dans la communauté PureSkin ! Votre code promo est : %s', promo_code)::TEXT,
           new_subscriber_id,
           true;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- PROCÉDURE POUR VÉRIFICATION EMAIL
-- =============================================
CREATE OR REPLACE FUNCTION check_newsletter_subscription(p_email VARCHAR(255))
RETURNS TABLE (
    email_exists BOOLEAN,
    subscriber_id BIGINT,
    subscription_date TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        true,
        ns.id,
        ns.subscription_date
    FROM newsletter_subscribers ns
    WHERE ns.email = p_email AND ns.is_active = true
    LIMIT 1;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT false, NULL::BIGINT, NULL::TIMESTAMP;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- VUE POUR STATISTIQUES COMMUNAUTÉ
-- =============================================
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

-- =============================================
-- TRIGGER POUR METTRE À JOUR LES STATISTIQUES
-- =============================================
CREATE OR REPLACE FUNCTION update_newsletter_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- Mettre à jour le compteur d'emails envoyés
    IF TG_OP = 'UPDATE' AND NEW.last_email_sent IS NOT NULL AND OLD.last_email_sent IS NULL THEN
        NEW.email_count = COALESCE(OLD.email_count, 0) + 1;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER newsletter_stats_trigger
    BEFORE UPDATE ON newsletter_subscribers
    FOR EACH ROW
    EXECUTE FUNCTION update_newsletter_stats();

-- =============================================
-- INDEX POUR OPTIMISATION
-- =============================================
CREATE INDEX IF NOT EXISTS idx_newsletter_email_active ON newsletter_subscribers(email, is_active);
CREATE INDEX IF NOT EXISTS idx_newsletter_subscription_date ON newsletter_subscribers(subscription_date);
CREATE INDEX IF NOT EXISTS idx_newsletter_source ON newsletter_subscribers(source);
CREATE INDEX IF NOT EXISTS idx_newsletter_student_verified ON newsletter_subscribers(student_verified);

-- =============================================
-- DONNÉES DE TEST (optionnel)
-- =============================================
INSERT INTO newsletter_subscribers (email, first_name, university, source, student_verified, promo_code_used, guide_downloaded, weekly_tips_active, subscription_date)
VALUES 
    ('test.student1@univ.fr', 'Marie', 'Université Paris-Saclay', 'homepage', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '7 days'),
    ('test.student2@etudiant.fr', 'Lucas', 'Sorbonne Université', 'homepage', true, 'ETUDIANT30', false, true, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('test.student3@campus.fr', 'Sophie', 'École Polytechnique', 'product_page', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '1 day')
ON CONFLICT (email) DO NOTHING;

-- =============================================
-- COMMENTAIRES
-- =============================================
COMMENT ON TABLE newsletter_subscribers IS 'Table pour la communauté PureSkin - étudiants inscrits à la newsletter';
COMMENT ON COLUMN newsletter_subscribers.source IS 'Source d''inscription: homepage, product_page, checkout, etc.';
COMMENT ON COLUMN newsletter_subscribers.student_verified IS 'Si l''email étudiant a été vérifié';
COMMENT ON COLUMN newsletter_subscribers.promo_code_used IS 'Code promo utilisé par l''étudiant';
COMMENT ON COLUMN newsletter_subscribers.guide_downloaded IS 'Si le guide PDF a été téléchargé';
COMMENT ON COLUMN newsletter_subscribers.weekly_tips_active IS 'Si l''étudiant reçoit encore les conseils hebdomadaires';
