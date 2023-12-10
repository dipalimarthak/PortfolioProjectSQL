--DATASET URL https://ourworldindata.org/covid-deaths
--put the 'population' column at the very beginning in order to avoid joins initially during the project and keep it simple at the beginning
--i removed all columns starting AA (total_tests) and this will be our first table 'CovidDeaths'

--now delete everything from population(E) to weekly_hosp_admissions_per_million(Z) and save it as second table 'CovidVaccinations'
--before you import data, be sure to reformat the date to yyyy-mm-dd so that MySql recognizes the date as an actual date. To do this, highlight the column and press control+1, 
--go to date and select the format

--install Microsoft Access Database Engine 2010 Redistributable from https://www.microsoft.com/en-us/download/details.aspx?id=13255

--use excel as the import type and destination server as Microsoft OLE DB Provider for SQL Server

SELECT * FROM PortfolioProject..CovidDeaths 
ORDER BY 3,4 

SELECT * FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--LOOKING AT TOTAL CASES VS TOTAL DEATHS (IN PERCENTAGE)
--SHOWS THE LOKELIHOOD OF DEATH IF YOU CONTRACT COVID IN YOUR COUNTRY
SELECT location, date, total_cases, total_deaths, CAST(total_deaths AS float)/CAST(total_cases AS float) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE  location = 'Germany'
ORDER BY 1,2


-- WHAT PERCENTAGE OF POPULATION GOT COVID
-- TOTAL CASES vs population

SELECT location, date,  population,total_cases, CAST(total_cases AS float)/CAST(population AS float) * 100 AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
WHERE  location = 'Germany'
ORDER BY 1,2

--- FINDING WHICH COUNTRY HAS HIGHEST INFECTION RATE AS COMPARED TO THE POPULATION
SELECT location,  population
,MAX(total_cases) AS HighestInfectionCount, 
MAX(CAST(total_cases as float)/population)* 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- FINDING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location,  MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
--, MAX(CAST(total_cases as float)/population)* 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location
ORDER BY TotalDeathCount DESC



-- HERE IN THIS DATA THERE ARE FEW DETAILS WHICH ARE NOT REALLY EXPECTED SUCH AS World/Continent Name, so we use the 'continent' field
SELECT location,  MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- GROUPING THE SAME RESULT BASED ON CONTINENTS
SELECT continent,  MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--SECOND APPROACH (PROBLEM - 3 UNNECESSARY GROUPS BASED ON INCOME, TRY ADDING FILTER COLUMN WHERE continent NOT LIKE '%OWID%')
SELECT location,  MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null AND 
GROUP BY location
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS

--- BASED ON DATE ACROSS CONTINENT
SELECT location,  MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- SUM OF CASES BASED ON DATE ACROSS

SELECT date,  SUM(CAST(new_cases AS FLOAT)) AS TotalCases
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY date
ORDER BY TotalCases DESC


SELECT date,  SUM(CAST(new_deaths AS FLOAT)) AS NewDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY date
ORDER BY NewDeaths DESC

--- DEATH PERCENTAGE ACROSS THE WORLD

SELECT date,  SUM(CAST(new_cases AS FLOAT)) AS TotalCases,
SUM(CAST(new_deaths AS FLOAT)) AS TotalDeaths,
SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS int)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY date DESC

SET ANSI_WARNINGS OFF;
SELECT date,  SUM(CAST(new_cases AS FLOAT)) AS TotalCases,
SUM(CAST(new_deaths AS FLOAT)) AS TotalDeaths,
SUM(CAST(new_deaths AS FLOAT) ) / SUM(CAST(new_cases AS float) ) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
GROUP BY date
ORDER BY date DESC

SET ANSI_WARNINGS OFF;
SELECT date,  SUM(CONVERT(FLOAT,new_cases)) AS TotalCases,
SUM(CONVERT(FLOAT, new_deaths)) AS TotalDeaths,
SUM(CONVERT(FLOAT, new_deaths)) /  NULLIF(SUM(CONVERT(FLOAT,new_cases)),0) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY date DESC
--WHY IS IT GIVING Divide by zero error encountered.? i WILL CHECK THE SOLUTION LATER
--USED NULLIF(PARAM,0)

SET ANSI_WARNINGS OFF;
SELECT SUM(CONVERT(FLOAT,new_cases)) AS TotalCases,
SUM(CONVERT(FLOAT,new_deaths)) AS TotalDeaths,
SUM(CONVERT(FLOAT, new_deaths) ) / SUM(CONVERT(FLOAT,new_cases) ) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is  null

--JOINING BOTH COVIDVACCINATION AND COVIDDEATHS TABLES

SELECT DEA.continent,  DEA.location, DEA.date, DEA.population, VAC.new_vaccinations FROM PortfolioProject..CovidVaccinations AS VAC
JOIN PortfolioProject..CovidDeaths AS DEA
ON DEA.location=VAC.location
AND DEA.date=VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 1,2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations
DROP VIEW PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;



SELECT * FROM PercentPopulationVaccinated