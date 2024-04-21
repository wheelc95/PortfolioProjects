SELECT
    Marketing,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    Marketing;
