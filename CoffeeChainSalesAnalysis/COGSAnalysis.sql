SELECT
    Market,
    AVG(Cogs) AS AverageCOGS,
    AVG(Target_cogs) AS TargetCOGS
FROM
    [Coffee_Chain_Sales ]
GROUP BY
    Market;
