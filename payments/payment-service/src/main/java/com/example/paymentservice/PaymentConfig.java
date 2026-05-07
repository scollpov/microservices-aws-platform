package com.example.paymentservice;

import com.example.paymentservice.application.CreatePaymentService;
import com.example.paymentservice.ports.in.CreatePaymentUseCase;
import com.example.paymentservice.ports.out.PaymentRepositoryPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class PaymentConfig {

    @Bean
    public CreatePaymentUseCase createPaymentUseCase(PaymentRepositoryPort repository){
        return new CreatePaymentService(repository);
    }
}
