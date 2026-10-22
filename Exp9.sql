CREATE TABLE RailwayBooking (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    PassengerName VARCHAR(60),
    TrainNo INT,
    JourneyDate DATE,
    SourceStation VARCHAR(40),
    DestinationStation VARCHAR(40),
    SeatNo INT,
    Fare DECIMAL(10,2),
    BookingStatus VARCHAR(20)
);
SET SESSION cte_max_recursion_depth = 5000;

INSERT INTO RailwayBooking
(PassengerName, TrainNo, JourneyDate, SourceStation,
 DestinationStation, SeatNo, Fare, BookingStatus)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 5000
)
SELECT
    CONCAT('Passenger', n),
    12000 + MOD(n, 20),
    DATE_ADD('2026-01-01', INTERVAL MOD(n, 365) DAY),
    CASE MOD(n, 4)
        WHEN 0 THEN 'Lucknow'
        WHEN 1 THEN 'Delhi'
        WHEN 2 THEN 'Mumbai'
        ELSE 'Jaipur'
    END,
    CASE MOD(n, 3)
        WHEN 0 THEN 'Delhi'
        WHEN 1 THEN 'Kanpur'
        ELSE 'Patna'
    END,
    n,
    300 + MOD(n, 2000),
    CASE MOD(n, 3)
        WHEN 0 THEN 'Confirmed'
        WHEN 1 THEN 'Waiting'
        ELSE 'Cancelled'
    END
FROM numbers;
SELECT COUNT(*) AS TotalBookings
FROM RailwayBooking;

EXPLAIN
SELECT *
FROM RailwayBooking
WHERE TrainNo = 12005
AND JourneyDate = '2026-03-01';
CREATE INDEX idx_train
ON RailwayBooking(TrainNo);

CREATE INDEX idx_journey_date
ON RailwayBooking(JourneyDate);

CREATE INDEX idx_train_date
ON RailwayBooking(TrainNo, JourneyDate);

ANALYZE TABLE RailwayBooking;
EXPLAIN
SELECT *
FROM RailwayBooking
WHERE TrainNo = 12005
AND JourneyDate = '2026-03-01';

SELECT *
FROM RailwayBooking
WHERE TrainNo = 12005
AND JourneyDate = '2026-03-01';