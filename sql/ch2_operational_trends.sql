-- ============================================================
-- Chapter 2: Charge & Discharge Trends by Life Bucket
-- Uses: CASE bucketing, GROUP BY aggregation
-- Question: How do charge conditions shift as the cell ages?
-- ============================================================

WITH bucketed AS (
    SELECT *,
        CASE
            WHEN cycle_number <= 40  THEN 'Early (1-40)'
            WHEN cycle_number <= 80  THEN 'Mid-Early (41-80)'
            WHEN cycle_number <= 120 THEN 'Mid-Late (81-120)'
            ELSE                          'Late (121+)'
        END AS life_bucket
    FROM cycles
)
SELECT
    cell_id,
    life_bucket,
    ROUND(AVG(charge_time_min), 2)    AS avg_charge_min,
    ROUND(AVG(discharge_time_min), 2) AS avg_discharge_min,
    ROUND(AVG(capacity_Ah), 4)        AS avg_capacity_Ah,
    ROUND(AVG(temperature_C), 2)      AS avg_temp_C,
    COUNT(*)                           AS n_cycles
FROM bucketed
GROUP BY cell_id, life_bucket
ORDER BY cell_id,
    CASE life_bucket
        WHEN 'Early (1-40)'      THEN 1
        WHEN 'Mid-Early (41-80)' THEN 2
        WHEN 'Mid-Late (81-120)' THEN 3
        ELSE 4
    END;
