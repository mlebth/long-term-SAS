*PITA MODELS;
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

*QUMA MODELS;
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

*QUMA3 MODELS;
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

*ILVO MODELS;
proc glimmix data=seedsmerge2; title 'ilvo models';
  class bcat soil;
  *model ilvo14 = ilvo13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo13 = ilvo12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model ilvo12 = milvopre bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  estimate 'bcat*soil' bcat*soil -1 1 ;	
  output out=glmout2 resid=ehat;
run;
