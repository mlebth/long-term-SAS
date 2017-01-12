
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\sapmerge2.csv"
out=sapmerge2
dbms=csv replace; 
getnames=yes;
run;

proc glm data=sapmerge2; title 'bcat glm';
  class bcat;
  model pita14 = bcat;
  output out=glmout r=ehat;
run;
proc univariate data=glmout plot normal; var ehat pita14; run; *very very non-normal;

*bcat models;
proc glimmix data=sapmerge2 ; title 'bcat models';
  class bcat;
  model pita15 = bcat / distribution=negbin link=log solution DDFM=bw;
  *model quma15 = bcat / distribution=negbin link=log solution DDFM=bw;
  *model qum313 = bcat / distribution=negbin link=log solution DDFM=bw;
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;

*soil models;
proc glimmix data=sapmerge2 method=laplace; title 'bcat models';
  class soil;
  *model pita15 = soil / distribution=negbin link=log solution DDFM=bw;
  *model quma15 = soil / distribution=negbin link=log solution DDFM=bw;
  model qum315 = soil / distribution=negbin link=log solution DDFM=bw;
  lsmeans soil / ilink cl;
  output out=glmout2 resid=ehat;
run;

*canopy cover models;
proc glimmix data=sapmerge2 ;  title 'bcat models';
  *model pita15 = cov15 / distribution=negbin link=log solution DDFM=bw;
  model quma14 = cov14 / distribution=negbin link=log solution DDFM=bw;
  *model mquma3pre = mcovpre / distribution=negbin link=log solution DDFM=bw;
  output out=glmout2 resid=ehat;
run;

proc means data=sapmerge2; 

