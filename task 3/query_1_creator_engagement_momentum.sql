-- QUERY 1: Creator Engagement Momentum
--
-- Purpose:
-- Measure Monthly Active Users across the Eklipse platform
--
-- Why It Matters:
-- This metric helps evaluate overall creator engagement and platform activity growth over time
--
-- A user is considered active if they:
-- - submit a gamesession
-- - generate clips
-- - download clips
-- - share clips
--
-- =========================================================

SELECT
    DATE_TRUNC('month', activity.activity_date) AS month,
    COUNT(DISTINCT activity.user_id) AS monthly_active_users

FROM (

    SELECT
        user_id,
        submited_date AS activity_date
    FROM gamesession
    WHERE submited_date IS NOT NULL

    UNION ALL

    SELECT
        user_id,
        created_at AS activity_date
    FROM clips
    WHERE created_at IS NOT NULL

    UNION ALL

    SELECT
        user_Id AS user_id,
        created_at AS activity_date
    FROM downloaded_clips
    WHERE created_at IS NOT NULL

    UNION ALL

    SELECT
        user_id,
        created_at AS activity_date
    FROM shared_clips
    WHERE created_at IS NOT NULL

) AS activity

GROUP BY month
ORDER BY month;