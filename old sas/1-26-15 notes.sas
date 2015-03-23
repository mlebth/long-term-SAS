
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
* proc print data=postsev1; *run;

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

proc import datafile="\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\FFI long-term data and SAS\plothistory.csv"  
out=hist dbms=csv replace; getnames=yes; run;  * N = 61;
/* proc contents data=hist; title 'plot history'; run;
proc print data=hist; run;  * N = 61; */

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
run;
proc sort data=hist2; by plot; run;
/* proc print data=hist2; title 'hist2'; run; *N = 61;
proc freq data=hist2; tables burnsev; run; */

*merging post-fire assessment and plot history files;
data plothist1; merge hist2 postsev2x5; by plot; 
run;
proc sort data=plothist1; by plot year typecat burnsev lastrx yrrx1 yrrx2 yrrx3; run;
/* proc print data=plothist1; title 'plothist1'; run; *N = 63;
proc freq data=plothist1; tables burnsev; run; */

data plothist (drop=_TYPE_ _FREQ_); set plothist1;
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
/*proc print data=plothist; title 'plothist'; run; * N =62;
proc contents data=plothist; run; */

*IMPORTANT: plots 1227-5300 were given burnsev classes visually, veg and subs measurements were not taken.
This was done because these plots were established the year following the BCCF.
Plots 1182-1185 and plot 1187 were given burnsev classes according to the burn severity GIS layer.
This was done because they were not visited for any plot history method.
Burnsev for all other plots was calculated from veg and subs values in the post-burn assessment.;
