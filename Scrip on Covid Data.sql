SELECT
	* 
FROM
	coviddeathsnew;
	
SELECT*
FROM covidvasinationsnew
ORDER BY 3,4;

-- Total Cases vs Total Deaths
-- Shows likelihood of Dying if you contract covid in you Country
SELECT Location, date,total_Cases, total_deaths,(Total_deaths/Total_Cases)*100 as DeathPrecentage
FROM coviddeathsnew
Where location like '%Ghana%';
-- ORDER BY 1,2;

-- Looking at the total cases vs the population
-- Shows What percentage of the population got covid
SELECT Location, date, total_Cases, Population,(Total_Cases/Population)*100 as PercentagePopulationInfected
FROM coviddeathsnew
Where location like '%Nigeria%';
-- ORDER BY 1,2;

-- Looking at countries with higest infection rate compared to population
SELECT Location, Population, max(total_cases) as HigestInfectionCount, max((Total_Cases/Population))*100 as PercentagePopulationInfected
FROM coviddeathsnew
GROUP BY Location, Population
ORDER BY PercentagePopulationInfected desc;

-- Showing the country with the higest death count per population
SELECT Location, max(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeathsnew
GROUP BY Location, Population
ORDER BY TotalDeathCount desc;

SELECT sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, 
sum(cast(new_deaths as int))/sum(neW_cases)*100 as DeathPercentage
FROM coviddeathsnew
;

-- Joinning coviddeathsnew to covidvasinationsnew
SELECT * 
FROM coviddeathsnew as dea
JOIN covidvasinationsnew as vac
ON dea.location = vac.location 
AND dea.date = vac.date;

-- Looking at total population vs vaccinations
SELECT dea.Location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (PARTITION by dea.location ORDER BY dea.location, 
dea.date) as RollingPeopleVaccinated
FROM coviddeathsnew as dea
JOIN covidvasinationsnew as vac
ON dea.location = vac.location 
AND dea.date = vac.date;

-- use CTE
WITH popvsvac (location, date, population, new_vaccinations, RollingpeopleVaccinated)
as (

SELECT dea.Location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (PARTITION by dea.location ORDER BY dea.location, 
dea.date) as RollingPeopleVaccinated
FROM coviddeathsnew as dea
JOIN covidvasinationsnew as vac
ON dea.location = vac.location 
AND dea.date = vac.date
)

SELECT *, (Rollingpeoplevaccinated/population)*100
FROM popvsvac;


-- Alternative option is TEMP table
drop table if exists PercentagePopulationVaccinated;
CREATE TABLE PercentagePopulationVaccinated(
Location nvarchar(255),
Date datetime,
Population NUMERIC,
new_vaccinations NUMERIC,
Rollingpeoplevaccinated NUMERIC);

INSERT INTO PercentagePopulationVaccinated
SELECT dea.Location, dea.date, dea.Population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (PARTITION by dea.location ORDER BY dea.location, 
dea.date) as RollingPeopleVaccinated
FROM coviddeathsnew as dea
JOIN covidvasinationsnew as vac
ON dea.location = vac.location 
AND dea.date = vac.date;

SELECT* , (Rollingpeoplevaccinated/population)*100
FROM PercentagePopulationVaccinated;

-- creating view to store data for later visualizations
CREATE VIEW  MyView as
SELECT dea.Location, dea.date, dea.Population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (PARTITION by dea.location ORDER BY dea.location, 
dea.date) as RollingPeopleVaccinated
FROM coviddeathsnew as dea
JOIN covidvasinationsnew as vac
ON dea.location = vac.location 
AND dea.date = vac.date;

SELECT*
FROM myview





