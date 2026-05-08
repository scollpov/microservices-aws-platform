package com.example.orderservice.application;

import com.example.orderservice.domain.model.Order;
import com.example.orderservice.ports.in.GetOrderUseCase;
import com.example.orderservice.ports.out.OrderRepositoryPort;

public class GetOrderService implements GetOrderUseCase {

    private final OrderRepositoryPort repository;

    public GetOrderService(OrderRepositoryPort repository) {
        this.repository = repository;
    }

    @Override
    public Order getOrderById(String id) {
        return repository.findById(id).orElseThrow(() -> new RuntimeException("Order not found"));
    }
}
