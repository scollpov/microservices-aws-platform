package com.example.paymentservice.adapters.in.rest;

import com.example.paymentservice.ports.in.CreatePaymentUseCase;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/payments")
public class PaymentController {

    private final CreatePaymentUseCase useCase;

    public PaymentController(CreatePaymentUseCase useCase) {
        this.useCase = useCase;
    }

    @PostMapping
    public void create(@RequestBody PaymentRequest request){
        useCase.createPayment(request.orderId(), request.amount());
    }
}
