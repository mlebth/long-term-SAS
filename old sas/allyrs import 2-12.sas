
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

/* *if processes get too slow, run this to free up memory, then rerun relevant 
	sections;

proc datasets library=work kill; run; 
*/

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

*--------------------------------------- POST-BURN SEVERITY ASSESSMENT AND PLOT HISTORY -----------------------------------------------------;
*Data were collected in all plots in 2011, and one plot in 2008. Data for 2012 included but blank.;
/*proc import datafile="g:\FFI CSV files\postburnsev.csv"*/

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\postburnsev.csv"
out=postsev dbms=csv replace; getnames=yes; run;  * N = 1227;
/* proc print data = postsev; run;
proc contents data = postsev; run;
proc freq data = postsev; tables PlotType; run;	*/

data postsev1; set postsev;
   plot = MacroPlot_Name; year = year(date); 
   type = PlotType; vege = Veg; subs=Sub; 
   keep plot year type vege subs;
run;   	*N = 1227;
proc sort data=postsev1; by plot; run;
*proc print data=postsev1; *run;

* Variables:
	Date, MacroPlot_Name, 
	PlotType = Forest or Shrub
	Transect = Transect id number, out of 3
	Point = Gives each measurement a number (ex. Point 1 is at 1m, 2 is at 5m, 3 is at 10m etc.)
	TapeDist = Point on tape where measurement was taken (1m, 5m, 10m, etc.)
	Veg = Scale of 0-5. For more details on categorizations, see backside of FMH-21
		{0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned}
	Sub = See Veg;

*Fixing plot type variable;
data dummydat; input plot year type $ vege subs;
datalines;
9999 9999 xxxxx 9 9
9999 9999 xxxxx 9 9
9999 9999 xxxxx 9 9
;                                                             * N = 3;
data dummydatx; set dummydat;
  if type = 'xxxxx' then type = '     '; run;
data postsev2x; set postsev1 dummydatx; run; * N = 1230;
proc sort data=postsev2x; by plot type; run;
/*proc print data=postsev2x; title 'postsev2x'; run; */

data postsev2x1; set postsev2x; dummy=1; keep plot year type vege subs dummy;
proc sort data=postsev2x1; by plot type; run;
/*proc print data=postsev2x1; title 'postsev2x1'; run; *N = 1230; */

* only plots with labeled types;
data postsev2x2; set postsev2x1; if (type ^= '      ' | type ^= '     '); run;  * N = 59;
proc sort data=postsev2x2; by plot type; run;
/*proc print data=postsev2x2; title 'postsev2x2'; run; */
                                                                   
data mout2; set postsev2x2; 
  if type = 'Forest' then typecat = 'f';
  if type = 'Shrub' then typecat = 's';	run;
proc sort data=mout2; by plot; 
/*proc print data=mout2; title 'mout2'; run; * N = 59;
proc contents data=mout2;run; plot, year, dummy, vege, subs, type, typecat*/

* merge back in the typecat information of the labeled plot;
data postsev2x3; merge postsev2x1 mout2; by plot;
  if typecat = ' ' then typecat='m';
run;
proc sort data=postsev2x3; by plot year typecat; run;
/*proc print data=postsev2x3; title 'postsev2x3'; run; * N = 1230;
proc contents data=postsev2x3;run; */
data postsev2x4; set postsev2x3;
	keep plot year typecat vege subs;
	if vege = '.' then delete;
run;
/* proc print data=postsev2x4; title 'postsev2x4'; run;  *N=1112; */

*getting mean burn sev with both vege and subs;
proc means data=postsev2x4 mean noprint; var vege subs; by plot year typecat;
	output out=postsev2x5 mean=meansev;
run;
proc sort data = postsev2x5; by plot; run; 
/* proc print data=postsev2x5; title 'postsev2x5'; run; *N=43; 
*41 plots--one of these is '9999', and only plot 1226 was sampled twice with this method--once in 2008, once in 2011;
*/

* Plot history: This comes from my own document, not FFI;
* Includes hydromulch, rx burn history, and burn severity variables. Burn severity is only for plots 1227-5300--these are the new plots
that were not included in the initial post-burn assessment. Qualitative assessment was done in summer 2012.;
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\plothistory.csv"  
out=hist dbms=csv replace; getnames=yes; 
run;  * N = 56;
/*proc contents data=hist; title 'plot history'; run;
proc print data=hist; run;  * N = 56; */

* plot history data in this file;
* variables: 
   burnsev (u, s, l, m, h) = wildfire severity
   hydr (x, n, l, h) = hydromulch [x = unknown, n = none, l = light, h = heavy]
   lastrx = year of last prescribed burn
   yrrx1, yrrx2, yrrx3 = years of rx burns since 2003
   plot = fmh plot #
   soil1 = full SSURGO soil name
   soil2 = abbreviated soil names:
		{fslo = fine sandy loam, gfsl = gravelly fine sandy loam, sand = fine sand, loam = loam, lfsa = loamy fine sand}
   elev	= elevation in m above sea level
   slope = % change in elevation
   aspect = azimuth (values of -1 = undefined--slope =<2);
                                                              
*plot history cleanup;
data hist2; set hist (rename=(aspect=oldaspect));
   drop soil1;
   soil = soil2;
   drop soil2;
   if lastrx = 9999 then lastrx = .;
   if yrrx1 = 9999 then yrrx1 = .;
   if yrrx2 = 9999 then yrrx2 = .;
   if yrrx3 = 9999 then yrrx3 = .;
   /* years since prescribed fire variables. So far not very useful.
   lastrx = 2014 - yrrx;
   if (lastrx = .) then yrcat = 'nev';
   if (lastrx = 3| lastrx = 6 | lastrx = 7) then yrcat = 'rec';
   if (lastrx = 9 | lastrx = 11) then yrcat = 'old';   */
   * categorizing aspects;
   if (oldaspect = -1) then temp = 0; 
   if (oldaspect >= 0 	& oldaspect < 45)	then temp = 1; 
   if (oldaspect >= 315 & oldaspect <= 360) then temp = 1;
   if (oldaspect >= 45  & oldaspect < 135)  then temp = 2;
   if (oldaspect >= 135 & oldaspect < 225)  then temp = 3;
   if (oldaspect >= 225 & oldaspect < 315)  then temp = 4;	
   * making aspect a character variable;
   aspect = put(temp,4. -L);
   drop oldaspect temp;
   * translating aspect number categories to cardinal directions;
   if aspect = '0' then aspect = 'flat';
   if aspect = '1' then aspect = 'nort';
   if aspect = '2' then aspect = 'east'; 
   if aspect = '3' then aspect = 'sout';
   if aspect = '4' then aspect = 'west';
run;
proc sort data=hist2; by plot; run;
/* proc print data=hist2; title 'hist2'; run; *N = 56;
proc freq data=hist2; tables burnsev; run; 
proc contents data=hist2; run;
*/

*merging post-fire assessment and plot history files;
data plothist1; merge hist2 postsev2x5; by plot; 
run;
proc sort data=plothist1; by plot year typecat burnsev lastrx yrrx1 yrrx2 yrrx3; run;
/* proc print data=plothist1; title 'plothist1'; run; *N = 58;
proc freq data=plothist1; tables burnsev; run; */

* burnsev cleanup;
data plothist (drop=_TYPE_ _FREQ_ year); set plothist1;
	*deleting 2008: there is only one stray plot recorded in 2008, maybe from an rx burn? 
	not useful without others;
	if year=2008 then delete;
	* assigning burnsev categories to vege+subs burn avg;
	if 1 <= meansev <2 then burnsev = 'h';
	if 2 <= meansev <3 then burnsev= 'm';
	if 3 <= meansev <4 then burnsev = 'l';
	if 4 <= meansev <5 then burnsev = 's';
	if meansev = 5     then burnsev = 'u';
	if meansev = 9 	   then delete;
	* makes new set of treatment names with natural ordering for graphs and constrasts;
    if burnsev = 'u' then burn = 0;
    if burnsev = 's' then burn = 1;
    if burnsev = 'l' then burn = 2;
    if burnsev = 'm' then burn = 3;
    if burnsev = 'h' then burn = 4;
	* poolingA - scorch, light, moderate;
    if (burnsev = 'h') then bcat1 = 'B';
    if (burnsev = 'm' | burnsev = 'l' | burnsev = 's') then bcat1 = 'A';
    if (burnsev = 'u') then bcat1 = 'X';
    * poolingB - combine scorch + light;
    if (burnsev = 'h') then bcat2 = 'C';
    if (burnsev = 'm') then bcat2 = 'B';
    if (burnsev = 's' | burnsev = 'l') then bcat2 = 'A';	
    if (burnsev = 'u') then bcat2 = 'X';
	*typecat for new plots--all forest;
	if typecat = '' then typecat = 'f';
run;
proc sort data=plothist; by plot; run;
/*proc print data=plothist; title 'plothist'; run; * N =56;
proc contents data=plothist; run; */

*IMPORTANT: plots 1227-5300 were given burnsev classes visually, veg and subs measurements were not taken.
This was done because these plots were established the year following the BCCF.
Burnsev for all other plots was calculated from veg and subs values in the post-burn assessment.;

*--------------------------------------- CANOPY COVER -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\CanopyCoverallyrs.csv"*/
proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\cc.csv"
out=canopy dbms=csv replace; getnames=yes;
run;  
proc sort data = canopy; by plot year; run;	
/* proc contents data = canopyx; title 'canopyx'; run; * N = 197;
proc print data = canopyx; title 'canopyx'; run;  

*Variables: 
	plot
	qu1a-qu1d, same for qu2-qu4 and ori: 4 measurements at each corner and at origin;
*/

* canopy cover calculations;
data canopy2; set canopy;
	*removing plots 1242 and 1244-1247. These plots are not in BSP;
	if (plot = '1242' | plot = '1244' | plot = '1245' | plot = '1246' | plot = '1247') then delete;
	*averaging measurements at each location;
	qua1 = ((qu1a + qu1b + qu1c + qu1d) / 4);
	qua2 = ((qu2a + qu2b + qu2c + qu2d) / 4);
	qua3 = ((qu3a + qu3b + qu3c + qu3d) / 4);
	qua4 = ((qu4a + qu4b + qu4c + qu4d) / 4);
	orim = ((oria + orib + oric + orid) / 4);
	*conversion factor;
	fact = (100/96);
	*converting to canopy cover from canopy openness;
	cov1 = -((qua1 * fact) - 100);
	cov2 = -((qua2 * fact) - 100);
	cov3 = -((qua3 * fact) - 100);
	cov4 = -((qua4 * fact) - 100);
	orig = -((orim * fact) - 100);
	*getting mean canopy cover per plot;
	covm = ((cov1 + cov2 + cov3 + cov4 + orig)/5);
run;
data canopy3 (keep = year plot covm); set canopy2;
proc sort data=canopy3; by plot year; run;
/* proc print data=canopy3; title 'plothist'; run; *N = 192; 
proc contents data=canopy3; run;*/

*----------------------------------------- TREES --------------------------------------------------;
*******SEEDLINGS (INCLUDES RESPROUTS AND FFI 'SEEDLINGS', DBH < 2.5);
/*proc import datafile="D:\FFI CSV files\seedlings-allyrs.csv" */

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\seedlings-allyrs.csv"
out=seedlings dbms=csv replace; getnames=yes;
run;  * N = 1285;

/*proc print data=seedlings; title 'seedlings'; run;*/
* cleanup;
data seedlings1; set seedlings;
 	year = year(date);
	subp = 'seed';
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set seedlings1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
/*proc print data=dat2; run;*/

data seedlings2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp) 
				 rename=(SizeClHt=heig) rename=(Status=stat) 
				 rename=(Count=coun));
	set dat2;
data seedlings3 (keep=plot year sspp heig coun stat subp); set seedlings2; run;
proc sort data = seedlings3; by plot year; run;
*merging with canopy cover;
data seedlings3x; merge seedlings3 canopy3; by plot year; 
run;  *N=1079;
*merging with plothist;
data seedlings3xx; merge seedlings3x plothist; by plot; run;
proc sort data=seedlings3xx; by plot year;	run;
/*
proc print data=seedlings3xx; title 'seedlings3xx'; run;
proc contents data=seedlings3xx; run;  * N = 1079;
proc freq data=seedlings3xx; tables year*covm; run; 

proc sql;
	select plot, year, sspp, subp, covm, slope, elev
	from seedlings3x
	where covm = '.';
quit;

*variables:
   plot = fmh plot #
   sspp = species code
   heig = height class
   coun = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
   stat = L/D (live or dead);

*CAAM is entered 2x (shrub, not a tree)
ILVO is entered 9x (shrub, not a tree)
UNTR1 = unknown tree, happened once in 1999, plot 1198.
XXXX = 10, meaning 10 observations of plots with no seedlings;
*/
*two sets, one with consistent trees, the other with inconsistent spp; 
data seedlings4; set seedlings3xx;
	if (sspp NE "CAAM2" & sspp NE "ILVOx");
run; *N=1068;
data seedlingprobspp; set seedlings3xx;
	if (sspp  = "CAAM2" | sspp  = "ILVOx");
	subp = 'seep';
run; *N=11;

/*proc contents data=seedlings4; title 'seedlings4' run;
proc print data=seedlings4; title 'seedlings4'; run;
proc print data=seedlingprobspp; title 'seedling prob spp'; run;

proc sql;
	select sspp, coun, plot	, date
	from seedlings4
	where sspp in ('PITA', 'QUMA', 'QUMA3', 'XXXX') and
	 year eq '2014';
quit; 

proc freq data=seedlings4; tables sspp*plot; title 'seedlings4'; run; * N = 1022;
proc freq data=seedlingprobspp; tables sspp; title 'seedlingprobspp'; run; * N = 11; 
* all ilvo and caam are from 1999.;	 */

******POLE TREES (SAPLINGS, DBH >=2.5 and < 15.1);
/*proc import datafile="D:\FFI CSV files\Saplings-allyrs.csv"*/

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\Saplings-allyrs.csv"
out=saplings dbms=csv replace; getnames=yes;
run;

/*proc print data=saplings; title 'saplings'; run; *N=2560;
proc contents data=saplings; run; */

*Variables:
	Date, MacroPlot, Species_Symbol, 
	SizeClDia = DBH size class
	Status = L/D
	AvgHt = Height class;

* cleanup;
data saplings1;	set saplings; 
 	year = year(date);
	subp = 'sapl';
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set saplings1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data saplings2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp)
				rename=(SizeClDia=diam) rename=(Status=stat) 
				rename=(AvgHt=heig));
	set dat2;
data saplings3 (keep=plot year sspp diam stat heig subp);
	set saplings2;
run;
proc sort data=saplings3; by plot year; run;
*merging with canopy cover;
data saplings3x; merge saplings3 canopy3; by plot year; 
run;  *N=2350;
*merging with plothist;
data saplings3xx; merge saplings3x plothist; by plot; run;
proc sort data=saplings3xx; by plot year;	run;
/*proc contents data=saplings3xx; title 'saplings3xx'; run;  * N = 2354;
proc print data=saplings3xx; run;
proc freq data=saplings3xx; tables sspp; run; */

*PINUS (3x) = unspecified species of Pinus;

/*proc sql;
	select *
	from saplings3
	where sspp eq 'ILVOx';
quit;  */

*All 3 instances were in 11/1999. 2 in 1200, 1 in 1206. Can reasonably change them to PITA.
ILVO is entered 3x all in 1999, splot 1193 (shrub, not a tree)
XXXX = 91, meaning 91 observations of plots with no saplings; 

*two sets, one with consistent trees, the other with inconsistent spp; 
data saplings4;	set saplings3xx;
	if sspp = "PINUS" then sspp = "PITAx";
data saplings5; set saplings4;
	if (sspp NE "ILVOx"); 
data saplingprobspp; set saplings4;
	if (sspp  = "ILVOx");
	subp = 'sapp';
run;

/* proc freq data=saplings5; tables sspp; title 'saplings5'; run; * N = 2351;
proc print data=saplings5; run;
proc freq data=saplingprobspp; tables sspp; title 'saplingprobspp'; run; * N = 3; 
proc print data=saplingprobspp; run;*/


******OVERSTORY (MATURE TREES, DBH >= 15.1);
/*proc import datafile="D:\FFI CSV files\overstory-allyrs.csv"*/

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\overstory-allyrs.csv"
out=overstory dbms=csv replace; getnames=yes;
run;  

/* proc print data=overstory; run; * N = 6817;
proc contents data=overstory; run; */

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, 
	QTR = Quarter
	TagNo = Tag number
	Status = L/D live or dead
	DBH
	CrwnRto = Relative dominance of crown;

* cleanup;
data overstory1; set overstory;
	if Species_Symbol='' then delete; 
	subp = 'tree';
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set overstory1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data overstory2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp)
				 rename=(Status=stat) rename=(DBH=diam) rename=(CrwnRto=crwn));
	set dat2;
data overstory3 (keep=plot year sspp stat diam crwn subp);	
	year = year(date); 
	set overstory2;
run;
proc sort data=overstory3; by plot year; run;
*merging with canopy cover;
data overstory3x; merge overstory3 canopy3; by plot year; 
run;  *N=6571;
*merging with plothist;
data overstory3xx; merge overstory3x plothist; by plot; run;
proc sort data=overstory3xx; by plot year;	run;
/*proc contents data=overstory3xx; title 'overstory3xx'; run;  * N = 6571;
proc print data=overstory3xx; title 'overstory3xx'; run;
proc freq data=overstory3xx; tables sspp; run;  */

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

data overstory4; set overstory3x;
	if sspp = "PINUS" then sspp = "PITAx";
run;
/* proc freq data = overstory4; tables sspp; run;  *N = 6571; */

*--------------------------------------- SHRUBS -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\shrubs-allyrs.csv"*/

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\shrubs-allyrs.csv"
out=shrubs dbms=csv replace; getnames=yes;
run; 

/* proc print data=shrubs; run; * N = 1129;
proc contents data=shrubs; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, 
	Status = L/D
	AgeCl = age class
	Count;

* cleanup;
data shrubs1; set shrubs;
	if Species_Symbol='' then delete; 
	subp = 'shru';
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set shrubs1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data shrubs2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp)	
			  rename=(AgeCl=agec) rename=(Count=coun) 
			  rename=(Status=stat));
	set dat2;
data shrubs3 (keep=plot year sspp agec coun stat subp);
	year = year(date);
	set shrubs2;
run;
proc sort data=shrubs3; by plot year; run; 
*merging with canopy cover;
data shrubs3x; merge shrubs3 canopy3; by plot year; 
run;  *N=932;
*merging with plothist;
data shrubs3xx; merge shrubs3x plothist; by plot; run;
proc sort data=shrubs3xx; by plot year;	run;

/*proc contents data=shrubs3xx; title 'shrubs3xx'; run;  * N = 932;
proc print data=shrubs3xx; title 'shrubs3xx'; run;
proc freq data=shrubs3xx; tables sspp*coun; run; 	*/

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

data shrubs4; set shrubs3xx;
	if sspp = "RHCO1" then sspp = "RHCOx";
data shrubs5; set shrubs4;
	if (sspp NE "CATE9" & sspp NE "JUVIx" & sspp NE "PITAx" & sspp NE "PRGL2" & sspp NE "PTTRx" &
		sspp NE "QUINx" & sspp NE "QUMA3" & sspp NE "QUNIx" & sspp NE "QUSTx" & sspp NE "SILA2");
data shrubsprobspp; set shrubs4;
	if (sspp = "CATE9" | sspp = "JUVIx" | sspp = "PITAx" | sspp = "PRGL2" |sspp = "PTTRx" | 
		sspp = "QUINx" | sspp = "QUMA3" | sspp = "QUNI" | sspp = "QUSTx" | sspp = "SILA2");
	subp = 'shrp';
run;

/* proc freq data=shrubs5; tables sspp; title 'shrubs5'; run; * N = 916;
proc print data=shrubs5; run;
proc freq data=shrubsprobspp; tables sspp * year; title 'shrubsprobspp'; run; * N = 15;
proc print data=shrubsprobspp; run;
* CATE9: 1, 2006
JUVI: 1, 2002
PITA: 2, 2005
PRGL: 1, 2002, 1, 2005
PTTR: 1, 2006 
QUIN: 1, 2002
QUMA3: 1, 2002
QUST: 1, 2002
SILA2: 5, 2002;
*/

***************NOTE that all of the N's reported in here refer to RECORDS, not COUNTS;

/*proc print data=shrubs5; run; */

*--------------------------------------- HERBACEOUS -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\herbaceous-allyrs.csv"*/

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\herbaceous-allyrs.csv"
out=herbaceous dbms=csv replace; getnames=yes;
run;  * N = 8674;

/* proc print data=herbaceous; title 'herbaceous'; run;
proc contents data=herbaceous; title 'herbaceous'; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, 
	Quadrat	(1-10)
	Status = L/D (some do not have this recorded at all)
	Count;

* cleanup;
data herb1; set herbaceous;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
	subp = 'herb';
data dat2; set herb1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data herb2 (rename=(MacroPlot_Name=plot) rename=(Status=stat)
			rename=(char3=sspp) rename=(Count=coun));
	set dat2;
data herb3 (keep=plot year sspp coun stat subp);
	year = year(date);
	set herb2;
run;
proc sort data = herb3; by plot year; run; 
*merging with canopy cover;
data herb3x; merge herb3 canopy3; by plot year; 
run;  *N=8674;
*merging with plothist;
data herb3xx; merge herb3x plothist; by plot; run;
proc sort data=herb3xx; by plot year;	run;

/*proc contents data=herb3xx; title 'herb3xx'; run;  * N = 8681;
proc print data=herb3xx (firstobs=1 obs=20); title 'herb3xx'; run;
proc freq data=herb3xx; tables sspp; run;  */

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
data herb4; set herb3xx;
	if sspp = 'ACGRx' then sspp = 'ACGR2'; 
run;
data herb5; set herb4;
	if (sspp NE 'UNSE1' & sspp NE 'RUBUS' & sspp NE 'SMILA' & sspp NE ' x');	*N=8665;
data herbprobspp; set herb4;
	if (sspp = "RUBUS" | sspp = "SMILA");
	subp='herp';
run;

/* proc contents data=herb5; title 'herb5'; run;  * N = 8421;
proc print data=herb5; run;
proc freq data=herb5; tables sspp; run; 
proc print data=herbprobspp; title 'herb prob spp'; run; *N = 4;*/
	

*--------------------------------------- POINT INTERCEPT -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\PointIntercept-allyrs.csv"	*/

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\PointIntercept-allyrs.csv"
out=transect dbms=csv replace; getnames=yes;
run;  

/* proc print data=transect; title 'transect'; run;	* N = 41,961. File size ~ 3MB;
proc contents data=transect; title 'transect'; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, 
	Point = numbered point on tape (0.3m = point 1,  0.6m = point 2, etc.)
	Tape = distance on tape measure
	Height = height of tallest plant at any given point;

* cleanup;

data trans1; set transect;
	if  Species_Symbol = '' then delete; 
	subp = 'tran';
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set trans1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data trans1x (rename=(MacroPlot_Name=plot) 
			rename=(char3=sspp) rename=(Height=heig));
	set dat2;
data trans2 (keep=plot year sspp heig subp);
	year = year(date);
	set trans1x;
run;
proc sort data = trans2; by plot year; run;	
*merging with canopy cover;
data trans3x; merge trans2 canopy3; by plot year; 
run;  *N=41744;
*merging with plothist;
data trans3; merge trans3x plothist; by plot; run;
proc sort data=trans3; by plot year; run;

/*proc contents data=trans3; title 'trans3'; run;  * N = 41,744;
proc print data=trans3 (firstobs=1 obs=20); title 'trans3x'; run;
proc freq data=trans3; tables sspp; run; */

*-----------------------------------------dataset merges-----------------------------;
data alld; set seedlings4 seedlingprobspp saplings5 saplingprobspp
			   overstory4 shrubs5 shrubsprobspp herb5 herbprobspp trans3; 
	if year < 2011  then prpo = 'pref';
   	if year >= 2011 then prpo = 'post';
run; *N = 61104;
proc sort data=alld; by plot year subp; run;
/* proc contents data=alld; title 'all'; run;
*Variables:			   #    Variable    Type    Len    Format     Informat
                       3    stat        Char      1    $1.        $1.
                       6    subp        Char      4
                      19    typecat     Char      1
                       5    year        Num       8    BEST12.    BEST32.
                      12    yrrx1       Num       8    BEST12.    BEST32.
                      13    yrrx2       Num       8    BEST12.    BEST32.
                      14    yrrx3       Num       8    BEST12.    BEST32.
					  26    agec        Char      1    $1.        $1.
                      18    aspect      Char      4
                      22    bcat1       Char      1
                      23    bcat2       Char      1
                      21    burn        Num       8
                      10    burnsev     Char      1    $1.        $1.
                       4    coun        Num       8    BEST12.    BEST32.
                       8    covm        Num       8
                      25    crwn        Num       8    BEST12.    BEST32.
                      24    diam        Num       8    BEST12.    BEST32.
                      15    elev        Num       8    BEST12.    BEST32.
                       2    heig        Num       8    BEST12.    BEST32.
                       9    hydr        Char      1    $1.        $1.
                      11    lastrx      Num       8    BEST12.    BEST32.
                      20    meansev     Num       8
                       1    plot        Num       8    BEST12.    BEST32.
 					  27    prpo        Char      4
                      16    slope       Num       8    BEST12.    BEST32.
                      17    soil        Char      4
                       7    sspp        Char      5

proc print data=alld (firstobs=60000 obs=60500); title 'alld'; run;

proc sql;
	select subp	, sspp
	from  alld
	where subp eq 'shrp';
quit; 

PROC PRINTTO PRINT='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\alld.csv' NEW;
RUN; 
*/

****************putting seedlings and shrubs together to have pines, oaks, and ilex in the same set;
* pulling just the important species--pines, ilvo, and quma, quma3;
data piquil; set alld;
	if (subp = 'seed') & (sspp = "PITAx" |sspp = "QUMAx" | sspp = "QUMA3") |
	   (subp = 'shrp') & (sspp = "PITAx" |sspp = "QUMAx" | sspp = "QUMA3") |
	   (subp = 'shru') & (sspp = "ILVOx") |
	   (subp = 'seep') & (sspp = "ILVOx");
run;  
proc sort data=piquil; by plot year; run;

/* proc print data=piquil; title 'piquil'; var plot subp sspp year; run;  * N = 878; 
proc contents data = piquil; run;
proc freq data=piquil; tables sspp*subp*year; title 'piquil'; run;

*finding whether each is counted more than once
proc sql;
	select year, plot, sspp, subp
	from piquil
	where year eq 2002 and
		  sspp = 'QUMA3';
quit;
*A: NO, they are not counted twice. Won't affect abundance.

*/
