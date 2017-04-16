
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\herb6.csv"
out=herb6 dbms=csv replace; getnames=yes; run;  * N = 4620;
*proc print data=herb6 (firstobs=1 obs=100); title 'herb6'; run;
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
;

proc glimmix data=herb6; title 'herb6'; 
class plot burn;
	model count = burn / dist=negbin solution; 
	*model count = year burn hydr soil aspect fungroup elev  / dist=negbin solution; *not a good fit;
	*model count = year burn hydr soil aspect fungroup elev year*burn*fungroup*hydr*soil*aspect / dist=negbin solution; *not a good fit;
	*fungroup very NS;
	*model mcount = burn / dist=negbin solution;
	*lsmeans burn year / ilink cl;
	random plot / subject = burn;
	output out=glmout resid=ehat;
run;

proc glimmix data=herb6; by year; title 'herb6'; 
class plot burn soil;
	model count = burn soil burn*soil/ dist=negbin solution; 
	*model count = burn hydr soil aspect fungroup elev  / dist=negbin solution; *not a good fit;
	*model count = burn hydr soil aspect fungroup elev year*burn*fungroup*hydr*soil*aspect / dist=negbin solution; *not a good fit;
	*fungroup very NS;
	*model mcount = burn / dist=negbin solution;
	*lsmeans burn year / ilink cl;
	random plot / subject = burn*soil;
	output out=glmout resid=ehat;
run;
