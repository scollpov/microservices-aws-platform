package com.example.paymentservice.ports.out;

import com.example.paymentservice.domain.Payment;

public interface PaymentRepositoryPort {

    void save(Payment payment);
}
