

use ML_project;   --using ML_Project database.
select * from dbo.Operational_Bus_data;

-- 1.First Moment Business Decision / Measures of Central Tendency

--Mean:--
SELECT AVG(Trips_per_Day) AS mean_Trips_per_Day, AVG(Bus_Stops_Covered) AS mean_Bus_Stops_Covered,
       AVG(Frequency_mins) AS mean_Frequency_mins,AVG(Distance_Travelled_km) AS mean_Distance_Travelled_km,
       AVG(Time_mins) AS mean_Time_mins,AVG(Revenue_Generated_INR) AS mean_Revenue_Generated_INR,
	   AVG(Tickets_Sold) as mean_Tickets_Sold
FROM dbo.Operational_Bus_data

--Meadian:--

 SELECT 
Trips_per_Day AS median_Trips_per_Day,
Bus_Stops_Covered as medain_Bus_Stops_Covered,
Frequency_mins as medain_Frequency_mins,
Distance_Travelled_km as medain_Distance_Travelled_km,
Time_mins as medain_Time_mins,
Tickets_Sold as medain_Tickets_Sold,
Revenue_Generated_INR as medain_Revenue_Generated_INR
FROM (
SELECT 
Trips_per_Day, ROW_NUMBER() OVER (ORDER BY Trips_per_Day) AS row_num_Trips_per_Day,
Bus_Stops_Covered, row_number() over (order by Bus_Stops_Covered) as row_num_Bus_Stops_Covered,
Frequency_mins, row_number() over (order by Frequency_mins) as row_Frequency_mins,
Distance_Travelled_km, row_number() over (order by Distance_Travelled_km) as row_Distance_Travelled_km,
Time_mins, row_number() over (order by Time_mins) as row_Time_mins,
Tickets_Sold, row_number() over (order by Tickets_Sold) as row_Tickets_Sold,
Revenue_Generated_INR, row_number() over (order by Revenue_Generated_INR) as row_Revenue_Generated_INR,
COUNT(*) OVER () AS total_count
FROM dbo.Operational_Bus_data
) 
AS subquery
WHERE row_num_Trips_per_Day IN ((total_count + 1) / 2, (total_count + 2) / 2)
   OR row_num_Bus_Stops_Covered IN ((total_count + 1) / 2, (total_count + 2) / 2)
   OR row_Frequency_mins IN ((total_count + 1) / 2, (total_count + 2) / 2)
   OR row_Distance_Travelled_km IN ((total_count + 1) / 2, (total_count + 2) / 2)
   OR row_Time_mins IN ((total_count + 1) / 2, (total_count + 2) / 2)
   OR row_Tickets_Sold IN ((total_count + 1) / 2, (total_count + 2) / 2)
   OR row_Revenue_Generated_INR IN ((total_count + 1) / 2, (total_count + 2) / 2);

--Mode:----

SELECT TOP 1 
Trips_per_Day AS Trips_per_Day_Mode,
Way as way_mode
FROM dbo.Operational_Bus_data
GROUP BY Trips_per_Day, Way
ORDER BY COUNT(*) DESC;


---2.Second Moment Business Decision / Measures of Dispersion:-
--(i). Standard Deviation:

SELECT 
STDEV(Trips_per_Day) AS Trips_per_Day_stddev,
STDEV(bus_stops_covered) AS bus_stops_covered_stddev,
STDEV(Frequency_mins) AS Frequency_mins_stddev,
STDEV(Distance_Travelled_km) AS Distance_Travelled_km_stddev,
STDEV(Time_mins) AS Time_mins_stddev,
STDEV(Revenue_Generated_INR) AS Revenue_Generated_INR_stddev,
STDEV(Tickets_Sold) AS Tickets_Sold_stddev
FROM dbo.Operational_Bus_data;

--(ii). Range(Maximum AND Minimum):---
--Maximum:
SELECT 
max(Trips_per_Day) AS Trips_per_Day_MAX,
max(bus_stops_covered) AS bus_stops_covered_MAX,
max(Frequency_mins) AS Frequency_mins_MAX,
max(Distance_Travelled_km) AS Distance_Travelled_km_MAX,
max(Time_mins) AS Time_mins_MAX,
max(Revenue_Generated_INR) AS Revenue_Generated_INR_MAX,
max(Tickets_Sold) AS Tickets_Sold_MAX
FROM dbo.Operational_Bus_data;

---Minimum:-
SELECT 
min(Trips_per_Day) AS Trips_per_Day_Min,
min(bus_stops_covered) AS bus_stops_covered_Min,
min(Frequency_mins) AS Frequency_mins_Min,
min(Distance_Travelled_km) AS Distance_Travelled_km_Min,
min(Time_mins) AS Time_mins_Min,
min(Revenue_Generated_INR) AS Revenue_Generated_INR_Min,
min(Tickets_Sold) AS Tickets_Sold_Min
FROM dbo.Operational_Bus_data;

--(iii) Variance of Performance:-

SELECT 
var(Trips_per_Day) AS Trips_per_Day_variance,
var(bus_stops_covered) AS bus_stops_covered_variance,
var(Frequency_mins) AS Frequency_mins_variance,
var(Distance_Travelled_km) AS Distance_Travelled_km_variance,
var(Time_mins) AS Time_mins_variance,
var(Revenue_Generated_INR) AS Revenue_Generated_INR_variance,
var(Tickets_Sold) AS Tickets_Sold_variance
FROM dbo.Operational_Bus_data;

---3. Third Moment Business Decision / Skewness:-
with skwns as (
SELECT
(SUM(POWER(Trips_per_Day-(SELECT AVG(Trips_per_Day) FROM dbo.Operational_Bus_data),3))/
(COUNT(*) * POWER((SELECT STDEV(Trips_per_Day) FROM dbo.Operational_Bus_data),3))
) AS skewness
FROM dbo.Operational_Bus_data, skwns)
SELECT skewness
FROM skwns;


--4.Fourth Moment Business Decision / Kurtosis:-

SELECT
(
(SUM(POWER(Trips_per_Day- (SELECT AVG(Trips_per_Day) FROM dbo.Operational_Bus_data), 4)) /
(COUNT(*) * POWER((SELECT STDEV(bus_stops_covered) FROM dbo.Operational_Bus_data), 4))) - 3
) AS kurtosis
FROM dbo.Operational_Bus_data;

--5. Typecasting:--

SELECT 
CAST(Trips_per_Day AS CHAR(55)) AS Trips_per_Day_str,
CAST(bus_stops_covered AS CHAR(55)) AS bus_stops_covered_str,
CAST(Frequency_mins AS CHAR(55)) AS Frequency_mins_str,
CAST(Distance_Travelled_km AS CHAR(55)) AS Distance_Travelled_km_str,
CAST(Time_mins AS CHAR(55)) AS Time_mins_str,
CAST(Revenue_Generated_INR AS CHAR(55)) AS Revenue_Generated_INR_str,
CAST(Tickets_Sold AS CHAR(55)) AS Tickets_Sold_str
FROM dbo.Operational_Bus_data;

--6.Handling Duplicates:--

-- (i).Count duplicates
--This query will return the ""Column1"" columns and their respective count of duplicates in the ""TABLE_Name"" table.

SELECT Trips_per_Day,bus_stops_covered,Frequency_mins,Distance_Travelled_km,Time_mins,Tickets_Sold,Revenue_Generated_INR,
COUNT(*) as duplicate_count
FROM dbo.Operational_Bus_data
GROUP BY Trips_per_Day, bus_stops_covered, Frequency_mins, Distance_Travelled_km,Time_mins,Tickets_Sold,Revenue_Generated_INR
HAVING COUNT(*) > 1;

--(ii). Drop Duplicates

/*In this Query, a temporary table named ""temp_TABLE_NAME"" is created to hold the unique records using the DISTINCT keyword. Then, 
the original ""TABLE_NAME"" table is truncated (emptied), and the unique records are reinserted into it. Finally, the temporary table is dropped.*/

CREATE TABLE temp_TABLE_NAME (duplicate varchar);
SELECT DISTINCT * from dbo.Operational_Bus_data;

TRUNCATE TABLE dbo.Operational_Bus_data;
INSERT INTO dbo.Operational_Bus_data

SELECT * FROM temp_TABLE_NAME;
DROP TABLE temp_TABLE_Name;

--7. Outlier Treatment:-

UPDATE dbo.Operational_Bus_data AS e
JOIN (
SELECT
Trips_per_Day,
Bus_Stops_Covered,
Frequency_mins,
Distance_Travelled_km,
Time_mins,
Revenue_Generated_INR,
Tickets_Sold,
NTILE(4) OVER (ORDER BY Tickets_Sold) AS Tickets_Sold_quartile
FROM dbo.Operational_Bus_data) AS subquery ON e.Trips_per_Day = subquery.Trips_per_Day
SET e.Tickets_Sold = (
SELECT AVG(Tickets_Sold)
FROM (
SELECT
Trips_per_Day,
Bus_Stops_Covered,
Frequency_mins,
Distance_Travelled_km,
Time_mins,
Revenue_Generated_INR,
Tickets_Sold,
NTILE(4) OVER (ORDER BY Tickets_Sold) AS Tickets_Sold_quartile
FROM dbo.Operational_Bus_data
) AS temp
WHERE Tickets_Sold_quartile = subquery.Tickets_Sold_quartile
)
WHERE subquery.Tickets_Sold_quartile IN (1, 4);


--8.Zero & near Zero Variance features:-

SELECT
VAR(Trips_per_Day) AS Distance_Travelled_km_variance,
VAR(Bus_Stops_Covered) AS Time_mins_variance,
VAR(Frequency_mins) AS Tickets_Sold_variance
FROM dbo.Operational_Bus_data;


--9. Missing Values:-

SELECT
COUNT(*) AS total_rows,
SUM(CASE WHEN Bus_Route_No IS NULL THEN 1 ELSE 0 END) AS Bus_Route_No_missing,
SUM(CASE WHEN Frequency_mins IS NULL THEN 1 ELSE 0 END) AS Frequency_mins_missing,
SUM(CASE WHEN distance_Travelled_km IS NULL THEN 1 ELSE 0 END) AS distance_Travelled_km_missing,
SUM(CASE WHEN Time_mins IS NULL THEN 1 ELSE 0 END) AS Time_mins_missing
FROM dbo.Operational_Bus_data;
/*This query provides the count of total rows and the number of missing columns for each column * total_rows:14278	 
 Bus_Route_No-17	Frequency_mins-16	distance_Travelled_km-19	Time_mins- 30 */

--delete null columns
DELETE FROM dbo.Operational_Bus_data
WHERE Bus_Route_No IS NULL or
Frequency_mins IS NULL or
distance_Travelled_km IS NULL or
Time_mins IS NULL;


--10.Normalization:-

select * from dbo.Operational_Bus_data;
CREATE TABLE TABLE_Name_scaled(scaled_data int);
SELECT Trips_per_Day,
Bus_Stops_Covered,
Frequency_mins,

(Trips_per_Day - min_Trips_per_Day) / (max_Trips_per_Day - min_Trips_per_Day) AS scaled_Trips_per_Day,
(Bus_Stops_Covered - min_Bus_Stops_Covered) / (max_Bus_Stops_Covered - min_Bus_Stops_Covered) AS scaled_Bus_Stops_Covered,
(Frequency_mins - min_Frequency_mins) / (max_Frequency_mins - min_Frequency_mins) AS scaled_Frequency_mins
FROM (
SELECT Trips_per_Day,Bus_Stops_Covered,Frequency_mins,
(SELECT MIN(Frequency_mins) FROM dbo.Operational_Bus_data) AS min_Frequency_mins,
(SELECT MAX(Frequency_mins) FROM dbo.Operational_Bus_data) AS max_Frequency_mins,
(SELECT MIN(Bus_Stops_Covered) FROM dbo.Operational_Bus_data) AS min_Bus_Stops_Covered,
(SELECT MAX(Bus_Stops_Covered) FROM dbo.Operational_Bus_data) AS max_Bus_Stops_Covered,
(SELECT MIN(Trips_per_Day) FROM dbo.Operational_Bus_data) AS min_Trips_per_Day,
(SELECT MAX(Trips_per_Day) FROM dbo.Operational_Bus_data) AS max_Trips_per_Day
FROM dbo.Operational_Bus_data
) AS scaled_data;


--11.Discretization/Binning/Grouping:-

SELECT
Trips_per_Day,
Bus_Stops_Covered,
Frequency_mins,
Distance_Travelled_km,
Time_mins,
Revenue_Generated_INR,
Tickets_Sold,
CASE
WHEN Tickets_Sold < 100 THEN 'Low'
WHEN Tickets_Sold >= 100 AND Tickets_Sold < 300 THEN 'Medium'
WHEN Tickets_Sold >= 300 THEN 'High'
ELSE 'Unknown'
END AS Tickets_Sold_group
FROM dbo.Operational_Bus_data;


--12.Dummy Variable Creation:--

select * from dbo.Operational_Bus_data;
SELECT
Trips_per_Day,
Bus_Stops_Covered,
Frequency_mins,
Distance_Travelled_km,
Time_mins,
Revenue_Generated_INR,
Tickets_Sold,
CASE WHEN way = 'Round Trip' THEN 1 ELSE 0 END AS is_Round_Trip,
CASE WHEN way = 'One-way' THEN 1 ELSE 0 END AS is_One_way
FROM dbo.Operational_Bus_data;


--13.Transformations:-
--Create the new table

CREATE TABLE BUS_Transformation (Transformed int);
SELECT
Trips_per_Day,
Bus_Stops_Covered,
Frequency_mins,
Distance_Travelled_km,
Time_mins,
Revenue_Generated_INR,
Tickets_Sold,
LOG(Distance_Travelled_km) AS Distance_Travelled_km_log,
SQRT(Distance_Travelled_km) AS Distance_Travelled_km_sqrt
FROM dbo.Operational_Bus_data;








