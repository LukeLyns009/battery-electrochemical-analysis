-- ============================================================
-- Chapter 3: RUL Feature Engineering
-- Uses: CTEs, window functions (AVG, SUM, LAG), JOIN
-- Question: Build a feature matrix with RUL as the target
--           variable for predictive modelling.
-- ============================================================

WITH eol AS (
    -- Step 1: Find the End-of-Life cycle for each cell
    --         (first cycle where SOH drops below 80%)
    SELECT cell_id, MIN(cycle_number) AS eol_cycle
    FROM cycles
    WHERE soh_pct < 80
    GROUP BY cell_id
),
features AS (
    -- Step 2: Engineer predictive features using window functions
    SELECT
        c.cell_id,
        c.cycle_number,
        c.capacity_Ah,
        c.internal_resistance_Ohm,
        c.charge_time_min,
        c.discharge_time_min,
        c.temperature_C,
        c.soh_pct,
        e.eol_cycle,

        -- RUL target: cycles remaining until EOL
        (e.eol_cycle - c.cycle_number)                  AS rul_cycles,

        -- 5-cycle rolling mean capacity (smoothed signal)
        AVG(c.capacity_Ah) OVER (
            PARTITION BY c.cell_id ORDER BY c.cycle_number
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        )                                                AS cap_rolling_mean_5,

        -- 5-cycle rolling mean resistance
        AVG(c.internal_resistance_Ohm) OVER (
            PARTITION BY c.cell_id ORDER BY c.cycle_number
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        )                                                AS res_rolling_mean_5,

        -- Cumulative capacity throughput (total energy delivered)
        SUM(c.capacity_Ah) OVER (
            PARTITION BY c.cell_id ORDER BY c.cycle_number
        )                                                AS cumulative_cap_Ah,

        -- Cycle-on-cycle resistance change (rate of aging)
        c.internal_resistance_Ohm - LAG(c.internal_resistance_Ohm, 1) OVER (
            PARTITION BY c.cell_id ORDER BY c.cycle_number
        )                                                AS resistance_delta

    FROM cycles c
    JOIN eol e USING (cell_id)
    WHERE c.cycle_number <= e.eol_cycle
)
SELECT *
FROM features
WHERE rul_cycles >= 0
ORDER BY cell_id, cycle_number;
