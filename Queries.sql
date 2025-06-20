show databases;
create database labmentix;
use labmentix;


-- 1. SHOWING ALL DATA
select * from uberdata
order by Request_timestamp;

-- 2. TOTAL NUMBER OF REQUESTS
select count(Request_id) as "Total Number of Cab Requests" from uberdata;

-- 3. REQUESTS BY STATUS
select Status,count(Request_id) as "Cab Requests" from uberdata
group by Status;

-- 4. PERCENTAGE OF RIDES BY STATUS
SELECT Status,COUNT(*) AS total_requests,ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uberdata), 2) AS percentage
FROM uberdata
GROUP BY Status;

-- 5. CAB REQUESTS BY PICKUP POINT
select Pickup_point, count(Request_id) as "Cab Requests" from uberdata
group by Pickup_point;

-- 6. PERCENTAGE OF CAB REQUESTS BY PICKUP POINT
SELECT Pickup_point, COUNT(*) AS Total_Requests, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uberdata) AS Percentage
FROM uberdata
GROUP BY Pickup_point;

-- 7. DRIVER PERFORMANCE
select Driver_id, count(*) as Number_of_Rides from uberdata
where Driver_id is not null
group by Driver_id
order by Number_of_Rides desc;

-- DATE FORMATTING FOR REQUEST 
ALTER TABLE uberdata ADD request_dt DATETIME;
UPDATE uberdata
SET request_dt = STR_TO_DATE(`Request_timestamp`, '%d-%m-%Y %H:%i');

-- DATE FORMATTING FOR DROP 
ALTER TABLE uberdata ADD drop_dt DATETIME;
UPDATE uberdata
SET drop_dt = STR_TO_DATE(`Drop_timestamp`, '%d-%m-%Y %H:%i');

-- DELETING OLD COLUMNS
ALTER TABLE uberdata
DROP COLUMN `Request_timestamp`,
DROP COLUMN `Drop_timestamp`;

-- RENAME NEW COLUMNS 
ALTER TABLE uberdata
CHANGE request_dt `Request_timestamp` DATETIME,
CHANGE drop_dt `Drop_timestamp` DATETIME;

-- 8. REQUESTS BY HOURS
select hour(Request_timestamp)as Hours,count(*) as Requests from uberdata
group by Hours
order by Hours;

-- 9. BUSIEST HOURS
select hour(Request_timestamp)as Hours,count(*) as Requests from uberdata
group by Hours
order by Requests desc;

-- 10. TIME GAP
SELECT Request_timestamp,Drop_timestamp,ROUND(TIMESTAMPDIFF(SECOND, Request_timestamp, Drop_timestamp) / 3600, 2) AS Ride_Time
FROM uberdata
WHERE Drop_timestamp IS NOT NULL AND Request_timestamp IS NOT NULL
ORDER BY Request_timestamp;

-- 11. AVERAGE RIDE TIME
SELECT ROUND(AVG(TIMESTAMPDIFF(SECOND, Request_timestamp, Drop_timestamp) / 3600), 2) AS Average_Ride_Time
FROM uberdata
WHERE Drop_timestamp IS NOT NULL AND Request_timestamp IS NOT NULL;








