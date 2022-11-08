--Select data that we are going to be using 

--Select Location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths 
--order by 1,2

--Looking at Total Cases vs Total Deaths (Percentage of deaths per cases)
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentagePer_cases
From PortfolioProject..CovidDeaths 
where location like '%greece%'
order by 1,2

--Percent of getting covid 
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulatoinInfected
From PortfolioProject..CovidDeaths 
order by 5

--looking at countrys with highest infection rates compared to population
Select Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths 
Group by Location, population
order by PercentPopulationInfected desc

--LETS BREAK THINGS DOWN BY CONTINENT  


--Showing countrys with highest death count per population 
Select Location, max(cast(total_deaths as int)) as Total_death_count
From PortfolioProject..CovidDeaths 
where continent is not null
group by location
order by Total_death_count desc

--LETS BREAK THINGS DOWN BY CONTINENT  

Select LOCATION, max(cast(total_deaths as int)) as Total_death_count
From PortfolioProject..CovidDeaths 
where continent is null
group by LOCATION
order by Total_death_count desc

--showing continents with the highest death count per population

Select CONTINENT, max(cast(total_deaths as int)) as Total_death_count
From PortfolioProject..CovidDeaths 
where continent is NOT null
group by CONTINENT
order by Total_death_count desc

--GLOBAL NUMBERS

--We use the cast,as int on new deaths cause it is writen as (nvarchar)

Select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/Sum(new_cases)*100  as Death_percentagePer_cases
From PortfolioProject..CovidDeaths 
--where location like '%greece%'
where continent is not null
Group by date --important to group by date 
order by 1

--Sum of Vaccinated ppl per location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (partition by dea.Location) as SumVaccinatesPerLocation
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE check on YT

--Temp table
--The drop meaning is even if you create a table you can change it whenever you WANT 
DROP Table if exists #PercentPopulationVaccinated 
Create Table #SumVaccinatesPerLocation
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
SumVaccinatesPerLocation numeric
)

Insert into #SumVaccinatesPerLocation
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (partition by dea.Location) as SumVaccinatesPerLocation
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *
From #SumVaccinatesPerLocation

--Creating view to store data for later visualizations

Create view  SumVaccinatesPerLocation as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (partition by dea.Location) as SumVaccinatesPerLocation
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
From SumVaccinatesPerLocation

 





 
  



