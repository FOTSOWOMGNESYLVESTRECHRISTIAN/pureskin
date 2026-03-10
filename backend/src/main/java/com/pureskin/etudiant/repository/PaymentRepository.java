package com.pureskin.etudiant.repository;

import com.pureskin.etudiant.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    // Trouver par order ID
    Optional<Payment> findByOrderId(String orderId);
    
    // Trouver par transaction Faroty
    Optional<Payment> findByFarotyTransactionId(String farotyTransactionId);
    
    // Compter par statut
    long countByStatus(String status);
    
    // Somme des montants par statut
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = :status")
    BigDecimal sumAmountByStatus(@Param("status") String status);
    
    // Trouver par email client
    List<Payment> findByCustomerEmailOrderByCreatedAtDesc(String customerEmail);
    
    // Trouver par statut avec pagination
    List<Payment> findByStatusOrderByCreatedAtDesc(String status);
    
    // Trouver tous les paiements ordonnés par date décroissante
    List<Payment> findAllByOrderByCreatedAtDesc();
    
    // Trouver par plage de dates
    @Query("SELECT p FROM Payment p WHERE p.createdAt BETWEEN :startDate AND :endDate ORDER BY p.createdAt DESC")
    List<Payment> findByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    // Statistiques générales
    @Query("SELECT " +
           "COUNT(p) as totalTransactions, " +
           "COUNT(p) FILTER (WHERE p.status = 'SUCCESS') as successfulTransactions, " +
           "COUNT(p) FILTER (WHERE p.status = 'FAILED') as failedTransactions, " +
           "COUNT(p) FILTER (WHERE p.status = 'PENDING') as pendingTransactions, " +
           "COALESCE(SUM(p.amount), 0) as totalRevenue, " +
           "COALESCE(SUM(p.amount) FILTER (WHERE p.status = 'SUCCESS'), 0) as successfulRevenue " +
           "FROM Payment p")
    Object[] getPaymentStats();
    
    // Transactions du jour
    @Query("SELECT COUNT(p) FROM Payment p WHERE CAST(p.createdAt AS LocalDate) = CURRENT_DATE")
    long getTodayTransactionsCount();
    
    // Recherche par nom ou email
    @Query("SELECT p FROM Payment p WHERE " +
           "LOWER(p.customerName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(p.customerEmail) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(p.orderId) LIKE LOWER(CONCAT('%', :searchTerm, '%')) " +
           "ORDER BY p.createdAt DESC")
    List<Payment> searchPayments(@Param("searchTerm") String searchTerm);
}
