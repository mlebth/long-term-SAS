
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv"
out=seedtree
dbms=csv replace; 
getnames=yes;
run;

proc contents data=seedtree; run;
proc plot data=seedtree; plot quma15p*quma14p quma14p*quma13p quma13p*quma12p; run;

*5-24-17--rerunning for fewer models;

proc glimmix data=seedtree ; title 'pole models';
  class burnsev soil aspect;
  model pita13p = burnsev pita12p/ distribution=negbin link=log solution DDFM=bw;
  *lsmeans  soil aspect/ ilink cl;
  output out=glmout2 resid=ehat;
run;


***from first runs, jan-feb 17;
*bcat models;
proc glimmix data=seedtree ; title 'bcat models';
  class burnsev soil;
  *model pita12p = burnsev soil / distribution=negbin link=log solution DDFM=bw;
  	*no pita models at all sig. tested cover too, not sig.;
  *model quma14p = quma13p / distribution=negbin link=log solution DDFM=bw;
  model mqustprep =  soil / distribution=negbin link=log solution DDFM=bw;
  *model mquma3prep = burnsev soil/ distribution=negbin link=log solution DDFM=bw;
	*no quma3 models at all sig.;
  lsmeans  soil/ ilink cl;
  /*
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
