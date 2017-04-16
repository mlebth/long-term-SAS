
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herbx1.csv"
out=herb dbms=csv replace; getnames=yes; run;  * N = 12547;
proc import datafile="d:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\plothist.csv"
out=plothist dbms=csv replace; getnames=yes; run;  *n=56;

*merging herb data with plothist to put back in burn severity;
*burn: 1=unburned, 2=scorch, 3=light, 4=mod, 5=heavy;
data plothist2; set plothist; keep plot burn;
proc sort data=herb; by plot;
proc sort data=plothist2; by plot; 
data herb2; merge herb plothist2; by plot; run; *N=12547;
*proc print data=herb2 (firstobs=1 obs=10); title 'herb2'; run;

/*
*finding where the blank lines are;
proc sql;
	select plot, year, sspp, coun
	from herbx2
	where sspp= '     ';
quit;
*plots 1223-1226 in 2012, which were never surveyed this year at all and
should be removed;

*finding where sspp=XXXXx is;
proc sql;
	select plot, year, sspp, coun, fungroup
	from herbx2
	where sspp= 'XXXXx';
quit;
*only plot 1203 in 2005;
*/

* cleaning dataset;
data herb3; set herb2;
	* removing blank lines--these are plots 1223-1226 in 2012. They were not surveyed at all in 2012;
	if sspp='     ' then delete;
	* removing 1999--data are of extremely poor quality;
	if year = 1999 	then delete;
	keep aspect burn coun quad covm elev hydrn plot slope soileb sspp year fungroup; 
	rename coun=count soileb=soil hydrn=hydr covm=cover;
run; * n = 12,543;
proc sort data=herb3; by sspp plot quad year burn cover count soil elev slope aspect hydr fungroup; run; 
* proc print data=herb3 (firstobs=1 obs=15); title 'herb3'; run;
* proc contents data=herb1x; run;

proc sort data=herb3; by plot sspp year; run;
proc means data=herb3 noprint sum mean; by plot sspp year; var quad burn cover count soil elev slope aspect hydr fungroup;
	output out=herb4 sum=sumquad sumburn sumcov count sumsoil sumelev sumslope sumaspect sumhydro sumfungroup
	mean=mquad burn cov mcount soil elev slope aspect hydr fungroup;
run; *n=4811;
data herb5; set herb4; 
	*adding in a counter--1 for each species/plot/year. sumcount is the number of stems/tillers
	for each species/plot per year (summed over all 10 quadrats);
	counter=1;
	keep plot sspp year count burn cov soil elev slope aspect hydr fungroup counter;
*proc print data=herb5 (firstobs=1 obs=15); title 'herb5'; run; *n=4811;

*proc freq data=herb5; *tables fungroup*counter burn*counter burn*counter*year*fungroup; run;
*lines per fungroup: 3121 forbs, 1689 grasses, 1 plot with nothing;
*lines by burn (fungroup1/2/3):
	1-34 (18/16/0)
	2-510 (317/193/0)
	3-1030 (700/329/1)
	4-958 (651/307/0)
	5-2279 (1435/844/0)
;

*pooling pre-fire data;
data herb5prefire; set herb5;
	if year <2011; run;			*n=701;
proc means data=herb5prefire mean noprint; by plot sspp burn soil elev slope aspect hydr fungroup counter; var count cov ;
	output out=herb5premean mean= mcount mcov;
run; 							*n=510; 
data herb5prem; set herb5premean; year=1111; count=mcount; cov=mcov; run;
*proc print data=herb5prem (firstobs=1 obs=10); title 'herb5prem'; run;

*post-fire data separated out;
data herb5postfire; set herb5; 
	if year >=2011; run;		*n=4110;

*merging post-fire data with pooled pre-fire data;
proc sort data=herb5prem; by year plot sspp burn soil elev slope aspect hydr fungroup ;
proc sort data=herb5postfire; by year plot sspp burn soil elev slope aspect hydr fungroup ;
data herb6; merge herb5prem herb5postfire; by year plot sspp burn soil elev slope aspect hydr fungroup;
	drop _TYPE_ _FREQ_;
	if cov='' then cov=.;
run; 							*n=4620;
*proc print data=herb6 (firstobs=1 obs=20); title 'herb6'; run;
*proc contents data=herb6; run;

*to do with this: 
pool pre-fire years
fix counter
do a proc contents and list all variables
;

/*
proc export data=herb6
   outfile='d:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herb6.csv'
   dbms=csv
   replace;
run;
*/
