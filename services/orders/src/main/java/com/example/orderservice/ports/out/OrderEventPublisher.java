package com.example.orderservice.ports.out;

import com.example.orderservice.events.OrderCreatedEvent;

public interface OrderEventPublisher {
    void publish(OrderCreatedEvent event);
}
