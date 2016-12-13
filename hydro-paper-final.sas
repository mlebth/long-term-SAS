/*
***use this file, and reorg from 'npsot v2.sas' for 2012 data--it's the data collected in may 2012;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedlings2.csv"
out=seed
dbms=csv replace; 
getnames=yes;
run;
proc contents data=seed; run;
proc print data=seed; run;  * N = 42;
* tree data in this file;
* variables: 
   burnsev (u,s,l,m,h)
   hgt (seedling
   hydromulch (1(no), 2(yes))
   num = number of seedlings
   plot = fmh code
   rspt (n,y) resprout?
   spp (quma, pita, x = no tree seedlings);
*/

*import seedlings4 from allyrsimport;

data seed; set seedlings4; keep bcat burnsev burn year heig hydrn coun plot sspp;  
rename hydrn=hydromulch heig=hgt coun=num; run;
* proc print data=seed; title 'seed'; run;
*proc print data=seedlings4 (firstobs=1 obs=4); run;

*---- # of obs of each plot -------------------;
proc sort data=seed; by plot hydromulch burnsev;
proc means data=seed noprint n; by plot hydromulch burnsev;
  output out=mout1 n=n;
*proc print data=mout1; title 'mout1'; * N = 61 plots;
run;

*---- subset the data by species and reorg-------------;
proc sort data=seed; by plot;
data pita; set seed; if sspp="PITAx"; 
  if year<2011 then npitapre = num; if year=2012 then npita12 = num; 
  if year=2013 then npita13 = num;  if year=2014 then npita14 = num; 
  if year=2015 then npita15 = num;
*proc print data=pita; title 'pita';  * N = 250 obs;
run;
proc means data=pita sum noprint; by plot burnsev burn bcat hydromulch; 
 var npitapre npita12 npita13 npita14 npita15;
 output out=pita2 sum = spitapre spita12 spita13 spita14 spita15;
*proc print data=pita2; title 'pita2';  * N = 43 non-zero plots;
run;
*proc freq data=pita2; *tables burnsev*hydromulch;
run;

data quma; set seed; if sspp="QUMAx"; 
  if year<2011 then nqumapre = num; if year=2012 then nquma12 = num; 
  if year=2013 then nquma13 = num;  if year=2014 then nquma14 = num; 
  if year=2015 then nquma15 = num;
*proc print data=quma; title 'quma';  * N = 19 obs;
run;
proc means data=quma sum noprint; by plot burnsev hydromulch; 
 var nqumapre nquma12 nquma13 nquma14 nquma15;
 output out=quma2 sum = squmapre squma12 squma13 squma14 squma15;
*proc print data=quma2; title 'quma2';  * N = 31 plots;
run;
*proc freq data=quma2; *tables burnsev*hydromulch;
run;

data quma3; set seed; if sspp="QUMA3"; 
  if year<2011 then nquma3pre = num; if year=2012 then nquma312 = num; 
  if year=2013 then nquma313 = num;  if year=2014 then nquma314 = num; 
  if year=2015 then nquma315 = num;
*proc print data=quma; title 'quma3';  * N = 19 obs;
run;
proc means data=quma3 sum noprint; by plot burnsev hydromulch; 
 var nquma3pre nquma312 nquma313 nquma314 nquma315;
 output out=quma32 sum = squma3pre squma312 squma313 squma314 squma315;
*proc print data=quma32; title 'quma32';  * N = 30 plots;
run;
*proc freq data=quma2; *tables burnsev*hydromulch;
run;
/*
*checking;
data empty; set seed; if sspp="x";
 holder = 0; * N = 5;
proc print data=empty; title 'empty';
run;	*0;
*/

data datreorg; merge pita2 quma2 quma32; by plot;
*proc print data=datreorg; title 'datreorg';
run; *n=46;
*proc freq data=datreorg; *tables burnsev*hydromulch;
run;

/*
This is no longer relevant--EB changed it 12/6/16 for year-by-year counts,
but originally it was for consolidating all the heights in a single year.
No point in consolidating all years together;

*---- analysis of total number --------------;
data dattotn; set datreorg;
  if (spitapre=.) then spitapre=0; if (spita12=.) then spita12=0; 
  if (spita13=.)  then spita13=0;  if (spita14=.) then spita14=0; 
  if (spita15=.)  then spita15=0; 
  if (squmapre=.) then squmapre=0; if (squma12=.) then squma12=0; 
  if (squma13=.)  then squma13=0;  if (squma14=.) then squma14=0; 
  if (squma15=.)  then squma15=0;
  totpita = spitapre + spita12 + spita13 + spita14 + spita15;
  totquma = squmapre + squma12 + squma13 + squma14 + squma15;
run; *n=46;
*/

* --- analyze only plots without mulch, burn is pooled----;
data nomulch; set datreorg; if hydromulch = 1;  * N = 31;
*proc print data=nomulch; title 'nomulch';
run;

data nomulchpool; set nomulch;
  if (burnsev='u'|burnsev='s') then burn='1';
  if (burnsev='l') then burn='2';
*  if (burnsev='m'|burnsev='h') then burn='L3'; * not used;
  if (burnsev='m') then burn='3';
  if (burnsev='h') then burn='4';
run;

* pita - genmod;
proc genmod data=nomulchpool; class burn;
  model spitapre = burn / dist = negbin link=log type1 type3;
  *model spita13 = burn / dist = negbin link=log type1 type3;
  *model spita14 = burn / dist = negbin link=log type1 type3;
  *model spita15 = burn / dist = negbin link=log type1 type3;
  contrast 'burn-scorch v light' burn -1 1 0 0;  
  contrast 'burn-scorch v mod' burn -1 0 1 0;
  contrast 'burn-scorch v hi' burn -1 0 0 1;
  contrast 'burn-light v mod' burn 0 -1 1 0;
  contrast 'burn-light v hi' burn 0 -1 0 1;
  contrast 'burn-mod v hi' burn 0 0 -1 1;
  *lsmeans burn / ilink cl;
run;
* dispersion =  2.7647;
* burn df=3 X2 = 7.17  P = 0.0666;

*quma
proc genmod data=nomulchpool; class burn;
  model squmapre = burn/ dist = negbin link=log type1 type3;
  *model squma13 = burn/ dist = negbin link=log type1 type3;
  *model squma14 = burn/ dist = negbin link=log type1 type3;
  *model squma15 = burn/ dist = negbin link=log type1 type3;  
  contrast 'burn-scorch v light' burn -1 1 0 0;  
  contrast 'burn-scorch v mod' burn -1 0 1 0;
  contrast 'burn-scorch v hi' burn -1 0 0 1;
  contrast 'burn-light v mod' burn 0 -1 1 0;
  contrast 'burn-light v hi' burn 0 -1 0 1;
  contrast 'burn-mod v hi' burn 0 0 -1 1;
  *lsmeans burn / ilink cl;
run; * NS;

*quma3;
proc genmod data=nomulchpool; class burn;
  model squma3pre = burn/ dist = negbin link=log type1 type3;
  *model squma313 = burn/ dist = negbin link=log type1 type3;
  *model squma314 = burn/ dist = negbin link=log type1 type3;
  *model squma315 = burn/ dist = negbin link=log type1 type3;
  lsmeans burn / ilink cl;
run; * NS;

* ---- analyze only burned plots ------;
data allburn; set datreorg;
  if (burnsev='l'|burnsev='m'|burnsev='h'); * N = 41;
  if (burnsev='l') then burn='1';
  if (burnsev='m') then burn='2';
  if (burnsev='h') then burn='3';
*proc print data=allburn; title 'allburn';
run;
* pita;
proc genmod data=allburn; class burn hydromulch;
  *model spitapre = burn hydromulch / dist = negbin link=log type1 type3;
  *model spita13 = burn hydromulch / dist = negbin link=log type1 type3;
  *model spita14 = burn hydromulch / dist = negbin link=log type1 type3;
  *model spita15 = burn hydromulch / dist = negbin link=log type1 type3;
  lsmeans burn hydromulch / ilink cl;
  contrast 'burn-lo v mod' burn -1 1 0;
  contrast 'burn-lo v hi' burn -1 0 1;
  contrast 'burn-mod v hi' burn 0 -1 1;
  contrast 'hydro-no v yes' hydromulch -1 1;
  estimate 'hydro in light burn' burn*hydromulch 
run;
* dispersion =  1.7247
  type 1
  burnsev df=2 X2=4.00 P = 0.1351 hydromulch df=2 X2 = 14.34 P = 0.0008
  hydromulch df=2 X2=7.32 P = 0.0257 burnsev df=2 X2=11.02 P = 0.0040
  type 3 - use these - order does not matter for type3 -  
  burnsev df=2, X2 = 11.02 P = 0.0040
  hydromulch df=2 X2 = 14.34  P = 0.0008;
proc print data=allburn; run;
* oak; 
proc genmod data=allburn; class burn hydromulch;
  *model squmapre = burn hydromulch / dist = negbin link=log type1 type3;
  *model squma13 = burn hydromulch / dist = negbin link=log type1 type3;
  *model squma14 = burn hydromulch / dist = negbin link=log type1 type3;
  model squma15 = burn hydromulch / dist = negbin link=log type1 type3;  
  contrast 'burn-lo v mod' burn -1 1 0;
  contrast 'burn-lo v hi' burn -1 0 1;
  contrast 'burn-mod v hi' burn 0 -1 1;
  contrast 'hydro-no v yes' hydromulch -1 1;
  lsmeans burn hydromulch / ilink cl;
run;
* type 3 burnsev df=2 X2=3.71 P = 0.1567
         hydromulch  df=2  X2=10.91 P=0.0043;

proc genmod data=allburn; class burnsev hydromulch;
  *model squma3pre = burnsev hydromulch / dist = negbin link=log type1 type3;
  model squma313 = burnsev hydromulch / dist = negbin link=log type1 type3;
  *model squma314 = burnsev hydromulch / dist = negbin link=log type1 type3;
  *model squma315 = burnsev hydromulch / dist = negbin link=log type1 type3;
  lsmeans/ilink cl;
run;

**not enough DF;
proc genmod data=allburn; class burnsev hydromulch;
  model squma12 = burnsev hydromulch  burnsev*hydromulch/ dist = negbin link=log type1 type3;
run;
* use this - note type 1 not type 3 - no type3 reported.
* type 1 burnsev df=2 X2=3.66 P = 0.1603
         hydromulch  df=2  X2=10.91 P=0.0043
         int df=3 X2=17.59 P = 0.0005;

