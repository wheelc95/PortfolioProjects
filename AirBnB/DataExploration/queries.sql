
-------------------------------------------------------
----CLEANED UP ORIGINAL Market_Analysis_2019 CSV FILE--
-------------------------------------------------------
--Orginal csv file had the month column formatted as i.e. 2019-1. altering table to split the column into a month column and a year column
ALTER TABLE AirBnB.dbo.market_analysis_2019
ADD year_column INT,
    month_column INT;

--Updated table to create a seperate year and month columns
UPDATE market_analysis_2019
SET year_column = CAST(SUBSTRING(month, 1, 4) AS INT),
    month_column = CAST(SUBSTRING(month, 6, 2) AS INT);

--Dropped the old month column from the original csv file
ALTER TABLE market_analysis_2019
DROP COLUMN [month];



-------------------------------------------
----CLEANED UP ORIGINAL Amenties CSV FILE--
-------------------------------------------
--Changed hot_tub column from bit to int
ALTER TABLE amenities
ALTER COLUMN hot_tub INT;

--Changed pool column from bit to int
ALTER TABLE amenities
ALTER COLUMN [pool] INT;

--Orginal csv file had the month column formatted as i.e. 2019-1. altering table to split the column into a month column and a year column
ALTER TABLE AirBnB.dbo.amenities
ADD year_column INT,
    month_column INT;

--Updated table to create a seperate year and month columns
UPDATE amenities
SET year_column = CAST(SUBSTRING(month, 1, 4) AS INT),
    month_column = CAST(SUBSTRING(month, 6, 2) AS INT);

--Dropped the old month column from the original csv file
ALTER TABLE amenities
DROP COLUMN [month];

--Select data we are going to be using
SELECT * 
FROM amenities

--Group unified_id by total number of hot tubs and pools per unified_id
SELECT unified_id, MAX(hot_tub) AS hot_tub, MAX([pool]) AS [pool]
FROM amenities
GROUP BY unified_id
ORDER BY unified_id



---------------------------------------------------------------------------------
--Created a temp table to store the market_analysis and amenities tables joined--
---------------------------------------------------------------------------------
--Created a temp Ttble that will store the market_analysis and amenities tables joined and inserted data from both tables into temp table
CREATE TABLE #MonthlyIdDataQuery1 (
    unified_id VARCHAR(255),
    zipcode VARCHAR(255),
    city VARCHAR(255),
    host_type VARCHAR(255),
    bedrooms INT,
    bathrooms INT,
	hot_tubs INT,
	pools INT,
    guests INT,
    revenue DECIMAL(18, 2),
    openness DECIMAL(18, 2),
    occupancy DECIMAL(18, 2),
    nightly_rate DECIMAL(18, 2),
    lead_time INT,
    length_stay INT,
    year_column INT,
    month_column INT
);
INSERT INTO #MonthlyIdDataQuery1 (unified_id, zipcode, city, host_type, bedrooms, bathrooms,hot_tubs, pools, guests, revenue, openness, occupancy, nightly_rate, lead_time, length_stay, year_column, month_column)
SELECT 
    ma.unified_id,
    ma.zipcode,
    ma.city,
    ma.host_type,
    ma.bedrooms,
    ma.bathrooms,
	amen.hot_tub,
	amen.pool,
    ma.guests,
    ma.revenue,
    ma.openness,
    ma.occupancy,
    ma.nightly_rate,
    ma.lead_time,
    ma.length_stay,
    ma.year_column,
    ma.month_column
FROM market_analysis_2019 ma --alias for market_analysis_2019 table
JOIN amenities amen ON ma.unified_id = amen.unified_id;

--Altered temp table to fill in null values for hot_tub and pool column--
UPDATE #MonthlyIdDataQuery1
SET hot_tubs = ISNULL(hot_tubs, 0),
	pools = ISNULL(pools, 0),
	revenue = ISNULL(revenue, 0),
	nightly_rate = ISNULL(nightly_rate, 0)
WHERE #MonthlyIdDataQuery1.hot_tubs IS NULL 
	OR #MonthlyIdDataQuery1.pools IS NULL;

--Deleted duplicate rows after inserting data from maket_analysis table into temp table
WITH DeletedDuplicateRows AS (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY unified_id, year_column, month_column 
		ORDER BY unified_id) AS row_num 
		FROM #MonthlyIdDataQuery1
	)
	DELETE FROM  DeletedDuplicateRows WHERE row_num > 1;




----------------------
--Summary Statistics--
----------------------
-- Select data used 
SELECT *
FROM #MonthlyIdDataQuery1

--Average of bedrooms, bathrooms, guest, revenue, and availibility 
SELECT AVG(bedrooms) AS AvgBedrooms, AVG(bathrooms) AS AvgBathrooms, AVG(guests) AS AvgGuests, AVG(revenue) AS AvgRevenue, AVG(openness) as AvgDaysAvail, AVG(occupancy) as AvgOccupancy, AVG(nightly_rate) as AvgNightlyRate, AVG(lead_time) as AvgLeadTime, AVG(length_stay) as AvgDaysStayed
FROM #MonthlyIdDataQuery1

--Median of bedrooms, bathrooms, guest, revenue, openness, occupancy, nightly rate, lead time, and length of stay
SELECT DISTINCT
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bedrooms) OVER() AS BedroomMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bathrooms) OVER() AS BathroomMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY guests) OVER() AS GuestsMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) OVER() AS RevenueMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY openness) OVER() AS OpennessMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY occupancy) OVER() AS OccupancyMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY nightly_rate) OVER() AS NightlyRateMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY lead_time) OVER() AS LeadTimeMedian,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY length_stay) OVER() AS LengthStayMedian
FROM #MonthlyIdDataQuery1;

--Mode of bedrooms, bathrooms, guest, revenue, openness, occupancy, nightly rate, lead time, and length of stay
WITH ModeCounts AS (
    SELECT 'Bedrooms' AS ColumnName, bedrooms AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY bedrooms
    UNION ALL
    SELECT 'Bathrooms' AS ColumnName, bathrooms AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY bathrooms
	UNION ALL
    SELECT 'HotTubs' AS ColumnName, hot_tubs AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY hot_tubs
	UNION ALL
    SELECT 'Pools' AS ColumnName, pools AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY pools
	UNION ALL
    SELECT 'Guest' AS ColumnName, guests AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY guests
	UNION ALL
    SELECT 'Revenue' AS ColumnName, revenue AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY revenue
	UNION ALL
    SELECT 'Openness' AS ColumnName, openness AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY openness
	UNION ALL
    SELECT 'Occupancy' AS ColumnName, occupancy AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY occupancy
	UNION ALL
    SELECT 'NightlyRate' AS ColumnName, nightly_rate AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY nightly_rate
	UNION ALL
    SELECT 'LeadTime' AS ColumnName, lead_time AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY lead_time
	UNION ALL
    SELECT 'LengthOfStay' AS ColumnName, length_stay AS Value, COUNT(*) AS Frequency
    FROM #MonthlyIdDataQuery1
    GROUP BY length_stay
),
RankedModes AS (
    SELECT ColumnName, Value, Frequency,
           ROW_NUMBER() OVER (PARTITION BY ColumnName ORDER BY Frequency DESC) AS Rank
    FROM ModeCounts
)
SELECT ColumnName, Value AS Mode, Frequency
FROM RankedModes
WHERE Rank = 1;

--Standard deviation of bedrooms, bathrooms, guest, revenue, openness, occupancy, nightly rate, lead time, and length of stay
SELECT 
    STDEV(bedrooms) AS bedrooms_std_dev,
    STDEV(bathrooms) AS bathrooms_std_dev,
    STDEV(hot_tubs) AS hot_tubs_std_dev,
    STDEV(pools) AS pools_std_dev,
    STDEV(guests) AS guests_std_dev,
    STDEV(revenue) AS revenue_std_dev,
    STDEV(openness) AS openness_std_dev,
    STDEV(occupancy) AS occupancy_std_dev,
    STDEV(nightly_rate) AS nightly_rate_std_dev,
    STDEV(lead_time) AS lead_time_std_dev,
    STDEV(length_stay) AS length_stay_std_dev
FROM 
    #MonthlyIdDataQuery1;


--Min of bedrooms, bathrooms, guest, revenue, openness, occupancy, nightly rate, lead time, and length of stay
SELECT 
    MIN(bedrooms) AS min_bedrooms,
    MIN(bathrooms) AS min_bathrooms,
    MIN(hot_tubs) AS min_hot_tubs,
    MIN(pools) AS min_pools,
    MIN(guests) AS min_guests,
    MIN(revenue) AS min_revenue,
    MIN(openness) AS min_openness,
    MIN(occupancy) AS min_occupancy,
    MIN(nightly_rate) AS min_nightly_rate,
    MIN(lead_time) AS min_lead_time,
    MIN(length_stay) AS min_length_stay
FROM 
    #MonthlyIdDataQuery1;

--Max of bedrooms, bathrooms, guest, revenue, openness, occupancy, nightly rate, lead time, and length of stay
SELECT 
    MAX(bedrooms) AS max_bedrooms,
    MAX(bathrooms) AS max_bathrooms,
    MAX(hot_tubs) AS max_hot_tubs,
    MAX(pools) AS max_pools,
    MAX(guests) AS max_guests,
    MAX(revenue) AS max_revenue,
    MAX(openness) AS max_openness,
    MAX(occupancy) AS max_occupancy,
    MAX(nightly_rate) AS max_nightly_rate,
    MAX(lead_time) AS max_lead_time,
    MAX(length_stay) AS max_length_stay
FROM 
    #MonthlyIdDataQuery1;

--Quartiles of bedrooms, bathrooms, guest, revenue, openness, occupancy, nightly rate, lead time, and length of stay
SELECT DISTINCT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY bedrooms) OVER() AS q1_bedrooms,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY bedrooms) OVER() AS median_bedrooms,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY bedrooms) OVER() AS q3_bedrooms,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY bathrooms) OVER() AS q1_bathrooms,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY bathrooms) OVER() AS median_bathrooms,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY bathrooms) OVER() AS q3_bathrooms,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY hot_tubs) OVER() AS q1_hot_tubs,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY hot_tubs) OVER() AS median_hot_tubs,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY hot_tubs) OVER() AS q3_hot_tubs,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY pools) OVER() AS q1_pools,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY pools) OVER() AS median_pools,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY pools) OVER() AS q3_pools,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY guests) OVER() AS q1_guests,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY guests) OVER() AS median_guests,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY guests) OVER() AS q3_guests,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue) OVER() AS q1_revenue,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY revenue) OVER() AS median_revenue,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue) OVER() AS q3_revenue,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY openness) OVER() AS q1_openness,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY openness) OVER() AS median_openness,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY openness) OVER() AS q3_openness,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY occupancy) OVER() AS q1_occupancy,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY occupancy) OVER() AS median_occupancy,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY occupancy) OVER() AS q3_occupancy,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY nightly_rate) OVER() AS q1_nightly_rate,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY nightly_rate) OVER() AS median_nightly_rate,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY nightly_rate) OVER() AS q3_nightly_rate,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY lead_time) OVER() AS q1_lead_time,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY lead_time) OVER() AS median_lead_time,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY lead_time) OVER() AS q3_lead_time,
    
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY length_stay) OVER() AS q1_length_stay,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY length_stay) OVER() AS median_length_stay,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY length_stay) OVER() AS q3_length_stay
   
FROM 
    #MonthlyIdDataQuery1;





--------------------
--Data Exploration--
--------------------
-- Select data used 
SELECT *
FROM #MonthlyIdDataQuery1

--Count the number of entries in dataset
SELECT COUNT(*) AS total_rows
FROM #MonthlyIdDataQuery1;




--Geographical Analysis
--Count the number of listings in each city and zipcode
SELECT city, zipcode, COUNT(DISTINCT unified_id) as listings_per_city
FROM #MonthlyIdDataQuery1
GROUP BY city, zipcode
ORDER BY listings_per_city DESC

--Average revenue by city
SELECT city, AVG(revenue) average_revenue
FROM #MonthlyIdDataQuery1
GROUP BY city
ORDER BY average_revenue DESC

--Average occupancy rate by city
SELECT city, AVG(occupancy) average_occupancy
FROM #MonthlyIdDataQuery1
GROUP BY city
ORDER BY average_occupancy DESC



--Property Type Analysis
--Count the number of each type of host (host_type).
SELECT host_type, COUNT(host_type) AS count_of_host_type
FROM #MonthlyIdDataQuery1
GROUP BY host_type
ORDER BY count_of_host_type DESC

--Analyze the distribution of bedrooms and bathrooms across different types of hosts.
SELECT 
    host_type,
    AVG(bedrooms) AS avg_bedrooms,
    AVG(bathrooms) AS avg_bathrooms,
    MIN(bedrooms) AS min_bedrooms,
    MAX(bedrooms) AS max_bedrooms,
    MIN(bathrooms) AS min_bathrooms,
    MAX(bathrooms) AS max_bathrooms
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    host_type;

--Compare revenue between different types of hosts
SELECT 
    host_type,
    AVG(revenue) AS avg_revenue,
    SUM(revenue) AS total_revenue
FROM  #MonthlyIdDataQuery1
GROUP BY host_type;

--Compare occupancy rates between different types of hosts
SELECT 
    host_type,
    AVG(occupancy) AS avg_occupancy
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    host_type;



--Amenities Analysis
--Calculate the percentage of listings with hot tubs
SELECT 
    (COUNT(CASE WHEN hot_tubs = 1 THEN 1 END) * 100.0 / COUNT(*)) AS hot_tub_percentage
FROM 
    #MonthlyIdDataQuery1;

--Calculate the percentage of listings with pools
SELECT 
    (COUNT(CASE WHEN pools = 1 THEN 1 END) * 100.0 / COUNT(*)) AS pool_percentage
FROM 
    #MonthlyIdDataQuery1;

-- Calculate average revenue for listings with and without hot tubs
SELECT 
    hot_tubs,
    AVG(revenue) AS avg_revenue
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    hot_tubs;

-- Calculate average revenue for listings with and without pools
SELECT 
    pools,
    AVG(revenue) AS avg_revenue
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    pools;

-- Calculate average occupancy rates for listings with and without hot tubs
SELECT 
    hot_tubs,
    AVG(occupancy) AS avg_occupancy
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    hot_tubs;

-- Calculate average occupancy rates for listings with and without pools
SELECT 
    pools,
    AVG(occupancy) AS avg_occupancy
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    pools;

--Identify the most common amenities combination (e.g., properties with both hot tubs and pools)
SELECT 
    CASE 
        WHEN hot_tubs = 1 THEN 'Hot Tub,' 
        ELSE '' 
    END +
    CASE 
        WHEN pools = 1 THEN 'Pool,' 
        ELSE '' 
    END +
    CASE 
        WHEN hot_tubs = 0 AND pools = 0 THEN 'No Amenities'
        ELSE '' 
    END AS amenities_combination,
    COUNT(*) AS frequency
FROM 
    #MonthlyIdDataQuery1
GROUP BY 
    CASE 
        WHEN hot_tubs = 1 THEN 'Hot Tub,' 
        ELSE '' 
    END +
    CASE 
        WHEN pools = 1 THEN 'Pool,' 
        ELSE '' 
    END +
    CASE 
        WHEN hot_tubs = 0 AND pools = 0 THEN 'No Amenities'
        ELSE '' 
    END
ORDER BY 
    frequency DESC;





--Demand and Pricing Analysis
--Analyze the average nightly rate by city
SELECT city, AVG(nightly_rate) AS avg_nightly_rate
FROM #MonthlyIdDataQuery1
GROUP BY city;

--Analyze the average nightly rate by zipcode
SELECT zipcode, AVG(nightly_rate) AS avg_nightly_rate
FROM #MonthlyIdDataQuery1
GROUP BY zipcode;

--Grouped lead time into ranges (e.g., 0-7 days, 8-14 days, 15-30 days, etc.) and then calculated average revenue or occupancy rates for each range.
SELECT
    CASE 
        WHEN lead_time BETWEEN 0 AND 7 THEN '0-7 days'
        WHEN lead_time BETWEEN 8 AND 14 THEN '8-14 days'
        WHEN lead_time BETWEEN 15 AND 30 THEN '15-30 days'
        ELSE 'More than 30 days'
    END AS lead_time_range,
    AVG(revenue) AS avg_revenue,
    AVG(occupancy) AS avg_occupancy
FROM
    #MonthlyIdDataQuery1
GROUP BY
    CASE 
        WHEN lead_time BETWEEN 0 AND 7 THEN '0-7 days'
        WHEN lead_time BETWEEN 8 AND 14 THEN '8-14 days'
        WHEN lead_time BETWEEN 15 AND 30 THEN '15-30 days'
        ELSE 'More than 30 days'
    END;

--Examine the length of stay patterns and their impact on revenue.
SELECT
    CASE 
        WHEN length_stay BETWEEN 1 AND 3 THEN '1-3 nights'
        WHEN length_stay BETWEEN 4 AND 7 THEN '4-7 nights'
        WHEN length_stay BETWEEN 8 AND 14 THEN '8-14 nights'
        ELSE 'More than 14 nights'
    END AS length_stay_range,
    AVG(revenue) AS avg_revenue
FROM
    #MonthlyIdDataQuery1
GROUP BY
    CASE 
        WHEN length_stay BETWEEN 1 AND 3 THEN '1-3 nights'
        WHEN length_stay BETWEEN 4 AND 7 THEN '4-7 nights'
        WHEN length_stay BETWEEN 8 AND 14 THEN '8-14 nights'
        ELSE 'More than 14 nights'
    END;
