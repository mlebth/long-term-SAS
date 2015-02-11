proc glm data=alld;
	class prpo burn;
	model covm = prpo burn;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;

proc univariate data=alld plot; var covm; run;

proc glimmix data = piquil2; title 'pita glimmix'; class soil;
	model papitax = soil covm soil*covm / dist = binomial;
	random residual / subject = plot(soil);
	lsmeans soil / ilink;
	output out=glimout pred=p resid=ehat;
run; 
proc univariate data=glimout plot normal; var ehat; run;

proc glimmix data = piquil2; title 'quma3 glimmix'; class soil;
	model paquma3 = soil covm soil*covm / dist = binomial;
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
