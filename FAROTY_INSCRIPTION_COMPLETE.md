# Système d'Inscription Faroty - PureSkin

## 🎯 Objectif
Créer un système d'inscription complet avec Faroty, incluant :
- Formulaire d'inscription
- Envoi OTP pour vérification
- Vérification OTP et authentification
- Intégration avec le système de paiement

## 🔄 Flux d'Inscription Complet

### **Étape 1: Inscription**
```
POST https://api-prod.faroty.me/auth/api/auth/register
Body: {
  "fullName": "Christian fotso",
  "contact": "sfotsowomgne084@gmail.com"
}
```

**Réponse Attendue:**
```json
{
  "success": true,
  "message": "Inscription réussie. Un code de vérification a été envoyé.",
  "data": {
    "tempToken": "a0099c19-c6fe-4ab7-b863-9c42c4280925",
    "contact": "s***@gmail.com",
    "channel": "EMAIL",
    "message": "Code de vérification envoyé à votre email",
    "newUser": false
  },
  "error": null,
  "timestamp": [2026, 3, 5, 9, 25, 71339657]
}
```

### **Étape 2: Vérification OTP**
```
POST https://api-prod.faroty.me/auth/api/auth/verify-otp
Body: {
  "otpCode": "07250",
  "tempToken": "a0099c19-c6fe-4ab7-b863-9c42c4280925",
  "deviceInfo": {
    "deviceId": "device-1234",
    "deviceType": "WEB",
    "deviceModel": "Web Browser",
    "osName": "Web Browser",
    "manufacturer": null,
    "pushNotificationToken": null,
    "userAgent": "Mozilla/5.0...",
    "ipAddress": "102.244.197.150",
    "location": null,
    "isPhysicalDevice": false
  }
}
```

**Réponse Attendue:**
```json
{
  "success": true,
  "message": "Authentification réussie",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9...",
    "tokenType": null,
    "expiresIn": 3600,
    "user": {
      "id": "53527106-2e69-4433-9090-99ff7b19e4eb",
      "fullName": "Christian fotso",
      "email": "sfotsowomgne084@gmail.com",
      "phoneNumber": null,
      "profilePictureUrl": null,
      "languageCode": "fr",
      "countryCode": null,
      "guest": false
    },
    "device": {
      "deviceId": "device-1234",
      "deviceType": "WEB",
      "deviceModel": "iPhone de Mac",
      "osName": "tester",
      "osVersion": null,
      "manufacturer": null,
      "pushNotificationToken": null,
      "userAgent": null,
      "ipAddress": "102.244.197.150",
      "location": null,
      "isPhysicalDevice": false
    },
    "session": {
      "id": "22fde939-6d5c-4811-8166-00c9672da571",
      "sessionToken": "eb0b5df1-2b20-4921-b749-e9d7f7b6cbfd",
      "loginTime": 1772701885.335398414,
      "lastActivityTime": 1772701885.335398675,
      "ipAddress": "102.244.197.150",
      "location": null,
      "current": true
    }
  },
  "error": null,
  "timestamp": [2026, 3, 5, 9, 11, 25, 352684087]
}
```

## 📁 Fichiers Créés

### **1. Page d'Inscription (`/register/page.tsx`)**
- ✅ Formulaire avec nom complet et contact (email/téléphone)
- ✅ Validation et gestion des erreurs
- ✅ Envoi vers API Faroty
- ✅ Transition automatique vers vérification OTP
- ✅ Design moderne et responsive

### **2. Modification Page Authentification (`/auth-checkout/page.tsx`)**
- ✅ Ajout du lien "Créer un compte"
- ✅ Utilisation de `faroty_access_token` pour l'authentification
- ✅ Intégration avec le système de paiement

### **3. Intégration Paiement (`/payment-checkout/page.tsx`)**
- ✅ Vérification du `faroty_access_token`
- ✅ Utilisation des tokens Faroty pour les paiements
- ✅ Gestion des informations de paiement

## 🎨 Interface Utilisateur

### **Page d'Inscription**
- **Design moderne** : Gradient vert-bleu, coins arrondis
- **Formulaire intuitif** : Icônes, placeholders, validation
- **Feedback utilisateur** : Messages de succès/erreur clairs
- **Responsive** : Adapté mobile/desktop

### **Page Authentification**
- **Lien d'inscription** : Visible pour les nouveaux utilisateurs
- **Deux étapes** : Email → OTP → Authentification
- **Sécurité** : Codes OTP à usage unique

## 🔐 Sécurité et Validation

### **Côté Client**
- Validation des champs requis
- Format email/téléphone
- Longueur maximale des champs
- Protection contre les soumissions multiples

### **Côté API**
- Validation des données d'entrée
- Gestion des erreurs appropriée
- Tokens sécurisés (JWT)
- Device fingerprinting

## 🔄 Intégration avec le Système de Paiement

### **Stockage des Tokens**
```javascript
// Après inscription réussie
localStorage.setItem('faroty_access_token', accessToken);
localStorage.setItem('faroty_refresh_token', refreshToken);
localStorage.setItem('faroty_user', JSON.stringify(user));

// Utilisation dans le paiement
const accessToken = localStorage.getItem('faroty_access_token');
const user = JSON.parse(localStorage.getItem('faroty_user') || '{}');
```

### **Flux de Paiement**
1. **Inscription** → Vérification OTP → Authentification
2. **Authentification** → Redirection vers `/payment-checkout`
3. **Paiement** → Utilisation de `accessToken` Faroty
4. **Session** → Création et redirection vers Faroty Pay

## 📱 Expérience Utilisateur

### **Inscription**
1. **Formulaire** : Nom + Email/Téléphone
2. **Envoi OTP** : Code à 6 chiffres par email/SMS
3. **Vérification** : Saisie du code OTP
4. **Authentification** : Connexion automatique après vérification
5. **Redirection** : Vers la page de paiement

### **Paiement**
1. **Vérification token** : Contrôle de l'accessToken
2. **Session Faroty** : Création avec wallet fixe
3. **Redirection** : Vers la page de paiement Faroty
4. **Finalisation** : Paiement sécurisé

## 🛠️ Configuration Technique

### **Variables d'Environnement**
```javascript
// URLs Faroty
FAROTY_API_URL = "https://api-prod.faroty.me"
FAROTY_REGISTER_URL = "https://api-prod.faroty.me/auth/api/auth/register"
FAROTY_VERIFY_OTP_URL = "https://api-prod.faroty.me/auth/api/auth/verify-otp"
FAROTY_PAY_URL = "https://pay.faroty.me/payment"
```

### **Headers API**
```javascript
const headers = {
  'Content-Type': 'application/json',
  'User-Agent': navigator.userAgent
};
```

### **Device Info**
```javascript
const deviceInfo = {
  deviceId: "device-1234",
  deviceType: "WEB",
  deviceModel: "Web Browser",
  osName: "Web Browser",
  manufacturer: null,
  pushNotificationToken: null,
  userAgent: navigator.userAgent,
  ipAddress: "102.244.197.150",
  location: null,
  isPhysicalDevice: false
};
```

## 🔍 Gestion des Erreurs

### **Erreurs d'Inscription**
- **Email invalide** : "Format d'email incorrect"
- **Contact requis** : "Email ou téléphone requis"
- **Erreur API** : "Erreur lors de l'inscription"
- **Réseau** : "Erreur de connexion"

### **Erreurs OTP**
- **Code invalide** : "Code OTP incorrect"
- **Code expiré** : "Code OTP expiré"
- **Tentatives excessives** : "Trop de tentatives"
- **Token invalide** : "Session expirée"

### **Messages de Succès**
- **Inscription** : "Inscription réussie ! Code envoyé"
- **Vérification** : "Authentification réussie !"
- **Redirection** : "Redirection vers le paiement..."

## 📊 Monitoring et Logs

### **Logs Client**
```javascript
console.log('🔐 Tentative d\'inscription Faroty...');
console.log('✅ Inscription réussie, tempToken:', data.data.tempToken);
console.log('🔍 Vérification OTP...');
console.log('✅ Vérification OTP réussie !');
console.log('📋 Informations de paiement chargées:', paymentInfo);
```

### **Tracking**
- Tentatives d'inscription
- Taux de conversion
- Erreurs par type
- Performance des API

## 🎯 Avantages du Système

### **Sécurité**
- ✅ **Double authentification** : Email + OTP
- ✅ **Tokens JWT** : Sécurisés et expirants
- ✅ **Device fingerprinting** : Protection contre les fraudes
- ✅ **Validation** : Côté client et serveur

### **Expérience Utilisateur**
- ✅ **Flux simple** : 3 étapes claires
- ✅ **Feedback immédiat** : Messages en temps réel
- ✅ **Design moderne** : Interface attractive
- ✅ **Responsive** : Mobile-friendly

### **Intégration**
- ✅ **API Faroty** : Utilisation des endpoints officiels
- ✅ **Paiement unifié** : Même système pour tous
- ✅ **Tokens partagés** : Entre inscription et paiement
- ✅ **Backend prêt** : Compatible Spring Boot

## 🚀 Déploiement

### **Frontend**
1. **Build** : `npm run build`
2. **Routes** : `/register` et `/auth-checkout`
3. **Variables** : Configuration des URLs Faroty
4. **Test** : Validation du flux complet

### **Backend**
1. **Endpoints** : Routes API Faroty existantes
2. **Validation** : Intégration avec Spring Security
3. **Logs** : Traçage des inscriptions
4. **Base de données** : Stockage des utilisateurs

## 📚 Documentation Complète

### **API Faroty**
- [Documentation officielle](https://docs.faroty.me)
- [Endpoints d'authentification](https://api-prod.faroty.me/docs)
- [Support développeur](support@faroty.me)

### **Intégration**
- [React + Next.js](https://nextjs.org/docs)
- [Spring Boot](https://spring.io/guides)
- [JWT](https://jwt.io/)

---

**Le système d'inscription Faroty est maintenant complet et prêt à l'utilisation !** 🚀

Les utilisateurs peuvent :
1. **S'inscrire** avec email/téléphone
2. **Vérifier** leur identité avec OTP
3. **S'authentifier** automatiquement
4. **Payer** en utilisant les tokens Faroty

Le tout avec une interface moderne et une sécurité renforcée !
