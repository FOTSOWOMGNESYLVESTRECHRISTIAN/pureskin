-- =============================================
-- TABLES POUR NOUVELLES FONCTIONNALITÉS
-- Livraison, Programme Fidélité, FAQ
-- =============================================

-- =============================================
-- TABLE OPTIONS DE LIVRAISON (page livraison)
-- =============================================
CREATE TABLE IF NOT EXISTS delivery_options (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    delivery_time_min INTEGER,
    delivery_time_max INTEGER,
    delivery_time_unit VARCHAR(20) DEFAULT 'jours',
    is_active BOOLEAN DEFAULT true,
    is_default BOOLEAN DEFAULT false,
    is_express BOOLEAN DEFAULT false,
    tracking_available VARCHAR(255),
    restrictions TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE PROGRAMME FIDÉLITÉ (page programme-fidelite)
-- =============================================
CREATE TABLE IF NOT EXISTS loyalty_programs (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    points_multiplier DECIMAL(3,2) NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    min_points INTEGER,
    max_points INTEGER,
    is_active BOOLEAN DEFAULT true,
    benefits TEXT,
    next_reward TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE FAQ (page FAQ)
-- =============================================
CREATE TABLE IF NOT EXISTS faqs (
    id BIGSERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100),
    helpful_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- TABLE RÉCOMPENSES FIDÉLITÉ
-- =============================================
CREATE TABLE IF NOT EXISTS loyalty_rewards (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    points_required INTEGER NOT NULL,
    category VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    is_popular BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- =============================================
-- DONNÉES OPTIONS DE LIVRAISON
-- =============================================
INSERT INTO delivery_options (name, description, price, delivery_time_min, delivery_time_max, delivery_time_unit, is_active, is_default, is_express, tracking_available, restrictions, sort_order) VALUES
('Livraison Standard', 'Livraison standard avec suivi temps réel', 4.99, 3, 5, 'jours', true, true, false, 'Oui', 'Poids max: 2kg, France métropolitaine', 1),
('Livraison Express', 'Livraison express 24-48h', 9.99, 1, 2, 'jours', true, false, true, 'Oui', 'Poids max: 2kg, France métropolitaine', 2),
('Point Relais', 'Retrait en point relais', 3.99, 2, 4, 'jours', true, false, false, 'Oui', '2500+ points relais disponibles', 3),
('Mondial Relay', 'Livraison économique Mondial Relay', 2.99, 4, 6, 'jours', true, false, false, 'Oui', '6000+ points en France', 4);

-- =============================================
-- DONNÉES PROGRAMME FIDÉLITÉ
-- =============================================
INSERT INTO loyalty_programs (name, description, points_multiplier, discount_percentage, min_points, max_points, is_active, benefits, next_reward, sort_order) VALUES
('Débutant', 'Niveau débutant pour les nouveaux membres', 1.0, 0.0, 0, 99, true, '1 point = 1€ d''achat, Accès aux promotions, Newsletter exclusive, Offre de bienvenue', '10% de réduction à 100 points', 1),
('Étudiant Actif', 'Niveau intermédiaire pour les membres actifs', 1.2, 10.0, 100, 299, true, '1.2x points multiplicateur, -10% sur tous produits, Accès anticipé nouveautés, Échantillons gratuits, Conseils personnalisés', '15% de réduction à 300 points', 2),
('Expert PureSkin', 'Niveau expert pour les membres fidèles', 1.5, 15.0, 300, 599, true, '1.5x points multiplicateur, -15% sur tous produits, Livraison offerte, Produits avant-première, Service client prioritaire, Invitations événements', '20% de réduction à 600 points', 3),
('Ambassadeur', 'Niveau最高 pour les ambassadeurs de la marque', 2.0, 20.0, 600, NULL, true, '2x points multiplicateur, -20% sur tous produits, Livraison offerte express, Box surprise exclusive, Coach personnel, Programme parrainage premium, Cadeaux anniversaire', 'Statut à vie à 1000 points', 4);

-- =============================================
-- DONNÉES FAQ
-- =============================================
INSERT INTO faqs (question, answer, category, subcategory, is_active, sort_order) VALUES

-- Questions Générales
('Qu''est-ce que PureSkin Étudiant ?', 'PureSkin Étudiant est une marque de produits skincare spécialement conçus pour les étudiants. Nos formules sont adaptées aux problématiques jeunes (acné, stress, budget limité) avec des produits efficaces, abordables et simples d''utilisation.', 'Général', NULL, true, 1),
('Les produits sont-ils testés sur animaux ?', 'Non, absolument pas. PureSkin est une marque cruelty-free. Aucun de nos produits ni ingrédients n''est testé sur animaux. Nous sommes également certifiés vegan pour la plupart de nos produits.', 'Général', NULL, true, 2),
('Quelle est la différence avec les autres marques ?', 'PureSkin se différencie par : 1) Des formules adaptées aux peaux jeunes, 2) Des prix étudiants accessibles, 3) Une routine simple en 3 étapes, 4) Des conseils personnalisés gratuits, 5) Un programme fidélité avantageux.', 'Général', NULL, true, 3),

-- Produits
('Quels produits pour peau grasse à tendance acnéique ?', 'Pour peau grasse/acnéique, nous recommandons : 1) Nettoyant Purifiant (matifiant), 2) Sérum Anti-Boutons (localisé), 3) Crème Hydratante Légère non comédogène. Commencez avec le Kit Express Peau Grasse.', 'Produits', 'Type de peau', true, 1),
('Les produits conviennent-ils aux peaux sensibles ?', 'Oui, toute notre gamme est hypoallergénique et testée dermatologiquement. Pour peaux sensibles, privilégiez : 1) Nettoyant Doux sans sulfates, 2) Sérum Apaisant à la centella, 3) Crème Réparatrice. Faites toujours un test 24h sur une petite zone.', 'Produits', 'Type de peau', true, 2),
('Combien de temps avant de voir des résultats ?', 'Les premiers résultats visibles apparaissent généralement : 1) Hydratation : 2-3 jours, 2) Texture peau : 1-2 semaines, 3) Boutons : 2-4 semaines, 4) Cicatrices : 6-8 semaines. La régularité est la clé du succès !', 'Produits', 'Résultats', true, 3),
('Puis-je combiner plusieurs produits ?', 'Oui, nos produits sont conçus pour fonctionner en synergie. Évitez cependant d''utiliser plus de 5 produits simultanément. Suivez notre guide : Nettoyant → Sérum → Crème. Le matin, ajoutez un SPF.', 'Produits', 'Utilisation', true, 4),

-- Commandes
('Comment passer commande ?', 'Simple en 3 étapes : 1) Choisissez vos produits et ajoutez au panier, 2) Créez votre compte ou connectez-vous, 3) Choisissez livraison et paiement. La commande prend 2 minutes maximum !', 'Commandes', 'Processus', true, 1),
('Puis-je modifier ma commande ?', 'Oui, vous pouvez modifier votre commande dans les 2 heures suivant la validation. Contactez-nous vite par email ou téléphone. Après expédition, il faudra attendre la réception pour faire un retour.', 'Commandes', 'Modification', true, 2),
('Comment suivre ma commande ?', 'Vous recevrez un email avec votre numéro de suivi 24h après la commande. Utilisez notre page ''Suivi colis'' ou le lien direct dans l''email pour suivre en temps réel votre livraison.', 'Commandes', 'Suivi', true, 3),

-- Paiement
('Quels moyens de paiement acceptez-vous ?', 'Nous acceptons : Carte bancaire (Visa, Mastercard, CB), PayPal, Apple Pay, Google Pay, PayPal en 4x, Alma (3x/4x sans frais), chèque (pour réservations en magasin). 100% sécurisé SSL.', 'Paiement', 'Moyens', true, 1),
('Puis-je payer en plusieurs fois ?', 'Oui ! Nous proposons : 1) PayPal en 4x (sans frais à partir de 30€), 2) Alma 3x/4x (sans frais à partir de 50€), 3) Notre propre programme 3x (étudiants uniquement). Le paiement est instantané et sécurisé.', 'Paiement', 'Fractionnement', true, 2),
('Ma carte a été refusée, que faire ?', 'Vérifiez : 1) Solde suffisant, 2) Plafond non dépassé, 3) Carte activée pour paiement en ligne, 4) Infos correctes. Si problème persiste, essayez PayPal ou contactez votre banque. Notre service client peut aider aussi.', 'Paiement', 'Problèmes', true, 3),

-- Livraison
('Quels sont les délais de livraison ?', 'Livraison Standard : 3-5 jours ouvrés (4,99€), Express : 24-48h (9,99€), Point Relais : 2-4 jours (3,99€), Mondial Relay : 4-6 jours (2,99€). Livraison offerte dès 25€ d''achat !', 'Livraison', 'Délais', true, 1),
('Livrez-vous à l''étranger ?', 'Actuellement : France métropolitaine, Corse, Belgique, Luxembourg. Bientôt : Suisse, Espagne, Italie. Pour DOM-TOM et autres pays, contactez-nous pour un devis personnalisé.', 'Livraison', 'Zone géographique', true, 2),
('Que faire si je suis absent à la livraison ?', 'Pas de panique ! Le transporteur laisse un avis de passage. Vous pouvez : 1) Reprogrammer la livraison en ligne, 2) Retirer au point relais, 3) Demander une deuxième tentative le lendemain. Vous avez 15 jours pour récupérer votre colis.', 'Livraison', 'Absence', true, 3),

-- Retours
('Puis-je retourner un produit ?', 'Oui, vous avez 14 jours pour retourner un produit non utilisé, dans son emballage d''origine. Contactez-nous pour obtenir une étiquette retour gratuite. Remboursement sous 5-7 jours ou échange immédiat.', 'Retours', 'Processus', true, 1),
('Les produits ouverts sont-ils remboursables ?', 'Pour des raisons d''hygiène, les produits ouverts ne peuvent être remboursés SAUF : 1) Produit défectueux, 2) Réaction allergique (certificat médical demandé), 3) Erreur de notre part. Dans ces cas, nous remboursons sans problème.', 'Retours', 'Conditions', true, 2),
('Comment faire un retour ?', 'Simple : 1) Connectez-vous à votre compte → ''Mes retours'', 2) Sélectionnez le produit et la raison, 3) Imprimez l''étiquette retour (gratuite), 4) Déposez dans un point relais. Suivez le retour en temps réel !', 'Retours', 'Instructions', true, 3);

-- =============================================
-- DONNÉES RÉCOMPENSES FIDÉLITÉ
-- =============================================
INSERT INTO loyalty_rewards (title, description, points_required, category, is_active, is_popular, sort_order) VALUES
('-10% sur votre prochaine commande', 'Valable 3 mois sur tous les produits', 100, 'Réduction', true, true, 1),
('Échantillon Sérum Premium', 'Sérum anti-âge 7 jours d''utilisation', 50, 'Produit', true, false, 2),
('Livraison offerte', 'Livraison standard offerte sur votre prochaine commande', 75, 'Service', true, false, 3),
('Box Découverte', '5 produits full-size de notre gamme', 200, 'Produit', true, true, 4),
('Conseil personnalisé', '30 min avec notre experte dermatologique', 150, 'Service', true, false, 5),
('-20% sur commande illimitée', 'Réduction valable 6 mois sans minimum d''achat', 300, 'Réduction', true, true, 6);
