use covidproject;
select * from covidproject.coviddeath
where continent is not null
order by 3,4;

select continent,location, date,total_cases,new_cases,total_deaths, population
from covidproject.coviddeath
order by 2,3;

/*total deaths against the total cases reported of covid in africa*/

	select continent,location,date,total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100
	as deathpercentage
	from covidproject.coviddeath
	where CONTINENT = 'africa'
	and continent is not null
	order by 1,2;

/*likelihood of getting infected with covid in Africa*/
	select continent,location,date,total_cases,population,(total_cases/population)*100
	as infectedPercentage
	from covidproject.coviddeath
	where CONTINENT = 'africa'
	and continent is not null
	order by 2;

select location,POPULATION,date, max(Total_cases) as HighestInfectionCount,
max(total_cases/population)*100
as infectedPopulationPercent
from covidproject.coviddeath
where CONTINENT = 'africa'
GROUP BY location,population,date
order by InfectedPopulationPercent desc;

/*covid death count in Africa  against the rest of the world*/
	Select location, sum(new_deaths) as TotalDeathCount
	from covidproject.coviddeath
	where CONTINENT = 'africa'
	group by location
	order by TotalDeathCount desc;

Select  continent,
sum(new_deaths) as TotalDeathCount
from covidproject.coviddeath
where continent is not null
group by continent
order by TotalDeathCount desc;

/*covid death rate in Africa  against the rest of the world*/

	select continent, SUM(new_deaths) AS TotalDeathCount,
	sum(total_deaths)/sum(total_cases)as deathrate
	from covidproject.coviddeath
	where CONTINENT is not null
	group by continent
	order by deathrate;

select date, SUM(new_cases)as totalCases,sum(new_deaths)as TotalDeaths,
sum(new_deaths)/ sum(new_cases)*100 as deathPercentage
from covidproject.coviddeath
where continent = 'Africa'
group by date
order by 1,2 ;

	select SUM(new_cases)as totalCases,sum(new_deaths)as TotalDeaths,
	sum(new_deaths)/ sum(new_cases)*100 as deathPercentage
	from covidproject.coviddeath
	where continent is not null
	#group by date
	order by 1,2;

/* TOTAL VACCINATION IN THE WORLD*/
	Select * 
	From Covidproject.coviddeath as COD
	join Covidproject.covidvaccination as COV
	ON COD.location=COV.location
	and COD.date=COV.date;

Select COD.continent,COD.Location,COD.date,COD.population,COV.new_vaccinations
From Covidproject.coviddeath as COD
join Covidproject.covidvaccination as COV
ON COD.location=COV.location
and COD.date=COV.date
where COD.continent is not null
order by 2,3;

/* TOTAL POPULATION VS TOTAL VACCINATIONS IN AFRICA*/
#USE CTE

With POPvsVAC (continent, location,date,population,new_vaccination,RollingPeopleVaccinated)
AS 
(Select COD.CONTINENT,COD.Location,COD.date,COD.population,
COV.new_vaccinations,
sum(new_vaccinations)over(Partition by COD.location order by cod.location,cod.date)
as RollingPeopleVaccinated
#(ROLLINGPEOPLEVACCINATED/Population)*100
From Covidproject.coviddeath as COD
join Covidproject.covidvaccination as COV
ON COD.location=COV.location
and COD.date=COV.date
where COD.continent = 'africa'
and COD.continent is not null
#order by 2,3) 
)

SELECT*
,(ROLLINGPEOPLEVACCINATED/Population)*100
AS PercentageVaccinated
FROM POPvsVAC


