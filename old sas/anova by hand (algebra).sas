* ANOVA by hand, and comparison with output;

* create a data set with one fixed variable (alpha) and a random residual;
* true grand mean = 10;
* true group means = 5 and 15;
* true alphas = (10-5)  and (10-15) ;
data dat1; input tr $ mu alpha;
datalines;
a 10 5
a 10 5
a 10 5
a 10 5
a 10 5
a 10 5
b 10 -5
b 10 -5
b 10 -5
b 10 -5
b 10 -5
b 10 -5
;
data dat2; set dat1;
ytr = mu + alpha;  * still in truth;
sdev = 1.5;        * true standard deviation of residuals;
etrue = sdev * rannor(0);  
y = ytr + etrue;   * y is the created variable distributed ~N(5 or 15, .25);
proc print data=dat2;
run;
* never will see ytr, mu, alpha, etrue again;
data dat2x; set dat2;
  dummy=1;         * we will need dummy to calculate the anova;
  drop ytr sdev etrue mu alpha;
proc print data=dat2x;
run;

* calculate ANOVA and more;

proc means data=dat2x mean; 
  output out=grandmeanout mean=grandmean;
data grandmeanoutx; set grandmeanout; dummy = 1;
data dat3; merge dat2x grandmeanoutx; by dummy;
* proc print data=dat3;
proc means data=dat2x mean; by tr;
  output out=groupmeans mean=groupmean;
data dat4; merge dat3 groupmeans; by tr;
proc print data=dat4;
run; 

data dat5; set dat4;
grandmeansq = grandmean**2;            * for the hidden SSgrandmean;
ysq = y**2;                            * for the hidden SST;
yhat = groupmean;                      * because this is a one-way anova;
alphahat = grandmean - groupmean;      * because this is a one-way anova;
yhatlessgrandmean = yhat - grandmean;
yhatlessgrandmeansq = yhatlessgrandmean**2; * for the model SS;
ehat = y - yhat;
ehatsq = ehat**2;                      * for the SSE;
ylessgrandmean = y - grandmean;  
ylessgrandmeansq = ylessgrandmean**2;  * for the SSCT;
proc print data=dat5;
run;
proc means sum data=dat5;
  var grandmeansq ysq yhatlessgrandmeansq ehatsq ylessgrandmeansq;
run;
* sample output
 
grandmeansq            1220.04
ysq                    1598.84
yhatlessgrandmeansq     349.7820515
ehatsq                   29.0157452
ylessgrandmeansq        378.7977967;


* now compare with PROC GLM output;
* regular one-way anova;
proc glm data=dat5; class tr;
  model y = tr;
run;

* run as no-int to see the summed ysq = the uncorrected total SS;
* the grandmeansq + yhatlessgrandmeansq = the model SS of this model;
proc glm data=dat3; class tr;
  model y = tr / noint;
run;



