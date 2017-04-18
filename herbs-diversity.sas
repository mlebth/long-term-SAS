
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herb6.csv"
out=herb6 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herb6 (firstobs=1 obs=10); title 'herb6'; run;
*proc contents data=herb6; run;
proc freq data=herb6; tables fungroup*burn; run;
*3008 forb obs, 1611 gram obs, 1 plot with no plants;

*Variables:
	plot: plot ID
	aspect: 0=flat 1=N 2=E 3=S 4=W
	burn: 1=unburned 2=scorched 3=light 4=moderate 5=heavy
    count/mcount: stem count of each species per plot/year (post-fire/pre-fire)
	counter: line
	fungroup: functional group. 1=forb, 2=gram, 3=no plants in plot
	cov/mcov: cover post/pre-fire
	elev, slope: continuous
	hydr: 1=no, 2=yes
	soil: 1=sand, 2=gravel
	sspp: species ID
	year: year. Pre-fire years are marked as '1111'
-->for count/mcount and cov/mcov: any pre-fire data is also in the regular columns. I kept
the mcount and mcov columns in case they would be useful anyway
;

proc glimmix data=herb6  method=laplace; by year; title 'herb6'; 
class plot fungroup burn soil hydr aspect sspp;
	*model count = fungroup burn soil / dist=negbin solution; 
		*good model;
		**pre-fire: x2 ok. fungroup sig. 						  AIC 3390**
		*2012: x2 ok. fungroup sig. 							  AIC 3989**
		*2013: x2 ok. fungroup, burn, soil sig. 				  AIC 9247**
		*2014: x2 high (2.12). fungroup, burn sig.  			  AIC 11516
		*2015: x2 high (2.4). fungroup, burn, soil sig. 		  AIC 13215;
	*model count = fungroup burn soil burn*soil / dist=negbin solution; 
		*interaction NS/non-estimable;
	model count = fungroup burn soil hydr aspect elev / dist=negbin solution;
		**pre-fire: x2 ok. fungroup, elev sig.					  AIC 3394
		*2012: x2 ok. fungroup sig.								  AIC 3996
		*2013: x2 ok. fungroup, burn, soil sig.					  AIC 9251
		**2014: x2 high (2.18). fungroup, burn, soil, aspect sig. AIC 11514*
		**2015: x2 high (2.45). fungroup, burn, soil, aspect sig. AIC 13215;
	*model count = fungroup burn soil hydr aspect sspp elev slope cov / dist=negbin solution;
		*estimated G-matrix not PD;
	random plot / subject = burn*soil;
	*lsmeans fungroup burn soil / ilink cl;
	output out=glmout resid=ehat;
run;

/* Using PROC SQL to count the number of levels for a variable. */
proc sql;
   create table new as 
     select count(distinct(sspp)) as speciescount
            from herb6;
quit;
proc print;
   title 'Number of distinct values for each variable'; 
run;	*315 species;

*total count;
proc means data=herb6 sum mean noprint; var count;
	output out=herbsum sum=sumcount mean=mcount;
run;	
proc print data=herbsum; title 'herbsum'; run; 
*freq=4620 observations, sumcount=258696.5 stems, mean stems=55.99;

***********H' by species;
*counts by species;
proc sort data=herb6; by sspp; run;
proc means data=herb6 sum mean noprint; by sspp; var count;
	output out=herbsumsp sum=sumcountsp mean=meancountsp;
run;	*n=315 species (including XXXXx);
proc print data=herbsumsp; title 'herbsumsp'; run; 

*Shannon's calculations;
data herbrelabund; set herbsumsp;
	*one row of XXXXx, count is 0--removing;
	if sumcountsp=0 then sumcountsp=.;
	spcount=315;
	pi=sumcountsp/spcount;
	logpi=log(pi);
	pixlogpi=pi*logpi;
	*pi squared for evenness;
	pisq=pi**2;
run;
proc print data=herbrelabund; title 'herbrelabund'; run;

*calculating H' for all obs;
proc means data=herbrelabund sum noprint; var pixlogpi pisq;
	output out=hprimetot sum=hprime sumpisq;
run;	
proc print data=hprimetot; title 'hprimetot'; run; 
data totevenness; set hprimetot;
	logrich=log(spcount);
	evenness=hprime/logrich;
run;
proc print data=totevenness; title 'totevenness'; run;
*richness=315
evenness=470.428
hprime=2706.17;


***********H' by species and burn;
*counts by species and burn sev;
proc sort data=herb6; by sspp burn; run;
proc means data=herb6 sum mean noprint; by sspp burn; var count;
	output out=herbsumspburn sum=sumcountspburn mean=meancountspburn;
run;	*n=315 species (including XXXXx);
proc print data=herbsumspburn; title 'herbsumspburn'; run; 

*Shannon's calculations;
data herbrelabundburn; set herbsumspburn;
	spburncount=693;
	pi=sumcountspburn/spburncount;
	logpi=log(pi);
	pixlogpi=pi*logpi;
run;
proc print data=herbrelabundburn; title 'herbrelabundburn'; run;

*calculating H' for all obs;
proc sort data=herbrelabundburn; by burn; run;
proc means data=herbrelabundburn sum noprint; by burn; var pixlogpi;
	output out=hprimeburn sum=hprimeburn;
run;	
proc print data=hprimeburn; title 'hprimeburn'; run; 
*hprime:
unburned=-2.791
scorched=-6.794
light=45.804
moderate=64.725
high=544.444;

***note that plots with lots of high stem-count grasses (DILI, for example)
	will be less even--there might be one DILI individual, but per FMH sampling
	protocol it might be recorded as 100s or 1000s of 'individuals' (tillers);
