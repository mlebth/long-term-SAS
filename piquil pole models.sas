
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

*11/29/15--merging seedling+overstory;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv"
out=seedtree
dbms=csv replace; 
getnames=yes;
*proc print data=seedtree (firstobs=1 obs=10); title 'seedtree'; run;

*remember--bcat 1=unburned, 2=s/l, 3=m/h;
	   *burnsev 1=unburned/scorched, 2=light, 3=moderate, 4=high;
proc glimmix data=seedtree ; title 'pita tree models';
  class burnsev soil;
  *model pita13p = burnsev soil/ distribution=negbin link=log solution DDFM=bw;
  *model mqumaprep = burnsev soil / distribution=negbin link=log solution DDFM=bw;
  model qum315p = burnsev soil / distribution=negbin link=log solution DDFM=bw;
  lsmeans burnsev soil / ilink cl;
 * contrast 'burn: u/scorch v light' burnsev -1 1 0 0;  
 * contrast 'burn: scorch v mod' burnsev -1 0 1 0;
 * contrast 'burn: scorch v hi' burnsev -1 0 0 1;
 * contrast 'burn: light v mod' burnsev 0 -1 1 0;
 * contrast 'burn: light v hi' burnsev 0 -1 0 1;
 * contrast 'burn: mod v hi' burnsev 0 0 -1 1;
 * contrast 'soil: sand v gravel' soil -1 1;
  output out=glmout resid=ehat;
run;

*prior veg models;
proc glimmix data=seedtree ; title 'pita tree models';
  model pita15p = pita12p/ distribution=negbin link=log solution DDFM=bw;
  *model pita12p = mpitapre/ distribution=negbin link=log solution DDFM=bw;
  *model quma14p = quma13p / distribution=negbin link=log solution DDFM=bw;
  *model quma12p = mqumapre / distribution=negbin link=log solution DDFM=bw;
  *model qum312p = mquma3prep / distribution=negbin link=log solution DDFM=bw;
  *model qum315p = mquma3pre / distribution=negbin link=log solution DDFM=bw;
  output out=glmout resid=ehat;
run;
