proc sort data=piquil2; by prpo plot burn aspect hydrn soiln; run; *N=473;

proc means data=piquil2 mean noprint; by prpo plot burn aspect hydrn soiln;	
  var covm elev heig slope nquma3 nqumax npitax nilvox paquma3 paqumax papitax pailvox; 
  output out=piquil3 mean = covm elev mhgt slope mquma3 mqumax mpitax milvox mpaquma3 mpaqumax mpapitax mpailvox;
* proc print data=piquil3; title 'piquil3';
run; *N=83;
data piquil4; set piquil3; drop _TYPE_; run;

/*
proc print data=piquil4; run;
proc contents data=piquil4; run;
 					   #    Variable    Type    Len    Format     Informat
         			   7    _FREQ_      Num       8
                       4    aspect      Num       4
                       3    burn        Num       8
                       8    covm        Num       8
                       9    elev        Num       8    BEST12.    BEST32.
                       5    hydrn       Num       8
                      10    mhgt        Num       8    BEST12.    BEST32.
                      15    milvox      Num       8
                      19    mpailvox    Num       8
                      18    mpapitax    Num       8
                      16    mpaquma3    Num       8
                      17    mpaqumax    Num       8
                      14    mpitax      Num       8
                      12    mquma3      Num       8
                      13    mqumax      Num       8
                       2    plot        Num       8    BEST12.    BEST32.
                       1    prpo        Num       8
                      11    slope       Num       8    BEST12.    BEST32.
                       6    soiln       Num       8
*/

proc iml;

inputyrs = {1,2};
nyrs = nrow(inputyrs);  * print nyrs; *2 yrs;

use piquil4; read all into mat1;
* print mat1;

nrecords = nrow(mat1); *print nrecords; *N = 83;

mat2 = j(nrecords,31,.); * create mat2 has 83 rows, 31 columns, each element=0;
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
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many pre-fire? (39);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many post-fire? (44);

* variables same each year: aspect, burn, elev, hydrn, plot, slope, soiln, 
  variables change each year: _FREQ_, covm, mhgt, milvox, mpailvox, mpapitax, mpaquma3, mpaqumax, 
	mpitax,	mquma3, mqumax, prpo, 

prpo, plot, burn, aspect, hydrn, soiln, freq, covm, elev, mght, slope, mquma3, mqumax, mpitax, 
	milvox, mpaquma3, mpaqumax, mpapitax, mpailvox
;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,2];   * plot;
  mat2[i,4] = mat1[i,3];   * burn;
  mat2[i,5] = mat1[i,4];   * aspect;
  mat2[i,6] = mat1[i,5];   * hydrn;
  mat2[i,7] = mat1[i,6];   * soiln;
  mat2[i,8] = mat1[i,9];   * elev;
  mat2[i,9] = mat1[i,11];  * slope;
  mat2[i,10] = mat1[i,8];  * covm1;
  mat2[i,12] = mat1[i,10]; * mhgt1;
  mat2[i,14] = mat1[i,12]; * mquma3;
  mat2[i,16] = mat1[i,13]; * mqumax;
  mat2[i,18] = mat1[i,14]; * mpitax;
  mat2[i,20] = mat1[i,15]; * milvox;
  mat2[i,22] = mat1[i,16]; * mpaquma3;
  mat2[i,24] = mat1[i,17]; * mpaqumax;
  mat2[i,26] = mat1[i,18]; * mpapitax;
  mat2[i,28] = mat1[i,19]; * mpailvox; 
  mat2[i,30] = mat1[i,7];  * _FREQ_1;
end;
* print mat2;

do i = 1 to nrecords;
  plot = mat2[i,3]; time2 = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,3] = plot & mat2[j,1] = time2) then do;
	  *print i,j;
	  mat2[i,11] = mat2[j,10]; * covm2;
	  mat2[i,13] = mat2[j,12]; * mhgt2;
	  mat2[i,15] = mat2[i,14]; * mquma3;
	  mat2[i,17] = mat2[i,16]; * mqumax;
  	  mat2[i,19] = mat2[i,18]; * mpitax;
  	  mat2[i,21] = mat2[i,20]; * milvox;
  	  mat2[i,23] = mat2[i,22]; * mpaquma3;
  	  mat2[i,25] = mat2[i,24]; * mpaqumax;
  	  mat2[i,27] = mat2[i,26]; * mpapitax;
  	  mat2[i,29] = mat2[i,28]; * mpailvox;
	  mat2[i,31] = mat2[j,30]; * _FREQ_2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'plot', 'burn', 'aspect', 'hydrn', 'soiln', 'elev', 'slope', 
			'covm1', 'covm2', 'mhgt1', 'mhgt2', 'nquma31', 'nquma32', 'nqumax1', 'nqumax2', 
			'npita1', 'npita2', 'nilvo1', 'nilvo2', 'paquma31', 'paquma32', 'paqumax1', 'paqumax2',
			'papita1', 'papita2', 'pailvo1', 'pailvo2', 'freq1', 'freq2'
};
create seedpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

proc print data=seedpairs; title 'seedpairs';
run;
proc freq data=seedpairs; tables plot*time1; run;

proc glm data=seedpairs; title 'seedpairs glm';  * N = 30 because only 30 plots have pre/post combos; 
	class burn;
	model npita2 = burn npita1*burn;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat npita2; run;

proc glimmix data=seedpairs; title 'seedpairs glimmix';
  class plot burn;
  model npita2 = npita1 covm1/ distribution=normal; *removed interaction term;
  random plot(burn);
  output out=glmout2 resid=ehat;
run;
