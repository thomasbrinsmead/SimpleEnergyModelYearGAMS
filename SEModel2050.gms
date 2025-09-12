option solprint = off ;
*Simple electricity model.
*Version changes: date is 2050, add FOAK costs, add existing pumped hydro, additional REZ capacity from existing deployed recognised

Sets
*h hourly time interval in a single year / 1*8760/
h hourly time interval in a single year / 1*4380/
y projection year /2022*2055/
w weather year /2011*2023/
hhr half hourly over year /1*17568/
HMap(hhr,h) mapping half hourly to hourly
GenTech generation technology options /USCBlack,USCBlackCCS,CCGTgas,OCGTgas,CCGTgasCCS,RecipGas,RecipH2,SolLargePV,WindOn,WindOffFix,WindOffFloat,NucSMR,NucLarge/
FuelGenTech(GenTech) subset of GenTech which are fuel based technologies /USCBlack,USCBlackCCS,CCGTgas,OCGTgas,CCGTgasCCS,RecipGas,RecipH2,NucSMR,NucLarge/
PeakingGenTech(GenTech) subset of GenTech which are peaking based technologies /OCGTgas,RecipGas,RecipH2/
BLFossilGenTech(GenTech) subset of GenTech which are baseload gas technologies /USCBlack,USCBlackCCS,CCGTgas,CCGTgasCCS/
NuclearGenTech(GenTech) subset of GenTech which are nuclear technologies /NucSMR,NucLarge/
FossilGenTech(FuelGenTech) subset of GenTech which are fossil fuel based technologies /USCBlack,USCBlackCCS,CCGTgas,OCGTgas,CCGTgasCCS,RecipGas/
VREGenTech(GenTech) subset of GenTech which includes variable renewables /SolLargePV,WindOn,WindOffFix,WindOffFloat/
CCSGenTech(GenTech) subset of GenTech which store carbon dioxide /USCBlackCCS,CCGTgasCCS/
FOAKGenTech(GenTech) subset of Gentech that is subject to a FOAK premium /USCBlackCCS,CCGTgasCCS,WindOffFix,WindOffFloat,NucSMR,NucLarge/
ElecStoTech storage technology options where each technology has a defined duration /BattStor02,BattStor04,BattStor08,HydPump10,HydPump24,HydPump48,HydPump159/
BattElecStoTech(ElecStoTech) battery storage technology options /BattStor02,BattStor04,BattStor08/
CustBattElecStoTech(ElecStoTech) battery storage technology options /BattStor02,BattStor04/
PHESExisting(ElecStoTech) storage technology already deployed /HydPump10,HydPump159/
PHESSnowy2(ElecStoTech) storage technology already deployed /HydPump159/
*15 region regions
Region energy supply Regions available /NQ,CQ,SQ,GG,NNSW,CNSW,SNSW,SNW,NSA,CSA,SESA,WNV,MEL,SEV,TAS/
RegionD(Region) subset of regions that are demand regions /NQ,CQ,SQ,GG,NNSW,CNSW,SNSW,SNW,CSA,SESA,WNV,MEL,SEV,TAS/
*5 region regions
Region5 energy supply Regions available /NSW,VIC,QLD,SA,TAS/
RMap(Region,Region5) map of 15 and state regions /NQ.QLD,CQ.QLD,SQ.QLD,GG.QLD,NNSW.NSW,CNSW.NSW,SNSW.NSW,SNW.NSW,NSA.SA,CSA.SA,SESA.SA,WNV.VIC,MEL.VIC,SEV.VIC,TAS.TAS/
*Mapping and control sets
AllowGen(Region) allowable gernation regions
AllowFuelMap(FuelGenTech,Region) allowable fuels by region
AllowFuelMap5(FuelGenTech,Region5) allowable fuels by region
*TxAllowedSet(Region,RegionD) Prevents model considering expansion of non-viable transmission pathways
TxAllowedSet(Region,Region) Prevents model considering expansion of non-viable transmission pathways
*tsb
VREAllowedSet(VREGenTech,Region) Prevents model considering expansion of VRE capacity where no resource exists
StoAllowedSet(Region,ElecStoTech) Prevents model from building storage (particularly PHES) where it is not plausible
S scenarios /NOAKStageTech,CCS,Nuclear,OffshoreWind/
NOAKSet(S) subset of S /NOAKStageTech/
*tsb
cslist cost stack list /VRECapitalCost,PeakingCapitalCost,BLFossilCapitalCost,NuclearCapitalCost,StorageCost,OandMCost,IBRCost,ConnectCost,FuelCost,CCSCost,REZTranCost,OtherTranCost/
;
alias (y,Year);
alias (Region, Region_al, Region_al2);
*tsb

*Load data ____________________________________________________________________________________________________________________________________
*Loaded scalars
Scalars
dt fraction of one hour in which demand load and renewable profile data is stepped
DiscountRate discount rate or weighted cost of capital
GJperMWh gigjoules per MWh which is 3.6
EmissionIntensity the average greenhouse gas equivalent emission intensity of electricity over the year tCO2e per MWh
TxEconomicLife_Yrs transmission capacity cost amortisation period
TxConstructPeriod_Yrs transmission capacity construction period
ElecTxLossFactor transmission loss factor accounting for average electricity lost owing to transmission waste heat (between 0 and 1)
;

*Calculated scalars
Scalar
TxCapCostConversion converts transport capacity upfront costs to annual costs and accounts for interest lost during construction
;


*Model parameters-loaded
Parameters
ElecConvCapCost(GenTech) electricity conversion technology capital cost dollars per MW
RegGenCostFactor(Region,GenTech) regional cost factor for generation technologies
ElecStoCapCost(ElecStoTech) electricity storage capacity cost in dollars per MWh
RegStoCostFactor(Region,ElecStoTech) regional cost factor for storage technologies
*TxCapCost(Region,RegionD) transmission capacity cost in dollars per MW
TxCapCost(Region,Region_al) transmission capacity cost in dollars per MW
*tsb
REZTxCost(Region) REZ average transmission cost applicable to VRE capacity dollars per MW
*TxCapExisting(Region,RegionD) existing transmission capacity MW
TxCapExisting(Region,Region_al) existing transmission capacity MW
*tsb
Duration_Hrs(ElecStoTech) nameplate duration associated with each electricity storage technology
ElecConvEconomicLife_Yrs(GenTech) electricity conversion capacity cost amortisation period
ElecStoEconomicLife_Yrs(ElecStoTech) electricity storage capacity cost amortisation period
ElecConvConstructPeriod_Yrs(GenTech) capacity construction period
ElecStoConstructPeriod_Yrs(ElecStoTech) storage capacity cost construction period
FuelPrice(FuelGenTech) fuel price in dollars per GJ
FuelEfficiency(FuelGenTech) fuel efficiency expressed as the ratio of energy out per energy in
FuelConnectCost(FuelGenTech) fuel connetion cost in dollars per MW
CarbStoCost(CCSGenTech) CO2 storage cost dollars per MWh
ElecConvVariableOM(GenTech) electricity variable operating and maintenance costs dollars per MWh
ElecConvFixedOM(GenTech) electricity fixed operating and maintenance costs dollars per MW
ElecStoFixedOM(ElecStoTech) electricity storage fixed operating and maintenance costs dollars per MW
ElecConnectCost(GenTech,Region) electricity generator grid connection cost dollars per MW
IBRRemediationCost(GenTech) remediation cost for non-synchronous inverter based resources based on cost of synchronous condensers and grid forming inverters (zero otherwise) dollars per MW
ElecStoConnectCost(ElecStoTech,Region) electricity generator grid connection cost dollars per MW
RenCapMax(VREGenTech,Region) maximum renewable capacity that can be deployed by region (MW)
RenCapMax_Scenario(S,VREGenTech,Region) maximum renewable capacity that can be deployed by region by scenario (MW)
ElecStoEfficiency(ElecStoTech) round trip electricity storage efficiency
MinStableGen(FuelGenTech) minimum stable generation rate (between 0 and 1)
MaxAvailability(FuelGenTech) maximum annual availability rate (between 0 and 1)
OperatingReserve(Region5) the continuous operating reserve requirement in MW
OperatingReserve_Scenario(S,Region5) the continuous operating reserve requirement by scenario in MW
PeakContribution(VREGenTech,Region) the expected contribution of variable renewables at peak demand (between 0 and 1)
FuelEmissionFactor(FuelGenTech,Region) fuel emission factor in (tCO2e per GJ)
CaptureRate(FuelGenTech) carbon dioxide capture rate
ElecConvCapCostConversion(GenTech) converts electricity conversion capacity upfront costs to annual cost and accounts for interest lost during construction
ElecStoCapCostConversion(ElecStoTech) converts electricity storage capacity upfront costs to annual cost and accounts for interest lost during construction
HydroCap(Region) hydro capacity in MW
FOAKProjCap(GenTech,Region) capacity of FOAK projects deployed by region and technology in MW
FOAKProjCap_Scenario(S,GenTech,Region) capacity of FOAK projects deployed by region and technology and scenario in MW
FOAKProjCapCost(GenTech,Region) cost of the capacity of FOAK projects deployed dolars per MW
PHESProjCap(ElecStoTech,Region) capacity of PHES existing projects by region in MWh
ElecStoCapExisting(ElecStoTech,Region) existing electricity storage capacity in MWh
ElecConvCapExisting(GenTech,Region) existing electricity generation capacity in MW
ExistingCustBatt(ElecStoTech,Region) existing customer owned batteries in MW
*To be assigned in loop or set
PeakDemand(Region) the highest demand by region experienced across all hours
ElecDemand(Region,h) hourly demand profile data
VREprofile(VREGenTech,Region,h) hourly REZ profile data
HydroChar(Region,h) hourly hydro inflow
FuelAllowed_int(FuelGenTech,Region) one if the fuel type is allowed in that region
FuelAllowed_Scenario(S,FuelGenTech,Region) one if the fuel type is allowed in that region by scenario


*Not directly in model but used to assign data in loop
RezProf2050(w,VREGenTech,Region,h) hourly REZ profile data for 2050
DdProf2050(w,Region,h) hourly demand profile data for 2050
PeakDemandW(w,Region) the highest demand by region experienced in that weather year across all hours
HydroInflow(w,Region,h) hourly hydro inflow by weather year
;

*Report Variables
Parameters
RElecConvCap(S,GenTech,Region) electricity conversion technology capacity (MW)
RElecConvCapAll(S,GenTech,Region) electricity conversion technology capacity includnig existing capacity (MW)
RElecStoCap(S,ElecStoTech,Region) electricity storage capacity (MWh)
RElecStoCapAll(S,ElecStoTech,Region) electricity storage capacity includnig existing capacity (MWh)
RTxCap(S,Region,Region) new transmission capacity (MW)
RElecEnergyProd(S,GenTech,Region,h) hourly energy production (MW)
RElecRegionExport(S,Region,RegionD,h) total exported energy including storage discharge (GenTech in MW)
RElecStateofCharge(S,ElecStoTech,Region,h) electricity storage state of charge (MWh)
RElecDischar(S,ElecStoTech,Region,h) electricity storage discharge (MW)
RElecChar(S,ElecStoTech,Region,h) electricity storage charge (MW)
RHydroStateofCharge(S,Region,h) hydro state of charge (MWh)
RHydroDischar(S,Region,h) hydro discharge (MW)
GenMix(S,GenTech) generation mix national
GenMixS(S,GenTech,Region5) generation mix state
GenMixR(S,GenTech,Region) generation mix region
TotalGenerationS(S,Region5) total state generation
TotalGenerationR(S,Region) total regional generation
TechGenerationS(S,GenTech,Region5) total state gernation by technology
AverageCostR(S,Region) average energy cost of generation by region
MarginalCostHour1(S,Region,h) marginal cost on export balance
MarginalCostHour2(S,RegionD,h) marginal cost on deamnd balance
MarginalCost1(S,Region) annual hourly volume weighted marginal cost on export balance
MarginalCost2(S,RegionD) annual hourly volume weighted marginal cost on deamnd balance
RTotalCost(S) all costs of meeting demand for electricity in Australian dollars
TotalGeneration(S) total electricity geenration
AverageCost(S) average energy cost of generation
Coststack(S,cslist) averge system cost broken down by list of cost elements
CapacityFactor(S,GenTech) NEM capacity factors achieved by scenario
CapacityFactorR(S,Region,GenTech) regional capacity factors achieved by scenario
;

*Load gdx data
$gdxIn Data\DataUpLoad2050.gdx
$load dt
$load DiscountRate
$load GJperMWh
$load EmissionIntensity
$load TxEconomicLife_Yrs
$load TxConstructPeriod_Yrs
$load ElecTxLossFactor
$load ElecConvCapCostConversion
$load ElecStoCapCostConversion
$load TxCapCostConversion
$load DdProf2050
$load PeakDemandW
$load RezProf2050
$load ElecConvCapCost
$load RegGenCostFactor
$load ElecStoCapCost
$load RegStoCostFactor
$load TxCapCost
$load REZTxCost
$load TxCapExisting
$load Duration_Hrs
$load ElecConvEconomicLife_Yrs
$load ElecStoEconomicLife_Yrs
$load ElecConvConstructPeriod_Yrs
$load ElecStoConstructPeriod_Yrs
$load FuelPrice
$load FuelEfficiency
$Load FuelConnectCost
$load CarbStoCost
$load ElecConvVariableOM
$load ElecConvFixedOM
$load ElecStoFixedOM
$load ElecConnectCost
$load IBRRemediationCost
$load ElecStoConnectCost
$load RenCapMax
$load ElecStoEfficiency
$load MinStableGen
$load MaxAvailability
$load OperatingReserve
$load PeakContribution
$load FuelEmissionFactor
$load CaptureRate
$load HydroCap
$load HydroInflow
$Load FuelAllowed_int
$Load FOAKProjCap
$Load FOAKProjCapCost
$Load PHESProjCap
$Load ExistingCustBatt
$gdxin

*Assign existing storage
ElecStoCapExisting(PHESExisting,Region)=PHESProjCap(PHESExisting,Region);
ElecStoCapExisting(CustBattElecStoTech,Region)=ExistingCustBatt(CustBattElecStoTech,Region)*Duration_Hrs(CustBattElecStoTech);

*Assign technology scenariios
FuelAllowed_Scenario(S,FuelGenTech,Region)=FuelAllowed_int(FuelGenTech,Region);
RenCapMax_Scenario(S,VREGenTech,Region)=RenCapMax(VREGenTech,Region);
FOAKProjCap_Scenario(S,GenTech,Region)=FOAKProjCap(GenTech,Region);
OperatingReserve_Scenario(S,Region5)=OperatingReserve(Region5);
*NOAKStageTech only
FuelAllowed_Scenario('NOAKStageTech','USCBlackCCS',Region)=0;
FuelAllowed_Scenario('NOAKStageTech','CCGTgasCCS',Region)=0;
FuelAllowed_Scenario('NOAKStageTech','NucSMR',Region)=0;
FuelAllowed_Scenario('NOAKStageTech','NucLarge',Region)=0;
RenCapMax_Scenario('NOAKStageTech','WindOffFix',Region)=0;
RenCapMax_Scenario('NOAKStageTech','WindOffFloat',Region)=0;
FOAKProjCap_Scenario('NOAKStageTech',FOAKGenTech,Region)=0;
*CCS
FuelAllowed_Scenario('CCS','NucSMR',Region)=0;
FuelAllowed_Scenario('CCS','NucLarge',Region)=0;
RenCapMax_Scenario('CCS','WindOffFix',Region)=0;
RenCapMax_Scenario('CCS','WindOffFloat',Region)=0;
FOAKProjCap_Scenario('CCS','NucSMR',Region)=0;
FOAKProjCap_Scenario('CCS','NucLarge',Region)=0;
FOAKProjCap_Scenario('CCS','WindOffFix',Region)=0;
FOAKProjCap_Scenario('CCS','WindOffFloat',Region)=0;
*Nuclear
FuelAllowed_Scenario('Nuclear','USCBlackCCS',Region)=0;
FuelAllowed_Scenario('Nuclear','CCGTgasCCS',Region)=0;
RenCapMax_Scenario('Nuclear','WindOffFix',Region)=0;
RenCapMax_Scenario('Nuclear','WindOffFloat',Region)=0;
FOAKProjCap_Scenario('Nuclear','USCBlackCCS',Region)=0;
FOAKProjCap_Scenario('Nuclear','CCGTgasCCS',Region)=0;
FOAKProjCap_Scenario('Nuclear','WindOffFix',Region)=0;
FOAKProjCap_Scenario('Nuclear','WindOffFloat',Region)=0;
OperatingReserve_Scenario('Nuclear','NSW')=FOAKProjCap('NucLarge','CNSW');
OperatingReserve_Scenario('Nuclear','VIC')=FOAKProjCap('NucLarge','SEV');
OperatingReserve_Scenario('Nuclear','QLD')=FOAKProjCap('NucLarge','CNSW');
OperatingReserve_Scenario('Nuclear','SA')=FOAKProjCap('NucSMR','CSA')*0.5;
*Offshore wind
FuelAllowed_Scenario('OffshoreWind','USCBlackCCS',Region)=0;
FuelAllowed_Scenario('OffshoreWind','CCGTgasCCS',Region)=0;
FuelAllowed_Scenario('OffshoreWind','NucSMR',Region)=0;
FuelAllowed_Scenario('OffshoreWind','NucLarge',Region)=0;
FOAKProjCap_Scenario('OffshoreWind','NucSMR',Region)=0;
FOAKProjCap_Scenario('OffshoreWind','NucLarge',Region)=0;
FOAKProjCap_Scenario('OffshoreWind','USCBlackCCS',Region)=0;
FOAKProjCap_Scenario('OffshoreWind','CCGTgasCCS',Region)=0;

*Assign sets defined by loaded Parameters
TxCapCost("SNW","CNSW")=TxCapCost("CNSW","SNW");
TxCapCost("MEL","WNV")=TxCapCost("WNV","MEL");
TxAllowedSet(Region, Region_al)=yes$(TxCapCost(Region, Region_al)>1);
*tsb
*TxAllowedSet(Region,RegionD)=yes$TxCapCost(Region,RegionD);
StoAllowedSet(Region,ElecStoTech)=yes$RegStoCostFactor(Region,ElecStoTech);
AllowFuelMap(FuelGenTech,Region)=yes$FuelAllowed_int(FuelGenTech,Region);


Positive Variables
ElecConvCap(GenTech,Region) electricity conversion technology capacity (MW)
ElecStoCap(ElecStoTech,Region) electricity storage capacity (MWh)
TxCap(Region,Region) new transmission capacity (MW)
ElecEnergyProd(GenTech,Region,h) hourly energy production (MW)
*ElecRegionExport(Region,RegionD,h) total exported energy including storage discharge (GenTech in MW)      tsb
ElecRegionExport(Region,Region_al,h) total exported energy including storage discharge (GenTech in MW)
ElecStateofCharge(ElecStoTech,Region,h) electricity storage state of charge (MWh)
ElecDischar(ElecStoTech,Region,h) electricity storage discharge (MW)
ElecChar(ElecStoTech,Region,h) electricity storage charge (MW)
HydroStateofCharge(Region,h) hydro state of charge (MWh)
HydroDischar(Region,h) hydro discharge (MW)
;



Variable
TotalCost all costs of meeting demand for electricity in Australian dollars
;

Equations
Obj objective function
ConElecExportLimit(Region,h) Maximum regional exports and regional energy supply-demand balance constraint
*ConElecDemandSupplyBalance(RegionD,h) Total demand-supply balance
ConElecDemandSupplyBalance(Region,h) Total demand-supply balance
*tsb
ConVREGenDefinition(VREGenTech,Region,h) Variable electricity generation defined
ConMaxFuelElecProd(FuelGenTech,Region,h) Maximum instantaneous electricity production
ConMinFuelElecProd(FuelGenTech,Region,h) Minimum instantaneous electricity production
ConMaxAnnFuelElecProd(FuelGenTech,Region) Maximum annual availability
ConElecStateOfChargeBalance(ElecStoTech,Region,h) State of charge balance
ConMaxElecStateOfCharge(ElecStoTech,Region,h) Maximum state of charge constraint
ConMaxElecDischarSoC(ElecStoTech,Region,h) Maximum discharge constraint on state of charge
ConMaxElecDischarPower(ElecStoTech,Region,h) Maximum discharge constraint on power rating
ConMaxElecCharPower(ElecStoTech,Region,h) Charge cannot exceed power capacity of storage
ConMaxPHES159 Disallowing any additional 159 hour duration projects besides Snowy2.0
ConHydroStateOfChargeBalance(Region,h) State of charge balance hydro
ConStoNetSOC(ElecStoTech,Region) Storage round trip state of charge is constant
*tsb
ConHydroInitSoC(Region) hydro iniital state of charge
ConMaxHydroDischarSoC(Region,h) Maximum discharge constraint on state of charge hydro
ConMaxHydroDischarPower(Region,h) Maximum discharge constraint on power rating hydro
ConMaxElecTx(Region, Region_al,h) Maximum transmission constraint
ConTxSymmetry(Region, Region_al) New transmission symmetry
*tsb
*ConMaxElecTx(Region,RegionD,h) Maximum transmission constraint
*ConTxSymmetry(Region,RegionD) New transmission symmetry
ConMaxRen(VREGenTech,Region) Maximum renewable deployment constraint
ConMaxEmisIntensity Maximum average emission intensity of annual electricity generation
ConReserveMargin(Region5) Reserve margin constraint Option 2
;

Obj.. TotalCost =e=
sum((GenTech,Region),ElecConvCap(GenTech,Region) * (ElecConvCapCost(GenTech) * RegGenCostFactor(Region,GenTech) + ElecConnectCost(GenTech,Region) + IBRRemediationCost(GenTech)) * ElecConvCapCostConversion(GenTech) ) +
sum((ElecStoTech,Region),ElecStoCap(ElecStoTech,Region) * (ElecStoCapCost(ElecStoTech) * RegStoCostFactor(Region,ElecStoTech) + (ElecStoConnectCost(ElecStoTech,Region)/Duration_Hrs(ElecStoTech))) * ElecStoCapCostConversion(ElecStoTech) ) +
sum((FuelGenTech,Region,h), ElecEnergyProd(FuelGenTech,Region,h) * dt * FuelPrice(FuelGenTech) /FuelEfficiency(FuelGenTech) * GJperMWh ) +
Sum((FuelGenTech,Region), FuelConnectCost(FuelGenTech) * ElecConvCap(FuelGenTech,Region) * ElecConvCapCostConversion(FuelGenTech)) +
sum((GenTech,Region,h),ElecConvVariableOM(GenTech) * ElecEnergyProd(GenTech,Region,h) * dt) + sum((GenTech,Region),ElecConvFixedOM(GenTech) * ElecConvCap(GenTech,Region) ) +
sum((CCSGenTech,Region,h),CarbStoCost(CCSGenTech) * ElecEnergyProd(CCSGenTech,Region,h) * dt)+
sum((VREGenTech,Region),REZTxCost(Region) * ElecConvCap(VREGenTech,Region) * TxCapCostConversion)+
sum((ElecStoTech,Region),ElecStoFixedOM(ElecStoTech) / Duration_Hrs(ElecStoTech) * (ElecStoCap(ElecStoTech,Region) + 0*ElecStoCapExisting(ElecStoTech,Region))) +
*tsb
*sum((ElecStoTech,Region),ElecStoFixedOM(ElecStoTech) / Duration_Hrs(ElecStoTech) * ElecStoCap(ElecStoTech,Region)) +
Sum((Region, Region_al),TxCap(Region, Region_al) * TxCapCost(Region, Region_al) * TxCapCostConversion) +
*Sum((Region,RegionD),TxCap(Region,RegionD) * TxCapCost(Region,RegionD) * TxCapCostConversion) +
Sum((GenTech,Region), FOAKProjCap(GenTech,Region) * FOAKProjCapCost(GenTech,Region) * ElecConvCapCostConversion(GenTech)) + sum((GenTech,Region),FOAKProjCap(GenTech,Region) * ElecConvFixedOM(GenTech));

*ConElecExportLimit(Region,h).. Sum(RegionD,ElecRegionExport(Region,RegionD,h)) =l= sum(GenTech,ElecEnergyProd(GenTech,Region,h)) + HydroDischar(Region,h) + sum(ElecStoTech,ElecDischar(ElecStoTech,Region,h)) - sum(ElecStoTech, ElecChar(ElecStoTech,Region,h) );
ConElecExportLimit(Region,h).. Sum(Region_al,ElecRegionExport(Region, Region_al,h))                   +  ElecDemand(Region,h)/(1-ElecTxLossFactor)
                                         =l= sum(  Region_al2,ElecRegionExport( Region_al2,Region,h )  ) * (1-ElecTxLossFactor) + sum( GenTech,ElecEnergyProd(GenTech,Region,h) )+
                                                 HydroDischar(Region,h) + sum(ElecStoTech,ElecDischar(ElecStoTech,Region,h)) - sum(ElecStoTech, ElecChar(ElecStoTech,Region,h) );

*ConElecDemandSupplyBalance(RegionD,h).. Sum(Region,ElecRegionExport(Region,RegionD,h) * (1-ElecTxLossFactor)) =g= ElecDemand(RegionD,h);
ConElecDemandSupplyBalance(Region,h).. ElecRegionExport(Region, Region,h) =e= 0;

ConVREGenDefinition(VREGenTech,Region,h).. ElecEnergyProd(VREGenTech,Region,h) =e= VREprofile(VREGenTech,Region,h) * (ElecConvCap(VREGenTech,Region) + ElecConvCapExisting(VREGenTech,Region));

ConMaxFuelElecProd(FuelGenTech,Region,h).. ElecEnergyProd(FuelGenTech,Region,h) =l= ElecConvCap(FuelGenTech,Region)$AllowFuelMap(FuelGenTech,Region) + ElecConvCapExisting(FuelGenTech,Region);

ConMinFuelElecProd(FuelGenTech,Region,h).. (ElecConvCap(FuelGenTech,Region) + ElecConvCapExisting(FuelGenTech,Region)) * MinStableGen(FuelGenTech) =l= ElecEnergyProd(FuelGenTech,Region,h);

ConMaxAnnFuelElecProd(FuelGenTech,Region).. Sum(h,ElecEnergyProd(FuelGenTech,Region,h) * dt) =l= MaxAvailability(FuelGenTech) * (ElecConvCap(FuelGenTech,Region) + ElecConvCapExisting(FuelGenTech,Region)) * 8760;

ConElecStateOfChargeBalance(ElecStoTech,Region,h).. ElecStateofCharge(ElecStoTech,Region,h+1) =e= ElecStateofCharge(ElecStoTech,Region,h)+ ElecStoEfficiency(ElecStoTech)**(1/2) * ElecChar(ElecStoTech,Region,h) * dt - ElecStoEfficiency(ElecStoTech)**(-1/2) * ElecDischar(ElecStoTech,Region,h) * dt;

ConStoNetSOC(ElecStoTech,Region)..     ElecStateofCharge(ElecStoTech,Region,'84') + 0*ElecStoEfficiency(ElecStoTech)**(1/2) * ElecChar(ElecStoTech,Region,'84') * dt - 0*ElecStoEfficiency(ElecStoTech)**(-1/2) * ElecDischar(ElecStoTech,Region,'84') * dt=g= ElecStateofCharge(ElecStoTech,Region,'1');
*tsb

ConMaxElecStateOfCharge(ElecStoTech,Region,h).. ElecStateofCharge(ElecStoTech,Region,h) =l= ElecStoCap(ElecStoTech,Region)$StoAllowedSet(Region,ElecStoTech) + ElecStoCapExisting(ElecStoTech,Region);

ConMaxElecDischarSoC(ElecStoTech,Region,h).. ElecDischar(ElecStoTech,Region,h) =l= ElecStateofCharge(ElecStoTech,Region,h) / dt;

ConMaxElecDischarPower(ElecStoTech,Region,h).. ElecDischar(ElecStoTech,Region,h) =l= ElecStoCap(ElecStoTech,Region)$StoAllowedSet(Region,ElecStoTech) / Duration_Hrs(ElecStoTech) + ElecStoCapExisting(ElecStoTech,Region) / Duration_Hrs(ElecStoTech) ;

ConMaxElecCharPower(ElecStoTech,Region,h).. ElecChar(ElecStoTech,Region,h) =l= ElecStoCap(ElecStoTech,Region)$StoAllowedSet(Region,ElecStoTech) / Duration_Hrs(ElecStoTech) + ElecStoCapExisting(ElecStoTech,Region) / Duration_Hrs(ElecStoTech);

ConMaxPHES159.. ElecStoCap('HydPump159','SNSW') =e=0;

ConHydroInitSoC(Region).. HydroStateofCharge(Region,'1') =e= HydroChar(Region,'1') * dt;

ConHydroStateOfChargeBalance(Region,h).. HydroStateofCharge(Region,h+1) =l= HydroStateofCharge(Region,h) + HydroChar(Region,h) * dt - HydroDischar(Region,h) * dt;

ConMaxHydroDischarSoC(Region,h).. HydroDischar(Region,h) =l= HydroStateofCharge(Region,h) / dt;

ConMaxHydroDischarPower(Region,h).. HydroDischar(Region,h) =l= HydroCap(Region);

*ConMaxElecTx(Region,RegionD,h).. ElecRegionExport(Region,RegionD,h) =l= TxCap(Region,RegionD)$TxAllowedSet(Region,RegionD) + TxCapExisting(Region,RegionD);

*ConTxSymmetry(Region,RegionD).. TxCap(Region,RegionD) =e= TxCap(RegionD,Region);

ConMaxElecTx(Region, Region_al,h).. ElecRegionExport(Region, Region_al,h)*(1-ElecTxLossFactor) =l= TxCap(Region, Region_al)$TxAllowedSet(Region, Region_al) + TxCapExisting(Region, Region_al);

ConTxSymmetry(Region, Region_al).. TxCap(Region, Region_al) =e= TxCap(Region_al,Region);
*tsb
ConMaxRen(VREGenTech,Region).. ElecConvCap(VREGenTech,Region) =l= RenCapMax(VREGenTech,Region);

ConMaxEmisIntensity.. Sum((FossilGenTech,Region,h),ElecEnergyProd(FossilGenTech,Region,h) * dt * (1-CaptureRate(FossilGenTech)) * FuelEmissionFactor(FossilGenTech,Region) * GJperMWh / FuelEfficiency(FossilGenTech) ) =l= EmissionIntensity * sum((RegionD,h),ElecDemand(RegionD,h) * dt / (1-ElecTxLossFactor));

ConReserveMargin(Region5).. OperatingReserve(Region5) =l= sum(Region$RMap(Region,Region5),
Sum(FuelGenTech,ElecConvCap(FuelGenTech,Region)+ElecConvCapExisting(FuelGenTech,Region)) + sum(VREGenTech,PeakContribution(VREGenTech,Region) * (ElecConvCap(VREGenTech,Region)+ElecConvCapExisting(VREGenTech,Region))) +
 HydroCap(Region) + sum(ElecStoTech,(ElecStoCap(ElecStoTech,Region)$StoAllowedSet(Region,ElecStoTech)+ElecStoCapExisting(ElecStoTech,Region))/Duration_Hrs(ElecStoTech))-PeakDemand(Region) );



Model SEM1 /
Obj,
ConElecExportLimit,
ConElecDemandSupplyBalance,
ConVREGenDefinition,
ConMaxFuelElecProd,
ConMinFuelElecProd,
ConMaxAnnFuelElecProd,
ConElecStateOfChargeBalance,
ConMaxElecStateOfCharge,
ConMaxElecDischarSoC,
ConMaxElecDischarPower,
ConMaxElecCharPower,
ConMaxPHES159,
ConHydroInitSoC,
ConHydroStateOfChargeBalance,
ConStoNetSOC,
*tsb
ConMaxHydroDischarSoC,
ConMaxHydroDischarPower,
ConMaxElecTx,
ConTxSymmetry,
ConMaxRen,
ConMaxEmisIntensity,
ConReserveMargin
/;
Option lp=cplex;
SEM1.optfile = 1;

*Assigning weather year 2011
ElecDemand(Region,h)=DdProf2050('2011',Region,h);
VREprofile(VREGenTech,Region,h)=RezProf2050('2011',VREGenTech,Region,h);
PeakDemand(Region)=PeakDemandW('2011',Region);
HydroChar(Region,h)=HydroInflow('2011',Region,h);

HydroStateofCharge.l(Region,'1')=HydroInflow('2011',Region,'1');
Loop(h,
HydroStateofCharge.l(Region,h+1)=HydroStateofCharge.l(Region,h)+HydroInflow('2011',Region,h);
);
*Loop through scenarios
Loop(S$NOAKSet(S),
FuelAllowed_int(FuelGenTech,Region)=FuelAllowed_Scenario(S,FuelGenTech,Region);
RenCapMax(VREGenTech,Region)=RenCapMax_Scenario(S,VREGenTech,Region);
FOAKProjCap(GenTech,Region)=FOAKProjCap_Scenario(S,GenTech,Region);
ElecConvCapExisting(GenTech,Region)=FOAKProjCap_Scenario(S,GenTech,Region);
AllowFuelMap(FuelGenTech,Region)=yes$FuelAllowed_int(FuelGenTech,Region);
OperatingReserve(Region5)=OperatingReserve_Scenario(S,Region5);

solve SEM1 using lp minimizing TotalCost;

*Capture model variable values
RElecConvCap(S,GenTech,Region)=ElecConvCap.l(GenTech,Region);
RElecConvCapAll(S,GenTech,Region)=ElecConvCap.l(GenTech,Region) + ElecConvCapExisting(GenTech,Region);
RElecStoCap(S,ElecStoTech,Region)=ElecStoCap.l(ElecStoTech,Region);
RElecStoCapAll(S,ElecStoTech,Region)=ElecStoCap.l(ElecStoTech,Region) + ElecStoCapExisting(ElecStoTech,Region);
RTxCap(S,Region,RegionD)=TxCap.l(Region,RegionD);
RElecEnergyProd(S,GenTech,Region,h)=ElecEnergyProd.l(GenTech,Region,h);
RElecRegionExport(S,Region,RegionD,h)=ElecRegionExport.l(Region,RegionD,h);
RElecStateofCharge(S,ElecStoTech,Region,h)=ElecStateofCharge.l(ElecStoTech,Region,h);
RElecDischar(S,ElecStoTech,Region,h)=ElecDischar.l(ElecStoTech,Region,h);
RElecChar(S,ElecStoTech,Region,h)=ElecChar.l(ElecStoTech,Region,h);
RHydroStateofCharge(S,Region,h)=HydroStateofCharge.l(Region,h);
RHydroDischar(S,Region,h)=HydroDischar.l(Region,h);
MarginalCostHour1(S,Region,h)=ConElecExportLimit.m(Region,h);
MarginalCostHour2(S,RegionD,h)=ConElecDemandSupplyBalance.m(RegionD,h);
RTotalCost(S)=TotalCost.l;
);

*Calculate additional reporting variables
TotalGeneration(S)=sum((GenTech,Region,h),RElecEnergyProd(S,GenTech,Region,h) * dt) + sum((Region,h),RHydroDischar(S,Region,h) * dt);
GenMix(S,GenTech)$TotalGeneration(S)=sum((Region,h),RElecEnergyProd(S,GenTech,Region,h) * dt)/TotalGeneration(S);
Loop(Region5,
TotalGenerationS(S,Region5)=sum((GenTech,Region,h)$RMAP(Region,Region5),RElecEnergyProd(S,GenTech,Region,h) * dt) + sum((Region,h)$RMAP(Region,Region5),RHydroDischar(S,Region,h) * dt);
TechGenerationS(S,GenTech,Region5)=sum((Region,h)$RMAP(Region,Region5),RElecEnergyProd(S,GenTech,Region,h) * dt);
);
GenMixS(S,GenTech,Region5)$TotalGenerationS(S,Region5)=TechGenerationS(S,GenTech,Region5)/TotalGenerationS(S,Region5);
TotalGenerationR(S,Region)=sum((GenTech,h),RElecEnergyProd(S,GenTech,Region,h) * dt) + sum(h,RHydroDischar(S,Region,h) * dt);
GenMixR(S,GenTech,Region)$TotalGenerationR(S,Region)=sum(h,RElecEnergyProd(S,GenTech,Region,h) * dt)/TotalGenerationR(S,Region);

AverageCost(S)$TotalGeneration(S)=(
sum((GenTech,Region),RElecConvCap(S,GenTech,Region) * (ElecConvCapCost(GenTech) * RegGenCostFactor(Region,GenTech) + ElecConnectCost(GenTech,Region) + IBRRemediationCost(GenTech)) * ElecConvCapCostConversion(GenTech) ) +
sum((ElecStoTech,Region),RElecStoCap(S,ElecStoTech,Region) * (ElecStoCapCost(ElecStoTech) * RegStoCostFactor(Region,ElecStoTech) + (ElecStoConnectCost(ElecStoTech,Region)/Duration_Hrs(ElecStoTech))) * ElecStoCapCostConversion(ElecStoTech) ) +
sum((FuelGenTech,Region,h), RElecEnergyProd(S,FuelGenTech,Region,h) * dt * FuelPrice(FuelGenTech) /FuelEfficiency(FuelGenTech) * GJperMWh ) +
Sum((FuelGenTech,Region), FuelConnectCost(FuelGenTech) * RElecConvCap(S,FuelGenTech,Region) * ElecConvCapCostConversion(FuelGenTech)) +
sum((GenTech,Region,h),ElecConvVariableOM(GenTech) * RElecEnergyProd(S,GenTech,Region,h) * dt) + sum((GenTech,Region),ElecConvFixedOM(GenTech) * RElecConvCap(S,GenTech,Region) ) +
sum((CCSGenTech,Region,h),CarbStoCost(CCSGenTech) * RElecEnergyProd(S,CCSGenTech,Region,h) * dt)+
sum((VREGenTech,Region),REZTxCost(Region) * RElecConvCap(S,VREGenTech,Region) * TxCapCostConversion)+
sum((ElecStoTech,Region),ElecStoFixedOM(ElecStoTech) / Duration_Hrs(ElecStoTech) * RElecStoCap(S,ElecStoTech,Region)) +
Sum((Region,RegionD),RTxCap(S,Region,RegionD) * TxCapCost(Region,RegionD) * TxCapCostConversion) +
Sum((GenTech,Region), FOAKProjCap_Scenario(S,GenTech,Region) * FOAKProjCapCost(GenTech,Region) * ElecConvCapCostConversion(GenTech)) + sum((GenTech,Region),FOAKProjCap_Scenario(S,GenTech,Region) * ElecConvFixedOM(GenTech))
)/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);

MarginalCost1(S,Region)$TotalGenerationR(S,Region)=sum(h,MarginalCostHour1(S,Region,h)*sum(Gentech,RElecEnergyProd(S,GenTech,Region,h) * dt) )/(TotalGenerationR(S,Region) - sum(h,RHydroDischar(S,Region,h)*dt) );
MarginalCost2(S,RegionD)$TotalGenerationR(S,RegionD)=sum(h,MarginalCostHour2(S,RegionD,h)*sum(Gentech,RElecEnergyProd(S,GenTech,RegionD,h) * dt) )/(TotalGenerationR(S,RegionD) - sum(h,RHydroDischar(S,RegionD,h)*dt) );



CostStack(S,'VRECapitalCost')=(sum((VREGenTech,Region),RElecConvCap(S,VREGenTech,Region) * ElecConvCapCost(VREGenTech) * RegGenCostFactor(Region,VREGenTech) * ElecConvCapCostConversion(VREGenTech) ) +
                               Sum((VREGenTech,Region), FOAKProjCap_Scenario(S,VREGenTech,Region) * FOAKProjCapCost(VREGenTech,Region) * ElecConvCapCostConversion(VREGenTech)))/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'PeakingCapitalCost')=(sum((PeakingGenTech,Region),RElecConvCap(S,PeakingGenTech,Region) * ElecConvCapCost(PeakingGenTech) * RegGenCostFactor(Region,PeakingGenTech)  * ElecConvCapCostConversion(PeakingGenTech) ) +
                                   Sum((PeakingGenTech,Region), FOAKProjCap_Scenario(S,PeakingGenTech,Region) * FOAKProjCapCost(PeakingGenTech,Region) * ElecConvCapCostConversion(PeakingGenTech)))/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'BLFossilCapitalCost')=(sum((BLFossilGenTech,Region),RElecConvCap(S,BLFossilGenTech,Region) * ElecConvCapCost(BLFossilGenTech) * RegGenCostFactor(Region,BLFossilGenTech) * ElecConvCapCostConversion(BLFossilGenTech) ) +
                                 Sum((BLFossilGenTech,Region), FOAKProjCap_Scenario(S,BLFossilGenTech,Region) * FOAKProjCapCost(BLFossilGenTech,Region) * ElecConvCapCostConversion(BLFossilGenTech)))/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'NuclearCapitalCost')=(sum((NuclearGenTech,Region),RElecConvCap(S,NuclearGenTech,Region) * ElecConvCapCost(NuclearGenTech) * RegGenCostFactor(Region,NuclearGenTech) * ElecConvCapCostConversion(NuclearGenTech) ) +
                                   Sum((NuclearGenTech,Region), FOAKProjCap_Scenario(S,NuclearGenTech,Region) * FOAKProjCapCost(NuclearGenTech,Region) * ElecConvCapCostConversion(NuclearGenTech)))/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'StorageCost')=(sum((ElecStoTech,Region),RElecStoCap(S,ElecStoTech,Region) * (ElecStoCapCost(ElecStoTech) * RegStoCostFactor(Region,ElecStoTech) + (ElecStoConnectCost(ElecStoTech,Region)/Duration_Hrs(ElecStoTech))) * ElecStoCapCostConversion(ElecStoTech) )+
                            sum((ElecStoTech,Region),ElecStoFixedOM(ElecStoTech) / Duration_Hrs(ElecStoTech) * RElecStoCapAll(S,ElecStoTech,Region)) )/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
*tsb ElecStoCapAll to ElecStoCap for fixed OM
CostStack(S,'OandMCost')=(sum((GenTech,Region,h),ElecConvVariableOM(GenTech) * RElecEnergyProd(S,GenTech,Region,h) * dt) +
                          sum((GenTech,Region),ElecConvFixedOM(GenTech) * RElecConvCap(S,GenTech,Region)) + sum((GenTech,Region),FOAKProjCap_Scenario(S,GenTech,Region) * ElecConvFixedOM(GenTech)) )/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'IBRCost')=sum((VREGenTech,Region),RElecConvCap(S,VREGenTech,Region) * IBRRemediationCost(VREGenTech) * ElecConvCapCostConversion(VREGenTech) )/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'ConnectCost')=sum((GenTech,Region),RElecConvCap(S,GenTech,Region) * ElecConnectCost(GenTech,Region) * ElecConvCapCostConversion(GenTech) )/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'FuelCost')=(sum((FuelGenTech,Region,h), RElecEnergyProd(S,FuelGenTech,Region,h) * dt * FuelPrice(FuelGenTech) /FuelEfficiency(FuelGenTech) * GJperMWh ) +
                         Sum((FuelGenTech,Region), FuelConnectCost(FuelGenTech) * RElecConvCap(S,FuelGenTech,Region) * ElecConvCapCostConversion(FuelGenTech)) )/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'CCSCost')=sum((CCSGenTech,Region,h),CarbStoCost(CCSGenTech) * RElecEnergyProd(S,CCSGenTech,Region,h) * dt)/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'REZTranCost')=sum((VREGenTech,Region),REZTxCost(Region) * RElecConvCap(S,VREGenTech,Region) * TxCapCostConversion)/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);
CostStack(S,'OtherTranCost')=Sum((Region,RegionD),RTxCap(S,Region,RegionD) * TxCapCost(Region,RegionD) * TxCapCostConversion)/(sum((Region,h),ElecDemand(Region,h)) / (1-ElecTxLossFactor) * dt);

CapacityFactor(S,GenTech)$(sum(Region,RElecConvCapAll(S,GenTech,Region)) gt 0)=sum((Region,h),RElecEnergyProd(S,GenTech,Region,h)*dt)/sum(Region,(RElecConvCapAll(S,GenTech,Region)*8760));
CapacityFactorR(S,Region,GenTech)$RElecConvCapAll(S,GenTech,Region)=sum(h,RElecEnergyProd(S,GenTech,Region,h)*dt)/(RElecConvCapAll(S,GenTech,Region)*8760);

execute_unload 'Output\Report'
RTotalCost,
RElecConvCap,
RElecStoCap,
RElecConvCapAll,
RElecStoCapAll,
RTxCap,
RElecEnergyProd,
RElecRegionExport,
RElecStateofCharge,
RElecDischar,
RElecChar,
RHydroStateofCharge,
RHydroDischar,
TotalGeneration,
TotalGenerationS,
TotalGenerationR,
GenMix,
GenMixS,
GenMixR,
AverageCost,
MarginalCostHour1,
MarginalCostHour2,
MarginalCost1,
MarginalCost2,
CostStack,
CapacityFactor,
CapacityFactorR
;

execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RElecConvCapAll rng=ElecConvCap!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RElecStoCapAll rng=ElecStoCap!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RTxCap rng=TxCap!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RElecEnergyProd rng=ElecEnergyProd!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RElecRegionExport rng=ElecRegionExport!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RElecStateofCharge rng=ElecStateofCharge!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=RElecDischar rng=ElecDischar!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=GenMix rng=GenMix!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=GenMixS rng=GenMixS!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=GenMixR rng=GenMixR!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=AverageCost rng=AverageCost!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=MarginalCostHour1 rng=MarginalCostHour1!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=MarginalCostHour2 rng=MarginalCostHour2!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=MarginalCost1 rng=MarginalCost1!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=MarginalCost2 rng=MarginalCost2!";
execute "=gdxxrw.exe Output\Report.gdx o=Output\Results.xlsx par=CostStack rng=CostStack!";





