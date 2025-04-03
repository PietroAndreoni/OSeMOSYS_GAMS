$include "Data/utopia_data.gms"
$include "Data/renewables_data.gms"


SET TECHNOLOGY /HEL   "Hydrogen Electrolyzers"/;

SET STORAGE / "HYDROGEN"/;


# Characterize ELECTROLIZERS
CapacityFactor(r,'HEL',l,y) = 1;
AvailabilityFactor(r,'HEL',y) = 0.9;
InputActivityRatio(r,l,'HEL','ELC',"1",y) = 2; #IEA convention
OutputActivityRatio(r,l,'HEL','ELC',"2",y) = 0.6; #IEA convention
TechnologyToStorage(r,"1",'HEL','HYDROGEN') = 1;
TechnologyFromStorage(r,"2",'HEL','HYDROGEN') = 1;

OperationalLife(r,'HEL') = 10;
CapitalCost(r,'HEL',y) = 1;
VariableCost(r,'HEL',m,y) = 0;
FixedCost(r,'HEL',y) = 0;

CapitalCostStorage(r,'HYDROGEN',y) = 100;
ResidualStorageCapacity(r,'HYDROGEN',y) = 0;
StorageLevelStart(r,'HYDROGEN') = 0;


set storage_plants(TECHNOLOGY) / "HEL" /;
