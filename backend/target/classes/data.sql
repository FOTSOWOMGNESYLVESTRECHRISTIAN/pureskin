-- =============================================
-- DONNÉES DE TEST POUR NEWSLETTER_SUBSCRIBERS
-- =============================================

INSERT INTO newsletter_subscribers (email, first_name, university, source, student_verified, promo_code_used, guide_downloaded, weekly_tips_active, subscription_date) VALUES 
    ('marie.dupont@univ-paris.fr', 'Marie', 'Université Paris-Saclay', 'homepage', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '7 days'),
    ('lucas.martin@sorbonne.fr', 'Lucas', 'Sorbonne Université', 'homepage', true, 'ETUDIANT30', false, true, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('sophie.bernard@polytechnique.fr', 'Sophie', 'École Polytechnique', 'product_page', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '1 day'),
    ('pierre.leclerc@ens.fr', 'Pierre', 'ENS Paris', 'checkout', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '14 days'),
    ('camille.renaud@hec.fr', 'Camille', 'HEC Paris', 'homepage', false, 'ETUDIANT30', false, true, CURRENT_TIMESTAMP - INTERVAL '21 days'),
    ('nicolas.petit@centralesupelec.fr', 'Nicolas', 'CentraleSupélec', 'homepage', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '10 days'),
    ('emma.dubois@mines-paris.fr', 'Emma', 'Mines Paris', 'product_page', true, 'ETUDIANT30', false, true, CURRENT_TIMESTAMP - INTERVAL '5 days'),
    ('hugo.moreau@telecom-paris.fr', 'Hugo', 'Télécom Paris', 'homepage', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '2 days'),
    ('alice.roux@science-po.fr', 'Alice', 'Sciences Po', 'checkout', true, 'ETUDIANT30', true, true, CURRENT_TIMESTAMP - INTERVAL '8 days'),
    ('louis.girard@dauphine.fr', 'Louis', 'Université Dauphine', 'homepage', false, 'ETUDIANT30', false, true, CURRENT_TIMESTAMP - INTERVAL '12 days')
ON CONFLICT (email) DO NOTHING;

-- Mettre à jour quelques compteurs d'emails pour simuler l'activité
UPDATE newsletter_subscribers 
SET email_count = floor(random() * 10 + 1), 
    last_email_sent = CURRENT_TIMESTAMP - INTERVAL '1 day' * floor(random() * 7 + 1)
WHERE email IN ('marie.dupont@univ-paris.fr', 'lucas.martin@sorbonne.fr', 'sophie.bernard@polytechnique.fr', 'pierre.leclerc@ens.fr');

-- Désinscrire quelques utilisateurs pour tester
UPDATE newsletter_subscribers 
SET is_active = false, 
    unsubscribe_reason = 'Plus intéressé',
    unsubscribe_date = CURRENT_TIMESTAMP - INTERVAL '15 days'
WHERE email IN ('camille.renaud@hec.fr', 'nicolas.petit@centralesupelec.fr');
