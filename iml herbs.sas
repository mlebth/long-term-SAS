****************pulling herbaceous data from the megaset;
data herbx; set alld;
	if (subp = 'herb'); 
run;  *N=12545;
data herb1; set herbx;
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo; *check TRURx;
run;
proc sort data=herb1; by plot sspp year bcat covm coun quad soileb elev slope aspect hydrn prpo; run;



proc means data=herb1 noprint sum; by plot sspp year bcat covm coun quad soileb elev slope aspect hydrn prpo; var coun; 
  output out=herb2 sum=nperspp; run; *N=11100;

/* *checking for out of place sspp;
  proc sort data=herb2; by sspp;
  proc means data=herb2; by sspp; output out=herb2x; run;
  proc print data=herb2x; run;
proc freq data=herb2x; tables sspp; run;
*/

/* proc print data=herb2; title 'herb numplantdata';   run;
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* N = 442 species-plot-year combinations;
* herb2 contains: obs, plot, sspp, year, bcat, prpo, covm, coun, soileb, elev, slope, aspect, hydrn, nperspp,
  				_TYPE_, _FREQ_
  nperspp = # of sdlngs or stems per species per plot-year;  */

/*
proc sql;
	select plot, year, sspp, coun
	from herb2;
quit;
*/

data herb3; set herb2; 	
 	keep aspect bcat covm coun elev hydrn plot year prpo slope soileb sspp nperspp;
run;  * N = 11100;
proc sort data=herb3; by year prpo plot bcat aspect hydrn soileb; run;

/* proc freq data=herb3; tables soileb; run; *8501 sand, 2599 gravel;
   proc contents data=herb3; run; 
   proc print data=herb3; title 'herb3'; run; */

* Contents:
#    Variable    Type    Len    Format     Informat
10 	 aspect		 Num	 8     
4 	 bcat		 Num	 8     
6 	 coun		 Num	 8 		BEST12. 	BEST32. 
5 	 covm		 Num	 8		BEST12. 	BEST32. 
8 	 elev		 Num	 8 		BEST12. 	BEST32. 
11	 hydrn		 Num	 8     
13	 nperspp	 Num	 8 		BEST12. 	BEST32. 
1	 plot		 Num	 8 		BEST12.		BEST32. 
12	 prpo		 Num	 8     
9	 slope		 Num	 8 		BEST12.		BEST32. 
7	 soileb		 Num	 8 		BEST12.		BEST32. 
2	 sspp		 Char	 5     
3	 year		 Num	 8 		BEST12.		BEST32. 

;

*what am i looking for?
effects of {burn severity, light, soil type, time since fire, hydromulch, pre-fire veg} 
	on herbs (stem density, diversity--species richness/evenness, composition [native vs non, hydro])

i can use iml to reorganize if i: 
	--organize the same way as piquil data (stem count each year is the DV), but using only a small number of most common species
	--ignore species altogether and use other year-by-year metrics (diversity, density) as the dependent variable

otherwise:
	--nonparametric tests (ordination/PERMANOVA)
;

*getting mean stem count/year;
proc means data=herb3 mean noprint; by year plot sspp bcat aspect hydrn soileb;
  var coun covm elev slope;
  output out=herb4 mean = mcnt mcov elev slope;
run;
data herb5; set herb4; drop _TYPE_; 
*proc print data=herb5; title 'herb5'; run; *N=4812;


proc sort data=herb5; by sspp year mcnt; run;
proc means data=herb5 mean noprint; by sspp year;
  var mcnt;
  output out=herb5x mean = mcnt2;
run;
proc sort data=herb5x; by year mcnt2; run;

proc sort data=herb5; by sspp; run;
proc means data=herb5 mean noprint; by sspp;
  var plot;
  output out=herb5x mean = mplot;
run;
proc sort data=herb5x; by sspp; run;
proc sql;
	select sspp
	from herb5x;
quit;



/*
proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use herb5; read all into mat1;
* print mat1;

nrecords = nrow(mat1);   *print nrecords; *N = 4812;

mat2 = j(nrecords,11,.); * create mat2 has 4812 rows, 11 columns, each element=0;
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

* variables the same each year: aspect, bcat, elev, hydrn, plot, slope, soileb, sspp
  variables that change each year: mcnt, nperspp,  _FREQ_, mcov, year;

*order of variables in mat1: year, plot, bcat, aspect, hydr, soileb, pltd, _FREQ_,  
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


/*
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
