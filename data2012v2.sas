OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";
*--------------------------------------- seedlings -----------------------------------------------------;
proc import datafile="F:\Research\2013 Spring\data2012excel.xls"
out=seed
dbms=excel replace; sheet=seedlings;
getnames=yes;
run;
proc contents data=seed; run;
proc print data=seed; run;  * N = 42;
* tree data in this file;
* variables: 
   burnsev (u,s,l,m,h)
   hgt (seedling
   hydromulch (n,l,h)
   num = number of seedlings
   plot = fmh code
   rspt (n,y) resprout?
   spp (quma, pita, x = no tree seedlings);

*---- # of obs of each plot -------------------;
proc sort data=seed; by hydromulch burnsev plot;
proc means data=seed noprint n; by hydromulch burnsev plot;
  output out=mout1 n=n;
proc print data=mout1; title 'mout1'; * N = 25 plots;
run;

*---- subset the data by species and reorg-------------;
proc sort data=seed; by plot;

data pita; set seed; if spp="pita"; 
  if hgt=1 then npita1 = num; if hgt=2 then npita2 = num;
  if hgt=3 then npita3 = num; if hgt=4 then npita4 = num;
  if hgt=5 then npita5 = num; 
proc print data=pita; title 'pita';  * N = 19 obs;
run;
proc means data=pita sum noprint; by plot burnsev hydromulch; 
 var npita1-npita5;
 output out=pita2 sum = spita1-spita5;
proc print data=pita2; title 'pita2';  * N = 12 non-zero plots;
run;
proc freq data=pita2; tables burnsev*hydromulch;
run;

data quma; set seed; if spp="quma"; 
  if hgt=1 then nquma1 = num; if hgt=2 then nquma2 = num;
  if hgt=3 then nquma3 = num; if hgt=4 then nquma4 = num;
  if hgt=5 then nquma5 = num; 
proc print data=quma; title 'quma';  * N = 19 obs;
run;
proc means data=quma sum noprint; by plot burnsev hydromulch; 
 var nquma1-nquma5;
 output out=quma2 sum = squma1-squma5;
proc print data=quma2; title 'quma2';  * N = 13 plots;
run;
proc freq data=quma2; tables burnsev*hydromulch;
run;

data empty; set seed; if spp="x";
 holder = 0; * N = 5;
proc print data=empty; title 'empty';
run;

data datreorg; merge pita2 quma2 empty; by plot;
  drop num hgt;
proc print data=datreorg; title 'datreorg';
run;

*---- analysis of total number --------------;
data dattotn; set datreorg;
  if (spita1=.) then spita1=0; if (spita2=.) then spita2=0; 
  if (spita3=.) then spita3=0; if (spita4=.) then spita4=0; 
  if (spita5=.) then spita5=0; 
  if (squma1=.) then squma1=0; if (squma2=.) then squma2=0; 
  if (squma3=.) then squma3=0; if (squma4=.) then squma4=0; 
  if (squma5=.) then squma5=0;
  totpita = spita1 + spita2 + spita3 + spita4 + spita5;
  totquma = squma1 + squma2 + squma3 + squma4 + squma5;


* --- analyze only plots without mulch, no pooling----;
data nomulch; set dattotn; if hydromulch = 'n';  * N = 14;
proc print data=nomulch; title 'nomulch';
run;
* pita - ols;
proc glm data=nomulch; class burnsev;
  model totpita = burnsev;
  output out=gout1 r=ehat;
proc univariate data=gout1 normal plot; var ehat;
run;
* pita - genmod;
proc genmod data=nomulch; class burnsev;
  model totpita = burnsev/ dist = negbin link=log type1 type3;
run;
* dispersion =  2.2050; 
* burnsev  df=4, X2 = 9.85, P = 0.0430;  * df issues!;
* quma - genmod;
proc genmod data=nomulch; class burnsev;
  model totquma = burnsev/ dist = negbin link=log type1 type3;
run; * NS;

* ---- analyze only plots without mulch, with pooling;
data nomulchpool; set nomulch;
  if (burnsev='u'|burnsev='s') then burn='L1';
  if (burnsev='l') then burn='L2';
*  if (burnsev='m'|burnsev='h') then burn='L3'; * not used;
  if (burnsev='m') then burn='L3';
  if (burnsev='h') then burn='L4';

* pita - genmod;
proc genmod data=nomulchpool; class burn;
  model totpita = burn/ dist = negbin link=log type1 type3;
run;
* dispersion =  2.7647;
* burn df=3 X2 = 7.17  P = 0.0666;

proc genmod data=nomulchpool; class burn;
  model totquma = burn/ dist = negbin link=log type1 type3;
run; * NS;


* ---- analyze only burned plots ------;
data allburn; set dattotn;
  if (burnsev='l'|burnsev='m'|burnsev='h'); * N = 19;
proc print data=allburn; title 'allburn';
run;
* pita;
proc genmod data=allburn; class burnsev hydromulch;
  model totpita = burnsev hydromulch / dist = negbin link=log type1 type3;
run;
* dispersion =  1.7247
  type 1
  burnsev df=2 X2=4.00 P = 0.1351 hydromulch df=2 X2 = 14.34 P = 0.0008
  hydromulch df=2 X2=7.32 P = 0.0257 burnsev df=2 X2=11.02 P = 0.0040
  type 3 - use these - order does not matter for type3 -  
  burnsev df=2, X2 = 11.02 P = 0.0040
  hydromulch df=2 X2 = 14.34  P = 0.0008;
proc genmod data=allburn; class burnsev hydromulch;
  model totpita =  hydromulch burnsev / dist = negbin link=log type1 type3;
run;

proc genmod data=allburn; class burnsev hydromulch;
  model totpita =  hydromulch burnsev hydromulch*burnsev/
     dist = negbin link=log type1 type3;
* interaction NS;
run;
* oak; 
proc genmod data=allburn; class burnsev hydromulch;
  model totquma = burnsev hydromulch / dist = poisson link=log type1 type3;
run;
* type 3 burnsev df=2 X2=3.71 P = 0.1567
         hydromulch  df=2  X2=10.91 P=0.0043;

proc genmod data=allburn; class burnsev hydromulch;
  model totquma = burnsev hydromulch  burnsev*hydromulch/ dist = poisson link=log type1 type3;
run;
* use this - note type 1 not type 3 - no type3 reported.
* type 1 burnsev df=2 X2=3.66 P = 0.1603
         hydromulch  df=2  X2=10.91 P=0.0043
         int df=3 X2=17.59 P = 0.0005;








*--------------------------------------- shrubs -----------------------------------------------------;

proc import datafile="F:\Research\2013 Spring\data2012excel.xls"
out=shrub0
dbms=excel replace; sheet=shrubs;
getnames=yes;
run;
proc contents data=shrub0; run;
proc print data=shrub0; title 'shrubdata'; run;  * N = 26;
* shrub data in this file;
* variables: 
   number of shrubs per plot from 0-30 on transect for species:
   caam, cevi, gavo, ilvo, ruri, smbo, topu
   plot = fmh code
   hydromulch (n,l,y)
   burnsev (u,s,l,m,h);
* for sigmaplot;
data shrub; set shrub0;
  * makes new set of treatment names with natural ordering for graphs and constrasts;
  if hydromulch = 'n' then hm = 1;
  if hydromulch = 'l' then hm = 2;
  if hydromulch = 'h' then hm = 3;
  if burnsev = 'u' then bs = 1;
  if burnsev = 's' then bs = 2;
  if burnsev = 'l' then bs = 3;
  if burnsev = 'm' then bs = 4;
  if burnsev = 'h' then bs = 5;
  * new variables pooling shrub species;
  allshrubnum = caam + cevi + gavo + ilvo + ruri + smbo + topu;
  allbutilex = caam + cevi + gavo + ruri + smbo + topu;
  * poolingA - combine only unburned and scorch;
  if (burnsev='u'|burnsev='s') then burn='AL1';
  if (burnsev='l') then burn='AL2';
  if (burnsev='m') then burn='AL3';
  if (burnsev='h') then burn='AL4'; 
  * poolingB - combine unburned + scorch, combine light, moderate, heavy burns;
  if (burnsev='u'|burnsev='s') then burn='BL1';
  if (burnsev='l'|burnsev='m'|burnsev='h') then burn='BL2'; 
run;

proc sort data=shrub; by bs hm;
proc means data=shrub noprint mean; by bs hm;
   var caam cevi gavo ilvo ruri smbo topu;
   output out=mout1 mean = mcaam mcevi mgavo milvo mruri msmbo mtopu;
proc print data=mout1; title 'mout1';
run;

* --- analyze only plots without mulch, no pooling (ilvo)----;
data nomulchshrub; set shrub; if hydromulch = 'n';  * N = 14;
proc print data=nomulchshrub; title 'nomulchshrubs';
run;
* ilvo - ols;
proc glm data=nomulchshrub; class burnsev;
  model ilvo = burnsev;
  output out=gout1 r=ehat;
proc univariate data=gout1 normal plot; title 'ilvo ols'; var ehat;
run;
*Skewness = 2.0981, kurtosis = 7.0373

* ilvo - genmod;
proc genmod data=nomulchshrub; class burnsev; title'ilvo genmod';
  model ilvo = burnsev/ dist = negbin link=log type1 type3;
run;
* dispersion =  1.2525; 
* burnsev  df=4, X2 = 4.25, P = 0.3737;  *NS;

* ---- analyze only plots without mulch, with pooling;
data nomulchpool; set nomulchshrub;


run;
* ilvo - genmod;
proc genmod data=nomulchpool; class burn;
  * model ilvo = burn/ dist = negbin link=log type1 type3;
  model allbutilex = burn/ dist = negbin link=log type1 type3;
run;
* dispersion =  1.2526;
* burn df=3 X2 = 4.25  P = 0.2361 *NS;

* ---- analyze only burned plots ------;
data allburn; set shrub;
  if (burnsev='l'|burnsev='m'|burnsev='h'); * N = 19;
proc print data=allburn; title 'allburn';
run;
* ilvo;
proc genmod data=allburn; class burnsev hydromulch;
  model ilvo = burnsev hydromulch / dist = negbin link=log type1 type3;
run;
* dispersion =  0.3458
  type 1
  burnsev df=2 X2=2.26 P = 0.3223 hydromulch df=2 X2 = 1.30 P = 0.5230 *NS
  hydromulch df=2 X2=2.85 P = 0.2402 burnsev df=2 X2=0.71 P = 0.7017 *NS
  type 3 - use these - order does not matter for type3 -  
  burnsev df=2, X2 = 0.71 P = 0.7017 *NS
  hydromulch df=2 X2 = 1.30  P = 0.5230 *NS;
proc genmod data=allburn; class burnsev hydromulch;
  model ilvo =  hydromulch burnsev / dist = negbin link=log type1 type3;
run;

proc genmod data=allburn; class burnsev hydromulch;
  model ilvo =  hydromulch burnsev hydromulch*burnsev/
     dist = negbin link=log type1 type3;
run;
* interaction NS;













*--------------------------------------- herbaceous -----------------------------------------------------;
*What do I want to find? 
	percent bare -- sort by treatment type
	species richness
	abundances of each species;
proc import datafile="f:\Research\2013 Spring\data2012excel.xls"
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

data datchk1; set herb; if count ^= 1;
proc print data=datchk1; title 'check1';
run;


*dataset with number of species (including bare) per plot;
proc means data=herb noprint n; by hydromulch burnsev plot spp; * pooling points;
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
proc freq data=herb4; tables burnsev*hydromulch; run;

proc univariate data=herb4 normal plot; title 'herb4'; 
run;
*(spnum): Skewness = 0.8373, kurtosis = -0.0164. Shapiro-Wilk: W=0.8883, p = 0.0087;

* ---- analyze only plots without mulch, with pooling;
data nomulchherb; set herb3; if hydromulch = 'n';  * N = 15 plots;
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
BUT scale predictor Value/DF > 1 (1.8186)....use negative binomial distribution;

proc genmod data=nomulchherb1; class burn;
  model spnum = burn / dist = negbin link=log type1 type3; title 'no mulch pooled negbin';
run;
* burnsev NS: df= 3 X2 = 2.12  P = 0.5485 
Value/DF = 1.3217....a little better;

* ---- analyze only burned plots ------;
data allburn; set herb3;
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



/* ################ IGNORE---VARIABLES NOT SIG
proc genmod data=allburn; class burnsev hydromulch;
  model _FREQ_ =  hydromulch burnsev hydromulch*burnsev/
     dist = poisson link=log type1 type3;
run;
* interaction: ??; */


