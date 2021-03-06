****************extracting saplings only to get pines and oaks in same set;
data piquilsap; set alld;
	if (subp = 'sapl');	*currently only including sapling spp, not yaupon (shrp);
	keep aspect bcat coun covm elev diam heig hydrn plot slope soileb sspp subp year prpo; 
run; 
proc sort data=piquilsap; by subp plot sspp year bcat covm coun diam heig soileb elev slope aspect hydrn prpo; run;
proc means data=piquilsap noprint sum; by subp plot sspp year bcat covm coun diam heig soileb elev slope aspect hydrn prpo; var coun; 
  output out=piquilsap2 sum=nperspp; run; *N=1822;
/* proc print data=piquilsap2 (firstobs=1 obs=30); title 'pi-qu-il numplantdata';    run;
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* piquil2 contains: obs, plot, sspp, year, burn, prpo, covm, soil, elev, slope, aspect, hydr, nperspp
  nperspp = # of sdlngs/stems per species per plot/year;  */

  /*
proc sort data=piquilsap2; by sspp year; run;
proc means data=piquilsap2 noprint n nmiss; by sspp year; var covm;
	output out=piquilsapnum n=ncover nmiss=ncovmiss; run;
proc print data=piquilsapnum; run;

proc sql;
	select sspp, year, plot, covm
	from piquilsap
	where sspp = 'PITAx' & year eq 2014;
quit;

proc glm data=piquilsap2; by sspp year;
	model coun = covm / solution;
run;
*/

/* checking slope for problem plot. slope = 3;
proc sql;
	select plot, slope
	from alld
    where plot eq 1217;
quit;
*/

/* *ILVO never counted as a sapling;
proc sql;
	select plot, sspp
	from piquilsap
    where sspp = 'ILVOx';
quit;
*/

/* 
*checking most common sspp; 
 proc freq data=piquilsap; tables sspp; run;
*most common: PITA--590
  			  QUMA--560
  			  QUMA3--325
  			  JUVI--123
  next most common, PODE--41, QUST--37
   Include JUVI and others?;
*/

*reassigning nperspp to nquma3, nqumax, npitax. This gives num per species where each species
has its own variable for count;
data holdqustx; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUSTx'); nqustx = nperspp; 
	proc sort data=holdqustx; by plot bcat year; 
data holdquma3; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUMA3'); nquma3 = nperspp; 
	proc sort data=holdquma3; by plot bcat year; 
data holdqumax; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'QUMAx'); nqumax = nperspp;
	proc sort data=holdqumax; by plot bcat year; 
data holdpitax; set piquilsap2; if (subp = 'sapl' | subp = 'shrp') & (sspp = 'PITAx'); npitax = nperspp; 
	proc sort data=holdpitax; by plot bcat year; 
data holdxxxxx; set piquilsap2; if (subp = 'sapl') 				   & (sspp = 'XXXXx'); 
	nquma3 = nperspp; nqustx=nperspp; nqumax = nperspp; npitax = nperspp; 
	proc sort data=holdxxxxx; by plot bcat year; 
run;
/* proc print data=holdquma3; run; 	*N=298;
   proc print data=holdqumax; run; 	*N=534;	
   proc print data=holdpitax; run; 	*N=497;
   proc print data=holdxxxxx; run; 	*N=100; */

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
proc sort data=holdqustx; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdqustx n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam heig nperspp nqustx;
	output out=qustxmean n = ndiam nhgt numperplot numqustx sum=sumdiam sumhgt nperspp nqustx mean= mdiam mhgt meanperplot mqustx;
data qustx; set qustxmean; drop _TYPE_ _FREQ_ ndiam nhgt numperplot numqustx sumdiam sumhgt nperspp meanperplot mqustx; run;
*proc print data=qustx; run; *n=11;

proc sort data=holdquma3; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdquma3 n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam heig nperspp nquma3;
	output out=quma3mean n = ndiam nhgt numperplot numquma3 sum=sumdiam sumhgt nperspp nquma3 mean= mdiam mhgt meanperplot mquma3;
data quma3; set quma3mean; drop _TYPE_ _FREQ_ ndiam nhgt numperplot numquma3 sumdiam sumhgt nperspp meanperplot mquma3; run;
*proc print data=quma3; run; *n=71;


proc sort data=holdqumax; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdqumax n sum mean noprint;  by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam heig nperspp nqumax;
	output out=qumaxmean n = ndiam nhgt numperplot numqumax sum=sumdiam sumhgt nperspp nqumax mean= mdiam mhgt meanperplot mqumax;
data qumax; set qumaxmean; drop _TYPE_ _FREQ_ ndiam nhgt numperplot numqumax sumdiam sumhgt nperspp meanperplot mqumax; run;
*proc print data=qumax; run; *n=93;

proc sort data=holdpitax; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdpitax n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam heig nperspp npitax;
	output out=pitamean n = ndiam nhgt numperplot numpitax sum=sumdiam sumhgt nperspp npitax mean= mdiam mhgt meanperplot mpitax;
data pita; set pitamean; drop _TYPE_ _FREQ_ ndiam nhgt numperplot numpitax sumdiam sumhgt nperspp meanperplot mpitax; run;
*proc print data=pita; run; *n=78;

proc sort data=holdxxxxx; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdxxxxx n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam heig nperspp ;
	output out=xxxxmean n = ndiam nhgt numperplot  sum=sumdiam sumhgt nperspp  mean= mdiam mhgt meanperplot ;
data xxxx; set xxxxmean; drop _TYPE_ _FREQ_ ndiam nhgt numperplot sumdiam sumhgt meanperplot ; run;
*proc print data=xxxx; run; *n=100;

proc sort data=piquilsap2; by plot bcat year; run;
*n(spp) is count, pa(spp) is presence/absence;
data piquilsap3; merge qustx quma3 qumax pita xxxx piquilsap2; by plot bcat year;
  if (nqustx = .) then nqustx=0; if (nqustx=0) then paqustx=0; if (nqustx ^= 0) then paqustx=1;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  drop _TYPE_ _FREQ_ subp sspp nperspp;  * dropping sspp & nperspp - become garbage;
run; *N=1661;

/* proc print data=piquilsap3; title 'piquilsap3'; run;  * N = 1674; 
proc contents data = piquilsap3; run;
proc freq data=piquilsap3; tables soileb*npitax; title 'piquil'; run;
proc freq data=piquilsap3; tables soileb*npitax; title 'piquil'; run;

*/

data piquilsap4; set piquilsap3; 		
	keep aspect bcat covm elev mdiam mhgt hydrn nqustx npitax nquma3 nqumax plot year prpo slope soileb;
run;  * N = 1661;
proc sort data=piquilsap4; by year prpo plot bcat aspect slope hydrn soileb; run;
/* proc freq data=piquilsap4; tables soileb; run; *1233 sand, 441 gravel;
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
  var nqustx npitax nquma3 nqumax covm elev slope mhgt mdiam;
  output out=piquilsap5 mean = mqustx mpitax mquma3 mqumax mcov elev slope mhgt mdbh;
run;
data piquilsap6; set piquilsap5; drop _TYPE_; 
proc sort data=piquilsap6; by plot year; run;
*proc print data=piquilsap6; title 'piquil6'; run; *N=241;

*IML to re-organize data;
proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use piquilsap6; read all into mat1;
* print mat1;

nrecords = nrow(mat1);   *print nrecords; *N = 246;

mat2 = j(nrecords,25,.); * create mat2 has 246 rows, 23 columns, each element=0;
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
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many year1? (4);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many year2? (46);

* variables the same each year: aspect, bcat, elev, hydrn, plot, slope, soileb, 
  variables that change each year: _FREQ_, covm, mdbh, mhgt, year, mpitax, mqumax,
								mquma3;

*order of variables in mat1: 
year, plot, bcat, aspect, hydrn, soileb, _FREQ_, mqustx, mpitax, mquma3, 
mqumax, mcov, elev, slope, mhgt, mdbh;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * bcat;
  mat2[i,7] = mat1[i,2];   * aspect;
  mat2[i,8] = mat1[i,5];   * hydrn;
  mat2[i,9] = mat1[i,6];   * soileb;
  mat2[i,10] = mat1[i,13]; * elev;
  mat2[i,11] = mat1[i,14]; * slope;
  mat2[i,12] = mat1[i,8];  * mqust1;
  mat2[i,14] = mat1[i,9];  * mpita1;
  mat2[i,16] = mat1[i,10];  * mqum31;
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
	  mat2[i,13] = mat2[j,12]; * mqust2;
	  mat2[i,15] = mat2[j,12]; * mpita2;
  	  mat2[i,17] = mat2[j,14]; * mqum32;
  	  mat2[i,19] = mat2[j,16]; * mqumx2;
  	  mat2[i,21] = mat2[j,18]; * covm2;
	  mat2[i,23] = mat2[j,20]; * mhgt2;
	  mat2[i,25] = mat2[j,22]; * mdbh2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'year1', 'year2', 'plot', 'bcat', 'aspect', 'hydr', 'soil', 'elev', 
			'slope', 'qust1', 'qust2', 'pita1', 'pita2', 'qum31', 'qum32', 'quma1', 'quma2', 
			'covm1', 'covm2', 'mhgt1', 'mhgt2', 'mdbh1', 'mdbh2'};
create sappairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

/* 
proc print data=sappairs; title 'sappairs'; run; *N=241;
proc freq data=sappairs; tables soil; run; 	     *N=183 sand, 58 gravel;
*/


*reorganizing seedpairs;
data sappairsspp; set sappairs;
	if (year1<2011)  then yrcat='pref'; 
	if (year1>=2011) then yrcat='post';	
	drop time1 time2 year2 qust2 pita2 qum32 quma2 covm2 mhgt2 mdbh2; 
	rename year1=year covm1=caco qust1=qust pita1=pita qum31=qum3 quma1=quma mhgt1=heig mdbh1=diam;
run;
data sappref;  set sappairsspp;
	if yrcat='pref';
run; *N=76;
*proc print data=sappref; title 'sappref'; run;
data sappost; set sappairsspp;
	if yrcat='post'; 
run; *N=170;
*proc print data=sappost; title 'sappost'; run;

*pooling data in sappre;
proc sort  data=sappref; by plot bcat elev hydr slope soil aspect;
proc means data=sappref n mean noprint; by plot bcat elev hydr slope soil aspect;
	var qust pita qum3 quma caco heig diam;
	output out=msappref n= nqus npit nqm3 nqma ncov nhgt ndbh
		   			  mean= mqus mpit mqm3 mqma mcov mhgt mdbh;
run;
*proc print data=msappref; title 'mseedspref'; run; *N=41;

*structure 1;
proc sort data=sappost; by plot bcat elev hydr slope soil aspect;
proc sort data=msappref; by plot bcat elev hydr slope soil aspect; run;
data sapmerge1; merge sappost msappref; by plot bcat elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ yrcat; 
run;
*proc print data=sapmerge1; title 'sapmerge1'; run;	*N=176;
*proc contents data=sapmerge1; run;


*structure 2;
proc sort data=sappost; by plot year;	run;
data dat2012; set sappost; if year=2012; 
	 rename qust=qust12p pita=pita12p quma=quma12p qum3=qum312p caco=cov12;   
data dat2013; set sappost; if year=2013; 
	 rename qust=qust13p pita=pita13p quma=quma13p qum3=qum313p caco=cov13;   
data dat2014; set sappost; if year=2014; 
	 rename qust=qust14p pita=pita14p quma=quma14p qum3=qum314p caco=cov14;  
data dat2015; set sappost; if year=2015; 
	 rename qust=qust15p pita=pita15p quma=quma15p qum3=qum315p caco=cov15;  
data prefavg; set msappref; 
	 rename nqus=nqustprep npit=npitaprep nqm3=nquma3prep nqma=nqumaprep ncov=ncovpre nhgt=nhgtprep ndbh=ndbhprep
		   	mqus=mqustprep mpit=mpitaprep mqm3=mquma3prep mqma=mqumaprep mcov=mcovpre mhgt=mhgtprep mdbh=mdhbprep;
run; 														  
data sapmerge2; merge prefavg dat2012 dat2013 dat2014 dat2015; by plot; drop year; run;
* proc print data=sapmerge2; title 'sapmerge2'; run; 
*proc contents data=sapmerge2; run; 
	*N=52 -- no data for plots 1211, 1212, 1218, 1219 b/c they are brush plots;

/*
proc export data=sapmerge2
   outfile='d:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\sapmerge2.csv'
   dbms=csv
   replace;
run;
*/


