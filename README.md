# Hotel Booking Cancellation & Revenue Analysis

An end-to-end data analytics project analysing 119,390 real hotel bookings using **PostgreSQL** and **Power BI** to identify revenue leakage from cancellations and build a cancellation risk scoring model.

---

## Dashboard Overview

![Executive Summary](images/page1_executive_summary.png)

---

## Problem Statement

Hotel cancellations are one of the biggest sources of revenue leakage in the hospitality industry. A booking that cancels at the last minute leaves a room unsold, blocks potential resales, and disrupts revenue forecasting.

This project analyses booking patterns across two hotels — a City Hotel and a Resort Hotel — to answer:
- What is driving the 37% overall cancellation rate?
- Which segments, channels, and guest types carry the highest risk?
- How much revenue is at risk from high-cancellation bookings?
- Can we score each booking by cancellation risk before it happens?

---

## Dataset

**Source:** [Hotel Booking Demand Dataset](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand)

Originally published in the research paper:
> Antonio, N., de Almeida, A., & Nunes, L. (2019). Hotel booking demand datasets. *Data in Brief*, 22, 41–49.

| Property | Value |
|----------|-------|
| Total Records | 119,390 |
| Hotels | City Hotel, Resort Hotel |
| Location | Portugal |
| Period | 2015 – 2017 |
| Key Columns | hotel, is_canceled, lead_time, adr, market_segment, distribution_channel, deposit_type, country, previous_cancellations |

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| PostgreSQL 16 | Database, data cleaning, SQL analysis |
| pgAdmin 4 | SQL query editor |
| Power BI Desktop | Dashboard and visualisation |

---

## Project Structure

```
hotel-booking-analysis/
│
├── data/
│   └── hotel_bookings.csv
│
├── sql/
│   ├── 01_table_setup.sql
│   ├── 02_business_queries.sql
│   └── 03_views.sql
│
├── powerbi/
│   └── hotel_booking_analysis.pbix
│
├── images/
│   ├── page1_executive_summary.png
│   ├── page2_cancellation_deep_dive.png
│   ├── page3_revenue_analysis.png
│   ├── page4_guest_behaviour.png
│   └── page5_risk_dashboard.png
│
└── README.md
```

---

## SQL Analysis — 20 Business Queries

Queries are organised into 5 themes:

### 1. Cancellation Analysis
| Query | Key Finding |
|-------|-------------|
| Overall cancellation rate | 37.04% of all bookings cancelled |
| By hotel type | City Hotel 41.7% vs Resort Hotel 27.8% |
| By market segment | Groups 61%, Online TA 36.7% highest risk |
| By deposit type | Non-refundable bookings cancel at 99% — phantom booking problem |
| By customer type | Transient guests cancel at 40.5% |
| By distribution channel | TA/TO 41% vs Direct 17.5% |

### 2. Lead Time Analysis
| Query | Key Finding |
|-------|-------------|
| Avg lead time — canceled vs completed | 144 days vs 79 days |
| Cancellation rate by lead time bucket | Higher lead time = higher cancellation risk |

### 3. Revenue Analysis
| Query | Key Finding |
|-------|-------------|
| Total revenue by hotel | City Hotel $14.4M, Resort Hotel $11.6M |
| Monthly revenue trends | August peak, January lowest — 2x difference in ADR |
| ADR by hotel and month | August ADR double January ADR |

### 4. Guest Behaviour
| Query | Key Finding |
|-------|-------------|
| Repeat guest rate | Only 3.19% of guests are repeat visitors |
| Repeat vs new guest cancellation | Repeat: 14.5%, New: 37.8% |
| Special requests vs cancellation | Cancelled bookings average 0.33 requests vs 0.71 for completed stays |
| Waiting list impact | Waiting list bookings cancel at 63.8% — stale demand effect |
| Previous cancellations | Guests with 1 prior cancellation cancel at 94.4% |

### 5. Risk Scoring Model
Combined 4 risk factors into a weighted scoring model:

| Factor | Weight |
|--------|--------|
| Previous cancellations > 0 | +3 points |
| Lead time > 90 days | +2 points |
| Lead time > 30 days | +1 point |
| Deposit type = Non Refund | +3 points |
| Distribution channel = TA/TO | +2 points |

| Risk Category | Score | Bookings | Cancellation Rate |
|--------------|-------|----------|-------------------|
| High Risk | ≥ 6 | 15,665 | 99.26% |
| Medium Risk | 3–5 | 87,737 | 30.18% |
| Low Risk | < 3 | 15,988 | 13.72% |

**High Risk bookings represent approximately $2.6M in revenue at risk.**

---

## Power BI Dashboard — 5 Pages

### Page 1 — Executive Summary
![Executive Summary](images/page1_executive_summary.png)

KPI cards, cancellation rate by hotel type, market segment, distribution channel, and monthly booking trend.

---

### Page 2 — Cancellation Deep Dive
![Cancellation Deep Dive](images/page2_cancellation_deep_dive.png)

Cancellation by deposit type, geographic map by country, lead time distribution.

---

### Page 3 — Revenue Analysis
![Revenue Analysis](images/page3_revenue_analysis.png)

Monthly revenue trend by year, revenue comparison by hotel type.

---

### Page 4 — Guest Behaviour
![Guest Behaviour](images/page4_guest_behaviour.png)

Repeat vs new guest cancellation rate, special requests vs cancellation rate.

---

### Page 5 — Risk Dashboard
![Risk Dashboard](images/page5_risk_dashboard.png)

Booking volume by risk category, cancellation rate by risk level, revenue at risk callout.

---

## Key Business Insights

1. **City Hotel cancellation crisis** — 41.7% cancellation rate driven by volatile corporate and event bookings. Resort Hotel at 27.8% due to committed leisure travelers.

2. **OTA dependency problem** — 82% of bookings come through TA/TO channel at 41% cancellation rate. Direct bookings cancel at only 17.5%. Every 1% shift to direct reduces cancellations and saves OTA commission.

3. **Phantom booking problem** — Non-refundable bookings cancel at 99%, blocking room resales at potentially higher last-minute rates. Revenue opportunity cost, not just policy violation.

4. **Early booking risk** — Cancelled bookings averaged 144 days lead time vs 79 days for completed stays. Hotels should apply stricter cancellation policies for bookings made 90+ days in advance.

5. **Loyalty gap** — Only 3.19% repeat guest rate vs industry benchmark of 15–25%. Repeat guests cancel at 14.5% vs 37.8% for new guests. Every 1% improvement in retention directly reduces overall cancellation rate.

6. **Previous cancellation history is the strongest predictor** — Guests with 1 prior cancellation cancel again at 94.4%. This single feature drives the risk scoring model.

---

## How to Run

### PostgreSQL Setup
1. Install PostgreSQL 16 and pgAdmin 4
2. Create a new database
3. Run `sql/01_table_setup.sql` — creates table and imports data
4. Update the file path in the COPY command to match your local directory
5. Run `sql/02_business_queries.sql` — executes all 20 analysis queries
6. Run `sql/03_views.sql` — creates 5 views for Power BI

### Power BI Setup
1. Open `powerbi/hotel_booking_analysis.pbix`
2. Go to Transform Data → Data Source Settings
3. Update PostgreSQL connection to your localhost credentials
4. Refresh data

---

## Author

**Anupam Chauhan**
Data Analyst | IIT Kharagpur M.Tech

[LinkedIn](https://www.linkedin.com/in/anupam-iit-kgp) | [GitHub](https://github.com/an-up-am) | [Portfolio](https://www.datascienceportfol.io/anupamchauhan)
