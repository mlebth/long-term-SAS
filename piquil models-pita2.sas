proc print data=seedsmerge1; run;
proc print data=seedsmerge2; run;
proc freq data=seedsmerge2; tables pita11*plot; run; *no data for 2011 (seedlings);
proc freq data=seedsmerge2; tables bcat*plot; run; *no data for 2011 (seedlings);

*testing collinearity and correlation between burn severity and canopy cover;
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
(smaller tolerance, greater vif = more collinearity--vif=1/tolerance);;
proc reg data=seedsmerge2;
      model caco=bcat / tol vif collin;
run;

proc plot data=seedsmerge2;  plot caco*bcat; run;

*---------------------------------------------------------------------------;

proc glimmix data=seedsmerge2; title 'seedsmerge2 bcat';
  class plot soil ;
  *model pita14 = mpitapre pita12 pita13 / distribution=normal link=identity solution DDFM=bw;
  *model pita14 = mpitapre pita12 pita13 bcat soil / distribution=normal link=identity solution DDFM=bw;
  *model pita14 = mpitapre pita12 pita13 bcat soil bcat*soil/ distribution=normal link=identity solution DDFM=bw;
  model pita14 = pita13 caco soil / distribution=normal link=identity solution DDFM=bw;
  *random plot(soil) / subject=plot;
  *lsmeans soil / ilink cl;
  output out=glmout2 resid=ehat;
run;  

proc plot data=mout2; 
  plot pita14*pita13; 
run;
