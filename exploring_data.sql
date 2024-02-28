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
SELECT dea.continent, dea.location, dea.date, dea.population, 
	vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as float)) OVER (Partition BY dea.Location)
FROM covid_1..CovidDeaths as dea
JOIN covid_1..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY dea.location,dea.date

