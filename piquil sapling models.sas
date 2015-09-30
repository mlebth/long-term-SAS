proc glm data=sapmerge2; title 'bcat glm';
  class bcat;
  model pita14 = bcat;
  output out=glmout r=ehat;
run;
proc univariate data=glmout plot normal; var ehat pita14; run; *very very non-normal;

*bcat models;
proc glimmix data=sapmerge2 ; title 'bcat models';
  class bcat;
  *model pita15 = bcat / distribution=negbin link=log solution DDFM=bw;
  *model quma15 = bcat / distribution=negbin link=log solution DDFM=bw;
  model qum315 = bcat / distribution=negbin link=log solution DDFM=bw;
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
proc glimmix data=sapmerge2 method=laplace; title 'bcat models';
  model pita12 = cov12 / distribution=negbin link=log solution DDFM=bw;
  *model quma15 = caco / distribution=negbin link=log solution DDFM=bw;
  *model qum315 = caco / distribution=negbin link=log solution DDFM=bw;
  output out=glmout2 resid=ehat;
run;


