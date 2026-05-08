package com.example.orderservice.ports.in;

import com.example.orderservice.domain.model.Order;

public interface GetOrderUseCase {
    Order getOrderById(String Id);
}
