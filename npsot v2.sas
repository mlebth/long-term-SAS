OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

proc import datafile="G:\Research\seedlings2.xls"
out=seed
dbms=excel replace; sheet=sheet1;
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

