package com.pureskin.etudiant.controller;

import com.pureskin.etudiant.model.Payment;
import com.pureskin.etudiant.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"})
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    // Créer un nouveau paiement
    @PostMapping
    public ResponseEntity<Payment> createPayment(@RequestBody Payment payment) {
        try {
            Payment createdPayment = paymentService.createPayment(payment);
            return ResponseEntity.ok(createdPayment);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Mettre à jour le statut d'un paiement
    @PutMapping("/{orderId}/status")
    public ResponseEntity<Payment> updatePaymentStatus(
            @PathVariable String orderId,
            @RequestBody Map<String, String> request) {
        try {
            String status = request.get("status");
            String farotyTransactionId = request.get("farotyTransactionId");
            
            Payment updatedPayment = paymentService.updatePaymentStatus(orderId, status, farotyTransactionId);
            return ResponseEntity.ok(updatedPayment);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Récupérer tous les paiements
    @GetMapping
    public ResponseEntity<List<Payment>> getAllPayments() {
        List<Payment> payments = paymentService.getAllPayments();
        return ResponseEntity.ok(payments);
    }
    
    // Récupérer les paiements par statut
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Payment>> getPaymentsByStatus(@PathVariable String status) {
        List<Payment> payments = paymentService.getPaymentsByStatus(status);
        return ResponseEntity.ok(payments);
    }
    
    // Récupérer un paiement par order ID
    @GetMapping("/order/{orderId}")
    public ResponseEntity<Payment> getPaymentByOrderId(@PathVariable String orderId) {
        Optional<Payment> payment = paymentService.getPaymentByOrderId(orderId);
        return payment.map(ResponseEntity::ok)
                      .orElse(ResponseEntity.notFound().build());
    }
    
    // Récupérer les statistiques de paiements
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getPaymentStats() {
        Map<String, Object> stats = paymentService.getPaymentStats();
        return ResponseEntity.ok(stats);
    }
    
    // Rechercher des paiements
    @GetMapping("/search")
    public ResponseEntity<List<Payment>> searchPayments(@RequestParam String term) {
        List<Payment> payments = paymentService.searchPayments(term);
        return ResponseEntity.ok(payments);
    }
    
    // Récupérer les paiements par plage de dates
    @GetMapping("/date-range")
    public ResponseEntity<List<Payment>> getPaymentsByDateRange(
            @RequestParam String startDate,
            @RequestParam String endDate) {
        try {
            LocalDateTime start = LocalDateTime.parse(startDate);
            LocalDateTime end = LocalDateTime.parse(endDate);
            List<Payment> payments = paymentService.getPaymentsByDateRange(start, end);
            return ResponseEntity.ok(payments);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Récupérer le montant retirable
    @GetMapping("/withdrawable-amount")
    public ResponseEntity<Map<String, Object>> getWithdrawableAmount() {
        Map<String, Object> result = Map.of(
            "withdrawableAmount", paymentService.getWithdrawableAmount()
        );
        return ResponseEntity.ok(result);
    }
}
