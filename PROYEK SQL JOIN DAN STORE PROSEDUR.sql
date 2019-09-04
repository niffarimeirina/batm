USE BIKESTORES;

SELECT * FROM production.BRANDS;
SELECT * FROM production.CATEGORIES;
SELECT * FROM production.PRODUCTS;
SELECT * FROM production.STOCKS;

SELECT * FROM SALES.CUSTOMERS;
SELECT * FROM SALES.ORDER_ITEMS;
SELECT * FROM SALES.ORDERS;
SELECT * FROM SALES.STAFFS;
SELECT * FROM SALES.STORES;

select top 2 oi.list_price, CONCAT(c.first_name,' ',c.last_name) AS [Nama Customer]
from sales.customers C
INNER JOIN sales.orders O on c.customer_id = o.customer_id
INNER JOIN sales.order_items oi on o.order_id = oi.order_id
where first_name = 'KASHA' and last_name='Todd'
order by oi.list_price desc;



SELECT * FROM SALES.order_items WHERE first_name = 'KASHA'
SELECT * FROM production.products where product_name = 'Electra Moto 1 - 2016'


----------------- S H O W    I N V O I C E    T A N P A    S T O R E     P R O C E D U R E -----------------------

SELECT INVOICE#, [Customer ID], [Nama Customer], Alamat, Phone, DATE, [PRODUCT ID], DESCRIPTION, 
QTY, [UNIT PRICE], DISCOUNT, AMOUNT
FROM
(
SELECT o.order_id AS [INVOICE#], c.customer_id AS [Customer ID], CONCAT(c.first_name,' ',c.last_name) AS [Nama Customer] ,
		c.street as [Alamat], C.phone AS [Phone], 
		o.order_date AS [DATE], p.product_id AS [PRODUCT ID], p.product_name AS [DESCRIPTION],
		SUM(oi.quantity) AS [QTY],  oi.list_price AS [UNIT PRICE],
		 --SUM(oi.discount) AS [DISKON], --
		SUM(oi.quantity *oi.list_price*oi.discount) AS [DISCOUNT], 
		SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS [AMOUNT]
		FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE c.first_name = 'KASHA' and c.last_name='Todd' and o.order_id=692
GROUP BY c.customer_id, c.first_name, c.last_name, c.street, 
c.phone, o.order_id, o.order_date, p.product_id, p.product_name,oi.list_price 
)as sales
UNION ALL
SELECT null, null, null, null, null, null, null, 'TOTAL', null, null, null, 
SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS AMOUNT
FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE c.first_name = 'KASHA' and c.last_name='Todd' and o.order_id=692




--------------- S T O R E   P R O C E D U R E    T A M P I L    B Y    N A M A ---------------------------------   

--MEMBUAT STORE PROSEDURE TAMPIL DATA
CREATE PROCEDURE sp_tampil_by_invoice_nama @first_name AS VARCHAR (255),
										   @last_name AS VARCHAR (255),
										   @order_id AS INT
AS
BEGIN

SELECT INVOICE#, [Customer ID], [Nama Customer], Alamat, Phone, DATE, [PRODUCT ID], DESCRIPTION, 
QTY, [UNIT PRICE], DISCOUNT, AMOUNT
FROM
(
SELECT o.order_id AS [INVOICE#], c.customer_id AS [Customer ID], CONCAT(c.first_name,' ',c.last_name) AS [Nama Customer] ,
		c.street as [Alamat], C.phone AS [Phone], 
		o.order_date AS [DATE], p.product_id AS [PRODUCT ID], p.product_name AS [DESCRIPTION],
		SUM(oi.quantity) AS [QTY],  oi.list_price AS [UNIT PRICE],
		 --SUM(oi.discount) AS [DISKON], --
		SUM(oi.quantity *oi.list_price*oi.discount) AS [DISCOUNT], 
		SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS [AMOUNT]
		FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE c.first_name = @first_name and c.last_name=@last_name and o.order_id=@order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.street, 
c.phone, o.order_id, o.order_date, p.product_id, p.product_name,oi.list_price 
)as sales
UNION ALL
SELECT null, null, null, null, null, null, null, 'TOTAL', null, null, null, 
SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS AMOUNT
FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE c.first_name = @first_name and c.last_name=@last_name and o.order_id=@order_id

END

EXEC sp_tampil_by_invoice_nama 'Kasha', 'Todd', 692; 



--------------- S T O R E   P R O C E D U R E    T A M P I L    B Y    O R D E R   I D  ---------------------------------  
--MEMBUAT STORE PROSEDURE TAMPIL DATA 
CREATE PROCEDURE sp_tampil_by_order_id @order_id AS INT
										   
AS
BEGIN

SELECT INVOICE#, [Customer ID], [Nama Customer], Alamat, Phone, DATE, [PRODUCT ID], DESCRIPTION, 
QTY, [UNIT PRICE], DISCOUNT, AMOUNT
FROM
(
SELECT o.order_id AS [INVOICE#], c.customer_id AS [Customer ID], CONCAT(c.first_name,' ',c.last_name) AS [Nama Customer] ,
		c.street as [Alamat], C.phone AS [Phone], 
		o.order_date AS [DATE], p.product_id AS [PRODUCT ID], p.product_name AS [DESCRIPTION],
		SUM(oi.quantity) AS [QTY],  oi.list_price AS [UNIT PRICE],
		 --SUM(oi.discount) AS [DISKON], --
		SUM(oi.quantity *oi.list_price*oi.discount) AS [DISCOUNT], 
		SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS [AMOUNT]
		FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE o.order_id=@order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.street, 
c.phone, o.order_id, o.order_date, p.product_id, p.product_name,oi.list_price 
)as sales
UNION ALL
SELECT null, null, null, null, null, null, null, 'TOTAL', null, null, null, 
SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS AMOUNT
FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE o.order_id=@order_id

END

EXEC sp_tampil_by_order_id 19; 



--------------------------------------------------------------------------------------
SELECT TOP 2 o.order_id AS [INVOICE#], c.customer_id AS [Customer ID], CONCAT(c.first_name,' ',c.last_name) AS [Nama Customer] ,
		c.street as [Alamat], C.phone AS [Phone], 
		o.order_date AS [DATE], p.product_id AS [PRODUCT ID], p.product_name AS [DESCRIPTION],
		SUM(oi.quantity) AS [QTY],  oi.list_price AS [UNIT PRICE],
		 --SUM(oi.discount) AS [DISKON], --
		SUM(oi.quantity *oi.list_price*oi.discount) AS [DISCOUNT], 
		SUM((oi.quantity*oi.list_price)-(oi.quantity*oi.list_price*oi.discount)) AS [AMOUNT]
		FROM sales.customers c 
INNER JOIN sales.orders o ON c.customer_id=o.customer_id
INNER JOIN sales.order_items oi ON o.order_id=oi.order_id
INNER JOIN production.products P ON oi.product_id=p.product_id
WHERE c.first_name = 'KASHA' and c.last_name='Todd'
GROUP BY c.customer_id, c.first_name, c.last_name, c.street, 
c.phone, o.order_id, o.order_date, p.product_id, p.product_name,oi.list_price 
ORDER BY oi.list_price desc;
