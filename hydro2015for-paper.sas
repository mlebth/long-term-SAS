proc freq data=seedsmerge2; tables hydr; run; *40 plots with 0 mulch, 15 with mulch;

* --- subset of data, no mulch only----;
data nomulch; set seedsmerge2; if hydr = '1';  
proc print data=nomulch; title 'nomulch';
run; * N = 40;

* ---- pooling unburned/scorch/light;
data nomulchpool; set nomulch;
  if (bcat=1|bcat=2) then burn='L1';
  if (bcat=3) then burn='L2';
run;
proc freq data=nomulchpool; tables hydr*burn; run; *L1:20, L2:20;

proc glimmix data=nomulchpool; title 'effect of bcat w/ no mulch';
  class burn;
  model pita12 =  burn / distribution=negbin link=log solution DDFM=bw; 
  *model quma15 = burn / distribution=negbin link=log solution DDFM=bw;
  *model qum315 = burn / distribution=negbin link=log solution DDFM=bw;
  *model ilvo15 = burn / distribution=negbin link=log solution DDFM=bw;
  *lsmeans pltd / ilink cl; 
  output out=glmout2 resid=ehat;
run;

/*
proc genmod data=nomulchpool; class burn;
  model totquma = burn/ dist = negbin link=log type1 type3;
run; * NS;
*/

* ---- analyze only burned plots ------;
data burnplots; set seedsmerge2;
  if (bcat=2|bcat=3); 
proc print data=burnplots; title 'burnplots';
run; * N = 53;
proc freq data=burnplots; tables bcat; run;	*level 1: 19, level 2: 	34;

proc glimmix data=burnplots; title 'effect of bcat & hydr in burned plots only';
  class bcat hydr;
  *model pita12 =  bcat / distribution=negbin link=log solution DDFM=bw;  
  *model pita12 =  bcat hydr/ distribution=negbin link=log solution DDFM=bw; 
  model pita12 =  bcat hydr bcat*hydr/ distribution=negbin link=log solution DDFM=bw; 
  *model quma15 = pltd / distribution=negbin link=log solution DDFM=bw;
  *model qum315 = pltd / distribution=negbin link=log solution DDFM=bw;
  *model ilvo15 = pltd / distribution=negbin link=log solution DDFM=bw;
  lsmeans bcat*hydr / ilink cl; 
  output out=glmout2 resid=ehat;
run;

/*
* pita;
proc genmod data=allburn; class bcat hydr;
  model totpita = bcat hydr / dist = negbin link=log type1 type3;
run;
* dispersion =  1.7247
  type 1
  bcat df=2 X2=4.00 P = 0.1351 hydr df=2 X2 = 14.34 P = 0.0008
  hydr df=2 X2=7.32 P = 0.0257 bcat df=2 X2=11.02 P = 0.0040
  type 3 - use these - order does not matter for type3 -  
  bcat df=2, X2 = 11.02 P = 0.0040
  hydr df=2 X2 = 14.34  P = 0.0008;
proc genmod data=allburn; class bcat hydr;
  model totpita =  hydr bcat / dist = negbin link=log type1 type3;
run;

proc genmod data=allburn; class bcat hydr;
  model totpita =  hydr bcat hydr*bcat/
     dist = negbin link=log type1 type3;
* interaction NS;
run;
* oak; 
proc genmod data=allburn; class bcat hydr;
  model totquma = bcat hydr / dist = poisson link=log type1 type3;
run;
* type 3 bcat df=2 X2=3.71 P = 0.1567
         hydr  df=2  X2=10.91 P=0.0043;

proc genmod data=allburn; class bcat hydr;
  model totquma = bcat hydr  bcat*hydr/ dist = poisson link=log type1 type3;
run;
* use this - note type 1 not type 3 - no type3 reported.
* type 1 bcat df=2 X2=3.66 P = 0.1603
         hydr  df=2  X2=10.91 P=0.0043
         int df=3 X2=17.59 P = 0.0005;
*/
