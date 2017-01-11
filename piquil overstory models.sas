*import mature trees file;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\treemerge3.csv"
out=treemerge2
dbms=csv replace; 
getnames=yes;
run;
*11/29/15--merging seedling+overstory;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedsmerge2.csv"
out=seedsmerge2
dbms=csv replace; 
getnames=yes;
run;
*1-11-17--bringing in saplings;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\sapmerge2.csv"
out=sapmerge2
dbms=csv replace; 
getnames=yes;
run;

*merging seedlings and overstory;
proc sort data=treemerge2;	by plot; run;
*proc contents data=treemerge2; run;
data seedtree; merge seedsmerge2 treemerge2 sapmerge2; by plot;
	if plot=1211 then burnsev = 1;
	if plot=1212 then burnsev = 3;
	if plot=1218 then burnsev = 1;
	if plot=1219 then burnsev = 2;
run;
*proc print data=seedtree; title 'seedtree'; run;
*proc contents data=seedtree; run;
proc sort data=seedtree; by bcat burnsev; run;

/*
proc export data=seedtree
   outfile='D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv'
   dbms=csv
   replace;
run;
*/

************11/24/15 -- data exploration;
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

proc plot data=seedtree; plot pita15*pita12tr; run;
***********************;
proc contents data=seedtree; run;
*bcat models;
*remember--bcat 1=unburned, bcat 2=s/l, bcat 3=m/h;
proc glimmix data=treemerge2; title 'bcat models';
  class burn soil;
  model pita12tr = burn soil cov12/ distribution=negbin link=log solution DDFM=bw;
  *model quma15 = bcat / distribution=poisson link=log solution DDFM=bw;
  *model qum313 = bcat / distribution=poisson link=log solution DDFM=bw;
  lsmeans bcat soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedtree; title 'seed v tree';
	*class burnsev;
	*model pita15 = pita15tr burnsev/ distribution=negbin link=log solution  DDFM=bw;
	*model pita14 = mpitapretr / distribution=negbin link=log solution  DDFM=bw;
	*model pita13 = pita12tr / distribution=negbin link=log solution  DDFM=bw;
	model pita12 = pita12tr / distribution=negbin link=log solution  DDFM=bw;
	*model mpitapre = mpitapretr / distribution=negbin link=log solution  DDFM=bw;
    *lsmeans burnsev / ilink cl;
	output out=glmout resid=ehat;
run;

proc glimmix data=seedtree; title 'seed v tree';
	*class burnsev;
	model quma15 = mqumapretr  / distribution=negbin link=log solution DDFM=bw;
	*model quma14 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model quma13 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model quma12 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model mqumapre = mqumapretr / distribution=negbin link=log solution DDFM=bw;
    *lsmeans burnsev / ilink cl;
	output out=glmout resid=ehat;
run;

proc glimmix data=seedtree; title 'seed v tree';
	*class burnsev;
	*model qum315 = mquma3pretr  / distribution=negbin link=log solution DDFM=bw;
	*model qum314 = qum313tr / distribution=negbin link=log solution DDFM=bw;
	*model quma313 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model quma312 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model mquma3pre = mqumapretr / distribution=negbin link=log solution DDFM=bw;
    *lsmeans burnsev / ilink cl;
	output out=glmout resid=ehat;
run;

*soil models;
proc glimmix data=seedtree; title 'bcat models';
  class  burnsev;
  model pita15tr =  burnsev pita14p burnsev*pita14p/ distribution=poisson link=log solution DDFM=bw;
  *model qum15tr = soil / distribution=poisson link=log solution DDFM=bw;
  lsmeans  burnsev / ilink cl;
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

