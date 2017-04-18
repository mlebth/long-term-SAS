
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herb6.csv"
out=herb6 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herb6 (firstobs=1 obs=10); title 'herb6'; run;
*proc contents data=herb6; run;

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
		**pre-fire: x2 ok. fungroup sig. 						  AIC 3390*
		*2012: x2 ok. fungroup sig. 							  AIC 3989*
		*2013: x2 ok. fungroup, burn, soil sig. 				  AIC 9247*
		*2014: x2 high (2.12). fungroup, burn sig.  			  AIC 11516
		*2015: x2 high (2.4). fungroup, burn, soil sig. 		  AIC 13215;
	*model count = fungroup burn soil burn*soil / dist=negbin solution; *interaction NS/non-estimable;
	*model count = fungroup burn soil hydr aspect elev / dist=negbin solution;
		**pre-fire: x2 ok. fungroup, elev sig.					  AIC 3394
		*2012: x2 ok. fungroup sig.								  AIC 3996
		*2013: x2 ok. fungroup, burn, soil sig.					  AIC 9251
		**2014: x2 high (2.18). fungroup, burn, soil, aspect sig. AIC 11514*
		**2015: x2 high (2.45). fungroup, burn, soil, aspect sig. AIC 13215;
	model count = fungroup burn soil hydr aspect sspp elev slope cov / dist=negbin solution;
		**pre-fire: x2 ok. fungroup, elev sig.					  AIC 3394
		*2012: x2 ok. fungroup sig.								  AIC 3996
		*2013: x2 ok. fungroup, burn, soil sig.					  AIC 9251
		**2014: x2 high (2.18). fungroup, burn, soil, aspect sig. AIC 11514*
		**2015: x2 high (2.45). fungroup, burn, soil, aspect sig. AIC 13215;
	random plot / subject = burn*soil;
	*lsmeans fungroup burn soil / ilink cl;
	output out=glmout resid=ehat;
run;
