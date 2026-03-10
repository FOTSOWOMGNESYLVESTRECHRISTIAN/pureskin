package com.pureskin.etudiant.service;

import com.pureskin.etudiant.model.Payment;
import com.pureskin.etudiant.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.HashMap;

@Service
@Transactional
public class PaymentService {
    
    @Autowired
    private PaymentRepository paymentRepository;
    
    // Créer un nouveau paiement
    public Payment createPayment(Payment payment) {
        payment.setCreatedAt(LocalDateTime.now());
        payment.setUpdatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }
    
    // Mettre à jour le statut d'un paiement
    public Payment updatePaymentStatus(String orderId, String status, String farotyTransactionId) {
        Optional<Payment> paymentOpt = paymentRepository.findByOrderId(orderId);
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            payment.setStatus(status);
            payment.setUpdatedAt(LocalDateTime.now());
            
            if (farotyTransactionId != null) {
                payment.setFarotyTransactionId(farotyTransactionId);
            }
            
            if ("SUCCESS".equals(status) || "FAILED".equals(status)) {
                payment.setProcessedAt(LocalDateTime.now());
            }
            
            return paymentRepository.save(payment);
        }
        throw new RuntimeException("Paiement non trouvé: " + orderId);
    }
    
    // Récupérer tous les paiements
    public List<Payment> getAllPayments() {
        return paymentRepository.findAllByOrderByCreatedAtDesc();
    }
    
    // Récupérer les paiements par statut
    public List<Payment> getPaymentsByStatus(String status) {
        return paymentRepository.findByStatusOrderByCreatedAtDesc(status);
    }
    
    // Récupérer un paiement par order ID
    public Optional<Payment> getPaymentByOrderId(String orderId) {
        return paymentRepository.findByOrderId(orderId);
    }
    
    // Récupérer les statistiques de paiements
    public Map<String, Object> getPaymentStats() {
        Object[] stats = paymentRepository.getPaymentStats();
        
        Map<String, Object> result = new HashMap<>();
        result.put("totalTransactions", stats[0]);
        result.put("successfulTransactions", stats[1]);
        result.put("failedTransactions", stats[2]);
        result.put("pendingTransactions", stats[3]);
        result.put("totalRevenue", stats[4]);
        result.put("successfulRevenue", stats[5]);
        result.put("todayTransactions", paymentRepository.getTodayTransactionsCount());
        
        // Calculer le solde disponible (transactions réussies)
        BigDecimal availableBalance = (BigDecimal) stats[5];
        result.put("availableBalance", availableBalance);
        
        // Calculer le nombre de produits vendus
        int totalProductsSold = 0;
        List<Payment> successfulPayments = paymentRepository.findByStatusOrderByCreatedAtDesc("SUCCESS");
        for (Payment payment : successfulPayments) {
            if (payment.getProducts() != null) {
                totalProductsSold += payment.getProducts().size();
            }
        }
        result.put("totalProductsSold", totalProductsSold);
        
        return result;
    }
    
    // Rechercher des paiements
    public List<Payment> searchPayments(String searchTerm) {
        return paymentRepository.searchPayments(searchTerm);
    }
    
    // Récupérer les paiements par plage de dates
    public List<Payment> getPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return paymentRepository.findByDateRange(startDate, endDate);
    }
    
    // Calculer le montant retirable (transactions réussies des 30 derniers jours)
    public BigDecimal getWithdrawableAmount() {
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        List<Payment> recentSuccessfulPayments = paymentRepository.findByDateRange(thirtyDaysAgo, LocalDateTime.now())
            .stream()
            .filter(p -> "SUCCESS".equals(p.getStatus()))
            .toList();
            
        return recentSuccessfulPayments.stream()
            .map(Payment::getAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
