#### require results_analysis.R to run 
select_scen <- "emicap1" #type of policy you want plotted
data_select <- c("renewables","hydrogen")
want_storage <- "yes" #do you want to consider storage?

ggplot(Production %>% 
         filter(scen==select_scen & 
                   data %in% data_select & 
                   FUEL %in% primary & 
                   storage==want_storage) %>%
         group_by(YEAR,scen,FUEL) %>%
         mutate(valuediff=(value-value[data=="renewables"]) ) ) +
  geom_line(aes(x=YEAR,
                y=value,
                color=FUEL,
                linetype=data),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")


ggplot(Activity %>% 
         filter(scen==select_scen & 
                    data %in% data_select & 
                   TECHNOLOGY %in% pp & 
                   storage==want_storage)) +
  geom_area(aes(x=YEAR,
                y=value,
                fill=TECHNOLOGY),
            linewidth=1.2, 
            position="stack", stat="identity") +
  xlab("") + ylab("PJ/yr") + facet_wrap(data~.)


ggplot(TotalCost %>% 
         filter( scen==select_scen & 
                   data %in% data_select & 
                   storage==want_storage) %>%
         group_by(YEAR,scen) %>%
         mutate(valuediff=(value-value[data=="renewables"])/value[data=="renewables"] )%>%
         filter(data!="renewables") ) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=data),
            linewidth=1.2) +
  xlab("") + ylab("Costs [fraction of baseline]")
