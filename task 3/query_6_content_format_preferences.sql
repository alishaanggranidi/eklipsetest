-- QUERY 6: Content Format Preferences
--
-- Purpose:
-- Analyze the distribution of clip formats generated across the Eklipse platform
--
-- Why It Matters:
-- This metric helps identify:
-- - creator content preferences
-- - product feature adoption
-- - dominant content creation behavior
--
-- Understanding clip type popularity helps Eklipse prioritize features and optimize creator workflows
--
-- =========================================================

SELECT
    CASE
        WHEN c.clip_type_id = 1 THEN 'AI Highlight'
        WHEN c.clip_type_id = 2 THEN 'TikTok Conversion'
        WHEN c.clip_type_id = 3 THEN 'Trimmed Clip'
        WHEN c.clip_type_id = 5 THEN 'Eventful Highlight'
        WHEN c.clip_type_id = 6 THEN 'Weekly Montage'
        WHEN c.clip_type_id = 7 THEN 'Local Upload'
        WHEN c.clip_type_id = 8 THEN 'YouTube Vertical'
        ELSE 'Unknown'
    END AS clip_type,

    COUNT(DISTINCT c.id)
        AS total_clips

FROM clips c

JOIN gamesession gs
    ON c.gamesession_Id = gs.id

GROUP BY clip_type
ORDER BY total_clips DESC;