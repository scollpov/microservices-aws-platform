CREATE TABLE `payments` (
    `id` varchar(255) NOT NULL,
    `amount` double NOT NULL,
    `order_id` varchar(255) DEFAULT NULL,
    `status` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
);
