package com.example.orderservice.ports.out;

import java.util.Optional;
import com.example.orderservice.domain.model.Order;

public interface OrderRepositoryPort {
    void save(Order order);
    Optional<Order> findById(String id);
}
