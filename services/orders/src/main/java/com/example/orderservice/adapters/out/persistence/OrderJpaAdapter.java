package com.example.orderservice.adapters.out.persistence;

import com.example.orderservice.domain.model.Order;
import com.example.orderservice.ports.out.OrderRepositoryPort;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class OrderJpaAdapter implements OrderRepositoryPort {

    private final SpringDataOrderRepository repository;

    public OrderJpaAdapter(SpringDataOrderRepository repository) {
        this.repository = repository;
    }

    @Override
    public void save(Order order) {
        repository.save(new OrderEntity(order.getId(), order.getAmount()));
    }

    @Override
    public Optional<Order> findById(String id) {
        return repository.findById(id)
                .map(e -> new Order(e.getId(), e.getAmount()));
    }
}
