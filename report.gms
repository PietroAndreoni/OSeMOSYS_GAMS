
* We allow for two ways of usage:
$ifthen.c not "%1"==""
* a) $batinclude ex01.gms scen (e.g. call ex01 after osemosys solution)
$set repscen "%1"
$else.c
* b) gams ex01.gms --repscen=scen (e.g. run ex01 on its own, so we need to load everything first)
$if not set repscen $abort 'If run on its own, you need to specify a "repscen" (e.g. --repscen=base)'
$call "gdxdump results_%repscen%.gdx NoData Output=results_%repscen%.gms"
$include results_%repscen%.gms
$endif.c


* To support multiple batincludes of this file, we need an ifthen
$ifthen.a not set report_symbols_declared

set energy_services(f) / RH, RL, TX /;
set primary_sources(f) / DSL, GSL, HCO, HYD, URN /
alias(f,ff);
set ftm_elec(f,t,m);
set t_elec(t);
set t_feeding_demand_f_using_ff(t,f,ff,m);
 
parameter rep_fen_tot(*,r,y) 'PJ/yr';
parameter rep_fen_share(*,r,f,y) '%';
parameter rep_pes_tot(*,r,y) 'PJ/yr';
parameter rep_pes_share(*,r,f,y) '%';
parameter rep_elec_tot(*,r,y) 'PJ/yr';
parameter rep_elec_share(*,r,f,y) '%';
parameter rep_capacity_elec_tot(*,r,y) 'GW';
parameter rep_capacity_elec_share(*,r,t,y) '%';
parameter rep_investment_elec_tot(*,r,y) 'M$';
parameter rep_investment_elec_share(*,r,t,y) '%';
parameter rep_co2emiss_tot(*,r,y) 'GtonCO2';
parameter rep_co2emiss_by_fuel(*,r,f,y) 'GtonCO2';
parameter rep_co2int_by_fuel(*,r,f,y) 'GtonCO2/PJ';
parameter rep_co2emiss_share_pes(*,r,f,y) '%';
parameter rep_sen_by_fen(*,r,ff,f,y) 'Amount of fuel ff used to feed f [PJ/yr]';
parameter rep_co2emiss_by_fen(*,r,f,y) 'GtonCO2';
parameter rep_co2emiss_share_fen(*,r,f,y) '%';
parameter rep_cost_wrt_base(*,r) '%';

variable cost_base(r);
$gdxin results_base.gdx
$loaddc cost_base=ModelPeriodCostByRegion
$gdxin

$setglobal report_symbols_declared
$endif.a

*------------------------------------------------------------------------	
*    - total final energy [PJ/yr]
*------------------------------------------------------------------------

* Final energy services are listed in the set f

* Quantities demanded are contained in two demand parameters, one for
* annual and one for time-slice demand (but both referring to annual
* quantitites). The Demand variable refers only to time-slice demand.
rep_fen_tot('%repscen%',r,y) = sum(energy_services(f), AccumulatedAnnualDemand(r,f,y) + SpecifiedAnnualDemand(r,f,y));

display rep_fen_tot;


*------------------------------------------------------------------------	
*    - share of final energy end uses [%]       
*------------------------------------------------------------------------

* For each energy service f, calculate the share between its demand and
* the total.
rep_fen_share('%repscen%',r,f,y)$energy_services(f) = 100.*(AccumulatedAnnualDemand(r,f,y) + SpecifiedAnnualDemand(r,f,y))/rep_fen_tot('%repscen%',r,y);
display rep_fen_share;


*------------------------------------------------------------------------	
*    - total primary energy supply [PJ/yr]       
*------------------------------------------------------------------------

* You need to clarify what we mean by primary energy supply. In this case,
* we consider energy sources that can be used as fuels for transport,
* heating or to produce electricity, i.e. the primary_sources set.

rep_pes_tot('%repscen%',r,y) = sum(primary_sources(f), ProductionAnnual.L(r,f,y));
display rep_pes_tot;


*------------------------------------------------------------------------	
*    - share of primary energy sources [%]       
*------------------------------------------------------------------------

rep_pes_share('%repscen%',r,f,y)$primary_sources(f) = 100.*ProductionAnnual.L(r,f,y)/rep_pes_tot('%repscen%',r,y);
display rep_pes_share;


*------------------------------------------------------------------------	
*    - total electricity production [PJ/yr]       
*------------------------------------------------------------------------

* First, we identify the combinations of ("fuel","tech","mode") such that
* electricity is produced from "fuel" using "tech" operating according to
* "mode", where "fuel" is a primary energy source (i.e. for simplicity we
* assume not to be interested in electricity supplied from storage).
ftm_elec(f,t,m) = yes$(sum((r,y)$(primary_sources(f) and InputActivityRatio(r,t,f,m,y) and OutputActivityRatio(r,t,'ELC',m,y)),1));

* ProductionAnnual is only per fuel. We need a variable which is indexed
* by technology, e.g. RateOfProductionByTechnologyByMode.
rep_elec_tot('%repscen%',r,y) = sum((f,t,m,l)$ftm_elec(f,t,m),
    RateOfProductionByTechnologyByMode.l(r,l,t,m,'ELC',y)*YearSplit(l,y));
display rep_elec_tot;


*------------------------------------------------------------------------	
*    - share of electricity production by primary energy source [%]       
*------------------------------------------------------------------------

rep_elec_share('%repscen%',r,f,y)$primary_sources(f) = 100.*sum((t,m,l)$ftm_elec(f,t,m),
    RateOfProductionByTechnologyByMode.l(r,l,t,m,'ELC',y)*YearSplit(l,y))/rep_elec_tot('%repscen%',r,y);
display rep_elec_share;


*------------------------------------------------------------------------	
*    - total capacity for electricity production [GW]       
*------------------------------------------------------------------------

* We list all techs producing elec by transforming one primary fuel under some mode.
t_elec(t) = yes$(sum((f,m)$ftm_elec(f,t,m),1));
display t_elec;

* Having t_elec, it is just a matter of summing TotalCapacityAnnual over t_elec
rep_capacity_elec_tot('%repscen%',r,y) = sum(t_elec(t), TotalCapacityAnnual.l(r,t,y));


*------------------------------------------------------------------------	
*    - share of capacity for electricity production by technology       
*------------------------------------------------------------------------

rep_capacity_elec_share('%repscen%',r,t,y)$t_elec(t) = 100.*TotalCapacityAnnual.l(r,t,y)/rep_capacity_elec_tot('%repscen%',r,y);
display rep_capacity_elec_share;


*------------------------------------------------------------------------	
*    - total investments in capacity for electricity production [M$]       
*------------------------------------------------------------------------

* Like capacity, with the variable used for investment accounting.
rep_investment_elec_tot('%repscen%',r,y) = sum(t$t_elec(t), CapitalInvestment.l(r,t,y));
display rep_investment_elec_tot;


*------------------------------------------------------------------------	
*    - share of investments in capacity for electricity production per technology [%]       
*------------------------------------------------------------------------

* We condition also on rep_investment_elec_tot to avoid division by 0 if no
* investments are done in certain years.
rep_investment_elec_share('%repscen%',r,t,y)$(t_elec(t) and rep_investment_elec_tot('%repscen%',r,y)) = 100.*CapitalInvestment.l(r,t,y)/rep_investment_elec_tot('%repscen%',r,y);
display rep_investment_elec_share;


*------------------------------------------------------------------------	
*    - total CO2 emissions [GtonCO2]       
*------------------------------------------------------------------------

rep_co2emiss_tot('%repscen%',r,y) = AnnualEmissions.l(r,'co2',y) + AnnualExogenousEmission(r,'co2',y);
display rep_co2emiss_tot;


*------------------------------------------------------------------------	
*    - share of CO2 emissions by final energy end use and primary energy [%]       
*------------------------------------------------------------------------

* The specific formulas to calculate such values depend on where emissions
* are accounted for. In the utopia dataset, emissions are accounted at the
* level of IMP* technologies (i.e. boxes representing import of primary
* fuels).

rep_co2emiss_by_fuel('%repscen%',r,f,y) = sum((t,m)$(OutputActivityRatio(r,t,f,m,y) and EmissionActivityRatio(r,t,'co2',m,y)), EmissionActivityRatio(r,t,'co2',m,y)*ProductionByTechnologyAnnual.l(r,t,f,y));
rep_co2int_by_fuel('%repscen%',r,f,y) = sum((t,m)$(OutputActivityRatio(r,t,f,m,y) and EmissionActivityRatio(r,t,'co2',m,y)), EmissionActivityRatio(r,t,'co2',m,y));
rep_co2emiss_share_pes('%repscen%',r,f,y) = 100.*rep_co2emiss_by_fuel('%repscen%',r,f,y)/sum(ff, rep_co2emiss_by_fuel('%repscen%',r,ff,y));
display rep_co2emiss_share_pes;

* Let's now calculate carbon intensity of secondary fuels. For simplicity,
* we neglect the potential difference in emissions between imported and
* produced diesel. Notice how the carbon intensity of electricity tends to
* the carbon intensity of the coal needed (3.1 PJ) to produced 1 PJ of
* electricity, as coal tends to a 100% share in the elec
* mix.
rep_co2int_by_fuel('%repscen%',r,'elc',y) = sum(ftm_elec(f,t,m),rep_elec_share('%repscen%',r,f,y)*InputActivityRatio(r,t,f,m,y)*rep_co2int_by_fuel('%repscen%',r,f,y))/100;
display rep_co2int_by_fuel;
* In order to relate final energy services with fuels, we build an
* appropriate set, knowing that a fuel "ff" will feed a technology "t"
* that eventually satisfies a demand "f"
t_feeding_demand_f_using_ff(t,f,ff,m) = yes$(sum((r,y)$(InputActivityRatio(r,t,ff,m,y) and OutputActivityRatio(r,t,f,m,y) and energy_services(f)), 1));
option t_feeding_demand_f_using_ff:0:0:3;
display t_feeding_demand_f_using_ff;
* Having the right set, it's just a matter of summing over quantities.
rep_sen_by_fen('%repscen%',r,ff,f,y)$energy_services(f) = sum((t,m,l)$t_feeding_demand_f_using_ff(t,f,ff,m), RateOfUseByTechnologyByMode.l(r,l,t,m,ff,y)*yearsplit(l,y));
rep_co2emiss_by_fen('%repscen%',r,f,y) = sum(ff, rep_sen_by_fen('%repscen%',r,ff,f,y)*rep_co2int_by_fuel('%repscen%',r,ff,y));
* There is a discrepancy between sum(ff, rep_co2emiss_by_fen(r,ff,y)) and rep_co2emiss_tot(r,y). This is due to the fact that for simplicity we are considering an average carbon intensity for produced electricity. Here we are considering the electricity coming from storage and feeding final demand as polluting with this average carbon intensity. On the other hand, rep_co2emiss_tot does not account for that electricity, which is assumed to have produced co2 previously in time.
rep_co2emiss_share_fen('%repscen%',r,f,y) = 100*rep_co2emiss_by_fen('%repscen%',r,f,y)/sum(ff, rep_co2emiss_by_fen('%repscen%',r,ff,y));
display rep_co2emiss_share_fen;


*------------------------------------------------------------------------	
*   - cost wrt base case
*------------------------------------------------------------------------

rep_cost_wrt_base('%repscen%',r) = 100*(ModelPeriodCostByRegion.l(r)/cost_base.l(r)-1);
display rep_cost_wrt_base;


execute_unload 'report_%repscen%.gdx',
rep_fen_tot
rep_fen_share
rep_pes_tot
rep_pes_share
rep_elec_tot
rep_elec_share
rep_capacity_elec_tot
rep_capacity_elec_share
rep_investment_elec_tot
rep_investment_elec_share
rep_co2emiss_tot
rep_co2emiss_share_fen
rep_co2emiss_share_pes
rep_cost_wrt_base
;
