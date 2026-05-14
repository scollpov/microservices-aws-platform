package com.example.paymentservice.adapters.in.kafka;

import com.example.orderservice.events.OrderCreatedEvent;
import com.example.paymentservice.ports.in.CreatePaymentUseCase;
import jakarta.annotation.PostConstruct;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class PaymentKafkaConsumer {

    private final CreatePaymentUseCase useCase;

    public PaymentKafkaConsumer(CreatePaymentUseCase useCase) {
        this.useCase = useCase;
    }

    @KafkaListener(topics = "order-created", groupId = "payment-debug-v9", containerFactory = "kafkaListenerContainerFactory")
    public void handle(OrderCreatedEvent event){
        System.out.println("Received event: " + event);
        useCase.createPayment(event.orderId(), event.amount());
    }
}
