-- 1. Total number of crimes per area
SELECT 
    a.AreaCode        AS [Area Code],
    a.AreaName        AS [Area Name],
    SUM(f.CrimeCount) AS TotalCrimes
FROM FactCrimeSummary f
JOIN DimArea a ON f.AreaKey = a.AreaKey
GROUP BY
    a.AreaCode,
    a.AreaName
ORDER BY
    TotalCrimes DESC;


-- 2. Most frequent crime types
SELECT 
    ct.CrimeCode      AS [Crime Code],
    ct.CrimeCodeDescription  AS [Crime Description],
    SUM(f.CrimeCount) AS Occurrences
FROM FactCrimeSummary f
JOIN DimCrimeType ct ON f.CrimeTypeKey = ct.CrimeKey
GROUP BY
    ct.CrimeCode,
    ct.CrimeCodeDescription
ORDER BY
    Occurrences DESC;

-- 3. Most used weapon types
SELECT 
    w.WeaponUsedCode      AS [Weapon Code],
    w.WeaponDescription      AS [Weapon Description],
    SUM(f.CrimeCount) AS TimesUsed
FROM FactCrimeSummary f
JOIN DimWeapon w ON f.WeaponKey = w.WeaponKey
GROUP BY
    w.WeaponUsedCode,
    w.WeaponDescription
ORDER BY
    TimesUsed DESC;

-- 4. Average victim age per crime type
SELECT 
    ct.CrimeCode      AS [Crime Code],
    ct.CrimeCodeDescription  AS [Crime Description],
    SUM(f.SumVictimAge) * 1.0 / NULLIF(SUM(f.VictimCount),0) AS [Avg Victim Age]
FROM FactVictimAnalysis f
JOIN DimCrimeType ct ON f.CrimeTypeKey = ct.CrimeKey
GROUP BY
    ct.CrimeCode,
    ct.CrimeCodeDescription
ORDER BY
    [Avg Victim Age] DESC;

-- 5. Crime distribution by time of day
SELECT 
    t.TimeLabel       AS [Time of Day],
    SUM(f.CrimeCount) AS TotalCrimes
FROM FactCrimeTime f
JOIN DimTime t ON f.TimeKey = t.TimeKey
GROUP BY
    t.TimeLabel
ORDER BY
    t.TimeLabel;


-- 6. Ratio of status cases
WITH StatusTotals AS (
  SELECT
    s.StatusDescription     AS [Status],
    SUM(f.CaseCount) AS CountPerStatus
  FROM FactCaseStatus f
  JOIN DimStatus s ON f.StatusKey = s.StatusKey
  GROUP BY
    s.StatusDescription
)
SELECT
  st.Status,
  st.CountPerStatus,
  st.CountPerStatus * 1.0 / SUM(st.CountPerStatus) OVER() AS [Ratio]
FROM StatusTotals st;