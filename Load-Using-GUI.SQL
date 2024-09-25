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
