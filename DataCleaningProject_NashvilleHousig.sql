SELECT * FROM PortfolioProject.dbo.Housing;

-- STANDARDIZE DATE FORMAT

SELECT SaleDate, CONVERT(date, SaleDate ) FROM PortfolioProject..Housing



ALTER TABLE PortfolioProject..Housing
ADD SalesDateConverted Date

UPDATE PortfolioProject..Housing
SET SalesDateConverted = CONVERT(date, SaleDate);

SELECT * FROM PortfolioProject.dbo.Housing
WHERE PropertyAddress IS NULL

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..Housing A JOIN PortfolioProject..Housing B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..Housing A JOIN PortfolioProject..Housing B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

SELECT * FROM PortfolioProject.dbo.Housing
WHERE PropertyAddress IS NULL -- leaves no more result, every entry now has PropertyAddress

-- SPLITTING ADDREESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress FROM PortfolioProject..Housing

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject..Housing

ALTER TABLE PortfolioProject..Housing
ADD PropertySplitAddress NVARCHAR(255), PropertySplitCity NVARCHAR(255)


UPDATE PortfolioProject..Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1), 
PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


SELECT * FROM PortfolioProject..Housing

--ALTERNATE APPROACH USING PARSENAME

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.Housing

ALTER TABLE PortfolioProject..Housing
Add OwnerSplitAddress Nvarchar(255), OwnerSplitCity Nvarchar(255), OwnerSplitState Nvarchar(255)

Update PortfolioProject..Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.Housing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..Housing
Group by SoldAsVacant
order by 2

-- THERE IS COMBINATION OF Y,N,YES,NO WHICH WE WILL CORRECT


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..Housing


Update PortfolioProject..Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


---- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.Housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--PERFORM DELETE OPERATION IN ATHE RESULTSET


-- Delete Unused Columns



Select *
From PortfolioProject.dbo.Housing


ALTER TABLE PortfolioProject.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


