package com.example.orderservice.config;

import com.example.orderservice.application.CreateOrderService;
import com.example.orderservice.application.GetOrderService;
import com.example.orderservice.ports.in.CreateOrderUseCase;
import com.example.orderservice.ports.in.GetOrderUseCase;
import com.example.orderservice.ports.out.OrderEventPublisher;
import com.example.orderservice.ports.out.OrderRepositoryPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class BeanConfig {

    @Bean
//    public CreateOrderUseCase createOrderUseCase(OrderRepositoryPort repo, OrderEventPublisher event){
    public CreateOrderUseCase createOrderUseCase(OrderRepositoryPort repo){
        return new CreateOrderService(repo, null);
    }

    @Bean
    public GetOrderUseCase getOrderUseCase(OrderRepositoryPort repo){
        return new GetOrderService(repo);
    }
}
