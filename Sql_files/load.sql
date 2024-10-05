
-- Give permissions access to csv files for loading using properties
--for territory.csv
COPY public.t( "SalesTerritoryKey", "Region", "Country", "Continent")
FROM '' —excel path
DELIMITER ','
CSV HEADER;

--- for products.csv
COPY public.p("ProductKey", "ProductSubcategoryKey", "ProductSKU", "ProductName", "ModelName", "ProductDescription", "ProductColor", "ProductSize", "ProductStyle", "ProductCost", "ProductPrice")
FROM '' —excel path
DELIMITER ','
CSV HEADER;


COPY public.calendar(e_date)
FROM '' —excel path
DELIMITER ','
CSV HEADER;


COPY public.customers(customerkey, prefix, firstname, lastname, birthdate, maritalstatus, gender, emailaddress, annualincome, totalchildren, educationlevel, occupation, homeowner)
FROM '' —excel path
DELIMITER ','
CSV HEADER;


COPY public.product_category(productcategorykey, categoryname)
FROM '' —excel path
DELIMITER ','
CSV HEADER;


COPY public.product_subcategory(productsubcategorykey, subcategoryname)
FROM '' —excel path
DELIMITER ','
CSV HEADER;


COPY public."Returns"(
	"ReturnDate", "TerritoryKey", "ProductKey", "ReturnQuantity")
FROM '' —excel path
DELIMITER ','
CSV HEADER;

# 3 sales files

COPY public.sales(
	orderdate, stockdate, ordernumber, productkey, customerkey, territorykey, orderlineitem, orderquantity)
FROM '' —excel path
DELIMITER ','
CSV HEADER;

COPY public.sales(
	orderdate, stockdate, ordernumber, productkey, customerkey, territorykey, orderlineitem, orderquantity)
FROM '' —excel path
DELIMITER ','
CSV HEADER;

COPY public.sales(
	orderdate, stockdate, ordernumber, productkey, customerkey, territorykey, orderlineitem, orderquantity)
FROM '' —excel path
DELIMITER ','
CSV HEADER;


INSERT INTO public."Product_Name"("ProductKey", "ProductName")
SELECT p."ProductKey",p."ProductName" from p;

INSERT INTO public."product_description"("ProductSKU","ProductName","ModelName","ProductDescription","ProductColor","ProductSize","ProductStyle")
SELECT p."ProductSKU",p."ProductName",p."ModelName",p."ProductDescription",p."ProductColor","ProductSize","ProductStyle" from p;

INSERT INTO public.products(productkey,productsubcategorykey,productcost,productprice)
SELECT p."ProductKey","ProductSubcategoryKey","ProductCost","ProductPrice" from p;

INSERT INTO public."Continent" ("Country", "Continent")
SELECT DISTINCT ON (t."Country", t."Continent") t."Country", t."Continent" FROM t;
