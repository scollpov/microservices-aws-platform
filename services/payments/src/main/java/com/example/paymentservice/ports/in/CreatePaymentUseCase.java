package com.example.paymentservice.ports.in;

public interface CreatePaymentUseCase {
    void createPayment(String orderId, double amount);
}
