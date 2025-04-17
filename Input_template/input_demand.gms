$set phase %1

**------------------------------------------------------------------------	
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        RHE 'Heat pumps [GW]'
        RHG 'Gas boiler [GW]'
        RHD 'Diesel boiler [GW]'
        RC1 'Air conditioning [GW]'
        RL1 'Lighting [GW]'
        PHS 'Residential building [km^2]'
        CHS 'Commercial building [km^2]'
        TXD 'Personal vehicles - diesel [number of vehicles]'
        TXE 'Personal vehicles - electric [number of vehicles]'
        TXG 'Personal vehicles - gasoline [number of vehicles]'
*        IHE 'Industrial heating - electric [GW]'
*        IHG 'Industrial heating - gas [GW]'
*        IHC 'Industrial heating - coal [GW]' 
        /;

set    FUEL            /
# ENERGY FUELS
        LTE 'Thermal energy, low temperature [TWh]'
        CTE 'Thermal energy, cooling [TWh]'
        LTG 'Visible light [TWh]'
*        HTE 'Thermal energy, high temperature [TWh]' 
*        IH 'Demand for steel [ton steel]'
# NON ENERGY FUELS
        RES 'Demand for residential housing [km^2]'
        COM 'Demand for commercial space [km^2]'
        TX 'Demand for personal transport [thousands km]' /;

**------------------------------------------------------------------------	
$elseif.ph %phase%=='data' 

##### FINAL DEMAND

** 40.8 million cars * 10000 km/yr = 408 billion km/yr
AccumulatedAnnualDemand(r,"TX",y) = 4.08e8;

** 43 m^2/person * 55 million people (source https://entranze.enerdata.net/)
AccumulatedAnnualDemand(r,"RH",y) = 43*55;

** 7 m^2/person * 55 million people (source https://entranze.enerdata.net/)
AccumulatedAnnualDemand(r,"CH",y) = 7*55;

##### END-USE TECHNOLOGIES
** residential heating technologies
CapitalCost(r,"RHE",y) = 1000;
VariableCost(r,"RHE",m,y) = 1e-5;
FixedCost(r,"RHE",y) = 0.1;
OperationalLife(r,"RHE") = 10;

CapitalCost(r,"RHG",y) = 1000;
VariableCost(r,"RHG",m,y) = 1e-5;
FixedCost(r,"RHG",y) = 0.1;
OperationalLife(r,"RHG") = 10;

CapitalCost(r,"RHD",y) = 1000;
VariableCost(r,"RHD",m,y) = 1e-5;
FixedCost(r,"RHD",y) = 0.1;
OperationalLife(r,"RHD") = 10;

** residential lighting and cooling
CapitalCost(r,"RL1",y) = 1000;
VariableCost(r,"RL1",m,y) = 1e-5;
FixedCost(r,"RL1",y) = 0.1;
OperationalLife(r,"RL1") = 10;

CapitalCost(r,"RC1",y) = 1000;
VariableCost(r,"RC1",m,y) = 1e-5;
FixedCost(r,"RC1",y) = 0.1;
OperationalLife(r,"RC1") = 10;

** personal transport
* assuming 25k for a diesel car, 22k for a gasoline car, and 35k for an electric car
* fixed costs (insurance, taxes, etc.) are 2k for diesel and gasoline, and 1.5k for electric
CapitalCost(r,"TXD",y) = 25e-6;
VariableCost(r,"TXD",m,y) = 0;
FixedCost(r,"TXD",y) = 2e-6;
OperationalLife(r,"TXD") = 12;

CapitalCost(r,"TXE",y) = 35e-6;
VariableCost(r,"TXE",m,y) = 0;
FixedCost(r,"TXE",y) = 1.5e-6;
OperationalLife(r,"TXE") = 12;

CapitalCost(r,"TXG",y) = 22e-6;
VariableCost(r,"TXG",m,y) = 0;
FixedCost(r,"TXG",y) = 2e-6;
OperationalLife(r,"TXG") = 12;

** industrial heating technologies
CapitalCost(r,"IHE",y) = 1000;
VariableCost(r,"IHE",m,y) = 1e-5;
FixedCost(r,"IHE",y) = 0.1;
OperationalLife(r,"IHE") = 10;

CapitalCost(r,"IHG",y) = 1000;
VariableCost(r,"IHG",m,y) = 1e-5;
FixedCost(r,"IHG",y) = 0.1;
OperationalLife(r,"IHG") = 10;

CapitalCost(r,"IHC",y) = 1000;
VariableCost(r,"IHC",m,y) = 1e-5;
FixedCost(r,"IHC",y) = 0.1;
OperationalLife(r,"IHC") = 10;

**------------------------------------------------------------------------	
$elseif.ph %phase%=='popol'

#template (efficiencies should be populated correctly)

** low heat heating and cooling technologies
InputActivityRatio(r,l,"RHE","ELC","1",y) = 1/0.9;
InputActivityRatio(r,l,"RHG","GAS","1",y) = 1/0.9;
InputActivityRatio(r,l,"RHD","DSL","1",y) = 1;
InputActivityRatio(r,l,"RC1","ELC","1",y) = 1;

OutputActivityRatio(r,l,"RHE","LTE","1",y) = 1;
OutputActivityRatio(r,l,"RHE","CTE","2",y) = 1;
OutputActivityRatio(r,l,"RHG","LTE","1",y) = 1;
OutputActivityRatio(r,l,"RHD","LTE","1",y) = 1;
OutputActivityRatio(r,l,"RC1","RC","1",y) = 1;

** lighting technologies
InputActivityRatio(r,l,"RL1","ELC","1",y) = 1;
OutputActivityRatio(r,l,"RL1","LTG","1",y) = 1;

** residential space 
OutputActivityRatio(r,"WD","PHS","LTG","1",y) = 1;
OutputActivityRatio(r,"WN","PHS","LTG","1",y) = 1;
OutputActivityRatio(r,"WD","PHS","LTG","1",y) = 1;


OutputActivityRatio(r,l,"PHS","RES","1",y) = 1;
OutputActivityRatio(r,l,"CHS","COM","1",y) = 1;

** personal transport
# here you want to the energy expenditure of one car in one year travelling 10000 kms
# 1 car consumes 10000km * l/km * TWh/l 
* DIESEL:  diesel 10 Kwh/l * 1e-9 TWh/kWh * 10000 km/(car*yr)  / 18 km/l 
InputActivityRatio(r,l,"TXD","DSL","1",y) = 5.5555e-6; 
* ELECTRIC: 10000 km/yr * 0.135 kWh/km * 1e-9 TWh/kWh 
InputActivityRatio(r,l,"TXE","ELC","1",y) = 1.35e-6;
* GASOLINE: 8.89 Kwh/l gasoline * 10000 * 1e-9 TWh/kWh / 16 km/l
InputActivityRatio(r,l,"TXG","GSL","1",y) = 5.5562e-6;

# switch from number of cars to thousands of chilometers travelled
OutputActivityRatio(r,l,"TXD","TX","1",y) = 10; # average thousands km travelled per year: 10
OutputActivityRatio(r,l,"TXE","TX","1",y) = 10;
OutputActivityRatio(r,l,"TXG","TX","1",y) = 10;

** industrial heating technologies
InputActivityRatio(r,l,"IHE","ELC","1",y) = 1;
InputActivityRatio(r,l,"IHG","GAS","1",y) = 1;
InputActivityRatio(r,l,"IHC","HCO","1",y) = 1;
# demand for industrial heating is thermal, so output is 1
OutputActivityRatio(r,l,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,l,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,l,"IHC","IH","1",y) = 1;

$endif.ph