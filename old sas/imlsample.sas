* imlsample.sas;
/*
proc import datafile="g:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\cc.csv"
out=canopy dbms=csv replace; getnames=yes;
run;  
proc sort data = canopy; by plot year; run;

* canopy cover calculations;
data canopy2; set canopy;
	*removing plots 1242 and 1244-1247. These plots are not in BSP;
	if (plot = '1242' | plot = '1244' | plot = '1245' | plot = '1246' | plot = '1247') then delete;
	*averaging measurements at each location;
	qua1 = ((qu1a + qu1b + qu1c + qu1d) / 4);
	qua2 = ((qu2a + qu2b + qu2c + qu2d) / 4);
	qua3 = ((qu3a + qu3b + qu3c + qu3d) / 4);
	qua4 = ((qu4a + qu4b + qu4c + qu4d) / 4);
	orim = ((oria + orib + oric + orid) / 4);
	*conversion factor;
	fact = (100/96);
	*converting to canopy cover from canopy openness;
	cov1 = -((qua1 * fact) - 100);
	cov2 = -((qua2 * fact) - 100);
	cov3 = -((qua3 * fact) - 100);
	cov4 = -((qua4 * fact) - 100);
	orig = -((orim * fact) - 100);
	*getting mean canopy cover per plot;
	covm = ((cov1 + cov2 + cov3 + cov4 + orig)/5);
run;
data canopy3 (keep = year plot covm); set canopy2;
proc sort data=canopy3; by plot year; run; 

*----------------------------------------- TREES --------------------------------------------------;
*******SEEDLINGS (INCLUDES RESPROUTS AND FFI 'SEEDLINGS', DBH < 2.5);

proc import datafile="g:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedlings-allyrs.csv"
out=seedlings dbms=csv replace; getnames=yes;
run;  * N = 1285;

* cleanup;
data seedlings1; set seedlings;
 	year = year(date);
	subp = 'seed';
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set seedlings1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;

data seedlings2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp) 
				 rename=(SizeClHt=heig) rename=(Status=stat) 
				 rename=(Count=coun));
	set dat2;
data seedlings3 (keep=plot year sspp heig coun stat subp); set seedlings2; run;
proc sort data = seedlings3; by plot year; run;
*merging with canopy cover;
data seedlings3x; merge seedlings3 canopy3; by plot year; 
run;  *N=1079;

proc print data=seedlings3x; title 'seedlings3x'; run;	
*/

* EXAMPLE;
title 'iml example';
data oak; set alld; 
  if sspp = 'QUMAx';
  if subp = 'seed';
  keep plot burn coun year covm heig; 
run; * N = 186;
proc sort data=oak; by year plot burn;

proc means data=oak mean noprint; by year plot burn;
  var coun covm heig;
  output out=oak1 mean = mcoun covm mhgt;
* proc print data=oak1; title 'oakx';
run;
data oak2; set oak1; keep year plot burn mcoun covm mhgt; 
*proc print data=oak2; run;

proc iml;

inputyrs = {1999, 2002, 2003, 2005, 2006, 2010, 2012, 2013, 2014};
nyrs = nrow(inputyrs);  * print nyrs; *9 yrs;

use oak2; read all into mat1;
* print mat1;
 
nrecords = nrow(mat1); *print nrecords;

mat2 = j(nrecords,12,.);  * create mat2 has 95 rows, 11 columns, each element=0;
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

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  firstyr = mat2[i,1];
  secondyr = firstyr+1;
  mat2[i,2] = secondyr;
  mat2[i,3] = mat1[i,1];   * year1;
  mat2[i,5] = mat1[i,2];   * plot;
  mat2[i,6] = mat1[i,3];   * variable burn;
  mat2[i,7] = mat1[i,4];   * variable coun1;
  mat2[i,8] = mat1[i,5];   * variable covm1;
  mat2[i,9] = mat1[i,6];   * variable hgt1;
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
