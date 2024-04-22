# Coffee Chain Sales Analysis Dashboard

This repository contains the SQL scripts and the Power BI dashboard for analyzing sales data of a coffee chain. The data was processed and cleaned using SQL, and the transformed data was used to create the visualizations in Power BI.

## Data Cleaning Process Overview

The data was cleaned using a series of SQL operations to ensure accuracy and integrity. The cleaning process involved:

- Removing duplicate entries
- Correcting data types
- Handling missing values
- Standardizing text fields
- Ensuring referential integrity

## SQL Queries for Power BI Dashboard

The following SQL queries were used to retrieve data for the Power BI dashboard visualizations:

1. **Total Sales by Year:** Aggregates sales data by year.
2. **Total Profit and Total Sales by Marketing Spend:** Calculates total profit against marketing spend.
3. **Average COGS and Target COGS by Market:** Compares average and target cost of goods sold by market.
4. **Total Sales by Product Line:** Breaks down sales by product line.
5. **Actual Profit and Target Profit by Product:** Compares actual and target profits for each product.
6. **Sum of Total Sales by Market Size and Type:** Aggregates sales by market size and type of coffee product.
7. **Total Sales and Average Margin by State:** Visualizes sales and margins by geographical location.

## Power BI Dashboard

The dashboard comprises various interactive elements:

- Line charts
- Scatter plots
- Bar charts
- Geographic maps
- Pie charts

These elements provide insights into the sales trends, profitability, and operational metrics of the coffee chain.

## Insights

- 2014 had the most sales.
- Sales are spread all across the USA.
- Spending more in marketing does not always equate to stronger sales and profit.
- The average COGs for every market was more than the target COGs.
- The major regular market accounts for most sales.
- The bean product line accounts for approximately 7% more than the leaves product line.

## Getting Started

To run these scripts and view the dashboard:

1. Clone the repository to your local machine.
2. Open SQL Server Management Studio (SSMS) and execute the SQL scripts to clean and prepare your data.
3. Load the cleaned data into Power BI.
4. Open the `.pbix` file included in the repository to access the pre-built dashboard.

