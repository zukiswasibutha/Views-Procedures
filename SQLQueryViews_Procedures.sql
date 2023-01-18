

-- To completely delete the view in order to re-create it
Drop View If Exists VaccinStatics;
GO

--Creating a View from the VaccinStats Table
Create View VaccinStatics
As
Select Location,Population,HighestVaccinated,TotalVaccinated
From CoviData.dbo.VaccinStats
GO

-- To execute the view in order to view all the data contained in it
Select *
from VaccinStatics

GO
-- in order to re-create a table
Drop Table If Exists HospDeathPerc;
GO

-- Creating a Table in order to create a view since I'm working with the Excel data
Create Table HospDeathPerc
(Location varchar(255) not null,
Population int not null,
NewCases int,
DeathCases int)
GO

-- Adding a column I missed when creating the table
Alter Table HospDeathPerc
Add Percentage float ;
GO

--Inserting data from the two Excel tables
Insert INTO HospDeathPerc
Select cv.Location,c.Population, cv.NewCases,sum(c.DeathCases) as NewDeathSum, (Sum(c.DeathCases)/(c.Population))*100 as Percentage
From CoviData.dbo.CoviVaccinations cv
Join CoviData.dbo.CoviDeaths c
On cv.Location = c.Location
Where cv.Location Like '%Hosp%' and c.DeathCases is not null
Group By cv.Location,cv.NewCases, c.Population;
GO


-- running my statement in order to view the Table data
Select *
From HospDeathPerc;
GO

--Creating a View of the Death percentage from the HospDeathPerc table
Create View HospPerc
As
Select *
From HospDeathPerc;
GO
--Executing the View to view data contained in it
Select *
from HospPerc;
GO


Drop Procedure If Exists Statis;
Go


--Creating a Stored Procedure
Create Procedure VaccinsSts
As
Select *
From VaccinStats
Go


--Exceuting the VaccinSts Procedure
Exec VaccinsSts;
GO

--Creating a Stored Procedure
Create Procedure Statis
(@newcase int)
As
Select *
From HospDeathPerc
Where NewCases = @newcase;
Go

-- Executing a parameterised Stored Procedure
Exec Statis
@newcase = 5;
Go

-- Executing a parameterised Stored Procedure
Exec Statis
@newcase = 17;