SELECT
    Type,
    Market_size,
    SUM(Sales) AS TotalSales
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    Type, Market_size;

