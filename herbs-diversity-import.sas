
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory, then rerun relevant 
	sections;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herbx1.csv"
out=herbx1 dbms=csv replace; getnames=yes; run;  * N = 12547;
proc import datafile="d:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\plothist.csv"
out=plothist dbms=csv replace; getnames=yes; run;  *n=56;

*merging herb data with plothist to put back in burn severity;
*burn: 1=unburned, 2=scorch, 3=light, 4=mod, 5=heavy;
data plothist2; set plothist; keep plot burn;
proc sort data=herbx1; by plot;
proc sort data=plothist2; by plot; 
data herbx2; merge herbx1 plothist2; by plot; run;
*proc print data=herbx2 (firstobs=1 obs=10); title 'herbx2'; run;

* creating a set of herbs;
data herb1x; set herbx2;
	* removing blank lines;
	if sspp='     ' then delete;
	* removing 1999--data are of extremely poor quality;
	if year = 1999 	then delete;
	* type 1--it is a plant. type 2--zero plants were found in that plot/year;
  	*type = 1;     		  			  	
 	*if (sspp = 'XXXXx') then type = 2;   
	keep aspect burn coun quad covm elev hydrn plot slope soileb sspp year form; 
	rename coun=count soileb=soil hydrn=hydr covm=cover;
run; * n = 12,543;
proc sort data=herb1x; by sspp plot quad year burn cover count soil elev slope aspect hydr form; run; 
* proc print data=herb1x (firstobs=1 obs=20); title 'herb1x'; run;
* proc contents data=herb1x; run;

proc sort data=herb1x; by plot sspp year; run;
proc means data=herb1x noprint sum mean; by plot sspp year; var quad burn cover count soil elev slope aspect hydr form;
	output out=herbs sum=sumquad sumburn sumcov sumcount sumsoil sumelev sumslope sumaspect sumhydro sumform
	mean=mquad burn mcov mcount soil elev slope aspect hydr form;
run;
data herbs1; set herbs; 
	*adding in a counter--1 for each species/plot/year. sumcount is the number of stems/tillers
	for each species/plot per year (summed over all 10 quadrats);
	counter=1;
	keep plot sspp year sumcount burn mcov soil elev slope aspect hydr form counter;
*proc print data=herb1x (firstobs=1 obs=10); title 'herb1x'; run;
*proc print data=herbs1 (firstobs=1 obs=10); title 'herbs1'; run;

proc freq data=herbs1; tables form*counter burn*counter burn*counter*year*form; run;
*3121 forbs, 1689 grasses, 1 plot with nothing;
