# 🔧 **Guide Debug - CORS + OrderData**

## ✅ **Corrections Appliquées**

### **1. Problème CORS Corrigé**
- ❌ **Avant** : `http://localhost:8080/api/orders/35`
- ✅ **Maintenant** : `http://localhost:8081/api/orders/35`
- 📁 **Fichiers modifiés** : `fetchOrderDetails` + `updateOrderWithWalletInfo`

### **2. OrderData false - Analyse**
- ❌ **Problème** : `orderData: false` dans les logs
- ✅ **Solution** : Récupération automatique si `orderData` est false
- ✅ **Logs** : État complet affiché pour débogage

---

## 🧪 **Test Étape par Étape**

### **1. Vérifier le Backend**
```bash
# Assurez-vous que le backend tourne sur le bon port
cd backend
mvn spring-boot:run
# Doit afficher : Started EtudiantApplication on port 8081
```

### **2. Vérifier le Frontend**
```bash
cd frontend
npm run dev
# Doit démarrer sur http://localhost:3000
```

### **3. Test du Flux**
1. **Créer une commande** : `http://localhost:3000/checkout`
2. **Vérifier les logs backend** : Commande créée avec ID
3. **Authentification** : OTP → Succès
4. **Page paiement** : `http://localhost:3000/payment-checkout`

### **4. Analyse des Logs Console**

#### **Logs Attendus sur payment-checkout**
```javascript
// Au chargement de la page
Récupération détails commande pour ID: 35
Détails commande reçus: { data: { orderId: 35, orderNumber: "PS...", ... } }

// Après création wallet
Wallet simulé créé: { success: true, data: { id: "wallet-xxxxxxxx" } }

// Au clic sur "Payer avec Faroty"
=== BOUTON PAYER CLIQUÉ ===
État actuel: {
  walletId: "wallet-xxxxxxxx",     // ← Doit être défini
  orderData: { ... },               // ← Doit être un objet
  userInfo: { ... },               // ← Doit être un objet
  cartItems: [...],                // ← Doit être un array
  orderId: "35"                   // ← Doit être une string
}
```

#### **Si orderData est false**
```javascript
État actuel: {
  walletId: "wallet-xxxxxxxx",
  orderData: false,                  // ← PROBLÈME
  userInfo: { ... },
  cartItems: [...],
  orderId: "35"
}

OrderData manquant - tentative de récupération automatique
Tentative récupération automatique commande ID: 35
```

---

## 🔍 **Points de Contrôle**

### **Vérifier le localStorage**
```javascript
// Dans la console (F12)
localStorage.getItem('pending_order_id')     // Doit être "35"
localStorage.getItem('faroty_user')          // Doit contenir les infos utilisateur
```

### **Vérifier l'URL**
```javascript
// Dans la console
window.location.pathname  // Doit être "/payment-checkout"
new URLSearchParams(window.location.search).get('orderId')  // Doit être "35"
```

### **Vérifier le réseau**
```javascript
// Onglet Network (F12)
// Chercher la requête vers /api/orders/35
// Doit avoir le statut 200
```

---

## 🐛 **Dépannage Avancé**

### **Si CORS persiste**
1. **Vérifier la configuration backend** :
   ```properties
   # application.properties
   spring.web.cors.allowed-origins=http://localhost:3000
   server.port=8081
   ```
2. **Redémarrer le backend** après modification
3. **Vider le cache** du navigateur

### **Si orderData reste false**
1. **Vérifier le useEffect** :
   ```javascript
   useEffect(() => {
     const orderId = new URLSearchParams(window.location.search).get('orderId');
     console.log('OrderId depuis URL:', orderId);
     
     if (orderId) {
       setOrderId(orderId);
       fetchOrderDetails(orderId); // ← Cette fonction doit peupler orderData
     }
   }, [router]);
   ```
2. **Vérifier la réponse API** :
   ```javascript
   const response = await fetch(`http://localhost:8081/api/orders/${orderId}`);
   console.log('Response status:', response.status);
   console.log('Response ok:', response.ok);
   const data = await response.json();
   console.log('Response data:', data);
   ```

### **Si le walletId est undefined**
1. **Vérifier la création wallet** :
   ```javascript
   const response = await farotyService.createWallet(user);
   console.log('Wallet response:', response);
   if (response.success) {
     console.log('Wallet ID:', response.data.id);
     setWalletId(response.data.id);
   }
   ```

---

## 🎯 **Solution Rapide**

### **Forcer orderData pour tester**
Si vous voulez tester rapidement le paiement sans attendre la correction :

```javascript
// Dans la console du navigateur sur payment-checkout
const testData = {
  orderNumber: "PS123456789",
  customerEmail: "test@example.com",
  totalAmount: 32.89,
  items: [{
    name: "Produit test",
    quantity: 1,
    price: 32.89
  }]
};

// Forcer l'état
window.orderData = testData;
```

### **Forcer le walletId pour tester**
```javascript
// Dans la console du navigateur sur payment-checkout
window.testWalletId = "wallet-test-123";
```

---

## 🚀 **Validation Finale**

### **Checklist Complète**
- [ ] Backend sur port 8081
- [ ] CORS configuré pour localhost:3000
- [ ] OrderId récupéré depuis l'URL
- [ ] OrderData peuplé via API
- [ ] Wallet créé avec ID sauvegardé
- [ ] Bouton paiement utilise handlePayment
- [ ] Session créée avec walletId valide
- [ ] Redirection vers Faroty fonctionnelle

### **Résultat Attendu**
Après correction :

1. **Plus d'erreur CORS** ✅
2. **OrderData est un objet** ✅
3. **WalletId est défini** ✅
4. **Session paiement créée** ✅
5. **Redirection immédiate** ✅

---

## 🎉 **Conclusion**

**Les problèmes identifiés sont maintenant en cours de correction :**

- ✅ **CORS** : Port corrigé de 8080 → 8081
- ✅ **OrderData** : Récupération automatique si false
- ✅ **Logs** : Détaillés pour identifier le problème
- ✅ **Fallback** : Tentative de récupération automatique

**Testez à nouveau le flux complet avec ces corrections !** 🚀

Les logs détaillés vous aideront à identifier exactement où se situe le problème.
