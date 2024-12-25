WITH RECURSIVE Hours AS (
    SELECT 0 AS HOUR
    UNION ALL
    SELECT HOUR + 1
    FROM Hours
    WHERE HOUR < 23
)
SELECT
    h.HOUR,
    COALESCE(d.COUNT, 0) AS COUNT
FROM
    Hours h
LEFT JOIN (
    SELECT
        EXTRACT(HOUR FROM DATETIME) AS HOUR,
        COUNT(*) AS COUNT
    FROM
        ANIMAL_OUTS
    GROUP BY
        EXTRACT(HOUR FROM DATETIME)
) d ON h.HOUR = d.HOUR
ORDER BY
    h.HOUR;