data piquil4; set piquil3; 	
 	keep aspect bcat1 covm elev heig hydrn nilvox npitax nquma3 nqumax plot year prpo slope soileb;
run;  * N = 437;
proc sort data=piquil4; by year prpo plot bcat1 aspect hydrn soileb; run;
proc freq data=piquil4; tables soileb; run; *301 sand, 136 gravel;
*proc contents data=piquil4; run;
/* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                       10    aspect      Num       8
                       3    bcat1       Num       8
                       5    covm        Num       8
                       8    elev        Num       8    BEST12.    BEST32.
                       6    heig        Num       8    BEST12.    BEST32.
                      11    hydrn       Num       8
                      15    nilvox      Num       8
                      14    npitax      Num       8
                      12    nquma3      Num       8
                      13    nqumax      Num       8
                       1    plot        Num       8    BEST12.    BEST32.
                       4    prpo        Num       8
                       9    slope       Num       8    BEST12.    BEST32.
                       7    soileb      Num       8    BEST12.    BEST32.
                       2    year        Num       8    BEST12.    BEST32
*/

proc means data=piquil4 mean noprint; by year prpo plot bcat1 aspect hydrn soileb;
  var nilvox npitax nquma3 nqumax covm elev slope heig;
  output out=piquil5 mean = milvox mpitax mquma3 mqumax mcov elev slope mhgt;
run;
data piquil6; set piquil5; drop _TYPE_; 
*proc print data=piquil6; title 'piquil6'; run; *N=191;

/* data piquil7; set piquil6; if year >2011; run;
proc plot data=piquil6; plot mcoun*mcov; run;
proc glm data=piquil6; title 'post';  
	model mcoun = year;
	output out=glmout2 r=ehat;
run; */

proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014};
nyrs = nrow(inputyrs);  * print nyrs; *10 yrs;

use piquil6; read all into mat1;
* print mat1;

nrecords = nrow(mat1); *print nrecords; *N = 191;

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
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many year1? (3);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many year2? (43);

* variables same each year: aspect, bcat1, elev, hydrn, plot, slope, soileb, 
  variables change each year: _FREQ_, covm, mhgt, prpo, year, milvox, mpitax, mqumax,
								mquma3;

*year, prpo, plot, bcat,  aspect, hydr, soileb, _FREQ_, ilvo, pita, quma3, qumax, 
	mcov, elev, slope, mhgt	;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,3];   * plot;
  mat2[i,6] = mat1[i,4];   * bcat1;
  mat2[i,7] = mat1[i,5];   * aspect;
  mat2[i,8] = mat1[i,6];   * hydrn;
  mat2[i,9] = mat1[i,7];   * soileb;
  mat2[i,10] = mat1[i,14];  * elev;
  mat2[i,11] = mat1[i,15];  * slope;
  mat2[i,12] = mat1[i,9];  * milvo1;
  mat2[i,14] = mat1[i,10]; * mpita1;
  mat2[i,16] = mat1[i,11]; * mqum31;
  mat2[i,18] = mat1[i,12]; * mqumx1;
  mat2[i,20] = mat1[i,13]; * covm1;
  mat2[i,22] = mat1[i,16]; * mhgt1;
  mat2[i,24] = mat1[i,8];  * _FREQ_1;
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
	  mat2[i,25] = mat2[j,24]; * _FREQ_2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'year1', 'year2', 'plot', 'bcat1', 'aspect', 'hydr', 'soil', 'elev', 
			'slope', 'ilvo1', 'ilvo2', 'pita1', 'pita2', 'boak1', 'boak2', 'poak1', 'poak2', 
			'covm1', 'covm2', 'mhgt1', 'mhgt2', 'freq1', 'freq2'};
create seedpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

proc print data=seedpairs; title 'seedpairs';
run;

proc glm data=seedpairs; title 'seedpairs glm';  * N = 15 because only 15 plots have pre/post combos; 
	class bcat1;
	model pita2 = covm2 covm2*pita1;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat coun2; run;

proc glm data=post; title 'post';  
	class bcat1;
	model coun2 = covm2 covm2*coun1;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat coun2; run;


proc glimmix data=oakpairsprpo; title 'oakpairsprpo glimmix';
  class plot bcat1;
  model coun2 = bcat1 coun1 coun1*bcat1 / distribution=poisson DDFM = KR; *removed DDFM=KR;
  random plot(bcat1);
  output out=glmout2 resid=ehat;
run; 
