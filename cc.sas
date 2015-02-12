data post; set alld; if year > 2010; run;
proc print data=post (firstobs=10108 obs=10110); run;

proc glm data=alld;
	class burn prpo;
	model covm = burn year burn*prpo;
	lsmeans burn*prpo;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;

proc glm data=piquil2; 
	class soil;
	*model nquma3 = covm soil covm*soil;
	model nquma3 = covm soil;
	output out=glmout2 r=ehat;
run; 
proc univariate data=glmout2 plot normal; var ehat; run;



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
