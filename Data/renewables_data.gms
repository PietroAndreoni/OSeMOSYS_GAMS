$include "Data/utopia_data.gms"

set TECHNOLOGY /
* new technologies
        SPV 'Solar power plants'
        WPP 'Wind power plants'/;

set FUEL / 
* new fuels 
        SOL 'Solar'
        WND 'Wind' /;
 
set renewable_tech(TECHNOLOGY) /SPV,WPP/; 
set renewable_fuel(FUEL) /SOL,WND/; 

set power_plants(TECHNOLOGY) / SPV, WPP/;

set primary_fuel(FUEL) / SOL, WND /;

# Characterize SOLAR technology
OperationalLife(r,'SPV') = 15;
CapacityFactor(r,'SPV','ID',y) = 0.4;
CapacityFactor(r,'SPV','IN',y) = 0;
CapacityFactor(r,'SPV','SD',y) = 0.8;
CapacityFactor(r,'SPV','SN',y) = 0;
CapacityFactor(r,'SPV','WD',y) = 0.1;
CapacityFactor(r,'SPV','WN',y) = 0;

InputActivityRatio(r,'SPV','SOL',m,y) = 1; #IEA convention
OutputActivityRatio(r,'SPV','ELC',m,y) = 0.98; 

CapitalCost(r,'SPV',y)$(y.val le 2010) = 1000;
CapitalCost(r,'SPV',y)$(y.val gt 2010) = max(1000*(1-0.05)**(y.val-2010),300);
VariableCost(r,'SPV',m,y) = 1e-5;
FixedCost(r,'SPV',y) = 5;


# Characterize WIND technology
OperationalLife(r,'WPP') = 15;

CapacityFactor(r,'WPP','ID',y) = 0.2;
CapacityFactor(r,'WPP','IN',y) = 0.3;
CapacityFactor(r,'WPP','SD',y) = 0.1;
CapacityFactor(r,'WPP','SN',y) = 0.15;
CapacityFactor(r,'WPP','WD',y) = 0.3;
CapacityFactor(r,'WPP','WN',y) = 0.4;

InputActivityRatio(r,'WPP','WND',m,y) = 1; #IEA convention
OutputActivityRatio(r,'WPP','ELC',m,y) = 0.98; 

CapitalCost(r,'WPP',y)$(y.val le 2010) = 1200;
CapitalCost(r,'WPP',y)$(y.val gt 2010) = max(1200*(1-0.05)**(y.val-2010),600);
VariableCost(r,'WPP',m,y) = 1e-5;
FixedCost(r,'WPP',y) = 7;

