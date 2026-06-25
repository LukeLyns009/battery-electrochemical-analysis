-- ============================================================
-- Chapter 1: Degradation Rate Ranking
-- Uses: FIRST_VALUE, LAST_VALUE, RANK() window functions
-- Question: Which cell degrades fastest (SOH loss per cycle)?
-- ============================================================

WITH endpoints AS (
    SELECT
        cell_id,
        FIRST_VALUE(soh_pct) OVER (
            PARTITION BY cell_id ORDER BY cycle_number
        ) AS soh_start,
        LAST_VALUE(soh_pct) OVER (
            PARTITION BY cell_id ORDER BY cycle_number
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS soh_end,
        MAX(cycle_number) OVER (PARTITION BY cell_id) AS max_cycle
    FROM cycles
),
dedup AS (
    SELECT DISTINCT cell_id, soh_start, soh_end, max_cycle FROM endpoints
)
SELECT
    cell_id,
    ROUND(soh_start, 2)                                 AS initial_soh_pct,
    ROUND(soh_end, 2)                                   AS final_soh_pct,
    max_cycle                                            AS cycles_tested,
    ROUND((soh_start - soh_end) / max_cycle, 4)         AS soh_loss_per_cycle,
    RANK() OVER (
        ORDER BY (soh_start - soh_end) / max_cycle DESC
    )                                                    AS degradation_rank
FROM dedup
ORDER BY degradation_rank;
