# 🔧 **Guide de Debug Paiement Faroty**

## ✅ **Corrections Appliquées**

### **1. Suppression Délai**
- ❌ **Avant** : `setTimeout(() => {...}, 1500)` (1.5 secondes)
- ✅ **Maintenant** : `farotyService.redirectToPayment(sessionUrl)` (immédiat)

### **2. Simplification Redirection**
- ❌ **Avant** : Validation URL + fallback
- ✅ **Maintenant** : `window.location.href = sessionUrl` (direct)

### **3. Logs Détaillés**
- ✅ **Bouton cliqué** : `=== BOUTON PAYER CLIQUÉ ===`
- ✅ **Vérifications** : Informations manquantes
- ✅ **API appelée** : `Appel API création session...`
- ✅ **Réponse** : Session URL reçue
- ✅ **Redirection** : `Redirection immédiate vers Faroty`

---

## 🧪 **Test Étape par Étape**

### **Ouvrez la Console (F12)**

1. **Allez sur** : `http://localhost:3000/payment-checkout`
2. **Vérifiez** que vous avez :
   - ✅ Wallet créé
   - ✅ Informations utilisateur
   - ✅ Bouton "Payer avec Faroty" visible

3. **Cliquez sur** : "Payer avec Faroty"

### **Logs Attendus dans la Console**

```javascript
=== BOUTON PAYER CLIQUÉ ===
Début processus paiement...
=== DÉBUT CRÉATION SESSION PAIEMENT ===
Wallet ID: wallet-xxxxxxxx
Order Data: {orderNumber: "PS...", totalAmount: 32.89, ...}
User Info: {id: "c173d45d-...", fullName: "...", email: "..."}
Cart Items: [{name: "Sérum...", quantity: 1, price: 22.99}]
Appel API création session...
Session de paiement simulée créée avec URL Faroty valide: {
  success: true,
  data: {
    sessionToken: "session-xxxxxxxx",
    sessionUrl: "https://pay.faroty.me/payment?sessionToken=session-xxxxxxxx"
  }
}
Réponse session paiement: {...}
Session URL reçue: https://pay.faroty.me/payment?sessionToken=session-xxxxxxxx
Redirection immédiate vers Faroty: https://pay.faroty.me/payment?sessionToken=session-xxxxxxxx
Redirection immédiate vers Faroty: https://pay.faroty.me/payment?sessionToken=session-xxxxxxxx
```

### **Comportement Attendu**

1. **Click** → Loading apparaît
2. **API** → Session créée (simulation)
3. **Message** → "Session de paiement créée !"
4. **Redirection** → Immédiate vers Faroty
5. **Page** → `https://pay.faroty.me/payment?sessionToken=...`

---

## 🐛 **Dépannage**

### **Si rien ne se passe**

#### **Vérifiez la console :**
- [ ] Avez-vous `=== BOUTON PAYER CLIQUÉ ===` ?
- [ ] Y a-t-il des erreurs JavaScript ?
- [ ] Le bouton est-il bien cliquable ?

#### **Vérifiez le code :**
- [ ] La fonction `handlePayment` est-elle bien appelée ?
- [ ] Les variables `walletId`, `orderData`, `userInfo` existent ?
- [ ] L'appel API `farotyService.createPaymentSession` fonctionne ?

#### **Vérifiez le DOM :**
- [ ] Le bouton a-t-il le bon `onClick` ?
- [ ] Y a-t-il des erreurs React ?
- [ ] Le composant est-il bien monté ?

---

## 🔍 **Points de Contrôle**

### **Dans le Navigateur (F12)**

1. **Onglet Console** :
   - Cherchez `=== BOUTON PAYER CLIQUÉ ===`
   - Vérifiez les erreurs rouges

2. **Onglet Network** :
   - Cherchez des requêtes `payment-sessions`
   - Vérifiez les statuts 200/400/401

3. **Onglet Elements** :
   - Inspectez le bouton "Payer avec Faroty"
   - Vérifiez l'attribut `onClick`

### **Dans le Code**

#### **payment-checkout/page.tsx**
```tsx
<button
  onClick={handlePayment}  // ← Vérifiez cette ligne
  disabled={isLoading || !walletId}
  className="w-full bg-green-600 text-white py-3 px-6 rounded-lg hover:bg-green-700 disabled:opacity-50"
>
  {isLoading ? 'Création...' : 'Payer avec Faroty'}
</button>
```

---

## 🎯 **Solution si Problème**

### **Le bouton ne répond pas :**

1. **Vérifiez** que `handlePayment` est bien exportée
2. **Vérifiez** qu'il n'y a pas d'erreurs TypeScript
3. **Vérifiez** que le composant est bien monté

### **La redirection ne fonctionne pas :**

1. **Vérifiez** que `sessionUrl` est bien une string
2. **Vérifiez** que `window.location.href` fonctionne
3. **Essayez** : `window.open(sessionUrl, '_self')`

### **L'API ne répond pas :**

1. **Vérifiez** la clé API dans `faroty-service.ts`
2. **Vérifiez** l'URL de l'endpoint
3. **Vérifiez** le format des données envoyées

---

## 🚀 **Test Final**

### **Pour tester rapidement :**

1. **Ouvrez** la console
2. **Exécutez** manuellement :
   ```javascript
   farotyService.redirectToPayment('https://pay.faroty.me/payment?sessionToken=test');
   ```
3. **Vérifiez** que la redirection fonctionne

### **Si ça marche :**
- Le problème vient de la création de session
- Vérifiez les logs de `createPaymentSession`

### **Si ça ne marche pas :**
- Le problème vient de la redirection
- Vérifiez `window.location.href`

---

## 🎉 **Résultat Attendu**

**Après correction, quand vous cliquez sur "Payer avec Faroty" :**

- ✅ **Immédiatement** → Redirection vers Faroty
- ✅ **Sans délai** → Pas d'attente 1.5s
- ✅ **URL valide** → `https://pay.faroty.me/payment?sessionToken=...`
- ✅ **Logs clairs** → Débogage facile

**La session s'ouvrira immédiatement comme demandé !** 🚀
