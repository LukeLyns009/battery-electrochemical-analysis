-- ============================================================
-- Chapter 2: Capacity Distribution Bands (10-cycle bins)
-- Uses: integer division for binning, MIN/MAX/AVG aggregation
-- Question: What is the spread of capacity across all cells
--           at each stage of life?
-- ============================================================

WITH binned AS (
    SELECT *,
        (cycle_number / 10) * 10 + 5 AS cycle_bin_center
    FROM cycles
)
SELECT
    cycle_bin_center,
    ROUND(AVG(capacity_Ah), 4) AS avg_capacity_Ah,
    ROUND(MIN(capacity_Ah), 4) AS min_capacity_Ah,
    ROUND(MAX(capacity_Ah), 4) AS max_capacity_Ah,
    COUNT(*)                    AS n_cycles
FROM binned
GROUP BY cycle_bin_center
ORDER BY cycle_bin_center;
