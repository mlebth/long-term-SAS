
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

*11/29/15 import seedtree;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\seedtree.csv"
out=seedtree
dbms=csv replace; 
getnames=yes;
*proc print data=seedtree (firstobs=1 obs=10); title 'seedtree'; run;

**added 1/27/17--per GC, testing effects of rx burns on seedling counts;
*proc contents data=seedtree; run;
data seedtreenoburnhydro; set seedsmerge; drop hydr burnsev; run;
proc sort data=seedtreenoburnhydro; by plot; run;
proc sort data=hist; by plot; run;
data seedtreerx; merge seedtreenoburnhydro hist; by plot; run;
*proc contents data=seedtreerx; run;
data seedtreerx2; set seedtreerx; if lastrx = 9999 then rx=0; if lastrx NE 9999 then rx=1; run;
data seedsmerge3rx; set seedsmerge3;  if lastrx = 9999 then rx=0; if lastrx NE 9999 then rx=1; run;
proc contents data=seedsmerge3; run;

proc plot data=seedtree; plot qum312tr*mquma3pretr qum312tr*burnsev; run;
proc plot data=seedtree; plot pita15sd*burnsev pita15sd*pltd burnsev*pltd; run;
proc freq data=seedtree; tables pltd*burnsev; run;

*PITA;
proc glimmix data=seedsmerge3rx; title 'rx models';
	class  rx;
	*model mpitapre = rx / dist=negbin link=log solution DDFM=bw; *NS;
	model qust13sd = rx  / dist=negbin link=log solution DDFM=bw; *p=.0536, more in rx=1; *NS w/burnsev & soil;
	*model pita13 = rx / dist=negbin link=log solution DDFM=bw; *NS;
    *model pita14 = rx / dist=negbin link=log solution DDFM=bw; *NS;
	*model pita15 = rx soil burnsev / dist=negbin link=log solution DDFM=bw; *rx alone: .0022, more in rx=1;
		*NS when burnsev and soil are included;
	*model burnsev=rx; *NS;
	lsmeans rx / ilink cl;
	output out=glmout resid=ehat;
run;

*QUMA;
proc glimmix data=seedtree; title 'rx models';
	*class  rx;
	model quma14tr=quma13p / dist=negbin link=log solution DDFM=bw; 
	*model milvopre = rx / dist=negbin link=log solution DDFM=bw; *NS;
	*model ilvo12 = rx  / dist=negbin link=log solution DDFM=bw; *NS;
	*model ilvo13 = rx / dist=negbin link=log solution DDFM=bw; *NS;
    *model ilvo14 = rx / dist=negbin link=log solution DDFM=bw; *NS;
	*model ilvo15 = rx  / dist=negbin link=log solution DDFM=bw; *NS;
	*model burnsev=rx; *NS;
	*lsmeans rx / ilink cl;
	output out=glmout resid=ehat;
run;

*****************Interaction-only models (bcat*soil);
*PITA;
proc glimmix data=seedtree; title 'pita models';
  class burnsev soil; 
  *model pita14 = pita13 bcat*soil / distribution=negbin link=log solution DDFM=residual; 
  *model pita13 = pita12 bcat*soil / distribution=negbin link=log solution DDFM=residual;  
  model pita15 =  burnsev*soil / distribution=negbin link=log solution DDFM=residual;  
  lsmeans burnsev*soil / ilink cl;
  contrast '11 v 21 - effect of fire in sand' burnsev*soil 1 0 -1 0;
  contrast '21 v 22 - effect of soil in hifire' burnsev*soil 0 0 1 -1;
  contrast '11 v 12 - effect of soil in lofire' burnsev*soil 1 -1 0 0;
  contrast '12 v 22 - effect of fire in gravel' burnsev*soil 0 1 0 -1;
  output out=glmout2 resid=ehat;
run;

*QUMA;
proc glimmix data=seedsmerge3; title 'quma models';
  class bcat soil; 
  *model quma14 = qust13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model quma13 = quma12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  model quma12 = mqumapre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
output out=glmout2 resid=ehat;
run;

*QUMA3;
proc glimmix data=seedsmerge2; title 'quma3 models';
  *class  soil; 
  model qum314sd = cov12
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum313 = qum312 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *model qum312 = mquma3pre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  *lsmeans soil / ilink cl;
output out=glmout2 resid=ehat;
run;

*QUST;
proc glimmix data=seedtree ; title 'qust models';
	class soil;
	*model qust13sd = qust12sd / distribution=negbin link=log solution DDFM=bw; 
	*model qust15sd = pltd / distribution=negbin link=log solution DDFM=bw; 
	model mqustpresd = soil / distribution=negbin link=log solution DDFM=bw; 
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
proc glimmix data=seedsmerge3; title 'burnsev models';
  *class soil;  
  model qust12sd = cov12 / distribution=negbin link=log solution DDFM=residual; 
  *model mqumapre = burnsev / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = burnsev / distribution=negbin link=log solution DDFM=residual; 
  *model milvopre = burnsev / distribution=negbin link=log solution DDFM=residual;  
  *lsmeans soil / ilink cl; 
  *contrast 'burn: u/scorch v light' burnsev -1 1 0 0;  
  *contrast 'burn: scorch v mod' burnsev -1 0 1 0;
  *contrast 'burn: scorch v hi' burnsev -1 0 0 1;
  *contrast 'burn: light v mod' burnsev 0 -1 1 0;
  *contrast 'burn: light v hi' burnsev 0 -1 0 1;
  *contrast 'burn: mod v hi' burnsev 0 0 -1 1;
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
proc glimmix data=seedlings2; title 'soil models'; 
  class soil;  
 * model mpitapresd = soil / distribution=negbin link=log solution DDFM=bw; 
  model mqumapresd = soil / distribution=negbin link=log solution DDFM=residual; 
  *model mquma3pre = soil / distribution=negbin link=log solution DDFM=residual; 
  *model ilvo15 = soil / distribution=negbin link=log solution DDFM=residual; 
  output out=glmout2 resid=ehat;
  lsmeans soil / ilink cl; 
run; 

proc print data=seedtree; run;

*****************caco models;
proc glimmix data=seedtree; title 'caco models'; 
  *model pita12sd = cov12 / distribution=negbin link=log solution DDFM=residual; 
  *model quma13sd = cov12 / distribution=negbin link=log solution DDFM=residual; 
  model qum314sd = cov13 / distribution=negbin link=log solution DDFM=residual; 
  *model milvopre = caco / distribution=negbin link=log solution DDFM=residual;  
  *model qust15sd = mcovpre / distribution=negbin link=log solution DDFM=residual;
  output out=glmout2 resid=ehat;
run; 
