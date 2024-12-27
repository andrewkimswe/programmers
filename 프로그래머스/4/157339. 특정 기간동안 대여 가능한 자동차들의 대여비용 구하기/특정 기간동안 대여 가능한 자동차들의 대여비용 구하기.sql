WITH AVAILABLE_CARS AS (
    SELECT
        C.CAR_ID,
        C.CAR_TYPE,
        C.DAILY_FEE,
        COALESCE(MAX(H.END_DATE), '1900-01-01') AS LAST_RENTAL_END
    FROM
        CAR_RENTAL_COMPANY_CAR C
    LEFT JOIN
        CAR_RENTAL_COMPANY_RENTAL_HISTORY H
        ON C.CAR_ID = H.CAR_ID
    WHERE
        C.CAR_TYPE IN ('세단', 'SUV')
    GROUP BY
        C.CAR_ID, C.CAR_TYPE, C.DAILY_FEE
    HAVING
        LAST_RENTAL_END < '2022-11-01'
),
DISCOUNTED_FEES AS (
    SELECT
        A.CAR_ID,
        A.CAR_TYPE,
        A.DAILY_FEE,
        ROUND(A.DAILY_FEE * 30 * (1 - DP.DISCOUNT_RATE / 100.0)) AS FEE
    FROM
        AVAILABLE_CARS A
    JOIN
        CAR_RENTAL_COMPANY_DISCOUNT_PLAN DP
        ON A.CAR_TYPE = DP.CAR_TYPE AND DP.DURATION_TYPE = '30일 이상'
    WHERE
        ROUND(A.DAILY_FEE * 30 * (1 - DP.DISCOUNT_RATE / 100.0)) BETWEEN 500000 AND 2000000
)
SELECT
    DF.CAR_ID,
    DF.CAR_TYPE,
    DF.FEE
FROM
    DISCOUNTED_FEES DF
ORDER BY
    DF.FEE DESC,
    DF.CAR_TYPE ASC,
    DF.CAR_ID DESC;