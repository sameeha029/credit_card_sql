CREATE DATABASE CreditCardSystem;
USE CreditCardSystem;

-- 1. Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Credit Cards Table
CREATE TABLE Credit_Cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    card_number VARCHAR(16) UNIQUE NOT NULL,
    cvv VARCHAR(4) NOT NULL,
    expiry_date DATE NOT NULL,
    credit_limit DECIMAL(10,2) NOT NULL DEFAULT 5000.00,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status ENUM('Active', 'Blocked', 'Expired') DEFAULT 'Active',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 3. Merchants Table
CREATE TABLE Merchants (
    merchant_id INT AUTO_INCREMENT PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Transactions Table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    card_id INT,
    merchant_id INT,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Approved', 'Declined', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (card_id) REFERENCES Credit_Cards(card_id) ON DELETE CASCADE,
    FOREIGN KEY (merchant_id) REFERENCES Merchants(merchant_id)
);

-- 5. Fraud Detection (Simple Flagging System)
CREATE TABLE Fraud_Detection (
    fraud_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    flagged BOOLEAN DEFAULT FALSE,
    reason TEXT,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON DELETE CASCADE
);

-- Sample Data Insertion
INSERT INTO Users (name, email, phone) VALUES ('John Doe', 'john@example.com', '1234567890');
INSERT INTO Credit_Cards (user_id, card_number, cvv, expiry_date, credit_limit, balance) 
VALUES (1, '1234567812345678', '123', '2026-12-31', 10000.00, 0.00);
INSERT INTO Merchants (merchant_name, category) VALUES ('Amazon', 'E-Commerce');
INSERT INTO Transactions (card_id, merchant_id, amount, status) VALUES (1, 1, 200.00, 'Approved');

INSERT INTO Users (name, email, phone) VALUES 
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '8765432109'),
('Charlie Brown', 'charlie@example.com', '7654321098'),
('David White', 'david@example.com', '6543210987'),
('Emma Davis', 'emma@example.com', '5432109876'),
('Frank Harris', 'frank@example.com', '4321098765'),
('Grace Wilson', 'grace@example.com', '3210987654'),
('Henry Moore', 'henry@example.com', '2109876543'),
('Ivy Clark', 'ivy@example.com', '1098765432'),
('Jack Taylor', 'jack@example.com', '0987654321');

INSERT INTO Credit_Cards (user_id, card_number, cvv, expiry_date, credit_limit, balance, status) VALUES 
(2, '4111222233334444', '456', '2027-10-31', 8000.00, 1000.00, 'Active'),
(3, '5500111122223333', '789', '2026-08-30', 12000.00, 500.00, 'Active'),
(4, '340012345678901', '321', '2025-05-20', 15000.00, 2000.00, 'Active'),
(5, '6011345678901234', '654', '2026-12-31', 5000.00, 100.00, 'Blocked'),
(6, '4111999988887777', '987', '2028-07-25', 10000.00, 3000.00, 'Active'),
(7, '5500444466667777', '159', '2027-02-15', 11000.00, 700.00, 'Active'),
(8, '340076543210987', '753', '2029-09-05', 13000.00, 50.00, 'Active'),
(9, '6011987654321012', '852', '2026-06-18', 14000.00, 1200.00, 'Active'),
(10, '4111666677778888', '951', '2028-04-10', 9000.00, 250.00, 'Active'),
(1, '5500999900001111', '369', '2027-11-22', 6000.00, 150.00, 'Expired');

INSERT INTO Merchants (merchant_name, category) VALUES 
('Walmart', 'Retail'),
('Netflix', 'Streaming Service'),
('Uber', 'Transportation'),
('Starbucks', 'Coffee Shop'),
('Best Buy', 'Electronics'),
('Apple Store', 'Electronics'),
('Amazon', 'E-Commerce'),
('Costco', 'Wholesale'),
('Nike', 'Clothing'),
('McDonalds', 'Fast Food');

INSERT INTO Transactions (card_id, merchant_id, amount, status) VALUES 
(2, 2, 15.99, 'Approved'),
(3, 3, 25.00, 'Declined'),
(4, 4, 50.00, 'Approved'),
(5, 5, 200.00, 'Declined'),
(6, 6, 999.99, 'Approved'),
(7, 7, 300.00, 'Pending'),
(8, 8, 120.50, 'Approved'),
(9, 9, 85.75, 'Approved'),
(10, 10, 45.00, 'Approved'),
(1, 1, 150.00, 'Declined');

INSERT INTO Fraud_Detection (transaction_id, flagged, reason) VALUES 
(2, TRUE, 'Suspicious multiple declined transactions'),
(4, FALSE, NULL),
(5, TRUE, 'High-value transaction flagged'),
(6, FALSE, NULL),
(7, TRUE, 'Unusual purchase location'),
(8, FALSE, NULL),
(9, TRUE, 'Repeated transactions in a short period'),
(10, FALSE, NULL),
(3, TRUE, 'Multiple transactions in a foreign country'),
(1, FALSE, NULL);

SELECT 
    t.transaction_id,
    u.name AS user_name,
    cc.card_number,
    cc.status AS card_status,
    m.merchant_name,
    t.amount,
    t.transaction_date,
    t.status AS transaction_status
FROM Transactions t
JOIN Credit_Cards cc ON t.card_id = cc.card_id
JOIN Users u ON cc.user_id = u.user_id
JOIN Merchants m ON t.merchant_id = m.merchant_id
ORDER BY t.transaction_date DESC;

SELECT 
    u.name AS user_name,
    cc.card_number,
    cc.credit_limit,
    cc.balance,
    cc.status
FROM Credit_Cards cc
JOIN Users u ON cc.user_id = u.user_id
ORDER BY cc.credit_limit DESC;

SELECT 
    t.transaction_id,
    u.name AS user_name,
    m.merchant_name,
    t.amount,
    t.transaction_date,
    t.status
FROM Transactions t
JOIN Credit_Cards cc ON t.card_id = cc.card_id
JOIN Users u ON cc.user_id = u.user_id
JOIN Merchants m ON t.merchant_id = m.merchant_id
WHERE t.status = 'Declined';

SELECT 
    fd.fraud_id,
    t.transaction_id,
    u.name AS user_name,
    t.amount,
    t.transaction_date,
    fd.reason
FROM Fraud_Detection fd
JOIN Transactions t ON fd.transaction_id = t.transaction_id
JOIN Credit_Cards cc ON t.card_id = cc.card_id
JOIN Users u ON cc.user_id = u.user_id
WHERE fd.flagged = TRUE;

SELECT 
    t.transaction_id, 
    u.name AS user_name, 
    t.amount, 
    t.transaction_date, 
    t.status
FROM Transactions t
JOIN Credit_Cards cc ON t.card_id = cc.card_id
JOIN Users u ON cc.user_id = u.user_id
JOIN Merchants m ON t.merchant_id = m.merchant_id
WHERE m.merchant_name = 'Amazon'
ORDER BY t.transaction_date DESC;


