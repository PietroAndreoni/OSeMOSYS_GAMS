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
        RH 'Demand for residential housing [thousands km^2]'
        CH 'Demand for commercial space [thousands km^2]'
        TX 'Demand for personal transport [thousands km]' /;

**------------------------------------------------------------------------	
$elseif.ph %phase%=='data' 

##### FINAL DEMAND

scalar fen_2025;
fen_2025 = 1400; #TWh

** italy: residential and commercial -> 26% + 12.5% OF FEN.
** assume: 50% heating, 20% cooling, 30% lighting
SpecifiedAnnualDemand(r,"RH",y) = 0.38 * 0.5 * fen_2025;
SpecifiedAnnualDemand(r,"RC",y) = 0.38 * 0.2 * fen_2025;
SpecifiedAnnualDemand(r,"RL",y) = 0.38 * 0.3 * fen_2025;
SpecifiedAnnualDemand(r,"IH",y) = 0.21 * fen_2025;
** 40.8 million cars * 10000 km/yr = 408 billion km/yr
AccumulatedAnnualDemand(r,"TX",y) = 4.08e8;

parameter SpecifiedDemandProfile(r,f,l,y) /
  ITALY.RH.ID.(2025*2075)  .12
  ITALY.RH.IN.(2025*2075)  .06
  ITALY.RH.SD.(2025*2075)  0
  ITALY.RH.SN.(2025*2075)  0
  ITALY.RH.WD.(2025*2075)  .5467
  ITALY.RH.WN.(2025*2075)  .2733
  ITALY.RL.ID.(2025*2075)  .15
  ITALY.RL.IN.(2025*2075)  .05
  ITALY.RL.SD.(2025*2075)  .15
  ITALY.RL.SN.(2025*2075)  .05
  ITALY.RL.WD.(2025*2075)  .5
  ITALY.RL.WN.(2025*2075)  .1
  ITALY.RC.ID.(2025*2075)  .3
  ITALY.RC.IN.(2025*2075)  0
  ITALY.RC.SD.(2025*2075)  .5
  ITALY.RC.SN.(2025*2075)  .2
  ITALY.RC.WD.(2025*2075)  0
  ITALY.RC.WN.(2025*2075)  0
  ITALY.IH.ID.(2025*2075)  .3
  ITALY.IH.IN.(2025*2075)  .033
  ITALY.IH.SD.(2025*2075)  .3
  ITALY.IH.SN.(2025*2075)  .033
  ITALY.IH.WD.(2025*2075)  .3
  ITALY.IH.WN.(2025*2075)  .034
/;

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

** cogeneration RHCC is a ficticious technology that transforms 1:1 THE fuel in in RH and has no costs
CapitalCost(r,"RHCC",y) = 0;
VariableCost(r,"RHCC",m,y) = 0;
FixedCost(r,"RHCC",y) = 0;
OperationalLife(r,"RHCC") = 999;
ResidualCapacity(r,"RHCC",y) = TotalAnnualMaxCapacity(r,"RHCC",y);

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

** residential heating technologies
InputActivityRatio(r,"RHE","ELC","1",y) = 1/0.9;
InputActivityRatio(r,"RHG","GAS","1",y) = 1/0.9;
InputActivityRatio(r,"RHD","DSL","1",y) = 1;
OutputActivityRatio(r,"RHE","LTE","1",y) = 1;
OutputActivityRatio(r,"RHG","LTE","1",y) = 1;
OutputActivityRatio(r,"RHD","LTE","1",y) = 1;

PHS

** residential lighting and cooling
InputActivityRatio(r,"RL1","ELC","1",y) = 1;
InputActivityRatio(r,"RC1","ELC","1",y) = 1;
OutputActivityRatio(r,"RL1","RL","1",y) = 1;
OutputActivityRatio(r,"RC1","RC","1",y) = 1;

** personal transport
# here you want to the energy expenditure of one car in one year travelling 10000 kms
# 1 car consumes 10000km * l/km * TWh/l 
* DIESEL:  diesel 10 Kwh/l * 1e-9 TWh/kWh * 10000 km/(car*yr)  / 18 km/l 
InputActivityRatio(r,"TXD","DSL","1",y) = 5.5555e-6; 
* ELECTRIC: 10000 km/yr * 0.135 kWh/km * 1e-9 TWh/kWh 
InputActivityRatio(r,"TXE","ELC","1",y) = 1.35e-6;
* GASOLINE: 8.89 Kwh/l gasoline * 10000 * 1e-9 TWh/kWh / 16 km/l
InputActivityRatio(r,"TXG","GSL","1",y) = 5.5562e-6;

# switch from number of cars to thousands of chilometers travelled
OutputActivityRatio(r,"TXD","TX","1",y) = 10; # average thousands km travelled per year: 10
OutputActivityRatio(r,"TXE","TX","1",y) = 10;
OutputActivityRatio(r,"TXG","TX","1",y) = 10;

** industrial heating technologies
InputActivityRatio(r,"IHE","ELC","1",y) = 1;
InputActivityRatio(r,"IHG","GAS","1",y) = 1;
InputActivityRatio(r,"IHC","HCO","1",y) = 1;
# demand for industrial heating is thermal, so output is 1
OutputActivityRatio(r,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,"IHC","IH","1",y) = 1;

$endif.ph