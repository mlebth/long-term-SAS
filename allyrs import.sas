OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";


*--------------------------------------- PLOT HISTORY -----------------------------------------------------;
* This comes from my own document, not FFI;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data\plothistory.csv"
out=hist 
dbms=csv replace;
getnames=yes;
run;

/*proc contents data=hist; title 'plot history'; run;
proc print data=hist; run;  * N = 61; */
* plot history data in this file;
* variables: 
   burnsev (s, l, m, h) = wildfire severity
   hydr (x, n, l, h) = hydromulch [x = unknown, n = none, l = light, h = heavy]
   lastrx = year of last prescribed burn
   yrrx1, yrrx2, yrrx3 = years of rx burns since 2003
   plot = fmh plot #;

*plot history cleanup;
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

*--------------------------------------- FUELS AND SPECIES COMP -----------------------------------------------------;
/* All these fuels data were only collected in 1999. Not including in mass import.

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

For species comp, from FMH handbook--'Ocular estimates of cover for plant species on a macroplot'
Collected on about 13 plots, 2010-2013. no more than 5-6 spp recorded per plot, and no cover recorded. 
Also entered for 2002, 2003, 2005, 2006, but completely blank. Not including in mass import.

proc import datafile="g:\Excel Files\FFI long-term data\cover-speciescomp-allyrs.csv"
out=spcomp 
dbms=csv replace;
getnames=yes;
run;

*/

*--------------------------------------- POST-BURN SEVERITY -----------------------------------------------------;
*Data were collected in all plots in 2011, and one plot in 2008. Data for 2012 included but blank.;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data\postburnsev.csv"
out=postsev 
dbms=csv replace;
getnames=yes;
run;

/* proc print data = postsev; run;
proc contents data = postsev; run;
proc freq data = postsev; tables PlotType; run;

Variables:
	Date, MacroPlot_Name, 
	PlotType = Forest or Shrub
	Transect = Transect id number, out of 3
	Point = Gives each measurement a number (ex. Point 1 is at 1m, 2 is at 5m, 3 is at 10m etc.)
	TapeDist = Point on tape where measurement was taken (1m, 5m, 10m, etc.)
	Veg = Scale of 0-5. For more details on categorizations, see backside of FMH-21
		{0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned}
	Sub = See Veg
*/

* cleanup;
data postsev1 (rename=(MacroPlot_Name=plot) rename=(PlotType=type) rename=(TapeDist=dist) rename=(Veg=vege) rename=(Sub=subs));
	set postsev;
data postsev2 (keep=plot type dist vege subs);
	set postsev1;
run;

proc sort data = postsev2; by plot dist; run;
data postsev3;
	set postsev2;
	for each plot
	if type = '' then  type = type;

/* proc print data=postsev2; run; *N = 1227;
proc contents data=postsev2; run;
proc freq data=postsev2; tables type; run; */

*----------------------------------------- TREES --------------------------------------------------;
*******SEEDLINGS (INCLUDES RESPROUTS AND FFI 'SEEDLINGS');
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

/*proc contents data=seedlings3; title 'seedlings3'; run;  * N = 1033;
variables:
   plot = fmh plot #
   sspp = species code
   shgt = height class
   snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   stat = L/D (live or dead)
   Date = date of plot visit;

proc print data=seedlings3; run;
proc freq data=seedlings3; tables sspp; run; */

*What to do about species with numbers in the species code? Names are longer than 4 char;

*CAAM is entered 2x (shrub, not a tree)
ILVO is entered 9x (shrub, not a tree)
VAAR is entered 169x
UNTR1 = unknown tree
XXXX = 10, meaning 10 observations of plots with no seedlings;
*two sets, one with consistent trees, the other with inconsistent spp; 
data seedlings4; set seedlings3;
	if (sspp NE "CAAM2" & sspp NE "ILVO" & sspp NE "VAAR") ;
data seedlingprobspp; set seedlings3;
	if (sspp  = "CAAM2" | sspp  = "ILVO" | sspp  = "VAAR");
run;

/* proc freq data=seedlings4; tables sspp; title 'seedlings4'; run; * N = 853;
proc freq data=seedlingprobspp; tables sspp; title 'seedlingprobspp'; run; * N = 180; */


******POLE TREES (SAPLINGS);
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data\Saplings-allyrs.csv"
out=saplings 
dbms=csv replace;
getnames=yes;
run;

/*proc print data=saplings; title 'saplings'; run; *N=2560;
proc contents data=saplings; run;

Variables:
	Date, MacroPlot, Species_Symbol
	SizeClDia = DBH size class
	Status = L/D
	AvgHt = Height class
*/

* cleanup;
data saplings1;
	set saplings;
	if Species_Symbol='' then delete;
data saplings2 (rename=(MacroPlot_Name=plot) rename=(Species_Symbol=sspp) rename=(SizeClDia=diam) rename=(Status=stat) rename=(AvgHt=heig));
	set saplings1;
data saplings3 (keep=plot sspp diam stat heig Date);
	set saplings2;
run;

/*proc contents data=saplings3; title 'saplings3'; run;  * N = 2308;
proc print data=saplings3; run;
proc freq data=saplings3; tables sspp; run; */

*ILVO is entered 3x (shrub, not a tree)
VAAR is entered 45x
XXXX = 91, meaning 91 observations of plots with no saplings;
*two sets, one with consistent trees, the other with inconsistent spp; 
data saplings4; set saplings3;
	if (sspp NE "ILVO" & sspp NE "VAAR") ;
data saplingprobspp; set saplings3;
	if (sspp  = "ILVO" | sspp  = "VAAR");
run;

/* proc freq data=saplings4; tables sspp; title 'saplings4'; run; * N = 2260;
proc freq data=saplingprobspp; tables sspp; title 'saplingprobspp'; run; * N = 48; */

/* PINUS (3x) = unspecified species of Pinus

proc sql;
	select *
	from saplings4
	where sspp eq 'PINUS';
quit; 

All 3 instances were in 11/1999. 2 in 1200; 1 in 1206. Can reasonably change them to PITA.
*/
