# SQL Data Cleaning 

A SQL project that demonstrates various data cleaning operations on a Nashville Housing dataset.

## Project Overview
This project showcases different SQL techniques to clean and standardize real estate data, including:
- Date standardization
- Handling missing values
- Breaking down address fields
- Removing duplicates
- Column management

## Cleaning Operations

### 1. Date Standardization
- Converts sale dates to a consistent format
- Creates a new standardized date column

### 2. Address Data Cleaning
- Populates missing property addresses
- Breaks down addresses into individual components (Address, City, State)
- Uses string manipulation functions for address parsing

### 3. Duplicate Management
- Identifies duplicate records using ROW_NUMBER() function
- Removes duplicates while preserving the original entry
- Uses Common Table Expressions (CTE) for duplicate detection

### 4. Column Organization
- Removes unused columns
- Restructures data for better organization

## Technologies Used
- SQL Server
- T-SQL functions
- Common Table Expressions (CTE)
- JOIN operations
- String manipulation functions

## Database Requirements
- SQL Server
- Database with appropriate permissions for:
  - Table alterations
  - Data updates
  - Column additions/deletions
