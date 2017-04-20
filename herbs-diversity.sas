
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herb6.csv"
out=herb6 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herb6 (firstobs=1 obs=15); title 'herb6'; run;
*proc contents data=herb6; run;
proc freq data=herb6; tables fungroup*burn; run;
*3008 forb obs, 1611 gram obs, 1 plot with no plants;

*Variables:
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

/* Using PROC SQL to count the number of levels for a variable.
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
*/

*************HPRIME AND EVENNESS***********;
*sum of stem counts per plot/year/fungroup;
proc sort data=herb6; by plotnum year fungroup sspp; run;
proc means data=herb6 noprint sum mean; by plotnum yearnum fungroup ; 
	var count aspect burn soil cov elev slope hydr;
	output out=herbsumsp sum=scount saspect sburn ssoil scov selev sslope shydr
						mean=mcount aspect burn soil cov elev slope hydr;
run;	*n=419;
data herb7; set herbsumsp; 
	*drop mcount saspect sburn ssoil sfun scov selev sslope shydr;
	keep plotnum yearnum fungroup _FREQ_ scount;
run;
*proc print data=herb7 (firstobs=1 obs=15); title 'herb7'; run; 
*proc contents data=herb7; run;

*merging total stem counts back to og dataset;
proc sort data=herb6; by plotnum yearnum fungroup; run;
proc sort data=herb7; by plotnum yearnum fungroup; run;
data herb8; merge herb7 herb6; by plotnum yearnum fungroup; run;
*proc print data=herb8 (firstobs=1 obs=10); title 'herb8'; run;

*beginning h' and j' calcuations;
data herb9; set herb8;
	*one plot has no individuals, removing it for division;
	if scount=0 then scount=.;
	pi=count/scount;
	logpi=log(pi);
	pixlogpi=pi*logpi;
run;
*proc print data=herb9 (firstobs=1 obs=10); title 'herb9'; run;

*calcluting h';
proc means data=herb9 sum noprint; by plotnum yearnum fungroup; var pixlogpi;
	output out=herb10 sum=hprime;
run;
*proc print data=herb10 (firstobs=1 obs=10); title 'herb10'; run;

*merging h' back to og dataset and getting evenness (j');
proc sort data=herb6; by plotnum yearnum fungroup; run;
proc sort data=herb10; by plotnum yearnum fungroup; run;
data herbdiv; merge herb10 herb9 herb6; by plotnum yearnum fungroup; 
	*_FREQ_ is number of species/fungroup in each plot-year combo;
	hmax=log(_FREQ_);
	*for some, hmax is 0 (because there was only one individual with one stem);
	if hmax=0 then hmax=.;
	evenness=hprime/hmax;
	drop _TYPE_ counter mcount mcov logpi pixlogpi;
run;
*proc print data=herbdiv (firstobs=1 obs=10); title 'herbdiv'; run;

/*
proc export data=herbdiv
   outfile='D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herbdiv.csv'
   dbms=csv
   replace;
run;
*/

proc sort data=herbdiv; by year; run;
proc glimmix data=herbdiv; by year; title 'hprime';
	class burn fungroup;
	model hprime=burn fungroup / solution ;
	random plot / subject=burn;
	lsmeans burn fungroup;
	output out=glmout resid=ehat;
run;

*prepping for an ordination of just forbs vs grams;
proc means data=herbdiv noprint mean; by plotnum yearnum fungroup; var hprime evenness;
	output out=ordifungroup mean=hprime jprime;
run;													*n=419;
proc print data=ordifungroup; title 'ordifungroup'; run;

/*
proc export data=ordifungroup
   outfile='D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\ordifungroup.csv'
   dbms=csv
   replace;
run;
*/
