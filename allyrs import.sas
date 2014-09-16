
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
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data\seedlings-allyrs.csv"
out=seedlings 
dbms=csv replace;
getnames=yes;
run;  * N = 998;

/*proc print data=seedlings; title 'seedlings'; run;*/

* cleanup;
data seedlings1;
	set seedlings;
	if Species_Symbol='' then delete;
data seedlings2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=sspp) rename=(SizeClHt=shgt) rename=(Status=stat) rename=(Count=snum));
	set seedlings1;
data seedlings3 (keep=plot sspp shgt snum stat Date);
	set seedlings2;
run;
proc contents data=seedlings3; title 'seedlings3'; run;  * N = 1033;
*variables
   plot = fmh plot #
   sspp = species code
   shgt = height class
   snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   stat = L/D (live or dead)
   Date = date of plot visit;

/*proc print data=seedlings3; run;*/
proc freq data=seedlings3; tables sspp; run; 
*What to do about species with numbers in the species code? Names are longer than 4 char;
	/* CAAM is entered 2x (shrub, not a seedling)
	ILVO is entered 9x (shrub, not a seedling)
	UNTR1 = unknown tree
    XXXX = 10, meaning 10 plots with no seedlings*/
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
