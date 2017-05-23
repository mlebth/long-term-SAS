
proc sort data=fundiv2; by yearnum; run;
proc glimmix data=fundiv2; by yearnum; title 'hprime';
    class burn;
    model forbdiv= burn cov/ solution ;
    *random plotnum / subject=burn type=vc;
    lsmeans burn ;
    output out=glmout resid=ehat;
run;

**************import;

OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory;
* proc datasets library=work kill noprint; run; 

**************import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herb6.csv"
out=herb6 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herb6 (firstobs=30 obs=40); title 'herb6'; run;
*proc contents data=herb6; run;
*proc freq data=herb6; *tables fungroup*burn; run;
*3008 forb obs, 1611 gram obs, 1 plot with no plants;

**************Variables:
	plot: FMH plot ID
	plotnum: renumbered 1-55
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
	yearnum: prefire=1, 2012=2, 2013=3, 2014=4, 2015=5
-->for count/mcount and cov/mcov: any pre-fire data is also in the regular columns. I kept
the mcount and mcov columns in case they would be useful anyway
;

*herb7 gets rid of fungroup3;
proc sort data=herb6; by plot fungroup year burn soil elev slope aspect hydr;
proc means data=herb6 noprint mean; by plot fungroup year burn soil elev slope aspect hydr; var count cov;
	output out=herb62 mean=meancount cov;
run;
data herb7; set herb62; if fungroup=3 then delete;
*proc print data=herb7 (firstobs=30 obs=40); title 'herbs7'; run;
*meancount=mean stems/plot/fungorup.
use meancount for analyses;
proc sql;
	select sspp, fungroup, plot, year
	from herb6
	where fungroup=3;
quit;
*there is only one instance. deleting.;

data forbs; set herb7; if fungroup=1;
data grams; set herb7; if fungroup=2; run;
proc print data=forbs; title 'forbs';
proc print data=grams; title 'grams'; run;

proc plot data=forbs; plot meancount*year; run;
proc freq data=forbs; tables meancount*year; run;

**************count analysis of forbs and grams separately;
proc sort data=forbs; by year; run;
proc glimmix data=forbs; by year; title 'forbs'; 
class burn soil hydr aspect ;
	model meancount =  soil hydr aspect elev cov/ dist=negbin solution;
	lsmeans soil hydr aspect  / ilink cl;
/*
	contrast 'scorch v low' burn 1 -1 0 0;
	contrast 'scorch v mod' burn 1 0 -1 0;
	contrast 'scorch v hi' burn 1 0 0 -1;
	contrast 'low v mod' burn 0 1 -1 0;
	contrast 'low v hi' burn 0 1 0 -1;
	contrast 'mod v hi' burn 0 0 1 -1;
	*/
	/*
	contrast 'flat v N' aspect 1 -1 0 0 0 ;
	contrast 'flat v E' aspect 1 0 -1 0 0 ;
	contrast 'flat v S' aspect 1 0 0 -1 0 ;
	contrast 'flat v W' aspect 1 0 0 0 -1 ;
	contrast 'N v E' aspect 0 1 -1 0 0 ;
	contrast 'N v S' aspect 0 1 0 -1 0 ;
	contrast 'N v W' aspect 0 1 0 0 -1 ;
	contrast 'E v S' aspect 0 0 1 -1 0 ;
	contrast 'E v W' aspect 0 0 1 0 -1 ;
	contrast 'S v W' aspect 0 0 0 1 -1;
	*/
	output out=glmout resid=ehat;
run;

proc sort data=grams; by year; run;
proc glimmix data=grams; by year; title 'grams'; 
class plot burn soil hydr aspect  ;
	model meancount= soil  aspect cov / dist=negbin solution;
	lsmeans soil aspect / ilink cl;
	contrast 'flat v N' aspect 1 -1 0 0 0 ;
	contrast 'flat v E' aspect 1 0 -1 0 0 ;
	contrast 'flat v S' aspect 1 0 0 -1 0 ;
	contrast 'flat v W' aspect 1 0 0 0 -1 ;
	contrast 'N v E' aspect 0 1 -1 0 0 ;
	contrast 'N v S' aspect 0 1 0 -1 0 ;
	contrast 'N v W' aspect 0 1 0 0 -1 ;
	contrast 'E v S' aspect 0 0 1 -1 0 ;
	contrast 'E v W' aspect 0 0 1 0 -1 ;
	contrast 'S v W' aspect 0 0 0 1 -1;
	output out=glmout resid=ehat;
run;










**************count analyses using herb7;
proc sort data=herb7; by year; run;
proc glimmix data=herb7 method=laplace; by year; title 'herb7'; 
*class plot fungroup burn soil hydr aspect ;
class plot fungroup burn soil hydr aspect  ;
	*model meancount=fungroup burn soil hydr aspect elev slope cov / dist=negbin solution;;
*1&4: nonpd
2: 561.39. fungroup, almost slope.
3: 988.94. fungroup, burn, soil
5: 847.01. fungroup, soil, aspect, cov ;	
	*model meancount=fungroup burn soil aspect slope cov / dist=negbin solution;;
*1&4: nonpd
2: 558.74. fungroup, almost soil, almost slope. 
3: 988.55. fungroup, burn, soil   **
5: 844.98. fungroup, soil, almost aspect, cov;	 **;
	*model meancount=fungroup  soil  aspect  / dist=negbin solution;;
*1: 499.7. fungroup. **
2: 551.82. fungroup. **	
3: 994.1. fungroup, soil 
4: 962.69, fungroup, soil.
5: 864.92. fungroup, soil.;
	model meancount=fungroup  soil plot(burn) / dist=negbin solution;
	*random plot / subject = burn*soil;
	*lsmeans fungroup  soil  / ilink cl;
	output out=glmout resid=ehat;
run;

**************count analyses using herb6;
proc sort data=herb6; by year; run;
proc glimmix data=herb6  method=laplace; by year; title 'herb6'; 
*class plot fungroup burn soil hydr aspect ;
class plot fungroup burn soil aspect  ;
	model count=fungroup soil aspect cov / dist=negbin solution;;
	*model count = fungroup burn soil / dist=negbin solution; 
		*good model;
		**pre-fire: x2 ok. fungroup sig. 						  AIC 3390
		*2012: x2 ok. fungroup sig. 							  AIC 3989**
		*2013: x2 ok. fungroup, burn, soil sig. 				  AIC 9247**
		*2014: x2 high (2.12). fungroup, burn sig.  			  AIC 11516
		*2015: x2 high (2.4). fungroup, burn, soil sig. 		  AIC 13215;
	*model count = fungroup burn soil burn*soil / dist=negbin solution; 
		*interaction NS/non-estimable;
	*model count = fungroup burn soil hydr aspect elev / dist=negbin solution;
		**pre-fire: x2 ok. fungroup, elev sig.					  AIC 3394
		*2012: x2 ok. fungroup sig.								  AIC 3996
		*2013: x2 ok. fungroup, burn, soil sig.					  AIC 9251
		**2014: x2 high (2.18). fungroup, burn, soil, aspect sig. AIC 11514
		**2015: x2 high (2.45). fungroup, burn, soil, aspect sig. AIC 13215;
	*model count = fungroup burn soil hydr aspect sspp elev slope cov / dist=negbin solution;
		*estimated G-matrix not PD;
	*model count = fungroup burn soil hydr aspect elev cov / dist=negbin solution;
		*good model;
		**pre-fire: x2 ok. fungroup, aspect, cov sig. 			  AIC 1798**
		*2012: x2 ok. fungroup sig. 							  AIC 3997
		*2013: x2 ok. fungroup, burn, soil sig. 				  AIC 9252
		*2014: x2 high (2.22). fungroup, burn, soil, aspect, cov sig.   AIC 11510*
		*2015: x2 high (2.48). fungroup, soil, cov sig. 		  	  AIC 13210*;
	*model count = fungroup burn soil aspect elev cov fungroup*burn fungroup*soil fungroup*aspect fungroup*elev fungroup*cov / dist=negbin solution;
	*year 1 best model; *model count = fungroup soil aspect cov  / dist=negbin solution; 
	*year 2 best model; *model count = fungroup  / dist=negbin solution; 
	*year 3 best model; *model count = fungroup burn soil / dist=negbin solution; 
	*year 4 best model; *model count = fungroup burn soil aspect elev cov fungroup*burn fungroup*soil fungroup*aspect fungroup*elev fungroup*cov / dist=negbin solution; 
		*this model still ahs x2/df at 2.07. it's 2.01 with just fungroup in the model, but all these interaction terms are significant;
		*the years 4 and 5 models get slightly better as i add more terms/interactions, right up to the point that the model is way over-specified
		and the estimated g-matrix is no longer pd. they never get to x2/2<2;
	random plot / subject = burn*soil;
	*lsmeans fungroup burn soil / ilink cl;
	output out=glmout resid=ehat;
run;

**************import diversity data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herbdiv.csv"
out=herbdiv dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herbdiv (firstobs=1 obs=15); title 'herbdiv'; run;
*herbdiv columns: plotnum, yernum, fungroup, _FREQ_, scount, plot, sspp, env vars, 
count, cov, relabund, hprime, hmax, evenness;

proc sort data=herbdiv; by year; run;
proc glimmix data=herbdiv; by year; title 'hprime';
	class plot burn fungroup;
	model hprime=burn fungroup / solution ;
	random plot / subject=burn;
	lsmeans burn fungroup;
	output out=glmout resid=ehat;
run;

**************import diversity data to analyze hprime of forbdiv/gramdiv separately;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\fundiv2.csv"
out=fundiv2 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=fundiv2 (firstobs=1 obs=15); title 'fundiv2'; run;
*fundiv2 columns: plotnum, yearnum, envvars, forbdiv, gramdiv;

proc sort data=fundiv2; by yearnum; run;
proc glimmix data=fundiv2; by yearnum; title 'hprime';
	class burn soil;
	model forbdiv= burn soil / solution ;
	*random plotnum / subject=burn type=vc;
	lsmeans burn ;
	output out=glmout resid=ehat;
run;

**************import relative abundance data by species;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herbdivbysp4.csv"
out=herbdivbysp4 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herbdivbysp4 (firstobs=1 obs=15); title 'herbdivbysp4'; run;
*herbdivbysp4 columns: plotnum, yearnum, numspperplot, scount, envvars, 
then relative abundances of each species in 315 columns--best for ordination;
