
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv"
out=seedtree
dbms=csv replace; 
getnames=yes;
run;

proc plot data=seedtree; plot quma15p*quma14p quma14p*quma13p quma13p*quma12p; run;

*bcat models;
proc glimmix data=seedtree ; title 'bcat models';
  *class burnsev soil;
  *model pita12p = burnsev soil / distribution=negbin link=log solution DDFM=bw;
  	*no pita models at all sig. tested cover too, not sig.;
  model quma14p = quma13p / distribution=negbin link=log solution DDFM=bw;
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
