package com.example.orderservice.ports.in;

public interface CreateOrderUseCase {
    void createOrder(String id, double amount);
}
