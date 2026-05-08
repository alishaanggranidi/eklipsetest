-- QUERY 4: Social Distribution Dynamics
--
-- Purpose:
-- Measure the number of clips shared by creators
--
-- Why It Matters:
-- Shared clips indicate:
-- - creator engagement
-- - social distribution behavior
-- - platform virality potential
--
-- Increased sharing activity may help Eklipse gain more organic exposure through social platforms
--
-- =========================================================

SELECT
    DATE_TRUNC('month', sc.created_at) AS shared_month,

    COUNT(DISTINCT sc.clip_id)
        AS total_shared_clips

FROM shared_clips AS sc

JOIN clips AS c
    ON sc.clip_id = c.id

WHERE sc.created_at IS NOT NULL

GROUP BY shared_month
ORDER BY shared_month;