-- Table: public.Category_Subcategory

-- DROP TABLE IF EXISTS public."Category_Subcategory";

CREATE TABLE IF NOT EXISTS public."Category_Subcategory"
(
    "SubcategoryName" character varying COLLATE pg_catalog."default" NOT NULL,
    "ProductCategorykey" integer NOT NULL,
    CONSTRAINT "Category_Subcategory_pkey" PRIMARY KEY ("SubcategoryName"),
    CONSTRAINT "ProductCategorykey" FOREIGN KEY ("ProductCategorykey")
        REFERENCES public.product_category (productcategorykey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Category_Subcategory"
    OWNER to postgres;
	
-- Table: public.Continent

-- DROP TABLE IF EXISTS public."Continent";

CREATE TABLE IF NOT EXISTS public."Continent"
(
    "Country" character varying COLLATE pg_catalog."default" NOT NULL,
    "Continent" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Continent_pkey" PRIMARY KEY ("Country")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Continent"
    OWNER to postgres;
-- Table: public.Product_Name

-- DROP TABLE IF EXISTS public."Product_Name";

CREATE TABLE IF NOT EXISTS public."Product_Name"
(
    "ProductKey" integer NOT NULL,
    "ProductName" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Product_Name_pkey" PRIMARY KEY ("ProductKey"),
    CONSTRAINT "Product_Name_ProductName_key" UNIQUE NULLS NOT DISTINCT ("ProductName"),
    CONSTRAINT "Product_Name_ProductKey_fkey" FOREIGN KEY ("ProductKey")
        REFERENCES public.products (productkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Product_Name"
    OWNER to postgres;

-- Table: public.Returns

-- DROP TABLE IF EXISTS public."Returns";

CREATE TABLE IF NOT EXISTS public."Returns"
(
    "ReturnDate" date NOT NULL,
    "TerritoryKey" integer NOT NULL,
    "ProductKey" integer NOT NULL,
    "ReturnQuantity" integer NOT NULL,
    CONSTRAINT "Returns_pkey" PRIMARY KEY ("ReturnDate", "TerritoryKey", "ProductKey", "ReturnQuantity"),
    CONSTRAINT "Returns_ProductKey_fkey" FOREIGN KEY ("ProductKey")
        REFERENCES public.products (productkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Returns_ReturnDate_fkey" FOREIGN KEY ("ReturnDate")
        REFERENCES public.calendar (e_date) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Returns_TerritoryKey_fkey" FOREIGN KEY ("TerritoryKey")
        REFERENCES public.territory (salesterritorykey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Returns"
    OWNER to postgres;


-- Table: public.calendar

-- DROP TABLE IF EXISTS public.calendar;

CREATE TABLE IF NOT EXISTS public.calendar
(
    e_date date NOT NULL,
    month character varying COLLATE pg_catalog."default",
    year integer,
    CONSTRAINT calendar_pkey PRIMARY KEY (e_date)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.calendar
    OWNER to postgres;
	
	
-- Table: public.customers

-- DROP TABLE IF EXISTS public.customers;

CREATE TABLE IF NOT EXISTS public.customers
(
    customerkey integer NOT NULL,
    prefix character varying COLLATE pg_catalog."default",
    firstname character varying COLLATE pg_catalog."default",
    lastname character varying COLLATE pg_catalog."default",
    birthdate date,
    maritalstatus character varying COLLATE pg_catalog."default",
    gender character varying COLLATE pg_catalog."default",
    emailaddress character varying COLLATE pg_catalog."default",
    annualincome character varying COLLATE pg_catalog."default",
    totalchildren integer,
    educationlevel character varying COLLATE pg_catalog."default",
    occupation character varying COLLATE pg_catalog."default",
    homeowner character varying COLLATE pg_catalog."default",
    CONSTRAINT customers_pkey PRIMARY KEY (customerkey)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customers
    OWNER to postgres;
	
-- Table: public.product_category

-- DROP TABLE IF EXISTS public.product_category;

CREATE TABLE IF NOT EXISTS public.product_category
(
    productcategorykey integer NOT NULL,
    categoryname character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT product_category_pkey PRIMARY KEY (productcategorykey)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product_category
    OWNER to postgres;
	
-- Table: public.product_description

-- DROP TABLE IF EXISTS public.product_description;

CREATE TABLE IF NOT EXISTS public.product_description
(
    "ProductSKU" character varying COLLATE pg_catalog."default" NOT NULL,
    "ProductName" character varying COLLATE pg_catalog."default" NOT NULL,
    "ModelName" character varying COLLATE pg_catalog."default" NOT NULL,
    "ProductDescription" character varying COLLATE pg_catalog."default",
    "ProductColor" character varying COLLATE pg_catalog."default",
    "ProductSize" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 0,
    "ProductStyle" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 0,
    CONSTRAINT product_description_pkey PRIMARY KEY ("ProductName"),
    CONSTRAINT "product_description_ProductName_fkey" FOREIGN KEY ("ProductName")
        REFERENCES public."Product_Name" ("ProductName") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product_description
    OWNER to postgres;
	
-- Table: public.product_subcategory

-- DROP TABLE IF EXISTS public.product_subcategory;

CREATE TABLE IF NOT EXISTS public.product_subcategory
(
    productsubcategorykey integer NOT NULL,
    subcategoryname character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT product_subcategory_pkey PRIMARY KEY (productsubcategorykey),
    CONSTRAINT product_subcategory_subcategoryname_fkey FOREIGN KEY (subcategoryname)
        REFERENCES public."Category_Subcategory" ("SubcategoryName") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product_subcategory
    OWNER to postgres;
	
	
-- Table: public.products

-- DROP TABLE IF EXISTS public.products;

CREATE TABLE IF NOT EXISTS public.products
(
    productkey integer NOT NULL,
    productsubcategorykey integer NOT NULL,
    productcost double precision NOT NULL,
    productprice double precision NOT NULL,
    CONSTRAINT products_pkey PRIMARY KEY (productkey),
    CONSTRAINT products_productsubcategorykey_fkey FOREIGN KEY (productsubcategorykey)
        REFERENCES public.product_subcategory (productsubcategorykey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.products
    OWNER to postgres;
	
	
-- Table: public.sales

-- DROP TABLE IF EXISTS public.sales;

CREATE TABLE IF NOT EXISTS public.sales
(
    orderdate date NOT NULL,
    stockdate date NOT NULL,
    ordernumber character varying COLLATE pg_catalog."default" NOT NULL,
    productkey integer NOT NULL,
    customerkey integer NOT NULL,
    territorykey integer NOT NULL,
    orderlineitem integer NOT NULL,
    orderquantity integer NOT NULL,
    CONSTRAINT sales_pkey PRIMARY KEY (ordernumber, productkey),
    CONSTRAINT sales_customerkey_fkey FOREIGN KEY (customerkey)
        REFERENCES public.customers (customerkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT sales_orderdate_fkey FOREIGN KEY (orderdate)
        REFERENCES public.calendar (e_date) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT sales_productkey_fkey FOREIGN KEY (productkey)
        REFERENCES public.products (productkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT sales_territorykey_fkey FOREIGN KEY (territorykey)
        REFERENCES public.territory (salesterritorykey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.sales
    OWNER to postgres;


-- Table: public.territory

-- DROP TABLE IF EXISTS public.territory;

CREATE TABLE IF NOT EXISTS public.territory
(
    salesterritorykey integer NOT NULL,
    region character varying COLLATE pg_catalog."default" NOT NULL,
    country character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT territory_pkey PRIMARY KEY (salesterritorykey),
    CONSTRAINT territory_country_fkey FOREIGN KEY (country)
        REFERENCES public."Continent" ("Country") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.territory
    OWNER to postgres;
	
--- Table P

-- Table: public.p

-- DROP TABLE IF EXISTS public.p;

CREATE TABLE IF NOT EXISTS public.p
(
    "ProductKey" integer,
    "ProductSubcategoryKey" integer,
    "ProductSKU" character varying COLLATE pg_catalog."default",
    "ProductName" character varying COLLATE pg_catalog."default",
    "ModelName" character varying COLLATE pg_catalog."default",
    "ProductDescription" character varying COLLATE pg_catalog."default",
    "ProductColor" character varying COLLATE pg_catalog."default",
    "ProductSize" character varying COLLATE pg_catalog."default",
    "ProductStyle" character varying COLLATE pg_catalog."default",
    "ProductCost" double precision,
    "ProductPrice" double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.p
    OWNER to postgres;
	
-- Table: public.t

-- DROP TABLE IF EXISTS public.t;

CREATE TABLE IF NOT EXISTS public.t
(
    "SalesTerritoryKey" integer,
    "Region" character varying COLLATE pg_catalog."default",
    "Country" character varying COLLATE pg_catalog."default",
    "Continent" character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.t
    OWNER to postgres;
	
