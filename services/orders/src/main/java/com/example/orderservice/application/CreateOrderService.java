package com.example.orderservice.application;

import com.example.orderservice.domain.model.Order;
import com.example.orderservice.events.OrderCreatedEvent;
import com.example.orderservice.ports.in.CreateOrderUseCase;
import com.example.orderservice.ports.out.OrderEventPublisher;
import com.example.orderservice.ports.out.OrderRepositoryPort;

public class CreateOrderService implements CreateOrderUseCase {

    private final OrderRepositoryPort orderRepositoryPort;
    private final OrderEventPublisher eventPublisher;

    public CreateOrderService(OrderRepositoryPort orderRepositoryPort, OrderEventPublisher eventPublisher) {
        this.orderRepositoryPort = orderRepositoryPort;
        this.eventPublisher = eventPublisher;
    }

    @Override
    public void createOrder(String id, double amount) {
        Order order = new Order(id, amount);
        orderRepositoryPort.save(order);

        eventPublisher.publish(new OrderCreatedEvent(order.getId(), order.getAmount()));
    }
}
