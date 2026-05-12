package com.example.orderservice.adapters.out.kafka;

import com.example.orderservice.events.OrderCreatedEvent;
import com.example.orderservice.ports.out.OrderEventPublisher;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;

@Component
@ConditionalOnProperty(name = "kafka.enabled", havingValue = "true")
public class OrderKafkaProducer implements OrderEventPublisher {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    public OrderKafkaProducer(KafkaTemplate<String, Object> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    @Override
    public void publish(OrderCreatedEvent event) {
        kafkaTemplate.send("order-created", event);
    }
}
