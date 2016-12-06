
proc contents data=new; run;

OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

*importing seedling data;
proc import datafile="E:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedsmerge2.csv"
out=seedsmerge2 dbms=csv replace; getnames=yes; run;  * N = 55;

proc freq data=seedsmerge2; tables hydr; run; *40 plots with 0 mulch, 15 with mulch;
proc freq data=seedsmerge2; tables bcat*hydr; run; 
*		hydr1	hydr2
bcat2	 18		  1
bcat3	 20		  14
--bcat1 omitted--unburned. none post-fire.
split up--no hydro only, heavy burn only? can't ignore the one bcat2/hydr2 plot though (plot 1220);

*9-29-16--switching tactics, the old methods are no longer appropriate because now we have
more than 1 year of data and a more appropriate data structure;
proc glimmix data=seedsmerge2;  
  class bcat hydr;
  	*2012 models have issues--maybe too many missing cells;
  model pita12 = bcat hydr slope / distribution=negbin link=log solution DDFM=bw; *bcat*hydr NS every year; *hydr only sig in 2015;
  *model quma15 = bcat hydr / distribution=negbin link=log solution DDFM=bw; *bcat*hydr NS every year; *hydr approaching sig in 2015 (p=.087);
  *model qum315 = bcat hydr / distribution=negbin link=log solution DDFM=bw; *bcat*hydr NS every year; *hydr never sig;
  *model ilvo15 = bcat hydr / distribution=negbin link=log solution DDFM=bw;  *bcat*hydr NS every year; *hydr never sig;
  lsmeans bcat hydr / ilink cl; 
  output out=glmout2 resid=ehat;
run;

* --- subset of data, no mulch only----;
data nomulch; set seedsmerge2; if hydr = '1';  
proc print data=nomulch; title 'nomulch';
run; * N = 40;
proc freq data=nomulch; tables bcat*hydr; run; 
proc glimmix data=nomulch;  
  class bcat;
  model pita12 = bcat / distribution=negbin link=log solution DDFM=bw;
  *model quma15 = bcat / distribution=negbin link=log solution DDFM=bw; 
  *model qum315 = bcat / distribution=negbin link=log solution DDFM=bw; 
  *model ilvo15 = bcat / distribution=negbin link=log solution DDFM=bw; 
  lsmeans bcat / ilink cl; 
  output out=glmout2 resid=ehat;
run;

* ---- subset of data, severe burn only (bcat=3) ---- ;
data burnplots; set seedsmerge2;
  if (bcat=3); 
proc print data=burnplots; title 'burnplots';
run; * N = 34;
proc freq data=burnplots; tables bcat*hydr; run;	
*hydr1: 20, hydr2: 14;
proc glimmix data=burnplots;  
	*2012 models are no good;
  class hydr;
  model pita12 = hydr / distribution=poisson link=log solution DDFM=bw;
  *model quma15 = hydr / distribution=negbin link=log solution DDFM=bw; 
  *model qum312 = hydr / distribution=negbin link=log solution DDFM=bw; 
  *model ilvo12 = hydr / distribution=negbin link=log solution DDFM=bw; 
  lsmeans hydr / ilink cl; 
  output out=glmout2 resid=ehat;
run;


*for herbaceous--run 'herb-iml-reorg-10-round-2';

*herbbyquad count models;
proc sort data=herbbyquad; by spnum plotnum yearnum bcat soil hydr aspect elev slope;
proc means data=herbbyquad sum mean noprint; by spnum plotnum yearnum bcat soil hydr aspect elev slope;
	var count cover; output out=herbbyquad2 sum=counts covers mean=countm coverm;
run;
data herbbyquad3; set herbbyquad2; keep counts coverm spnum plotnum yearnum bcat soil hydr aspect elev slope;
*proc print data=herbbyquad3; title 'herbbyquad3'; run;


data herbbyquad4; set herbbyquad3; if bcat=1 then delete; run;
proc sort data=herbbyquad4; by spnum;
data herbbyquadLEDU; set herbbyquad4; if spnum=1; run;

*older than 9-29-16;
* --- subset of data, no mulch only----;
data nomulch; set seedsmerge2; if hydr = '1';  
proc print data=nomulch; title 'nomulch';
run; * N = 40;
* ---- pooling unburned/scorch/light;
data nomulchpool; set nomulch;
  if (bcat=1|bcat=2) then burns ='L1'; *unburned/scorch/light burn;
  if (bcat=3) then burns ='L2';		 *moderate/heavy burn;
run;
proc freq data=nomulchpool; tables hydr*burn; run; *L1:20, L2:20;


* ---- analyze unmulched plots only ---- ;
proc glimmix data=nomulchpool; title 'effect of bcat w/ no mulch';
  class burns ;
  model pita15 =  burns / distribution=negbin link=log solution DDFM=bw; 
  *model quma15 = burns / distribution=negbin link=log solution DDFM=bw;
  *model qum315 = burns / distribution=negbin link=log solution DDFM=bw;
  *model ilvo15 = burns / distribution=negbin link=log solution DDFM=bw;
  *lsmeans pltd / ilink cl;   
  lsmeans burn / ilink cl; 
  output out=glmout2 resid=ehat;
run;

/*
proc genmod data=nomulchpool; title 'effect of bcat w/ no mulch';
  class burn;
  model pita12 =  burn / distribution=negbin link=log type1 type3; 
run;

proc genmod data=nomulchpool; class burn;
  model totquma = burn/ dist = negbin link=log type1 type3;
run; * NS;
*/

* ---- analyze burned plots only ---- ;
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
