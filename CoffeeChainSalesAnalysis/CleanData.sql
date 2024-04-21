-- Trim whitespace from column names and data
UPDATE [Coffee_Chain_Sales ]
SET
    Market_size = TRIM(Market_size),
    Market = TRIM(Market),
    Product_line = TRIM(Product_line),
    Product = TRIM(Product),
    Type = TRIM(Type),
    State = TRIM(State);

-- Correct date formats (assuming the dates are stored as strings)
UPDATE [Coffee_Chain_Sales ]
SET
    Date = CAST(Date AS DATE); -- Ensure the date format matches the database requirement

-- Standardize text fields to ensure consistency
UPDATE [Coffee_Chain_Sales ]
SET
    Market_size = CASE WHEN Market_size = 'Major Market' THEN 'Major' ELSE Market_size END;

-- Check and handle missing values
-- Example for handling missing values by setting them to a default or calculated value
UPDATE [Coffee_Chain_Sales ]
SET
    Marketing = COALESCE(Marketing, 0); -- Setting missing marketing expenses to 0

-- View Results
SELECT *
FROM [Coffee_Chain_Sales ]

