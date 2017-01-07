****************putting saplings and shrubs together to have pines, oaks, and ilex in the same set;
data piquiltrees; set alld;
	if (subp = 'tree');		
	if (sspp = 'XXXXx' | stat='D') then coun=0;
					  			   else coun=1;
	keep aspect bcat covm coun elev diam crwn hydrn plot slope soileb sspp subp year prpo stat; 
run; 
proc sort data=piquiltrees; by subp plot sspp year bcat covm coun diam crwn soileb elev slope aspect hydrn prpo stat; run;
proc means data=piquiltrees noprint sum; by subp plot sspp year bcat covm coun diam crwn soileb elev slope aspect hydrn prpo stat; var coun; 
  output out=piquiltrees2 sum=nperspp; run; *N=5674;
/* proc print data=piquiltrees (firstobs=1 obs=100); title 'pi-qu-il numplantdata';    run;
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* piquil2 contains: obs, plot, sspp, year, burn, prpo, covm, soil, elev, slope, aspect, hydr, nperspp
  nperspp = # of sdlngs/stems per species per plot/year;  */

/*  *determining most common tree species;
proc freq data=piquiltrees2; tables sspp; run;
*most common species:
	PITA:  2426
	QUMA:  1024
	JUVI:  383
	QUST:  265
	QUMA3: 261
	XXXX:  81;
*others: CATE (2), QUDR (21), QUMA2 (4), ULAL (4), ULCR	(8);

 *what and where is quma2?
PROC sql;
	select sspp, plot, year
	from piquiltrees2
	where sspp = 'QUMA3';
quit; 
  *Quercus macrocarpa (bur oak), plots 1191 and 1221 in 2010 and 2011;
*/

*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set piquiltrees2; if (sspp = 'QUMA3'); nquma3 = nperspp; 
	proc sort data=holdquma3; by plot bcat year; 
data holdqumax; set piquiltrees2; if (sspp = 'QUMAx'); nqumax = nperspp;
	proc sort data=holdqumax; by plot bcat year; 
data holdpitax; set piquiltrees2; if (sspp = 'PITAx'); npitax = nperspp; 
	proc sort data=holdpitax; by plot bcat year; 
data holdqustx; set piquiltrees2; if (sspp = 'QUSTx'); nqustx = nperspp; 
	proc sort data=holdqustx; by plot bcat year;   
data holdjuvix; set piquiltrees2; if (sspp = 'JUVIx'); njuvix = nperspp; 
	proc sort data=holdjuvix; by plot bcat year;  
data holdxxxxx; set piquiltrees2; if (sspp = 'XXXXx'); 
	nquma3 = nperspp; nqumax = nperspp; npitax = nperspp; nqustx = nperspp; njuvix = nperspp; 
	proc sort data=holdxxxxx; by plot bcat year; 
run;
/* proc print data=holdquma3; run; 	*N=261;
   proc print data=holdqumax; run; 	*N=1024;	
   proc print data=holdpitax (firstobs=1 obs=30); run; 	*N=2426;
   proc print data=holdqustx; run; 	*N=265; 
   proc print data=holdjuvix; run; 	*N=383; 
   proc print data=holdxxxxx; run; 	*N=81; */

proc sort data=holdquma3; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdquma3 n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam crwn nperspp nquma3;
	output out=quma3mean n = ndiam ncrwn numperplot numquma3 sum=sumdiam sumcrwn nperspp nquma3 mean= mdiam mcrwn meanperplot mquma3;
data quma3; set quma3mean; drop _TYPE_ _FREQ_ ndiam ncrwn numperplot numquma3 sumdiam sumcrwn nperspp meanperplot mquma3; run;
*proc print data=quma3; run; *n=89;

proc sort data=holdqumax; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdqumax n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam crwn nperspp nqumax;
	output out=qumaxmean n = ndiam ncrwn numperplot numqumax sum=sumdiam sumcrwn nperspp nqumax mean= mdiam mcrwn meanperplot mqumax;
data qumax; set qumaxmean; drop _TYPE_ _FREQ_ ndiam ncrwn numperplot numqumax sumdiam sumcrwn nperspp meanperplot mqumax; run;
*proc print data=qumax; run; *n=132;

proc sort data=holdpitax; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdpitax n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam crwn nperspp npitax;
	output out=pitamean n = ndiam ncrwn numperplot numpitax sum=sumdiam sumcrwn nperspp npitax mean= mdiam mcrwn meanperplot mpitax;
data pita; set pitamean; drop _TYPE_ _FREQ_ ndiam ncrwn numperplot numpitax sumdiam sumcrwn nperspp meanperplot mpitax; run;
*proc print data=pita; run; *n=153;

proc sort data=holdqustx; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdqustx n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam crwn nperspp nqustx;
	output out=qustmean n = ndiam ncrwn numperplot numqustx sum=sumdiam sumcrwn nperspp nqustx mean= mdiam mcrwn meanperplot mqustx;
data qust; set qustmean; drop _TYPE_ _FREQ_ ndiam ncrwn numperplot numqustx sumdiam sumcrwn nperspp meanperplot mqustx; run;
*proc print data=qust; run; *n=40;

proc sort data=holdjuvix; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdjuvix n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam crwn nperspp njuvix;
	output out=juvimean n = ndiam ncrwn numperplot numjuvix sum=sumdiam sumcrwn nperspp njuvix mean= mdiam mcrwn meanperplot mjuvix;
data juvi; set juvimean; drop _TYPE_ _FREQ_ ndiam ncrwn numperplot numjuvix sumdiam sumcrwn nperspp meanperplot mjuvix; run;
*proc print data=juvi; run; *n=52;

proc sort data=holdxxxxx; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; run;
proc means data=holdxxxxx n sum mean noprint; by plot sspp year bcat covm soileb elev slope aspect hydrn prpo; var diam crwn nperspp ;
	output out=xxxxmean n = ndiam ncrwn numperplot  sum=sumdiam sumcrwn nperspp  mean= mdiam mcrwn meanperplot ;
data xxxx; set xxxxmean; drop _TYPE_ _FREQ_ ndiam ncrwn numperplot sumdiam sumcrwn meanperplot ; run;
*proc print data=xxxx; run; *n=81;

proc sort data=piquiltrees2; by plot bcat year; run;
*n(spp) is count, pa(spp) is presence/absence;
data piquiltrees3; merge quma3 quma pita qust juvi xxxx piquiltrees2; by plot bcat year;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nqustx = .) then nqustx=0; if (nqustx=0) then paqustx=0; if (nqustx ^= 0) then paqustx=1; 
  if (njuvix = .) then njuvix=0; if (njuvix=0) then pajuvix=0; if (njuvix ^= 0) then pajuvix=1; 
  if (stat='D')	  then nquma3=0 & nqumax=0 & npitax=0 & nqustx=0 & njuvix=0
					 & paquma3=0 & paqumax=0 & papitax=0 & paqustx=0 & pajuvix=0;
  drop _TYPE_ _FREQ_ subp sspp nperspp;  * dropping sspp & nperspp - become garbage;
run; *N=4477;
/* proc print data=piquiltrees3 (firstobs=1 obs=200); title 'piquiltrees3'; run;  * N = 4477; 
proc contents data = piquiltrees3; run;
*/

data piquiltrees4; set piquiltrees3; 		
	keep aspect bcat covm elev mdiam mcrwn hydrn njuvix npitax nquma3 nqumax nqustx plot year prpo slope soileb;
run;  * N = 2736;
proc sort data=piquiltrees4; by plot year; run;
/* proc freq data=piquiltrees4; tables soileb; run; *3818 sand, 661 gravel;
   proc contents data=piquiltrees4; run; 
   proc print data=piquiltrees4 (firstobs=1 obs=150); title 'piquil4'; run; */

* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                       10    aspect      Num       8
                        3    bcat        Num       8
                        4    covm        Num       8    BEST12.    BEST32.
                        6    crwn        Num       8    BEST12.    BEST32.
                        5    diam        Num       8    BEST12.    BEST32.
                        8    elev        Num       8    BEST12.    BEST32.
                       11    hydrn       Num       8
                       17    njuvix      Num       8
                       15    npitax      Num       8
                       13    nquma3      Num       8
                       14    nqumax      Num       8
                       16    nqustx      Num       8
                        1    plot        Num       8    BEST12.    BEST32.
                       12    prpo        Num       8
                        9    slope       Num       8    BEST12.    BEST32.
                        7    soileb      Num       8    BEST12.    BEST32.
                        2    year        Num       8    BEST12.    BEST32.
;
/* 1-5-17--the means for count are wrong, use n (mean is how many trees of a certain DBH per plot, which is
why they're all very low)--keeping means for plot-level variables though;
proc means data=piquiltrees4 n mean noprint; by year plot bcat aspect hydrn soileb;
  var npitax nquma3 nqumax nqustx njuvix covm elev slope crwn diam;
  output out=piquiltrees5 mean = mpitax mquma3 mqumax mqustx mjuvix mcov elev slope mcrn mdbh;
run;
*/
proc sort data=piquiltrees4; by year plot bcat aspect hydrn soileb; run;
proc means data=piquiltrees4 mean noprint; by year plot bcat aspect hydrn soileb;
  var npitax nquma3 nqumax nqustx njuvix covm elev slope mcrwn mdiam;
  output out=piquiltrees5 mean = mpitax mquma3 mqumax mqustx mjuvix mcov melev mslope mcrn mdbh;
run;
data piquiltrees6; set piquiltrees5; drop _TYPE_ ; 
proc sort data=piquiltrees6; by plot year; run;
*proc print data=piquiltrees6; title 'piquil6'; run; *N=279;

*IML to re-organize data;
proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use piquiltrees6; read all into mat1;
* print mat1;

nrecords = nrow(mat1);   *print nrecords; *N = 272;

mat2 = j(nrecords,27,.); * create mat2 has 272 rows, 27 columns, each element=0;
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

*order of variables in mat1: 
	year, plot, bcat, aspect, hydr, soileb, _FREQ_, mpita, mquma3, mqumax, 
	mqust, mjuvi, mcov, melev, mslope, mcrwn, mdiam;

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
  mat2[i,10] = mat1[i,14]; * elev;
  mat2[i,11] = mat1[i,15]; * slope;
  mat2[i,12] = mat1[i,8];  * pita1;
  mat2[i,14] = mat1[i,9];  * qum31;
  mat2[i,16] = mat1[i,10]; * qumx1;
  mat2[i,18] = mat1[i,11]; * qust1;
  mat2[i,20] = mat1[i,12]; * juvi1;
  mat2[i,22] = mat1[i,13]; * covm1;
  mat2[i,24] = mat1[i,16]; * mcrn1;
  mat2[i,26] = mat1[i,17]; * mdbh1;
end;
* print mat2;

do i = 1 to nrecords;
  plot = mat2[i,5]; time2 = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = time2) then do;
	  *print i,j;
  	  mat2[i,4]  = mat2[j,3];  * year2;
	  mat2[i,13] = mat2[j,12]; * mpita2;
  	  mat2[i,15] = mat2[j,14]; * mqum32;
  	  mat2[i,17] = mat2[j,16]; * mqumx2;
  	  mat2[i,19] = mat2[j,18]; * mqust2;
  	  mat2[i,21] = mat2[j,20]; * mjuvi2;
	  mat2[i,23] = mat2[j,22]; * covm2;
	  mat2[i,25] = mat2[j,24]; * mcrn2;
	  mat2[i,27] = mat2[j,26]; * mdbh2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'year1', 'year2', 'plot', 'bcat', 'aspect', 'hydr', 'soil', 'elev', 
			'slope', 'pita1', 'pita2', 'qum31', 'qum32', 'quma1', 'quma2', 'qust1', 'qust2', 
			'juvi1', 'juvi2', 'covm1', 'covm2', 'mcrn1', 'mcrn2', 'mdbh1', 'mdbh2'};
create treepairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

/* 
proc print data=treepairs; title 'treepairs'; run; *N=408;
proc freq data=treepairs; tables soil; run; 	   * 322 sand, 86 gravel;
*/
proc sort data=treepairs; by year1; *proc print data=treepairs; run;

*reorganizing treepairs;
data treepairssp; set treepairs;
	if (year1<2011)  then yrcat='pref'; 
	if (year1>=2011) then yrcat='post';	
	drop time1 time2 year2 pita2 qum32 quma2 qust2 juvi2 covm2 mcrn2 mdbh2; 
	rename year1=year covm1=caco pita1=pita qum31=qum3 quma1=quma 
		   qust1=qust juvi1=juvi mcrn1=crwn mdbh1=diam;
run;
data treepref;  set treepairssp;
	if yrcat='pref';
run; *N=86;
data treepost; set treepairssp;
	if yrcat='post'; 
run; *N=186;
*pooling data in treepref;
proc sort  data=treepref; by plot bcat elev hydr slope soil aspect;
proc means data=treepref n mean noprint; by plot bcat elev hydr slope soil aspect;
	var pita qum3 quma qust juvi caco crwn diam;
	output out=mtreepref n=npit nqm3 nqma nqst njuv ncov ncrn ndbh
		   			  mean=mpit mqm3 mqma mqst mjuv mcov mcrn mdbh;
run;
*proc print data=mtreepref; title 'mtreepref'; run; *N=37;

*structure 1;
proc sort data=treepost; by plot bcat elev hydr slope soil aspect;
proc sort data=mtreepref; by plot bcat elev hydr slope soil aspect; run;
data treemerge1; merge treepost mtreepref; by plot bcat elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ yrcat; 
run;
*proc print data=treemerge1; title 'treemerge1'; run;	*N=180;
*proc contents data=treemerge1; run;


*structure 2;
proc sort data=treepost; by plot year;	run;
data dat2012; set treepost; if year=2012; 
	 rename pita=pita12tr quma=quma12tr qum3=qum312tr qust=qust12tr juvi=juvi12tr caco=cov12; *n=49; 
data dat2013; set treepost; if year=2013; 
	 rename pita=pita13tr quma=quma13tr qum3=qum313tr qust=qust13tr juvi=juvi13tr caco=cov13; *n=54;
data dat2014; set treepost; if year=2014; 
	 rename pita=pita14tr quma=quma14tr qum3=qum314tr qust=qust14tr juvi=juvi14tr caco=cov14; *n=57;
data dat2015; set treepost; if year=2015; 
	 rename pita=pita15tr quma=quma15tr qum3=qum315tr qust=qust15tr juvi=juvi15tr caco=cov15; *n=51;
data prefavg; set mtreepref; 
	 rename npit=npitapretr nqm3=nquma3pretr nqma=nqumapretr nqst=nqustpretr njuv=njuvipretr ncov=ncovpre ncrn=ncrnpre ndbh=ndbhpre
		   	mpit=mpitapretr mqm3=mquma3pretr mqma=mqumapretr mqst=mqustpretr mjuv=mjuvipretr mcov=mcovpre mcrn=mcrnpre mdbh=mdhbpre;
run; *n=37;
data treemerge2; merge prefavg dat2012 dat2013 dat2014 dat2015; by plot; drop year; run;
*proc print data=treemerge2; title 'treemerge2'; run; 
	*N=52 -- no data for plots 1211, 1212, 1218, 1219 b/c they are brush plots;

/*
proc freq data=treemerge2; tables bcat*pita15; run;
proc plot data=treemerge2; plot pita15*bcat; run;
*/

/*
proc export data=treemerge2
   outfile='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\treemerge2.csv'
   dbms=csv
   replace;
run;
*/
