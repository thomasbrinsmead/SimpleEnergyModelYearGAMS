*Simple electricity model. Code for loading all data
Sets
h hourly time interval in a single year / 1*4380/
y projection year /2022*2055/
w weather year /2011*2023/
hhr half hourly time intervals over a year /1*17568/
HMap(hhr,h) mapping half hourly to hourly
GenTech generation technology options /USCBlack,USCBlackCCS,CCGTgas,OCGTgas,CCGTgasCCS,RecipGas,RecipH2,SolLargePV,WindOn,WindOffFix,WindOffFloat,NucSMR,NucLarge/
FuelGenTech(GenTech) subset of GenTech which are fuel based technologies USCBlack /USCBlack,USCBlackCCS,CCGTgas,OCGTgas,CCGTgasCCS,RecipGas,RecipH2,NucSMR,NucLarge/
FossilGenTech(FuelGenTech) subset of GenTech which are fossil fuel based technologies /USCBlack,USCBlackCCS,CCGTgas,OCGTgas,CCGTgasCCS,RecipGas/
VREGenTech(GenTech) subset of GenTech which includes variable renewables /SolLargePV,WindOn,WindOffFix,WindOffFloat/
CCSGenTech(GenTech) subset of GenTech which store carbon dioxide /USCBlackCCS,CCGTgasCCS/
ElecStoTech storage technology options where each technology has a defined duration /BattStor02,BattStor04,BattStor08,HydPump10,HydPump24,HydPump48,HydPump159/
BattElecStoTech(ElecStoTech) battery storage technology options /BattStor02,BattStor04,BattStor08/
*15 region regions
Region energy supply Regions available /NQ,CQ,SQ,GG,NNSW,CNSW,SNSW,SNW,NSA,CSA,SESA,WNV,MEL,SEV,TAS/
RegionD(Region) subset of regions that are demand regions /NQ,CQ,SQ,GG,NNSW,CNSW,SNSW,SNW,NSA,CSA,SESA,WNV,MEL,SEV,TAS/
*5 region regions
Region5 energy supply Regions available /NSW,VIC,QLD,SA,TAS/
*Mapping and control sets
RMap(Region5,Region) region 5 to 15 mapping
AllowFuelMap(FuelGenTech,Region) allowable fuels by region
AllowFuelMap5(FuelGenTech,Region5) allowable fuels by region
TxAllowedSet(Region,RegionD) Prevents model considering expansion of non-viable transmission pathways
VREAllowedSet(VREGenTech,Region) Prevents model considering expansion of VRE capacity where no resource exists
StoAllowedSet(Region,ElecStoTech) Prevents model from building storage (particularly PHES) where it is not plausible
scalist /scal1*scal7/
;

alias (y,Year);

*Load data ____________________________________________________________________________________________________________________________________
*Loaded scalars
Scalars
dt fraction of one hour in which demand load and renewable profile data is stepped
DiscountRate discount rate or weighted cost of capital
GJperMWh gigjoules per MWh which is 3.6
FossilEnergyShare the maximum annual share of fossil fuel energy between 0 and 1
EmissionIntensity the average greenhouse gas equivalent emission intensity of electricity over the year tCO2e per MWh
TxEconomicLife_Yrs transmission capacity cost amortisation period
TxConstructPeriod_Yrs transmission capacity construction period
ElecTxLossFactor transmission loss factor accounting for average electricity lost owing to transmission waste heat (between 0 and 1)
;

*Calculated scalars
Scalar
TxCapCostConversion converts transport capacity upfront costs to annual costs and accounts for interest lost during construction
;

*Intermediate parameters not used in model but required as intermediate step
Parameters
ScalData(scalist) parameter for collecting a list scalar data from Excel
ElecConvCapCost_int(GenTech,y) electricity conversion technology capital cost dollars per MW by year
ElecStoCapCost_int(ElecStoTech,y) electricity storage capacity cost in dollars per MWh by year
TxCapCost_int(Region,RegionD,y) transmission capacity cost in dollars per MW by year
FuelPrice_int(FuelGenTech,y) fuel price in dollars per GJ
ElecConnectCostVRE_int(Region) electricity generator grid connection cost dollars per MW
ElecConnectCostNonVRE_int(Region5) electricity generator grid connection cost dollars per MW
IBRRemediationCostVRE_int(y) remediation cost for non-synchronous inverter based resources based on cost of synchronous condensers and grid forming inverters (zero otherwise) dollars per MW
ElecStoConnectCostBatt_int(Region5) electricity generator grid connection cost dollars per MW
PeakContribution_int(VREGenTech,Region5) the expected contribution of variable renewables at peak demand (between 0 and 1)
GenAllowed_int(Region) one if generation is allowed in that region
FuelAllowed_int(FuelGenTech,Region) one if the fuel type is allowed in that region
FuelEmissionFactor5_int(FuelGenTech,Region5) fuel emission factor in (tCO2e per GJ)
CFAdjust_int(Region,w) adjustment for high capacity factor wind resources
DdProfAll(w,Region,Year,hhr) demand profile data
REZProf2011(VREGenTech,Region,Year,hhr) 2011 REZ profile data
REZProf2012(VREGenTech,Region,Year,hhr) 2012 REZ profile data
REZProf2013(VREGenTech,Region,Year,hhr) 2013 REZ profile data
REZProf2014(VREGenTech,Region,Year,hhr) 2014 REZ profile data
REZProf2015(VREGenTech,Region,Year,hhr) 2015 REZ profile data
REZProf2016(VREGenTech,Region,Year,hhr) 2016 REZ profile data
REZProf2017(VREGenTech,Region,Year,hhr) 2017 REZ profile data
REZProf2018(VREGenTech,Region,Year,hhr) 2018 REZ profile data
REZProf2019(VREGenTech,Region,Year,hhr) 2019 REZ profile data
REZProf2020(VREGenTech,Region,Year,hhr) 2020 REZ profile data
REZProf2021(VREGenTech,Region,Year,hhr) 2021 REZ profile data
REZProf2022(VREGenTech,Region,Year,hhr) 2022 REZ profile data
REZProf2023(VREGenTech,Region,Year,hhr) 2023 REZ profile data
RezProfAll2050(w,VREGenTech,Region,hhr) REZ profile data for 2050
RezProf2050(w,VREGenTech,Region,h) hourly REZ profile data for 2050
DdProfAll2050(w,Region,hhr) demand profile data for 2050
DdProf2050(w,Region,h) hourly demand profile data for 2050
HydroInflowhhr(w,hhr,Region) half hourly hydro inflow by weather year
HydroInflow(w,Region,h) hourly hydro inflow by weather year
;

*Model parameters-loaded
Parameters
ElecConvCapCost(GenTech) electricity conversion technology capital cost dollars per MW
RegGenCostFactor(Region,GenTech) regional cost factor for generation technologies
ElecStoCapCost(ElecStoTech) electricity storage capacity cost in dollars per MWh
RegStoCostFactor(Region,ElecStoTech) regional cost factor for storage technologies
TxCapCost(Region,RegionD) transmission capacity cost in dollars per MW
REZTxCost(Region) REZ average transmission cost applicable to VRE capacity dollars per MW
TxCapExisting(Region,RegionD) existing transmission capacity MW
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
RenCapMax(VREGenTech,Region) maximum renewable capacity that can be deployed by region in MW
ElecStoEfficiency(ElecStoTech) round trip electricity storage efficiency
MinStableGen(FuelGenTech) minimum stable generation rate (between 0 and 1)
MaxAvailability(FuelGenTech) maximum annual availability rate (between 0 and 1)
OperatingReserve(Region5) the continuous operating reserve requirement in MW
PeakContribution(VREGenTech,Region) the expected contribution of variable renewables at peak demand (between 0 and 1)
FuelEmissionFactor(FuelGenTech,Region) fuel emission factor in (tCO2e per GJ)
CaptureRate(FuelGenTech) carbon dioxide capture rate
VREprofile(VREGenTech,Region,h) variable renewable generation profile in MWs per MW
ElecDemand(RegionD,h) electricity demand
HydroCap(Region) hydro capacity in MW
ElecConvCapExisting(GenTech,Region) existing nuclear capacity by region in MW
FOAKProjCap(GenTech,Region) capacity of FOAK projects deployed by region and technology in MW
FOAKProjCapCost(GenTech,Region) cost of the capacity of FOAK projects deployed dolars per MW
PHESProjCap(ElecStoTech,Region) capacity of PHES existing projects by region in MWh
ExistingCustBatt(ElecStoTech,Region) existing customer owned batteries MW
;

* Model parameters-Calculated
Parameters
ElecConvCapCostConversion(GenTech) converts electricity conversion capacity upfront costs to annual cost and accounts for interest lost during construction
ElecStoCapCostConversion(ElecStoTech) converts electricity storage capacity upfront costs to annual cost and accounts for interest lost during construction
PeakDemandW(w,Region) the highest demand by region experienced in that weather year across all hours
;

$onEmbeddedCode Connect:
- ExcelReader:
    file: Data\AllData.xlsx
    symbols:
      - name: ElecConvCapCost_int
        range: GenCapitalCost-GloNZEpost2050!D5:AJ27
        rowDimension: 1
        columnDimension: 1
      - name: RegGenCostFactor
        range: LCF_GenTech!C6:E80
        rowDimension: 2
        columnDimension: 0
      - name: ElecStoCapCost_int 
        range: StoCapitalCost-GloNZEpost2050!C7:AI13
        rowDimension: 1
        columnDimension: 1
      - name: RegStoCostFactor 
        range: LCF_ElecStoTech!C6:E96
        rowDimension: 2
        columnDimension: 0
      - name: TxCapCost_int 
        range: TxCost15Region!B6:AH30
        rowDimension: 2
        columnDimension: 1
      - name: REZTxCost 
        range: REZTxCost!C6:D20
        rowDimension: 1
        columnDimension: 0
      - name: TxCapExisting 
        range: TranCap15Region!B6:D37
        rowDimension: 2
        columnDimension: 0
      - name: Duration_Hrs
        range: ElecStoTechParams!D7:E13
        rowDimension: 1
        columnDimension: 0
      - name: ElecConvEconomicLife_Yrs
        range: GenTechParams!C7:D19
        rowDimension: 1
        columnDimension: 0
      - name: ElecStoEconomicLife_Yrs 
        range: ElecStoTechParams!D7:F13
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: E
      - name: ElecConvConstructPeriod_Yrs
        range: GenTechParams!C7:E19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: D      
      - name: ElecStoConstructPeriod_Yrs
        range: ElecStoTechParams!D7:G13
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "E:F"
      - name: FuelPrice_int 
        range: FuelCost_average!C6:AD19
        rowDimension: 1
        columnDimension: 1   
        ignoreRows: [14:17]
      - name: FuelEfficiency
        range: GenTechParams!C7:F19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:E"
        ignoreRows: [14:17]
      - name: FuelConnectCost
        range: GenTechParams!C7:M19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:L"
        ignoreRows: [14:17]
      - name: CarbStoCost
        range: GenTechParams!C8:I11
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:H"
        ignoreRows: [9:10]
      - name: CaptureRate
        range: GenTechParams!C8:L11
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:K"
        ignoreRows: [9:10]
      - name: ElecConvVariableOM 
        range: GenTechParams!C7:H19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:G"
      - name: ElecConvFixedOM
        range: GenTechParams!C7:G19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:F"    
      - name: ElecStoFixedOM
        range: ElecStoTechParams!D7:H13
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "E:G"
      - name: ElecConnectCostVRE_int 
        range: ElecVREConCost!C7:D21
        rowDimension: 1
        columnDimension: 0
      - name: ElecConnectCostNonVRE_int 
        range: ElecNonVREConCost!C7:D11
        rowDimension: 1
        columnDimension: 0
      - name: IBRRemediationCostVRE_int 
        range: IBRRemediationCost!C6:D36
        rowDimension: 1
        columnDimension: 0
      - name: RenCapMax 
        range: REZCap15Region!B6:D65
        rowDimension: 2
        columnDimension: 0
      - name: CFAdjust_int 
        range: CapFacAdjust_working!AO21:BC33
        rowDimension: 1
        columnDimension: 1        
      - name: ElecStoConnectCostBatt_int
        range: ElecStoConCost!C7:D11
        rowDimension: 1
        columnDimension: 0
      - name: ElecStoEfficiency
        range: ElecStoTechParams!D7:I14
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "E:H"
      - name: MinStableGen
        range: GenTechParams!C7:J19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:I"
        ignoreRows: [14:17]        
      - name: MaxAvailability
        range: GenTechParams!C7:K19
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "D:J"
        ignoreRows: [14:17]         
      - name: OperatingReserve 
        range: OpReserve!C6:D10
        rowDimension: 1
        columnDimension: 0
      - name: PeakContribution_int
        range: PeakContribution!C6:E18
        rowDimension: 2
        columnDimension: 0
      - name: FuelEmissionFactor5_int 
        range: FuelCO2Eq!B6:D35
        rowDimension: 2
        columnDimension: 0
      - name: ScalData 
        range: Scalarlist!B6:E12
        rowDimension: 1
        columnDimension: 0
        ignoreColumns: "C:D"   
      - name: FOAKProjCap 
        range: FOAKParams!B7:D13
        rowDimension: 2
        columnDimension: 0
      - name: FOAKProjCapCost 
        range: FOAKParams!B7:E13
        rowDimension: 2
        columnDimension: 0
        ignoreColumns: D
      - name: PHESProjCap 
        range: PHESParams!B7:D8
        rowDimension: 2
        columnDimension: 0
      - name: ExistingCustBatt
        range: ExistingBatt!B6:D25
        rowDimension: 2
        columnDimension: 0
      - name: HMap
        range: HourMapSet!E3:F4394
        type: set
        rowDimension: 2
        columnDimension: 0
      - name: RMap
        range: RegionSetMapping!K7:L21
        type: set
        rowDimension: 2
        columnDimension: 0
      - name: FuelAllowed_int
        range: FuelAllowedSet15!B6:D140
        rowDimension: 2
        columnDimension: 0


- GAMSWriter:
    symbols: all
$offEmbeddedCode

$onEmbeddedCode Connect:
- ExcelReader:
    file: Data\HydroData.xlsx
    symbols:
      - name: HydroCap
        range: Capacity!N7:O12
        rowDimension: 1
        columnDimension: 0
      - name: HydroInflowhhr
        range: Flows!V3:AC228387
        rowDimension: 2
        columnDimension: 1        
- GAMSWriter:
    symbols: all
$offEmbeddedCode


*Load gdx data
$gdxIn Data\DdAll.gdx
$load DdProfAll
$gdxin

$gdxIn Data\allvre_2011
$load REZProf2011
$gdxIn

$gdxIn Data\allvre_2012
$load REZProf2012
$gdxIn

$gdxIn Data\allvre_2013
$load REZProf2013
$gdxIn

$gdxIn Data\allvre_2014
$load REZProf2014
$gdxIn

$gdxIn Data\allvre_2015
$load REZProf2015
$gdxIn

$gdxIn Data\allvre_2016
$load REZProf2016
$gdxIn

$gdxIn Data\allvre_2017
$load REZProf2017
$gdxIn

$gdxIn Data\allvre_2018
$load REZProf2018
$gdxIn

$gdxIn Data\allvre_2019
$load REZProf2019
$gdxIn

$gdxIn Data\allvre_2020
$load REZProf2020
$gdxIn

$gdxIn Data\allvre_2021
$load REZProf2021
$gdxIn

$gdxIn Data\allvre_2022
$load REZProf2022
$gdxIn

$gdxIn Data\allvre_2023
$load REZProf2023
$gdxIn

*Collect 2050 values, group weather years for VRE and convert both to hourly
DdProfAll2050(w,Region,hhr)=DdProfAll(w,Region,'2050',hhr);
RezProfAll2050('2011',VREGenTech,Region,hhr)=REZProf2011(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2012',VREGenTech,Region,hhr)=REZProf2012(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2013',VREGenTech,Region,hhr)=REZProf2013(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2014',VREGenTech,Region,hhr)=REZProf2014(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2015',VREGenTech,Region,hhr)=REZProf2015(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2016',VREGenTech,Region,hhr)=REZProf2016(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2017',VREGenTech,Region,hhr)=REZProf2017(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2018',VREGenTech,Region,hhr)=REZProf2018(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2019',VREGenTech,Region,hhr)=REZProf2019(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2020',VREGenTech,Region,hhr)=REZProf2020(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2021',VREGenTech,Region,hhr)=REZProf2021(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2022',VREGenTech,Region,hhr)=REZProf2022(VREGenTech,Region,'2050',hhr);
RezProfAll2050('2023',VREGenTech,Region,hhr)=REZProf2023(VREGenTech,Region,'2050',hhr);
*Noting hydro inflows are in watt hours so there is a conversion to time step required below via ScalData('scal1') which is 2 hourly
Loop(h,
Loop(hhr$HMap(hhr,h),
DdProf2050(w,Region,h)=DdProfAll2050(w,Region,hhr);
REZProf2050(w,VREGenTech,Region,h)=REZProfAll2050(w,VREGenTech,Region,hhr);
HydroInflow(w,Region,h)=HydroInflowhhr(w,hhr,Region)*ScalData('scal1');
););
PeakDemandW(w,Region)=smax(h,DdProf2050(w,Region,h));
*Adjust medium wind profiles to account for higher capacity wind profiles
CFAdjust_int(Region,w)$(CFAdjust_int(Region,w)=0)=1;
REZProf2050(w,'WindOn',Region,h)=CFAdjust_int(Region,w)*REZProf2050(w,'WindOn',Region,h);
REZProf2050(w,'WindOn',Region,h)$(REZProf2050(w,'WindOn',Region,h)>1)=1;

*Adjusting selected parameters by 1000 to match model units
FuelEmissionFactor5_int(FuelGenTech,Region5)=FuelEmissionFactor5_int(FuelGenTech,Region5)/1000;
ElecConvCapCost_int(GenTech,y)=ElecConvCapCost_int(GenTech,y)*1000;
ElecStoCapCost_int(ElecStoTech,y)=ElecStoCapCost_int(ElecStoTech,y)*1000;
REZTxCost(Region)=REZTxCost(Region)*1000;
IBRRemediationCostVRE_int(y)=IBRRemediationCostVRE_int(y)*1000;
ElecStoConnectCostBatt_int(Region5)=ElecStoConnectCostBatt_int(Region5)*1000;
ElecConnectCostVRE_int(Region)=ElecConnectCostVRE_int(Region)*1000;
ElecConnectCostNonVRE_int(Region5)=ElecConnectCostNonVRE_int(Region5)*1000;
ElecConvFixedOM(GenTech)=ElecConvFixedOM(GenTech)*1000;

*Assign model parameetrs using intermediate parameters
dt=ScalData('scal1');
DiscountRate=ScalData('scal2');
GJperMWh=ScalData('scal3');
ElecTxLossFactor=ScalData('scal4');
TxEconomicLife_Yrs=ScalData('scal5');
TxConstructPeriod_Yrs=ScalData('scal6');
EmissionIntensity=ScalData('scal7');
ElecConvCapCost(GenTech)=ElecConvCapCost_int(GenTech,'2050');
ElecStoCapCost(ElecStoTech)=ElecStoCapCost_int(ElecStoTech,'2050');
TxCapCost(Region,RegionD)=TxCapCost_int(Region,RegionD,'2050');
FuelPrice(FuelGenTech)=FuelPrice_int(FuelGenTech,'2050');
ElecConnectCost(VREGenTech,Region)=ElecConnectCostVRE_int(Region);
IBRRemediationCost(VREGenTech)=IBRRemediationCostVRE_int('2050')
Loop(Region,
Loop(Region5$RMap(Region5,Region),
ElecConnectCost(FuelGenTech,Region)=ElecConnectCostNonVRE_int(Region5);
ElecStoConnectCost(BattElecStoTech,Region)=ElecStoConnectCostBatt_int(Region5);
PeakContribution(VREGenTech,Region)=PeakContribution_int(VREGenTech,Region5);
FuelEmissionFactor(FuelGenTech,Region)=FuelEmissionFactor5_int(FuelGenTech,Region5)
););

*Calcuate factor for capital cost anualissation and interest lost during construction
ElecConvCapCostConversion(GenTech)=(1+DiscountRate)**ElecConvConstructPeriod_Yrs(GenTech)*(DiscountRate*((1+DiscountRate)**ElecConvEconomicLife_Yrs(GenTech) ))/(((1+DiscountRate)**ElecConvEconomicLife_Yrs(GenTech) )-1);
ElecStoCapCostConversion(ElecStoTech)=(1+DiscountRate)**ElecStoConstructPeriod_Yrs(ElecStoTech)*(DiscountRate*((1+DiscountRate)**ElecStoEconomicLife_Yrs(ElecStoTech) ))/(((1+DiscountRate)**ElecStoEconomicLife_Yrs(ElecStoTech) )-1);
TxCapCostConversion=(1+DiscountRate)**TxConstructPeriod_Yrs*(DiscountRate*((1+DiscountRate)**TxEconomicLife_Yrs ))/(((1+DiscountRate)**TxEconomicLife_Yrs )-1);

*Halve transmission costs to account for symmetrical reverse-capacity already included under one-way cost
TxCapCost(Region,RegionD)=0.5*TxCapCost(Region,RegionD);
*Assign zero values of regional costs to value of 1
RegGenCostFactor(Region,GenTech)$(RegGenCostFactor(Region,GenTech)=0)=1;
*Allow for own region trade
Loop(Region,
Loop(RegionD,
If( (ord(Region) eq ord(RegionD)),
TxCapExisting(Region,RegionD)=30000;
);
););


execute_unload 'Data\DataUpLoad2050',
dt,
DiscountRate,
GJperMWh,
EmissionIntensity,
TxEconomicLife_Yrs,
TxConstructPeriod_Yrs,
ElecTxLossFactor,
ElecConvCapCostConversion,
ElecStoCapCostConversion,
TxCapCostConversion,
DdProf2050,
PeakDemandW,
RezProf2050,
ElecConvCapCost,
RegGenCostFactor,
ElecStoCapCost,
RegStoCostFactor,
TxCapCost,
REZTxCost,
TxCapExisting,
Duration_Hrs,
ElecConvEconomicLife_Yrs,
ElecStoEconomicLife_Yrs,
ElecConvConstructPeriod_Yrs,
ElecStoConstructPeriod_Yrs,
FuelPrice,
FuelEfficiency,
FuelConnectCost,
CarbStoCost,
ElecConvVariableOM,
ElecConvFixedOM,
ElecStoFixedOM,
ElecConnectCost,
IBRRemediationCost,
ElecStoConnectCost,
RenCapMax,
ElecStoEfficiency,
MinStableGen,
MaxAvailability,
OperatingReserve,
PeakContribution,
FuelEmissionFactor,
CaptureRate,
HydroCap,
HydroInflow,
FuelAllowed_int,
FOAKProjCap,
FOAKProjCapCost,
PHESProjCap,
ExistingCustBatt
;



