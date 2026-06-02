-- ================================================
-- Hotel Booking Cancellation & Revenue Analysis
-- File 2: Business Analysis Queries
-- ================================================

-- Query 1: Overall Cancellation Rate
SELECT
ROUND((SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM hotel_bookings;

-- Query 2: Cancellation Rate by Hotel Type
SELECT
hotel,
ROUND((SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM hotel_bookings
GROUP BY hotel;

-- Query 3: Cancellation Rate by Market Segment
SELECT
market_segment,
ROUND((SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM hotel_bookings
GROUP BY market_segment
ORDER BY cancellation_rate DESC;

-- Query 4: Cancellation Rate by Deposit Type
SELECT
deposit_type,
ROUND((SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM hotel_bookings
GROUP BY deposit_type
ORDER BY cancellation_rate DESC;

-- Query 5: Cancellation Rate by Customer Type
SELECT
customer_type,
ROUND((SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM hotel_bookings
GROUP BY customer_type
ORDER BY cancellation_rate DESC;

-- Query 6: Average Lead Time by Cancellation Status
SELECT
is_canceled,
AVG(lead_time) AS average_lead_time
FROM hotel_bookings
GROUP BY is_canceled
ORDER BY average_lead_time DESC;

-- Query 7: Booking Distribution by Lead Time Bucket
SELECT
CASE
WHEN lead_time BETWEEN 0 AND 15 THEN 'Early Booking'
WHEN lead_time BETWEEN 16 AND 50 THEN 'Mid Booking'
ELSE 'Old Booking'
END AS lead_time_bucket,
COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY lead_time_bucket;

-- Query 8: Monthly Booking Volume
SELECT
arrival_date_month,
COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY arrival_date_month
ORDER BY total_bookings DESC;

-- Query 9: Country-wise Booking and Cancellation Analysis
SELECT
country,
COUNT(*) AS total_bookings,
ROUND((SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM hotel_bookings
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY total_bookings DESC;

-- Query 10: Average Daily Rate by Hotel Type
SELECT
hotel,
ROUND(CAST(AVG(adr) AS NUMERIC), 2) AS avg_adr
FROM hotel_bookings
GROUP BY hotel
ORDER BY avg_adr DESC;

-- Query 11: Average Daily Rate by Month
SELECT
arrival_date_month,
ROUND(CAST(AVG(adr) AS NUMERIC), 2) AS avg_adr
FROM hotel_bookings
GROUP BY arrival_date_month
ORDER BY avg_adr DESC;

-- Query 12: Average Daily Rate by Hotel and Month
SELECT
hotel,
arrival_date_month,
ROUND(CAST(AVG(adr) AS NUMERIC), 2) AS avg_adr
FROM hotel_bookings
GROUP BY hotel, arrival_date_month
ORDER BY hotel, avg_adr DESC;

-- Query 13: Revenue by Hotel Type
SELECT
hotel,
ROUND(
CAST(
SUM((stays_in_weekend_nights + stays_in_week_nights) * adr)
AS NUMERIC
),
2
) AS total_revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY hotel
ORDER BY total_revenue DESC;

-- Query 14: Revenue Trend by Month and Year
SELECT
arrival_date_year,
arrival_date_month,
ROUND(
CAST(
SUM((stays_in_weekend_nights + stays_in_week_nights) * adr)
AS NUMERIC
),
2
) AS total_revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year DESC;

-- Query 15: Repeated Guest Percentage
SELECT
SUM(is_repeated_guest) AS repeated_guests,
COUNT(*) AS total_bookings,
ROUND(
(CAST(SUM(is_repeated_guest) AS NUMERIC) / COUNT(*)) * 100,
2
) AS repeated_guest_percentage
FROM hotel_bookings;

-- Query 16: Cancellation Rate for Repeated Guests vs New Guests
SELECT
is_repeated_guest,
COUNT(*) AS total_bookings,
ROUND(
(CAST(SUM(is_canceled) AS NUMERIC) / COUNT(*)) * 100,
2
) AS cancellation_rate
FROM hotel_bookings
GROUP BY is_repeated_guest;

-- Query 17: Average Special Requests by Cancellation Status
SELECT
is_canceled,
ROUND(CAST(AVG(total_of_special_requests) AS NUMERIC), 2)
AS avg_special_requests,
COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY is_canceled
ORDER BY is_canceled;

-- Query 18: Cancellation Rate by Meal Type
SELECT
meal,
COUNT(*) AS total_bookings,
ROUND(
(CAST(SUM(is_canceled) AS NUMERIC) / COUNT(*)) * 100,
2
) AS cancellation_rate
FROM hotel_bookings
GROUP BY meal
ORDER BY total_bookings DESC;

-- Query 19: Impact of Room Changes on Cancellation
WITH hotel_status AS (
SELECT *,
CASE
WHEN assigned_room_type > reserved_room_type THEN 'Upgraded'
WHEN assigned_room_type < reserved_room_type THEN 'Downgraded'
ELSE 'No Change'
END AS room_change_type
FROM hotel_bookings
)

SELECT
room_change_type,
ROUND(
(CAST(SUM(is_canceled) AS NUMERIC) / COUNT(*)) * 100,
2
) AS cancellation_rate
FROM hotel_status
GROUP BY room_change_type;

-- Query 20: Cancellation Rate by Distribution Channel
SELECT
distribution_channel,
COUNT(*) AS total_bookings,
ROUND(
(CAST(SUM(is_canceled) AS NUMERIC) / COUNT(*)) * 100,
2
) AS cancellation_rate
FROM hotel_bookings
GROUP BY distribution_channel
ORDER BY cancellation_rate DESC;

-- Query 21: Previous Cancellation History vs Current Cancellation Rate
WITH prev_cancel AS (
SELECT *,
CASE
WHEN previous_cancellations = 0 THEN 'No Previous Cancellation'
WHEN previous_cancellations = 1 THEN '1 Previous Cancellation'
WHEN previous_cancellations = 2 THEN '2 Previous Cancellation'
WHEN previous_cancellations BETWEEN 3 AND 10 THEN '3-10 Previous Cancellations'
ELSE '>10 Previous Cancellations'
END AS prev_cancel_status
FROM hotel_bookings
)

SELECT
prev_cancel_status,
ROUND(
(CAST(SUM(is_canceled) AS NUMERIC) / COUNT(*)) * 100,
2
) AS cancellation_rate
FROM prev_cancel
GROUP BY prev_cancel_status
ORDER BY cancellation_rate DESC;

-- Query 22: Booking Risk Score Segmentation
WITH risk_score AS (
SELECT *,
CASE WHEN previous_cancellations > 0 THEN 3 ELSE 0 END +
CASE
WHEN lead_time > 90 THEN 2
WHEN lead_time > 30 THEN 1
ELSE 0
END +
CASE
WHEN deposit_type = 'Non Refund' THEN 3
WHEN deposit_type = 'No Deposit' THEN 1
ELSE 0
END +
CASE
WHEN distribution_channel = 'TA/TO' THEN 2
ELSE 0
END AS risk_score
FROM hotel_bookings
)

SELECT
CASE
WHEN risk_score >= 6 THEN 'High Risk'
WHEN risk_score >= 3 THEN 'Medium Risk'
ELSE 'Low Risk'
END AS risk_category,
COUNT(*) AS total_bookings,
ROUND(
(CAST(SUM(is_canceled) AS NUMERIC) / COUNT(*)) * 100,
2
) AS cancellation_rate
FROM risk_score
GROUP BY risk_category
ORDER BY cancellation_rate DESC;
