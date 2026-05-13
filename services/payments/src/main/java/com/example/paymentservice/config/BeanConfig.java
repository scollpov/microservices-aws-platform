package com.example.paymentservice.config;

import com.example.paymentservice.application.GetPaymentUseCase;
import com.example.paymentservice.ports.out.PaymentRepositoryPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class BeanConfig {

    @Bean
    public GetPaymentUseCase getPaymentUseCase(
            PaymentRepositoryPort paymentRepositoryPort
    ) {
        return new GetPaymentUseCase(paymentRepositoryPort);
    }
}
