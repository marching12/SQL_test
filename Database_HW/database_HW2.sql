USE classicmodels;

# 1. employees의 lastname, firstname, jobtitle의 정보를 검색
SELECT e.lastname, e.firstname, e.jobTitle
FROM employees e;

# 2. customers중 country가 USA이면서 NYC라는 city에 살고 있으며
#    creditlimit이 200미만인 사람의 이름(customername)을 검색
SELECT customername
FROM customers
WHERE country = 'USA' and city = 'NYC' and creditlimit < 200;

# 3. buyprice가 50이하이거나 100이상인 products의 productcode,
#    productname, buyprice를 검색
SELECT productCode, productName, buyPrice
FROM products
WHERE buyPrice BETWEEN 50 and 100;

# 4. lastname에 am이 들어가고 firstname이 er으로 끝나는 employees의
#    employeenumber와 lastname, firstname을 검색
SELECT e.employeeNumber, e.lastName, e.firstName
FROM employees e
WHERE e.lastName LIKE '%am%'
AND e.firstName LIKE '%er';

# 5. customers의 contactlastname은 사전의 역순으로, 고객의
#    contactfirstname은 사전순으로 정렬될 수 있도록 검색
SELECT contactLastName, contactFirstName
FROM customers
ORDER BY contactLastName DESC, contactFirstName ASC;

# 6. buyprice가 가장 높은 products의 productname과 buyprice을 10위까지 추출
SELECT productName, buyPrice
FROM products
ORDER BY buyPrice DESC
LIMIT 10;

# 7. priceeach가 가장 작은 products의 productname과 priceeach를 검색
SELECT products.productName, orderdetails.priceEach
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
ORDER BY orderdetails.priceEach ASC
LIMIT 1;

# 8. amount가 40000이상인 customers가 사는 city를 모두 나열
SELECT DISTINCT city, payments.amount
FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE payments.amount>=40000
ORDER BY payments.amount ASC;

# 9. 고객테이블에서 고객번호, 고객 Lastname정보를 얻은 결과와 직원테이블에서 직원
#    번호, 직원 Lastname정보를 합치고 번호에 대하여 오름차순으로 정렬한 결과를 보이시오
SELECT customerNumber, contactLastName
FROM customers
UNION
SELECT e.employeeNumber, e.lastName
FROM employees e
ORDER BY customerNumber ASC;

# 10. 주문의 상태와 그 상태를 갖는 주문의 수를 출력하여라
#     상태를 갖는 주문의 수가 많은 순으로 출력
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

# 11.  상세주문 테이블에서 주문번호별 총 주문수,총 개당 가격을 추출하시오
#      총 주문수는 1000건 이상이고 총 개당 가격은 600이상인 ROW만 추출
SELECT orderNumber,
       SUM(quantityOrdered) AS total_order_quantity,
       SUM(priceEach * quantityOrdered) AS total_price
FROM orderdetails
GROUP BY orderNumber
HAVING total_order_quantity >= 500 #1000이상이 없음 500으로 대체
   AND total_price >= 600;

# 12. INNER JOIN을 활용하여 priceEach가 가장 작은 물품의 이름과 priceEach를 검색하시오
SELECT products.productName, orderdetails.priceEach
FROM orderdetails
INNER JOIN products ON orderdetails.productCode = products.productCode
ORDER BY orderdetails.priceEach ASC
LIMIT 1;

# 13. 주문 테이블과 상세 주문 테이블로부터 주문번호 별로 주문번호, 상태, 총 주문금액을 검색하시오
#     하나의 주문번호에는 여러 개의 상품주문이 있기 때문에 총 주문금액은 quantityOrdered*priceEach들의 Sum이 되어야 함
SELECT O.orderNumber, O.status, SUM(OD.quantityOrdered * OD.priceEach) AS total_order_amount
FROM orders O
INNER JOIN orderdetails OD ON O.orderNumber = OD.orderNumber
GROUP BY O.orderNumber, O.status;

# 14. 모든 고객의 주문 정보를 검색하시오(추출해야 할 정보는 고객번호, 고객이름, 주문번호, 상품상태)
# ◼ Q: SELECT c.customerNumer, c.customerName, orderNumber, o.status FROM customers c LEFT JOIN
# orders o ON c.customerNumer=o.customerNumer;
# ◼ Q의 결과에서 NULL값이 포함되었다면, 이유를 설명하시오
# 설명 : LEFT JOIN을 사용해 왼쪽 테이블의 모든 정보가 출력되기 때문에 order가 없어도 출력된다
SELECT c.customerNumber, c.customerName, o.orderNumber, o.status
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber;

# 15. 고객 중 주문을 하지 않은 고객의 고객번호와 고객이름을 추출하시오
SELECT c.customerNumber, c.customerName
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;

#############################################################################################3
# 16. empdb라는 이름의 database를 만드시오
# CREATE DATABASE empdb;
USE empdb;

-- 모든 테이블 삭제
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS merit;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS buildings;

# 17. merit 테이블 생성
CREATE TABLE merit (
    performance INT(11) NOT NULL,
    percentage FLOAT NOT NULL,
    PRIMARY KEY (performance)
);

# 18. employees 테이블 생성
CREATE TABLE employees (
    emp_id INT(11) NOT NULL AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    PRIMARY KEY (emp_id),
    CONSTRAINT fk_performance FOREIGN KEY (performance) REFERENCES merit(performance)
);

# 19. buildings 테이블 생성
CREATE TABLE buildings (
    building_no INT(11) NOT NULL AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(355) NOT NULL,
    PRIMARY KEY (building_no)
);

# 20. rooms 테이블 생성
CREATE TABLE rooms (
    room_no INT(11) NOT NULL AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT(11) NOT NULL,
    PRIMARY KEY (room_no),
    KEY building_no (building_no),
    CONSTRAINT rooms_ibfk_1 FOREIGN KEY (building_no)
    REFERENCES buildings(building_no) ON DELETE CASCADE
);


# 21. merit 테이블에 실적(performance)별 보너스 percentage를 입력하시오
INSERT INTO merit (performance, percentage) VALUES
(1, 0.00),
(2, 0.01),
(3, 0.03),
(4, 0.05),
(5, 0.08);


# 22. employees 테이블에 직원 데이터를 입력하시오
INSERT INTO employees (emp_name, performance, salary) VALUES
('Mary Doe', 1, 50000),
('Cindy Smith', 3, 65000),
('Sue Greenspan', 4, 75000),
('Grace Dell', 5, 125000),
('Nancy Johnson', 3, 85000),
('John Doe', 2, 45000),
('Lily Bush', 3, 55000);

# 23. buildings 테이블에 데이터 입력
INSERT INTO buildings (building_name, address) VALUES
('ACME Headquarters', '3950 North 1st Street CA 95134'),
('ACME Sales', '5000 North 1st Street CA 95134');

# 24. rooms 테이블에 데이터 입력
INSERT INTO rooms (room_name, building_no) VALUES
('Amazon', 1),
('War Room', 1),
('Office of CEO', 1),
('Marketing', 2),
('Showroom', 2);

#############################################################################################
USE classicmodels;

DELETE FROM employees
WHERE employeeNumber = 1901;

# 25. Employee Table에 employeeNumber는 1901번,
#     lastName은 hong, firstName은 jin, extension은 x5000,
#     email은 nike@google.com, officeCode는 7,
#     reportsTo는 null, jobTitle은 Research인 사원의 정보를 입력하시오
INSERT INTO employees (
    employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle
) VALUES (
    1901, 'hong', 'jin', 'x5000', 'nike@google.com', 7, NULL, 'Research'
);
# 검사
SELECT *
FROM employees e
WHERE e.employeeNumber = '1901';

########################################################################################
# 26. Jobtitle이 research인 직원이 속한 office의 city를 Jeonju로 변경하시오
update offices
SET city = 'Jeonju'
WHERE officeCode IN(
    SELECT officeCode
    FROM employees e
    WHERE e.jobTitle = 'Research'
    );

# 변경되었는지 체크
SELECT o.officeCode, o.city, e.employeeNumber, e.firstName, e.lastName
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
WHERE e.jobTitle = 'Research';

######################################################################
# 27. 실적 별 월급은 실적이 올라갈 때 마다 월급=월급+월급*percentage로 오른다고 가정하고,
#     현재 employees 테이블에 들어가 있는 월급 데이터는 실적정보가 반영되어 있지 않다고 할 때
#     실적을 반영한 월급으로 갱신 시키시오
USE empdb;

START TRANSACTION;
SELECT e.emp_name, e.salary
FROM employees e;

UPDATE employees e
JOIN merit m ON e.performance = m.performance
SET salary = salary + (e.salary*m.percentage/100)
WHERE e.emp_id IS NOT NULL AND e.salary > 0;

SELECT e.emp_name, e.salary
FROM employees e;
ROLLBACK;

######################################################################
# 28. Employees와 offices Table에서 officeCode가 1인 Row들을 삭제하시오 (삭제 후 결과 화면 스크린 샷)

USE classicmodels;
START TRANSACTION;
# officeCode가 1인 행의 reportsTo를 NULL로 바꾸어서 더이상 상사 역할을 못하도록 함
UPDATE employees e1
JOIN employees e2 ON e1.reportsTo = e2.employeeNumber
SET e1.reportsTo = NULL
WHERE e2.officeCode = 1;

# officeCode = 1에게 할당된 고객들을 해제해줌
UPDATE customers
SET salesRepEmployeeNumber = NULL
WHERE salesRepEmployeeNumber IN(
    SELECT e.employeeNumber
    FROM employees e
    WHERE e.officeCode = 1
    );

# 삭제
DELETE
FROM employees e
WHERE e.officeCode=1;
# 삭제
DELETE
FROM offices o
WHERE o.officeCode=1;

# 검증
SELECT e.employeeNumber, e.reportsTo, e.officeCode, o.officeCode
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode
ORDER BY e.officeCode ASC;

ROLLBACK;
######################################################################
# 29. page에서 입력시킨 사원을 삭제 하시오 (사원입력은 29페이지에서 함)
START TRANSACTION;

# 삭제 전
SELECT e.employeeNumber
FROM employees e
ORDER BY e.employeeNumber DESC;
# 번호로 삭제
DELETE
FROM employees e
WHERE e.employeeNumber = '1901';
# 삭제 후
SELECT e.employeeNumber
FROM employees e
ORDER BY e.employeeNumber DESC;

ROLLBACK;
############################################################################
# 30. room 테이블을 캡처하고, 2번 building을 삭제 한 후에 room 테이블을 캡처 하시오
USE empdb;
START TRANSACTION;
# 삭제 전
SELECT * FROM rooms;
# 번호로 삭제
DELETE
FROM buildings
WHERE building_no = 2;
# 삭제 후
SELECT * FROM rooms;

ROLLBACK;
############################################################################


