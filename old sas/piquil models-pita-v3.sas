proc print data=seedsmerge1; run;
proc print data=seedsmerge2; run;
proc freq data=seedsmerge2; tables pita11*plot; run; *no data for 2011 (seedlings);
proc freq data=seedsmerge2; tables bcat; run; 

*-----------------testing collinearity and correlation between burn severity and canopy cover;
proc plot data=seedsnozero;  plot caco*bcat; run;

ods graphics on; 
* exploration of relationship between caco & bcat;
proc corr spearman data=seedsmerge2 sscp cov plots; title 'caco/bcat correlation'; 
var caco; with bcat;  * canopy cover with burn severity;  * bcat is ordinal;
run;
ods graphics off;
* Pearson correlation coefficient = -0.71846, p <.0001, N=46
Negative correlation (higher burn severity, lower canopy cover);

* more exploration of relationship between caco & bcat;
proc glm data=seedsmerge2; title 'caco/bcat'; 
	class bcat;
	model caco=bcat / tolerance;
	lsmeans bcat / stderr cl;  * expected mean of each level of the variable bcat, with std error & conf limits;
	contrast 'level0 v level1' bcat  1 -1 0;  * compare first and second levels;
	* regular output compares each level with last-in-alphabet-numeric level;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;

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

*backwards;
* not enough df for three-way, due to imbalance in design;
* plot is lowest level of the design (for this variable), so defaults to being the residual
       - assuming each plot has a unique id and/or its own data line;
proc glimmix data=seedsmerge2; title 'model';
  class bcat soil;  * caco is continuous; * mpitapre is pre-fire;
  * model1; * model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*bcat caco*soil
       / distribution=negbin link=log solution DDFM=bw; 
  * model nlf11a;  model pita14 = pita13 bcat soil caco bcat*soil
       / distribution=negbin link=log solution DDFM=residual; 

  *model2; *model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*bcat caco*soil  caco*bcat*soil
       / distribution=normal link=identity solution DDFM=bw; 
  * model3; * model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*bcat caco*soil  pita13*bcat*soil 
       / distribution=normal link=identity solution DDFM=bw;    
  *model4; *model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*bcat caco*soil 
  		/ distribution=negbin solution DDFM=bw;  *-2LL--166, X2/df=.71;
  *model5; *model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*bcat 
		/ distribution=negbin solution DDFM=bw;  * 163, .69;
  *model6; *model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*soil 
		/ distribution=negbin solution DDFM=bw;  *163, .69;
  *model7; *model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat caco*bcat caco*soil 
		/ distribution=poisson solution DDFM=bw;  *163, .67, negbin did not converge;
  *model8; *model pita14 = pita13 bcat soil caco bcat*soil pita13*soil caco*bcat caco*soil 
		/ distribution=negbin solution DDFM=bw;  *162, .73;
  *model9; *model pita14 = pita13 bcat soil caco pita13*bcat pita13*soil caco*bcat caco*soil 
		/ distribution=poisson solution DDFM=bw;  *171, .70;
  * lsmeans bcat soil bcat*soil / ilink cl;
  output out=glmout2 resid=ehat;
run;

proc glm data=seedsmerge2; title 'glm';
  class plot bcat soil;
  model pita14 = pita13 bcat soil caco bcat*soil pita13*bcat pita13*soil caco*bcat caco*soil  pita13*bcat*soil;
  lsmeans bcat soil /  cl;
  output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; * var ehat; var pita14; run;

 proc freq data=seedsmerge2; table soil*bcat; run;

*forward;
*variables of interest: caco, bcat, soil, prev. year;
proc glimmix data=seedsmerge2; title 'model';
  class plot bcat;  * caco is continuous; * mpitapre is pre-fire;  
  *model pita14 = pita13 bcat / distribution=negbin solution DDFM=bw;  	*154, .82; *dendf=0;
  	*caco and soil are not significant in any model;
  model pita14 = pita13 bcat / distribution=negbin solution DDFM=residual;  	
  	*154, .82; *pita 1/43/41.93/<0.00001    bcat 1/43/.62/.4364;
  	*this one's better, df makes more sense;
  *model pita14 = pita13 bcat / distribution=negbin solution DDFM=kr;  	
  	*154, .82; *pita 1/12.36/41.08/<0.0001  bcat 1/30.85/.6/.4446;
  *model pita14 = pita13 bcat / distribution=negbin solution DDFM=satterth;  	
  	*154, .82; *pita 1/12.36/41.93/<0.0001 bcat 1/30.85/.62/.4381;

  *model pita14 = pita13 bcat pita13*bcat/ distribution=poisson solution DDFM=residual;  
  *model pita14 = pita13 bcat pita13*bcat/ distribution=poisson solution DDFM=contain;  
  *model pita14 = pita13 bcat pita13*bcat/ distribution=poisson solution DDFM=kr;   
  *model pita14 = pita13 bcat pita13*bcat/ distribution=poisson solution DDFM=satterth;  
  random plot(bcat);
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;



*pita13;
*forward;
*variables of interest: caco, bcat, soil, prev. year;
proc glimmix data=seedsmerge2; title 'model';
  class plot bcat soil;  * caco is continuous; * mpitapre is pre-fire;  
  model pita13 = pita12 bcat soil/ distribution=negbin solution DDFM=residual; 
  random plot(bcat*soil);
  lsmeans bcat soil / ilink cl;
  output out=glmout2 resid=ehat;
run;

*pita12;
*forward;
*variables of interest: caco, bcat, soil, prev. year;
proc glimmix data=seedsmerge2; title 'model';
  class plot  soil;  * caco is continuous; * mpitapre is pre-fire;  
  model pita12 = soil / distribution=normal solution DDFM=residual; 
  random plot(soil);
  lsmeans  soil / ilink cl;
  output out=glmout2 resid=ehat;
run;







*------------------------------------------------------------------------------------------------;

* nlf pretend:  nothing is signficant except caco*soil, and we want the slopes and intercepts;
proc glimmix data=seedsmerge1; title 'seedsmerge1';
  class plot soil;  * caco is continuous; * mpit is pre-fire;
  * model pita14 = soil caco caco*soil
       / distribution=normal link=identity solution DDFM=bw;        * final model;
  model pita14 = soil soil*caco
       / noint distribution=normal link=identity solution DDFM=bw;  * model ONLY for getting intercepts and slopes, IGNORE p-values;
  * by making it noint, betas of soil will be true intercepts;
  * by taking out caco, betas of caco*soil will be true slopes;
  * you could find these beta with appropriate addition of the solution betas of full model;
  random plot(bcat*soil) / subject=plot;
run;

* nlf pretend: nothing is signficant except caco*bcat*soil, and we want the slopes and intercepts
proc glimmix data=seedsmerge1; title 'seedsmerge1';
  class plot soil;  * caco is continuous; * mpit is pre-fire;
  * model pita14 = soil caco bcat soil*caco soil*bcat caco*bcat soil*bcat*caco
       / distribution=normal link=identity solution DDFM=bw;        * final model;
  model pita14 = soil*bcat soil*bcat*caco
       / noint distribution=normal link=identity solution DDFM=bw;  * model ONLY for getting intercepts and slopes, IGNORE p-values;
  random plot(bcat*soil) / subject=plot;
run;

* general rule: if a higher order interaction is present, component lower-order interactions must also be 
   present (among other reasons) so that the higher-order interaction is interpretable; 
