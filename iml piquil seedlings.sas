  ****************putting seedlings and shrubs together to have pines, oaks, and ilex in the same set;
data herbx; set alld;
	if (subp = 'herb'); 
run;  *N=12545;
data herb1; set herbx;
	keep aspect bcat coun covm elev hydrn plot slope soileb sspp subp year prpo; *check TRURx;
run;
proc sort data=herb1; by subp plot sspp year bcat covm coun soileb elev slope aspect hydrn prpo; run;
proc means data=herb1 noprint sum; by subp plot sspp year bcat covm coun soileb elev slope aspect hydrn prpo; var coun; 
  output out=herb2 sum=nperspp; run; *N=11100;
/* proc print data=herb2; title 'herb numplantdata';   run;
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* N = 442 species-plot-year combinations;
* piquil2 contains: obs, plot, sspp, year, burn, prpo, covm, soil, elev, slope, aspect, hydr, nperspp
  nperspp = # of sdlngs/stems per species per plot/year;  */

/*
proc sql;
	select plot, year, sspp, coun, pltd
	from piquilseed2
    where pltd eq 0;
quit;
*/

*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set piquilseed2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'QUMA3'); nquma3 = nperspp; 
	proc sort data=holdquma3; by plot bcat year; 
data holdqumax; set piquilseed2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'QUMAx'); nqumax = nperspp;
	proc sort data=holdqumax; by plot bcat year; 
data holdpitax; set piquilseed2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'PITAx'); npitax = nperspp; 
	proc sort data=holdpitax; by plot bcat year; 
data holdilvox; set piquilseed2; if (subp = 'seep' | subp = 'shru') & (sspp = 'ILVOx'); nilvox = nperspp; 
data holdxxxxx; set piquilseed2; if (subp = 'seed' | subp = 'shru') & (sspp = 'XXXXx'); 
	nquma3 = nperspp; nqumax = nperspp;	npitax = nperspp; nilvox = nperspp; 
	proc sort data=holdxxxxx; by plot bcat year; 
run;
/* proc print data=holdquma3; run; 	*N=299;
   proc print data=holdqumax; run; 	*N=216;	
   proc print data=holdpitax; run; 	*N=231;
   proc print data=holdilvox; run; 	*N=252;    
   proc print data=holdxxxxx; run; 	*N=24; */

proc sort data=piquilseed2; by plot bcat year pltd; run;
*n(spp) is count, pa(spp) is presence/absence;
data piquilseed3; merge holdquma3 holdqumax holdpitax holdilvox holdxxxxx piquilseed2; by plot bcat year pltd;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nilvox = .) then nilvox=0; if (nilvox=0) then pailvox=0; if (nilvox ^= 0) then pailvox=1; 
  drop _TYPE_ _FREQ_ sspp nperspp;  * dropping sspp & nperspp - become garbage;
run;

/* proc print data=piquilseed3; title 'piquil'; run;  * N = 2247; 
proc contents data = piquilseed3; run;
proc freq data=piquilseed3; tables soileb*npitax; title 'piquil'; run;
proc freq data=piquilseed3; tables soileb*npitax; title 'piquil'; run;

*finding whether each is counted more than once
proc sql;
	select year, plot, sspp, subp
	from piquil
	where year eq 2002 and
		  sspp = 'QUMA3';
quit;
*A: NO, they are not counted twice. Won't affect abundance.

*checking for missing values. NONE;

*/

data piquilseed4; set piquilseed3; 	
 	keep aspect bcat covm elev heig hydrn nilvox npitax nquma3 nqumax plot year prpo slope soileb pltd;
run;  * N = 2247;
proc sort data=piquilseed4; by year prpo plot bcat aspect hydrn soileb pltd; run;

/* proc freq data=piquilseed4; tables pltd; run; *1776 sand, 471 gravel;
   proc contents data=piquilseed4; run; 
   proc print data=piquilseed4; title 'piquil4'; run; */

* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                      10    aspect      Num       8
                       3    bcat        Num       8
                       5    covm        Num       8
                       8    elev        Num       8    BEST12.    BEST32.
                       6    heig        Num       8    BEST12.    BEST32.
                      11    hydrn       Num       8
                      15    nilvox      Num       8
                      14    npitax      Num       8
                      12    nquma3      Num       8
                      13    nqumax      Num       8
                       1    plot        Num       8    BEST12.    BEST32. 
					  12    pltd        Num       8
                       4    prpo        Num       8
                       9    slope       Num       8    BEST12.    BEST32.
                       7    soileb      Num       8    BEST12.    BEST32.
                       2    year        Num       8    BEST12.    BEST32
;

proc means data=piquilseed4 mean noprint; by year plot bcat aspect hydrn soileb pltd;
  var nilvox npitax nquma3 nqumax covm elev slope heig;
  output out=piquilseed5 mean = milvox mpitax mquma3 mqumax mcov elev slope mhgt;
run;
data piquilseed6; set piquilseed5; drop _TYPE_; 
*proc print data=piquilseed6; title 'piquil6'; run; *N=267;

/* 
*Just messing around with dataset;
data piquil7; set piquil6; if year >2011; run;
proc plot data=piquil6; plot mcoun*mcov; run;
proc glm data=piquil6; title 'post';  
	model mcoun = year;
	output out=glmout2 r=ehat;
run; 
*/

proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use piquilseed6; read all into mat1;
* print mat1;

nrecords = nrow(mat1);   *print nrecords; *N = 267;

mat2 = j(nrecords,24,.); * create mat2 has 267 rows, 24 columns, each element=0;
do i = 1 to nrecords;    * record by record loop;
  do j = 1 to nyrs;      * yr by yr loop;
    if (mat1[i,1] = inputyrs[j]) then mat2[i,1] = j;  * pref in col 1;
  end;                   * end yr by yr loop;
end;                     * end yr by yr loop;
* print mat2;

mattemp = j(nrecords,2,0);
do i = 1 to nrecords;
  if mat2[i,1] = 1     then mattemp[i,1] = 1;
  if mat2[i,1] = nyrs  then mattemp[i,2] = 1;
end;
* print mattemp;
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many year1? (3);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many year2? (43);

* variables the same each year: aspect, bcat, elev, hydrn, plot, slope, soileb, 
  variables that change each year: _FREQ_, covm, mhgt, year, milvox, mpitax, mqumax,
								mquma3;

*order of variables in mat1: year, plot, bcat, aspect, hydr, soileb, pltd, _FREQ_, ilvo, pita, quma3, qumax, 
	mcov, elev, slope, mhgt	;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * bcat;
  mat2[i,7] = mat1[i,4];   * aspect;
  mat2[i,8] = mat1[i,5];   * hydrn;
  mat2[i,9] = mat1[i,6];   * soileb;
  mat2[i,10] = mat1[i,7];  * pltd;
  mat2[i,11] = mat1[i,14]; * elev;
  mat2[i,12] = mat1[i,15]; * slope;
  mat2[i,13] = mat1[i,9];  * milvo1;
  mat2[i,15] = mat1[i,10]; * mpita1;
  mat2[i,17] = mat1[i,11]; * mqum31;
  mat2[i,19] = mat1[i,12]; * mqumx1;
  mat2[i,21] = mat1[i,13]; * covm1;
  mat2[i,23] = mat1[i,16]; * mhgt1;
end;
* print mat2;

do i = 1 to nrecords;
  plot = mat2[i,5]; time2 = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = time2) then do;
	  *print i,j;
  	  mat2[i,4]  = mat2[j,3];  * year2;
	  mat2[i,14] = mat2[j,13]; * milvo2;
  	  mat2[i,16] = mat2[j,15]; * mpita2;
  	  mat2[i,18] = mat2[j,17]; * mqum32;
  	  mat2[i,20] = mat2[j,19]; * mqumx2;
	  mat2[i,22] = mat2[j,21]; * covm2;
	  mat2[i,24] = mat2[j,23]; * mhgt2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'year1', 'year2', 'plot', 'bcat', 'aspect', 'hydr', 'soil', 'pltd', 
			'elev', 'slope', 'ilvo1', 'ilvo2', 'pita1', 'pita2', 'qum31', 'qum32', 'quma1', 'quma2', 
			'covm1', 'covm2', 'mhgt1', 'mhgt2'};
create seedpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

/* 
proc print data=seedpairs; title 'seedpairs'; run; *N=267;
proc freq data=seedpairs; tables soil; run; 	   * 204 sand, 63 gravel;
*/
*******Need to fix height---right now, just one mean height for all species/plot/year;


*reorganizing seedpairs;
data seedpairspp; set seedpairs;
	if (year1<2011)  then yrcat='pref'; 
	if (year1>=2011) then yrcat='post';	
	drop time1 time2 year2 ilvo2 pita2 qum32 quma2 covm2 mhgt2; 
	rename year1=year covm1=caco ilvo1=ilvo pita1=pita qum31=qum3 quma1=quma mhgt1=heig;
run;
data seedspref;  set seedpairspp;
	if yrcat='pref';
run; *N=94;
data seedspost; set seedpairspp;
	if yrcat='post'; 
run; *N=173;
*pooling data in seedspre;
proc sort  data=seedspref; by plot bcat elev hydr slope soil aspect;
proc means data=seedspref n mean noprint; by plot bcat elev hydr slope soil aspect;
	var ilvo pita qum3 quma caco heig;
	output out=mseedspref n=nilv npit nqm3 nqma ncov nhgt 
		   			  mean=milv mpit mqm3 mqma mcov mhgt;
run;
*proc print data=mseedspref; title 'mseedspref'; run; *N=51;

*structure 1;
proc sort data=seedspost; by plot bcat elev hydr slope soil aspect;
proc sort data=mseedspref; by plot bcat elev hydr slope soil aspect; run;
data seedsmerge1; merge seedspost mseedspref; by plot bcat elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ yrcat; 
run;
*proc print data=seedsmerge1; title 'seedsmerge1'; run;	*N=179;
*proc contents data=seedsmerge1; run;


*structure 2;
proc sort data=seedspost; by plot year;	run;
data dat2012; set seedspost; if year=2012; 
	 rename pita=pita12sd quma=quma12sd ilvo=ilvo12sd qum3=qum312sd caco=cov12;  
data dat2013; set seedspost; if year=2013; 
	 rename pita=pita13sd quma=quma13sd ilvo=ilvo13sd qum3=qum313sd caco=cov13; 
data dat2014; set seedspost; if year=2014; 
	 rename pita=pita14sd quma=quma14sd ilvo=ilvo14sd qum3=qum314sd caco=cov14;  
data dat2015; set seedspost; if year=2015; 
	 rename pita=pita15sd quma=quma15sd ilvo=ilvo15sd qum3=qum315sd caco=cov15; 
data prefavg; set mseedspref; 
	 rename nilv=nilvopresd npit=npitapresd nqm3=nquma3presd nqma=nqumapresd ncov=ncovpre nhgt=nhgtpre 
		   	milv=milvopresd mpit=mpitapresd mqm3=mquma3presd mqma=mqumapresd mcov=mcovpre mhgt=mhgtpre;
run;
data seedsmerge2; merge prefavg dat2012 dat2013 dat2014 dat2015; by plot; drop year; run;
*proc print data=seedsmerge2; title 'seedsmerge2'; run; 
	*N=55----not 56 like all the others b/c 1226 was never surveyed for seedlings or shrubs;

proc freq data=seedsmerge2; tables bcat; run;

/*
proc export data=seedsmerge2
   outfile='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\seedsmerge2.csv'
   dbms=csv
   replace;
run;
*/
