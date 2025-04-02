#### require results_analysis.R to run 
select_multiple_scens <- c("cheapres10","nocoal") #type of policy you want plotted
data_select <- "renewables"
want_storage <- "yes" #do you want to consider want_storage?

#################### MULTIPLE scenarios
ggplot(Production %>% 
         filter( (str_detect(scen,paste(select_multiple_scens,collapse="|"))|scen=="base") & 
                   data==data_select & 
                   FUEL %in% primary & 
                   storage==want_storage) %>%
         group_by(YEAR,data,FUEL) %>%
         mutate(valuediff=(value-value[scen=="base"]) )) +
  geom_line(aes(x=YEAR,
                y=value,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(Activity %>% 
         filter( (str_detect(scen,paste(select_multiple_scens,collapse="|"))|scen=="base") & 
                   data==data_select & 
                   TECHNOLOGY %in% pp & 
                   storage==want_storage)) +
  geom_area(aes(x=YEAR,
                y=value,
                fill=TECHNOLOGY),
            linewidth=1.2, 
            position="stack", stat="identity") +
  xlab("") + ylab("PJ/yr") + facet_wrap(scen~.)

ggplot(TotalCost %>% 
         filter( (str_detect(scen,paste(select_multiple_scens,collapse="|"))|scen=="base") & data==data_select & storage==want_storage) %>%
         group_by(YEAR,data) %>%
         mutate(valuediff=(value-value[scen=="base"])/value[scen=="base"] )) +
  geom_line(aes(x=YEAR,
                y=value,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Costs [fraction of baseline]")

ggplot(Emissions %>% 
         filter( (str_detect(scen,paste(select_multiple_scens,collapse="|"))|scen=="base") & data==data_select & EMISSION=="CO2" & storage==want_storage) %>%
         group_by(YEAR,data) %>%
         mutate(valuediff=(value-value[scen=="base"])/value[scen=="base"] )) +
  geom_line(aes(x=YEAR,
                y=value,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Emission [fraction of baseline]")

ggplot(Demand %>%
         filter((str_detect(scen,paste(select_multiple_scens,collapse="|") )|scen=="base") & 
                  data==data_select & 
                  storage==want_storage & 
                  YEAR==2010 & value!=0) %>% 
         inner_join(hourly_split %>%
                      group_by(season) %>%
                      slice(1:24) %>% mutate(hours=row_number()) ) ) +
  geom_line(aes(x=hours,
                y=value,
                color=FUEL),
            linewidth=1.2) +
  xlab("") + ylab("MW") + facet_wrap(season~.,)

techs <- c("COAL")
ggplot(RateofActivity %>%
         filter((str_detect(scen,paste(select_multiple_scens,collapse="|") )|scen=="base") & 
                  data==data_select & 
                  TECHNOLOGY %in% techs & 
                  storage==want_storage & 
                  YEAR==2010 & 
                  MODE_OF_OPERATION=="1") %>% 
         inner_join(hourly_split) %>%
         filter(yearly_hours <= 8760)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=TECHNOLOGY,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("MW")

ggplot(RateofActivity %>%
         filter((str_detect(scen,paste(select_multiple_scens,collapse="|"))|scen=="base") & 
                  data==data_select & 
                  TECHNOLOGY %in% techs & 
                  storage==want_storage & 
                  YEAR==2010 & 
                  MODE_OF_OPERATION=="1") ) +
  geom_line(aes(x=TIMESLICE,
                y=value,
                color=TECHNOLOGY,
                linetype=scen,
                group=interaction(TECHNOLOGY,scen)),
            linewidth=1.2) +
  xlab("") + ylab("MW")
