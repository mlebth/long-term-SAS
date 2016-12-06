*--------------------------------------- herbaceous -----------------------------------------------------;
*What do I want to find? 
	percent bare -- sort by treatment type
	species richness
	abundances of each species;
proc import datafile="h:\Research\2013 Spring\data2012excel.xls"
out=herb (keep=plot hydromulch burnsev date hgt point spp count)
dbms=excel replace; sheet=herbaceous;
getnames=yes;
run;
proc contents data=herb; run;
proc print data=herb; title 'herbaceous'; run;  * N = 4384 observations;
* herbaceous data in this file;
* variables: 
   plot = fmh code
   hydromulch (n,l,y)
   burnsev (u,s,l,m,h)
   date = date data was collected (ddmonyy)
   hgt = height of tallest plant (cm)
   point = point on transect tape (m)
   spp = species code
   count = number of plants at each point of each species. always = 1;;

proc sort data=herb; by hydromulch burnsev plot spp;
proc print data=herb; title 'by species'; run;
proc freq data=herb; tables spp; run;

data sptest; set herb; if spp = 'trit' then pt=1; else pt=0;

data herbred; set herb;
if (spp NE 'bare' & spp NE 'trit' & spp NE 'ledu');

* dataset with number of species (including bare) per plot;
proc means data=herbred noprint n; by hydromulch burnsev plot spp; * pooling points;
	output out=herb2 n=n; run;  * # records/species/plot;
	proc print data=herb2; title 'herb2'; run; * N = 200 species-plot combinations, 26 plots;
	proc contents data=herb2; title 'herb2'; run;

*---- # of obs of each plot -------------------;
proc sort data=herb2; by hydromulch burnsev plot ;
proc means data=herb2 noprint n; by hydromulch burnsev plot ;
  output out=herb3 n=n;
data herb4; set herb3; spnum = n; 
proc print data=herb4; title 'herb4'; 
run;
* review the design;
* proc freq data=herb4; * tables burnsev*hydromulch; * run;

proc univariate data=herb4 normal plot; title 'herb4'; 
run;
*(spnum): Skewness = 0.8373, kurtosis = -0.0164. Shapiro-Wilk: W=0.8883, p = 0.0087;

* ---- analyze only plots without mulch, with pooling;
data nomulchherb; set herb4; if hydromulch = 'n';  * N = 15 plots;
proc print data=nomulchherb; title 'nomulchherb';
run;

data nomulchherb1; set nomulchherb;
  if (burnsev='u'|burnsev='s') then burn='L1';
  if (burnsev='l') then burn='L2';
  if (burnsev='m') then burn='L3';
  if (burnsev='h') then burn='L4';

 proc genmod data=nomulchherb1; class burn;
  model spnum = burn / dist = poisson link=log type1 type3; title 'no mulch pooled poisson';
run;
* burnsev NS: df= 3 X2 = 3.07 P = 0.3807 
BUT X2/DF > 1 (1.85)....use negative binomial distribution;

proc genmod data=nomulchherb1; class burn;
  model spnum = burn / dist = negbin link=log type1 type3; title 'no mulch pooled negbin';
run;
* burnsev NS: df= 3 X2 = 2.13  P = 0.545
X2/DF = 1.24.... better;

* ---- analyze only burned plots ------;
data allburn; set herb4;
  if (burnsev='l'|burnsev='m'|burnsev='h'); * N = 19;
proc print data=allburn; title 'allburn';
run;

proc genmod data=allburn; class burnsev hydromulch;
  model spnum = burnsev hydromulch / dist = poisson link=log type1 type3; title 'all burn poisson';
run;
*Value/DF =1.3169....use negative binomial distribution;

proc genmod data=allburn; class burnsev hydromulch;
  model spnum = burnsev hydromulch / dist = negbin link=log type1 type3; title 'all burn negbin';
run;
*Value/DF =1.2615--not much different;
* type 1
  burnsev df= 2 X2= 0.23 P = 0.8898 hydromulch df= 2 X2 = 0.49 P = 0.7831
  hydromulch df= 2 X2= 0.46 P = 0.7955 burnsev df= 2 X2= 0.26 P = 0.8760
* type 3  
  burnsev df= 2, X2 = 0.26 P = 0.8760
  hydromulch df= 2 X2 = 0.49  P = 0.7831;


