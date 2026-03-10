# Flux de Paiement Simplifié Faroty - PureSkin

## 🎯 Objectif
Simplifier le processus de paiement en éliminant la création de wallet et en utilisant directement un wallet fixe pour créer des sessions de paiement.

## 🔄 Nouveau Flux de Paiement

### 1. Authentification Utilisateur
- L'utilisateur s'authentifie via OTP avec Faroty
- Les informations utilisateur sont stockées dans `localStorage`
- Aucune création de wallet nécessaire

### 2. Création Session de Paiement Directe
- Utilisation du wallet fixe : `9c3cdf3b-ff0b-44d9-8aa0-4e638c88f660`
- Appel direct à l'API : `https://api-pay-prod.faroty.me/payments/api/v1/payment-sessions`
- Structure de la requête selon la documentation Faroty

### 3. Redirection Automatique
- Une fois la session créée, redirection automatique vers Faroty
- URL de redirection : `https://pay.faroty.me/payment?sessionToken={sessionToken}`

## 📋 Structure API

### Requête POST
```json
{
  "walletId": "9c3cdf3b-ff0b-44d9-8aa0-4e638c88f660",
  "currencyCode": "XAF",
  "cancelUrl": "https://votre-site.com/payment/cancel",
  "successUrl": "https://votre-site.com/payment/success",
  "type": "DEPOSIT",
  "amount": 20,
  "contentType": "CAMPAIGN_SIMPLE",
  "dynamicContentData": {
    "title": "Commande PureSkin - #12345",
    "description": "Articles: 1x Serum Hydratant (15000 XAF)",
    "target": "15000 XAF",
    "imageUrl": "https://media.faroty.me/api/media/public/c3e256db-6c97-48a7-8e8d-f2ba1d568727.jpg"
  }
}
```

### Réponse Attendue
```json
{
  "success": true,
  "message": "payment.session.created.success",
  "statusCode": 200,
  "timestamp": "2025-12-02T21:29:49.670061137",
  "data": {
    "sessionToken": "-PlIgutc6O4cNe9AeETyCgyf-nBn3WGD",
    "sessionUrl": "https://pay.faroty.me/payment?sessionToken=-PlIgutc6O4cNe9AeETyCgyf-nBn3WGD"
  },
  "pagination": null,
  "metadata": null
}
```

## 🔧 Implémentation Technique

### Service Faroty Simplifié
```typescript
// Méthode principale pour le flux complet
async processPayment(amount: number, orderData: OrderData): Promise<void> {
  // 1. Créer la session de paiement
  const sessionResponse = await this.createPaymentSession(amount, orderData);
  
  // 2. Rediriger directement vers Faroty
  if (sessionResponse.success && sessionResponse.data?.sessionToken) {
    this.redirectToPayment(sessionResponse.data.sessionToken);
  }
}

// Redirection vers la page de paiement
redirectToPayment(sessionToken: string): void {
  const paymentUrl = `https://pay.faroty.me/payment?sessionToken=${sessionToken}`;
  window.location.href = paymentUrl;
}
```

### Page de Paiement
```typescript
const handleCreatePaymentSession = async () => {
  try {
    // Flux simplifié - une seule méthode
    await farotyService.processPayment(orderData.totalAmount, {
      orderNumber: orderData.orderNumber,
      customerEmail: userInfo.email,
      items: orderData.items,
    });
  } catch (error) {
    setError(error.message);
  }
};
```

## ✅ Avantages du Nouveau Flux

### 1. Simplicité
- ❌ Plus de création de wallet
- ✅ Wallet fixe prédéfini
- ✅ Une seule étape : session → paiement

### 2. Fiabilité
- ✅ Moins d'appels API
- ✅ Moins de points d'échec
- ✅ Gestion centralisée des erreurs

### 3. Performance
- ✅ Temps de chargement réduit
- ✅ Redirection immédiate
- ✅ Expérience utilisateur fluide

### 4. Sécurité
- ✅ Wallet fixe et contrôlé
- ✅ Clé API publique uniquement
- ✅ Sessions temporaires

## 🔄 Étapes du Flux Utilisateur

1. **Connexion** → Authentification OTP ✅
2. **Commande** → Page de récapitulatif ✅
3. **Paiement** → Clic sur "Payer avec Faroty" ✅
4. **Session** → Création automatique ✅
5. **Redirection** → Page Faroty ✅
6. **Paiement** → Finalisation chez Faroty ✅
7. **Retour** → Page de succès/échec ✅

## 🛡️ Gestion des Erreurs

### Types d'Erreurs Gérées
- **Token expiré** → Redirection vers login
- **Session invalide** → Message d'erreur clair
- **API indisponible** → Fallback avec données simulées
- **Wallet invalide** → Utilisation du wallet fixe

### Messages d'Erreur
```typescript
// Erreurs spécifiques avec messages clairs
if (!requestBody.walletId) {
  throw new Error('Wallet ID est requis');
}
if (!requestBody.amount || requestBody.amount <= 0) {
  throw new Error('Montant valide est requis');
}
```

## 📊 Monitoring et Logs

### Logs de Suivi
```javascript
🚀 Démarrage du processus de paiement...
=== CRÉATION SESSION PAIEMENT FAROTY (SANS WALLET) ===
✅ Session créée avec succès: {sessionData}
🔄 Redirection vers la page de paiement Faroty: {paymentUrl}
```

### Métriques à Surveiller
- Taux de succès de création de session
- Temps de redirection
- Erreurs par type
- Conversion paiement

## 🔗 Points d'Intégration

### Pages Impliquées
- `/auth-checkout` → Authentification OTP
- `/payment-checkout` → Création session + redirection
- `/payment/success` → Confirmation paiement
- `/payment/cancel` → Annulation paiement

### Services Externes
- **Faroty API** → Création sessions
- **Faroty Pay** → Page de paiement
- **PureSkin Backend** → Gestion commandes

## 🚀 Déploiement et Configuration

### Variables d'Environnement
```typescript
FAROTY_API_URL = 'https://api-pay-prod.faroty.me'
FAROTY_PUBLIC_API_KEY = 'pk_live_2b6e8c5f-9a3d-4e7f-8c1b-6d9e0f5a7c8d'
PAYMENT_WALLET_ID = '9c3cdf3b-ff0b-44d9-8aa0-4e638c88f660'
```

### URLs de Callback
- **Success** : `https://pureskin.com/payment/success`
- **Cancel** : `https://pureskin.com/payment/cancel`
- **Webhook** : `https://api.pureskin.com/webhooks/faroty`

## 🎯 Conclusion

Le nouveau flux de paiement simplifié élimine la complexité de la gestion des wallets tout en offrant une expérience utilisateur fluide et sécurisée. L'utilisation d'un wallet fixe réduit les points d'échec et garantit une meilleure fiabilité du processus de paiement.
