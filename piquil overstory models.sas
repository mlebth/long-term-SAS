*bcat models;
*remember--bcat 1=unburned, bcat 2=s/l, bcat 3=m/h;
proc glimmix data=treemerge2; title 'bcat models';
  class bcat soil;
  model pita12tr = bcat soil cov12/ distribution=negbin link=log solution DDFM=bw;
  *model quma15 = bcat / distribution=poisson link=log solution DDFM=bw;
  *model qum313 = bcat / distribution=poisson link=log solution DDFM=bw;
  lsmeans bcat soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

************11/24/15;
proc sort data=treemerge2; by bcat soil; run;
proc means data=treemerge2 mean noprint; 
	by bcat soil; var pita15tr quma15tr qum315tr;
	output out=mout1 n=npita15tr nquma15tr nquma315tr;
run;
proc print data=mout1; run;	 *no data for bcat=1 (unburned) -- no unburned plots sampled post-fire;

proc means data=treemerge2 mean noprint; 
	by bcat; var pita15tr quma15tr qum315tr;
	output out=mout2 mean=mpita15 mquma15 mquma315;
run;
proc print data=mout2; run;	

proc means data=treemerge2 mean noprint; 
	by bcat ; var mpitapretr pita12tr pita13tr pita14tr pita15tr;
	output out=mout2 mean=pitapre mpita12 mpita13 mpita14 mpita15;
run;
proc print data=mout2; run;	
***********************;


*11/29/15--merging seedling+overstory;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedsmerge2.csv"
out=seedsmerge2
dbms=csv replace; 
getnames=yes;
run;

proc sort data=treemerge2;	by plot aspect bcat elev hydr; run;
proc contents data=treemerge2; run;
data seedtree; merge seedsmerge2 treemerge2; by plot aspect bcat elev hydr;
run;
proc print data=seedtree; title 'seedtree'; run;
proc contents data=seedtree; run;

/*
proc export data=seedtree
   outfile='E:\Research\FMH Raw Data, SAS, Tables\FFI long-term data\Tables not used in SAS--results, sas exports, etc\seedtree.csv'
   dbms=csv
   replace;
run;
*/

proc plot data=seedtree; plot pita15*pita12tr; run;

proc glimmix data=seedtree; title 'seed v tree';
	model pita15sd = mpitapretr / distribution=negbin link=log solution DDFM=bw;
	output out=glmout resid=ehat;
run;

proc glimmix data=seedtree; title 'seed v tree';
	model quma12sd = quma12tr / distribution=negbin link=log solution DDFM=bw;
	output out=glmout resid=ehat;
run;

*soil models;
proc glimmix data=treemerge2; title 'bcat models';
  class soil ;
  *model pita15tr = soil  / distribution=poisson link=log solution DDFM=bw;
  model qum15tr = soil / distribution=poisson link=log solution DDFM=bw;
  lsmeans soil  / ilink cl;
  output out=glmout2 resid=ehat;
run;

*bcat models;
proc glimmix data=treemerge2; title 'bcat models';
  class bcat ;
  *model pita13tr = bcat  / distribution=poisson link=log solution DDFM=bw;
  model quma12tr = bcat / distribution=poisson link=log solution DDFM=bw;
  lsmeans bcat  / ilink cl;
  output out=glmout2 resid=ehat;
run;

*canopy cover models;
proc glimmix data=treemerge2 ;  title 'bcat models';
  *model pita15 = cov15 / distribution=negbin link=log solution DDFM=bw;
  model quma14 = cov14 / distribution=negbin link=log solution DDFM=bw;
  *model mquma3pre = mcovpre / distribution=negbin link=log solution DDFM=bw;
  output out=glmout2 resid=ehat;
run;

