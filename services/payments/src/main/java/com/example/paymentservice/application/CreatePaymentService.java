package com.example.paymentservice.application;

import com.example.paymentservice.domain.Payment;
import com.example.paymentservice.messaging.PaymentKafkaConsumer;
import com.example.paymentservice.ports.in.CreatePaymentUseCase;
import com.example.paymentservice.ports.out.PaymentRepositoryPort;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

public class CreatePaymentService implements CreatePaymentUseCase {

    private static final Logger log =
        LoggerFactory.getLogger(PaymentKafkaConsumer.class);

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

        log.info("PAYMENT SAVED: paymentId={}, orderId={}, amount={}, status={}",
                payment.getId(),
                payment.getOrderId(),
                payment.getAmount(),
                payment.getStatus());
    }
}
