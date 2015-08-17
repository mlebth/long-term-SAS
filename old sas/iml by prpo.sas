/* 
*using prpo and piquil w/ n&pa reorg--didn't work;

proc sort data=piquil2; by year plot burn aspect hydrn soilt; run; *N=473;

proc means data=piquil2 mean noprint; by year plot burn aspect hydrn soilt;	
  var covm elev heig slope nquma3 nqumax npitax nilvox paquma3 paqumax papitax pailvox; 
  output out=piquil3 mean = covm elev mhgt slope mquma3 mqumax mpitax milvox mpaquma3 mpaqumax mpapitax mpailvox;
* proc print data=piquil3; title 'piquil3';
run; *N=83;
data piquil4; set piquil3; drop _TYPE_; run;

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
                       6    soilt       Num       8
*/

data oak; set piquil; 	
	if sspp="QUMAx";
 	keep aspect bcat1 coun covm elev heig hydrn plot year prpo slope soilt soile soileb;
run;  * N = 181;
*proc contents data=oak; run;
proc sort data=oak; by year prpo plot bcat1 aspect hydrn soilt soile soileb; run;
proc freq data=oak; tables soilt soile soileb; run;
/* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                      10    aspect      Num       8
                      11    bcat1       Num       8
                       3    coun        Num       8    BEST12.    BEST32.
                       5    covm        Num       8
                       6    elev        Num       8    BEST12.    BEST32.
                       2    heig        Num       8    BEST12.    BEST32.
                       8    hydrn       Num       8
                       1    plot        Num       8    BEST12.    BEST32.
                      12    prpo        Num       8
                       7    slope       Num       8    BEST12.    BEST32.
                       9    soilt       Num       8
                       4    year        Num       8    BEST12.    BEST32
*/

proc means data=oak mean noprint; by year prpo plot bcat1 aspect hydrn soileb;
  var coun covm elev slope heig;
  output out=oak1 mean = mcoun mcov elev slope mhgt;
run;
data oak2; set oak1; drop _TYPE_; 
*proc print data=oak2; title 'oak2'; run;

/* data oak3; set oak2; if year >2011; run;
proc plot data=oak3; plot mcoun*mcov; run;
proc glm data=oak2; title 'post';  
	model mcoun = year;
	output out=glmout2 r=ehat;
run; */

proc iml;

inputyrs = {1,2};
nyrs = nrow(inputyrs);  * print nyrs; *2 yrs;

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
nyr1obs = sum(mattemp[,1]); *print nyr1obs;  * how many year1? (23);
nyr2obs = sum(mattemp[,2]); *print nyr2obs;  * how many year2? (23);

* variables same each year: aspect, bcat1, elev, hydrn, plot, slope, soilt, 
  variables change each year: _FREQ_, covm, mhgt, prpo, 

prpo, plot, bcat1, aspect, hydrn, soilt, freq, covm, elev, mght, slope
;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,1];   * pre-fire;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * bcat1;
  mat2[i,7] = mat1[i,4];   * aspect;
  mat2[i,8] = mat1[i,5];   * hydrn;
  mat2[i,9] = mat1[i,6];   * soilt;
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
	  mat2[i,4]  = mat2[j,3]; * post-fire;
  	  mat2[i,13] = mat2[j,12]; * coun2;
	  mat2[i,15] = mat2[j,14]; * covm2;
	  mat2[i,17] = mat2[j,16]; * mhgt2;
	  mat2[i,19] = mat2[j,18]; * _FREQ_2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print mat2;

cnames1 = {'time1', 'time2', 'pref', 'post', 'plot', 'bcat1', 'aspect', 'hydr', 'soil', 'elev', 
			'slope', 'coun1', 'coun2', 'covm1', 'covm2', 'mhgt1', 'mhgt2', 'freq1', 'freq2'
};
create oakpairsprpo from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

proc print data=oakpairsprpo; title 'oakpairsprpo';
run;

proc glm data=oakpairsprpo; title 'oakpairsprpo glm';  * N = 15 because only 15 plots have pre/post combos; 
	class bcat1;
	model coun2 = covm2 covm2*coun1;
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
