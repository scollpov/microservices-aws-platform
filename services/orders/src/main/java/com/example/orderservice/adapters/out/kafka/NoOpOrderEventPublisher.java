package com.example.orderservice.adapters.out.kafka;

import com.example.orderservice.events.OrderCreatedEvent;
import com.example.orderservice.ports.out.OrderEventPublisher;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "kafka.enabled", havingValue = "false", matchIfMissing = true)
public class NoOpOrderEventPublisher implements OrderEventPublisher {

    @Override
    public void publish(OrderCreatedEvent event) {
        // Kafka disabled
    }
}
