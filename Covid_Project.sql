--Total Cases vs Total Deaths
SELECT location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_1..CovidDeaths
WHERE location like 'Turkey'
ORDER BY DeathPercentage DESC


--Percentage of Population got Covid
SELECT Location, date, total_cases,population,(total_cases/population)*100 AS CasePercentage
FROM covid_1..CovidDeaths
WHERE location like '%states%'
ORDER BY CasePercentage DESC


--Countries with Highest Infection Rate Compared to Population
SELECT Location, Population, total_cases, MAX(total_cases) AS HighestInf, MAX((total_cases/population))*100 AS CasePercentage
FROM covid_1..CovidDeaths
WHERE continent is not null
GROUP BY Location, Population,total_cases
ORDER BY CasePercentage DESC

SELECT Continent, MAX(CAST(total_deaths as int)) AS TotalDEathCount
FROM covid_1..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


--GLOBAL NUMBERS
SELECT date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM covid_1..CovidDeaths
WHERE continent is not null
Group By date
ORDER BY 1,2


--TOTAL POPULATION VS VACCINATIONS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition BY dea.Location ORDER BY dea.Date, dea.Location) as RollingPeopleVaccinated --dea.Location'a göre böleriz, dea.Date'e göre sýralarýz.
FROM covid_1..CovidDeaths as dea
JOIN covid_1..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--USE CTE
WITH PopvsVac(Continent, Location, DAte, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.Location ORDER BY dea.Date, dea.Location) AS RolingPeopleVaccinated
FROM covid_1..CovidDeaths dea
JOIN covid_1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS Percentage
FROM PopvsVac
ORDER BY 2,3



--TEMP TABLE 
DROP TABLE  #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population float,
New_vaccinations float,
RollingPoepleVaccinated float
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.Location ORDER BY dea.Date, dea.Location) AS RollingPeopleVaccinated
FROM covid_1..CovidDeaths dea
JOIN covid_1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location is not null

SELECT *, (#PercentPopulationVaccinated.RollingPoepleVaccinated/#PercentPopulationVaccinated.Population)*100 AS Percentage
FROM #PercentPopulationVaccinated
ORDER BY 2,3


--Creating View to Store Data for Later Visualizations
CREATE View PercentPopulationVaccinated AS
SELECT dea.continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.Location ORDER BY dea.Date, dea.Location) AS RolingPeopleVaccinated
FROM covid_1..CovidDeaths dea
JOIN covid_1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location is not null

SELECT *
FROM PercentPopulationVaccinated
ORDER BY 2,3