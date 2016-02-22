****************putting saplings and shrubs together to have pines, oaks, and ilex in the same set;
data piquilsap; set alld;
	if (subp = 'sapl') | (subp = 'shrp') | (subp = 'shru') | (subp = 'sapp');
	keep aspect bcat coun covm elev diam heig hydrn plot slope soileb sspp subp year prpo; 
run; 
proc sort data=piquilsap; by subp plot sspp year bcat covm coun diam heig soileb elev slope aspect hydrn prpo; run;
proc means data=piquilsap noprint sum; by subp plot sspp year bcat covm coun diam heig soileb elev slope aspect hydrn prpo; var coun; 
  output out=piquilsap2 sum=nperspp; run; *N=2736;
/* proc print data=piquilsap2; title 'pi-qu-il numplantdata';    run;
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* piquil2 contains: obs, plot, sspp, year, burn, prpo, covm, soil, elev, slope, aspect, hydr, nperspp
  nperspp = # of sdlngs/stems per species per plot/year;  */

*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUMA3'); nquma3 = nperspp; 
	proc sort data=holdquma3; by plot bcat year; 
data holdqumax; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUMAx'); nqumax = nperspp;
	proc sort data=holdqumax; by plot bcat year; 
data holdpitax; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'PITAx'); npitax = nperspp; 
	proc sort data=holdpitax; by plot bcat year; 
data holdilvox; set piquilsap2; if (subp = 'sapp' | subp = 'shru') & (sspp = 'ILVOx'); nilvox = nperspp; 
	proc sort data=holdilvox; by plot bcat year;  
data holdxxxxx; set piquilsap2; if (subp = 'sapl') 				   & (sspp = 'XXXXx'); nquma3 = nperspp & nqumax = nperspp & npitax = nperspp & nilvox = nperspp; 
	proc sort data=holdxxxxx; by plot bcat year; 
run;
/* proc print data=holdquma3; run; 	*N=299;
   proc print data=holdqumax; run; 	*N=534;	
   proc print data=holdpitax; run; 	*N=499;
   proc print data=holdilvox; run; 	*N=252; 
   proc print data=holdxxxxx; run; 	*N=101; */

/*   *ran with other species; none are very common (but JUVI? 122);
data holdquin; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUINx'); nquma3 = nperspp; 
	proc sort data=holdquin; by plot bcat year;   *N=4;
data holdqust; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUSTx'); nqumax = nperspp;
	proc sort data=holdqust; by plot bcat year;  *N=37;
data holdqudr; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUDRx'); npitax = nperspp; 
	proc sort data=holdqudr; by plot bcat year;  *N=0;
data holdjuvi; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'JUVIx'); nilvox = nperspp; 
	proc sort data=holdjuvi; by plot bcat year;  *N=122;
run;
*/

proc sort data=piquilsap2; by plot bcat year; run;
*n(spp) is count, pa(spp) is presence/absence;
data piquilsap3; merge holdquma3 holdqumax holdpitax holdilvox holdxxxxx piquilsap2; by plot bcat year;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nilvox = .) then nilvox=0; if (nilvox=0) then pailvox=0; if (nilvox ^= 0) then pailvox=1;  
  drop _TYPE_ _FREQ_ sspp nperspp;  * dropping sspp & nperspp - become garbage;
run; *N=2736;

/* proc print data=piquilsap3; title 'piquilsap3'; run;  * N = 2736; 
proc contents data = piquilsap3; run;
proc freq data=piquilsap3; tables soileb*npitax; title 'piquil'; run;
proc freq data=piquilsap3; tables soileb*npitax; title 'piquil'; run;

*/

data piquilsap4; set piquilsap3; 		
	keep aspect bcat covm elev diam heig hydrn nilvox npitax nquma3 nqumax plot year prpo slope soileb;
run;  * N = 2736;
proc sort data=piquilsap4; by year prpo plot bcat aspect hydrn soileb; run;
/* proc freq data=piquilsap4; tables soileb; run; *2146 sand, 590 gravel;
   proc contents data=piquilsap4; run; 
   proc print data=piquilsap4; title 'piquil4'; run; */

* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                      10    aspect      Num       8
                       3    bcat        Num       8
                       4    covm        Num       8    BEST12.    BEST32.
                       5    diam        Num       8    BEST12.    BEST32.
                       8    elev        Num       8    BEST12.    BEST32.
                       6    heig        Num       8    BEST12.    BEST32.
                      11    hydrn       Num       8
                      16    nilvox      Num       8
                      15    npitax      Num       8
                      13    nquma3      Num       8
                      14    nqumax      Num       8
                       1    plot        Num       8    BEST12.    BEST32.
                      12    prpo        Num       8
                       9    slope       Num       8    BEST12.    BEST32.
                       7    soileb      Num       8    BEST12.    BEST32.
                       2    year        Num       8    BEST12.    BEST32.


;

proc means data=piquilsap4 mean noprint; by year plot bcat aspect hydrn soileb;
  var nilvox npitax nquma3 nqumax covm elev slope heig diam;
  output out=piquilsap5 mean = milvox mpitax mquma3 mqumax mcov elev slope mhgt mdbh;
run;
data piquilsap6; set piquilsap5; drop _TYPE_; 
*proc print data=piquilsap6; title 'piquil6'; run; *N=269;

*IML to re-organize data;
proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use piquilsap6; read all into mat1;
* print mat1;

nrecords = nrow(mat1);   *print nrecords; *N = 269;

mat2 = j(nrecords,25,.); * create mat2 has 191 rows, 25 columns, each element=0;
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
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many year1? (7);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many year2? (49);

* variables the same each year: aspect, bcat, elev, hydrn, plot, slope, soileb, 
  variables that change each year: _FREQ_, covm, mdbh, mhgt, year, milvox, mpitax, mqumax,
								mquma3;

*order of variables in mat1: year, plot, bcat, aspect, hydr, soileb, _FREQ_, ilvo, pita, quma3, qumax, 
	mcov, elev, slope, mhgt, mdbh;

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
  mat2[i,10] = mat1[i,13]; * elev;
  mat2[i,11] = mat1[i,14]; * slope;
  mat2[i,12] = mat1[i,8];  * milvo1;
  mat2[i,14] = mat1[i,9];  * mpita1;
  mat2[i,16] = mat1[i,10]; * mqum31;
  mat2[i,18] = mat1[i,11]; * mqumx1;
  mat2[i,20] = mat1[i,12]; * covm1;
  mat2[i,22] = mat1[i,15]; * mhgt1;
  mat2[i,24] = mat1[i,16]; * mdbh1;
end;
* print mat2;

do i = 1 to nrecords;
  plot = mat2[i,5]; time2 = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = time2) then do;
	  *print i,j;
  	  mat2[i,4]  = mat2[j,3];  * year2;
	  mat2[i,13] = mat2[j,12]; * milvo2;
  	  mat2[i,15] = mat2[j,14]; * mpita2;
  	  mat2[i,17] = mat2[j,16]; * mqum32;
  	  mat2[i,19] = mat2[j,18]; * mqumx2;
	  mat2[i,21] = mat2[j,20]; * covm2;
	  mat2[i,23] = mat2[j,22]; * mhgt2;
	  mat2[i,25] = mat2[j,24]; * mdbh2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'year1', 'year2', 'plot', 'bcat', 'aspect', 'hydr', 'soil', 'elev', 
			'slope', 'ilvo1', 'ilvo2', 'pita1', 'pita2', 'qum31', 'qum32', 'quma1', 'quma2', 
			'covm1', 'covm2', 'mhgt1', 'mhgt2', 'mdbh1', 'mdbh2'};
create sappairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

/* 
proc print data=sappairs; title 'sappairs'; run; *N=269;
proc freq data=sappairs; tables soil; run; 	   * 206 sand, 63 gravel;
*/


*reorganizing seedpairs;
data sappairsspp; set sappairs;
	if (year1<2011)  then yrcat='pref'; 
	if (year1>=2011) then yrcat='post';	
	drop time1 time2 year2 ilvo2 pita2 qum32 quma2 covm2 mhgt2 mdbh2; 
	rename year1=year covm1=caco ilvo1=ilvo pita1=pita qum31=qum3 quma1=quma mhgt1=heig mdbh1=diam;
run;
data sappref;  set sappairsspp;
	if yrcat='pref';
run; *N=96;
data sappost; set sappairsspp;
	if yrcat='post'; 
run; *N=173;
*pooling data in sappre;
proc sort  data=sappref; by plot bcat elev hydr slope soil aspect;
proc means data=sappref n mean noprint; by plot bcat elev hydr slope soil aspect;
	var ilvo pita qum3 quma caco heig;
	output out=msappref n=nilv npit nqm3 nqma ncov nhgt ndbh
		   			  mean=milv mpit mqm3 mqma mcov mhgt mdbh;
run;
*proc print data=mseedspref; title 'mseedspref'; run; *N=52;

*structure 1;
proc sort data=sappost; by plot bcat elev hydr slope soil aspect;
proc sort data=msappref; by plot bcat elev hydr slope soil aspect; run;
data sapmerge1; merge sappost msappref; by plot bcat elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ yrcat; 
run;
*proc print data=sapmerge1; title 'sapmerge1'; run;	*N=180;
*proc contents data=sapmerge1; run;


*structure 2;
proc sort data=sappost; by plot year;	run;
data dat2012; set sappost; if year=2012; 
	 rename pita=pita12 quma=quma12 ilvo=ilvo12 qum3=qum312 caco=cov12;  
data dat2013; set sappost; if year=2013; 
	 rename pita=pita13 quma=quma13 ilvo=ilvo13 qum3=qum313 caco=cov13; 
data dat2014; set sappost; if year=2014; 
	 rename pita=pita14 quma=quma14 ilvo=ilvo14 qum3=qum314 caco=cov14; 
data prefavg; set msappref; 
	 rename nilv=nilvopre npit=npitapre nqm3=nquma3pre nqma=nqumapre ncov=ncovpre nhgt=nhgtpre ndbh=ndbhpre
		   	milv=milvopre mpit=mpitapre mqm3=mquma3pre mqma=mqumapre mcov=mcovpre mhgt=mhgtpre mdbh=mdhbpre;
run;
data sapmerge2; merge prefavg dat2012 dat2013 dat2014; by plot; drop year; run;
*proc print data=sapmerge2; title 'sapmerge2'; run; *N=55;

/*
proc export data=sapmerge2
   outfile='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\seedsmerge2.csv'
   dbms=csv
   replace;
run;
*/












