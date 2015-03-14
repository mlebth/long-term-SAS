*----------------PIQUIL MODELS;
*cover = burn year burn*year;
proc glm data=alld;
	class burn;
	model covm = burn year burn*year;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;
*9df, R-sq 0.700, p<0.0001;

/* proc univariate data=piquil2 plot; var nquma3 nqumax npitax nilvox;
run; */

*------------------pa models (presence/absence);
proc glimmix data=piquil2;
  class burn;
  model paquma3 = burn / dist = binomial solution;  * default to link=logit; 
  * plot is the replication; 
run;
*-2LL = 260.22  AIC = 270.22;  *penalty of 10 = 5 df * 2;  * X2/df = 1.01 - a very good fit;
*logit (prob(quma3 present in burn1))  = .04652 - 2.6115 = -2.56498;

*------------------n models (stem count);
proc glimmix data=piquil2;
  class burn;
  * model nquma3 = burn / dist=poisson link=log solution; * bad fit;
  model nquma3 = burn / dist=negbin link=log solution; 
  lsmeans burn / cl ilink;
run;
* poisson: X2/df = 57.63 very bad fit, -2LL = 2892.86, AIC = 2900.86; * N = 60, 1 obs not used;
* negbin: X2/df = 0.44. -2LL = 363.39, AIC = 373.39;
*  burn1: log(#) = 3.1499 - 4.1307 = -.9808, estimated value = exp(.9808) = .375
   burn2: log(#) = 3.1499 + .08599 = 3.23189, estimated value = 25.327;

proc glimmix data=piquil2;
  class soil;
  *model nquma3 = covm soil covm*soil/ dist=poisson link=log solution; 
  model nquma3 = covm soil/ dist=poisson link=log solution; 
  lsmeans soil/ cl ilink;
run; *X2=18.6, bad fit;

proc glm data=piquil2; 
	class soil;
	model nquma3 = covm soil covm*soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;

proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model nqumax = covm soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;

proc glimmix data=piquil2;
  class soil;
  *model nquma3 = covm soil covm*soil/ dist=poisson link=log solution; 
  model nqumax = covm soil/ dist=poisson link=log solution; 
  lsmeans soil/ cl ilink;
run;

proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model npitax = covm soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;

proc glimmix data=piquil2;
  class soil;
  *model nquma3 = covm soil covm*soil/ dist=poisson link=log solution; 
  model npitax= covm soil/ dist=poisson link=log solution; 
  lsmeans soil/ cl ilink;
run;

proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model ilvox = covm soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;


*-----------------relabund models;
proc glimmix data=logpiquil; title 'glimmix'; class burn prpo sspp;
	model nperplot = burn prpo sspp burn*sspp sspp*prpo burn*sspp*prpo/ dist = poisson;
	random residual / type = cs subject = plot(burn*sspp*prpo);
	lsmeans burn*sspp*prpo / ilink;
	output out=glimout pred=p resid=ehat;
run;
proc univariate data = glimout plot normal; var ehat; run;
* Shapiro-Wilk  W = 0.876522  p<0.0001;
* long left tail -- different transformation?;
