*****************Interaction-only models (bcat*soil);
*PITA;
proc glimmix data=seedsmerge2; title 'pita models';
  class bcat soil; 
  *model pita14 = pita13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *model pita13 = pita12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model pita12 = mpitapre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
output out=glmout2 resid=ehat;
run;

*QUMA;
proc glimmix data=seedsmerge2; title 'quma models';
  class bcat soil; 
  *model quma14 = quma13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma13 = quma12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model quma12 = mqumapre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
output out=glmout2 resid=ehat;
run;

*QUMA3;
proc glimmix data=seedsmerge2; title 'quma3 models';
  class bcat soil; 
  *model qum314 = qum313 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum313 = qum312 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model qum312 = mquma3pre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
output out=glmout2 resid=ehat;
run;

*ILVO;
proc glimmix data=seedsmerge2; title 'ilvo models';
  class bcat soil;
  *model ilvo14 = ilvo13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo13 = ilvo12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model ilvo12 = milvopre bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  contrast 'bcat*soil' bcat*soil 0 -1 1 ;	
  output out=glmout2 resid=ehat;
run;

*****************bcat (or burnsev) models;
proc glimmix data=seedtree; title 'burnsev models';
  class burnsev;  
  *model mpitapre = burnsev / distribution=negbin link=log solution DDFM=residual; 
  *model mqumapre = burnsev / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = burnsev / distribution=negbin link=log solution DDFM=residual; 
  model milvopre = burnsev / distribution=negbin link=log solution DDFM=residual;  
  lsmeans burnsev / ilink cl; 
  contrast 'burn: u/scorch v light' burnsev -1 1 0 0;  
  contrast 'burn: scorch v mod' burnsev -1 0 1 0;
  contrast 'burn: scorch v hi' burnsev -1 0 0 1;
  contrast 'burn: light v mod' burnsev 0 -1 1 0;
  contrast 'burn: light v hi' burnsev 0 -1 0 1;
  contrast 'burn: mod v hi' burnsev 0 0 -1 1;
  output out=glmout resid=ehat;
run;

proc glimmix data=seedtree; title 'pltd models';
	class pltd;
	model pita15=pltd/distribution=negbin link=log solution DDFM=bw;
    lsmeans pltd / ilink cl; 
    output out=glmout resid=ehat;
run;

*pltd: 1=no, 2=yes;
proc freq data=seedtree; tables pltd*plot; run;
*39 not planted, 7 planted;

*****************soil models;
proc glimmix data=seedsmerge2; title 'soil models'; 
  class soil;  
  *model pita15 = soil / distribution=negbin link=log solution DDFM=residual; 
  *model quma15 = soil / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = soil / distribution=negbin link=log solution DDFM=residual; 
  model ilvo15 = soil / distribution=negbin link=log solution DDFM=residual; 
  output out=glmout2 resid=ehat;
  lsmeans soil / ilink cl; 
run; 

*****************caco models;
proc glimmix data=seedsmerge2; title 'caco models'; 
  *model mpitapre = caco / distribution=negbin link=log solution DDFM=residual; 
  *model mqumapre = caco / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = caco / distribution=negbin link=log solution DDFM=residual; 
  model milvopre = caco / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run; 
