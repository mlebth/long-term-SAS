proc glimmix data=seedsmerge2; title 'model';
  class bcat soil; 
  model pita14 = pita13 bcat soil caco bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  lsmeans bcat soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;


proc glimmix data=seedsmerge2; title 'model';
  class bcat soil; 
  model pita14 = pita13 bcat soil bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  * this works, scale = 0.2, xX2 = 1.14;
  output out=glmout2 resid=ehat;
run;

* alternate for unbalanced designs;
* if we drop bcat & soil, its variation falls into bcat*soil;
* if SIG, add appropriate constrasts;
proc glimmix data=seedsmerge2; title 'model';
  class bcat soil; 
  model pita14 = pita13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  * this works, scale=0.2, X2=1.14 -2LL=122.61;
  output out=glmout2 resid=ehat;
run;

proc plot data=seedsmerge2; plot pita13*caco; run;

proc glimmix data=seedsmerge2; title 'model';
  * class bcat soil; 
  model pita14 = caco
       / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;
