-- ================================================
-- Hotel Booking Cancellation & Revenue Analysis
-- File 1: Table Setup and Data Cleaning
-- Dataset: Hotel Booking Demand (119,390 records)
-- ================================================


-- STEP 1: Create Table
CREATE TABLE hotel_bookings (
    hotel VARCHAR(50),
    is_canceled INT,
    lead_time INT,
    arrival_date_year INT,
    arrival_date_month VARCHAR(20),
    arrival_date_week_number INT,
    arrival_date_day_of_month INT,
    stays_in_weekend_nights INT,
    stays_in_week_nights INT,
    adults INT,
    children VARCHAR(10),
    babies INT,
    meal VARCHAR(20),
    country VARCHAR(10),
    market_segment VARCHAR(50),
    distribution_channel VARCHAR(50),
    is_repeated_guest INT,
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type VARCHAR(5),
    assigned_room_type VARCHAR(5),
    booking_changes INT,
    deposit_type VARCHAR(50),
    agent VARCHAR(10),
    company VARCHAR(10),
    days_in_waiting_list INT,
    customer_type VARCHAR(50),
    adr FLOAT,
    required_car_parking_spaces INT,
    total_of_special_requests INT,
    reservation_status VARCHAR(20),
    reservation_status_date DATE
);


-- STEP 2: Import Data
-- Note: Update file path to match your local directory
COPY hotel_bookings
FROM 'E:\archive\hotel_bookings.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


-- STEP 3: Verify Import
SELECT COUNT(*) FROM hotel_bookings;
-- Expected: 119,390 rows


-- STEP 4: Explore Data
SELECT * FROM hotel_bookings LIMIT 10;


-- STEP 5: Check Null Values
SELECT 
    COUNT(*) FILTER (WHERE children = 'NA') AS children_na,
    COUNT(*) FILTER (WHERE agent = 'NULL') AS agent_null,
    COUNT(*) FILTER (WHERE company = 'NULL') AS company_null,
    COUNT(*) FILTER (WHERE country IS NULL) AS country_null
FROM hotel_bookings;


-- STEP 6: Fix NA values in children column
UPDATE hotel_bookings 
SET children = NULL 
WHERE children = 'NA';

-- STEP 7: Fix missing country values
UPDATE hotel_bookings
SET country = 'Unknown'
WHERE country IS NULL;


-- STEP 8: Convert columns to correct data types
ALTER TABLE hotel_bookings
ALTER COLUMN children TYPE FLOAT
USING children::FLOAT;

ALTER TABLE hotel_bookings
ALTER COLUMN agent TYPE FLOAT
USING agent::FLOAT;

ALTER TABLE hotel_bookings
ALTER COLUMN company TYPE FLOAT
USING company::FLOAT;


-- STEP 9: Verify data types
SELECT 
    pg_typeof(children),
    pg_typeof(agent),
    pg_typeof(company)
FROM hotel_bookings
LIMIT 1;
-- Expected: double precision for all three


-- STEP 10: Add Primary Key
ALTER TABLE hotel_bookings 
ADD COLUMN booking_id SERIAL PRIMARY KEY;