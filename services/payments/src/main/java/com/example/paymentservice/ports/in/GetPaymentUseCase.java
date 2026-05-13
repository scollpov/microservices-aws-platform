package com.example.paymentservice.ports.in;

import com.example.paymentservice.domain.Payment;

public interface GetPaymentUseCase {
    Payment getPaymentById(String Id);
}

