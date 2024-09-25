--- In order to illustrate Role Based Access Controls, the necessary tables must be created below.
--- Run the following commands in SQL using your own filepaths.
--- NOTE: You will need multiple users in your Snowflake instance to create and validate these controls.

CREATE TABLE car
(
	idnum int NOT NULL PRIMARY KEY,
	car varchar(50) NOT NULL,
	mpg decimal(10, 2) NOT NULL,
	cylinders tinyint NOT NULL,
	displacement decimal(10, 2) NOT NULL,
	horsepower decimal(10, 2) NOT NULL,
	weight decimal(10, 2) NOT NULL,
	acceleration decimal(10, 2) NOT NULL,
	origin varchar(50) NOT NULL,
	dt date NOT NULL
)

-- Connect using SnowSQL

-- 1. Stage a file (https://gitlab.com/opstar/share20/-/raw/master/car.txt)

USE test1;
put file://C: -- Filepath goes here --

-- 2. Stage a file with a schema

USE test1
put file://C: -- Filepath goes here --

LIST @%car;

-- Show copy history under Data

COPY INTO car FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);

USE test1;
 
CREATE OR REPLACE TABLE sales (
  city VARCHAR(20),
  zip VARCHAR(5),
  state STRING,
  type STRING,
  sale_date DATE,
  price STRING
  );
 
/* Create a file format for JSON */
CREATE OR REPLACE FILE FORMAT sales_json_format1
  TYPE = JSON;
 
/* Create a named stage */
CREATE OR REPLACE STAGE sales_stage1
FILE_FORMAT = sales_json_format1;
 
--- Download this file: https://docs.snowflake.com/en/_downloads/b50c24de20be843b34f2535dfe67fd5e/sales.json
--- Run the commands below in SNOWSQL:
/* 
USE test1;
PUT file://C:\Users\DavidPortas\Downloads\sales.json @sales_stage1;
 
*/
--- Run the commands above in SNOWSQL

TRUNCATE TABLE public.sales;

COPY INTO public.sales(city, zip, state, type, sale_date, price)
   FROM (SELECT SUBSTR($1:location.state_city,4),
                $1:location.zip,
                SUBSTR($1:location.state_city,1,2),
                'DEFAULT',
                $1:sale_date,
                $1:price
         FROM @sales_stage1 t);

SELECT * FROM public.sales;

--*************************************
use role  accountadmin;
--*************************************
CREATE DATABASE ecust;

USE ecust;

CREATE OR REPLACE TABLE ecustomer
(user_id VARCHAR(10) NOT NULL PRIMARY KEY
,title VARCHAR(10) NULL
,firstname VARCHAR(100) NULL
,middlename VARCHAR(100) NULL
,lastname VARCHAR(100) NULL
,emailaddress VARCHAR(100) NULL
,phone VARCHAR(50) NULL);

select * from ecustomer;

GRANT all ON SCHEMA public TO accountadmin;

--*************************************
use role  accountadmin;
--*************************************
CREATE ROLE ecrole;
CREATE USER ecuser PASSWORD = 'nPsbh89fwe89nvc';

GRANT ROLE ecrole TO USER ecuser;

GRANT ALL ON WAREHOUSE compute_wh TO ROLE ecrole;
GRANT USAGE ON DATABASE ecust TO ROLE ecrole;
use database ecust;
GRANT USAGE ON SCHEMA public TO ecrole;
GRANT OWNERSHIP on table ecustomer TO ecrole;
--GRANT OWNERSHIP on table ecustomer TO accountadmin;


--***************************************************
--Login to snowsql as ecuser and swich role to ecrole
--****************************************************
/*
--- put file://C:\Users\DavidPortas\Downloads\ecustomer.txt @public.%ecustomer;
*/

COPY INTO ecustomer FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);

SELECT * FROM public.ecustomer;
