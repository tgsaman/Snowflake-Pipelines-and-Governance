-- Loading a remote file from GitHub into a SnowSQL (client editor GUI)

CREATE OR REPLACE WAREHOUSE wh_ex1
	WAREHOUSE_SIZE = SMALL
	AUTO_RESUME = TRUE
	AUTO_SUSPEND = 120
	COMMENT = 'This is a small warehouse';
 
CREATE OR REPLACE DATABASE sample_ex1;
 
CREATE SCHEMA bank;
 
CREATE TABLE bank.asset
    (bank_code CHAR(5) NOT NULL PRIMARY KEY
    , bank_name VARCHAR(100) NOT NULL
    , country VARCHAR(100) NOT NULL
    , balsheet_k_usd INT NOT NULL);
 
--- INSERT DATA VIA WEB UI
--- https://gitlab.com/opstar/share20/-/raw/master/bigbank

USE sample_ex1;
 
SELECT a.bank_code||'_'||b.bank_code||'_'||c.bank_code AS xcode
, (a.balsheet_k_usd * b.balsheet_k_usd + c.balsheet_k_usd) AS xamt
FROM bank.asset AS a, bank.asset AS b, bank.asset AS c;

--- INSERT THIS DATA, TOO
--- gitlab.com/opstar/share20/-/raw/master/nyse/nysedayfiles/nyse20160401.txt
--- gitlab.com/opstar/share20/-/raw/master/nyse/nysedayfiles/nyse20160404.txt

SELECT dt, COUNT(*) AS cnt, AVG(open_price) AS avg_open_price,
AVG(close_price) AS avg_close_price
FROM stock.daily
GROUP BY dt;

CREATE OR REPLACE DATABASE NYSE;

USE nyse;
CREATE OR REPLACE SCHEMA stock;
CREATE OR REPLACE TABLE stock.daily
(dt DATE NOT NULL
, symbol CHAR(5) NOT NULL
, open_price DECIMAL(8,2) NOT NULL
, close_price DECIMAL(8,2) NOT NULL
, PRIMARY KEY (dt,symbol));

--- Download the following files to your local machine and use
--- SnowSQL to PUT them into the table’s stage.
--- gitlab.com/opstar/share20/-/raw/master/nyse/nysedayfiles/nyse20160401.txt
--- gitlab.com/opstar/share20/-/raw/master/nyse/nysedayfiles/nyse20160404.txt

--- In order to this, you will need to install SnowSQL and open it using the Command Line in your system's terminal. 
--- The documentation to install and run these commands can be found HERE:
--- https://docs.snowflake.com/en/user-guide/snowsql-use

--- An example of the SnowSQL Command Line interface is attached as a PNG in this repository
