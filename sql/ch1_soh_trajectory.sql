-- ============================================================
-- Chapter 1: SOH Trajectory per Cell
-- Uses: CTEs, window functions (AVG, LAG), CASE
-- Question: How does State of Health evolve across cycles?
-- ============================================================

WITH smoothed AS (
    SELECT
        cell_id,
        cycle_number,
        soh_pct,
        -- 5-cycle rolling average to smooth measurement noise
        AVG(soh_pct) OVER (
            PARTITION BY cell_id
            ORDER BY cycle_number
            ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
        ) AS soh_rolling_avg,
        -- Cycle-over-cycle SOH change
        LAG(soh_pct, 1) OVER (
            PARTITION BY cell_id ORDER BY cycle_number
        ) AS prev_soh
    FROM cycles
),
tagged AS (
    SELECT *,
        soh_pct - prev_soh                        AS soh_delta,
        CASE WHEN soh_pct < 80 THEN 1 ELSE 0 END AS below_eol
    FROM smoothed
),
eol_cycle AS (
    SELECT cell_id, MIN(cycle_number) AS eol_cycle
    FROM tagged
    WHERE below_eol = 1
    GROUP BY cell_id
)
SELECT
    t.cell_id,
    t.cycle_number,
    t.soh_pct,
    t.soh_rolling_avg,
    t.soh_delta,
    t.below_eol,
    e.eol_cycle
FROM tagged t
LEFT JOIN eol_cycle e USING (cell_id)
ORDER BY t.cell_id, t.cycle_number;
