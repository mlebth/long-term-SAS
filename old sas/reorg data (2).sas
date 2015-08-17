data holdquma3; set numplantdatapo; if sspp = 'QUMA3'; nquma3 = nperspp; 
data holdqumax; set numplantdatapo; if sspp = 'QUMAx'; nqumax = nperspp;
data holdpitax; set numplantdatapo; if sspp = 'PITAx'; npitax = nperspp; 
data holdilvox; set numplantdatapo; if sspp = 'ILVOx'; nilvox = nperspp; 
data holdnonex; set numplantdatapo; if sspp = 'NONEx'; flag=1;

proc print data=holdquma3; var plot prpo sspp nquma3 nperspp; run; 

data reorg; merge holdquma3 holdqumax holdpitax holdilvox holdnonex; by plot prpo; * PUT YEAR BACK IN;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nilvox = .) then nilvox=0; if (nilvox=0) then pailvox=0; if (nilvox ^= 0) then pailvox=1; 
  if (flag NE 1) then flag = 0;
  keep plot prpo burn nquma3 nqumax npitax nilvox flag paquma3 paqumax papitax pailvox;  * dropping sspp & nperspp - become garbage;
proc print data=reorg; run;

proc glimmix data=reorg;
  class burn;
  model paquma3 = burn / dist = binomial solution;  * default to link=logit; 
  * plot is the replication; 
run;
* on obs missing burn.  therefore N = 60 plot-prpo combination;
* -2LL = 79.99  AIC = 87.99;  * penalty of 8 = 4 df * 2;  * X2/df = 1.07 - a very good fit;
*  logit (prob(quma3 present in burn1))  = -0.07411 -0.4367 = .51;

proc freq data=reorg; table paquma3*burn / chisq;
run;  * for burn1, p(present) = .375; * gives a lot of -.58;

proc univariate data=reorg plot; var nquma3 nqumax npitax nilvox;
run;

proc glimmix data=reorg;
  class burn;
  * model nquma3 = burn / dist=poisson link=log solution; * bad fit;
  model nquma3 = burn / dist=negbin link=log solution; 
  lsmeans burn / cl ilink;
run;
* poisson: X2/df = 57.63 very bad fit, -2LL = 2892.86, AIC = 2900.86; * N = 60, 1 obs not used;
* negbin: X2/df = 0.44. -2LL = 363.39, AIC = 373.39;
*  burn1: log(#) = 3.1499 - 4.1307 = -.9808, estimated value = exp(.9808) = .375
   burn2: log(#) = 3.1499 + .08599 = 3.23189, estimated value = 25.327;

data check; set reorg; logquma3 = log(nquma3);
proc sort data=check; by burn;
proc means data=check mean median; by burn; var nquma3;
run;


 

