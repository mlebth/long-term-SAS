
proc glimmix data=seedtree; title 'overstory';
    class burnsev soil aspect;
    model pita13tr = burnsev soil pita12tr/ distribution=negbin link=log solution  DDFM=bw;

    *model pita14tr =   burnsev soil pita13tr/ distribution=negbin link=log solution  DDFM=bw;
    lsmeans  burnsev  / ilink cl;
    contrast 'scorch v low' burnsev 1 -1 0 0;
    contrast 'scorch v mod' burnsev 1 0 -1 0;
    contrast 'scorch v hi' burnsev 1 0 0 -1;
    contrast 'low v mod' burnsev 0 1 -1 0;
    contrast 'low v hi' burnsev 0 1 0 -1;
    contrast 'mod v hi' burnsev 0 0 1 -1;
    output out=glmout resid=ehat;
run;

OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

/*
*import mature trees file;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\treemerge3.csv"
out=treemerge2
dbms=csv replace; 
getnames=yes;
*proc print data=treemerge2; title 'treemerge2'; run;

*11/29/15--merging seedling+overstory;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedsmerge3.csv"
out=seedsmerge2
dbms=csv replace; 
getnames=yes;
*proc print data=seedsmerge2; title 'seedsmerge2'; run;

*1-11-17--bringing in saplings;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\sapmerge2.csv"
out=sapmerge2
dbms=csv replace; 
getnames=yes;
*proc print data=sapmerge2; title 'sapmerge2'; run;
data sapmerge3; set sapmerge2; drop aspect; run;
*proc print data=sapmerge3; title 'sapmerge3'; run;

*merging seedlings and overstory;
proc sort data=treemerge2;	by plot; run;
*proc contents data=treemerge2; run;
data seedtree; merge seedsmerge2 treemerge2 sapmerge3; by plot;
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
*proc print data=seedtree ; title 'seedtree'; run;
*proc contents data=seedtree; run;

proc sort data=seedtree; by soil;
proc means data=seedtree mean min max noprint; by soil;
	var slope elev;
	output out=blerg mean=mslope melev min=minslope minelev max=maxslope maxelev;
run;
proc print data=blerg; title 'blerg'; run;
	***mean elev and slope at each soil type;
proc glm data=seedtree;
	class soil;
	model soil=elev;
run;

*6-7-17--calculating pre-fire tree density v. post-fire seedling density (of PITA);
proc means data=seedtree noprint mean; 
	var mpitapretr; 
	output out=pretrdens mean=totpitapretrdens;
run;
proc print data=pretrdens; title 'pretrdens'; run;
*pre-fire tree density: 180.67/ha;

proc means data=seedtree noprint mean; 
	var pita12sd pita13sd pita14sd pita15sd; 
	output out=pitapostsddens mean=pita12sdens pita13sddens pita14sddens pita15sddens;
run;
proc print data=pitapostsddens; title 'pitapostsddens'; run;
*post-fire seedling density (all years, all burn classes): 1812.47/ha

*post seedlings, by burn severity;
proc sort data=seedtree; by burnsev;
proc means data=seedtree noprint mean; by burnsev; 
	var pita12sd pita13sd pita14sd pita15sd; 
	output out=pitapostsddens mean=pita12sdens pita13sddens pita14sddens pita15sddens;
run;
proc print data=pitapostsddens; title 'pitapostsddens'; run;
*post-fire seedling density (2012): 527.67
2013: 295.16
2014: 246.39
2015: 6,180.67
post-fire total (all years) seedling density: 1812.47/ha

Totals by burnsev in 2015:
burnsev 1: 11057.62/ha
burnsev 2: 21647.73
burnsev 3: 905.45
burnsev 4: 199.83
***end 6-7-17;

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
proc glimmix data=seedtree; title 'overstory';
    class burnsev soil aspect;
    model pita12tr =  burnsev soil mpitapretr/ distribution=negbin link=log solution  DDFM=bw;
    lsmeans burnsev soil  / ilink cl;
    /*
    contrast 'scorch v low' burnsev 1 -1 0 0;
    contrast 'scorch v mod' burnsev 1 0 -1 0;
    contrast 'scorch v hi' burnsev 1 0 0 -1;
    contrast 'low v mod' burnsev 0 1 -1 0;
    contrast 'low v hi' burnsev 0 1 0 -1;
    contrast 'mod v hi' burnsev 0 0 1 -1;
*/
    output out=glmout resid=ehat;
run;
*correlations between all variables;
proc corr data=seedtree spearman; 
var mcovpre hydr slope burnsev;
run;
*correlations between burn and cover;
proc corr data=seedtree spearman; 
var mcovpre cov12 cov13 cov14 cov15 burnsev;
run;

proc plot data=seedtree; plot mcovpre*burnsev; run;
proc freq data=seedtree; tables burnsev*mcovpre; run;
proc sql;
	select plot mcovpre burnsev
	from seedtree;
quit;

*********5-23-17: re-running some models with all variables in one instead of treating them separately;

*vars:
burnsev, soil, aspect, elev, slope
prev trees (same class);
proc glimmix data=seedtree; title 'overstory';
	class burnsev soil aspect;
	model quma13sd = soil quma14sd quma15tr / distribution=negbin link=log solution  DDFM=bw;
	/*lsmeans  burnsev  / ilink cl;
	contrast 'scorch v low' burnsev 1 -1 0 0;
	contrast 'scorch v mod' burnsev 1 0 -1 0;
	contrast 'scorch v hi' burnsev 1 0 0 -1;
	contrast 'low v mod' burnsev 0 1 -1 0;
	contrast 'low v hi' burnsev 0 1 0 -1;
	contrast 'mod v hi' burnsev 0 0 1 -1;  */
	output out=glmout resid=ehat;	
run; 


*jan-feb 2017;
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
