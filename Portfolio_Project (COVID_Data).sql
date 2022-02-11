-- Covid 19 Data Exploration
-- Skills used: Aggregate functions, Joins, and Converting Data Types


-- In this Query, i explore the data to find the following
-- Number of covid tests carried out
-- Population that has gotten infected with COVID
-- deaths in Population due to COVID
-- Population that has gotten vaccinated against COVID
-- Top 20 countries with (1) Infection count (2) Death Count (3) Vaccination count



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

select continent, location, population,
max(cast(total_deaths as int)) as TotalDeaths,
(max(cast(total_deaths as int))/population)*100 as DeathRate
from PortfolioProject..CovidDeaths
where continent is not null
--and continent = 'africa'
group by location, continent, population
order by 1



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



-- This query finds the Total infections, Total deaths, and Total Vaccination counts across the world

select dea.continent, dea.location,
sum(convert(bigint,vax.new_tests)) as totaltests,
sum(dea.new_cases) as totalcases,
sum(cast(dea.new_deaths as bigint)) as totaldeaths,
sum(cast(vax.new_vaccinations as bigint)) as totalvaccinations
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
--and dea.continent = 'africa'
and dea.location <> 'European union'
and dea.location <> 'high income'
and dea.location <> 'International'
and dea.location <> 'Low income'
and dea.location <> 'Lower middle income'
and dea.location <> 'Upper middle income'
and dea.location <> 'World'
group by dea.continent, dea.location



-- This query finds the top 20 countries with infection cases

select top 20 dea.continent, dea.location,
sum(dea.new_cases) as totalcases
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
--and dea.continent = 'africa'
and dea.location <> 'European union'
and dea.location <> 'high income'
and dea.location <> 'International'
and dea.location <> 'Low income'
and dea.location <> 'Lower middle income'
and dea.location <> 'Upper middle income'
and dea.location <> 'World'
group by dea.continent, dea.location
order by 3 desc

-- This query finds the top 20 countries with Death Counts

select top 20 dea.continent, dea.location,
sum(cast(dea.new_deaths as bigint)) as totaldeaths
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
--and dea.continent = 'africa'
and dea.location <> 'European union'
and dea.location <> 'high income'
and dea.location <> 'International'
and dea.location <> 'Low income'
and dea.location <> 'Lower middle income'
and dea.location <> 'Upper middle income'
and dea.location <> 'World'
group by dea.continent, dea.location
order by 3 desc


-- This query finds the top 20 countries with Vaccination counts

select top 20 dea.continent, dea.location,
sum(cast(vax.new_vaccinations as bigint)) as totalvaccinations
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
--and dea.continent = 'africa'
and dea.location <> 'European union'
and dea.location <> 'high income'
and dea.location <> 'International'
and dea.location <> 'Low income'
and dea.location <> 'Lower middle income'
and dea.location <> 'Upper middle income'
and dea.location <> 'World'
group by dea.continent, dea.location
order by 3 desc
