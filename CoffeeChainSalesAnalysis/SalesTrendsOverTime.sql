SELECT
    FORMAT(Date, 'yyyy-MM') AS Month,
    SUM(Sales) AS TotalSales
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    FORMAT(Date, 'yyyy-MM')
ORDER BY
    Month;
