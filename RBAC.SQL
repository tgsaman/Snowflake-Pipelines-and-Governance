USE test1;

CREATE OR REPLACE TABLE car
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
AS
SELECT 101, 'Chevrolet Chevelle Malibu', 18.00, 8, 307.00, 130.00, 3504.00, 12.00, 'US', '1970-10-17' UNION
SELECT 102, 'Buick Skylark 320', 15.00, 8, 350.00, 165.00, 3693.00, 11.50, 'US', '1970-05-13' UNION
SELECT 103, 'Plymouth Satellite', 18.00, 8, 318.00, 150.00, 3436.00, 11.00, 'US', '1970-03-05' UNION
SELECT 104, 'AMC Rebel SST', 16.00, 8, 304.00, 150.00, 3433.00, 12.00, 'US', '1970-05-10' UNION
SELECT 105, 'Ford Torino', 17.00, 8, 302.00, 140.00, 3449.00, 10.50, 'US', '1970-06-01' UNION
SELECT 106, 'Ford Galaxie 500', 15.00, 8, 429.00, 198.00, 4341.00, 10.00, 'US', '1970-09-10' UNION
SELECT 107, 'Chevrolet Impala', 14.00, 8, 454.00, 220.00, 4354.00, 9.00, 'US', '1970-04-25' UNION
SELECT 108, 'Plymouth Fury iii', 14.00, 8, 440.00, 215.00, 4312.00, 8.50, 'US', '1970-03-27' UNION
SELECT 109, 'Pontiac Catalina', 14.00, 8, 455.00, 225.00, 4425.00, 10.00, 'US', '1970-02-27' UNION
SELECT 110, 'AMC Ambassador DPL', 15.00, 8, 390.00, 190.00, 3850.00, 8.50, 'US', '1970-09-17' UNION
SELECT 121, 'Toyota Corolla Mark ii', 24.00, 4, 113.00, 95.00, 2372.00, 15.00, 'Japan', '1970-05-03' UNION
SELECT 125, 'Datsun PL510', 27.00, 4, 97.00, 88.00, 2130.00, 14.50, 'Japan', '1970-01-13' UNION
SELECT 136, 'Datsun PL510', 27.00, 4, 97.00, 88.00, 2130.00, 14.50, 'Japan', '1971-01-28' UNION
SELECT 158, 'Opel 1900', 28.00, 4, 116.00, 90.00, 2123.00, 14.00, 'Europe', '1971-04-17' UNION
SELECT 159, 'Peugeot 304', 30.00, 4, 79.00, 70.00, 2074.00, 19.50, 'Europe', '1971-02-09' UNION
SELECT 160, 'Fiat 124B', 30.00, 4, 88.00, 76.00, 2065.00, 14.50, 'Europe', '1971-04-01';

ALTER TABLE car DROP ROW ACCESS POLICY car_region;

CREATE OR REPLACE ROW ACCESS POLICY car_region AS (r STRING) RETURNS boolean ->
  (CASE WHEN r ='US' OR r = 'Europe' THEN True ELSE False END);

ALTER TABLE car ADD ROW ACCESS POLICY car_region ON (origin);

CREATE ROLE caruser;
GRANT USAGE ON DATABASE test1 TO caruser;
GRANT ALL ON WAREHOUSE compute_wh TO caruser;
GRANT USAGE ON SCHEMA public TO caruser;
GRANT SELECT ON TABLE car TO caruser;
GRANT ROLE caruser TO USER dportas4;

use role caruser;
use role accountadmin;

COPY INTO public.car FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1)
FILES = ('car.txt.gz');

COPY INTO stock.daily FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '\t' SKIP_HEADER = 0)
PATTERN = 'nyse20.*.txt.gz';

--- Assign a role to a new user:

CREATE USER dpuser1 PASSWORD = 'p44123ggghh';
 
create or replace warehouse dev_dba_wh
warehouse_size = 'SMALL'
auto_suspend = 60
initially_suspended = true;
 
USE test1;

CREATE ROLE canreadonly;
 
GRANT ALL ON WAREHOUSE dev_dba_wh TO ROLE canreadonly;
GRANT USAGE ON DATABASE test1 TO ROLE canreadonly;
GRANT USAGE ON SCHEMA public TO ROLE canreadonly;
GRANT SELECT ON TABLE car TO ROLE canreadonly;
GRANT INSERT ON TABLE car TO ROLE canreadonly;
GRANT DELETE ON TABLE car TO ROLE canreadonly;
REVOKE INSERT ON TABLE car FROM ROLE canreadonly;
REVOKE DELETE ON TABLE car FROM ROLE canreadonly;
REVOKE SELECT ON TABLE car FROM ROLE canreadonly;
 
GRANT ROLE canreadonly TO USER dpuser1;
 
GRANT OWNERSHIP ON TABLE car TO ROLE canreadonly;

--- Create a Masking Policy:

USE ecust;
 
SELECT * FROM public.ecustomer LIMIT 100;
 
CREATE OR REPLACE MASKING POLICY email_mask AS (xval string) RETURNS string ->
'*****'||RIGHT(xval, 6);
 
alter table public.ecustomer modify column emailaddress set masking policy email_mask;
alter table public.ecustomer modify column emailaddress unset masking policy;
 
CREATE OR REPLACE MASKING POLICY email_mask2 AS (xval string) RETURNS string ->
CASE WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'
    THEN xval
    ELSE LEFT(xval,2)||'********'
END;
 
alter table public.ecustomer modify column emailaddress set masking policy email_mask2;
alter table public.ecustomer modify column emailaddress unset masking policy;
 
SELECT CURRENT_ROLE();
USE ROLE accountadmin;
use role ecrole;
 
GRANT SELECT ON ecustomer TO ROLE ecrole;
 
SELECT * FROM public.ecustomer LIMIT 100;
 
SELECT CURRENT_USER();
 
GRANT ROLE ecrole TO USER dpuser1;

USE ecust;
 
SELECT * FROM public.ecustomer LIMIT 100;
 
CREATE OR REPLACE MASKING POLICY email_mask AS (xval string) RETURNS string ->
'*****'||RIGHT(xval, 6);
 
alter table public.ecustomer modify column emailaddress set masking policy email_mask;
alter table public.ecustomer modify column emailaddress unset masking policy;
 
CREATE OR REPLACE MASKING POLICY email_mask2 AS (xval string) RETURNS string ->
CASE WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'
    THEN xval
    ELSE LEFT(xval,2)||'********'
END;
 
alter table public.ecustomer modify column emailaddress set masking policy email_mask2;
alter table public.ecustomer modify column emailaddress unset masking policy;
 
SELECT CURRENT_ROLE();
USE ROLE accountadmin;
use role ecrole;
 
GRANT SELECT ON ecustomer TO ROLE ecrole;
 
SELECT * FROM public.ecustomer LIMIT 100;
 
SELECT CURRENT_USER();
 
GRANT ROLE ecrole TO USER dpuser1;
