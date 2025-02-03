-- 1(a) assignment

select employeeNumber,firstName,lastName  
from employees
where jobTitle="Sales Rep" and reportsTo = 1102;

-- 1(b) assignment

select distinct(productLine)
from products
where productLine like "% cars";

-- 2 assignment

SELECT 
    customerNumber, 
    customerName,
    CASE 
        WHEN country IN ('USA', 'Canada') THEN 'North America'
        WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment
FROM Customers;

-- 3(a) assignment

SELECT 
    productCode, 
    SUM(quantityOrdered) AS total_ordered
FROM 
    OrderDetails
GROUP BY 
    productCode
ORDER BY 
    total_ordered DESC
LIMIT 10;

-- 3(b) assignment

SELECT 
    MONTHNAME(paymentDate) AS payment_month,
    COUNT(*) AS num_payments
FROM 
    Payments
GROUP BY 
    payment_month
HAVING 
    num_payments > 20
ORDER BY 
    num_payments DESC;

-- 4 assignment
CREATE DATABASE Customers_Orders;

USE Customers_Orders;

-- 4(a) assignment

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

-- 4(b) assignment

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT chk_total_amount CHECK (total_amount > 0)
);

-- 5 assignment

select 
      c.country,
      count(o.orderNumber) order_count
from 
      customers c
join
	  orders o on c.customerNumber = o.customerNumber
group by 
      c.country
order by  
      order_count desc
limit 5;

-- 6 assignment

create table project(EmployeeID int auto_increment primary key,
                     FullName varchar(50) not null,
                     Gender enum("male","female") not null,
                     ManagerID int
                     );
insert into project(FullName,Gender,ManagerID) values('Pranaya', 'Male', 3),
								                     ('Priyanka', 'Female', 1),
                                                     ('Preety', 'Female', NULL),
                                                     ('Anurag', 'Male', 1),
													 ('Sambit', 'Male', 1),
                                                     ('Rajesh', 'Male', 3),
                                                     ('Hina', 'Female', 3);

select * from project;
	
Select  
	   b.FullName "Manager Name",
       a.FullName "Emp Name"
from  
       project a
join 
       project b
on  
       a.ManagerID=b.EmployeeID
order by
	   b.FullName;
    
-- 7 assignment

CREATE TABLE facility (
    Facility_ID INT NOT NULL,
    Name VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

ALTER TABLE facility
MODIFY Facility_ID INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (Facility_ID);

ALTER TABLE facility
ADD City VARCHAR(100) NOT NULL AFTER Name;

DESCRIBE facility;

-- 8 assignment

CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    products p
JOIN 
    productlines pl ON p.productLine = pl.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine
ORDER BY 
    total_sales;
    
select * from product_category_sales;

-- 9 assignment

DELIMITER $$

CREATE PROCEDURE Get_country_payments(
    IN input_year INT,
    IN input_country VARCHAR(100)
)
BEGIN
    SELECT 
        YEAR(p.paymentDate) AS Year,
        c.country AS Country,
        CONCAT(FORMAT(SUM(p.amount) / 1000, 0), 'K') AS TotalAmount
    FROM 
        customers c
    JOIN 
        payments p ON c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentDate) = input_year
        AND c.country = input_country
    GROUP BY 
        YEAR(p.paymentDate), c.country;
END$$

DELIMITER ;

SHOW CREATE PROCEDURE Get_country_payments;

CALL Get_country_payments(2003, 'France');

-- 10(a) assignment

select 
    c.customerName,
    COUNT(o.orderNumber) AS Order_count,
    rank() over (order by count(o.orderNumber) desc)  order_frequency_rnk
from 
    customers c
left join 
    orders o 
on 
    c.customerNumber = o.customerNumber
group by  
    c.customerName
order by 
    order_frequency_rnk;
     
-- 10(b) assignment

with A as (
    select 
        year(orderDate) as Year,
        monthname(orderDate) as Month,
        count(orderDate) as Total_orders
    from 
        orders
    group by  
        Year,Month
)
    select 
        Year,
        Month,
        Total_orders as "Total Orders",
        concat(
           Round(
              100* (
                (Total_orders - lag(Total_orders) over (order by Year)) / lag(Total_orders) over (order by Year)
                ), 
                0
			),
			"%"
		) as "% YoY Changes"
     from 
	   A;

-- 11 assignment

 select
      productLine,
      count(*) AS Total
 from 
	  products
 where
      buyPrice >(select 
                       avg(buyPrice) 
				 from  
                       products)
 group by 
	  productLine
 order by
      Total desc;
      

-- 12 assignment

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

DELIMITER $$

CREATE PROCEDURE Insert_Emp_EH(
    IN input_EmpID INT,
    IN input_EmpName VARCHAR(100),
    IN input_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling block
        SELECT 'Error occurred' AS ErrorMessage;
    END;

    -- Insert operation
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (input_EmpID, input_EmpName, input_EmailAddress);
END$$

DELIMITER ;

CALL Insert_Emp_EH(1, 'Alice', 'alice@example.com');

CALL Insert_Emp_EH(1, 'Bob', 'bob@example.com');

SELECT * FROM Emp_EH;

-- 13 assignment

CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER $$

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END$$

DELIMITER ;

INSERT INTO Emp_BIT VALUES ('Lucas', 'Architect', '2020-10-05', -8);

SELECT * FROM Emp_BIT;