proc print data=seedsmerge1; run;
proc print data=seedsmerge2; run;
proc freq data=seedsmerge2; tables pita11*plot; run; *no data for 2011 (seedlings);
proc freq data=seedsmerge2; tables pita14*plot; run; 

*-----------------testing collinearity and correlation between burn severity and canopy cover;
proc plot data=seedsnozero;  plot caco*bcat; run;

ods graphics on; 
proc corr data=seedsmerge2 sscp cov plots; title 'caco/bcat correlation'; 
var caco; with bcat;
run;
ods graphics off;
* Pearson correlation coefficient = -0.71846, p <.0001, N=46
Negative correlation (higher burn severity, lower canopy cover);

*glm can calculate tolerance;
proc glm data=seedsmerge2; title 'caco/bcat'; 
	class bcat;
	model caco=bcat / tolerance;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;
*                    Type I         Type II
Variable            Tolerance       Tolerance
Intercept                  46              31
bcat 1                      1               1
bcat 2           3.977852E-16               0
poor model fit thoug, R2= .51;

*reg can do tolerance, vif and collinearity statistics but can't use categorical variables
(smaller tolerance, greater vif = more collinearity--vif=1/tolerance)
--removed 2 bcat-0 plots for test, still no good though;
data seedsnozero; set seedsmerge2; if bcat^=0; run;	*N=53;
proc reg data=seedsnozero;
      model caco=bcat / tol vif collin;
run;


*---------------------------------------------------------------------------;
proc glimmix data=seedsmerge1; title 'seedsmerge1';
  class plot bcat soil ;
  *model pita = mpit / distribution=normal link=identity solution DDFM=bw;
  model pita =  year bcat soil caco bcat*soil*caco/ distribution=normal link=identity solution DDFM=bw;
  *model pita = mpit bcat soil bcat*soil/ distribution=normal link=identity solution DDFM=bw;
  *model pita = mpit caco soil / distribution=normal link=identity solution DDFM=bw;
  random plot(bcat*soil) / subject=plot;
  lsmeans bcat soil / ilink cl;
  output out=glmout2 resid=ehat;
run; 

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
