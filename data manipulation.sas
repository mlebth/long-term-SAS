/*
--Merge plot history and canopy cover with all others, or as needed.
10 herbaceous subplots (no woody plants) - species, # stems (pooled)
transect - species (all plants), ht
seedling subplot - species, ht class
mature trees - plot. dbh, species
pole trees subplot - species, dbh, ht class
shrubs subplot - species, stem count (pooled) 


independent variables:
	Fixed: Canopy cover, burn severity, soil type, hydromulch (0,1,2), 
           elevation, aspect, year, prpo (pre, post fire)
	Random: plot
dependent variables:
	Species (all samples)
		presence/absence by species
		richness
		other measures of diversity and composition
	plant cover (transect)- hits on transect - check values
	stem count - wherever an individual has >1 stem, they are treated as separate. in lieu of N.
	height of each stem. transect: cm,  seedlings& poles: class, shrubs & trees: not measured
	DBH - pole & mature trees 
	canopy cover - densiometer in 5 places/plot x 4 readings/place = 20 readings/plot. convert to 1 #/plot?

Nesting:
	--site (Bastrop/Buescher)
		--soil type	/ --burn severity
			--plot (FMH, invasive, or demog)
				--veg

Strategy:
	--for main FMH datasets (herbaceous, shrubs, 'seedlings', pole and mature trees): merge plot history 
	  and canopy cover with each dataset
	--point transect: treat as other datasets for extra info (messy method)
	--invasives: logistic regressions with p/a?
	--demography: depends on data quality/quantity
*/

*--------------------------piquil: relative abundances;
* getting number of individuals per species, per year and plot.
  ilvo from shrubs. qu, pi from seedlings. no transect data. 
  add ilvo from seedlings.  NOTE: check: if measured twice, interpretation of density must be adjusted.
  nperspp = number stems per species for pines, oaks, ilvo;
* plots with none of these 3 spp have NONEx as their species;
* NOTE TEMPORARILY POOLING YEARS - FIX THIS;
proc sort data=piquil3; by plot sspp burn prpo;
proc means data=piquil3 noprint sum; by plot sspp burn prpo; var coun; 
  output out=numplantdatapo sum=nperspp;
proc print data=numplantdatapo; title 'pi-qu-il numplantdata'; 
  var plot burn prpo sspp nperspp; run;   
* N = 342 plot-year-spp combinations;
* numplantdatapo contains: obs, plot, year, burn, prpo, sspp, nperspp
  nperspp = # of sdlngs per plot per species;

proc sort data=numplantdatapo; by plot burn prpo;
proc means data=numplantdatapo noprint sum; by plot burn prpo; var nperspp; 
	output out=numperplot sum=nperplot;
proc print data=numperplot; title 'totals per plot'; var plot burn prpo nperplot; run;   
* N = 89 plot-prpo combinations;
* numperplot contains: obs, plot, burn, prpo, nperplot
  nperplot = # of all sdlngs in the plot;

*merging to get both nperspp and nperplot in same dataset;
proc sort data = numperplot; by plot burn prpo;
data numperplot2; merge numplantdatapo numperplot; by plot burn prpo; run;
proc print data = numperplot2; title 'numperplot2'; run; 
*back to N=342;
*numperplot2 contains: obs, plot, year, sspp, burn, prpo, nperspp, nperplot

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
ILVO: 2629 (40), QUMA3: 1330 (92), PITA: 1122 (103), QUMA: 955 (95), 
12 plot combos with none
---more ILVO total, but in fewer plot combos;

*freq of spp in burnsev cats, prpo cats. fisher: p-value calc takes too long, freezes system;
proc freq data=relabund; tables sspp*burn; run;
proc freq data=relabund; tables sspp*prpo; run;

*------------------------------piquil models;
proc univariate data=relabund plot normal; run;
*Shapiro-Wilk: 0.1875, P < 0.0001. 
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
* Shapiro-Wilk  W = 0.858531  p<0.0001;
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
	model totpita =  hydromulch burnsev hydromulch*burnsev/
	dist = negbin link=log type1 type3;
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

