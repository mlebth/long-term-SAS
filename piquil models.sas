*----------------PIQUIL MODELS;
*cover = burn year burn*year;
proc glm data=alld;	title 'cover';
	class burn;
	model covm = burn year burn*year;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;
*9df, R-sq 0.700, p<0.0001;

/* proc univariate data=piquil2 plot; var nquma3 nqumax npitax nilvox;
run; */

*------------------pa models (presence/absence);
proc glimmix data=piquil2; title 'paquma3';
  class burn;
  model paquma3 = burn / dist = binomial solution;  * default to link=logit; 
  * plot is the replication; 
run;
*-2LL = 260.22  AIC = 270.22;  *penalty of 10 = 5 df * 2;  * X2/df = 1.01 - a very good fit;
*logit (prob(quma3 present in burn1))  = .04652 - 2.6115 = -2.56498;

/*
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


proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model npitax = covm soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;

proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model ilvox = covm soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;

*/

*------------------n models (stem count);
proc glimmix data=piquil2; title 'nquma3/burn';
  class burn;
  * model nquma3 = burn / dist=poisson link=log solution; * bad fit;
  model nquma3 = burn / dist=negbin link=log solution; 
  lsmeans burn / cl ilink;
run;
* poisson: X2/df = 57.63 very bad fit, -2LL = 2892.86, AIC = 2900.86; * N = 60, 1 obs not used;
* negbin: X2/df = 0.44. -2LL = 363.39, AIC = 373.39;
*  burn1: log(#) = 3.1499 - 4.1307 = -.9808, estimated value = exp(.9808) = .375
   burn2: log(#) = 3.1499 + .08599 = 3.23189, estimated value = 25.327;


*soil = soil type (sand = fine sand, gfsl = gravelly fine sandy loam, 
						  fslo = fine sandy loam, lfsa = loamy fine sand, loam = loam);

proc glimmix data=piquil2; title 'nquma3/soil';
  class soil;
  *model nquma3 = covm soil covm*soil/ dist=poisson link=log solution; 	*-2LL=2262.07, AIC=2274, X2/df=18.85;
  model nquma3 = covm soil/ dist=negbin link=log solution;  *-2LL=712.44, AIC=722.44, X2/df=0.82;
  *model nquma3 = covm soil covm*soil/ dist=negbin link=log solution;  *-2LL=712.44, AIC=726.44, X2/df=0.84;
  lsmeans soil/ cl ilink;
run; 
*  fslo: log(#) = 1.522 - 15.82 = -14.298, estimated value = exp(-14.298) > 0.0001
   gfsl: log(#) = 1.522 + 1.0276 = 2.549, estimated value = 12.794
   sand (int): log(#) = 1.522 estimated value = 4.58
   cover: log(#) = 1.522 - 0.00655 = 1.515 estimated value = 4.549;

proc glimmix data=piquil2; title 'nqumax';
  class soil;
  *model nqumax = covm soil covm*soil/ dist=poisson link=log solution; *AIC=1615.62, X2/df=13.31;
  *model nqumax = covm soil covm*soil/ dist=negbin link=log solution; *-2LL=603.14, AIC=617.14, X2/df=0.81; 
  model nqumax = covm soil/ dist=negbin link=log solution; *-2LL=603.63, AIC=613.63, X2/df=0.84;
lsmeans soil/ cl ilink;
run; 

proc glimmix data=piquil2; title 'npitax';
  class soil;
  *model npitax = covm soil covm*soil/ dist=poisson link=log solution; 
  model npitax= covm soil covm*soil/ dist=negbin link=log solution; *-2LL=653.13, AIC=667.13, X2/df=1.12;
  *model npitax= covm soil/ dist=negbin link=log solution; *-2LL=653.59, AIC=663.59, X2/df=1.16;
  lsmeans soil/ cl ilink;
run;

proc glimmix data=piquil2; title 'nilvox';
  class soil;
  *model nilvox = covm soil covm*soil/ dist=poisson link=log solution; 
  *model nilvox= covm soil covm*soil/ dist=negbin link=log solution; *-2LL=1151.93, AIC=1165.93, X2/df=0.86;
  model nilvox= covm soil/ dist=negbin link=log solution; *-2LL=1152.89, AIC=1162.89.59, X2/df=0.84;
  lsmeans soil/ cl ilink;
run;


*-----------------relabund models;
proc glimmix data=logpiquil; class burn prpo sspp;
	model nperplot = burn prpo sspp burn*sspp sspp*prpo burn*sspp*prpo/ dist = poisson;
	random residual / type = cs subject = plot(burn*sspp*prpo);
	lsmeans burn*sspp*prpo / ilink;
	output out=glimout pred=p resid=ehat;
run;
proc univariate data = glimout plot normal; var ehat; run;
* Shapiro-Wilk  W = 0.876522  p<0.0001;
* long left tail -- different transformation?;
