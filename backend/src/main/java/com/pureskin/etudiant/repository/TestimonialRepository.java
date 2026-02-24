package com.pureskin.etudiant.repository;

import com.pureskin.etudiant.model.Testimonial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestimonialRepository extends JpaRepository<Testimonial, Long> {
    
    List<Testimonial> findByIsApprovedOrderByCreatedAtDesc(Boolean isApproved);
    
    @Query("SELECT t FROM Testimonial t WHERE t.isApproved = true ORDER BY RANDOM()")
    List<Testimonial> findRandomApprovedTestimonials();
    
    @Query("SELECT COUNT(t) FROM Testimonial t WHERE t.isApproved = true")
    long countApprovedTestimonials();
    
    @Query("SELECT COALESCE(AVG(t.rating), 0.0) FROM Testimonial t WHERE t.isApproved = true")
    Double getAverageRating();
    
    @Query("SELECT t FROM Testimonial t WHERE t.isApproved = true ORDER BY t.createdAt DESC")
    List<Testimonial> findLatestApprovedTestimonials();
}
