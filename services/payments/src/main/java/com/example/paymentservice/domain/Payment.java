package com.example.paymentservice.domain;

public class Payment {

    private final String id;
    private final String orderId;
    private final double amount;
    private final String status;

    public Payment(String id, String orderId, double amount, String status) {
        this.id = id;
        this.orderId = orderId;
        this.amount = amount;
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public String getOrderId() {
        return orderId;
    }

    public double getAmount() {
        return amount;
    }

    public String getStatus() {
        return status;
    }
}
