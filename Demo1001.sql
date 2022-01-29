-- Data Exploration
-- Skills used: Aggregate functions, Joins, and Converting Data Types
--				Aliasing, CTEs, TEMP table
-- create a new data column from existing data in 2 seperate datasets.
-- query the new column for another new column to be visualized.

-- step one
-- get data from the 2 seperate datasets
-- this will be done using JOINS
-- table names will be given aliases using the AS statement
-- aliasing table names will help shorten text

select *
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date

-- step two
-- get data from joined table to be used in the project

select dea.continent, dea.location, dea.population, vax.new_vaccinations
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date


-- step three (A)
-- create new column "allvax"
-- this will be done using the aggregate function SUM, and GROUP BY statement
-- the value type for the output will be converted from a VCHAR to an INT
-- conversion will be done using the CAST query
-- the output will be assigned a BIGINT to accomodate the output values
-- the new column will be given an ALIAS "allvax"

select dea.continent, dea.location, dea.population, 
sum(cast(vax.new_vaccinations as bigint)) as allvax
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
group by dea.continent, dea.location, dea.population


-- step three (B)
-- alternative value-type conversion
-- conversion will be done using the CONVERT statement
-- the output will be assigned a BIGINT to accomodate the output values

select dea.continent, dea.location, dea.population, 
sum(convert(bigint, new_vaccinations)) as allvax
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
group by dea.continent, dea.location, dea.population


-- step four (A)
-- a new column "vaxrate" will be created
-- this will be done using an already existing column and the newly created column "allvax"
-- first we'll create a CTE to validate the newly created column to enable us query the data successfully
-- next we'll query the CTE to create new column "vaxrate"
-- the vaxrate will be the percentage output of vaccinated population

with popvsvax (continent, location, population, allvax)
as
(
select dea.continent, dea.location, dea.population, 
sum(cast(vax.new_vaccinations as bigint)) as allvax
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
group by dea.continent, dea.location, dea.population
)
select *, (allvax/population)*100 as vaxrate
from popvsvax



-- step four (B)
-- creating an alternative to a CTE to validate newly created column
-- creating a TEMP table


create table #popvax
(
continent varchar(255),
location varchar(255),
population numeric,
allvax numeric
)
insert into popvax
select dea.continent, dea.location, dea.population, 
sum(cast(vax.new_vaccinations as bigint)) as allvax
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vax
	on dea.location = vax.location
	and dea.date = vax.date
group by dea.continent, dea.location, dea.population

select *, (allvax/population)*100 as vaxrate
from popvax