$set phase %1

**------------------------------------------------------------------------	
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        RHE 'Residential heating - electric'
        RHG 'Residential heating - gas'
        RHD 'Residential heating - diesel'
        RHCC 'Residential heating - waste/cogeneration heat'
        RL1 'Residential lighting'
        RC1 'Residential cooling'
        TXD 'Personal vehicles - diesel'
        TXE 'Personal vehicles - electric'
        TXG 'Personal vehicles - gasoline'
        IHE 'Industrial heating - electric'
        IHG 'Industrial heating - gas'
        IHC 'Industrial heating - coal' /;

set    FUEL            /
        RH 'Demand for residential heating'
        RL 'Demand for residential lighting'
        RC 'Demand for residential cooling'
        IH 'Demand for industrial heating'
        TX 'Demand for personal transport' /;

$elseif.ph %phase%=='data' 
*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
scalar fen_2025;
fen_2025 = 1400; #TWh

** italy: residential and commercial -> 26% + 12.5% OF FEN.
** assume: 50% heating, 20% cooling, 30% lighting
SpecifiedAnnualDemand(r,"RH","2025") = 0.38 * 0.5 * fen_2025;
SpecifiedAnnualDemand(r,"RC","2025") = 0.38 * 0.2 * fen_2025;
SpecifiedAnnualDemand(r,"RL","2025") = 0.38 * 0.3 * fen_2025;
SpecifiedAnnualDemand(r,"IH","2025") = 0.21 * fen_2025;
AccumulatedAnnualDemand(r,"TX","2025") = 0.33 * fen_2025;

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

$elseif.ph %phase%=='popol'

#template (efficiencies should be populated correctly)

** residential heating technologies
InputActivityRatio(r,"RHE","ELC","1",y) = 1;
InputActivityRatio(r,"RHG","GAS","1",y) = 1;
InputActivityRatio(r,"RHD","DSL","1",y) = 1;
InputActivityRatio(r,"RHCC","THE","1",y) = 1;
OutputActivityRatio(r,"RHE","RH","1",y) = 1;
OutputActivityRatio(r,"RHG","RH","1",y) = 1;
OutputActivityRatio(r,"RHD","RH","1",y) = 1;
OutputActivityRatio(r,"RHCC","RH","1",y) = 1;

** residential lighting and cooling
InputActivityRatio(r,"RL1","ELC","1",y) = 1;
InputActivityRatio(r,"RC1","ELC","1",y) = 1;
OutputActivityRatio(r,"RHCC","RH","1",y) = 1;
OutputActivityRatio(r,"RL1","RL","1",y) = 1;

** personal transport
InputActivityRatio(r,"TXD","DSL","1",y) = 1; 
InputActivityRatio(r,"TXE","ELC","1",y) = 1;
InputActivityRatio(r,"TXG","GSL","1",y) = 1;
# here you want to switch from energy to km travelled: km/TWh
OutputActivityRatio(r,"TXD","TX","1",y) = 1;
OutputActivityRatio(r,"TXE","TX","1",y) = 1;
OutputActivityRatio(r,"TXG","TX","1",y) = 1;

** industrial heating technologies
InputActivityRatio(r,"IHE","ELC","1",y) = 1;
InputActivityRatio(r,"IHG","GAS","1",y) = 1;
InputActivityRatio(r,"IHC","HCO","1",y) = 1;
# demand for industrial heating is thermal
OutputActivityRatio(r,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,"IHC","IH","1",y) = 1;

$endif.ph