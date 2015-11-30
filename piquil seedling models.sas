*10/1/2015: pltd models;
proc glimmix data=seedsmerge2; title 'pltd models';
  class pltd;
  model pita15 =  pltd / distribution=negbin link=log solution DDFM=bw; 
  *model quma15 = pltd / distribution=negbin link=log solution DDFM=bw;
  *model qum315 = pltd / distribution=negbin link=log solution DDFM=bw;
  *model ilvo15 = pltd / distribution=negbin link=log solution DDFM=bw;
  lsmeans pltd / ilink cl; 
  output out=glmout2 resid=ehat;
run;
**********;

proc plot data=seedsmerge2; plot pita14*pita15; run;
data chek; set seedsmerge2;
	if pita15 > 200;
proc print data=chek; run;

proc glimmix data=seedsmerge2; title 'bcat models';
  class bcat;
  model pita15 = bcat / distribution=negbin link=log solution DDFM=residual;
  *model quma15 = bcat / distribution=negbin link=log solution DDFM=residual;
  *model qum315 = bcat / distribution=negbin link=log solution DDFM=residual;
  *model ilvo15 = bcat / distribution=negbin link=log solution DDFM=residual;
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'caco models';
  *model pita12 = mcovpre / distribution=negbin link=log solution DDFM=residual;
  *model quma14 = mcovpre / distribution=negbin link=log solution DDFM=residual;
  model qum313 = mcovpre / distribution=negbin link=log solution DDFM=residual;
  *model milvopre = mcovpre / distribution=negbin link=log solution DDFM=residual;
  output out=glmout2 resid=ehat;
run;
*****************Interaction-only models (bcat*soil);
*PITA;
proc glimmix data=seedsmerge2; title 'pita models';
  class bcat soil; 	
  model pita15 = pita14 bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *model pita14 = pita13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *model pita13 = bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model pita12 = mpitapre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  lsmeans bcat*soil/ ilink cl;
  output out=glmout2 resid=ehat;
run; 

proc glimmix data=seedsmerge2; title 'pita models';
  class bcat soil; 	
  model pita15 = bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *model pita14 = bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *model pita13 = bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model pita12 = bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  lsmeans bcat*soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'pita models';
  model pita15 = pita14
       / distribution=negbin link=log solution DDFM=residual; 
  *model pita13 = pita12 
       / distribution=negbin link=log solution DDFM=residual;  
  *model pita12 = mpitapre 
       / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;
*QUMA;
proc glimmix data=seedsmerge2; title 'quma models';
  class bcat soil; 	
  model quma15 = quma14 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma14 = quma13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma13 = quma12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma13 = quma12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  lsmeans bcat*soil/ ilink cl;
output out=glmout2 resid=ehat;
run;
proc glimmix data=seedsmerge2; title 'quma models';
  class bcat soil; 	
  model quma15 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma14 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma13 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma12 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  lsmeans bcat*soil/ ilink cl;
output out=glmout2 resid=ehat;
run; 

proc glimmix data=seedsmerge2; title 'quma models';
  model quma15 =  quma14
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma13 =  quma12
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma12 =  mqumapre
       / distribution=negbin link=log solution DDFM=residual;
output out=glmout2 resid=ehat;
run; *

*QUMA3;
proc glimmix data=seedsmerge2; title 'quma3 models';
  class bcat soil; 	
  model qum315 = qum314 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;
  *model qum314 = qum313 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum313 = qum312 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum312 = mquma3pre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  lsmeans bcat*soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'quma3 models';
  class bcat soil; 
  model qum315 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum314 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum313 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum312 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  	 
  *contrast '11 v 21 - effect of fire in sand' bcat*soil 1 0 -1 0;	
  *contrast '12 v 22 - effect of fire in gravel' bcat*soil 0 1 0 -1;
  *contrast '11 v 12 - effect of soil in lofire' bcat*soil 1 -1 0 0;
  *contrast '21 v 22 - effect of soil in hifire' bcat*soil 0 0 1 -1;
  lsmeans bcat*soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'quma3 models';
  model qum315 = qum314 
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum313 = qum312 
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum312 = mquma3pre 
       / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;

*ILVO;
proc glimmix data=seedsmerge2; title 'ilvo models';
  class bcat soil; 
  *model ilvo15 = ilvo14 bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *model ilvo14 = ilvo13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo13 = ilvo12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model ilvo12 = milvopre bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  *contrast '11 v 21' bcat*soil 1 -1 0;	*p=0.02;
  *contrast '21 v 22' bcat*soil 0 1 -1;	*p=0.73;
  lsmeans bcat*soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'ilvo models';
  class bcat soil; 
  *model ilvo15 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo14 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo13 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model ilvo12 =  bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *contrast '11 v 21 - effect of fire in sand' bcat*soil 1 0 -1 0;	
  *contrast '12 v 22 - effect of fire in gravel' bcat*soil 0 1 0 -1;
  *contrast '11 v 12 - effect of soil in lofire' bcat*soil 1 -1 0 0;
  *contrast '21 v 22 - effect of soil in hifire' bcat*soil 0 0 1 -1;
  lsmeans bcat*soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'ilvo models';
  *model ilvo15 = ilvo14
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo14 = ilvo13 
       / distribution=negbin link=log solution DDFM=residual;  
  *model ilvo13 = ilvo12 
       / distribution=negbin link=log solution DDFM=residual;  
  model ilvo12 = milvopre 
       / distribution=negbin link=log solution DDFM=residual; 
  output out=glmout2 resid=ehat;
run;


*****************bcat models;
proc glimmix data=seedsmerge2; title 'bcat models';
  class bcat;  
  model pita15 = bcat / distribution=negbin link=log solution DDFM=residual; 
  *model quma12 = bcat / distribution=negbin link=log solution DDFM=residual; 
  *model qum312 = bcat / distribution=negbin link=log solution DDFM=residual; 
  *model ilvo12 = bcat / distribution=negbin link=log solution DDFM=residual;  	
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;

*****************soil models;
proc glimmix data=seedsmerge2; title 'soil models'; 
  class soil;  
  *model pita15 = soil / distribution=negbin link=log solution DDFM=residual; 
  model quma15 = soil / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = soil / distribution=negbin link=log solution DDFM=residual; 
  *model milvopre = soil / distribution=negbin link=log solution DDFM=residual;  
  lsmeans soil / ilink cl;
  output out=glmout2 resid=ehat;
run; 

*****************caco models;
proc glimmix data=seedsmerge2; title 'caco models'; 
  *model pita15 = cov13 / distribution=negbin link=log solution DDFM=residual; 
  *model mqumapre = mcovpre / distribution=negbin link=log solution DDFM=residual; 
  *model qum315 = mcovpre / distribution=negbin link=log solution DDFM=residual; 
  model ilvo12 = mcovpre / distribution=negbin link=log solution DDFM=residual; 
  output out=glmout2 resid=ehat;
run; 


*work with NLF 7/28/15;
proc freq data=seedsmerge2; table soil*quma12; run;

proc sort data=seedsmerge2; by bcat soil; run;
proc means data=seedsmerge2 mean noprint; 
	by bcat soil; var pita15 quma15 qum315 ilvo15;
	output out=mout1 n=npita15 nquma15 nquma315 nilvo15;
run;
proc print data=mout1; run;

proc means data=seedsmerge2 mean noprint; 
	by bcat soil; var pita15 quma15 qum315 ilvo15;
	output out=mout2 mean=mpita15 mquma15 mquma315 milvo15;
run;
proc print data=mout2; run;

proc sort data=seedsmerge2; by bcat soil; run;
proc means data=seedsmerge2 n noprint; 
	by bcat soil; var mpitapre pita12 pita13 pita14;
	output out=mout1 n=npre n12 n13 n14;
run;
proc print data=mout1; run;

data seedsmerge3; set seedsmerge2;
	if mpitapre ^= . & pita12^=.;
run;
proc means data=seedsmerge3 mean noprint; 
	by bcat soil; var pita12;
	output out=mout1 mean=mpita mquma mquma3 milvo;
run;
proc freq data=seedsmerge3; table bcat*soil*plot; run;

proc means data=seedsmerge2 mean noprint; 
	by bcat; var pita12 quma12 quma312 ilvo12;
	output out=mout1 mean=mpita mquma mquma3 milvo;
run;
proc print data=mout1; run;

proc glimmix data=seedsmerge2; title 'bcat model';
  class bcat;  
  model milvopre = bcat / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'soil model';
  class soil;  
  model milvopre = soil / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;
