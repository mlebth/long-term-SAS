
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

*mature trees;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\treemerge3.csv"
out=treemerge2
dbms=csv replace; 
getnames=yes;
run;
*seedlings;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedsmerge2.csv"
out=seedsmerge2
dbms=csv replace; 
getnames=yes;
run;
*saplings;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\sapmerge2.csv"
out=sapmerge2
dbms=csv replace; 
getnames=yes;
run;

*merging;
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

*bcat models;
proc glimmix data=seedtree ; title 'bcat models';
  class burnsev soil;
  *model pita12p = burnsev soil / distribution=negbin link=log solution DDFM=bw;
  	*no pita models at all sig. tested cover too, not sig.;
  model quma12p = cov12 / distribution=negbin link=log solution DDFM=bw;
  *model mquma3prep = burnsev soil/ distribution=negbin link=log solution DDFM=bw;
	*no quma3 models at all sig.;
  /*
  lsmeans burnsev soil/ ilink cl;
  contrast 'burn: u/scorch v light' burnsev -1 1 0 0;  
  contrast 'burn: scorch v mod' burnsev -1 0 1 0;
  contrast 'burn: scorch v hi' burnsev -1 0 0 1;
  contrast 'burn: light v mod' burnsev 0 -1 1 0;
  contrast 'burn: light v hi' burnsev 0 -1 0 1;
  contrast 'burn: mod v hi' burnsev 0 0 -1 1;
  contrast 'soil: sand v gravel' soil -1 1; */
  output out=glmout2 resid=ehat;
run;
proc plot data=seedtree; plot quma12p*soil; run;
