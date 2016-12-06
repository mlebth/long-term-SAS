
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

/*when processes get too slow, run this and RERUN ALL OF HIST to free up memory

proc datasets library=work kill; run; 

*/

proc import datafile="G:\Research\Excel Files\data 2013\plothistory.csv"
out=hist 
dbms=csv replace;
getnames=yes;
run;
/*proc contents data=hist; title 'hist'; run;
proc print data=hist; run;  * N = 44; */
* plot history data in this file;
* variables: 
   burnsev (s, l, m, h) = wildfire severity
   hydr (x, n, l, h) = hydromulch [x = unknown, n = none, l = light, h = heavy]
   lastrx = year of last prescribed burn
   yrrx1, yrrx2, yrrx3 = years of rx burns since 2003
   plot = fmh plot #;
data hist2; set hist;
   if lastrx = 9999 then lastrx = .;
   if yrrx1 = 9999 then yrrx1 = .;
   if yrrx2 = 9999 then yrrx2 = .;
   if yrrx3 = 9999 then yrrx3 = .;
   /* years since prescribed fire variables. So far not very useful.
   lastrx = 2014 - yrrx;
   if (lastrx = .) then yrcat = 'nev';
   if (lastrx = 3| lastrx = 6 | lastrx = 7) then yrcat = 'rec';
   if (lastrx = 9 | lastrx = 11) then yrcat = 'old';   */
   * makes new set of treatment names with natural ordering for graphs and constrasts;
   if burnsev = 's' then burn = 1;
   if burnsev = 'l' then burn = 2;
   if burnsev = 'm' then burn = 3;
   if burnsev = 'h' then burn = 4;
   * poolingA - scorch, light, moderate;
   if (burnsev = 'h') then bcat1 = 'B';
   if (burnsev = 'm' | burnsev = 'l' | burnsev = 's') then bcat1 = 'A';
   * poolingB - combine scorch + light;
   if (burnsev = 'h') then bcat2 = 'C';
   if (burnsev = 'm') then bcat2 = 'B';
   if (burnsev = 's' | burnsev = 'l') then bcat2 = 'A';
run;

proc sort data=hist2; by plot burn; run;

*--------------------------------------- 2014 -----------------------------------------------------;
/*FUELS data were only collected in 1999.

proc import datafile="g:\Excel Files\FFI long-term data\duff-1999.csv"
out=duff 
dbms=csv replace;
getnames=yes;
run;

proc import datafile="g:\Excel Files\FFI long-term data\1000hrfuels-1999.csv"
out=cwd 
dbms=csv replace;
getnames=yes;
run;

proc import datafile="g:\Excel Files\FFI long-term data\finefuels-1999.csv"
out=finefuels 
dbms=csv replace;
getnames=yes;
run;

From FMH handbook--'Ocular estimates of cover for plant species on a macroplot'
Collected on about 13 plots, 2010-2013. no more than 5-6 spp recorded per plot, and no cover recorded. 
Also entered for 2002, 2003, 2005, 2006, but completely blank. 
proc import datafile="g:\Excel Files\FFI long-term data\cover-speciescomp-allyrs.csv"
out=spcomp 
dbms=csv replace;
getnames=yes;
run;

Done in 2011, one plot in 2008. Data for 2012 included but blank--maybe a mistake?
proc import datafile="g:\Excel Files\FFI long-term data\postburnsev-allyrs.csv"
out=postsev 
dbms=csv replace;
getnames=yes;
run;
*/

*NOTE FOR ALL: Count subspecies as separate species or lump together? Also: there are species in the database that are taxonomically something different now, should be corrected for consistency;

*---------------------------------------trees-----------------------------------------;
*seedlings/resprouts;
proc import datafile="G:\Research\Excel Files\FFI long-term data\seedlings-allyrs.csv"
out=seedlings 
dbms=csv replace;
getnames=yes;
run;  * N = 998;

/*proc print data=seedlings; title 'seedlings'; run;*/

* cleanup;
data seedlings1;
	set seedlings;
	if Species_Symbol='' then delete;
data seedlings2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=sspp) rename=(SizeClHt=shgt) rename=(Count=snum));
	set seedlings1;
data seedlings3 (keep=plot sspp shgt snum Date);
	set seedlings2;
run;
proc contents data=seedlings3; title 'seedlings3'; run;  * N = 798;
*variables
   plot = fmh plot #
   sspp = species code
   shgt = height class
   snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   Date = date of plot visit;

/*proc print data=seedlings3; run;  * N = 798 (798 sdlngs);*/
proc freq data=seedlings3; tables sspp; run; 
	/* CAAM is entered 2x (shrub, not a seedling)
	ILVO is entered 9x (shrub, not a seedling)
	UNTR1 = unknown tree
	FOR ALL DATASETS: remove unknown observations?? */
*two sets, one with consistent trees, the other with inconsistent spp; 
data seedlings4; set seedlings3;
	if (sspp NE "CAAM2" & sspp NE "ILVO" & sspp NE "VAAR") ;
data seedlingprobspp; set seedlings3;
	if (sspp  = "CAAM2" | sspp  = "ILVO" | sspp  = "VAAR");
run;
proc freq data=seedlings4; tables sspp; title 'seedlings4'; run; * N = 648;
proc freq data=seedlingprobspp; tables sspp; title 'seedlings4'; run; * N = 150;

*splitting out just important species--pines and quma, quma3;
data pineoak; set seedlings4;
	if (sspp = "PITA" |sspp = "QUMA" | sspp = "QUMA3");
run;

proc freq data=pineoak; tables sspp; title 'pineoak'; run; * N = 473;
proc sort data=pineoak; by plot;
data pineoak2; merge hist2 pineoak; by plot; year = year(date); run;
data pineoak3; set pineoak2;
   if year < 2011 then prpo = 'pref';
   if year >= 2011 then prpo = 'post';
run;
proc print data=pineoak3; run;
proc contents data = pineoak3; run;
proc freq data=pineoak3; tables sspp*burn; title 'pineoak'; run; * N = 491;

proc sort data=pineoak3; by plot year sspp burn prpo;
proc means data=pineoak3 noprint sum; by plot year sspp burn prpo; var snum; 
  output out=numplantdatapo sum=npersppo;
  *npersppo = number per species for pines and oaks;
proc print data=numplantdatapo; title 'pine oak numplantdata'; 
  var plot year burn prpo sspp npersppo;
run;   * N = 240 plot-year combinations;

proc freq data=numplantdatapo; tables sspp*burn / fisher expected;
run;
*this has different values than pineoak3 table...not sure why yet;

proc sort data=numplantdatapo; by plot burn prpo;
proc means data=numplantdatapo noprint sum; by plot burn prpo; var npersppo; 
  output out=numperplot sum=nperplot;
proc print data=numperplot; title 'totals per plot'; 
  var plot burn prpo nperplot;
run;   * N = 249 plot-year combinations;
proc sort data = numperplot; by plot;
data numperplot2; merge numplantdatapo numperplot; by plot; run;
proc print data = numperplot2; run;
data numperplot3; set numperplot2;
	relabun = npersppo / nperplot;
proc print data = numperplot3; title 'numperplot3'; run;


proc freq data=numperplot3; tables sspp*burn / fisher expected;
run;
proc freq data=numperplot3; tables sspp*prpo / fisher expected;
run;

*merging orig dataset (with all species) with plot history;
proc sort data=seedlings4; by plot;
data seedlings5; merge hist2 seedlings4; by plot; year = year(date); run;
proc print data=seedlings5; title 'seedlings merged with plot history'; run; * N = 659 no seedlings observed in plot 1237; 


* ---- plot-level information -----;
* to compare spp among plots, we need a comparable variable for each plot;
* an obvious comparable variable is number of plants of that spp;
proc sort data=seedlings5; by plot year sspp;
proc means data=seedlings5 noprint sum; by plot year sspp; var snum; 
  output out=numplantdata sum=npersp;
proc print data=numplantdata; title 'numplantdata'; 
  var plot year sspp npersp;
run;   * N = 352;

proc means data=numplantdata noprint sum; by plot year; 
  var npersp;
  output out=seedlings6 sum = sumseedlings;
* sumseedlings = # of all sdlngs in the plot;
proc print data=seedlings6; title 'seedling6';
  run; * n=168 plot-year combinations;

proc univariate data=numplantdatapo plot;
	var npersppo;
run;
* long right tail;

* which are the most common spp?;
proc sort data=numplantdata; by sspp;
proc means data=numplantdata sum noprint; by sspp; var npersp;
  output out=spptotals sum=spptot;
proc print data=spptotals; title 'plants/spp all plots, all year';
run;
*QUMA3: 1027, PITA: 937, QUMA: 725, SANI: 157;

*****************models;
proc contents data = numperplot3; run;
proc univariate data=numperplot3 plot normal; 
run;
*Shapiro-Wilk: 0.3359, P < 0.0001. 
Lognormally distributed, create new variable with transformed data;

data numperplot4; set numperplot3;
	logabund = log(relabun);
run;
proc print data = numperplot4; run;
proc univariate data=numperplot4 plot normal; 
run;
proc print data = numperplot4; run;
*Shapiro-Wilk: 0.983, p = 0.0074. Not normal but much better;

proc genmod data=numperplot4; title 'genmod';
class burn prpo sspp;
  model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo / type1 type3;
    lsmeans sspp*burn*prpo;
  	output reslik=ehat out=glmout1;
run;
proc univariate data=glmout1 plot normal; var ehat; title 'genmodunivariate';
run;
*N = 249. AIC: 724.2018
  type 1
  plot df=1 X2=68.33 P <.0001 
  year df=1 X2=85.66 P <.0001 
  type 3 -  
Source 			DF 	Chi-Square 	Pr > ChiSq 
burn 			3 	17.82 		0.0005 
prpo 			1 	8.93 		0.0028 
sspp 			2 	4.75 		0.0929 
burn*sspp 		6 	5.39 		0.4946 
prpo*sspp 		2 	5.86 		0.0533 
burn*prpo 		3 	6.40 		0.0935 
burn*prpo*sspp 	5 	10.58 		0.0603 ;

proc glm data=numperplot4; title 'glm';
class burn prpo sspp;
  model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo;
  lsmeans sspp*burn*prpo / stderr;
  output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat;
run;











proc glm data=numperplot3; title 'glm';
class burn prpo sspp;
  model relabun = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo;
  lsmeans sspp*burn*prpo / stderr;
  output out=glmout1 r=ehat;
run;
proc univariate data=glmout1 plot normal; var ehat;
run;


proc glimmix data=numplantdatapo; title 'glimmix';
class burn prpo sspp;
  model npersppo = burn prpo sspp burn*sspp sspp*prpo burn*sspp*prpo/ dist = poisson;
random residual / type = cs subject = plot(burn*sspp*prpo);
lsmeans burn*sspp*prpo / ilink;
run;






proc glimmix data=seedlings5; 
class plot burn;
  model snum = burn / dist = poisson;
random residual / type = cs subject = plot(burn);
lsmeans burn / ilink;
run;


proc glimmix data=prunus4; title 'prse b=ng cs';
class burn fenc plot year;
model stem = year burn fenc year*burn year*fenc year*burn*fenc / dist=negbin;
random residual / type=cs subject=plot(burn*fenc);
*random int / subject=plot(burn*fenc);
lsmeans burn*fenc*year / ilink;



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
run;
* use this - note type 1 not type 3 - no type3 reported.
* type 1 burnsev df=2 X2=3.66 P = 0.1603
         hydromulch  df=2  X2=10.91 P=0.0043
         int df=3 X2=17.59 P = 0.0005;









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
proc import datafile="f:\Excel Files\FFI long-term data\density-quadrats-allyrs.csv"
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
