package com.example.paymentservice.application;

import com.example.paymentservice.domain.Payment;
import com.example.paymentservice.ports.out.PaymentRepositoryPort;

public class GetPaymentUseCase {

    private final PaymentRepositoryPort paymentRepositoryPort;

    public GetPaymentUseCase(PaymentRepositoryPort paymentRepositoryPort) {
        this.paymentRepositoryPort = paymentRepositoryPort;
    }

    public Payment getPaymentById(String id) {
        return paymentRepositoryPort.findById(id);
    }
}
