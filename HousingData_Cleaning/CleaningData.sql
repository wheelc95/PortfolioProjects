-- SQL Script for cleaning Housing Data

-- Step 1: Trim whitespace from all string columns
UPDATE HousingData
SET
    ParcelID = LTRIM(RTRIM(ParcelID)),
    LandUse = LTRIM(RTRIM(LandUse)),
    PropertyAddress = LTRIM(RTRIM(PropertyAddress)),
    SaleDate = LTRIM(RTRIM(SaleDate)),
    SalePrice = REPLACE(LTRIM(RTRIM(SalePrice)), ',', ''),  -- Remove commas for conversion
    LegalReference = LTRIM(RTRIM(LegalReference)),
    SoldAsVacant = LTRIM(RTRIM(SoldAsVacant)),
    OwnerName = LTRIM(RTRIM(OwnerName)),
    OwnerAddress = LTRIM(RTRIM(OwnerAddress));

-- Step 2: Convert data types as necessary
-- Convert SalePrice to numeric
ALTER TABLE HousingData
ALTER COLUMN SalePrice INT;

-- Convert SaleDate to date format
UPDATE HousingData
SET SaleDate = TRY_CONVERT(DATE, SaleDate, 107);  -- Assuming 'Month dd, yyyy' format

-- Step 3: Handle missing values
-- Example: Setting default values for missing numeric entries
UPDATE HousingData
SET
    Bedrooms = COALESCE(Bedrooms, 0),
    FullBath = COALESCE(FullBath, 0),
    HalfBath = COALESCE(HalfBath, 0);

-- Step 4: Identify and remove duplicate rows
WITH DupRows AS (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress ORDER BY UniqueID) AS RowNum
    FROM HousingData
)
DELETE FROM DupRows WHERE RowNum > 1;

-- Check for errors or unusual data
SELECT * FROM HousingData
WHERE SalePrice <= 0 OR Bedrooms < 0 OR FullBath < 0 OR HalfBath < 0;

SELECT *
FROM HousingData
