
select * from PortfolioProjects.dbo.Nashwil_Housing 

----- changing date format
select SaleDate,CONVERT(date,SaleDate)
from PortfolioProjects..nashwil_Housing

alter table PortfolioProjects..nashwil_Housing
add SalesDate Date;
update PortfolioProjects..nashwil_Housing
set SalesDate = CONVERT(date,SaleDate)

---populate property address data 
select propertyaddress 
from PortfolioProjects..Nashwil_Housing

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress
from PortfolioProjects..nashwil_Housing a join PortfolioProjects..nashwil_Housing b 
on a.parcelid = b.parcelid and a.uniqueid <> b.uniqueid
where a.propertyaddress is null


update a
set propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
from PortfolioProjects..nashwil_Housing a join PortfolioProjects..nashwil_Housing b 
on a.parcelid = b.parcelid and a.uniqueid <> b.uniqueid
where a.propertyaddress is null


----breaking out address into  (address,city,state)

select SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as address
from 
PortfolioProjects..nashwil_Housing


alter table PortfolioProjects..nashwil_Housing
add splitAddress nvarchar(255)  

alter table PortfolioProjects..nashwil_Housing
add splitcity nvarchar(255)

update  PortfolioProjects..nashwil_Housing 
set splitcity =SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

update PortfolioProjects..nashwil_housing
set splitaddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

select 
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from
PortfolioProjects..nashwil_Housing

alter table PortfolioProjects..nashwil_Housing
add OwnersplitAddress nvarchar(255)

alter table PortfolioProjects..nashwil_Housing
add Ownersplitcity nvarchar(255)  

alter table PortfolioProjects..nashwil_Housing
add OwnersplitState nvarchar(255) 


update PortfolioProjects..nashwil_Housing
set Ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3)


update PortfolioProjects..nashwil_Housing
set Ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2)

update PortfolioProjects..nashwil_Housing
set OwnersplitState = PARSENAME(replace(owneraddress,',','.'),1)

---changing Y , N to yes , no
select Soldasvacant, 
case when Soldasvacant = 'Y' then 'Yes' 
	when Soldasvacant = 'N' then 'No' 
	else Soldasvacant 
	end
from portfolioProjects..nashwil_Housing 

update portfolioProjects..nashwil_Housing  set Soldasvacant =
case when Soldasvacant = 'Y' then 'Yes' 
	when Soldasvacant = 'N' then 'No' 
	else Soldasvacant 
	end
---------------------------------------------------------------------------------
---------------------------remove Duplicates-------------------------------------
with temptable as (
select * , ROW_NUMBER() over (Partition by 
parcelid,
propertyaddress,
saleprice,
legalreference
order by uniqueid) row_num
from portfolioProjects..nashwil_Housing) 
 
 --delete from temptable where row_num > 1

select * from temptable where propertyaddress = '104  HURST DR, OLD HICKORY'


Alter table portfolioProjects..nashwil_Housing
drop column owneraddress,taxdistrict,propertyaddress,saledate