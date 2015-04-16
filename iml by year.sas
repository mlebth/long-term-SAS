data oak; set piquil; 	
	if sspp = "QUMAx";
 	keep aspect burn coun covm elev heig hydrn plot prpo slope soiln year;
run;  * N = 181;
*proc contents data=oak; 
proc sort data=oak; by prpo year plot burn aspect hydrn soiln; run;
/* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                      10    aspect      Num       8
                      11    burn        Num       8
                       3    coun        Num       8    BEST12.    BEST32.
                       5    covm        Num       8
                       6    elev        Num       8    BEST12.    BEST32.
                       2    heig        Num       8    BEST12.    BEST32.
                       8    hydrn       Num       8
                       1    plot        Num       8    BEST12.    BEST32.
                      12    prpo        Num       8
                       7    slope       Num       8    BEST12.    BEST32.
                       9    soiln       Num       8
                       4    year        Num       8    BEST12.    BEST32
*/

proc means data=oak mean noprint; by year plot burn aspect hydrn soiln;
  var coun covm elev slope heig;
  output out=oak1 mean = mcoun mcov elev slope mhgt;
run;
data oak2; set oak1; drop _TYPE_; 
*proc print data=oak2; title 'oak2'; run;


proc iml;

inputyrs = {1999, 2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use oak2; read all into mat1;
* print mat1;

nrecords = nrow(mat1); *print nrecords; *N = 95;

mat2 = j(nrecords,19,.); * create mat2 has 95 rows, 19 columns, each element=0;
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
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many year2? (18);

* variables same each year: aspect, burn, elev, hydrn, plot, slope, soiln, 
  variables change each year: _FREQ_, covm, mhgt, prpo, 

prpo, plot, burn, aspect, hydrn, soiln, freq, covm, elev, mght, slope
;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * burn;
  mat2[i,7] = mat1[i,4];   * aspect;
  mat2[i,8] = mat1[i,5];   * hydrn;
  mat2[i,9] = mat1[i,6];   * soiln;
  mat2[i,10] = mat1[i,10];  * elev;
  mat2[i,11] = mat1[i,11];  * slope;
  mat2[i,12] = mat1[i,8];  * coun1;
  mat2[i,14] = mat1[i,9];  * covm1;
  mat2[i,16] = mat1[i,12]; * mhgt1;
  mat2[i,18] = mat1[i,7];  * _FREQ_1;
end;
* print mat2;

do i = 1 to nrecords;
  plot = mat2[i,5]; time2 = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = time2) then do;
	  *print i,j;
	  mat2[i,4]  = mat2[j,3]; * year2;
  	  mat2[i,13] = mat2[j,12]; * coun2;
	  mat2[i,15] = mat2[j,14]; * covm2;
	  mat2[i,17] = mat2[j,16]; * mhgt2;
	  mat2[i,19] = mat2[j,18]; * _FREQ_2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'year1', 'year2', 'plot', 'burn', 'aspect', 'hydr', 'soil', 'elev', 
			'slope', 'coun1', 'coun2', 'covm1', 'covm2', 'mhgt1', 'mhgt2', 'freq1', 'freq2'
};
create oakpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

proc print data=oakpairs; title 'oakpairs';
run;

proc glm data=oakpairs; title 'oakpairs glm';  * N = 26 because only 26 plots have pre/post combos; 
	class burn;
	model coun2 = covm2 covm2*coun1;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat coun2; run;

proc glimmix data=oakpairs; title 'oakpairs glimmix';
  class plot burn;
  model coun2 = soil soil*coun1 / distribution=poisson; 
  random plot(burn);
  output out=glmout2 resid=ehat;
run;

proc glimmix data=oakpairs; title 'oakpairs glimmix';
  class plot burn;
  model coun2 = soil soil*coun1/ distribution=poisson; *removed interaction term;
  random plot(burn);
  output out=glmout2 resid=ehat;
run;
