package com.example.paymentservice.adapters.in.rest;

import com.example.paymentservice.application.GetPaymentUseCase;
import com.example.paymentservice.domain.Payment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/payments")
@RestController
public class PaymentController {

    private final GetPaymentUseCase getPaymentUseCase;

    public PaymentController(GetPaymentUseCase getPaymentUseCase) {
        this.getPaymentUseCase = getPaymentUseCase;
    }

    @GetMapping("/{id}")
    public Payment get(@PathVariable String id) {
        return getPaymentUseCase.getPaymentById(id);
    }
}
