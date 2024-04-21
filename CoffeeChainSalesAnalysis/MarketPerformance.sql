SELECT
    State,
    SUM(Sales) AS TotalSales,
    AVG(Margin) AS AverageMargin
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    State;
