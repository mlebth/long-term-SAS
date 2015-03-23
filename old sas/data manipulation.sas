*--------------------------PIQUIL (Pinus-Quercus-Ilvo): relative abundances------------------------;
* getting number of individuals per species, per year and plot.
  ilvo from shrubs and problem seedlings. qu, pi from seedlings and problem shrubs. none are measured 2 ways in any given plot/year. 
  no transect data. ;
proc sort data=piquil; by plot sspp year burn prpo covm soil elev slope aspect hydr; run;
proc means data=piquil noprint sum; by plot sspp year burn prpo covm soil elev slope aspect hydr; var coun; 
  output out=numplantdata sum=nperspp;
/* proc print data=numplantdata; title 'pi-qu-il numplantdata'; 
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* N = 442 species-plot-year combinations;
* numplantdata contains: obs, plot, sspp, year, burn, prpo, covm, soil, elev, slope, aspect, hydr, nperspp
  nperspp = # of sdlngs/stems per species per plot/year;  */

*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set numplantdata; if sspp = 'QUMA3'; nquma3 = nperspp; 
data holdqumax; set numplantdata; if sspp = 'QUMAx'; nqumax = nperspp;
data holdpitax; set numplantdata; if sspp = 'PITAx'; npitax = nperspp; 
data holdilvox; set numplantdata; if sspp = 'ILVOx'; nilvox = nperspp; 
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

/* *This was done before above reorganization of data to eliminate need for sspp and nperspp;
*getting to relative abundances;

proc sort data=numplantdata; by plot burn prpo;
proc means data=numplantdata noprint sum; by plot burn prpo; var nperspp; 
	output out=numperplot sum=nperplot;
proc print data=numperplot; title 'totals per plot'; var plot burn prpo nperplot; run;   
* N = 84 plot-prpo combinations;
* numperplot contains: obs, plot, burn, prpo, nperplot
  nperplot = # of all sdlngs in the plot;

*merging to get both nperspp and nperplot in same dataset;
proc sort data = numperplot; by plot burn prpo;
data numperplot2; merge numplantdata numperplot; by plot burn prpo; run;
proc print data = numperplot2; title 'numperplot2'; run; 
*back to N=342;
*numperplot2 contains: obs, plot, year, sspp, burn, prpo, nperspp, nperplot;

*calculting relative abundance of each species in each plot/yr combo;

data relabund; set numperplot2;	
	relabun = nperspp / nperplot; 
proc print data = relabund; title 'relative abundance'; run;
*numperplot3 contains: obs, plot, year, sspp, burn, prpo, nperspp, nperplot, relabun;

* which are the most common spp?;
proc sort data=relabund; by sspp;
proc means data=relabund sum noprint; by sspp; var nperspp;
  output out=spptotals sum=spptot; title 'species counts'; 
proc print data=spptotals; run;
* SPECIES: count (in # of plot-year-burn combos):
ILVO: 8115 (148), QUMA3: 1332 (94), PITA: 1125 (105), QUMA: 955 (95)
---more ILVO total and occurs in more plot combos;

*freq of spp in burnsev cats, prpo cats. fisher: p-value calc takes too long, freezes system;
proc freq data=relabund; tables sspp*burn; run;
proc freq data=relabund; tables sspp*prpo; run;
*/

*------------------------------piquil models;
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






proc univariate data=relabund plot normal; run;
*Shapiro-Wilk: 0.825349, P < 0.0001. 
Lognormally distributed, create new variable with transformed data;

data logpiquil; set relabund;
	logabund = log(relabun);
run;
proc print data = logpiquil; run;

proc glimmix data=logpiquil; title 'glimmix'; class burn prpo sspp;
	model nperplot = burn prpo sspp burn*sspp sspp*prpo burn*sspp*prpo/ dist = poisson;
	random residual / type = cs subject = plot(burn*sspp*prpo);
	lsmeans burn*sspp*prpo / ilink;
	output out=glimout pred=p resid=ehat;
run;
proc univariate data = glimout plot normal; var ehat; run;
* Shapiro-Wilk  W = 0.876522  p<0.0001;
* long left tail -- different transformation?;


/* *adapted from last 2013-2014 analyses, use as reference;

proc genmod data=logpiquil; title 'genmod'; class burn prpo sspp;
	model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo / type1 type3;
    lsmeans sspp*burn*prpo;
  	output reslik=ehat out=glmout1;
run;
proc univariate data=glmout1 plot normal; var ehat; run;

proc glm data=logpiquil; title 'glm'; class burn prpo sspp;
  model logabund = burn prpo sspp sspp*burn sspp*prpo prpo*burn sspp*burn*prpo;
  lsmeans sspp*burn*prpo / stderr;
  output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat; run;

proc glimmix data=logpiquil; title 'glimmix'; class burn prpo sspp;
	model npersppo = burn prpo sspp burn*sspp sspp*prpo burn*sspp*prpo/ dist = poisson;
	random residual / type = cs subject = plot(burn*sspp*prpo);
	lsmeans burn*sspp*prpo / ilink;
run;

*/

*---------------------old hydro analyses....
	allburn doesn't exist anymore--came from data step like this:
	data allburn set shrub
  	if (burnsev='l'|burnsev='m'|burnsev='h')
can recreate by repeating with a current dataset of interest merged with hist2;

proc genmod data=allburn; class burnsev hydromulch;
  model totpita =  hydromulch burnsev / dist = negbin link=log type1 type3;
run;

proc genmod data=allburn; class burnsev hydromulch;
	model totpita =  hydromulch burnsev hydromulch*burnsev/	dist = negbin link=log type1 type3;
* interaction NS;
run;
* oak; 
proc genmod data=allburn; class burnsev hydromulch;
	model totquma = burnsev hydromulch / dist = poisson link=log type1 type3;
run;
* type 3 burnsev df=2 X2=3.71 P = 0.1567
         hydromulch  df=2  X2=10.91 P=0.0043;

proc genmod data=allburn; class burnsev hydromulch;
	model totquma = burnsev hydromulch  burnsev*hydromulch/ dist = poisson link=log type1 type3;
run;
* use this - note type 1 not type 3 - no type3 reported.
* type 1 burnsev df=2 X2=3.66 P = 0.1603
         hydromulch  df=2  X2=10.91 P=0.0043
         int df=3 X2=17.59 P = 0.0005;



*********************for herbaceous: each quadrat is a separate record. Add or find means per species to analyze. 
*********************for transect: need to separate out substrate from plants and set substrate heights to '.' instead of '0'.

