
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

/*when processes get too slow, run this and RERUN ALL OF HIST to free up memory*/
proc datasets library=work kill;
run;

proc import datafile="F:\Excel Files\2013 Raw data\final data\plothistory.csv"
out=hist 
dbms=csv replace;
getnames=yes;
run;
/*proc contents data=hist; title 'hist'; run;
proc print data=hist; run;  * N = 44; */
* plot history data in this file;
* variables: 
   burnsev (s, l, m, h) = wildfire severity
   hydr (n, l, h) = hydromulch [needs completing]
   yrrx = year of last prescribed burn
   plot = fmh plot #;
data hist2; set hist;
   if yrrx = 9999 then yrrx = .;
   yrsincerx = 2013 - yrrx;
   if (yrsincerx = .) then yrcat = 'nev';
   if (yrsincerx = 2| yrsincerx = 5 | yrsincerx = 6) then yrcat = 'rec';
   if (yrsincerx = 8 | yrsincerx = 10) then yrcat = 'old';
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
proc import datafile="f:\Excel Files\FFI long-term data\seedlings-allyrs.csv"
out=seedlings 
dbms=csv replace;
getnames=yes;
run;

/*proc print data=seedlings; title 'seedlings'; run;*/

*cleanup;
data seedlings1;
	set seedlings;
	if Species_Symbol='' then delete;
data seedlings2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=sspp) rename=(SizeClHt=shgt) rename=(Count=snum));
	set seedlings1;
data seedlings3 (keep=plot sspp shgt snum Date);
	set seedlings2;
run;
proc contents data=seedlings3; title 'seedlings3'; run;
*variables
   plot = fmh plot #
   sspp = species code
   shgt = height class
   snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   Date = date of plot visit;

/*proc print data=seedlings3; run;  * N = 798 (798 sdlngs);*/
proc freq data=seedlings3; tables sspp; run; *CAAM is entered 2x and ILVO 9x, should both be in shrubs instead. UNTR1 = unknown tree;

*merging with plot history;
proc sort data=seedlings3; by plot;
data seedlings4; merge hist2 seedlings3; by plot; run;
/*proc print data=seedlings4; title 'seedlings merged with plot history'; run; * N = 799 b/c no seedlings observed in plot 1237; */

* ---- plot-level information -----;
proc sort data=seedlings4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=seedlings4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var snum;
  output out=seedlings5 n = snumhgt
  						sum = sumseedlings;
* snumhgt = number of sdlngs/height class/plot  
  sumseedlings = # of all sdlngs in the plot;

proc print data=seedlings5; title 'seedling5'; run; *n=51 (plot 1226 was never visited--record wasn't counted);

proc univariate data=seedlings5 normal plot; title 'seedlings5';
	var sumseedlings;
run;
*N = 50 (no seedlings in one plot), skewness = 2.0180, kurtosis = 4.9477. Shapiro-Wilk: W=0.8021, p < 0.0001;











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
	/* VAAR should be in shrubs, not trees. 
	PINU = unidentified Pinus spp. 
	QUER = unidentified Quercus spp.
	SILA = gum bully */

*merging with plot history;
proc sort data=saplings3; by plot;
data saplings4; merge hist2 saplings3; by plot; run;
/*proc print data=saplings4; title 'saplings merged with plot history'; run; * N = 2149--because there are 14 plots w/hist data but no sapling observations; */

* ---- plot-level information -----;
proc sort data=saplings4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=saplings4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var pnum;
  output out=saplings5 n = pnum
  					   sum = sumsaplings;
* pnum = number of saplings/plot  
  sumsaplings = # of all saplings in the plot;

proc print data=saplings5; title 'saplings5'; run; *n=51 (no obs in plot 1209--record wasn't counted);

proc univariate data=saplings5 normal plot; title 'saplings5';
	var sumsaplings;
run;
*N = 37 (only 37 plots with sapling obs.), skewness = 1.3873, kurtosis = 1.2449. Shapiro-Wilk: W=0.8337, p < 0.0001;





















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

*merging with plot history;
proc sort data=overstory3; by plot;
data overstory4; merge hist2 overstory3; by plot; run;
/*proc print data=overstory4; title 'overstory merged with plot history'; run; * N = 6236; */

* ---- plot-level information -----;
proc sort data=overstory4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=overstory4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var onum;
  output out=overstory5 n = onum
  					   sum = sumtrees;
* pnum = number of trees/plot  
  sumtrees = # of all trees in the plot;

proc print data=overstory5; title 'overstory5'; run; *n=52;

proc univariate data=overstory5 normal plot; title 'overstory5';
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

*merging with plot history;
proc sort data=herbs3; by plot;
data herbs4; merge hist2 herbs3; by plot; run;
/*proc print data=herbs4; title 'herbs merged with plot history'; run; * N = 5081; */

* ---- plot-level information -----;
proc sort data=herbs4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=herbs4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var hnum;
  output out=herbs5 n = hnum
  					   sum = sumherbs;
* hnum = number of stems/plot  
  sumherbs = # of all stems in the plot;

proc print data=herbs5; title 'herbs5'; run; *n=55;

proc univariate data=herbs5 normal plot; title 'herbs5';
	var sumherbs;
run;
*N = 55, skewness = 1.2252, kurtosis = 2.7804. Shapiro-Wilk: W=0.9204, p = 0.0014;













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
	* Trees (should not be included): CATE9 (Carya texana), JUVI, PITA, PRGL2 (Prosopis glandulosa), PTTR (Ptelea trifoliata), QUIN, QUMA3, QUNI, QUST, SILA2 (gum bully);

*merging with plot history;
proc sort data=shrubs3; by plot;
data shrubs4; merge hist2 shrubs3; by plot; run;
/*proc print data=shrubs4; title 'shrubs merged with plot history'; run; * N = 687; */

* ---- plot-level information -----;
proc sort data=shrubs4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=shrubs4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var shnum;
  output out=shrubs5 n = shnum
  					 sum = sumshrubs;
* shnum = number of stems/plot  
  sumshrubs = # of all stems in the plot;

proc print data=shrubs5; title 'shrubs5'; run; *n=55. Note: 0 shrub observations in 1231, 1233;

proc univariate data=shrubs5 normal plot; title 'shrubs5';
	var sumshrubs;
run;
*N = 53 (b/c 0 shrub observations in 1231, 1233), skewness = 1.8329, kurtosis = 3.0906. Shapiro-Wilk: W=0.7760, p < 0.0001;











*following dataset is large, kill previous libraries
*---------------------------------------point-intercept--------------------------------------------;
proc import datafile="f:\Excel Files\FFI long-term data\cover-points-allyrs.csv"
out=point 
dbms=csv replace;
getnames=yes;
run;
/*proc print data=point; title 'point'; run;*/

*cleanup;
data point1;
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
   hspp = species code
   hnum = count variable
   stat = status (L/D)
   Date = date of plot visit;

/*proc print data=point3; run;  * N = 5081;*/
proc freq data=point3; tables hspp; run; 
	/* ACGR = Acacia farnesiana (tree), probably meant ACGR2 (Acalypha gracilens).
	RUBUS should not be in here, it should be with shrubs.
	SMILA2 (Smilax spp.) also should be with shrubs.
	UNID1 = unidentified.
	UNFL1 = unknown flower.
	UNGR3 = unknown grass.
	UNSE1 = unknown seedling. Shouldn't even be in here! */

*merging with plot history;
proc sort data=point3; by plot;
data point4; merge hist2 point3; by plot; run;
/*proc print data=point4; title 'point intercept merged with plot history'; run; * N = 5081; */

* ---- plot-level information -----;
proc sort data=point4; by burn bcat1 bcat2 yrcat yrsincerx plot; run; 
proc means data=point4 noprint n; by burn bcat1 bcat2 yrcat yrsincerx plot;  
  var hnum;
  output out=point5 n = hnum
  					   sum = sumherbs;
* hnum = number of stems/plot  
  sumherbs = # of all stems in the plot;

proc print data=point5; title 'point5'; run; *n=55;

proc univariate data=point5 normal plot; title 'point5';
	var sumherbs;
run;
*N = 55, skewness = 1.2252, kurtosis = 2.7804. Shapiro-Wilk: W=0.9204, p = 0.0014;

