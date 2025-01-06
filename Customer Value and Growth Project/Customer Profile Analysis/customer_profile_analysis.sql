USE PRACTICE;

/****************************************************************************/
/*******************************Customer Profile Analysis************************/
/****************************************************************************/

select *
from customer;

/***************Data Mart for Customer Profile Analysis***************/
CREATE TABLE customer_profile AS
SELECT A.*
	   ,DATE_FORMAT(JOIN_DATE, "%Y-%m") AS JOIN_YEAR_MONTH
       ,2021 - YEAR(BIRTHDAY) + 1 AS AGE
       ,CASE WHEN 2021 - YEAR(BIRTHDAY) + 1 < 20 THEN "10s and under"
			 WHEN 2021 - YEAR(BIRTHDAY) + 1 < 30 THEN "20s"
             WHEN 2021 - YEAR(BIRTHDAY) + 1 < 40 THEN "30s"
             WHEN 2021 - YEAR(BIRTHDAY) + 1 < 50 THEN "40s"
             ELSE "50s and above" END AS AGE_GROUP
             
	   ,CASE WHEN B.MEM_NO IS NOT NULL THEN "Purchased"
			 ELSE "Not Purchased" END AS Purchase_Status 
FROM CUSTOMER AS A
LEFT
JOIN (SELECT DISTINCT MEM_NO FROM SALES) AS B
  ON A.MEM_NO = B.MEM_NO;

/* Check the data mart*/
SELECT *
FROM CUSTOMER_PROFILE;

/* 1. Number of Custmers by Join Year-Month*/
SELECT JOIN_YEAR_MONTH, COUNT(MEM_NO) AS NUM_CUSTOMER
FROM CUSTOMER_PROFILE
GROUP BY JOIN_YEAR_MONTH;

/* 2. Average age by gender / Number of customers by gender and age group */
SELECT GENDER, AVG(AGE) AS AVG_AGE
FROM CUSTOMER_PROFILE
GROUP BY GENDER;

SELECT GENDER, AGE_GROUP, COUNT(MEM_NO) AS NUM_CUSTOMER
FROM CUSTOMER_PROFILE
GROUP BY GENDER, AGE_GROUP
ORDER BY GENDER, AGE_GROUP;

/* 3. Number of customers by gender and age group (+ purchase status) */
SELECT GENDER, AGE_GROUP, PURCHASE_STATUS, COUNT(MEM_NO) AS NUM_CUSTOMER
FROM CUSTOMER_PROFILE
GROUP BY GENDER, AGE_GROUP, PURCHASE_STATUS
ORDER BY GENDER, AGE_GROUP, PURCHASE_STATUS;