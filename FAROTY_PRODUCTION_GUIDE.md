# 🚀 **Guide d'Utilisation Faroty - Production**

## 🔑 **Configuration Requise**

### 1. **Clés API Faroty**
Vous avez reçu les clés API de production Faroty. Remplacez `VOTRE_ACCOUNT_ID` par votre vrai ID de compte Faroty.

```bash
# Dans .env.local
NEXT_PUBLIC_FAROTY_ACCOUNT_ID=VOTRE_VRAI_ACCOUNT_ID
NEXT_PUBLIC_FAROTY_PUBLIC_KEY=fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU
NEXT_PUBLIC_FAROTY_PRIVATE_KEY=fs_live_Etb1Tgk3dSLMeco6KuM0XiR0DPlLHnKdYPOY0M2oBPxXU7F7RAmI2-XZB4khe-dDYnrV-ChCeGs
```

### 2. **Base de Données**
Assurez-vous que les tables existent avec les champs Faroty :

```sql
-- Script pour ajouter les champs Faroty
ALTER TABLE orders ADD COLUMN IF NOT EXISTS wallet_id VARCHAR(255);
ALTER TABLE orders ADD COLUMN IF NOT EXISTS session_token VARCHAR(255);
ALTER TABLE orders ADD COLUMN IF NOT EXISTS faroty_user_id VARCHAR(255);

-- Index pour optimisation
CREATE INDEX IF NOT EXISTS idx_orders_wallet_id ON orders(wallet_id);
CREATE INDEX IF NOT EXISTS idx_orders_session_token ON orders(session_token);
CREATE INDEX IF NOT EXISTS idx_orders_faroty_user_id ON orders(faroty_user_id);
```

---

## 🔄 **Flux Complet d'Utilisation**

### Étape 1: **Finalisation Commande**
1. Client remplit le formulaire `/checkout`
2. ✅ Commande créée dans la base de données PureSkin
3. ✅ Client créé automatiquement si inexistant
4. Redirection vers `/auth-checkout`

### Étape 2: **Authentification OTP**
1. Page affiche "Entrez votre email"
2. Envoi du code OTP via API Faroty
3. Réponse: `tempToken` reçu et sauvegardé
4. Page affiche "Entrez le code à 6 chiffres"
5. Vérification du code OTP avec `tempToken`
6. Réponse: Utilisateur Faroty authentifié

### Étape 3: **Création Wallet**
1. Page `/payment-checkout` affiche les infos utilisateur
2. Bouton "Créer mon Wallet Faroty"
3. ✅ Wallet créé avec l'ID utilisateur Faroty
4. ✅ Commande mise à jour avec `walletId`

### Étape 4: **Paiement**
1. Bouton "Payer avec Faroty"
2. ✅ Session de paiement créée
3. Redirection automatique vers `pay.faroty.me`
4. Client finalise le paiement sur Faroty
5. Redirection vers `/payment/success`

---

## 🛠 **Dépannage**

### Problèmes Communs

#### 1. **"Access non autorisé"**
- ✅ **Solution**: Vérifiez que vous utilisez les clés de PRODUCTION
- ✅ **Vérification**: Clés commencent par `fk_live_` et `fs_live_`

#### 2. **"Code OTP invalide"**
- ✅ **Solution**: Le code a expiré (10 minutes)
- ✅ **Action**: Demander un nouveau code OTP

#### 3. **"Erreur création wallet"**
- ✅ **Solution**: Vérifiez `NEXT_PUBLIC_FAROTY_ACCOUNT_ID`
- ✅ **Vérification**: ID doit être valide et actif

#### 4. **"Erreur session paiement"**
- ✅ **Solution**: Vérifiez `NEXT_PUBLIC_FAROTY_PRIVATE_KEY`
- ✅ **Vérification**: Clé privée doit commencer par `fs_live_`

---

## 📁 **Endpoints API Utilisés**

### Authentification
- **Login OTP**: `POST https://api-prod.faroty.me/auth/api/auth/login`
- **Vérification OTP**: `POST https://api-prod.faroty.me/auth/api/auth/verify-otp`

### Paiement
- **Créer Wallet**: `POST https://api-pay-prod.faroty.me/payments/api/v1/wallets`
- **Session Paiement**: `POST https://api-pay-prod.faroty.me/payments/api/v1/payment-sessions`

### Redirection
- **Page Paiement**: `https://pay.faroty.me/payment?sessionToken=TOKEN`

---

## 🔧 **Configuration Technique**

### Variables d'Environnement
```bash
# Production
NEXT_PUBLIC_FAROTY_ACCOUNT_ID=VOTRE_VRAI_ACCOUNT_ID
NEXT_PUBLIC_FAROTY_PUBLIC_KEY=fk_live_...
NEXT_PUBLIC_FAROTY_PRIVATE_KEY=fs_live_...

# Développement (si besoin)
NEXT_PUBLIC_FAROTY_ACCOUNT_ID=VOTRE_ACCOUNT_ID_TEST
NEXT_PUBLIC_FAROTY_PUBLIC_KEY=fk_test_...
NEXT_PUBLIC_FAROTY_PRIVATE_KEY=fs_test_...
```

### Headers Requis
```javascript
{
  'Content-Type': 'application/json',
  'Authorization': 'Bearer VOTRE_CLÉ_API'
}
```

---

## 🎯 **Tests Recommandés**

### 1. **Test API**
```bash
# Test envoi OTP
curl -X POST https://api-prod.faroty.me/auth/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer VOTRE_CLÉ_PUBLIQUE" \
  -d '{
    "contact": "test@example.com",
    "deviceInfo": {
      "deviceId": "test-device",
      "deviceType": "WEB",
      "deviceModel": "Test PC",
      "osName": "Windows"
    },
    "publicKey": "VOTRE_CLÉ_PUBLIQUE"
  }'
```

### 2. **Test Frontend**
1. Ouvrir `http://localhost:3000/checkout`
2. Remplir le formulaire avec un email de test
3. Suivre le flux complet
4. Vérifier les logs du navigateur et du backend

---

## 📊 **Monitoring**

### Logs à Surveiller
- **Backend**: Logs Spring Boot dans la console
- **Frontend**: Logs navigateur (F12)
- **Réseau**: Onglet Network des outils de développement

### KPI à Suivre
- ✅ Taux de conversion checkout → commande
- ✅ Taux de succès authentification OTP
- ✅ Taux de création wallet
- ✅ Taux de réussite paiement

---

## 🚨 **Sécurité**

### Protection des Clés
- ❌ **Jamais** commit les clés API dans Git
- ✅ **Toujours** utiliser les variables d'environnement
- ✅ **Séparer** clés de test et de production

### Validation des Données
- ✅ **Email**: Validation format avant envoi
- ✅ **OTP**: Validation 6 chiffres uniquement
- ✅ **Montants**: Validation numérique positive
- ✅ **Tokens**: Sauvegarde sécurisée dans localStorage

---

## 🎉 **Déploiement**

### Avant de Mettre en Production
1. ✅ Remplacer `VOTRE_ACCOUNT_ID` par le vrai ID
2. ✅ Tester le flux complet en environnement de staging
3. ✅ Vérifier toutes les URLs de redirection
4. ✅ Configurer les domaines Faroty autorisés
5. ✅ Activer le monitoring et les alertes

### Checklist de Déploiement
- [ ] Clés API configurées
- [ ] Base de données à jour
- [ ] URLs de redirection valides
- [ ] Tests fonctionnels
- [ ] Monitoring activé
- [ ] Documentation à jour

---

## 📞 **Support**

### En Cas de Problème
1. **Vérifier les logs** du backend et frontend
2. **Consulter** ce guide de dépannage
3. **Tester** avec les clés de test si disponible
4. **Contacter** le support Faroty si problème persiste

### Contact Support
- **Email**: support@faroty.me
- **Documentation**: https://docs.faroty.me
- **API Reference**: https://api.faroty.me/docs

---

**Le système est maintenant prêt pour la production avec Faroty !** 🚀

Suivez ce guide étape par étape pour une mise en production réussie.
