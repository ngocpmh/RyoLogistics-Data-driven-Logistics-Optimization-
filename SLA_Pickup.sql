



CREATE VIEW PICKUP_SLA AS
WITH CTE_pickup_deadline AS (
    SELECT 
        *,
        CASE 
            WHEN TRY_CAST(creation_datetime AS TIME) < '16:00:00' THEN CAST(TRY_CAST(creation_datetime AS DATE) AS DATE)
            ELSE DATEADD(DAY, 1, CAST(TRY_CAST(creation_datetime AS DATE) AS DATE))
        END AS tentative_pickup_deadline
    FROM [dbo].['CleanOM (3)$']
),
CTE_adjusted_deadline AS (
    SELECT 
        p.*,
        DATEADD(SECOND, -1, DATEADD(DAY, 1, c.date)) AS sla_pickup
    FROM 
        CTE_pickup_deadline p
    CROSS APPLY (
        SELECT TOP 1 date 
        FROM [dbo].[ryo_calendar$]
        WHERE date >= p.tentative_pickup_deadline AND working_day = 1 
        ORDER BY date
    ) c
)
SELECT 
    a.*,
    CASE 
        WHEN CAST(a.pickup_datetime AS DATE) <= CAST(a.sla_pickup AS DATE) THEN 1
        ELSE 0
    END AS pickup_ontime
FROM 
    CTE_adjusted_deadline a;


-----------
SELECT order_id,
	cod_value_sgd,
	shipper_id,
	order_type,
	delivery_type,
	pickup_hub_id,
	pickup_attempts,
	created_month,
	creation_datetime, 
	pickup_datetime,
	sla_pickup,
	pickup_ontime,
	to_city,
	parcel_size
FROM PICKUP_SLA