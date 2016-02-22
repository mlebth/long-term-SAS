OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";
 
*--------------------------------------- PLOT HISTORY -----------------------------------------------------;
* This comes from my own document, not FFI;
proc import datafile="g:\Research\FMH All Data\FFI long-term data\plothistory.csv" 
out=hist dbms=csv replace; getnames=yes; run;  * N = 61;

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
/*
*--------------------------------------- FUELS AND SPECIES COMP -----------------------------------------------------;
* All these fuels data were only collected in 1999. Not including in mass import. ;

proc import datafile="g:\Excel Files\FFI long-term data\duff-1999.csv"
out=duff dbms=csv replace; getnames=yes; run;

proc import datafile="g:\Excel Files\FFI long-term data\1000hrfuels-1999.csv"
out=cwd dbms=csv replace; getnames=yes;run;

proc import datafile="g:\Excel Files\FFI long-term data\finefuels-1999.csv"
out=finefuels dbms=csv replace; getnames=yes; run;

* For species comp, from FMH handbook--'Ocular estimates of cover for plant species on a macroplot'
Collected on about 13 plots, 2010-2013. no more than 5-6 spp recorded per plot, and no cover recorded. 
Also entered for 2002, 2003, 2005, 2006, but completely blank. Not including in mass import. ;

proc import datafile="g:\Excel Files\FFI long-term data\cover-speciescomp-allyrs.csv"
out=spcomp dbms=csv replace; getnames=yes;run;
*/

*--------------------------------------- POST-BURN SEVERITY ASSESSMENT DATA -----------------------------------------------------;
*Data were collected in all plots in 2011, and one plot in 2008. Data for 2012 included but blank.;
proc import datafile="g:\Research\FMH All Data\FFI long-term data\postburnsev.csv"
out=postsev dbms=csv replace; getnames=yes; run;  * N = 1227;

/* proc print data = postsev; run;
proc contents data = postsev; run;
proc freq data = postsev; tables PlotType; run;	*/

* Variables:
	Date, MacroPlot_Name, Monitoring_Status
	PlotType = Forest or Shrub
	Transect = Transect id number, out of 3
	Point = Gives each measurement a number (ex. Point 1 is at 1m, 2 is at 5m, 3 is at 10m etc.)
	TapeDist = Point on tape where measurement was taken (1m, 5m, 10m, etc.)
	Veg = Scale of 0-5. For more details on categorizations, see backside of FMH-21
		{0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned}
	Sub = See Veg;

* cleanup;
data postsev1; set postsev;
   plot = MacroPlot_Name; most = Monitoring_Status; 
   type = PlotType; dist = TapeDist; vege = Veg; subs=Sub; 
    * keep plot most type dist vege subs date;
   keep plot most type dist vege subs;
run;   
data dummydat; input plot most type $ dist vege subs;
datalines;
9999 9999 xxxxx 9999 9 9
9999 9999 xxxxx 9999 9 9
9999 9999 xxxxx 9999 9 9
;                                                             * N = 3;
data dummydatx; set dummydat;
  if type = 'xxxxx' then type = '     '; run;
data postsev2x; set postsev1 dummydat;
*proc print data=postsev2x; *title 'postsev2x';
run;                                                          * N = 1230;

data postsev2x1; set postsev2x; dummy=1; keep plot type dummy;
proc sort data=postsev2x1; by type plot; run;
/*proc print data=postsev2x1; title 'postsev2x1';
run; */

/* * how many plots?;    * 41 plots in this data set, all have labeled type;
proc sort data=postsev2x1; by plot;
proc means data=postsev2x1 n; by plot; output out=moutx n=n;
proc print data=moutx; run; */

* only plots with labeled types;
data postsev2x2; set postsev2x1; if (type ^= '      ' | type ^= '     ');  * N = 59 labeled plots;
/*proc print data=postsev2x2; title 'postsev2x2';
run; */
proc means data=postsev2x2 mean noprint; var dummy; by type plot;
  output out=mout1 mean=meandummy;
*proc print data=mout1; *title 'mout1';
run;                                                                       * N = 41 plots with a labeled type;
data mout2; set mout1; 
  if type = 'Forest' then typecat = 'f';
  if type = 'Shrub' then typecat = 's';
/*proc print data=mout2; title 'mout2';                                      * N = 41;
run;*/
proc sort data=mout2; by plot;
proc sort data=postsev2x; by plot;
* merge back in the typecat information of the labeled plot;
data postsev2x3; merge postsev2x mout2; by plot;
  if typecat = ' ' then typecat='m';
run;
/*proc print data=postsev2x3; title 'postsev2x3';                            * N = 1227;
run; */
* final cleanup;
data postsev2; set postsev2x3;
  if ( (plot ^= 9999) & (dist^=.| vege^=.|subs^=.) );
  keep plot most dist vege subs typecat;
run;
/*proc print data=postsev2; title 'postsev2';
run;*/                                                                       * N = 1168;

proc sort data = postsev2; by plot dist; run;


*----------------------------------------- TREES --------------------------------------------------;
*******SEEDLINGS (INCLUDES RESPROUTS AND FFI 'SEEDLINGS', DBH < 2.5);
/*proc import datafile="D:\FFI CSV files\seedlings-allyrs.csv" */

proc import datafile="g:\Research\FMH All Data\FFI long-term data\seedlings-allyrs.csv"
out=seedlings dbms=csv replace; getnames=yes;
run;  * N = 998;

/*proc print data=seedlings; title 'seedlings'; run;*/

* cleanup;
data seedlings1; set seedlings;
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set seedlings1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
/*proc print data=dat3; run;*/

data seedlings2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				 rename=(char3=sspp) rename=(SizeClHt=heig) rename=(Status=stat) 
				 rename=(Count=coun));
	set dat2;
data seedlings3 (keep=plot most sspp heig coun stat date);
	set seedlings2;
run;
proc sort data = seedlings3; by plot; run;

/*proc contents data=seedlings3; title 'seedlings3'; run;  * N = 1033;
proc print data=seedlings3; run;
proc freq data=seedlings3; tables sspp; run; */

*variables:
   plot = fmh plot #
   sspp = species code
   heig = height class
   coun = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   stat = L/D (live or dead)
   Date = date of plot visit;

*CAAM is entered 2x (shrub, not a tree)
ILVO is entered 9x (shrub, not a tree)
UNTR1 = unknown tree, happened once in 1999, plot 1198.
XXXX = 10, meaning 10 observations of plots with no seedlings;

*two sets, one with consistent trees, the other with inconsistent spp; 
data seedlings4; set seedlings3;
	if (sspp NE "CAAM2" & sspp NE "ILVOx") ;
data seedlingprobspp; set seedlings3;
	if (sspp  = "CAAM2" | sspp  = "ILVOx");
run;

/*proc contents data=seedlings4; run;

proc sql;
	select sspp, coun, plot	, date
	from seedlings4
	where sspp in ('PITA', 'QUMA', 'QUMA3', 'XXXX') and
	 most eq '2014';
quit; 

proc freq data=seedlings4; tables sspp*plot; title 'seedlings4'; run; * N = 1022;
proc freq data=seedlingprobspp; tables sspp; title 'seedlingprobspp'; run; * N = 11; */


******POLE TREES (SAPLINGS, DBH >=2.5 and < 15.1);
/*proc import datafile="D:\FFI CSV files\Saplings-allyrs.csv"*/

proc import datafile="g:\Research\FMH All Data\FFI long-term data\Saplings-allyrs.csv"
out=saplings dbms=csv replace; getnames=yes;
run;

/*proc print data=saplings; title 'saplings'; run; *N=2560;
proc contents data=saplings; run; */

*Variables:
	Date, MacroPlot, Species_Symbol, Monitoring_Status
	SizeClDia = DBH size class
	Status = L/D
	AvgHt = Height class;

* cleanup;
data saplings1;	set saplings;
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set saplings1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data saplings2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				rename=(char3=sspp) rename=(SizeClDia=diam) rename=(Status=stat) 
				rename=(AvgHt=heig));
	set dat2;
data saplings3 (keep=plot most sspp diam stat heig date);
	set saplings2;
run;
proc sort data=saplings3; by plot; run;

/*proc contents data=saplings3; title 'saplings3'; run;  * N = 2308;
proc print data=saplings3; run;
proc freq data=saplings3; tables sspp; run; */

*PINUS (3x) = unspecified species of Pinus;

/*proc sql;
	select *
	from saplings4
	where sspp eq 'PINUS';
quit;  */

*All 3 instances were in 11/1999. 2 in 1200, 1 in 1206. Can reasonably change them to PITA.
ILVO is entered 3x all in 1999, splot 1193 (shrub, not a tree)
XXXX = 91, meaning 91 observations of plots with no saplings; 

*two sets, one with consistent trees, the other with inconsistent spp; 
data saplings4;	set saplings3;
	if sspp = "PINUS" then sspp = "PITAx";
data saplings5; set saplings4;
	if (sspp NE "ILVOx") ;
data saplingprobspp; set saplings4;
	if (sspp  = "ILVOx");
run;

/* proc freq data=saplings5; tables sspp; title 'saplings5'; run; * N = 2305;
proc freq data=saplingprobspp; tables sspp; title 'saplingprobspp'; run; * N = 3; */


******OVERSTORY (MATURE TREES, DBH >= 15.1);
/*proc import datafile="D:\FFI CSV files\overstory-allyrs.csv"*/

proc import datafile="g:\Research\FMH All Data\FFI long-term data\overstory-allyrs.csv"
out=overstory dbms=csv replace; getnames=yes;
run;  

/* proc print data=overstory; run; * N = 6817;
proc contents data=overstory; run; */

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	QTR = Quarter
	TagNo = Tag number
	Status = L/D live or dead
	DBH
	CrwnRto = Relative dominance of crown;

* cleanup;
data overstory1; set overstory;
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set overstory1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data overstory2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				 rename=(char3=sspp) rename=(QTR=quar) rename=(TagNo=tagn) 
			 	 rename=(Status=stat) rename=(DBH=diam) rename=(CrwnRto=crwn));
	set dat2;
data overstory3 (keep=plot most sspp quar tagn stat diam crwn date);
	set overstory2;
run;
proc sort data=overstory3; by plot; run;
/*proc contents data=overstory3; title 'overstory3'; run;  * N = 6565;
proc print data=overstory3; run;
proc freq data=overstory3; tables sspp; run;  */

*PINUS (1x) = unspecified species of Pinus;

/*proc sql;
	select *
	from overstory3
	where sspp eq 'PINUS';
quit; */

*PINUS was recorded in plot 1199, in 11/1999. Can reasonably change them to PITA.
UNKN1 was recorded 3x, all in 11/1999, plot 1206. Tags 11, 12, and 13, all dead. Ignoring;

/*proc sql;
	select *
	from overstory3
	where sspp eq 'UNKN1';
quit; */

data overstory4; set overstory3;
	if sspp = "PINUS" then sspp = "PITAx";
run;
/* proc freq data = overstory4; tables sspp; run; */

*--------------------------------------- SHRUBS -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\shrubs-allyrs.csv"*/

proc import datafile="g:\Research\FMH All Data\FFI long-term data\shrubs-allyrs.csv"
out=shrubs dbms=csv replace; getnames=yes;
run; 

/* proc print data=shrubs; run; * N = 1130;
proc contents data=shrubs; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	Status = L/D
	AgeCl = age class
	Count;

* cleanup;
data shrubs1; set shrubs;
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set shrubs1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data shrubs2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
			  rename=(char3=sspp) rename=(AgeCl=agec) rename=(Count=coun) 
			  rename=(Status=stat));
	set dat2;
data shrubs3 (keep=plot most sspp agec coun stat date);
	set shrubs2;
run;
proc sort data=shrubs3; by plot; run;

/*proc contents data=shrubs3; title 'shrubs3'; run;  * N = 890;
proc print data=shrubs3; run;
proc freq data=shrubs3; tables sspp*coun; run; 	*/

*Problem species:
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
XXXX = 13, meaning 13 observations of no shrubs in a plot ;

/*proc sql;
	select *
	from shrubs3
	where sspp eq 'JUVI';
quit; */

data shrubs4; set shrubs3;
	if sspp = "RHCO1" then sspp = "RHCOx";
data shrubs5; set shrubs4;
	if (sspp NE "CATE9" & sspp NE "JUVIx" & sspp NE "PITAx" & sspp NE "PRGL2" & sspp NE "PTTRx" &
		sspp NE "QUINx" & sspp NE "QUMA3" & sspp NE "QUNIx" & sspp NE "QUSTx" & sspp NE "SILA2");
data shrubsprobspp; set shrubs4;
	if (sspp = "CATE9" | sspp = "JUVIx" | sspp = "PITAx" | sspp = "PRGL2" |sspp = "PTTRx" | 
		sspp = "QUINx" | sspp = "QUMA3" | sspp = "QUNI" | sspp = "QUSTx" | sspp = "SILA2");
run;

/* proc freq data=shrubs5; tables sspp; title 'shrubs5'; run; * N = 874;
proc freq data=shrubsprobspp; tables sspp; title 'shrubsprobspp'; run; * N = 16;  */

***************NOTE that all of the N's reported in here refer to RECORDS, not COUNTS;

/*proc print data=shrubs5; run; */

*--------------------------------------- HERBACEOUS -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\herbaceous-allyrs.csv"*/

proc import datafile="g:\Research\FMH All Data\FFI long-term data\herbaceous-allyrs.csv"
out=herbaceous dbms=csv replace; getnames=yes;
run;  * N = 8674;

/* proc print data=herbaceous; title 'herbaceous'; run;
proc contents data=herbaceous; title 'herbaceous'; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	Quadrat	(1-10)
	Status = L/D (some do not have this recorded at all)
	Count;

* cleanup;
data herb1; set herbaceous;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set herb1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data herb2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) rename=(Status=stat)
			rename=(Species_Symbol=sspp) rename=(Quadrat=quad) rename=(Count=coun));
	set dat2;
data herb3 (keep=plot most sspp quad coun stat date);
	set herb2;
run;
proc sort data = herb3; by plot; run;

/*proc contents data=herb2; title 'herb2'; run;  * N = 8674;
proc print data=herb2; run;
proc freq data=herb2; tables sspp; run;  */

* problem species:
ACGR should be ACGR2
RUBUS and SMILA2 are shrubs
1 instance of GOGO2 (shrub, not herb)
12 UNFL1 (Unknown flower) (1999, many plots)
30 UNGR1 (Unknown grass) (1999, many plots)
1 UNGR3	(Unknown grass)	(2002, plot 1209)
2 UNID1	(Unidentified) (1999, plot 1194)
5 UNSE1	(Unknown seedling) (2003, plot 1195)
1 XXXX -- 2005, plot 1203. Nothing in herbaceous quadrats.;

/*proc sql;
	select *
	from herb2
	where sspp eq 'XXXX';
quit;
*/

*Removing UNSE1 observations--seedlings shouldn't be in this dataset anyway;
data herb3; set herb2;
	if sspp = 'UNSE1' or sspp = 'RUBUS' or sspp = 'SMILA2' or sspp = '' then delete;
	if sspp = 'ACGRx' then sspp = 'ACGR2'; 
run;
/* proc contents data=herb3; title 'herb3'; run;  * N = 8414;
proc print data=herb3; run;
proc freq data=herb3; tables sspp; run;  */
	

*--------------------------------------- POINT INTERCEPT -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\PointIntercept-allyrs.csv"	*/

proc import datafile="g:\Research\FMH All Data\FFI long-term data\PointIntercept-allyrs.csv"
out=transect dbms=csv replace; getnames=yes;
run;  

/* proc print data=transect; title 'transect'; run;	* N = 41,961. File size ~ 3MB;
proc contents data=transect; title 'transect'; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, Monitoring_Status
	Point = numbered point on tape (0.3m = point 1,  0.6m = point 2, etc.)
	Tape = distance on tape measure
	Height = height of tallest plant at any given point;

* cleanup;

data trans1; set transect;
	if  Species_Symbol = '' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set trans1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data trans2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) rename=(Point=poin)
			rename=(char3=sspp) rename=(Height=heig));
	set dat2;
data trans3 (keep=plot most Tape sspp poin heig date);
	set trans2;
run;
proc sort data = trans3; by plot; run;

/*proc contents data=trans3; title 'trans3'; run;  * N = 41,703;
proc print data=trans3; run;
proc freq data=trans3; tables sspp; run; */

*--------------------------------------- CANOPY COVER -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\CanopyCoverallyrs.csv"*/

proc import datafile="g:\Research\FMH All Data\FFI long-term data\Bastrop Canopy Cover Table.csv"
out=canopy dbms=csv replace; getnames=yes;
run;  
/* proc contents data = canopy; title 'canopy'; run; * N = 196;
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
data seedlings5; merge hist2 canopy2 seedlings4; by plot; year = year(date); run; 
/*proc print data = seedlings5; title 'seedlings5'; run; *N = 1039;
proc contents data = seedlings5; run;

proc sql;
	select burnsev, bsev, plot
	from seedlings5;
quit; */

*check burnsevs on 1182, 1183, 1184, 1185, 1196, 1211, 1212, 1218, 1225, 1226, 1223, 1229, 1233, 1234, 1238, 1239, 1240;
*repeat and condense--need this for all data sets;

****************putting seedlings and shrubs together to have pines, oaks, and ilex in the same set;
data seedlingsshrubs; merge shrubs5 seedlings5 ; by plot; run;
proc print data=seedlingsshrubs; var plot sspp year; run;

* pulling just the important species--pines, ilvo, and quma, quma3;
data piquil; set seedlingsshrubs;
	if (sspp = "PITAx" |sspp = "QUMAx" | sspp = "QUMA3" | sspp = "ILVOx");
run; /* proc print data=piquil; title 'piquil'; var plot sspp; run;*/
/* proc freq data=pineoak; tables sspp; title 'pineoak'; run; * N = 473; */

proc sort data=piquil; by plot;  
data piquil2; merge hist2 piquil; by plot; year = year(date); run;
/* proc print data=piquil2; title 'piquil2'; var plot sspp year; run;*/
data piquil3; set piquil2;
   if (sspp = '     ') then sspp = 'NONEx';
   if year < 2011 then prpo = 'pref';
   if year >= 2011 then prpo = 'post';
run;
proc print data=piquil3; title 'piquil3'; var plot sspp year prpo; run;  * N = 697;

/*proc print data=piquil3; run;
proc contents data = piquil3; run;
proc freq data=piquil3; tables sspp*coun; title 'pineoak'; run;*/
