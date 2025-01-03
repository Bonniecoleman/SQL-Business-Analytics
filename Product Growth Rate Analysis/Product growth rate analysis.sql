USE PRACTICE;

/****************************************************************************/
/********************************Product growth rate analysis********************************/
/****************************************************************************/

/***************Data Mart for Product growth rate analysis***************/

CREATE TABLE product_growth AS
SELECT  A.MEM_NO, B.CATEGORY ,B.BRAND, A.SALES_QTY * B.PRICE AS PURCHASE_AMOUNT
        ,CASE WHEN DATE_FORMAT(ORDER_DATE, '%Y-%m') BETWEEN '2020-01' AND '2020-03' THEN '2020_Q1'
			  WHEN DATE_FORMAT(ORDER_DATE, '%Y-%m') BETWEEN '2020-04' AND '2020-06' THEN '2020_Q2'
              END AS QUARTER
  FROM  SALES AS A
LEFT JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE
 WHERE  DATE_FORMAT(ORDER_DATE, '%Y-%m') BETWEEN '2020-01' AND '2020-06';

/* 1. Growth rate of purchase amount by category (2020-Q1 -> 2020-Q2) */
SELECT  * ,2020_Q2_PURCHASE_AMOUNT / 2020_Q1_PURCHASE_AMOUNT -1 AS GROWTH_RATE
  FROM  (SELECT  CATEGORY
				,SUM(CASE WHEN QUARTER = '2020_Q1' THEN PURCHASE_AMOUNT END) AS 2020_Q1_PURCHASE_AMOUNT
				,SUM(CASE WHEN QUARTER = '2020_Q2' THEN PURCHASE_AMOUNT END) AS 2020_Q2_PURCHASE_AMOUNT
		 FROM  product_growth
	 GROUP BY  CATEGORY) AS A
ORDER BY 4 DESC;

/* 2. Purchase metrics by brand in the Beauty category*/
SELECT  BRAND
        ,COUNT(DISTINCT MEM_NO) AS NUM_OF_CUSTOMERS
        ,SUM(PURCHASE_AMOUNT) AS TOTAL_AMOUNT_PURCHASE
        ,SUM(PURCHASE_AMOUNT) / COUNT(DISTINCT MEM_NO) AS PURCHASE_AMOUNT_PER_CUSTOMER
  FROM  product_growth
 WHERE  CATEGORY = 'beauty'
GROUP BY  BRAND
ORDER BY  4 DESC;

