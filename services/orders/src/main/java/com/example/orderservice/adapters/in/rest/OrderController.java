package com.example.orderservice.adapters.in.rest;

import com.example.orderservice.domain.model.Order;
import com.example.orderservice.ports.in.CreateOrderUseCase;
import com.example.orderservice.ports.in.GetOrderUseCase;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
public class OrderController {
    private final CreateOrderUseCase createOrderUseCase;
    private final GetOrderUseCase getOrderUseCase;

    public OrderController(CreateOrderUseCase createOrderUseCase, GetOrderUseCase getOrderUseCase) {
        this.createOrderUseCase = createOrderUseCase;
        this.getOrderUseCase = getOrderUseCase;
    }

    @PostMapping
    public ResponseEntity<Void> create(@RequestBody OrderRequest request){
        createOrderUseCase.createOrder(request.id(), request.amount());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public Order get(@PathVariable String id){
        System.out.println(id);
        return getOrderUseCase.getOrderById(id);

    }
}
