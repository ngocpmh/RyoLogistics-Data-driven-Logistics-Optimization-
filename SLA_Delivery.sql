CREATE VIEW sla_delivery AS
SELECT
    a.order_id,
    a.granular_status,
    a.dest_hub_id,
    format(a.dest_hub_datetime, 'yyyy-MM-dd, HH:mm:ss') as 'dest_hub_datetime',
    a.pickup_datetime,
    format(a.first_valid_delivery_attempt_datetime, 'yyyy-MM-dd, HH:mm:ss') as 'first_valid_delivery_attempt_datetime',
    format(b.delivery_success_datetime, 'yyyy-MM-dd, HH:mm:ss') as 'delivery_success_datetime',
    b.shipper_id,
    b.delivery_driver_id,
	b.delivery_success_hub_id,
    c.date,
    c.day,
    c.working_day,
    c.next_working_day_0,
    c.next_working_day_1,
    CASE 
        WHEN c.working_day = 1 THEN c.next_working_day_0
        WHEN c.working_day = 0 THEN c.next_working_day_1
        ELSE cast(a.dest_hub_datetime as date)
    END AS delivery_date
FROM LM_cleaned2 a
JOIN Cleaned_OM_2 b ON a.order_id = b.order_id
FULL OUTER JOIN ryo_calendar c ON cast(a.dest_hub_datetime as date) = c.date;

drop view sla_delivery

select *
from sla_delivery
where granular_status like '%complete%'

drop view new_sla_delivery

CREATE VIEW new_sla_delivery AS
SELECT
    *,
    CASE
        WHEN CAST(delivery_date AS DATE) = CAST(TRY_CONVERT(DATETIME2, SUBSTRING(dest_hub_datetime, 1, 10)) AS DATE)
             AND CAST(TRY_CONVERT(TIME, SUBSTRING(dest_hub_datetime, 12, 8)) AS TIME) < '11:00:00'
        THEN DATEDIFF(SECOND, CAST(TRY_CONVERT(TIME, SUBSTRING(dest_hub_datetime, 12, 8)) AS TIME), '23:59:59') / 3600.0
        WHEN CAST(delivery_date AS DATE) = CAST(TRY_CONVERT(DATETIME2, SUBSTRING(dest_hub_datetime, 1, 10)) AS DATE)
            AND CAST(TRY_CONVERT(TIME, SUBSTRING(dest_hub_datetime, 12, 8)) AS TIME) >= '11:00:00'
        THEN (DATEDIFF(SECOND, CAST(TRY_CONVERT(TIME, SUBSTRING(dest_hub_datetime, 12, 8)) AS TIME), '23:59:59')
              + 86400) / 3600.0 -- 86400 là số giây trong một ngày
        ELSE 23.9833 -- 23 giờ 59 phút chuyển đổi thành giờ
    END AS sla_delivery_hours
FROM sla_delivery

select order_id, granular_status, dest_hub_id,shipper_id,delivery_driver_id, dest_hub_datetime,delivery_success_datetime,delivery_date, working_day,sla_delivery_hours
from new_sla_delivery

CREATE VIEW new_sla_delivery_1 AS
SELECT
    *,
    -- Tính toán thời gian thực tế giữa dest_hub_datetime và delivery_success_datetime theo giờ
    DATEDIFF(SECOND, TRY_PARSE(dest_hub_datetime AS DATETIME USING 'en-US'), TRY_PARSE(delivery_success_datetime AS DATETIME USING 'en-US')) / 3600.0 AS actual_delivery_hours,
    -- So sánh actual_delivery_hours với sla_delivery_hours và xác định giao hàng đúng hạn hay trễ
    CASE
        WHEN DATEDIFF(SECOND, TRY_PARSE(dest_hub_datetime AS DATETIME USING 'en-US'), TRY_PARSE(delivery_success_datetime AS DATETIME USING 'en-US')) / 3600.0 <= sla_delivery_hours
        THEN 'True'
        ELSE 'False'
    END AS on_time_delivery
FROM new_sla_delivery
where granular_status like '%completed%'

select order_id, granular_status, dest_hub_id,shipper_id,delivery_driver_id, dest_hub_datetime,delivery_success_datetime,delivery_date,working_day,sla_delivery_hours,actual_delivery_hours,on_time_delivery
from new_sla_delivery_1

SELECT
	dest_hub_id,
    COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 ELSE NULL END) AS on_time_delivery_true,
    COUNT(CASE WHEN on_time_delivery = 'False' THEN 1 ELSE NULL END) AS on_time_delivery_false
FROM new_sla_delivery_1
GROUP BY dest_hub_id

SELECT
    shipper_id,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 END) AS on_time_orders,
    (COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 END) * 1.0 / COUNT(*)) * 100 AS on_time_delivery_rate
FROM
    new_sla_delivery_1
GROUP BY
    shipper_id

	SELECT
    dest_hub_id,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 END) AS on_time_orders,
    (COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 END) * 1.0 / COUNT(*)) * 100 AS on_time_delivery_rate
FROM
    new_sla_delivery_1
GROUP BY
    dest_hub_id

SELECT
    delivery_driver_id,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 END) AS on_time_orders,
    (COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 END) * 1.0 / COUNT(*)) * 100 AS on_time_delivery_rate
FROM
    new_sla_delivery_1
GROUP BY
    delivery_driver_id



SELECT
    shipper_id,
    COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 ELSE NULL END) AS on_time_delivery_true,
    COUNT(CASE WHEN on_time_delivery = 'False' THEN 1 ELSE NULL END) AS on_time_delivery_false
FROM new_sla_delivery_1
GROUP BY shipper_id

SELECT
    delivery_driver_id,
    COUNT(CASE WHEN on_time_delivery = 'True' THEN 1 ELSE NULL END) AS on_time_delivery_true,
    COUNT(CASE WHEN on_time_delivery = 'False' THEN 1 ELSE NULL END) AS on_time_delivery_false
FROM new_sla_delivery_1
GROUP BY delivery_driver_id




