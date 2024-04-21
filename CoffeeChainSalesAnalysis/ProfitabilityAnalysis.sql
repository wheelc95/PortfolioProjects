SELECT
    Product,
    SUM(Profit) AS ActualProfit,
    SUM(Target_profit) AS TargetProfit
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    Product;
