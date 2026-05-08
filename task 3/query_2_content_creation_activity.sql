-- QUERY 2: Content Creation Activity
--
-- Purpose:
-- Measure the number of submitted gamesessions that successfully generated clips
--
-- Why It Matters:
-- This metric reflects:
-- - creator activity
-- - platform usage
-- - AI clipping pipeline performance
--
-- =========================================================

SELECT
    DATE_TRUNC('month', gs.submited_date) AS submission_month,

    COUNT(DISTINCT gs.id)
        AS gamesession_submitted_with_clips

FROM gamesession AS gs

JOIN clips AS c
    ON gs.id = c.gamesession_Id

WHERE gs.submited_date IS NOT NULL

GROUP BY submission_month
ORDER BY submission_month;