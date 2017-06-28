 
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

***5-31-17: below blocked out section was me figuring out my dataset,
I had done some weird things with my waypoints when I first laid this out
without knowing better;
/*
*importing my data;
proc import datafile="D:\Werk\Research\Demography\demogdatafinal.csv"
out=demog dbms=csv replace; getnames=yes; run;  * N = 723;
proc print data = demog (firstobs=1 obs=20); title 'demog'; run;
proc contents data = demog; run;

*variables: 
date = mm/dd/yyyy
sspp = 5 characters
plid = plant ID
plot = generated plot id's (from initial randomization)
gpsp = gps point of individual plants
drcr = diameter at root crown
stco = stem count
hgt1, hgt2, hgt3, hgt4, hgt5 = heights of 5 stems--picked one to start then every other one
cano = canopy cover--1 measurement
trmt = treatment combo--sand/gravel x no/low/high [sn, sl, sh, gn, gl, gh].
	xx's indicate that it was an on-the-fly plot, needs to be matched up on map
notes;

*importing waypoint information;
proc import datafile="D:\Werk\Research\Demography\demogpoints-treatmentsfixed.csv"
out=waypoints dbms=csv replace; getnames=yes; run;  * N = 630;
proc print data = waypoints (firstobs=1 obs=20); title 'waypoints'; run;
proc contents data = waypoints; run;

*variables: 
ident = same as 'plot' in demogdatafinal.csv
lat/long, x_proj/y_proj = coordinates
treatment = sandno, sandlo, sandhi, gravelno, gravello, gravelhi
type = 'WAYPOINT';

data waypoints2; set waypoints;
	drop type lat long x_proj y_proj;
	rename ident=plot;
	
	if treatment='sandno' then trmt2='sn';
	if treatment='sandlo' then trmt2='sl';
	if treatment='sandhi' then trmt2='sh';
	if treatment='gravelno' then trmt2='gn';
	if treatment='gravello' then trmt2='gl';
	if treatment='gravelhi' then trmt2='gh';
	drop treatment;
	
run;
proc sort data=waypoints2; by plot; run;
* proc print data=waypoints2 (firstobs=1 obs=200); title 'waypoints2'; run;
proc sort data=demog; by plot; run;

*merging treatment info with data;
data demog2; merge demog waypoints2; by plot; run;
*many points were never used, deleting them;
data demog3; set demog2; if plid=. then delete; drop gpsp;
* proc print data=demog3; title 'demog3'; run; *n=723;
*/

*5-31-17: new import;
proc import datafile="D:\Werk\Research\Demography\demog-for-analysis.csv"
out=demog dbms=csv replace; getnames=yes; run;  * N = 635;
*proc print data = demog ; title 'demog'; run;
*proc contents data = demog; run;

*6-24-17: checking initial numbers of plot/treatment;
proc import datafile="D:\Werk\Research\Demography\demog1.csv"
out=demog1 dbms=csv replace; getnames=yes; run;  * N = 635;
*proc print data = demog1 (firstobs=1 obs=10); title 'demog'; run;
*proc contents data = demog1; run;
proc freq data=demog1; tables cens*sspp*trmt; run;

*5-29-17;
data demog1; set demog;
	*fixing canopy;
	cancovp=100-(cano*1.04)-0.16;
	*extracting year;
    year = year(date);
	*Census 1 was done in the 11/14-1/15;
	if year=2014 | year=2015 then cens=1;
	*Census 2 was done 1/16;
	if year=2016 then cens=2; 
	*when drcr is blank the plant was either missing or dead;
	if drcr=. then drcr=0;
	if stco=. then stco=0;
	if mhgt=. then mhgt=0;
	*dropping plot and gps because location doesn't matter, just treatment
	and plant number;
	if cens=1 then mhgt1=mhgt;	if cens=2 then mhgt2=mhgt;
	if cens=1 then stco1=stco;	if cens=2 then stco2=stco;
	if cens=1 then diam1=drcr;	if cens=2 then diam2=drcr;
	if cens=1 then cano1=cancovp;	if cens=2 then cano2=cancovp;
	if cens=1 then statnum1=stat;	if cens=2 then statnum2=stat;
	stat1 = input(statnum1, best32.); 
	stat2 = input(statnum2, best32.);
	*assigning status;
	stat1=1; *all year 1 plants were alive;
	if stco2=0 then stat2=0; if stco2 NE . then stat2=1;
	drop date year stco hgt1 hgt2 hgt3 hgt4 hgt5 mhgt cens drcr cancovp stat statnum1 statnum2;
run;   	
proc sort data=demog1; by plot sspp plid trmt; run;
*proc contents data=demog1; run;
*proc print data=demog1; title 'demog1'; run;
*proc freq data=demog1; *tables trmt trmt*sspp; run;
*sn=38 sl=126 sh=148 gn=26 gl=135 gh=162 ;

proc means data=demog1 noprint mean; by plot sspp plid trmt burn soil; 
	var mhgt1 mhgt2 stco1 stco2 diam1 diam2 cano1 cano2 stat1 stat2;
	output out=demog15 mean=mhgt1 mhgt2 stco1 stco2 diam1 diam2 cano1 cano2 stat1 stat2;
run;
data demog2; set demog15;
	*stat:  0=died, 1=lived;
	stat1=1; *all year 1 plants were alive;
	if stco2=0 then stat2=0; if stco2 NE 0 then stat2=1;
	*filling in blanks on plots where canopy stayed the same;
	if cano2=. then cano2=cano1;
	*when drcr is blank the plant was either missing or dead;
	if diam2=. then diam2=0;
	if stco2=. then stco2=0;
	if mhgt2=. then mhgt2=0;
	drop _TYPE_ _FREQ_ plid;
	pi=constant("pi");
	*calculating mean basal area;
	area1=((pi/4)*(diam1**2));
	area2=((pi/4)*(diam2**2));
	if stco1=0 then	area1=0;
	if stco2=0 then area2=0;
	drop pi;
*proc print data=demog2; title 'demog2'; run;
*proc freq data=demog1; *tables trmt trmt*sspp; run; *n=319;
*sn=38 sl=126 sh=148 gn=26 gl=135 gh=162 ;

*vars:
sspp = 5 characters
plid = plant ID
plot = generated plot id's (from initial randomization)
diam1/2 = basal diameter, year 1/2
stco1/2 = stem count, year 1/2
mhgt1/2 = mean height (of the 5 measured), year 1/2
cano = canopy cover--1 measurement
trmt = treatment combo--sand/gravel x no/low/high [sn, sl, sh, gn, gl, gh].
	xx's indicate that it was an on-the-fly plot, needs to be matched up on map
cens = census year (1 or 2)
stat1/2 = 0/1 (dead/alive)
area1/2 = mean area of stems * number of stems
burn = 1 (not burned), 2 (low burn), 3 (high burn)
soil = 1 (sandy soil), 2 (gravelly soil);

/*
proc export data=demog2
   outfile='D:\Werk\Research\Demography\demog2.csv'
   dbms=csv
   replace;
run;
*/
