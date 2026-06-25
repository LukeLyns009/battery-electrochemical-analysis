-- ============================================================
-- Chapter 1: Internal Resistance by Cell × Life Stage
-- Uses: NTILE() to split each cell's life into 5 equal stages
-- Question: How does resistance accumulate across a cell's life?
-- ============================================================

WITH quintiles AS (
    SELECT *,
        NTILE(5) OVER (
            PARTITION BY cell_id ORDER BY cycle_number
        ) AS life_quintile
    FROM cycles
)
SELECT
    cell_id,
    life_quintile,
    CASE life_quintile
        WHEN 1 THEN 'Early (0-20%)'
        WHEN 2 THEN 'Growth (20-40%)'
        WHEN 3 THEN 'Mid (40-60%)'
        WHEN 4 THEN 'Late (60-80%)'
        WHEN 5 THEN 'End (80-100%)'
    END                                                  AS life_stage,
    ROUND(AVG(internal_resistance_Ohm) * 1000, 2)       AS avg_resistance_mOhm,
    ROUND(AVG(capacity_Ah), 4)                           AS avg_capacity_Ah,
    ROUND(AVG(soh_pct), 2)                               AS avg_soh_pct,
    COUNT(*)                                             AS n_cycles
FROM quintiles
GROUP BY cell_id, life_quintile
ORDER BY cell_id, life_quintile;
