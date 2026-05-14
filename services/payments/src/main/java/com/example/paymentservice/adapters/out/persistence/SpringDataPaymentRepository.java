package com.example.paymentservice.adapters.out.persistence;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SpringDataPaymentRepository extends JpaRepository<PaymentEntity, String> {}
