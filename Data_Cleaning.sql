/*
Cleaning Data in SQL Queries
*/

-- Display all records from NashvilleHousing table for initial inspection

Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- Convert SaleDate to a standardized Date format for all records

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

-- Update SaleDate column with standardized Date format

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If the above update doesn't work, add a new column and populate it with the standardized Date format

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

-- Display all records from NashvilleHousing table, ordered by ParcelID

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

-- Join NashvilleHousing table with itself to find and populate missing PropertyAddress values

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Update records with missing PropertyAddress values using ISNULL to fill in the blanks

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- Display all PropertyAddress values from NashvilleHousing table

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

-- Split PropertyAddress into Address, City, and State

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

-- Add new columns for Address, City, and State to NashvilleHousing table

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Address nvarchar(255), City nvarchar(255), State nvarchar(255);

-- Update NashvilleHousing table to populate Address, City, and State columns by parsing PropertyAddress

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ),
    City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) - CHARINDEX(',', PropertyAddress) - 1),
    State = SUBSTRING(PropertyAddress, LEN(PropertyAddress) - CHARINDEX(' ', REVERSE(PropertyAddress)) + 2, CHARINDEX(' ', REVERSE(PropertyAddress)) - 1)

--------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates

-- Use CTE to identify duplicate records based on ParcelID and SaleDate, keeping the first occurrence

WITH RowNumCTE AS
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, SaleDate ORDER BY UniqueID) AS row_num
    FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- Delete duplicate records identified by the CTE

DELETE FROM PortfolioProject.dbo.NashvilleHousing
WHERE UniqueID IN (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);

--------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

-- Display all records from NashvilleHousing table for inspection before column deletion

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- Remove unnecessary columns from NashvilleHousing table

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

--------------------------------------------------------------------------------------------------------------------------
