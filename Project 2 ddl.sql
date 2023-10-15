CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone_number VARCHAR(20)
);

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  product_description VARCHAR(500),
  product_price FLOAT
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATETIME,
  order_status VARCHAR(50),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price FLOAT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_id, first_name, last_name, email, phone_number)
VALUES 
(1, 'John', 'Doe', 'johndoe@gmail.com', '1234567890'),
(2, 'Jane', 'Smith', 'janesmith@yahoo.com', '2345678901'),
(3, 'Bob', 'Johnson', 'bobjohnson@hotmail.com', '3456789012'),
(4, 'Alice', 'Lee', 'alicelee@gmail.com', '4567890123'),
(5, 'David', 'Kim', 'davidkim@yahoo.com', '5678901234');

INSERT INTO products (product_id, product_name, product_description, product_price)
VALUES
(1, 'Laptop', 'Brand new laptop with latest hardware', 1000.00),
(2, 'Smartphone', 'New smartphone with the best features', 500.00),
(3, 'Headphones', 'High-quality headphones for an immersive audio experience', 100.00),
(4, 'Tablet', 'Portable device with a large display', 300.00),
(5, 'Camera', 'Professional camera with high resolution', 800.00),
(6, 'Camera', 'Normal camera', 40.00);

INSERT INTO orders (order_id, customer_id, order_date, order_status)
VALUES
(1, 1, '2023-04-01 10:00:00', 'Pending'),
(2, 2, '2023-04-02 12:00:00', 'Shipped'),
(3, 3, '2023-04-03 14:00:00', 'Delivered'),
(4, 4, '2023-04-04 16:00:00', 'Shipped'),
(5, 5, '2023-04-05 18:00:00', 'Pending');

INSERT INTO order_details (order_item_id, order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 1, 1000.00),
(2, 2, 2, 2, 1000.00),
(3, 3, 3, 1, 100.00),
(4, 4, 4, 1, 300.00),
(5, 5, 5, 2, 1000.00);

