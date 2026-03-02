# 🔄 GUIDE DE COMMUNICATION FRONTEND - BACKEND - BASE DE DONNÉES

## 📋 ARCHITECTURE GLOBALE

```
┌─────────────────┐    HTTP/HTTPS     ┌─────────────────┐    JDBC/SQL     ┌─────────────────┐
│   FRONTEND     │ ◄──────────────► │    BACKEND      │ ◄──────────────► │ BASE DE DONNÉES │
│   (Next.js)    │                  │  (Spring Boot)  │                  │  (PostgreSQL)   │
│                │                  │                 │                  │                 │
│ - React        │                  │ - Controllers   │                  │ - Tables        │
│ - TypeScript   │                  │ - Services      │                  │ - Index         │
│ - Tailwind     │                  │ - Repositories  │                  │ - Triggers      │
│ - Fetch/Axios  │                  │ - JPA/Hibernate │                  │ - Constraints   │
└─────────────────┘                  └─────────────────┘                  └─────────────────┘
```

---

## 🎯 ÉTAPE 1: CONFIGURATION BACKEND - BASE DE DONNÉES

### 1.1 Configuration de la connexion PostgreSQL

Dans `backend/src/main/resources/application.properties` :

```properties
# Connexion à la base de données
spring.datasource.url=jdbc:postgresql://localhost:5432/pureskin
spring.datasource.username=postgres
spring.datasource.password=votre_password
spring.datasource.driver-class-name=org.postgresql.Driver

# Configuration JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true

# Configuration du pool de connexions
spring.datasource.hikari.connection-timeout=20000
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
```

### 1.2 Dépendances Maven nécessaires

Dans `backend/pom.xml` :

```xml
<dependencies>
    <!-- Spring Boot Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- Driver PostgreSQL -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Spring Boot Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
</dependencies>
```

---

## 🎯 ÉTAPE 2: MODÈLES DE DONNÉES (ENTITIES)

### 2.1 Exemple : Entity Product

Dans `backend/src/main/java/com/pureskin/etudiant/entity/Product.java` :

```java
package com.pureskin.etudiant.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "products")
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 255)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;
    
    @Column(precision = 10, scale = 2)
    private BigDecimal originalPrice;
    
    @Column(length = 255)
    private String image;
    
    @Column(length = 255)
    private String imageUrl; // Pour compatibilité frontend
    
    @Column(length = 50)
    private String badge;
    
    @Column(nullable = false)
    private Integer stockQuantity = 0;
    
    @Column(nullable = false)
    private Boolean isActive = true;
    
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructeurs
    public Product() {}
    
    public Product(String name, String description, BigDecimal price) {
        this.name = name;
        this.description = description;
        this.price = price;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(BigDecimal originalPrice) { this.originalPrice = originalPrice; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }
    
    public Integer getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(Integer stockQuantity) { this.stockQuantity = stockQuantity; }
    
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    // Lifecycle callbacks
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
```

### 2.2 Entity Order (pour le checkout)

Dans `backend/src/main/java/com/pureskin/etudiant/entity/Order.java` :

```java
package com.pureskin.etudiant.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false, length = 50)
    private String orderNumber;
    
    @Column(nullable = false, length = 255)
    private String customerEmail;
    
    @Column(name = "customer_first_name", length = 100)
    private String customerFirstName;
    
    @Column(name = "customer_last_name", length = 100)
    private String customerLastName;
    
    @Column(name = "customer_phone", length = 20)
    private String customerPhone;
    
    @Column(name = "subtotal", precision = 10, scale = 2)
    private BigDecimal subtotal;
    
    @Column(name = "shipping_cost", precision = 10, scale = 2)
    private BigDecimal shippingCost = BigDecimal.ZERO;
    
    @Column(name = "tax_amount", precision = 10, scale = 2)
    private BigDecimal taxAmount = BigDecimal.ZERO;
    
    @Column(name = "total_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;
    
    @Column(nullable = false, length = 20)
    private String status = "PENDING";
    
    @Column(name = "payment_status", nullable = false, length = 20)
    private String paymentStatus = "PENDING";
    
    @Column(name = "payment_method", length = 50)
    private String paymentMethod;
    
    @Column(name = "wallet_id", length = 255)
    private String walletId;
    
    @Column(name = "session_token", length = 500)
    private String sessionToken;
    
    @Column(name = "faroty_user_id", length = 255)
    private String farotyUserId;
    
    @Column(name = "shipping_address", columnDefinition = "TEXT")
    private String shippingAddress;
    
    @Column(name = "billing_address", columnDefinition = "TEXT")
    private String billingAddress;
    
    @Column(name = "shipping_city", length = 100)
    private String shippingCity;
    
    @Column(name = "shipping_postal_code", length = 20)
    private String shippingPostalCode;
    
    @Column(name = "shipping_country", length = 100)
    private String shippingCountry = "France";
    
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    @Column(name = "paid_at")
    private LocalDateTime paidAt;
    
    // Relations
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> orderItems = new ArrayList<>();
    
    // Constructeurs
    public Order() {}
    
    // Getters et Setters (similaire à Product)
    // ...
    
    // Lifecycle callbacks
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (orderNumber == null) {
            orderNumber = "PS" + System.currentTimeMillis();
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
```

---

## 🎯 ÉTAPE 3: REPOSITORIES (ACCÈS AUX DONNÉES)

### 3.1 Repository Product

Dans `backend/src/main/java/com/pureskin/etudiant/repository/ProductRepository.java` :

```java
package com.pureskin.etudiant.repository;

import com.pureskin.etudiant.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Trouver les produits actifs
    List<Product> findByIsActiveTrue();
    
    // Trouver par nom (recherche)
    @Query("SELECT p FROM Product p WHERE p.isActive = true AND " +
           "(LOWER(p.name) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
           "LOWER(p.description) LIKE LOWER(CONCAT('%', :name, '%')))")
    List<Product> findActiveByNameContaining(@Param("name") String name);
    
    // Trouver par badge
    List<Product> findByBadgeAndIsActiveTrue(String badge);
    
    // Compter les produits actifs
    @Query("SELECT COUNT(p) FROM Product p WHERE p.isActive = true")
    long countActiveProducts();
    
    // Vérifier le stock
    @Query("SELECT p.stockQuantity FROM Product p WHERE p.id = :productId AND p.isActive = true")
    Integer getStockQuantity(@Param("productId") Long productId);
    
    // Mettre à jour le stock
    @Query("UPDATE Product p SET p.stockQuantity = p.stockQuantity - :quantity WHERE p.id = :productId")
    void updateStock(@Param("productId") Long productId, @Param("quantity") Integer quantity);
}
```

### 3.2 Repository Order

Dans `backend/src/main/java/com/pureskin/etudiant/repository/OrderRepository.java` :

```java
package com.pureskin.etudiant.repository;

import com.pureskin.etudiant.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    // Trouver par email client
    List<Order> findByCustomerEmailOrderByCreatedAtDesc(String customerEmail);
    
    // Trouver par numéro de commande
    Optional<Order> findByOrderNumber(String orderNumber);
    
    // Trouver par statut
    List<Order> findByStatusOrderByCreatedAtDesc(String status);
    
    // Trouver par statut de paiement
    List<Order> findByPaymentStatusOrderByCreatedAtDesc(String paymentStatus);
    
    // Trouver par wallet ID Faroty
    Optional<Order> findByWalletId(String walletId);
    
    // Compter les commandes par statut
    @Query("SELECT COUNT(o) FROM Order o WHERE o.status = :status")
    long countByStatus(@Param("status") String status);
    
    // Trouver les commandes récentes
    @Query("SELECT o FROM Order o WHERE o.createdAt >= :since ORDER BY o.createdAt DESC")
    List<Order> findRecentOrders(@Param("since") LocalDateTime since);
}
```

---

## 🎯 ÉTAPE 4: SERVICES (LOGIQUE MÉTIER)

### 4.1 Service Product

Dans `backend/src/main/java/com/pureskin/etudiant/service/ProductService.java` :

```java
package com.pureskin.etudiant.service;

import com.pureskin.etudiant.entity.Product;
import com.pureskin.etudiant.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    // Obtenir tous les produits actifs
    public List<Product> getAllActiveProducts() {
        return productRepository.findByIsActiveTrue();
    }
    
    // Obtenir un produit par ID
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }
    
    // Rechercher des produits
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveProducts();
        }
        return productRepository.findActiveByNameContaining(keyword.trim());
    }
    
    // Obtenir les produits par badge
    public List<Product> getProductsByBadge(String badge) {
        return productRepository.findByBadgeAndIsActiveTrue(badge);
    }
    
    // Créer un nouveau produit
    public Product createProduct(Product product) {
        product.setIsActive(true);
        return productRepository.save(product);
    }
    
    // Mettre à jour un produit
    public Product updateProduct(Long id, Product productDetails) {
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setName(productDetails.getName());
            product.setDescription(productDetails.getDescription());
            product.setPrice(productDetails.getPrice());
            product.setOriginalPrice(productDetails.getOriginalPrice());
            product.setImage(productDetails.getImage());
            product.setImageUrl(productDetails.getImageUrl());
            product.setBadge(productDetails.getBadge());
            product.setStockQuantity(productDetails.getStockQuantity());
            product.setIsActive(productDetails.getIsActive());
            return productRepository.save(product);
        }
        return null;
    }
    
    // Supprimer un produit (désactiver)
    public boolean deleteProduct(Long id) {
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setIsActive(false);
            productRepository.save(product);
            return true;
        }
        return false;
    }
    
    // Vérifier le stock
    public boolean checkStock(Long productId, Integer quantity) {
        Integer availableStock = productRepository.getStockQuantity(productId);
        return availableStock != null && availableStock >= quantity;
    }
    
    // Réduire le stock
    public void reduceStock(Long productId, Integer quantity) {
        productRepository.updateStock(productId, quantity);
    }
}
```

### 4.2 Service Order

Dans `backend/src/main/java/com/pureskin/etudiant/service/OrderService.java` :

```java
package com.pureskin.etudiant.service;

import com.pureskin.etudiant.entity.Order;
import com.pureskin.etudiant.entity.OrderItem;
import com.pureskin.etudiant.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private ProductService productService;
    
    // Créer une nouvelle commande
    public Order createOrder(Order orderData, List<OrderItem> items) {
        // Vérifier le stock pour chaque article
        for (OrderItem item : items) {
            if (!productService.checkStock(item.getProductId(), item.getQuantity())) {
                throw new RuntimeException("Stock insuffisant pour le produit ID: " + item.getProductId());
            }
        }
        
        // Calculer les totaux
        BigDecimal subtotal = items.stream()
            .map(item -> item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        orderData.setSubtotal(subtotal);
        orderData.setShippingCost(BigDecimal.valueOf(4.99)); // Frais de port fixes
        orderData.setTotalAmount(subtotal.add(orderData.getShippingCost()));
        
        // Sauvegarder la commande
        Order savedOrder = orderRepository.save(orderData);
        
        // Ajouter les articles et réduire le stock
        for (OrderItem item : items) {
            item.setOrder(savedOrder);
            savedOrder.getOrderItems().add(item);
            
            // Réduire le stock
            productService.reduceStock(item.getProductId(), item.getQuantity());
        }
        
        return orderRepository.save(savedOrder);
    }
    
    // Obtenir une commande par ID
    public Optional<Order> getOrderById(Long id) {
        return orderRepository.findById(id);
    }
    
    // Obtenir une commande par numéro
    public Optional<Order> getOrderByNumber(String orderNumber) {
        return orderRepository.findByOrderNumber(orderNumber);
    }
    
    // Obtenir les commandes d'un client
    public List<Order> getCustomerOrders(String email) {
        return orderRepository.findByCustomerEmailOrderByCreatedAtDesc(email);
    }
    
    // Mettre à jour le statut
    public Order updateOrderStatus(Long id, String status) {
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.setStatus(status);
            return orderRepository.save(order);
        }
        return null;
    }
    
    // Mettre à jour le statut de paiement
    public Order updatePaymentStatus(Long id, String paymentStatus) {
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.setPaymentStatus(paymentStatus);
            if ("COMPLETED".equals(paymentStatus)) {
                order.setPaidAt(LocalDateTime.now());
            }
            return orderRepository.save(order);
        }
        return null;
    }
    
    // Associer un wallet Faroty
    public Order associateFarotyWallet(Long orderId, String walletId, String sessionToken, String farotyUserId) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.setWalletId(walletId);
            order.setSessionToken(sessionToken);
            order.setFarotyUserId(farotyUserId);
            return orderRepository.save(order);
        }
        return null;
    }
}
```

---

## 🎯 ÉTAPE 5: CONTROLLERS (API REST)

### 5.1 Controller Product

Dans `backend/src/main/java/com/pureskin/etudiant/controller/ProductController.java` :

```java
package com.pureskin.etudiant.controller;

import com.pureskin.etudiant.entity.Product;
import com.pureskin.etudiant.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001", 
                       "https://votre-app.vercel.app", "https://votre-app.onrender.com"})
public class ProductController {
    
    @Autowired
    private ProductService productService;
    
    // Obtenir tous les produits actifs
    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productService.getAllActiveProducts();
        return ResponseEntity.ok(products);
    }
    
    // Obtenir un produit par ID
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Optional<Product> product = productService.getProductById(id);
        return product.map(ResponseEntity::ok)
                      .orElse(ResponseEntity.notFound().build());
    }
    
    // Rechercher des produits
    @GetMapping("/search")
    public ResponseEntity<List<Product>> searchProducts(@RequestParam String q) {
        List<Product> products = productService.searchProducts(q);
        return ResponseEntity.ok(products);
    }
    
    // Obtenir les produits par badge
    @GetMapping("/badge/{badge}")
    public ResponseEntity<List<Product>> getProductsByBadge(@PathVariable String badge) {
        List<Product> products = productService.getProductsByBadge(badge);
        return ResponseEntity.ok(products);
    }
    
    // Créer un produit (admin)
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product createdProduct = productService.createProduct(product);
        return ResponseEntity.ok(createdProduct);
    }
    
    // Mettre à jour un produit (admin)
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @RequestBody Product product) {
        Product updatedProduct = productService.updateProduct(id, product);
        if (updatedProduct != null) {
            return ResponseEntity.ok(updatedProduct);
        }
        return ResponseEntity.notFound().build();
    }
    
    // Supprimer un produit (admin)
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        boolean deleted = productService.deleteProduct(id);
        if (deleted) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
```

### 5.2 Controller Order

Dans `backend/src/main/java/com/pureskin/etudiant/controller/OrderController.java` :

```java
package com.pureskin.etudiant.controller;

import com.pureskin.etudiant.entity.Order;
import com.pureskin.etudiant.entity.OrderItem;
import com.pureskin.etudiant.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001",
                       "https://votre-app.vercel.app", "https://votre-app.onrender.com"})
public class OrderController {
    
    @Autowired
    private OrderService orderService;
    
    // Créer une nouvelle commande
    @PostMapping
    public ResponseEntity<Map<String, Object>> createOrder(@RequestBody Map<String, Object> orderData) {
        try {
            // Extraire les données de la commande
            Order order = new Order();
            order.setCustomerEmail((String) orderData.get("customerEmail"));
            order.setCustomerFirstName((String) orderData.get("customerFirstName"));
            order.setCustomerLastName((String) orderData.get("customerLastName"));
            order.setCustomerPhone((String) orderData.get("customerPhone"));
            order.setShippingAddress((String) orderData.get("shippingAddress"));
            order.setBillingAddress((String) orderData.get("billingAddress"));
            order.setShippingCity((String) orderData.get("shippingCity"));
            order.setShippingPostalCode((String) orderData.get("shippingPostalCode"));
            order.setNotes((String) orderData.get("notes"));
            
            // Extraire les articles de commande
            List<Map<String, Object>> itemsData = (List<Map<String, Object>>) orderData.get("items");
            List<OrderItem> orderItems = itemsData.stream()
                .map(itemData -> {
                    OrderItem item = new OrderItem();
                    item.setProductId(Long.valueOf(itemData.get("productId").toString()));
                    item.setProductName((String) itemData.get("productName"));
                    item.setProductDescription((String) itemData.get("productDescription"));
                    item.setProductImage((String) itemData.get("productImage"));
                    item.setProductImageUrl((String) itemData.get("productImageUrl"));
                    item.setUnitPrice(new java.math.BigDecimal(itemData.get("unitPrice").toString()));
                    item.setQuantity(Integer.valueOf(itemData.get("quantity").toString()));
                    item.setTotalPrice(item.getUnitPrice().multiply(
                        java.math.BigDecimal.valueOf(item.getQuantity())));
                    return item;
                })
                .toList();
            
            // Créer la commande
            Order createdOrder = orderService.createOrder(order, orderItems);
            
            // Retourner la réponse
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Commande créée avec succès",
                "data", Map.of(
                    "orderId", createdOrder.getId(),
                    "orderNumber", createdOrder.getOrderNumber(),
                    "totalAmount", createdOrder.getTotalAmount(),
                    "status", createdOrder.getStatus()
                )
            ));
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Erreur lors de la création de la commande: " + e.getMessage()
            ));
        }
    }
    
    // Obtenir une commande par ID
    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrderById(@PathVariable Long id) {
        Optional<Order> order = orderService.getOrderById(id);
        return order.map(ResponseEntity::ok)
                     .orElse(ResponseEntity.notFound().build());
    }
    
    // Obtenir une commande par numéro
    @GetMapping("/number/{orderNumber}")
    public ResponseEntity<Order> getOrderByNumber(@PathVariable String orderNumber) {
        Optional<Order> order = orderService.getOrderByNumber(orderNumber);
        return order.map(ResponseEntity::ok)
                     .orElse(ResponseEntity.notFound().build());
    }
    
    // Obtenir les commandes d'un client
    @GetMapping("/customer/{email}")
    public ResponseEntity<List<Order>> getCustomerOrders(@PathVariable String email) {
        List<Order> orders = orderService.getCustomerOrders(email);
        return ResponseEntity.ok(orders);
    }
    
    // Mettre à jour le statut de paiement
    @PutMapping("/{id}/payment-status")
    public ResponseEntity<Order> updatePaymentStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> statusData) {
        
        String paymentStatus = statusData.get("paymentStatus");
        Order updatedOrder = orderService.updatePaymentStatus(id, paymentStatus);
        
        if (updatedOrder != null) {
            return ResponseEntity.ok(updatedOrder);
        }
        return ResponseEntity.notFound().build();
    }
    
    // Associer un wallet Faroty
    @PutMapping("/{id}/faroty-wallet")
    public ResponseEntity<Order> associateFarotyWallet(
            @PathVariable Long id,
            @RequestBody Map<String, String> walletData) {
        
        Order updatedOrder = orderService.associateFarotyWallet(
            id,
            walletData.get("walletId"),
            walletData.get("sessionToken"),
            walletData.get("farotyUserId")
        );
        
        if (updatedOrder != null) {
            return ResponseEntity.ok(updatedOrder);
        }
        return ResponseEntity.notFound().build();
    }
}
```

---

## 🎯 ÉTAPE 6: CONFIGURATION FRONTEND

### 6.1 Service API

Dans `frontend/src/lib/api.ts` :

```typescript
// Configuration de l'API
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080';

interface ApiResponse<T> {
  data?: T;
  message?: string;
  success?: boolean;
}

class ApiService {
  private baseUrl: string;

  constructor() {
    this.baseUrl = API_BASE_URL;
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`;
    
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // Produits
  async getProducts(): Promise<Product[]> {
    return this.request<Product[]>('/api/products');
  }

  async getProduct(id: number): Promise<Product> {
    return this.request<Product>(`/api/products/${id}`);
  }

  async searchProducts(query: string): Promise<Product[]> {
    return this.request<Product[]>(`/api/products/search?q=${encodeURIComponent(query)}`);
  }

  async getProductsByBadge(badge: string): Promise<Product[]> {
    return this.request<Product[]>(`/api/products/badge/${badge}`);
  }

  // Commandes
  async createOrder(orderData: OrderRequest): Promise<ApiResponse<OrderResponse>> {
    return this.request<ApiResponse<OrderResponse>>('/api/orders', {
      method: 'POST',
      body: JSON.stringify(orderData),
    });
  }

  async getOrder(id: string): Promise<Order> {
    return this.request<Order>(`/api/orders/${id}`);
  }

  async getOrderByNumber(orderNumber: string): Promise<Order> {
    return this.request<Order>(`/api/orders/number/${orderNumber}`);
  }

  async getCustomerOrders(email: string): Promise<Order[]> {
    return this.request<Order[]>(`/api/orders/customer/${encodeURIComponent(email)}`);
  }

  async updatePaymentStatus(
    orderId: string,
    paymentStatus: string
  ): Promise<Order> {
    return this.request<Order>(`/api/orders/${orderId}/payment-status`, {
      method: 'PUT',
      body: JSON.stringify({ paymentStatus }),
    });
  }

  async associateFarotyWallet(
    orderId: string,
    walletData: FarotyWalletData
  ): Promise<Order> {
    return this.request<Order>(`/api/orders/${orderId}/faroty-wallet`, {
      method: 'PUT',
      body: JSON.stringify(walletData),
    });
  }
}

// Types
export interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  originalPrice?: number;
  image?: string;
  imageUrl?: string;
  badge?: string;
  stockQuantity: number;
  isActive: boolean;
  createdAt?: string;
  updatedAt?: string;
}

export interface OrderRequest {
  customerEmail: string;
  customerFirstName: string;
  customerLastName: string;
  customerPhone?: string;
  subtotal: number;
  shippingCost: number;
  taxAmount: number;
  totalAmount: number;
  shippingAddress: string;
  billingAddress: string;
  shippingCity: string;
  shippingPostalCode: string;
  shippingCountry?: string;
  notes?: string;
  items: OrderItemRequest[];
}

export interface OrderItemRequest {
  productId: number;
  productName: string;
  productDescription?: string;
  productImage?: string;
  productImageUrl?: string;
  unitPrice: number;
  quantity: number;
}

export interface OrderResponse {
  orderId: string;
  orderNumber: string;
  totalAmount: number;
  status: string;
}

export interface Order {
  id: number;
  orderNumber: string;
  customerEmail: string;
  customerFirstName?: string;
  customerLastName?: string;
  customerPhone?: string;
  subtotal: number;
  shippingCost: number;
  taxAmount: number;
  totalAmount: number;
  status: string;
  paymentStatus: string;
  paymentMethod?: string;
  walletId?: string;
  sessionToken?: string;
  farotyUserId?: string;
  shippingAddress?: string;
  billingAddress?: string;
  shippingCity?: string;
  shippingPostalCode?: string;
  shippingCountry?: string;
  notes?: string;
  createdAt: string;
  updatedAt: string;
  paidAt?: string;
  orderItems: OrderItem[];
}

export interface OrderItem {
  id: number;
  productId: number;
  productName: string;
  productDescription?: string;
  productImage?: string;
  productImageUrl?: string;
  unitPrice: number;
  quantity: number;
  totalPrice: number;
}

export interface FarotyWalletData {
  walletId: string;
  sessionToken: string;
  farotyUserId: string;
}

export const apiService = new ApiService();
```

### 6.2 Exemple d'utilisation dans un composant

Dans `frontend/src/app/checkout/page.tsx` :

```typescript
'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { apiService, OrderRequest, CartItem } from '@/lib/api';

export default function CheckoutPage() {
  const router = useRouter();
  const [cartItems, setCartItems] = useState<CartItem[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [customerInfo, setCustomerInfo] = useState({
    email: '',
    firstName: '',
    lastName: '',
    phone: '',
    address: '',
    city: '',
    postalCode: '',
  });

  // Charger le panier
  useEffect(() => {
    const cart = JSON.parse(localStorage.getItem('pureskin-cart') || '{}');
    setCartItems(cart.items || []);
  }, []);

  // Calculer les totaux
  const subtotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const shipping = 4.99;
  const total = subtotal + shipping;

  // Créer la commande
  const handleCreateOrder = async () => {
    if (!customerInfo.email || !customerInfo.firstName || !customerInfo.lastName) {
      alert('Veuillez remplir tous les champs obligatoires');
      return;
    }

    setIsLoading(true);

    try {
      const orderData: OrderRequest = {
        customerEmail: customerInfo.email,
        customerFirstName: customerInfo.firstName,
        customerLastName: customerInfo.lastName,
        customerPhone: customerInfo.phone,
        subtotal,
        shippingCost: shipping,
        taxAmount: 0,
        totalAmount: total,
        shippingAddress: `${customerInfo.address}, ${customerInfo.postalCode} ${customerInfo.city}`,
        billingAddress: `${customerInfo.address}, ${customerInfo.postalCode} ${customerInfo.city}`,
        shippingCity: customerInfo.city,
        shippingPostalCode: customerInfo.postalCode,
        shippingCountry: 'France',
        notes: `Client: ${customerInfo.firstName} ${customerInfo.lastName}, Email: ${customerInfo.email}, Tel: ${customerInfo.phone}`,
        items: cartItems.map(item => ({
          productId: item.id,
          productName: item.name,
          productDescription: item.description,
          productImage: item.image,
          productImageUrl: item.imageUrl,
          unitPrice: item.price,
          quantity: item.quantity,
        })),
      };

      const response = await apiService.createOrder(orderData);

      if (response.success && response.data) {
        // Sauvegarder l'ID de commande pour le paiement
        localStorage.setItem('pending_order_id', response.data.orderId);
        localStorage.setItem('customer_email', customerInfo.email);
        
        // Rediriger vers la page d'authentification
        router.push('/auth-checkout');
      } else {
        alert(response.message || 'Erreur lors de la création de la commande');
      }
    } catch (error) {
      console.error('Error creating order:', error);
      alert('Erreur lors de la création de la commande');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Formulaire de checkout */}
      <div className="max-w-4xl mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-8">Finaliser la commande</h1>
        
        {/* Informations client */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">Informations de livraison</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <input
              type="email"
              placeholder="Email *"
              value={customerInfo.email}
              onChange={(e) => setCustomerInfo({...customerInfo, email: e.target.value})}
              className="border rounded px-3 py-2"
            />
            
            <input
              type="text"
              placeholder="Prénom *"
              value={customerInfo.firstName}
              onChange={(e) => setCustomerInfo({...customerInfo, firstName: e.target.value})}
              className="border rounded px-3 py-2"
            />
            
            {/* Autres champs... */}
          </div>
        </div>

        {/* Récapitulatif commande */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">Récapitulatif</h2>
          
          {cartItems.map(item => (
            <div key={item.id} className="flex justify-between mb-2">
              <span>{item.name} x {item.quantity}</span>
              <span>{(item.price * item.quantity).toFixed(2)} €</span>
            </div>
          ))}
          
          <div className="border-t pt-4 mt-4">
            <div className="flex justify-between mb-2">
              <span>Sous-total:</span>
              <span>{subtotal.toFixed(2)} €</span>
            </div>
            <div className="flex justify-between mb-2">
              <span>Livraison:</span>
              <span>{shipping.toFixed(2)} €</span>
            </div>
            <div className="flex justify-between font-bold">
              <span>Total:</span>
              <span>{total.toFixed(2)} €</span>
            </div>
          </div>
        </div>

        {/* Bouton de commande */}
        <button
          onClick={handleCreateOrder}
          disabled={isLoading}
          className="w-full bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 disabled:bg-gray-400"
        >
          {isLoading ? 'Création en cours...' : 'Continuer vers le paiement'}
        </button>
      </div>
    </div>
  );
}
```

---

## 🎯 ÉTAPE 7: VARIABLES D'ENVIRONNEMENT

### 7.1 Backend (.env)

```bash
# Base de données
DATABASE_URL=jdbc:postgresql://localhost:5432/pureskin
DB_USERNAME=postgres
DB_PASSWORD=votre_password

# API Faroty
FAROTY_API_KEY=votre_cle_api_faroty
FAROTY_API_URL=https://api.faroty.dev

# Serveur
PORT=8080
```

### 7.2 Frontend (.env.local)

```bash
# API Backend
NEXT_PUBLIC_API_URL=http://localhost:8080

# API Faroty
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=votre_cle_api_faroty

# URLs
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

---

## 🔄 FONCTIONNEMENT COMPLET

### 1. **Flux de données Frontend → Backend → Base de données**

```
Frontend (React) → API Service → HTTP Request → Spring Boot Controller → Service → Repository → JPA → PostgreSQL
```

### 2. **Exemple : Création d'une commande**

1. **Frontend** : Utilisateur remplit le formulaire
2. **API Service** : Crée l'objet OrderRequest
3. **HTTP POST** : Envoie à `/api/orders`
4. **Controller** : Reçoit la requête, valide les données
5. **Service** : Vérifie le stock, calcule les totaux
6. **Repository** : Sauvegarde en base de données
7. **Database** : Insère dans les tables orders et order_items
8. **Response** : Retourne l'ID de commande au frontend
9. **Frontend** : Redirige vers la page de paiement

### 3. **Exemple : Récupération des produits**

```
Frontend → apiService.getProducts() → GET /api/products → 
ProductController.getAllProducts() → ProductService.getAllActiveProducts() → 
ProductRepository.findByIsActiveTrue() → JPA Query → PostgreSQL → 
Products table → Response JSON → Frontend display
```

---

## 🔧 DÉBOGAGE ET MONITORING

### 1. **Logs Backend**

```properties
# application.properties
logging.level.com.pureskin.etudiant=DEBUG
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE
```

### 2. **Monitoring Frontend**

```typescript
// Dans api.ts
private async request<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  const url = `${this.baseUrl}${endpoint}`;
  
  console.log(`API Request: ${options.method || 'GET'} ${url}`);
  
  try {
    const response = await fetch(url, config);
    console.log(`API Response: ${response.status} ${url}`);
    
    if (!response.ok) {
      console.error(`API Error: ${response.status} ${response.statusText}`);
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    console.log(`API Data:`, data);
    return data;
  } catch (error) {
    console.error('API request failed:', error);
    throw error;
  }
}
```

### 3. **Test des endpoints**

```bash
# Tester les produits
curl http://localhost:8080/api/products

# Tester la création de commande
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{"customerEmail":"test@example.com","totalAmount":29.99,"items":[]}'

# Vérifier la base de données
docker exec -it postgres_container psql -U postgres -d pureskin -c "SELECT * FROM orders;"
```

---

## 🎉 RÉSUMÉ

Ce guide complet montre comment :

1. **Configurer la connexion** entre Spring Boot et PostgreSQL
2. **Créer les entités** JPA avec les bonnes annotations
3. **Implémenter les repositories** pour l'accès aux données
4. **Créer les services** avec la logique métier
5. **Développer les controllers** REST pour l'API
6. **Configurer le frontend** pour communiquer avec l'API
7. **Gérer les variables d'environnement** pour la sécurité
8. **Déboguer et monitorer** les communications

Le système est maintenant prêt pour un déploiement en production avec une communication fluide entre frontend, backend et base de données !
