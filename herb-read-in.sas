
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory, then rerun relevant 
	sections;
* proc datasets library=work kill noprint; run; 


*--------------------------------------- POST-BURN SEVERITY ASSESSMENT AND PLOT HISTORY -----------------------------------------------------;
*Data were collected in all plots in 2011, and one plot in 2008. Data for 2012 included but blank.;
proc import datafile="D:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\postburnsev.csv"
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
*proc print data=postsev1; run;

* Variables:
	Date, MacroPlot_Name, Monitoring_Status
	PlotType = Forest or Shrub
	Transect = Transect id number, out of 3
	Point = Gives each measurement a number (ex. Point 1 is at 1m, 2 is at 5m, 3 is at 10m etc.)
	TapeDist = Point on tape where measurement was taken (1m, 5m, 10m, etc.)
	Veg = Scale of 0-5. For more details on categorizations, see backside of FMH-21
		{0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned}
	Sub = See Veg;

*Fixing plot type variable, there will be a temporary SAS warning. Ignore--just an intermediate step;
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
*proc print data=postsev2x; title 'postsev2x'; run;

data postsev2x1; set postsev2x; dummy=1; keep plot year type vege subs dummy;
proc sort data=postsev2x1; by plot type; run;
*proc print data=postsev2x1; title 'postsev2x1'; run; *N = 1230;

* only plots with labeled types;
data postsev2x2; set postsev2x1; if (type ^= '      ' | type ^= '     '); run;  * N = 59;
proc sort data=postsev2x2; by plot type; run;
*proc print data=postsev2x2; title 'postsev2x2'; run; 
                                                                   
data mout2; set postsev2x2; 
  if type = 'Forest' then typecat = 'f';
  if type = 'Shrub' then typecat = 's';	run;
proc sort data=mout2; by plot; 
/* proc print data=mout2; title 'mout2'; run; * N = 59;
proc contents data=mout2;run; *plot, year, dummy, vege, subs, type, typecat; */

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
*proc print data=postsev2x4; title 'postsev2x4'; run;  *N=1112;

*getting mean burn sev with both vege and subs;
proc means data=postsev2x4 mean noprint; var vege subs; by plot year typecat;
	output out=postsev2x5 mean=meansev;
run;
proc sort data = postsev2x5; by plot; run; 
/* proc print data=postsev2x5; title 'postsev2x5'; run; *N=43; 
proc contents data=postsev2x5; run;
*41 plots--one of these is '9999', and only plot 1226 was sampled twice with this method--once in 2008, once in 2011;
*/

* Plot history: This comes from my own document, not FFI;
* Includes hydromulch, rx burn history, and burn severity variables. Burn severity is only for plots 1227-5300--these are the new plots
that were not included in the initial post-burn assessment. Qualitative assessment was done in summer 2012.;
proc import datafile="D:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\plothistory.csv"  
out=hist dbms=csv replace; getnames=yes; 
run;  * N = 56;
/*proc contents data=hist; title 'plot history'; run;
proc print data=hist; run;  * N = 56; */

* plot history data in this file;
* variables: 
   burnsev (u, s, l, m, h) = wildfire severity
   hydr (n, l, h) = post-wildfire (2012) hydromulch [n = none, l = light, h = heavy]
   hydrn = 2012 hydromulch given numbers for iml [n = 1, l = 2, h = 2] --combining light and heavy
   hyyr = year of hydromulch application. Variable added when more was applied in 2014.
		NOTE that 2012 hydro was a different mix:
		2012 (Triticale, Leptochloa dubia), 2014 (Schizachryium scoparium)
   lastrx = year of last prescribed burn
   yrrx1, yrrx2, yrrx3 = years of rx burns since 2003
   plot = fmh plot #
   soil1 = full SSURGO soil name
   soil2 = abbreviated soil names:
		{fslo = fine sandy loam, gfsl = gravelly fine sandy loam, sand = fine sand, loam = loam, lfsa = loamy fine sand}
   soil3 = soil names given numbers for iml: {fslo = 1, gfsl = 2, sand = 3, loam = 4, lfsa = 5}
   elev	= elevation in m above sea level
   slope = % change in elevation
   aspect = azimuth (values of -1 = undefined--slope =<2);
                                                              
*plot history cleanup;
data hist2; set hist (rename=(aspect=oldaspect));
   if hydr = 'n' then hydrn = 1;
   if hydr = 'l' then hydrn = 2;
   if hydr = 'h' then hydrn = 2;
   drop soil1;
   soil = soil2;
   drop soil2;
   *giving each soil type a number;
   if soil = 'fslo' then soiln = 1;	
   if soil = 'gfsl' then soiln = 2;
   if soil = 'sand' then soiln = 3;
   if soil = 'loam' then soiln = 4;
   if soil = 'lfsa' then soiln = 5;
   * pooling soils to just sand/gravel. 1 = sand, 2 = gravel;
   if soil = 'fslo' then soilt = 1;	
   if soil = 'gfsl' then soilt = 2;
   if soil = 'sand' then soilt = 1;
   if soil = 'loam' then soilt = 2; 
   if soil = 'lfsa' then soilt = 1;
   *fixing rx;
   if lastrx = 9999 then lastrx = .;
   if yrrx1  = 9999 then yrrx1 = .;
   if yrrx2  = 9999 then yrrx2 = .;
   if yrrx3  = 9999 then yrrx3 = .;
   /* *years since prescribed fire variables. So far not very useful.;
   lastrx = 2014 - yrrx;
   if (lastrx = .) then yrcat = 'nev';
   if (lastrx = 3| lastrx = 6 | lastrx = 7) then yrcat = 'rec';
   if (lastrx = 9 | lastrx = 11) then yrcat = 'old';   */
   /*  *the following was to categorize aspects. 4/11/15, changing to have aspect as num instead of char;
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
   if aspect = 0 then aspectc = 'flat';
   if aspect = 1 then aspectc = 'nort';
   if aspect = 2 then aspectc = 'east'; 
   if aspect = 3 then aspectc = 'sout';
   if aspect = 4 then aspectc = 'west';	*/
   * 4/11/15 new categorizing of aspects;
   if (oldaspect = -1) then aspect = 0; 
   if (oldaspect >= 0 	& oldaspect < 45)	then aspect = 1; 
   if (oldaspect >= 315 & oldaspect <= 360) then aspect = 1;
   if (oldaspect >= 45  & oldaspect < 135)  then aspect = 2;
   if (oldaspect >= 135 & oldaspect < 225)  then aspect = 3;
   if (oldaspect >= 225 & oldaspect < 315)  then aspect = 4;	
   drop oldaspect;
run;
proc sort data=hist2; by plot; run;
/* proc print data=hist2; title 'hist2'; run; *N = 56;
proc freq data=hist2; tables burnsev; run; 
proc freq data=hist2; tables soilt; run; 
proc contents data=hist2; run;
*/

*merging post-fire assessment and plot history files;
data plothist1; merge hist2 postsev2x5; by plot; 
run;
proc sort data=plothist1; by plot year typecat burnsev lastrx yrrx1 yrrx2 yrrx3; run;
/* proc print data=plothist1; title 'plothist1'; run; *N = 58;
proc contents data=plothist1; run;
proc freq data=plothist1; tables year*plot/missing; run; */

* burnsev cleanup;
data plothistx (drop=_TYPE_ _FREQ_); set plothist1;
	*deleting 2008: there is only one stray plot recorded in 2008, maybe from an rx burn? 
	not useful without others;
	if year=2008 then delete;
	*deleting plot 9999: not an actual plot, just a placeholder;
	if plot=9999 then delete;
	* assigning burnsev categories to vege+subs burn avg;
	if 1 <= meansev <2 then burnsev = 'h';
	if 2 <= meansev <3 then burnsev= 'm';
	if 3 <= meansev <4 then burnsev = 'l';
	if 4 <= meansev <5 then burnsev = 's';
	if meansev = 5     then burnsev = 'u';
	if meansev = 9 	   then delete;
	* makes new set of treatment names with natural ordering for graphs and constrasts;
    if burnsev = 'u' then burn = 1;
    if burnsev = 's' then burn = 2;
    if burnsev = 'l' then burn = 3;
    if burnsev = 'm' then burn = 4;
    if burnsev = 'h' then burn = 5;
	* poolingA - scorch, light, moderate;
    if (burnsev = 'h' | burnsev = 'm') then bcat = 3;
    if (burnsev = 'l' | burnsev = 's') then bcat = 2;
    if (burnsev = 'u') then bcat = 1;
    * poolingB - combine scorch + light;
    if (burnsev = 'h') then bcat2 = 4;
    if (burnsev = 'm') then bcat2 = 3;
    if (burnsev = 's' | burnsev = 'l') then bcat2 = 2;	
    if (burnsev = 'u') then bcat2 = 1;
	*typecat for new plots--all forest;
	if typecat = '' then typecat = 'f';
run;
data plothist (drop = year); set plothistx;
proc sort data=plothist; by plot; run;
/*proc print data=plothist; title 'plothist'; run; * N =56;
proc contents data=plothist; run; 
proc freq data=plothist; tables soileb*plot; run;

*making a printout for EK;
proc export data=plothist
   outfile='D:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\plothist.csv'
   dbms=csv
   replace;
run;
*/

*IMPORTANT: plots 1227-5300 were given burnsev classes visually, veg and subs measurements were not taken.
This was done because these plots were established the year following the BCCF.
Burnsev for all other plots was calculated from veg and subs values in the post-burn assessment.;

*--------------------------------------- CANOPY COVER -----------------------------------------------------;
/*proc import datafile="D:\FFI CSV files\CanopyCoverallyrs.csv"*/
proc import datafile="D:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\CanopyCover.csv"
out=canopy dbms=csv replace; getnames=yes;
run;  
proc sort data = canopy; by plot year; run;	

/* proc contents data = canopy; title 'canopy'; run; * N = 242;
proc print data = canopy; title 'canopy'; run;  

*Variables: 
	plot
	year
	qua1-qua4, orig: 4 measurements at each corner and at origin;
	covm: average canopy cover
*/

/* 
*removing this section; already incorporated in csv file (9-28-2015);
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
*/

data canopy3 (keep = year plot covm); set canopy;
proc sort data=canopy3; by plot year; run;
/* proc print data=canopy3; title 'plothist'; run; *N = 242; 
proc contents data=canopy3; run;*/

*--------------------------------------- HERBACEOUS -----------------------------------------------------;
proc import datafile="D:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herbaceous-allyrs.csv"
out=herbaceous dbms=csv replace; getnames=yes;
run;  * N = 12878;

/* proc print data=herbaceous; title 'herbaceous'; run;
proc contents data=herbaceous; title 'herbaceous'; run;	*/

*Variables to use:
	Date, MacroPlotName, SpeciesSymbol, 
	Quadrat	(1-10)
	Status = L/D (some do not have this recorded at all)
	Count;

* cleanup;
data herb1; set herbaceous;
	if Status = 'D' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
	subp = 'herb';
data dat2; set herb1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data herb2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp) rename=(Count=coun) rename=(Quadrat=quad));
	set dat2;
data herb3 (keep=plot year sspp coun quad subp); set herb2;
	year = year(date);	
run;
proc sort data = herb3; by plot year; run; 
*merging with canopy cover;
data herb3x; merge herb3 canopy3; by plot year; 
run;  *N=12872;
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

/*
proc sql;
	select plot, year, sspp
	from herb3xx
	where sspp eq 'LEMUx';
quit;
*/

*Removing UNSE1 observations--seedlings shouldn't be in this dataset anyway;
data herb4; set herb3xx;
	if sspp = 'ACGRx' then sspp = 'ACGR2'; 
	if sspp = 'TRURx' then sspp = 'TRUR2';
	*11/10/15: note from EK, all Galactia volubilis should be G. regularis instead;	
	if sspp = 'GAVOx' then sspp = 'GAREx'; 
run;
data herb5; set herb4;
	if (sspp NE 'UNSE1' & sspp NE 'RUBUS' & sspp NE 'SMILA' & sspp NE ' x');	*N=8665;
data herbprobspp; set herb4;
	if (sspp = "RUBUS" | sspp = "SMILA");
	subp='herp';
run;

/* proc contents data=herb5; title 'herb5'; run;  * N = 12652;
proc print data=herb5; run;
proc freq data=herb5; tables sspp; run; 
proc print data=herbprobspp; title 'herb prob spp'; run; *N = 4;*/

data herbx; set herb5;
	*dropping all data from 1999. useless sfa data;
	if year = 1999 then delete;
	if (plot = 1242 | plot = 1244 |plot = 1245 |plot = 1246 |plot = 1247) then delete;
	*splitting to into pre/post fire variable 'prpo';
	if year < 2011  then prpo = 1;
   	if year >= 2011 then prpo = 2;
	if year=2011 then delete; *herbs were not measured in 2011;
	* 12 'missing' years that come from postburn severity metric, all come from 2011;
	if year = '.' 	then year = 2011;
run;

*proc print data=herbx (firstobs=1 obs=20); title 'herbx'; run;
