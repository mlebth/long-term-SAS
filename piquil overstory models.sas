*bcat models;
proc glimmix data=treemerge2; title 'bcat models';
  class bcat;
  model pita15 = bcat / distribution=poisson link=log solution DDFM=bw;	*poisson a better fit than negbin;
  *model quma15 = bcat / distribution=poisson link=log solution DDFM=bw;
  *model qum313 = bcat / distribution=poisson link=log solution DDFM=bw;
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;

************11/24/15;
proc sort data=treemerge2; by bcat soil; run;
proc means data=treemerge2 mean noprint; 
	by bcat soil; var pita15 quma15 qum315;
	output out=mout1 n=npita15 nquma15 nquma315;
run;
proc print data=mout1; run;	 *no data for bcat=1 (unburned) -- no unburned plots sampled post-fire;

proc means data=treemerge2 mean noprint; 
	by bcat; var pita15 quma15 qum315;
	output out=mout2 mean=mpita15 mquma15 mquma315;
run;
proc print data=mout2; run;	

proc means data=treemerge2 mean noprint; 
	by bcat ; var mpitapre pita12 pita13 pita14 pita15;
	output out=mout2 mean=pitapre mpita12 mpita13 mpita14 mpita15;
run;
proc print data=mout2; run;	
***********************;

*11/29/15--merging seedling+overstory;
proc sort data=seedsmerge2; by plot aspect bcat elev hydr; run;
proc sort data=treemerge2;	by plot aspect bcat elev hydr; run;
data seedtree; merge seedsmerge2 treemerge2; by plot aspect bcat elev hydr;
run;
proc print data=seedtree; title 'seedtree'; run;
proc contents data=seedtree; run;

proc plot data=seedtree; plot pita15sd*mpitapretr; run;

proc glimmix data=seedtree; title 'seed v tree';
	model pita15sd = mpitapretr / distribution=negbin link=log solution DDFM=bw;
	output out=glmout resid=ehat;
run;

*soil models;
proc glimmix data=treemerge2; title 'bcat models';
  class soil ;
  *model mpitapre = soil  / distribution=poisson link=log solution DDFM=bw;
  model quma15 = soil / distribution=poisson link=log solution DDFM=bw;
  *model qum315 = soil / distribution=poisson link=log solution DDFM=bw;
  lsmeans soil  / ilink cl;
  output out=glmout2 resid=ehat;
run;

*canopy cover models;
proc glimmix data=treemerge2 ;  title 'bcat models';
  *model pita15 = cov15 / distribution=negbin link=log solution DDFM=bw;
  model quma14 = cov14 / distribution=negbin link=log solution DDFM=bw;
  *model mquma3pre = mcovpre / distribution=negbin link=log solution DDFM=bw;
  output out=glmout2 resid=ehat;
run;

