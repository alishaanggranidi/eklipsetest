-- QUERY 5: Monetization Expansion
--
-- Purpose:
-- Measure monthly premium subscription growth
--
-- Why It Matters:
-- This metric helps evaluate:
-- - monetization performance
-- - premium adoption growth
-- - willingness of creators to pay
--
-- Increasing premium subscriptions suggest stronger perceived platform value
--
-- =========================================================

SELECT
    DATE_TRUNC('month', p.starts_at)
        AS premium_start_month,

    COUNT(DISTINCT p.user_id)
        AS new_premium_users

FROM premium AS p

JOIN gamesession AS gs
    ON p.user_id = gs.user_id

WHERE p.starts_at IS NOT NULL

GROUP BY premium_start_month
ORDER BY premium_start_month;