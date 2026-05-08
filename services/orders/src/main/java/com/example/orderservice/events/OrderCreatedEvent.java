package com.example.orderservice.events;

public record OrderCreatedEvent(String orderId, double amount) {}
