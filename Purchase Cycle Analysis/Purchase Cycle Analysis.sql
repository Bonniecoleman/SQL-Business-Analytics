USE PRACTICE;

/****************************************************************************/
/****************************Repurchase Rate and Purchase Cycle Analysis*****************************/
/****************************************************************************/

/***************Data Mart for Repurchase Rate and Purchase Cycle Analysis***************/

CREATE TABLE purchase_cycle AS
SELECT  *
        ,CASE WHEN DATE_ADD(FIRST_PUR_DATE, INTERVAL +1 DAY) <= LAST_PUR_DATE THEN 'Y' ELSE 'N' END AS REPUR_STATUS
        ,DATEDIFF(LAST_PUR_DATE, FIRST_PUR_DATE) AS PUR_INTERVAL
        ,CASE WHEN PUR_COUNT - 1 = 0 OR DATEDIFF(LAST_PUR_DATE, FIRST_PUR_DATE) = 0 THEN 0
              ELSE DATEDIFF(LAST_PUR_DATE, FIRST_PUR_DATE) / (PUR_COUNT - 1) END AS PUR_CYCLE
  FROM  (SELECT  MEM_NO
                ,MIN(ORDER_DATE) AS FIRST_PUR_DATE        
                ,MAX(ORDER_DATE) AS LAST_PUR_DATE
                ,COUNT(ORDER_NO) AS PUR_COUNT
          FROM  SALES
         WHERE  MEM_NO <> '9999999' /* Exclude non-members */
      GROUP BY  MEM_NO) AS A;



/* 1. Percentage of Repurchasing Customers (%) */
SELECT  COUNT(DISTINCT MEM_NO) AS NUM_PUR_CUSTOMER
		,COUNT(DISTINCT CASE WHEN REPUR_STATUS = 'Y' THEN MEM_NO END) AS NUM_REPUR_CUSTOMER
  FROM  purchase_cycle;


/* 2. Average Purchase Cycle and Number of Customers by Purchase Cycle Interval */
SELECT  AVG(PUR_INTERVAL)
  FROM  purchase_cycle
 WHERE  PUR_INTERVAL > 0;

SELECT  *
		,CASE WHEN PUR_INTERVAL <= 7 THEN 'Within 7 days'
			  WHEN PUR_INTERVAL <= 14 THEN 'Within 14 days'
			  WHEN PUR_INTERVAL <= 21 THEN 'Within 21 days'
			  WHEN PUR_INTERVAL <= 28 THEN 'Within 28 days'
			  ELSE 'After 29 days' END AS REPUR_INTERVAL
  FROM  purchase_cycle
 WHERE  PUR_INTERVAL > 0;
 
 SELECT  REPUR_INTERVAL, COUNT(MEM_NO) AS NUM_CUSTOMER
   FROM  (SELECT  *
			,CASE WHEN PUR_INTERVAL <= 7 THEN 'Within 7 days'
				  WHEN PUR_INTERVAL <= 14 THEN 'Within 14 days'
				  WHEN PUR_INTERVAL <= 21 THEN 'Within 21 days'
				  WHEN PUR_INTERVAL <= 28 THEN 'Within 28 days'
				  ELSE 'After 29 days' END AS REPUR_INTERVAL
		  FROM  purchase_cycle
		 WHERE  PUR_INTERVAL > 0)AS A
GROUP BY  REPUR_INTERVAL;