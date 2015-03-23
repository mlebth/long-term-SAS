*RUN 'DATA READ IN 5-6-14' FIRST;

*****************SEEDLING MODELS;
proc genmod data=numperplot4; title 'genmod';
class burn prpo sspp;
  model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo / type1 type3;
    lsmeans sspp*burn*prpo;
  	output reslik=ehat out=glmout1;
run;
proc univariate data=glmout1 plot normal; var ehat; title 'genmodunivariate';
run;
*N = 249, N used: 231. 
Goodness of fit:
	Deviance: DF = 208, Value = 252.6035, Value/DF = 1.2144
	Pearson Chi-Square : DF = 208, Value = 252.6035, Value/DF = 1.2144
	Log Likelihood: -338.1009
	AIC: 724.2018
LR stats for type 3 analysis -  
Source 			DF 	Chi-Square 	Pr > ChiSq 
burn 			3 	17.82 		0.0005 
prpo 			1 	8.93 		0.0028 
sspp 			2 	4.75 		0.0929 
burn*sspp 		6 	5.39 		0.4946 
prpo*sspp 		2 	5.86 		0.0533 
burn*prpo 		3 	6.40 		0.0935 
burn*prpo*sspp 	5 	10.58 		0.0603 

ehat - residuals are normally distributed
	N = 231, Shapiro-Wilk = 0.9956, p = 0.7578;

proc glm data=numperplot4; title 'glm';
class burn prpo sspp;
  model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo;
  lsmeans sspp*burn*prpo / stderr;
  output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat;
run;
*Source DF Type III SS Mean Square F Value Pr > F 
burn 			3 	20.25216658 	6.75072219 	5.56 	0.0011 
prpo 			1 	9.95903006 		9.95903006 	8.20 	0.0046 
sspp 			2 	5.25125965 		2.62562982 	2.16 	0.1177 
burn*sspp 		6 	5.96596561 		0.99432760 	0.82 	0.5565 
prpo*sspp 		2 	6.49488748 		3.24744374 	2.67 	0.0713 
burn*prpo 		3 	7.10103409 		2.36701136 	1.95 	0.1228 
burn*prpo*sspp 	5 	11.84311439 	2.36862288 	1.95 	0.0874 ;

* year is NOT year, year is just timerep, a repeated measure made on plot;
* to be sure, make a new variable timerep:  plotA2001 plotA2003 ....  plotB2001;

proc glimmix data=numperplot4; title 'glimmix';   * or in proc mixed?;
class burn plot prpo year sspp;
model logabund = burn prpo burn*prpo sspp sspp*burn sspp*prpo sspp*prpo*burn / dist=normal link=identity;
random plot(burn);
random year(prpo) / subject = plot(burn);
random residual / type=cs subject=plot(burn);
lsmeans sspp*prpo*burn / ilink;
run;






*************************AFE POSTER results, year 2012****************************;
*tried poisson first, overdispersed;
proc genmod data=tot12; title 'loblolly 2012';
class burn ;
  model totpita = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat out=glmout1;
run;
proc univariate data=glmout1 plot normal; var ehat;
run;
*AIC=224.86 (better than poisson, around 750)
Shapiro-Wilk: W=0.95, P=0.1462
LR Type 3 Analysis--
burn: df=3, chi-square=6.21, P=0.1018
LSmeans: 
burn Estimate Standard Error  z Value  Pr > |z| 
1 	  1.6094   0.6649 		  2.42 		0.0155 
2 	  3.2144   0.4773 		  6.73 		<.0001 
3 	  3.0204   0.5858 		  5.16 		<.0001 
4 	  1.8326   0.4253 		  4.31 		<.0001 

;

proc genmod data=tot12; title 'sand post 2012';
class burn ;
  model totquma = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat2 out=glmout2;
run;
proc univariate data=glmout2 plot normal; var ehat2;
run;
*AIC=140.1959
Shapiro-Wilk: W=0.806, P<0.0001 ---non-normal residuals
LR Type 3 Analysis--
burn: df=3, chi-square=5.54, P=0.1364
LSmeans: 
burn Estimate Standard Error  z Value  Pr > |z| 
1 	  2.4681   	 0.9093		  2.71 		0.0066 
2 	  1.8971   	 0.6831 	  2.78 		0.0055
3 	  1.0415   	 0.8566		  1.22 		0.2240 
4 	  -0.08701   0.6545 	  -0.13 	0.8942 

;

proc genmod data=tot12; title 'blackjack 2012';
class burn ;
  model totquma3 = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat3 out=glmout3;
run;
proc univariate data=glmout3 plot normal; var ehat3;
run;
*AIC=169.6919
Shapiro-Wilk: W=0.898, P=0.0055
LR Type 3 Analysis--
burn: df=3, chi-square=9.14, P=0.0275 
LSmeans: 
burn 	Estimate 	Standard Error 	z Value 	Pr > |z| 
1 		-22.9321 	42674 			-0.00 		0.9996   ****crazy estimate and SE, only 2 obs
2 		2.1595 		0.6405 			3.37 		0.0007 
3 		2.7515 		0.7789 			3.53 		0.0004 
4 		2.0898 		0.5553 			3.76 		0.0002 

;
proc freq data = dattotn; tables totquma3*burn; run;

*************************AFE POSTER results, year 2013****************************;
proc genmod data=tot13; title 'loblolly 2013';
class burn ;
  model totpita = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat4 out=glmout4;
run;
proc univariate data=glmout4 plot normal; var ehat4;
run;
*AIC=224.86 (better than poisson, around 750)
Shapiro-Wilk: W=0.93, P=0.0108
LR Type 3 Analysis--
burn: df=3, chi-square=6.21, P=0.1018
LSmeans: 
burn 	Estimate 	Standard Error  z Value  Pr > |z| 
1 		1.7228 		0.6374 			2.70 	0.0069 
2 		2.9653 		0.4364 			6.79 	<.0001 
3 		2.6672 		0.4385 			6.08 	<.0001 
4 		2.5649 		0.3032 			8.46 	<.0001 


;

proc genmod data=tot13; title 'sand post 2013';
class burn ;
  model totquma = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat5 out=glmout5;
run;
proc univariate data=glmout5 plot normal; var ehat5;
run;
*AIC=140.1959
Shapiro-Wilk: W=0.7652, P<0.0001 ---non-normal residuals
LR Type 3 Analysis--
burn: df=3, chi-square=5.54, P=0.1364
LSmeans: 
burn 	Estimate 	Standard Error  z Value  Pr > |z| 
1 		2.5494 		1.1086 			2.30 	0.0215 
2 		1.9021 		0.7884 			2.41 	0.0158 
3 		0.9163 		0.8042 			1.14 	0.2545 
4 		0.5664 		0.5621 			1.01 	0.3136 


;

proc genmod data=tot13; title 'blackjack 2013';
class burn ;
  model totquma3 = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat6 out=glmout6;
run;
proc univariate data=glmout6 plot normal; var ehat6;
run;
*AIC=169.6919
Shapiro-Wilk: W=0.846, P=0.0055
LR Type 3 Analysis--
burn: df=3, chi-square=9.14, P=0.0275 
LSmeans: 
burn 	Estimate 	Standard Error 	z Value 	Pr > |z| 
1 		-21.9922 	26673 			-0.00 		0.9993    ****crazy estimate and SE, only 2 obs
2 		2.4932 		0.6891 			3.62 		0.0003 
3 		2.2083 		0.6911 			3.20 		0.0014 
4 		2.1260 		0.4774 			4.45 		<.0001 


;

*yaupon;

**herbaceous richness;
proc sort data=herbs5; by year burn plot hspp;
proc means data=herbs5 n noprint ; by year burn plot hspp;
	output out=out1 n=n; run;

proc means data=out1 n; by year burn plot;
	output out=out2 n=richness;
proc print data=out2; run;


data herb12; set out2; if (year = "2012"); run;
proc sort data=herb12; by plot year burn;
proc print data = herb12; run; *N = 32 observations;

data herb13; set out2; if (year = "2013"); run;
proc sort data=herb13; by plot year burn;
proc print data = herb13; run; *N = 46 observations;

proc genmod data=herb12; title 'richness 2012';
class burn;
  model richness = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat7 out=glmout7;
run;
proc univariate data=glmout7 plot normal; var ehat7;
run;
*AIC=169.6919
Shapiro-Wilk: W=0.9812, P=0.8363
LR Type 3 Analysis--
burn: df=3, chi-square=10.12, P=0.0176 * 
LSmeans: 
burn 	Estimate 	Standard Error 	z Value 	Pr > |z| 
1 		2.7973 		0.1123 			24.90 		<.0001 
2 		2.9267 		0.07865 		37.21 		<.0001 
3 		2.4709 		0.1201 			20.57 		<.0001 
4 		2.8670 		0.07011 		40.89 		<.0001 


;

proc genmod data=herb13; title 'richness 2013';
class burn;
  model richness = burn/ dist = negbin link=log type1 type3;
  lsmeans burn;
  output reslik=ehat7 out=glmout7;
run;
proc univariate data=glmout7 plot normal; var ehat7;
run;
*AIC=169.6919
Shapiro-Wilk: W=0.970722, P=0.2946
LR Type 3 Analysis--
burn: df=3, chi-square=1.56, P=0.6693 
LSmeans: 
burn 	Estimate 	Standard Error 	z Value 	Pr > |z| 
1 		2.9857 		0.1349 			22.14 		<.0001 
2 		3.0634 		0.09336 		32.81 		<.0001 
3 		3.0155 		0.09458 		31.88 		<.0001 
4 		3.1293 		0.06331 		49.43 		<.0001 


;



proc glm data=pita2; title 'pita2';
class burn sspp;
  model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo;
  lsmeans sspp*burn*prpo / stderr;
  output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat;
run;











**********************************************************old analyses;
proc genmod data=allburn; class burnsev hydromulch;
  model totpita =  hydromulch burnsev / dist = negbin link=log type1 type3;
run;

proc genmod data=allburn; class burnsev hydromulch;
  model totpita =  hydromulch burnsev hydromulch*burnsev/
     dist = negbin link=log type1 type3;
* interaction NS;
run;
* oak; 
proc genmod data=allburn; class burnsev hydromulch;
  model totquma = burnsev hydromulch / dist = poisson link=log type1 type3;
run;
* type 3 burnsev df=2 X2=3.71 P = 0.1567
         hydromulch  df=2  X2=10.91 P=0.0043;

proc genmod data=allburn; class burnsev hydromulch;
  model totquma = burnsev hydromulch  burnsev*hydromulch/ dist = poisson link=log type1 type3;
  lsmeans burnsev*hydromulch;
run;
* use this - note type 1 not type 3 - no type3 reported.
* type 1 burnsev df=2 X2=3.66 P = 0.1603
         hydromulch  df=2  X2=10.91 P=0.0043
         int df=3 X2=17.59 P = 0.0005;




proc sort data = ???; by year burn plot sspp;
proc means data = ???; by year burn plot ssspp; var npersppo; 
  output out=numperplot sum=nperplot;



**copied from data2013 nlf 7-11;
* ---- get plot-level information, pooling species -----;
proc sort data=seedling2; by burn bcat1 bcat2 yrcat yrsincerx plot; run;
proc means data=seedling2 noprint n mean sum; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var shgt snum;
  output out=seedling3 n=plantno plantnox 
                       mean = mhgt mstems 
                       sum  = sumhgt sumstems; * # records/species/plot;
proc print data=seedling3; title 'seedling3'; run;
* N = 207 species-plot combinations, 44 plots;
* plantno = number of plants/plot  
  plantnox is redundant
  mhgt = average ht of all plants in the plot
  mstems = avage # stems/plant in the plot
  sumhgt = junk?
  sumstems = # of stems of all species in the plot;
proc univariate data=seedling3 normal plot; title 'seedling3';
  var plantno sumstems mhgt;
run;

data seedling4; set seedling3;
  if plantno = 0 then plantno = .;
  logplantno = log10(plantno); logsumstems = log10(sumstems);
  logmhgt = log10(mhgt);
  drop plantnox sumhgt mstems;
run;
proc glm data=seedling4;
  class burn bcat1 bcat2 yrcat;
  * model sumstems = bcat2 yrcat bcat2*yrcat;
  model logsumstems = burn yrcat burn*yrcat;
  lsmeans burn*yrcat / stderr;
  output out=glmout1 r=ehat;
run;
proc univariate data=glmout1 plot normal; var ehat;
run;












proc import datafile="f:\Excel Files\FFI long-term data\saplings-allyrs.csv"
out=saplings 
dbms=csv replace;
getnames=yes;
run;
/*proc print data=saplings; title 'saplings'; run;*/

*cleanup;
data saplings1;
	set saplings;
	if Species_Symbol='' then delete;
data saplings2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=pspp) rename=(Status=stat) rename=(SizeClDia=pdia) rename=(Count=pnum) rename=(Avght=phgt));
	set saplings1;
data saplings3 (keep=plot pspp stat pdia pnum phgt Date);
	set saplings2;
run;
proc contents data=saplings3; title 'saplings3'; run;
*variables
   plot = fmh plot #
   pspp = species code
   pdia = DBH
   phgt = height class
   pnum = number of saplings per height class
   stat = status (L/D)
   Date = date of plot visit;

/*proc print data=saplings3; run;  * N = 2135;*/
proc freq data=saplings3; tables pspp; run; 
	/* VAAR shrub, not tree. 
	PINU = unidentified Pinus spp. 
	QUER = unidentified Quercus spp.
	SILA = gum bully */
*removing incorrect observations;
data saplings4;
	set saplings3;
	if pspp = "VAAR" then delete;
run;
proc freq data=saplings4; tables pspp; title 'seedlings4'; run;

*merging with plot history;
proc sort data=saplings4; by plot;
data saplings5; merge hist2 saplings4; by plot; run;
/*proc print data=saplings5; title 'saplings merged with plot history'; run; * N = 2104--14 plots w/hist data but no sapling observations; */

* ---- plot-level information -----;
proc sort data=saplings5; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=saplings5 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var pnum;
  output out=saplings6 n = pnum
  					   sum = sumsaplings;
* pnum = number of individual observations in the plot  
  sumsaplings = # of all saplings in the plot;

proc print data=saplings6; title 'saplings6'; run; *n=51 (no obs in plot 1209--record wasn't counted);

proc univariate data=saplings6 normal plot;
	var sumsaplings;
run;
*N = 37 (only 37 plots with sapling obs.), skewness = 1.3984, kurtosis = 1.3469. Shapiro-Wilk: W=0.8346, p < 0.0001;





















proc import datafile="f:\Excel Files\FFI long-term data\maturetrees-allyrs.csv"
out=overstory 
dbms=csv replace;
getnames=yes;
run;
/*proc print data=overstory; title 'overstory'; run;*/

*cleanup;
data overstory1;
	set overstory;
	if Species_Symbol='' then delete;
data overstory2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=ospp) rename=(Status=stat) rename=(CrwnRto=crwn) rename=(DBH=odbh) rename=(SubFrac=onum));
	set overstory1;
data overstory3 (keep=plot ospp stat crwn odbh onum Date);
	set overstory2;
run;
proc contents data=overstory3; title 'overstory3'; run;
*variables
   plot = fmh plot #
   ospp = species code
   crwn = crown dominance class
   odbh = DBH
   onum = count variable
   stat = status (L/D)
   Date = date of plot visit;

/*proc print data=overstory3; run;  * N = 6236;*/
proc freq data=overstory3; tables ospp; run; 
	/* JUVA = Juncus validus--this is a graminoid, def shouldn't be here. maybe they meant JUVI??
	QUDR = Quercus drummondii. Synonym for QUMA.
	PINU = unidentified Pinus spp.
	QUER = unidentified Quercus spp.
	UNKN = unknown */
*removing incorrect observations;
data overstory4;
	set overstory3;
	if ospp = "JUVA" then ospp = "JUVI";
run;
proc freq data = overstory4; tables ospp; title 'overstory4'; run;

*merging with plot history;
proc sort data=overstory4; by plot;
data overstory5; merge hist2 overstory4; by plot; run;
/*proc print data=overstory5; title 'overstory merged with plot history'; run; * N = 6236; */

* ---- plot-level information -----;
proc sort data=overstory5; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=overstory5 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var onum;
  output out=overstory6 n = onum
  					   sum = sumtrees;
* pnum = number of individual observations in the plot  
  sumtrees = # of all trees in the plot;

proc print data=overstory6; title 'overstory6'; run; *n=52;

proc univariate data=overstory6 normal plot;
	var sumtrees;
run;
*N = 52, skewness = 0.2806, kurtosis = -1.0372. Shapiro-Wilk: W=0.9431, p = 0.0151;











*-------------------------------------herbaceous-----------------------------------------;
proc import datafile="E:\Research\Excel Files\FFI long-term data\density-quadrats-allyrs.csv"
out=herbs 
dbms=csv replace;
getnames=yes;
run;
/*proc print data=herbs; title 'herbs'; run;*/

*cleanup;
data herbs1;
	set herbs;
	if Species_Symbol='' then delete;
data herbs2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=hspp) rename=(Status=stat) rename=(Count=hnum));
	set herbs1;
data herbs3 (keep=plot hspp stat hnum Date);
	set herbs2;
run;
proc contents data=herbs3; title 'herbs3'; run;
*variables
   plot = fmh plot #
   hspp = species code
   hnum = count variable
   stat = status (L/D)
   Date = date of plot visit;

/*proc print data=herbs3; run;  * N = 5081;*/
proc freq data=herbs3; tables hspp; run; 
	/* ACGR = Acacia farnesiana (tree), probably meant ACGR2 (Acalypha gracilens).
	RUBUS should not be in here, it should be with shrubs.
	SMILA2 (Smilax spp.) also should be with shrubs.
	UNID1 = unidentified.
	UNFL1 = unknown flower.
	UNGR3 = unknown grass.
	UNSE1 = unknown seedling. Shouldn't even be in here! */
*removing incorrect observations and correcting Acalypha gracilens;
data herbs4;
	set herbs3;
	if hspp = "RUBUS" or hspp = "SMILA2" or hspp = "UNSE1" then delete;
	if hspp = "ACGR" then hspp = "ACGR2";
run;
proc freq data = herbs4; tables hspp; title 'herbs4'; run;

*merging with plot history;
proc sort data=herbs4; by plot;
data herbs5; merge hist2 herbs4; by plot; run;
/*proc print data=herbs5; title 'herbs merged with plot history'; run; * N = 5072; */

* ---- plot-level information -----;
proc sort data=herbs5; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=herbs5 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var hnum;
  output out=herbs6 n = hnum
  					   sum = sumherbs;
* hnum = number of individual observations in the plot  
  sumherbs = # of all stems in the plot;

proc print data=herbs6; title 'herbs6'; run; *n=55;

proc univariate data=herbs6 normal plot;
	var sumherbs;
run;
*N = 55, skewness = 1.2260, kurtosis = 2.7826. Shapiro-Wilk: W=0.9204, p = 0.0014;













*---------------------------------------shrubs-------------------------------------------;
proc import datafile="f:\Excel Files\FFI long-term data\density-belts-allyrs.csv"
out=shrubs 
dbms=csv replace;
getnames=yes;
run;
/*proc print data=shrubs; title 'shrubs'; run;*/

*cleanup;
data shrubs1;
	set shrubs;
	if Species_Symbol='' then delete;
data shrubs2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=shspp) rename=(Status=stat) rename=(AgeCl=agec) rename=(Count=shnum));
	set shrubs1;
data shrubs3 (keep=plot shspp stat agec shnum Date);
	set shrubs2;
run;
proc contents data=shrubs3; title 'shrubs3'; run;
*variables
   plot = fmh plot #
   shspp = species code
   shnum = stem number
   agecl = age class (R(resprout)/I(immature)/M(mature))
   stat = status (L/D)
   Date = date of plot visit;

/*proc print data=shrubs3; run;  * N = 685;*/
proc freq data=shrubs3; tables shspp; run; 
	/* Trees (should not be included):
	CATE9 (Carya texana), JUVI, PITA, PRGL2 (Prosopis glandulosa), PTTR (Ptelea trifoliata), QUIN, QUMA3, QUNI, QUST, SILA2 (gum bully) */
*removing incorrect observations and correcting Acalypha gracilens;
data shrubs4;
	set shrubs3;
	if shspp = "CATE9" or shspp = "JUVI" or shspp = "PITA" or shspp = "PRGL2" or shspp = "PTTR" or shspp = "QUIN" or shspp = "QUMA3" or shspp = "QUNI" or shspp = "QUST" or hspp = "SILA2" then delete;
run;
proc freq data = shrubs4; tables shspp; title 'shrubs4'; run;

*merging with plot history;
proc sort data=shrubs4; by plot;
data shrubs5; merge hist2 shrubs4; by plot; run;
/*proc print data=shrubs5; title 'shrubs merged with plot history'; run; * N = 676; */

* ---- plot-level information -----;
proc sort data=shrubs5; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=shrubs5 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var shnum;
  output out=shrubs6 n = shnum
  					 sum = sumshrubs;
* shnum = number of individual observations in the plot  
  sumshrubs = # of stems in the plot;

proc print data=shrubs6; title 'shrubs6'; run; *n=54. Note: 0 shrub observations in 1231, 1233;

proc univariate data=shrubs6 normal plot;
	var sumshrubs;
run;
*N = 52 (b/c 0 shrub observations in 1231, 1233), skewness = 1.7992, kurtosis = 2.9600. Shapiro-Wilk: W=0.7817, p < 0.0001;











*following dataset is large, kill previous libraries
*---------------------------------------point-intercept--------------------------------------------;
proc import datafile="f:\Excel Files\FFI long-term data\cover-points-allyrs.csv"
out=point 
dbms=csv replace;
getnames=yes;
run;
/*proc print data=point; title 'point'; run;*/
proc import datafile="f:\Excel Files\FFI long-term data\Report_CoverPoints_M.csv"
out=pointcount 
dbms=csv replace;
getnames=yes;
run;
proc contents data=pointcount; title 'pointcount'; run;

data pointcount2 (rename=(MacroPlot_Name=plot) rename=(Average_Count=cnt) rename=(Average_Cover=covr) rename=(Average_Height_m_=vhgt) rename=(Average_Hits=hits) rename=(Item=item) rename=(Status=stat) rename=(Monitoring_Status=year));
	set point1;
data point3 (keep=plot spp stat hgt Date Point Tape);
	set point2;
run;
proc contents data=point3; title 'point3'; run;

*cleanup;
data point1 (compress = yes);
	set point;
	if Species_Symbol='' then delete;
data point2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=spp) rename=(Status=stat) rename=(Height=hgt));
	set point1;
data point3 (keep=plot spp stat hgt Date Point Tape);
	set point2;
run;
proc contents data=point3; title 'point3'; run;
*variables
   plot = fmh plot #
   spp = species code
   stat = status (L/D)
   hgt = height of stem
   Date = date of plot visit
   Point = point number (1-166)
   Tape = value of tape at points (ex. .3, .6., 9);


/*proc print data=point3; run;  * N = 31730;*/
proc freq data=point3; tables spp; run; 
	/* 	A lot substrate/other--bare, bole, wood, liverwort (2LW), litt etc. aggregate into one substrate variable?*/
*removing incorrect observations and correcting Acalypha gracilens;

*merging with plot history;
proc sort data=point3; by plot;
data point4; merge hist2 point3; by plot; run;
/*proc print data=point4; title 'point intercept merged with plot history'; run; * N = 31730; */

* ---- plot-level information -----;
proc sort data=point4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=point4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var hnum;
  output out=point5 n = hnum
  					   sum = sumspp;
* hits = number of hits?
  sumhits = # of all hits in the plot;

proc print data=point5; title 'point5'; run; *n=55;

proc univariate data=point5 normal plot; title 'point5';
	var sumherbs;
run;
*N = 55, skewness = 1.2252, kurtosis = 2.7804. Shapiro-Wilk: W=0.9204, p = 0.0014;



data all; merge seedlings6 saplings6 overstory6 shrubs6 herbs6 point5; run;
