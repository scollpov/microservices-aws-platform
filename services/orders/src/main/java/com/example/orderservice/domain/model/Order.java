package com.example.orderservice.domain.model;

import java.io.Serializable;

public class Order implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private final String id;
    private final double amount;

    public Order(String id, double amount){
        this.id = id;
        this.amount = amount;
    }

    public String getId() {
        return id;
    }

    public double getAmount() {
        return amount;
    }
}
