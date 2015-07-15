proc print data=seedsmerge1; run;
proc print data=seedsmerge2; run;
proc freq data=seedsmerge2; tables pita11*plot; run; *no data for 2011 (seedlings);
proc freq data=seedsmerge2; tables pita14*plot; run; 

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
proc glimmix data=seedsmerge1; title 'seedsmerge1';
  class plot bcat soil ;
  *model pita = mpit / distribution=normal link=identity solution DDFM=bw;
  model pita =  year bcat soil caco bcat*soil*caco/ distribution=normal link=identity solution DDFM=bw; * PROBLEM: pools 3 two-ways with the 3-way;
  *model pita = mpit bcat soil bcat*soil/ distribution=normal link=identity solution DDFM=bw;
  *model pita = mpit caco soil / distribution=normal link=identity solution DDFM=bw;
  random plot(bcat*soil) / subject=plot;
  lsmeans bcat soil / ilink cl;
  output out=glmout2 resid=ehat;
run;

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
proc glimmix data=seedsmerge1; title 'seedsmerge1';
  class plot bcat soil;  * caco is continuous; * mpit is pre-fire;
  model pita14 = pita13 bcat soil caco bcat*soil  pita13*bcat pita13*soil caco*bcat caco*soil  pita13*bcat*soil caco*bcat*soil;
       / distribution=normal link=identity solution DDFM=bw; 
  random plot(bcat*soil) / subject=plot;
  lsmeans bcat soil bcat*soil / ilink cl;
  output out=glmout2 resid=ehat;
run;


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

proc glimmix data=seedsmerge2; title 'seedsmerge2';
  class plot bcat soil ;
  *model pita14 = mpitapre pita12 pita13 / distribution=normal link=identity solution DDFM=bw;
  model pita14 =  mpitapre pita12 pita13 bcat soil caco/ distribution=normal link=identity solution DDFM=bw;
  *model pita14 = mpitapre pita12 pita13 bcat soil bcat*soil/ distribution=normal link=identity solution DDFM=bw;
  *model pita14 = pita13 caco soil / distribution=normal link=identity solution DDFM=bw;
  random plot(bcat*soil) / subject=plot;
  lsmeans bcat soil / ilink cl;
  output out=glmout2 resid=ehat;
run;  

proc plot data=mout2; 
  plot pita14*pita13; 
run;
