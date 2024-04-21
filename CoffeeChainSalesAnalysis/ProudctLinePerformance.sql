SELECT
    Product_line,
    SUM(Sales) AS TotalSales
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    Product_line;
