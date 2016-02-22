*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set piquil2; if sspp = 'QUMA3'; nquma3 = nperspp; 
data holdqumax; set piquil2; if sspp = 'QUMAx'; nqumax = nperspp;
data holdpitax; set piquil2; if sspp = 'PITAx'; npitax = nperspp; 
data holdilvox; set piquil2; if sspp = 'ILVOx'; nilvox = nperspp; 
run;
/* proc print data=holdquma3; run; 
proc print data=holdqumax; run; 	
proc print data=holdpitax; run; 	
proc print data=holdilvox; run; */

*n(spp) is count, pa(spp) is presence/absence;
data piquil2; merge holdquma3 holdqumax holdpitax holdilvox; by plot year;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nilvox = .) then nilvox=0; if (nilvox=0) then pailvox=0; if (nilvox ^= 0) then pailvox=1; 
  drop _TYPE_ _FREQ_ sspp nperspp;  * dropping sspp & nperspp - become garbage;
run;
/* proc print data=piquil2; run; *N = 208; */

proc glimmix data=piquil2;
  class burn;
  model paquma3 = burn / dist = binomial solution;  * default to link=logit; 
  * plot is the replication; 
run;
*-2LL = 260.22  AIC = 270.22;  *penalty of 10 = 5 df * 2;  * X2/df = 1.01 - a very good fit;
*logit (prob(quma3 present in burn1))  = .04652 - 2.6115 = -2.56498;

proc univariate data=piquil2 plot; var nquma3 nqumax npitax nilvox;
run;

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
