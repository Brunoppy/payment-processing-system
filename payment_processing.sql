-- Create Payment_Methods table
CREATE TABLE Payment_Methods (
    PaymentMethodID INT AUTO_INCREMENT PRIMARY KEY,
    MethodName VARCHAR(50) NOT NULL
);

-- Create Payments table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    AmountPaid DECIMAL(10, 2) NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentStatus ENUM('Paid', 'Pending', 'Overdue') DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PaymentMethodID) REFERENCES Payment_Methods(PaymentMethodID)
);

-- Insert sample data into Payment_Methods
INSERT INTO Payment_Methods (MethodName) VALUES
('Credit Card'),
('Bank Transfer'),
('Cash'),
('Boleto');

-- Insert sample data into Payments
INSERT INTO Payments (OrderID, PaymentMethodID, AmountPaid, PaymentDate, PaymentStatus) VALUES
(1, 1, 120.50, '2025-01-19', 'Paid'), -- Order 1 paid by Credit Card
(2, 2, 250.00, '2025-01-18', 'Pending'), -- Order 2 pending payment by Bank Transfer
(3, 4, 75.00, '2025-01-15', 'Overdue'); -- Order 3 overdue payment by Boleto

-- Query to list all payments with details
SELECT 
    Payments.PaymentID,
    Orders.CustomerID,
    Payment_Methods.MethodName AS PaymentMethod,
    Payments.AmountPaid,
    Payments.PaymentDate,
    Payments.PaymentStatus
FROM Payments
JOIN Orders ON Payments.OrderID = Orders.OrderID
JOIN Payment_Methods ON Payments.PaymentMethodID = Payment_Methods.PaymentMethodID;

-- Query to calculate total revenue from payments
SELECT 
    SUM(AmountPaid) AS TotalRevenue
FROM Payments
WHERE PaymentStatus = 'Paid';

-- Query to find unpaid or overdue payments
SELECT 
    Payments.PaymentID,
    Orders.OrderID,
    Orders.CustomerID,
    Payments.AmountPaid,
    Payments.PaymentStatus
FROM Payments
JOIN Orders ON Payments.OrderID = Orders.OrderID
WHERE Payments.PaymentStatus IN ('Pending', 'Overdue');

-- Query to list payments grouped by method
SELECT 
    Payment_Methods.MethodName AS PaymentMethod,
    COUNT(Payments.PaymentID) AS NumberOfPayments,
    SUM(Payments.AmountPaid) AS TotalAmount
FROM Payments
JOIN Payment_Methods ON Payments.PaymentMethodID = Payment_Methods.PaymentMethodID
GROUP BY Payment_Methods.MethodName;
