select location,date,total_cases,new_cases,total_deaths,population
from  PortfolioProjects..['owid-covid-data$'] order by 1,2

--total cases vs total deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as 'Death Percentage'
from  PortfolioProjects..['owid-covid-data$']  where location like '%states%'
order by 1,2

--countries with heighest infection rate compared to population

select location,population,max(total_cases) as heighest_infection_count, max((total_cases/population))*100 as
'PercentagePopulationInfected'
from  PortfolioProjects..['owid-covid-data$']   --where location like '%states%'
group by population,location
order by PercentagePopulationInfected desc

--countries with heighest deaths per population


select location,max(cast(total_deaths as int)) as TotalDeathCount
from  PortfolioProjects..['owid-covid-data$']   where continent is not null
group by location
order by TotalDeathCount desc

--breakdown by continent

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from  PortfolioProjects..['owid-covid-data$']   where continent is not null
group by continent
order by TotalDeathCount desc

--global numbers

select date, sum(total_cases) as 'Total Cases',sum(cast(new_deaths as int)) as 'Total Deaths',
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
 from PortfolioProjects..['owid-covid-data$']
 where continent is not null
 group by date
 order by 1,2

 --total population vs vaccination 

 with popvsvac (location,date,population,new_vaccinations,pplvaccinated)
 as (
 select cd.location,cd.date,cd.population,cd.new_vaccinations , 
 sum(cast(cd.new_vaccinations as bigint)) over (partition by cd.location order by cd.location) as pplvaccinated
 from  PortfolioProjects..['Covid-Vaccination$'] cv join PortfolioProjects..['owid-covid-data$'] cd
 on cv.location = cd.location and cv.date = cd.date
 where cd.continent is not null --and  cd.location ='canada'
  --order by 1,2
  )

  select * , (pplvaccinated/population) * 100
  from popvsvac

  --view

  create view popvsvac as 
   select cd.location,cd.date,cd.population,cd.new_vaccinations , 
 sum(cast(cd.new_vaccinations as bigint)) over (partition by cd.location order by cd.location) as pplvaccinated
 from  PortfolioProjects..['Covid-Vaccination$'] cv join PortfolioProjects..['owid-covid-data$'] cd
 on cv.location = cd.location and cv.date = cd.date
 where cd.continent is not null --and  cd.location ='canada'
  --order by 1,2