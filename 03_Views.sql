-- ================================================
-- Hotel Booking Cancellation & Revenue Analysis
-- File 3: Views 
-- ================================================


CREATE VIEW v_cancellation_summary AS
SELECT 
    booking_id,
    hotel,
    market_segment,
    distribution_channel,
    country,
    deposit_type,
    customer_type,
    is_canceled,
    lead_time,
    arrival_date_year,
    arrival_date_month,
    CASE 
        WHEN arrival_date_month = 'January' THEN 1
        WHEN arrival_date_month = 'February' THEN 2
        WHEN arrival_date_month = 'March' THEN 3
        WHEN arrival_date_month = 'April' THEN 4
        WHEN arrival_date_month = 'May' THEN 5
        WHEN arrival_date_month = 'June' THEN 6
        WHEN arrival_date_month = 'July' THEN 7
        WHEN arrival_date_month = 'August' THEN 8
        WHEN arrival_date_month = 'September' THEN 9
        WHEN arrival_date_month = 'October' THEN 10
        WHEN arrival_date_month = 'November' THEN 11
        WHEN arrival_date_month = 'December' THEN 12
    END AS month_number
FROM hotel_bookings;

CREATE VIEW v_revenue_trends AS
SELECT 
    booking_id,
    hotel,
    arrival_date_year,
    arrival_date_month,
    CASE 
        WHEN arrival_date_month = 'January' THEN 1
        WHEN arrival_date_month = 'February' THEN 2
        WHEN arrival_date_month = 'March' THEN 3
        WHEN arrival_date_month = 'April' THEN 4
        WHEN arrival_date_month = 'May' THEN 5
        WHEN arrival_date_month = 'June' THEN 6
        WHEN arrival_date_month = 'July' THEN 7
        WHEN arrival_date_month = 'August' THEN 8
        WHEN arrival_date_month = 'September' THEN 9
        WHEN arrival_date_month = 'October' THEN 10
        WHEN arrival_date_month = 'November' THEN 11
        WHEN arrival_date_month = 'December' THEN 12
    END AS month_number,
    stays_in_weekend_nights,
    stays_in_week_nights,
    adr,
    is_canceled,
    (stays_in_weekend_nights + stays_in_week_nights) * adr AS total_revenue
FROM hotel_bookings
WHERE is_canceled = 0
AND adr > 0;

CREATE OR REPLACE VIEW v_guest_behaviour AS
SELECT 
    booking_id,
    hotel,
    is_repeated_guest,
    previous_cancellations,
    lead_time,
    total_of_special_requests,
    customer_type,
    meal,
    is_canceled,
    arrival_date_year,
    arrival_date_month
FROM hotel_bookings;

CREATE VIEW v_risk_scores AS
SELECT 
    booking_id,
    hotel,
    is_canceled,
    lead_time,
    deposit_type,
    distribution_channel,
    previous_cancellations,
    CASE WHEN previous_cancellations > 0 THEN 3 ELSE 0 END +
    CASE WHEN lead_time > 90 THEN 2 
         WHEN lead_time > 30 THEN 1 
         ELSE 0 END +
    CASE WHEN deposit_type = 'Non Refund' THEN 3
         WHEN deposit_type = 'No Deposit' THEN 1
         ELSE 0 END +
    CASE WHEN distribution_channel = 'TA/TO' THEN 2 ELSE 0 END
    AS risk_score,
    CASE 
        WHEN (
            CASE WHEN previous_cancellations > 0 THEN 3 ELSE 0 END +
            CASE WHEN lead_time > 90 THEN 2 
                 WHEN lead_time > 30 THEN 1 
                 ELSE 0 END +
            CASE WHEN deposit_type = 'Non Refund' THEN 3
                 WHEN deposit_type = 'No Deposit' THEN 1
                 ELSE 0 END +
            CASE WHEN distribution_channel = 'TA/TO' THEN 2 ELSE 0 END
        ) >= 6 THEN 'High Risk'
        WHEN (
            CASE WHEN previous_cancellations > 0 THEN 3 ELSE 0 END +
            CASE WHEN lead_time > 90 THEN 2 
                 WHEN lead_time > 30 THEN 1 
                 ELSE 0 END +
            CASE WHEN deposit_type = 'Non Refund' THEN 3
                 WHEN deposit_type = 'No Deposit' THEN 1
                 ELSE 0 END +
            CASE WHEN distribution_channel = 'TA/TO' THEN 2 ELSE 0 END
        ) >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM hotel_bookings;

CREATE VIEW v_adr_trends AS
SELECT 
    booking_id,
    hotel,
    arrival_date_year,
    arrival_date_month,
    market_segment,
    distribution_channel,
    reserved_room_type,
    assigned_room_type,
    adr,
    is_canceled
FROM hotel_bookings
WHERE adr > 0;