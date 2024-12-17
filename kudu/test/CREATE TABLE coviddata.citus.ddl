DROP TABLE public.coviddata;
CREATE TABLE public.coviddata (
 "iso_code"  varchar (10) 
,"continent"  varchar (50)
,"location"  varchar  (60)
,"date"  timestamp
,"total_cases"  float
,"new_cases"  float
,"new_cases_smoothed"  float
,"total_deaths"  float
,"new_deaths"  float
,"new_deaths_smoothed"  float
,"total_cases_per_million"  float
,"new_cases_per_million"  float
,"new_cases_smoothed_per_million"  float
,"total_deaths_per_million"  float
,"new_deaths_per_million"  float
,"new_deaths_smoothed_per_million"  float
,"reproduction_rate"  float
,"icu_patients"  float
,"icu_patients_per_million"  float
,"hosp_patients"  float
,"hosp_patients_per_million"  float
,"weekly_icu_admissions"  float
,"weekly_icu_admissions_per_million"  float
,"weekly_hosp_admissions"  float
,"weekly_hosp_admissions_per_million"  float
,"total_tests"  float
,"new_tests"  float
,"total_tests_per_thousand"  float
,"new_tests_per_thousand"  float
,"new_tests_smoothed"  float
,"new_tests_smoothed_per_thousand"  float
,"positive_rate"  float
,"tests_per_case"  float
,"tests_units"  varchar (100) 
,"total_vaccinations"  float
,"people_vaccinated"  float
,"people_fully_vaccinated"  float
,"new_vaccinations"  float
,"new_vaccinations_smoothed"  float
,"total_vaccinations_per_hundred"  float
,"people_vaccinated_per_hundred"  float
,"people_fully_vaccinated_per_hundred"  float
,"new_vaccinations_smoothed_per_million"  float
,"stringency_index"  float
,"population"  float
,"population_density"  float
,"median_age"  float
,"aged_65_older"  float
,"aged_70_older"  float
,"gdp_per_capita"  float
,"extreme_poverty"  float
,"cardiovasc_death_rate"  float
,"diabetes_prevalence"  float
,"female_smokers"  float
,"male_smokers"  float
,"handwashing_facilities"  float
,"hospital_beds_per_thousand"  float
,"life_expectancy"  float
,"human_development_index"  float
, PRIMARY KEY (iso_code,continent, "date")
)
PARTITION BY List (continent)
;
  CREATE TABLE Asi_covid PARTITION OF public.coviddata FOR VALUES IN ('Asia');
  CREATE TABLE Eur_covid PARTITION OF public.coviddata FOR VALUES IN ('Europe');
  CREATE TABLE Afr_covid PARTITION OF public.coviddata FOR VALUES IN ('Africa');
  CREATE TABLE Nam_covid PARTITION OF public.coviddata FOR VALUES IN ('North America');
  CREATE TABLE Sam_covid PARTITION OF public.coviddata FOR VALUES IN ('South America');
  CREATE TABLE Oce_covid PARTITION OF public.coviddata FOR VALUES IN ('Oceania');
  CREATE TABLE wrl_covid PARTITION OF public.coviddata FOR VALUES IN ('World');
  CREATE TABLE Int_covid PARTITION OF public.coviddata FOR VALUES IN ('International');
  CREATE TABLE Eun_covid PARTITION OF public.coviddata FOR VALUES IN ('European Union');

CREATE INDEX ON public.coviddata ("iso_code"); 
CREATE INDEX ON public.coviddata ("date");



--command " "\\copy public.coviddata (iso_code, continent, location, date, total_cases, new_cases, new_cases_smoothed, total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million, new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million, new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million, total_tests, new_tests, total_tests_per_thousand, new_tests_per_thousand, new_tests_smoothed, new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units, total_vaccinations, people_vaccinated, people_fully_vaccinated, new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, new_vaccinations_smoothed_per_million, stringency_index, population, population_density, median_age, aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index) FROM '<STORAGE_DIR>/owid-covid-data.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""