*copied from iml piquil;
proc glm data=seedpairs; title 'seedpairs glm'; 
	model pita2 = covm2 covm2*pita1;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat pita2; run; *not even close to normal;
proc freq data=seedpairs; tables bcat1 *plot; run;

/*
ods html;
proc sgplot data=seedpairs;
	scatter y=covm2 x=pita2 /group=soil name="data";
	keylegend "data"/ title="group";
run;
ods html close;
*/

proc glimmix data=seedpairs; title 'seedpairs glimmix';
  class plot bcat1;
  model pita2 =  covm1 bcat1 / distribution=normal DDFM=bw; *removed DDFM=KR;
  random plot(bcat1) / subject=plot;
  *lsmeans bcat1 / ilink cl;
  output out=glmout2 resid=ehat;
run;  

*copied from  piquil models;
proc glimmix data=seedpairs; title 'nilvox';
  class bcat1 soil plot;
  model pita2 = plot pita1 soil bcat1 soil*bcat1/ dist=normal link=identity solution; *-2LL=1152.89, AIC=1162.89.59, X2/df=0.84;
  random plot(bcat1);
run;

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
