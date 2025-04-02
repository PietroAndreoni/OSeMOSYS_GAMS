$set phase %1

** ----------------------------------------------------------------
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        IMPDSL1 'Diesel imports'
        IMPGSL1 'Gasoline imports'
        IMPHCO1 'Coal imports'
        IMPOIL1 'Crude oil imports'
        IMPGAS1 'Natural gas imports'
        IMPBIO1 'Biomass supply'
/;

set     FUEL    /
        HCO 'Coal'
        GAS 'Natural gas'
        OIL 'Crude oil'
        WBM 'Woody biomass'
        WST 'Waste'
        GTH 'Geothermal energy'
        SUN 'Solar energy'
        WIN 'Wind energy'
        HYD 'Hydro energy'
/;

** ----------------------------------------------------------------
$elseif.ph %phase%=='data'

*** characterize technologies
CapitalCost(r,'IMPDSL1',y) = 0;
VariableCost(r,'IMPDSL1',m,y) = 50; # cost of diesel in $/MWh
FixedCost(r,'IMPDSL1',y) = 0;
OperationalLife(r,'IMPDSL1') = 999;
AvailabilityFactor(r,'IMPDSL1',y) = 1;
EmissionActivityRatio(r,'IMPDSL1','CO2','1',y) = 0.075;

CapitalCost(r,'IMPGSL1',y) = 0;
VariableCost(r,'IMPGSL1',m,y) = 70; # cost of gasoline in $/MWh
FixedCost(r,'IMPGSL1',y) = 0;
OperationalLife(r,'IMPGSL1') = 999;
AvailabilityFactor(r,'IMPGSL1',y) = 1;
EmissionActivityRatio(r,'IMPGSL1','CO2','1',y) = 0.075;

CapitalCost(r,'IMPHCO1',y) = 0;
VariableCost(r,'IMPHCO1',m,y) = 30; # cost of coal in $/MWh
FixedCost(r,'IMPHCO1',y) = 0;
OperationalLife(r,'IMPHCO1') = 999;
AvailabilityFactor(r,'IMPHCO1',y) = 1;
EmissionActivityRatio(r,'IMPHCO1','CO2','1',y) = 0.089;

CapitalCost(r,'IMPOIL1',y) = 0;
VariableCost(r,'IMPOIL1',m,y) = 60; # cost of oil in $/MWh
FixedCost(r,'IMPOIL1',y) = 0;
OperationalLife(r,'IMPOIL1') = 999;
AvailabilityFactor(r,'IMPOIL1',y) = 1;
EmissionActivityRatio(r,'IMPOIL1','CO2','1',y) = 0.075;

CapitalCost(r,'IMPGAS1',y) = 0;
VariableCost(r,'IMPGAS1',m,y) = 40; # cost of gas in $/MWh
FixedCost(r,'IMPGAS1',y) = 0;
OperationalLife(r,'IMPGAS1') = 999;
AvailabilityFactor(r,'IMPGAS1',y) = 1;
EmissionActivityRatio(r,'IMPGAS1','CO2','1',y) = 0.055;

CapitalCost(r,'IMPBIO1',y) = 0;
VariableCost(r,'IMPBIO1',m,y) = 20; # cost of biomass in $/MWh  
FixedCost(r,'IMPBIO1',y) = 0;
OperationalLife(r,'IMPBIO1') = 999;
AvailabilityFactor(r,'IMPBIO1',y) = 1;
EmissionActivityRatio(r,'IMPBIO1','CO2','1',y) = 0;

** ----------------------------------------------------------------
$elseif.ph %phase%=="popol"

$endif.ph