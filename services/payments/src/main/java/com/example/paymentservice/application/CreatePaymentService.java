package com.example.paymentservice.application;

import com.example.paymentservice.domain.Payment;
import com.example.paymentservice.ports.in.CreatePaymentUseCase;
import com.example.paymentservice.ports.out.PaymentRepositoryPort;

import java.util.UUID;

public class CreatePaymentService implements CreatePaymentUseCase {

    private final PaymentRepositoryPort repository;

    public CreatePaymentService(PaymentRepositoryPort repository) {
        this.repository = repository;
    }

    @Override
    public void createPayment(String orderId, double amount) {
        Payment payment = new Payment(
                UUID.randomUUID().toString(),
                orderId,
                amount,
                "PAID");

        repository.save(payment);

	System.out.println("PAYMENT SAVED FOR ORDER: " + orderId);
    }
}
