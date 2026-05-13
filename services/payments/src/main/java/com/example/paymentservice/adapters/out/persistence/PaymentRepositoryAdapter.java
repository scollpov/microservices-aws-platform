package com.example.paymentservice.adapters.out.persistence;

import com.example.paymentservice.domain.Payment;
import com.example.paymentservice.ports.out.PaymentRepositoryPort;
import org.springframework.stereotype.Component;

@Component
public class PaymentRepositoryAdapter implements PaymentRepositoryPort {

    public final SpringDataPaymentRepository repository;

    public PaymentRepositoryAdapter(SpringDataPaymentRepository repository) {
        this.repository = repository;
    }

    @Override
    public void save(Payment payment) {
        PaymentEntity entity = new PaymentEntity(
                payment.getId(),
                payment.getOrderId(),
                payment.getAmount(),
                payment.getStatus()
        );

        repository.save(entity);
    }

    @Override
    public Payment findById(String id) {
    PaymentEntity entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found"));

        return new Payment(
                entity.getId(),
                entity.getOrderId(),
                entity.getAmount(),
                entity.getStatus()
        );
    }
}
