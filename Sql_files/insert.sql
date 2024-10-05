INSERT INTO public."Product_Name"("ProductKey", "ProductName")
SELECT p."ProductKey",p."ProductName" from p;

INSERT INTO public."product_description"("ProductSKU","ProductName","ModelName","ProductDescription","ProductColor","ProductSize","ProductStyle")
SELECT p."ProductSKU",p."ProductName",p."ModelName",p."ProductDescription",p."ProductColor","ProductSize","ProductStyle" from p;

INSERT INTO public.products(productkey,productsubcategorykey,productcost,productprice)
SELECT p."ProductKey","ProductSubcategoryKey","ProductCost","ProductPrice" from p;

INSERT INTO public."Continent" ("Country", "Continent")
SELECT DISTINCT ON (t."Country", t."Continent") t."Country", t."Continent" FROM t;

-- Assuming your table is named "your_table_name" and the column to be changed is "your_column_name"
ALTER TABLE "Returns"
ALTER COLUMN "ReturnDate" TYPE date;
-- Update the date format
-- Update the date format
-- Set datestyle for the current session
SET datestyle = 'ISO, MDY';

-- Update the date format
UPDATE "Returns"
SET "ReturnDate" = TO_CHAR("ReturnDate"::DATE, 'YYYY-MM-DD');
-- Alter the column type with explicit conversion
ALTER TABLE "Returns"
ALTER COLUMN "ReturnDate" TYPE date
USING TO_DATE("ReturnDate", 'YYYY-MM-DD');


--1
UPDATE product_description
SET "ProductStyle" = 'NA'
WHERE "ProductStyle" = '0';

SELECT "ProductName","ProductColor","ProductSize","ProductStyle" from product_description;

--2
ALTER TABLE calendar
ADD COLUMN month VARCHAR, 
ADD COLUMN year INTEGER;

UPDATE calendar
SET
  month = TO_CHAR(e_date, 'Month'),
  year = EXTRACT(YEAR FROM e_date);
  
--3
INSERT INTO products(productkey,productsubcategorykey,productcost,productprice)
VALUES(607,14,897.64,1285.87);

--4

DELETE from products
where productkey=607;


--5
select p.productkey, "Product_Name"."ProductName",count(s.ordernumber) as Totalorders,sum(s.orderquantity) quantity_ordered from
sales s
inner join products p ON  
s.productkey=p.productkey
inner join "Product_Name" ON "Product_Name"."ProductKey" = p.productkey
group by p.productkey,"Product_Name"."ProductName"
order by Totalorders desc;

--6
select ps.productsubcategorykey,ps.subcategoryname,count(s.ordernumber) as Totalorders,sum(s.orderquantity) quantity_ordered from
sales s
inner join products  ON  
s.productkey=products.productkey
inner join product_subcategory ps ON products.productsubcategorykey = ps.productsubcategorykey
group by ps.productsubcategorykey,ps.subcategoryname
order by  ps.productsubcategorykey;



--7
EXPLAIN with tot as (SELECT *
FROM (
    SELECT
        p.productkey,
        "Product_Name"."ProductName",
        COUNT(s.ordernumber) AS TotalOrders,
        SUM(s.orderquantity) AS QuantityOrdered
    FROM
        sales s
    INNER JOIN products p ON s.productkey = p.productkey
    INNER JOIN "Product_Name" ON "Product_Name"."ProductKey" = p.productkey
    GROUP BY
        p.productkey, "Product_Name"."ProductName"
) AS orders
INNER JOIN (
    SELECT
        r."ProductKey",
        SUM(r."ReturnQuantity") AS QuantityReturned
    FROM
        "Returns" r
    GROUP BY
        r."ProductKey"
) AS qr ON orders.productkey = qr."ProductKey") 

SELECT *,round((quantityreturned::decimal /quantityordered)*100,2) as return_percentage from tot
order by quantityordered DESC;



--8
select calendar.year,calendar.month, count(s.ordernumber) as Total_Orders from sales s
inner join calendar ON calendar.e_date = s.orderdate
GROUP by calendar."year",calendar."month"
order by Total_Orders DESC;

EXPLAIN SELECT *
FROM sales
WHERE orderdate >= '2016-01-01';

-- index creation
CREATE INDEX idx_order_date ON sales(orderdate);

-- Drop the index
DROP INDEX idx_order_date;




EXPLAIN select ps.productsubcategorykey,ps.subcategoryname,count(s.ordernumber) as Totalorders,sum(s.orderquantity) quantity_ordered from
products 
INNER join product_subcategory ps ON products.productsubcategorykey = ps.productsubcategorykey
inner join sales s  ON  
products.productkey=s.productkey
group by ps.productsubcategorykey,ps.subcategoryname
order by  ps.productsubcategorykey
limit 5;


EXPLAIN select p.productkey, "Product_Name"."ProductName",count(s.ordernumber) as Totalorders,sum(s.orderquantity) quantity_ordered from
sales s
inner join products p ON  
s.productkey=p.productkey
inner join "Product_Name" ON "Product_Name"."ProductKey" = p.productkey
group by p.productkey,"Product_Name"."ProductName"
order by Totalorders desc;

explain select sa.ProductKey,"Product_Name"."ProductName",sa.Totalorders,sa.quantity_ordered from (SELECT Productkey,count(ordernumber) as Totalorders,sum(orderquantity) quantity_ordered from sales
Group by productkey) as sa,"Product_Name"
where "Product_Name"."ProductKey"=sa.ProductKey
order by sa.Totalorders desc


SELECT 
customers.gender, count(s.ordernumber) as Total_orders, sum(orderquantity) as Totalorderquantity 
from sales s
inner join customers ON customers.customerkey = s.customerkey
group By customers.gender;

SELECT
territory.country, count(s.ordernumber) as
Total_orders, sum(orderquantity) as
Totalorderquantity
from sales s
inner join territory ON territory.salesterritorykey= s.territorykey
inner join customers ON customers.customerkey = s.customerkey
where customers.totalchildren >4
group By territory.country

Use schema public  ;
select 
Ord.productkey, pn."ProductName",
'$'||' '||(products.productprice - products.productcost)*Ord.Totalorderquantity as Total_Profit
FROM
(SELECT sales.productkey,sum(orderquantity) as
Totalorderquantity from sales 
group by sales.productkey) as Ord 
inner join products on products.productkey = Ord.productkey
inner join public."Product_Name" pn ON pn."ProductKey" = products.productkey
ORDER by Total_Profit DESC;


select products.productprice - products.productcost from products









