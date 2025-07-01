CREATE DATABASE uber;

SELECT * FROM uber.`uber request data`;

USE uber;
RENAME TABLE `uber request data` TO `uber_data`;

-- 1. Total Number of Requests
SELECT COUNT(*) AS Total_Requests 
FROM uber_data;

-- 2. Requests Grouped by Status
SELECT Status, COUNT(*) AS Count
FROM uber_data
GROUP BY Status;

--  3. Requests by Hour of the Day
SELECT HOUR(STR_TO_DATE(`Request timestamp`, '%d-%m-%Y %H:%i')) AS Request_Hour,
       COUNT(*) AS Total_Requests
FROM uber_data
GROUP BY Request_Hour
ORDER BY Request_Hour;

--  4. Number of Unique Drivers
SELECT COUNT(DISTINCT `Driver id`) AS Total_Unique_Drivers
FROM uber_data
WHERE `Driver id` IS NOT NULL;

-- 5. Supply Gaps: No Cars Available by Hour -- All null/blank value rows are not uploaded
SELECT HOUR(STR_TO_DATE(`Request timestamp`, '%d-%m-%Y %H:%i')) AS Hour,
       COUNT(*) AS No_Cars_Count
FROM uber_data
WHERE Status = 'No Cars Available'
GROUP BY Hour
ORDER BY Hour;

-- 6. Cancellations by Pickup Point
SELECT `Pickup point`, COUNT(*) AS Cancelled_Requests
FROM uber_data
WHERE Status = 'Cancelled'
GROUP BY `Pickup point`;

--  7. Pickup Point vs Trip Outcome
SELECT `Pickup point`, Status, COUNT(*) AS Count
FROM uber_data
GROUP BY `Pickup point`, Status;

-- 8. Average Trip Duration by Status
SELECT Status,
       ROUND(AVG(
         TIME_TO_SEC(TIMEDIFF(
           STR_TO_DATE(`Drop timestamp`, '%d-%m-%Y %H:%i'),
           STR_TO_DATE(`Request timestamp`, '%d-%m-%Y %H:%i')
         )) / 60), 2) AS Avg_Trip_Minutes
FROM uber_data
WHERE `Drop timestamp` IS NOT NULL
  AND `Request timestamp` IS NOT NULL
GROUP BY Status;

-- 9. Driver Utilization
SELECT `Driver id`, COUNT(*) AS Completed_Trips
FROM uber_data
WHERE Status = 'Trip Completed'
GROUP BY `Driver id`
ORDER BY Completed_Trips DESC;

-- 10. Request Volume Trend Over Dates
SELECT DATE(STR_TO_DATE(`Request timestamp`, '%d-%m-%Y %H:%i')) AS Date,
       COUNT(*) AS Total_Requests
FROM uber_data
GROUP BY Date
ORDER BY Date;

-- 11. Trip Completion Rate (%)
SELECT 
  ROUND(
    (SUM(CASE WHEN Status = 'Trip Completed' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) AS Completion_Rate_Percent
FROM uber_data;
















