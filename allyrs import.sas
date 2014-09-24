OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

*--------------------------------------- PLOT HISTORY -----------------------------------------------------;
* This comes from my own document, not FFI;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\plothistory.csv"
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
/*proc freq data=hist2; tables burnsev; run; */

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
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\postburnsev.csv"
out=postsev 
dbms=csv replace;
getnames=yes;
run;

/* proc print data = postsev; run;
proc contents data = postsev; run;
proc freq data = postsev; tables PlotType; run;

Variables:
	Date, MacroPlot_Name, Monitoring_Status
	PlotType = Forest or Shrub
	Transect = Transect id number, out of 3
	Point = Gives each measurement a number (ex. Point 1 is at 1m, 2 is at 5m, 3 is at 10m etc.)
	TapeDist = Point on tape where measurement was taken (1m, 5m, 10m, etc.)
	Veg = Scale of 0-5. For more details on categorizations, see backside of FMH-21
		{0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned}
	Sub = See Veg
*/

* cleanup;
data postsev1 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
			   rename=(PlotType=type) rename=(TapeDist=dist) rename=(Veg=vege) 
			   rename=(Sub=subs));
	set postsev;
data postsev2 (keep=plot most type dist vege subs date);
	set postsev1;
run;

proc sort data = postsev2; by plot dist; run;

/* proc print data=postsev2; run; *N = 1227;

There's a problem--plot type is only recorded once per plot. How to drag that down? Or should
I just ignore it?

proc contents data=postsev2; run;
proc freq data=postsev2; tables type; run; */

*----------------------------------------- TREES --------------------------------------------------;
*******SEEDLINGS (INCLUDES RESPROUTS AND FFI 'SEEDLINGS', DBH < 2.5);
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\seedlings-allyrs.csv"
out=seedlings 
dbms=csv replace;
getnames=yes;
run;  * N = 998;

/*proc print data=seedlings; title 'seedlings'; run;*/

* cleanup;
data seedlings1; set seedlings;
	if Species_Symbol='' then delete;
data seedlings2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				 rename=(Species_Symbol=sspp) rename=(SizeClHt=heig) rename=(Status=stat) 
				 rename=(Count=snum));
	set seedlings1;
data seedlings3 (keep=plot most sspp heig snum stat date);
	set seedlings2;
run;
proc sort data = seedlings3; by plot; run;

/*proc contents data=seedlings3; title 'seedlings3'; run;  * N = 1033;
variables:
   plot = fmh plot #
   sspp = species code
   heig = height class
   snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   stat = L/D (live or dead)
   Date = date of plot visit;

proc print data=seedlings3; run;
proc freq data=seedlings3; tables sspp; run; */

*What to do about species with numbers in the species code? Names are longer than 4 char;

*CAAM is entered 2x (shrub, not a tree)
ILVO is entered 9x (shrub, not a tree)
UNTR1 = unknown tree, happened once in 1999, plot 1198.
XXXX = 10, meaning 10 observations of plots with no seedlings;
*two sets, one with consistent trees, the other with inconsistent spp; 

data seedlings4; set seedlings3;
	if (sspp NE "CAAM2" & sspp NE "ILVO") ;
data seedlingprobspp; set seedlings3;
	if (sspp  = "CAAM2" | sspp  = "ILVO");
run;

/* proc freq data=seedlings4; tables sspp; title 'seedlings4'; run; * N = 1022;
proc freq data=seedlingprobspp; tables sspp; title 'seedlingprobspp'; run; * N = 11; */


******POLE TREES (SAPLINGS, DBH >=2.5 and < 15.1);
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\Saplings-allyrs.csv"
out=saplings 
dbms=csv replace;
getnames=yes;
run;

/*proc print data=saplings; title 'saplings'; run; *N=2560;
proc contents data=saplings; run;

Variables:
	Date, MacroPlot, Species_Symbol, Monitoring_Status
	SizeClDia = DBH size class
	Status = L/D
	AvgHt = Height class
*/

* cleanup;
data saplings1;	set saplings;
	if Species_Symbol='' then delete;
data saplings2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				rename=(Species_Symbol=sspp) rename=(SizeClDia=diam) rename=(Status=stat) 
				rename=(AvgHt=heig));
	set saplings1;
data saplings3 (keep=plot most sspp diam stat heig date);
	set saplings2;
run;
proc sort data=saplings3; by plot; run;
/*proc contents data=saplings3; title 'saplings3'; run;  * N = 2308;
proc print data=saplings3; run;
proc freq data=saplings3; tables sspp; run; 

PINUS (3x) = unspecified species of Pinus

proc sql;
	select *
	from saplings4
	where sspp eq 'PINUS';
quit; 

All 3 instances were in 11/1999. 2 in 1200; 1 in 1206. Can reasonably change them to PITA.

ILVO is entered 3x all in 1999, splot 1193 (shrub, not a tree)
XXXX = 91, meaning 91 observations of plots with no saplings; */
*two sets, one with consistent trees, the other with inconsistent spp; 

data saplings4;	set saplings3;
	if sspp = "PINUS" then sspp = "PITA";
data saplings5; set saplings4;
	if (sspp NE "ILVO") ;
data saplingprobspp; set saplings4;
	if (sspp  = "ILVO");
run;

/* proc freq data=saplings5; tables sspp; title 'saplings5'; run; * N = 2305;
proc freq data=saplingprobspp; tables sspp; title 'saplingprobspp'; run; * N = 3; */



******OVERSTORY (MATURE TREES, DBH >= 15.1);
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\overstory-allyrs.csv"
out=overstory 
dbms=csv replace;
getnames=yes;
run;  * N = 6817;

/* proc print data=overstory; run;
proc contents data=overstory; run;

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	QTR = Quarter
	TagNo = Tag number
	Status = L/D live or dead
	DBH
	CrwnRto = Relative dominance of crown;
*/


* cleanup;
data overstory1; set overstory;
	if Species_Symbol='' then delete;
data overstory2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				 rename=(Species_Symbol=sspp) rename=(QTR=quar) rename=(TagNo=tagn) 
			 	 rename=(Status=stat) rename=(DBH=diam) rename=(CrwnRto=crwn));
	set overstory1;
data overstory3 (keep=plot most sspp quar tagn stat diam crwn date);
	set overstory2;
run;
proc sort data=overstory3; by plot; run;
/*proc contents data=overstory3; title 'overstory3'; run;  * N = 6565;
proc print data=overstory3; run;
proc freq data=overstory3; tables sspp; run; 

PINUS (1x) = unspecified species of Pinus

proc sql;
	select *
	from overstory3
	where sspp eq 'PINUS';
quit; 

PINUS was recorded in plot 1199, in 11/1999. Can reasonably change them to PITA.

UNKN1 was recorded 3x, all in 11/1999, plot 1206. Tags 11, 12, and 13, all dead. Ignoring.
proc sql;
	select *
	from overstory3
	where sspp eq 'UNKN1';
quit; 

*/

data overstory4; set overstory3;
	if sspp = "PINUS" then sspp = "PITA";
run;
/* proc freq data = overstory4; tables sspp; run; */

*--------------------------------------- SHRUBS -----------------------------------------------------;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\shrubs-allyrs.csv"
out=shrubs 
dbms=csv replace;
getnames=yes;
run;  * N = 1130;

/* proc print data=shrubs; run;
proc contents data=shrubs; run;

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	Status = L/D
	AgeCl = age class
	Count;
*/

* cleanup;
data shrubs1; set shrubs;
	if Species_Symbol='' then delete;
data shrubs2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
			  rename=(Species_Symbol=sspp) rename=(AgeCl=agec) rename=(Count=coun) 
			  rename=(Status=stat));
	set shrubs1;
data shrubs3 (keep=plot most sspp agec coun stat date);
	set shrubs2;
run;
proc sort data=shrubs3; by plot; run;

/*proc contents data=shrubs3; title 'shrubs3'; run;  * N = 890;
proc print data=shrubs3; run;
proc freq data=shrubs4; tables sspp; run; 

Problem species:
CATE9 (Carya texana) 1x in 2005, plot 1218
JUVI 2x, 2002, plot 1212
PITA 3X in 2005. 1 in 1218, 2 in 1219
PRGL2 (Prosopis glandulosa)	21x in 2002 (plot 1211) and 55x in 2005 (plot 1218)
PTTR (Ptelea trifoliata) 1x in 2006, plot 1198
QUIN 1x in 2002, plot 1212
QUMA3 1x in 2002, plot 1212
QUNI 1x in 2006, plot 1218
QUST 6x in 2002, plot 1211
RHCO (Rhus copallinum), RHCO17 (Rhus copallina). Should be copallinum.
SILA20 (Sideroxylon lanuginosum, gum bully. In trees.) 21x, all in 2002 plot 1212
XXXX = 13, meaning 13 observations of no shrubs in a plot

proc sql;
	select *
	from shrubs3
	where sspp eq 'JUVI';
quit;
*/

data shrubs4; set shrubs3;
	if sspp = "RHCO17" then sspp = "RHCO";
data shrubs5; set shrubs4;
	if (sspp NE "CATE9" & sspp NE "JUVI" & sspp NE "PITA" & sspp NE "PRGL2" & sspp NE "PTTR" &
		sspp NE "QUIN" & sspp NE "QUMA3" & sspp NE "QUNI" & sspp NE "QUST" & sspp NE "SILA20");
data shrubsprobspp; set shrubs4;
	if (sspp = "CATE9" | sspp = "JUVI" | sspp = "PITA" | sspp = "PRGL2" |sspp = "PTTR" | 
		sspp = "QUIN" | sspp = "QUMA3" | sspp = "QUNI" | sspp = "QUST" | sspp = "SILA20");
run;

/* proc freq data=shrubs5; tables sspp; title 'shrubs5'; run; * N = 874;
proc freq data=shrubsprobspp; tables sspp; title 'shrubsprobspp'; run; * N = 16; 

NOTE that all of the N's reported in this document refer to RECORDS, not COUNTS

*/

*--------------------------------------- HERBACEOUS -----------------------------------------------------;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\herbaceous-allyrs.csv"
out=herbaceous 
dbms=csv replace;
getnames=yes;
run;  * N = 8674;

/* proc print data=herbaceous; title 'herbaceous'; run;
proc contents data=herbaceous; title 'herbaceous'; run;

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	Quadrat	(1-10)
	Status = L/D (some do not have this recorded at all)
	Count;
*/

* cleanup;
data herb1 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) rename=(Status=stat)
			rename=(Species_Symbol=sspp) rename=(Quadrat=quad) rename=(Count=coun));
	set herbaceous;
data herb2 (keep=plot most sspp quad coun stat date);
	set herb1;
run;
proc sort data = herb2; by plot; run;

/*proc contents data=herb2; title 'herb2'; run;  * N = 8674;
proc print data=herb2; run;
proc freq data=herb2; tables sspp; run; 

problem species:
ACGR should be ACGR2
RUBUS and SMILA2 are shrubs
1 instance of GOGO2 (shrub, not herb)
12 UNFL1 (Unknown flower) (1999, many plots)
30 UNGR1 (Unknown grass) (1999, many plots)
1 UNGR3	(Unknown grass)	(2002, plot 1209)
2 UNID1	(Unidentified) (1999, plot 1194)
5 UNSE1	(Unknown seedling) (2003, plot 1195)
1 XXXX -- 2005, plot 1203. Nothing in herbaceous quadrats.

proc sql;
	select *
	from herb2
	where sspp eq 'XXXX';
quit;
*/

*Removing UNSE1 observations--seedlings shouldn't be in this dataset anyway;

data herb3; set herb2;
	if sspp = 'UNSE1' or sspp = 'RUBUS' or sspp = 'SMILA2' or sspp = '' then delete;
	if sspp = 'ACGR' then sspp = 'ACGR2'; 
run;
/* proc contents data=herb3; title 'herb3'; run;  * N = 8414;
proc print data=herb3; run;
proc freq data=herb3; tables sspp; run;  */
	

*--------------------------------------- POINT INTERCEPT -----------------------------------------------------;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\PointIntercept-allyrs.csv"
out=transect 
dbms=csv replace;
getnames=yes;
run;  * N = 41,961. File size ~ 3MB;

/* proc print data=transect; title 'transect'; run;
proc contents data=transect; title 'transect'; run;

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	Point = numbered point on tape (0.3m = point 1,  0.6m = point 2, etc.)
	Tape = distance on tape measure
	Height = height of tallest plant at any given point;
*/

* cleanup;
data trans1 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) rename=(Point=poin)
			rename=(Species_Symbol=sspp) rename=(Height=heig));
	set transect;
data trans2 (keep=plot most Tape sspp poin heig date);
	set trans1;
run;
data trans3; set trans2;
	if  sspp = '' then delete;
proc sort data = trans3; by plot; run;

/*proc contents data=trans3; title 'trans3'; run;  * N = 41,703;
proc print data=trans3; run;
proc freq data=trans3; tables sspp; run; 
*/

*--------------------------------------- CANOPY COVER -----------------------------------------------------;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\CanopyCoverallyrs.csv"
out=canopy 
dbms=csv replace;
getnames=yes;
run;  * N = 196;
/* proc contents data = canopy; title 'canopy'; run;
proc print data = canopy; run;  */

data canopy1 (rename=(Burn_Severity=bsev) rename=(Origin=orig) rename=(Q1=qua1)
			rename=(Q2=qua2) rename=(Q3=qua3) rename=(Q4=qua4));
	drop Total_Canopy_Cover;
	set canopy;
data canopy2;
	set canopy1;
	cavg = (qua1 + qua2 + qua3 + qua4 + orig)/5;
run;
proc sort data = canopy2; by plot; run;
/* proc contents data = canopy2; title 'canopy2'; run; 
proc print data = canopy2; run;	*/


*****************merging canopy cover and plot history with all else;
data seedlings5; merge hist2 canopy2 seedlings4; by plot; run; 
proc print data = seedlings5; title 'seedlings5'; run; *N = 1039;
proc contents data = seedlings5; run;

proc sql;
	select burnsev, bsev, plot
	from seedlings5;
quit;

*check burnsevs on 1182, 1183, 1184, 1185, 1196, 1211, 1212, 1218, 1225, 1226, 1223, 1229, 1233, 1234, 1238, 1239, 1240;
/* CODE FROM LAST YEAR. NOT INCLUDING IN AUTOMATIC RUN.

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
/*proc print data=pineoak3; run;
proc contents data = pineoak3; run;
proc freq data=pineoak3; tables sspp*burn; title 'pineoak'; run; * N = 491;*/

*/
