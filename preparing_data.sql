SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM covid_1..CovidDeaths
ORDER BY 1,2

--The denominator being 0 was causing issues in the scaling operations.
UPDATE covid_1..CovidDeaths
SET total_deaths = NULL
WHERE total_deaths=0

UPDATE covid_1..CovidDeaths
SET total_cases = NULL
WHERE total_cases = 0


UPDATE covid_1..CovidDeaths
SET new_cases = NULL
WHERE total_cases = 0

UPDATE covid_1..CovidDeaths
SET new_deaths = NULL
WHERE new_deaths = 0


