proc sort data=alld; by year plot burn sspp aspect hydr soil subp; run; *N=59195;
data oak; set alld; 
  if sspp = 'QUMAx';
  if subp = 'seed';
  keep plot burn coun year covm heig;  coun covm crwn diam elev heig slope year plot burn aspect hydr soil subp
run; * N = 186;
proc sort data=oak; by year plot burn;

proc means data=oak mean noprint; by year plot burn;
  var coun covm heig;
  output out=oak1 mean = mcoun covm mhgt;
* proc print data=oak1; title 'oakx';
run;
data oak2; set oak1; keep year plot burn mcoun covm mhgt; 
*proc print data=oak2; run;



proc means data=alld mean noprint; by year plot burn sspp aspect hydr soil subp;
  var coun covm crwn diam elev heig slope;
  output out=alld1 mean = mcoun covm mcrwn mdbh elev mhgt slope;
* proc print data=alld1 (firstobs=9000 obs=9093); title 'alld1';
run; *N=9093;
/*
proc contents data=alld1; run;
 					   #    Variable    Type    Len    Format     Informat
                      10    _FREQ_      Num       8
                       9    _TYPE_      Num       8
                       5    aspect      Char      4
                       3    burn        Num       8
                      12    covm        Num       8
                      15    elev        Num       8    BEST12.    BEST32.
                       6    hydr        Char      1    $1.        $1.
                      11    mcoun       Num       8    BEST12.    BEST32.
                      13    mcrwn       Num       8    BEST12.    BEST32.
                      14    mdbh        Num       8    BEST12.    BEST32.
                      16    mhgt        Num       8    BEST12.    BEST32.
                       2    plot        Num       8    BEST12.    BEST32.
                      17    slope       Num       8    BEST12.    BEST32.
                       7    soil        Char      4
                       4    sspp        Char      5
                       8    subp        Char      4
                       1    year        Num       8    BEST12.    BEST32.


*/

proc iml;

inputyrs = {1999, 2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use alld1; read all into mat1;
* print mat1;

nrecords = nrow(mat1); *print nrecords; *N = 9093;

mat2 = j(nrecords,21,.); * create mat2 has 9093 rows, 21 columns, each element=0;
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
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many in 1st yr?;
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many in last yr?;

* variables same each year: aspect, burn, elev, hydr, plot, slope, soil, sspp, subp
  variables change each year: covm, mcoun, mcrwn, mdbh, mhgt, year;

 						   COL1=yr   COL2/pl   COL3/brn   COL4/sp   COL5/asp  COL6 /hyd

              ROW9092      2014      5300         4         0         7         .
              ROW9093      2014      5300         4         0         1         .

                                             mat1
                           COL7soil      COL8      COL9     COL10     COL11     COL12

              ROW9092     11.25         .         .       162         .         0
              ROW9093     11.25         .         0       162         .         0


* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  firstyr = mat2[i,1];
  secondyr = firstyr+1;
  mat2[i,2] = secondyr;
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * variable burn;
  mat2[i,3] = mat1[i,1];   * hydr;
  mat2[i,5] = mat1[i,2];   * aspect;
  mat2[i,3] = mat1[i,1];   * elev;
  mat2[i,5] = mat1[i,2];   * slope;
  mat2[i,5] = mat1[i,2];   * soil;
  mat2[i,3] = mat1[i,1];   * sspp;
  mat2[i,5] = mat1[i,2];   * subp;
  mat2[i,7] = mat1[i,4];   * variable coun1;
  mat2[i,8] = mat1[i,5];   * variable covm1;
  mat2[i,9] = mat1[i,6];   * variable hgt1;
  mat2[i,8] = mat1[i,5];   * variable crwn1;
  mat2[i,9] = mat1[i,6];   * variable dbh1;

end;
* print mat2;
do i = 1 to nrecords;
  plot = mat2[i,5]; secondyr = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = secondyr) then do;
	  *print i,j;
	  mat2[i,4]  = mat2[j,3];    * variable year2;
	  mat2[i,10] = mat2[j,7];    * variable count2;
	  mat2[i,11] = mat2[j,8];    * variable covm2;
	  mat2[i,12] = mat2[j,9];	 * variable hgt2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;
*Problem with years--years 1-9 are fixed. If a plot was skipped one year, the continuity is broken;

cnames1 = {'yr1', 'yr2', 'year1', 'year2', 'plot', 'burn', 'count1', 'cov1', 'hgt1', 'count2', 'cov2', 'hgt2'};
create oakpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

proc print data=oakpairs; title 'oakpairs';
run;

proc glm data=oakpairs;	title 'oakpairs glm';  * N = 128 because 2010 & 2011 dropped; 
	class burn;
	model count2 = count1 burn count1*burn;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat count2; run;

proc glimmix data=oakpairs; title 'oakpairs glimmix';
  class plot burn;
  model count2 = count1 cov1/ distribution=normal; *removed interaction term;
  random plot(burn);
  output out=glmout2 resid=ehat;
run;
