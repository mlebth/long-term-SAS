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

*****************bcat models;
proc glimmix data=seedsmerge2; title 'bcat models';
  class bcat;  
  *model pita14 = bcat / distribution=negbin link=log solution DDFM=residual; 
  *model quma14 = bcat / distribution=negbin link=log solution DDFM=residual; 
  *model qum314 = bcat / distribution=negbin link=log solution DDFM=residual; 
  model ilvo14 = bcat / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;

*****************soil models;
proc glimmix data=seedsmerge2; title 'soil models'; 
  class soil;  
  *model mpitapre = soil / distribution=negbin link=log solution DDFM=residual; 
  *model mqumapre = soil / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = soil / distribution=negbin link=log solution DDFM=residual; 
  model milvopre = soil / distribution=negbin link=log solution DDFM=residual; 
  output out=glmout2 resid=ehat;
run; 

*****************caco models;
proc glimmix data=seedsmerge2; title 'caco models'; 
  *model mpitapre = caco / distribution=negbin link=log solution DDFM=residual; 
  *model mqumapre = caco / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = caco / distribution=negbin link=log solution DDFM=residual; 
  model milvopre = caco / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run; 
