-- QUERY 3: Creator Value Realization
--
-- Purpose:
-- Measure the percentage of generated clips that are downloaded by creators
--
-- Why It Matters:
-- Download behavior reflects:
-- - creator satisfaction
-- - perceived clip quality
-- - usefulness of generated content
--
-- A higher download rate suggests that creators find the generated clips valuable enough to save
--
-- =========================================================

SELECT
    DATE_TRUNC('month', c.created_at) AS month,

    COUNT(DISTINCT c.id)
        AS generated_clips,

    COUNT(DISTINCT dc.clip_id)
        AS downloaded_clips,

    ROUND(
        COUNT(DISTINCT dc.clip_id) * 100.0
        / COUNT(DISTINCT c.id),
        2
    ) AS download_rate_percentage

FROM clips c

LEFT JOIN downloaded_clips dc
    ON c.id = dc.clip_id

GROUP BY month
ORDER BY month;