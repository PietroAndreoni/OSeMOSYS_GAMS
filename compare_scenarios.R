#### require results_analysis.R to run 
select_multiple_scens <- "emicap" #type of policy you want plotted
data_select <- "hydrogen"
scen_select <- "base"
want_storage <- "yes" #do you want to consider want_storage?

#################### MULTIPLE scenarios
ggplot(Production %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & FUEL %in% primary & storage==want_storage) %>%
         group_by(YEAR,data,FUEL) %>%
         mutate(valuediff=(value-value[scen=="base"]) )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(Production %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & FUEL %in% secondary & storage==want_storage) %>%
         group_by(YEAR,data,FUEL) %>%
         mutate(valuediff=(value-value[scen=="base"]) )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(TotalCost %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & storage==want_storage) %>%
         group_by(YEAR,data) %>%
         mutate(valuediff=(value-value[scen=="base"])/value[scen=="base"] )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Costs [fraction of baseline]")

ggplot(Emissions %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & EMISSION=="CO2" & storage==want_storage) %>%
         group_by(YEAR,data) %>%
         mutate(valuediff=(value-value[scen=="base"])/value[scen=="base"] )) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Emission [fraction of baseline]")

ggplot(Activity %>%
         filter((str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & TECHNOLOGY %in% stor & storage==want_storage & YEAR==2010 & MODE_OF_OPERATION=="1") %>% 
         inner_join(hourly_split) %>%
         filter(yearly_hours <= 8760)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=TECHNOLOGY,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("MW")


ggplot(Activity %>%
         filter((str_detect(scen,select_multiple_scens)|scen=="base") & data==data_select & TECHNOLOGY %in% stor & storage==want_storage & YEAR==2010 & MODE_OF_OPERATION=="1") ) +
  geom_line(aes(x=TIMESLICE,
                y=value,
                color=TECHNOLOGY,
                linetype=scen,
                group=interaction(TECHNOLOGY,scen)),
            linewidth=1.2) +
  xlab("") + ylab("MW")
