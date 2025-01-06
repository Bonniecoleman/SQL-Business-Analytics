USE PRACTICE;

/****************************************************************************/
/*********************************RFM Analysis************************************/
/****************************************************************************/

/***************Data Mart for RFM Analysis***************/
CREATE TABLE RFM AS 
SELECT A.*, B.TOTAL_SPEND, B.PURCHASE_COUNT
FROM CUSTOMER AS A
LEFT JOIN (SELECT A.MEM_NO, SUM(A.SALES_QTY * B.PRICE) AS TOTAL_SPEND, COUNT(A.ORDER_NO) AS PURCHASE_COUNT
FROM SALES AS A
LEFT JOIN PRODUCT AS B
ON A.PRODUCT_CODE = B.PRODUCT_CODE
WHERE YEAR(A.ORDER_DATE) = '2020'
GROUP BY A.MEM_NO) AS B
ON A.MEM_NO = B.MEM_NO;

/* 1. Number of Cusomters by RFM segmentation */
SELECT  SEGMENTATION, COUNT(MEM_NO) AS NUM_CUSTOMER
  FROM  (SELECT *
		,CASE WHEN TOTAL_SPEND >  5000000 THEN 'VIP Customer'
			  WHEN TOTAL_SPEND >  1000000 OR PURCHASE_COUNT > 3 THEN 'Premium Customer'
		      WHEN TOTAL_SPEND >        0 THEN 'Regular Customer'
			  ELSE 'Potential Customer' END AS SEGMENTATION
		FROM  RFM)AS A
GROUP BY  SEGMENTATION
ORDER BY  NUM_CUSTOMER ASC;


/* 2. Revenue by RFM Segmentation */
SELECT  SEGMENTATION, SUM(TOTAL_SPEND) AS TOTAL_SPEND
  FROM  (SELECT  *
		,CASE WHEN TOTAL_SPEND >  5000000 THEN 'VIP'
			  WHEN TOTAL_SPEND >  1000000 OR PURCHASE_COUNT > 3 THEN 'Premium Customer'
			  WHEN TOTAL_SPEND >        0 THEN 'Regular Customer'
			  ELSE 'Potential Customer' END AS SEGMENTATION
		 FROM  RFM) AS A
GROUP BY  SEGMENTATION
ORDER BY  TOTAL_SPEND DESC;


/* 3. Average Revenue per Customer by RFM Segmentation */
SELECT  SEGMENTATION, SUM(TOTAL_SPEND) / COUNT(MEM_NO) AS AVG_REV_PER_CUSTOMER
	FROM  (SELECT  *
		,CASE WHEN TOTAL_SPEND >  5000000 THEN 'VIP'
			  WHEN TOTAL_SPEND >  1000000 OR PURCHASE_COUNT > 3 THEN 'Premium Customer'
			  WHEN TOTAL_SPEND >        0 THEN 'Regular Customer'
			  ELSE 'Potential Customer' END AS SEGMENTATION
		 FROM  RFM) AS A
GROUP BY  SEGMENTATION
ORDER BY  AVG_REV_PER_CUSTOMER DESC;
