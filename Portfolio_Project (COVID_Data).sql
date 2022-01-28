-- Covid 19 Data Exploration
-- Skills used: Aggregate functions, Joins, and Converting Data Types


-- In this Query, i explore the data to find the following
-- Population that has gotten infected with COVID
-- deaths in Population due to COVID
-- Population that has gotten vaccinated against COVID



-- Infection Data
-- This finds the Infection count and Rate of infection per population

select *
from PortfolioProject..CovidDeaths

select continent, location, population,
MAX(total_cases) as TotalInfection,
(MAX(total_cases)/population)*100 as InfectionRate
from PortfolioProject..CovidDeaths
where continent is not null
--and continent = 'africa'
group by location, continent, population
order by 1


-- Death data
-- This finds the death count and Rate of death per population

select *
from PortfolioProject..CovidDeaths

select continent, location, population, --1 begin by selectin everything, then columns of interest
max(cast(total_deaths as int)) as TotalDeaths, --8
(max(cast(total_deaths as int))/population)*100 as DeathRate --9
from PortfolioProject..CovidDeaths --2
where continent is not null --5
--and continent = 'africa' --10
group by location, continent, population --3
order by 1 --4



-- Vaccination Data
-- This finds the vaccination count and Rate of vaccination per population

select *
from PortfolioProject..CovidDeaths as death
join PortfolioProject..CovidVaccinations as vacc
	on death.location = vacc.location
	and death.date = vacc.date


select death.continent, death.location, death.population,
max(vacc.total_vaccinations) as TotalVaccination,
(max(vacc.total_vaccinations)/death.population)*100 as VaccinationRate
from PortfolioProject..CovidDeaths as death
join PortfolioProject..CovidVaccinations as vacc
	on death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null
--and death.continent = 'africa'
group by death.location, death.continent, death.population
--order by VaccinationRate desc



-- This query finds the Total infections, Total deaths, and Total Vaccination counts for each continent

select dea.location, dea.population,
sum(dea.new_cases) as TotalCases,
sum(cast(dea.new_deaths as int)) as TotalDeaths,
sum(convert(bigint,vac.new_vaccinations)) as TotaVaccinations
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is null
--and dea.location = 'africa'
and dea.location <> 'European union'
and dea.location <> 'high income'
and dea.location <> 'International'
and dea.location <> 'Low income'
and dea.location <> 'Lower middle income'
and dea.location <> 'Upper middle income'
and dea.location <> 'World'
group by dea.location, dea.population