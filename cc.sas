data post; set alld; if year > 2010; run;
proc print data=post (firstobs=10108 obs=10110); run;

proc glm data=alld;
	class burn;
	model covm = burn year burn*year;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;
*Model: 9df, R-sq 0.700, p<0.0001;

proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model nquma3 = covm soil covm*soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;

proc glimmix data=piquil2;
  class soil;
  *model nquma3 = covm soil covm*soil/ dist=poisson link=log solution; 
  model nquma3 = covm soil/ dist=poisson link=log solution; 
  lsmeans soil/ cl ilink;
run;


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












data herb; set alld; if subp = 'herb'; run;
proc genmod data=herb; 
	class soil sspp;
	model sspp = covm soil covm*soil;
  	output reslik=ehat out=glmout1;
run; 
proc univariate data=glmout1 plot normal; var ehat; run;

proc glimmix data = piquil2; title 'pita glimmix'; class soil;
	model papitax = soil covm soil*covm / dist = binomial;
	random residual / subject = plot(soil);
	lsmeans soil / ilink;
	output out=glimout pred=p resid=ehat;
run; 
proc univariate data=glimout plot normal; var ehat; run;

proc glimmix data = piquil2; title 'quma3 glimmix'; class soil;
	model nquma3 = soil covm soil*covm;
	random residual / subject = plot(soil);
	lsmeans soil / ilink;
	output out=glimout pred=p resid=ehat;
run; 
proc univariate data=glimout plot normal; var ehat; run;
*did not converge;
proc glm data=piquil2; title 'papitax glm';
	model papitax = covm / type1 type3;
  	output reslik=ehat out=glmout1;
run;
proc univariate data=glmout1 plot normal; var ehat; run;



proc glimmix data = piquil2; title 'quma glimmix'; class soil;
	model paqumax = soil covm soil*covm / dist = binomial;
	random residual / subject = plot(soil);
	lsmeans soil / ilink;
	output out=glimout pred=p resid=ehat;
run; 
proc univariate data=glimout plot normal; var ehat; run;
*did not converge;

proc glimmix data = piquil2; title 'ilvo glimmix'; class soil;
	model pailvox = soil covm soil*covm / dist = binomial;
	random residual / subject = plot(soil);
	lsmeans soil / ilink;
	output out=glimout pred=p resid=ehat;
run; 
proc univariate data=glimout plot normal; var ehat; run;
*did not converge;
