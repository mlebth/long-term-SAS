
proc glimmix data=seedsmerge2; title 'model';
  *class plot bcat;
  model quma12 = mqumapre caco/ distribution=negbin solution DDFM=bw;
    *caco and soil are not significant in any model;
  *random plot(bcat);
  *lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;
proc print data=seedsmerge2; run;
proc contents data=seedsmerge2; run;

*---------------------------------------------------------------------------;
* nlf recommended;  
* 2way interaction: bcat*soil - does the effect of soil depend on bcat level, does the effect of bcat depend on the soil level?;
* slope differences: pita13*bcat pita13*soil caco*bcat caco*soil - does the pita13 slope differ among bcat levels? etc;
* slope differences: pita13*bcat*soil caco*bcat*soil - does the pita13 slope differ among bcat-soil combinations? etc.;
* start with almost-complete model and drop terms from the highest order backwards;
* if the 3rd order is kept, then keep the 2nd order terms that "compose" it;
* example: if caco*bcat*soil is sig, then keep caco*bcat, caco*soil, & bcat*soil - but not pita terms; 
* also if 2nd order is signficant, keep the 1st order than compose it;
* we do this so the P values are interpretable;
* nlf suggests ignore all "interactions" of continuous*continuous variable  - ignore pita13*caco, ignore all terms that
      include pita13*caco, let their SS be pooled with residual;

*forward 2014;
*variables of interest: caco, bcat, soil, prev. year;
proc glimmix data=seedsmerge2; title 'model';
  class plot bcat soil;  
  model quma14 = quma13 bcat soil quma13*soil bcat*soil quma13*bcat*soil/ distribution=normal solution DDFM=residual;
  	*caco and soil are not significant in any model;
  random plot(bcat*soil);
  lsmeans bcat soil bcat*soil / ilink cl;
  output out=glmout2 resid=ehat;
run;

*forward 2013;
*variables of interest: caco, bcat, soil, prev. year;
proc glimmix data=seedsmerge2; title 'model';
  class plot bcat;  
  model quma13 = bcat quma12 
		/ distribution=normal solution DDFM=residual;
  	*caco and soil are not significant in any model;
  random plot(bcat);
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat; 
run; 







*forward 2012;
*variables of interest: caco, bcat, soil, prev. year;
proc glimmix data=seedsmerge2; title 'model';
  class plot soil;  
  model quma12 = soil / distribution=normal solution DDFM=bw;
  	*caco and soil are not significant in any model;
  random plot(soil);
  lsmeans soil / ilink cl;
  output out=glmout2 resid=ehat;
run;

