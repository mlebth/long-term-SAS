
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

/*
*import mature trees file;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\treemerge3.csv"
out=treemerge2
dbms=csv replace; 
getnames=yes;
run;
*11/29/15--merging seedling+overstory;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedsmerge3.csv"
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
*/

proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv"
out=seedtree
dbms=csv replace; 
getnames=yes;
run;

/*
proc export data=seedtree
   outfile='D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv'
   dbms=csv
   replace;
run;
*/

/*
************11/24/15 -- data exploration;
proc sort data=treemerge2; by burnsev soil; run;
proc means data=treemerge2 mean noprint; 
	by burnsev soil; var pita15tr quma15tr qum315tr;
	output out=mout1 n=npita15tr nquma15tr nquma315tr;
run;
proc print data=mout1; run;	 

proc means data=treemerge2 mean noprint; 
	by burnsev; var pita15tr quma15tr qum315tr;
	output out=mout2 mean=mpita15 mquma15 mquma315;
run;
proc print data=mout2; run;	

proc means data=treemerge2 mean noprint; 
	by burnsev ; var mpitapretr pita12tr pita13tr pita14tr pita15tr;
	output out=mout2 mean=pitapre mpita12 mpita13 mpita14 mpita15;
run;
proc print data=mout2; run;	

proc plot data=seedtree; plot pita15*pita12tr; run;

proc freq data=seedtree; tables mpitapretr; run;
*/

***********************;

******seedling = tree models;
proc glimmix data=seedtree; title 'seed v tree';
	class soil ;
	model pita15tr =  soil / distribution=negbin link=log solution  DDFM=bw;
	*model pita14 = mpitapretr / distribution=negbin link=log solution  DDFM=bw;
	*model pita13 = pita12tr / distribution=negbin link=log solution  DDFM=bw;
	*model pita12 = pita12tr / distribution=negbin link=log solution  DDFM=bw;
	*model mpitapre = mpitapretr / distribution=negbin link=log solution  DDFM=bw;
    *lsmeans burnsev / ilink cl;
	output out=glmout resid=ehat;
run;

proc glimmix data=seedtree; title 'seed v tree';
	class burnsev soil;
	model qust15tr = burnsev soil / distribution=negbin link=log solution DDFM=bw;
	*model quma12tr = burnsev soil / distribution=negbin link=log solution DDFM=bw;
	*model quma14 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model quma13 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model quma12 = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	*model mqumapre = mqumapretr / distribution=negbin link=log solution DDFM=bw;
    lsmeans burnsev soil / ilink cl;
	output out=glmout resid=ehat;
run;

proc glimmix data=seedtree; title 'seed v tree';
	*class burnsev;
	*model qum315 = mquma3pretr  / distribution=negbin link=log solution DDFM=bw;
	*model qum314 = mquma3pretr / distribution=negbin link=log solution DDFM=bw;
	*model qum313 = qum313tr / distribution=negbin link=log solution DDFM=bw;
	*model qum312 = qum312tr / distribution=negbin link=log solution DDFM=bw;
	*model mquma3pre = mquma3pretr / distribution=negbin link=log solution DDFM=bw;
    *lsmeans burnsev / ilink cl;
	output out=glmout resid=ehat;
run;

proc glimmix data=seedtree method=laplace; title 'qust y2y';
	model qust15tr = qust14tr  / distribution=negbin link=log solution DDFM=bw;
	*inestimable;
	*model qust12tr = qust13tr / distribution=negbin link=log solution DDFM=bw;
	*inestimable;
	*model qust14tr = qust15tr / distribution=negbin link=log solution DDFM=bw;
	*model qum312 = qum312tr / distribution=negbin link=log solution DDFM=bw;
	*model mquma3pre = mquma3pretr / distribution=negbin link=log solution DDFM=bw;
    *lsmeans burnsev / ilink cl;
	output out=glmout resid=ehat;
run;
***********;
*2-7-17--lumping unburned in with scorched;
data seedtreefix; set seedtree; 
	if bcat=1 then bcat=2; 
run;
*bcat models;
*remember--bcat 1=unburned, 2=s/l, 3=m/h;
	   *burnsev 1=unburned/scorched, 2=light, 3=moderate, 4=high;
proc glimmix data=seedtreefix; title 'pita tree models';
  class bcat soil;
  *model mpitapretr = burnsev soil / distribution=negbin link=log solution DDFM=bw;
  *model qum312tr = bcat soil / distribution=negbin link=log solution DDFM=bw;
  model mquma3pretr = bcat soil / distribution=negbin link=log solution DDFM=bw;
  *lsmeans bcat soil / ilink cl;
  *contrast 'burn: 1v2' bcat -1 1 0 ;  
  *contrast 'burn: 1v3' bcat -1 0 1 ;
  *contrast 'burn: 2v3' bcat -1 1;
  *contrast 'soil: sand v gravel' soil -1 1;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedtree ; title 'tree v prior trees/poles';
	*model pita12tr = mpitapretr  / distribution=negbin link=log solution DDFM=bw;
	*model quma12tr = mqumaprep / distribution=negbin link=log solution DDFM=bw;
	model qum312tr = mqumapretr / distribution=negbin link=log solution DDFM=bw;
	output out=glmout resid=ehat;
run;

proc plot data=seedtree; plot qum313tr*qum312tr; run;

proc glimmix data=seedtree method=laplace; title 'tree v prior tree';
	*class aspect;
	model pita14 =  elev  / distribution=negbin link=log solution DDFM=bw;
	*model quma12tr = mqumaprep / distribution=negbin link=log solution DDFM=bw;
	*model qum312tr = mquma3prep / distribution=negbin link=log solution DDFM=bw;
	output out=glmout resid=ehat;
run;

*2-7-17;
*getting stats for box plots;
proc means data=seedtree noprint min max mean median; by burnsev; 
