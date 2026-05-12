-- fact_bookings
SELECT *
FROM fact_bookings;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'fact_bookings';

ALTER TABLE fact_bookings
ALTER COLUMN booking_id TYPE TEXT,
ALTER COLUMN property_id TYPE INT USING property_id::INT,
ALTER COLUMN booking_date TYPE DATE USING booking_date::DATE,
ALTER COLUMN check_in_date TYPE DATE USING check_in_date::DATE,
ALTER COLUMN checkout_date TYPE DATE USING checkout_date::DATE,
ALTER COLUMN no_guests TYPE INT USING no_guests::INT,
ALTER COLUMN room_category TYPE TEXT,
ALTER COLUMN ratings_given TYPE INT USING ratings_given::INT,
ALTER COLUMN revenue_generated TYPE REAL USING revenue_generated::REAL,
ALTER COLUMN revenue_realized TYPE REAL USING revenue_realized::REAL;


---fact_aggregated_bookings
SELECT *
FROM fact_aggregated_bookings
LIMIT 5;


SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'fact_aggregated_bookings';

ALTER TABLE fact_aggregated_bookings
ALTER COLUMN property_id TYPE INT USING property_id::INT,
ALTER COLUMN check_in_date TYPE DATE USING check_in_date::DATE,
ALTER COLUMN room_category TYPE TEXT,
ALTER COLUMN successful_bookings TYPE INT USING successful_bookings::INT,
ALTER COLUMN capacity TYPE INT USING capacity::INT,
ALTER COLUMN occ_rate TYPE REAL USING occ_rate::REAL;

--dim_date
SELECT *
FROM dim_date;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'dim_date';

ALTER TABLE dim_date
ALTER COLUMN date TYPE DATE USING date::DATE,
--ALTER COLUMN "week no" TYPE INT USING "week no"::INT,
ALTER COLUMN "week no" TYPE INT USING REPLACE("week no", 'W ', '')::INT,
ALTER COLUMN day_type TYPE TEXT USING day_type::TEXT;
--because it create conflict
ALTER TABLE dim_date
DROP COLUMN "mmm yy";
--why this because of april date are missing in dataset it conflict while make relations B/W Fact_book to dim_date
INSERT INTO dim_date (date, "week no", day_type)
SELECT 
    datum AS date,
    TO_CHAR(datum, 'IW')::INT AS week_no,
    CASE 
        WHEN EXTRACT(DOW FROM datum) IN (0, 6) THEN 'weekend' 
        ELSE 'weekeday' 
    END AS day_type
FROM generate_series(
    '2022-01-01'::date, 
    '2022-12-31'::date, 
    '1 day'::interval
) AS datum
ON CONFLICT (date) DO NOTHING;

---dim_hotels
SELECT *
FROM dim_hotels
LIMIT 5;


SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'dim_hotels';

ALTER TABLE dim_hotels
ALTER COLUMN property_id TYPE INT USING property_id::INT;

---dim_rooms
SELECT *
FROM dim_rooms
LIMIT 5;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'dim_rooms';

---make relations useing PK & FK
--primary key
--DIM HOTELS
ALTER TABLE dim_hotels
ADD CONSTRAINT pk_dim_hotels
PRIMARY KEY (property_id);

--DIM ROOMS
ALTER TABLE dim_rooms
ADD CONSTRAINT pk_dim_rooms
PRIMARY KEY (room_id);

--DIM DATE
ALTER TABLE dim_date
ADD CONSTRAINT pk_dim_date
PRIMARY KEY (date);

--FACT BOOKINGS
ALTER TABLE fact_bookings
ADD CONSTRAINT pk_fact_bookings
PRIMARY KEY (booking_id);

--FACT AGGREGATED BOOKINGS-Composite PK:
ALTER TABLE fact_aggregated_bookings
ADD CONSTRAINT pk_fact_aggregated
PRIMARY KEY (
    property_id,
    check_in_date,
    room_category
);

--FORIEGN keys
--FACT BOOKINGS
ALTER TABLE fact_bookings
  ADD CONSTRAINT fk_fact_bookings_hotels 
      FOREIGN KEY (property_id) REFERENCES dim_hotels(property_id),
  ADD CONSTRAINT fk_fact_bookings_rooms 
      FOREIGN KEY (room_category) REFERENCES dim_rooms(room_id),
  ADD CONSTRAINT fk_fact_bookings_booking_date 
      FOREIGN KEY (booking_date) REFERENCES dim_date(date),
  ADD CONSTRAINT fk_fact_bookings_checkin 
      FOREIGN KEY (check_in_date) REFERENCES dim_date(date),
  ADD CONSTRAINT fk_fact_bookings_checkout 
      FOREIGN KEY (checkout_date) REFERENCES dim_date(date);
--FACT AGG BOOKINGS
ALTER TABLE fact_aggregated_bookings
  ADD CONSTRAINT fk_factagg_hotels 
      FOREIGN KEY (property_id) REFERENCES dim_hotels(property_id),
  ADD CONSTRAINT fk_factagg_rooms 
      FOREIGN KEY (room_category) REFERENCES dim_rooms(room_id),
  ADD CONSTRAINT fk_factagg_date 
      FOREIGN KEY (check_in_date) REFERENCES dim_date(date);

-- verfy eg query
SELECT 
    h.city, 
    SUM(f.revenue_generated) as total_revenue
FROM fact_bookings f
JOIN dim_hotels h ON f.property_id = h.property_id
GROUP BY h.city;