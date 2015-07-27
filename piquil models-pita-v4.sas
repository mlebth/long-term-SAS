proc glimmix data=seedsmerge2; title 'pita bcat soil caco bcat*soil';
  class bcat soil; 
  model pita14 = pita13 bcat soil caco bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 
  lsmeans bcat soil/ ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'pita13 bcat soil bcat*soil';
  class bcat soil; 
  model pita14 = pita13 bcat pita13*bcat
       / distribution=negbin link=log solution DDFM=residual;  * this works, scale = 0.2, xX2 = 1.14;
  output out=glmout2 resid=ehat;
run;

* alternate for unbalanced designs;
* if we drop bcat & soil, its variation falls into bcat*soil;
* if SIG, add appropriate constrasts;
proc glimmix data=seedsmerge2; title 'pita models';
  class bcat soil; 
  *model pita14 = pita13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.14, -2LL=122.61, AIC=134.61;
	    * pita13    df=41, F=26.11, p<.0001
          bcat*soil df=41, F=1.70,  p=0.1811;
  *model pita13 = pita12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.21, -2LL=98.66, AIC=110.66;
	    * pita13    df=27, F=30.93, p<.0001
          bcat*soil df=27, F=2.38,  p=0.09;
  model pita12 = mpitapre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=3.9, X2=.63, -2LL=75.21, AIC=85.21;
	    * pita13    df=13, F=1.07, p=0.3195
          bcat*soil df=13, F=.63,  p=0.5497;
output out=glmout2 resid=ehat;
run;

proc contents data=seedsmerge2; run;

proc glimmix data=seedsmerge2; title 'quma models';
  class bcat soil; 
  *model quma14 = quma13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.14, -2LL=122.61, AIC=134.61;
	    * pita13    df=41, F=26.11, p<.0001
          bcat*soil df=41, F=1.70,  p=0.1811;
  *model quma13 = quma12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.21, -2LL=98.66, AIC=110.66;
	    * pita13    df=27, F=30.93, p<.0001
          bcat*soil df=27, F=2.38,  p=0.09;
  model quma12 = mqumapre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=3.9, X2=.63, -2LL=75.21, AIC=85.21;
	    * pita13    df=13, F=1.07, p=0.3195
          bcat*soil df=13, F=.63,  p=0.5497;
output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'quma3 models';
  class bcat soil; 
  *model qum314 = qum313 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.14, -2LL=122.61, AIC=134.61;
	    * pita13    df=41, F=26.11, p<.0001
          bcat*soil df=41, F=1.70,  p=0.1811;
  *model qum313 = qum312 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.21, -2LL=98.66, AIC=110.66;
	    * pita13    df=27, F=30.93, p<.0001
          bcat*soil df=27, F=2.38,  p=0.09;
  model qum312 = mquma3pre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=3.9, X2=.63, -2LL=75.21, AIC=85.21;
	    * pita13    df=13, F=1.07, p=0.3195
          bcat*soil df=13, F=.63,  p=0.5497;
output out=glmout2 resid=ehat;
run;

proc glimmix data=seedsmerge2; title 'ilvo models';
  class bcat soil; 
  *model ilvo14 = ilvo13 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.14, -2LL=122.61, AIC=134.61;
	    * pita13    df=41, F=26.11, p<.0001
          bcat*soil df=41, F=1.70,  p=0.1811;
  *model ilvo13 = ilvo12 bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=0.2, X2=1.21, -2LL=98.66, AIC=110.66;
	    * pita13    df=27, F=30.93, p<.0001
          bcat*soil df=27, F=2.38,  p=0.09;
  model ilvo12 = milvopre bcat*soil
       / distribution=negbin link=log solution DDFM=residual;  
  		* this works, scale=3.9, X2=.63, -2LL=75.21, AIC=85.21;
	    * pita13    df=13, F=1.07, p=0.3195
          bcat*soil df=13, F=.63,  p=0.5497;
  contrast 'bcat*soil' bcat*soil 1 -1;	
  output out=glmout2 resid=ehat;
run;




proc plot data=seedsmerge2; title 'pita*caco'; 
	plot pita14*caco; 
	plot pita13*caco; 
	plot pita12*caco; 
	plot mpitapre*caco; 
run;

proc glimmix data=seedsmerge2; title 'model';
  * class bcat soil; 
  model pita14 = caco
       / distribution=negbin link=log solution DDFM=residual;  
  output out=glmout2 resid=ehat;
run;
