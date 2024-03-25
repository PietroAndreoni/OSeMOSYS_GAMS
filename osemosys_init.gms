YearSplit(l,y) = 1; #by default, equally long timeslices
DiscountRate(r) = 0.05; 
DaySplit(y,lh) = 1/365; 
Conversionls(l,ls) = 0;
Conversionld(l,ld) = 0;
Conversionlh(l,lh) = 0;
DaysInDayType(y,ls,ld) = 0;
TradeRoute(r,rr,f,y) = 0;
DepreciationMethod(r) = 1;
SpecifiedAnnualDemand(r,f,y) = 0;
SpecifiedDemandProfile(r,f,l,y) = 1;
AccumulatedAnnualDemand(r,f,y) = 0;
CapacityToActivityUnit(r,t) = 1;
CapacityFactor(r,t,l,y) = 1;
AvailabilityFactor(r,t,y) = 1;
OperationalLife(r,t) = 1;
ResidualCapacity(r,t,y) = 0;
InputActivityRatio(r,t,f,m,y) = 0;
OutputActivityRatio(r,t,f,m,y) = 0;
CapitalCost(r,t,y) = 0;
VariableCost(r,t,m,y) = 0;
FixedCost(r,t,y) = 0;   
TechnologyToStorage(r,m,t,s) = 0;
TechnologyFromStorage(r,m,t,s) = 0;
StorageLevelStart(r,s) = 0;
StorageMaxChargeRate(r,s) = 99;
StorageMaxDischargeRate(r,s) = 99;
MinStorageCharge(r,s,y) = 0;
OperationalLifeStorage(r,s) = 1;
CapitalCostStorage(r,s,y) = 0;
ResidualStorageCapacity(r,s,y) = 0;
CapacityOfOneTechnologyUnit(r,t,y) = 0; #by default, not a MIP
TotalAnnualMaxCapacity(r,t,y) = 99999;
TotalAnnualMinCapacity(r,t,y) = 0;
TotalAnnualMaxCapacityInvestment(r,t,y) = 99999;
TotalAnnualMinCapacityInvestment(r,t,y) = 0;
TotalTechnologyAnnualActivityUpperLimit(r,t,y) = 99999;
TotalTechnologyAnnualActivityLowerLimit(r,t,y) = 0;
TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 99999;
TotalTechnologyModelPeriodActivityLowerLimit(r,t) = 0;
ReserveMarginTagTechnology(r,t,y) = 0;
ReserveMarginTagFuel(r,f,y) = 0;
ReserveMargin(r,y) = 0;
RETagTechnology(r,t,y) = 0;
RETagFuel(r,f,y) = 0;
REMinProductionTarget(r,y) = 0;
EmissionsPenalty(r,e,y) = 0;
AnnualExogenousEmission(r,e,y) = 0;
AnnualEmissionLimit(r,e,y) = 0;
ModelPeriodExogenousEmission(r,e) = 0;
ModelPeriodEmissionLimit(r,e) = 0;
EmissionActivityRatio(r,t,e,m,y) = 0;
