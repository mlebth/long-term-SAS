proc sort data=alld; by year plot burn sspp aspect hydrn soiln subp; run; *N=59195;
data sandpost; set alld; 
  if sspp = 'QUMAx';
  if subp = 'seed';
  keep plot burn coun year covm heig crwn diam elev slope aspect hydrn soiln subp;
run; * N = 181;
proc sort data=sandpost; by year plot burn aspect hydrn soiln subp; run;

proc means data=sandpost mean noprint; by year plot burn aspect hydrn soiln subp;	
  var coun covm crwn diam elev heig slope; 
  output out=sandpost1 mean = mcoun covm mcrwn mdbh elev mhgt slope;
* proc print data=sandpost1; title 'sandpost1';
run; *N=95;
data sandpost2; set sandpost1; drop _TYPE_; run;

/*
proc contents data=sandpost2; run;
 					   #    Variable    Type    Len    Format     Informat
                       9    _FREQ_      Num       8
                       8    _TYPE_      Num       8
                       4    aspect      Char      4
                       3    burn        Num       8
                      11    covm        Num       8
                      14    elev        Num       8    BEST12.    BEST32.
                       5    hydrn       Num       8
                      10    mcoun       Num       8    BEST12.    BEST32.
                      12    mcrwn       Num       8    BEST12.    BEST32.
                      13    mdbh        Num       8    BEST12.    BEST32.
                      15    mhgt        Num       8    BEST12.    BEST32.
                       2    plot        Num       8    BEST12.    BEST32.
                      16    slope       Num       8    BEST12.    BEST32.
                       6    soiln       Num       8
                       7    subp        Char      4
                       1    year        Num       8    BEST12.    BEST32.

*/

proc iml;

inputyrs = {1999, 2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use sandpost2; read all into mat1;
* print mat1;

nrecords = nrow(mat1); *print nrecords; *N = 95;

mat2 = j(nrecords,22,.); * create mat2 has 95 rows, 21 columns, each element=0;
do i = 1 to nrecords;    * record by record loop;
  do j = 1 to nyrs;      * yr by yr loop;
    if (mat1[i,1] = inputyrs[j]) then mat2[i,1] = j;  * yr1 in col 1;
  end;                   * end yr by yr loop;
end;                     * end yr by yr loop;
* print mat2;

mattemp = j(nrecords,2,0);
do i = 1 to nrecords;
  if mat2[i,1] = 1     then mattemp[i,1] = 1;
  if mat2[i,1] = nyrs  then mattemp[i,2] = 1;
end;
* print mattemp;
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many in 1st yr? (7);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many in last yr? (18);

* variables same each year: burn, elev, hydr, plot, slope, soil, sspp, subp,
  variables change each year: covm, mcoun, mcrwn, mdbh, mhgt, year , freq

year, plot, burn, hydrn, soiln, freq, mcoun, covm, mcrwn, mdbh, elev, mhgt, slope
;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  firstyr = mat2[i,1];
  secondyr = firstyr+1;
  mat2[i,2] = secondyr;	
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * burn;
  mat2[i,7] = mat1[i,4];   * hydrn;
  mat2[i,8] = mat1[i,5];   * soiln;
  mat2[i,9] = mat1[i,11];  * elev;
  mat2[i,10] = mat1[i,13];  * slope;
  mat2[i,11] = mat1[i,8];   * covm1;
  mat2[i,13] = mat1[i,9];   * mcrwn1;
  mat2[i,15] = mat1[i,10];  * mdbh1;
  mat2[i,17] = mat1[i,7];   * mcoun1;
  mat2[i,19] = mat1[i,12];  * mhgt1;
  mat2[i,21] = mat1[i,6];   * _FREQ_1;
end;
* print mat2;

do i = 1 to nrecords;
  plot = mat2[i,5]; secondyr = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = secondyr) then do;
	  *print i,j;
	  mat2[i,4]  = mat2[j,3];    * variable year2;
	  mat2[i,12] = mat2[j,11];   * variable covm2;
	  mat2[i,14] = mat2[j,13];   * variable mcrwn2;
	  mat2[i,16] = mat2[j,15];	 * variable mdbh2;
	  mat2[i,18] = mat2[j,17];	 * variable mcoun2;
	  mat2[i,20] = mat2[j,19];	 * variable mhgt2;
	  mat2[i,22] = mat2[j,21];	 * variable _FREQ_2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;
*Problem with years--years 1-11 are fixed. If a plot was skipped one year, the continuity is broken;

cnames1 = {'yr1', 'yr2', 'year1', 'year2', 'plot', 'burn', 'hydrn', 'soiln', 'elev', 'slope', 
			'covm1', 'covm2', 'mcrwn1', 'mcrwn2', 'mdbh1', 'mdbh2', 'mcoun1', 'mcoun2',
 			'mhgt1', 'mhgt2', '_FREQ_1', '_FREQ_2'};
create oakpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

proc print data=oakpairs; title 'oakpairs';
run;

proc glm data=oakpairs;	title 'oakpairs glm';  * N = 128 because 2010 & 2011 dropped; 
	class burn;
	model mcoun2 = mcoun1 burn mcoun1*burn;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat mcoun2; run;

proc glimmix data=oakpairs; title 'oakpairs glimmix';
  class plot burn;
  model count2 = count1 cov1/ distribution=normal; *removed interaction term;
  random plot(burn);
  output out=glmout2 resid=ehat;
run;
