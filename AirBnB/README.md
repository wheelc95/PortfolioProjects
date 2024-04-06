# Airbnb Data Analysis

## Overview
This repository contains SQL queries and analysis scripts for cleaning and analyzing Airbnb market and amenities data. The data is structured in CSV format and is related to Airbnb listings and their associated amenities for the year 2019. The analysis includes exploring various aspects such as geographical patterns, property types, amenities, demand, and pricing.

## Repository Structure
- `DataExploration/queries.sql`: This file contains SQL queries for cleaning the original CSV data, transforming it, and performing various analyses.
- `README.md`: You are currently reading it! This file provides an overview of the repository contents, instructions for running the SQL queries, and any other relevant information.
- `AirBnBRawData/`: This directory contains the original CSV files used in the analysis.

## Running the Queries
To run the SQL queries in this repository, you will need access to a SQL database management system such as MySQL, PostgreSQL, or SQL Server. Follow these steps:
1. Download or clone this repository to your local machine.
2. Import the CSV files in the `AirBnBRawData/` directory into your SQL database.
3. Open `queries.sql` and execute the queries against your database.

## Analysis Highlights
- **Data Cleaning**: The SQL queries perform data cleaning tasks such as altering table structures, splitting columns, handling null values, and removing duplicates.
- **Summary Statistics**: Various summary statistics are calculated, including averages, medians, modes, standard deviations, minimum and maximum values, and quartiles.
- **Data Exploration**: Geographical analysis, property type analysis, amenities analysis, and demand and pricing analysis are conducted to gain insights into the Airbnb market.

## Acknowledgements
- The data used in this analysis is sourced from [Kaggle](https://www.kaggle.com/).
- This project is for educational purposes
