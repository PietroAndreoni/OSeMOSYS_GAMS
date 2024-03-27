require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

####### here you select your results for your plot
data_select <- "renewables"
scen_select <- "base"
complete_directory <- here::here()
all_gdx <- c(Sys.glob(here::here("Results/results_*.gdx")))
select_multiple_scens <- "emicap" #type of policy you want plotted
storage <- "no" #do you want to consider storage

osemosys_sanitize <- function(.x) {
  .x[, file := basename(gdx)]
  .x[, file := str_replace(file,"Results/results_","")]
  .x[, file := str_replace(file,".gdx","")]
  .x[, scen := str_extract(file,"(?<=SCEN).+?(?=_)")]
  .x[, data := str_extract(file,"(?<=DATA).+?(?=_)")]
  .x[, storage := str_extract(file,"(?<=STOR).*")]
  .x[, YEAR := as.numeric(YEAR)]
  .x[, gdx := NULL]}

Production <- batch_extract("ProductionAnnual",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
ProductionSlice <- batch_extract("Production",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Use <- batch_extract("UseAnnual",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Demand <- batch_extract("Demand",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
CapacityFactor <- batch_extract("CapacityFactor",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
TotalCost <- batch_extract("TotalDiscountedCost",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Emissions <- batch_extract("AnnualEmissions",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

### build the proxy for hourly curves
YearSplit <-  batch_extract("YearSplit",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
DaySplit <-  batch_extract("DaySplit",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

year_map <- unique(YearSplit %>% select(-file,-scen,-data, -YEAR)) %>% 
  filter(TIMESLICE !="ALLYEAR") %>%
  mutate(day = str_sub(TIMESLICE,2),
         season = str_sub(TIMESLICE,1,1)) 

hourly_split <- data.frame(yearly_hours = seq(1,8670)) %>%
  mutate(day = ifelse(yearly_hours %% 24 < 8 | yearly_hours %% 24 >= 24,"D","N")) %>%
  mutate(season = case_when(yearly_hours <= 3*31*24 ~ "W",
                            yearly_hours > 3*30*24 & yearly_hours <= 6*30*24 ~ "I",
                            yearly_hours > 6*30*24 & yearly_hours <= 9*30*24 ~ "S",
                            yearly_hours > 9*30*24 & yearly_hours <= 12*30*24 ~ "I",
                            yearly_hours > 12*30*24 ~ "W") ) %>%
  inner_join(year_map %>% select(-value))

### load some useful sets for fuels
primary <- batch_extract("primary_fuel",all_gdx)[[1]]$FUEL 
final <- batch_extract("final_demand",all_gdx)[[1]]$FUEL 
secondary <- batch_extract("secondary_carrier",all_gdx)[[1]]$FUEL 

### load some useful subsets for technologies
ren <- batch_extract("renewable_tech",all_gdx)[[1]]$TECHNOLOGY 
pp <- batch_extract("power_plants",all_gdx)[[1]]$TECHNOLOGY 

## plot primary energy, total
ggplot(Production %>% 
         filter(scen==scen_select & data==data_select & FUEL %in% primary & storage==storage)) +
  geom_line(aes(x=YEAR,
                y=value,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(ProductionSlice %>% 
         filter(scen==scen_select & data==data_select & FUEL %in% primary & storage==storage) %>%
         group_by(scen,data,YEAR) %>%
         mutate(valuerel=value/sum(value))  ) +
  geom_area(aes(x=YEAR,
                y=valuerel*100,
                fill=FUEL),
            linewidth=1.2,
            color="black") +
  xlab("") + ylab("%")

### secondary energy
ggplot(Production %>% 
         filter(scen==scen_select & data==data_select & FUEL %in% secondary & storage==storage)) +
  geom_line(aes(x=YEAR,
                y=value,
                color=FUEL),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

## plot final demand
ggplot(ProductionSlice %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & FUEL %in% final & YEAR == 2010 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=FUEL),
            linewidth=0.8) +
  xlab("") + ylab("PJ/yr") +
  facet_wrap(FUEL~.,scales="free")

### timeslice for a single day
ggplot(ProductionSlice %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & FUEL %in% final & YEAR == 2010 & yearly_hours <= 24 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=FUEL),
            linewidth=0.8) +
  xlab("") + ylab("PJ/yr") +
  facet_wrap(FUEL~.,scales="free")


### renewables availability
ggplot(CapacityFactor %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & TECHNOLOGY %in% ren & YEAR == 2010 & yearly_hours <= 24 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=TECHNOLOGY),
            linewidth=0.8) +
  xlab("") + ylab("fraction") + 
  ylim(c(0,1))

ggplot(CapacityFactor %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & TECHNOLOGY %in% ren & YEAR == 2010 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=TECHNOLOGY),
            linewidth=0.8) +
  xlab("") + ylab("fraction") + 
  ylim(c(0,1))



#################### MULTIPLE scenarios
ggplot(Production %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & FUEL %in% primary & storage==storage) %>%
         group_by(YEAR,data,FUEL) %>%
         mutate(valuediff=(value-value[scen=="base"]) )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(Production %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & FUEL %in% secondary & storage==storage) %>%
         group_by(YEAR,data,FUEL) %>%
         mutate(valuediff=(value-value[scen=="base"]) )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(TotalCost %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & storage==storage) %>%
         group_by(YEAR,data) %>%
         mutate(valuediff=(value-value[scen=="base"])/value[scen=="base"] )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Costs [fraction of baseline]")

ggplot(Emissions %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & EMISSION=="CO2" & storage==storage) %>%
         group_by(YEAR,data) %>%
         mutate(valuediff=(value-value[scen=="base"])/value[scen=="base"] )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Emission [fraction of baseline]")
