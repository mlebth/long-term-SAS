
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

*5-31-17;
proc import datafile="D:\Werk\Research\Demography\demog2.csv"
out=demog2 dbms=csv replace; getnames=yes; run;  * N = 319;
*proc print data = demog2; title 'demog2'; run;
*proc contents data = demog2; run;

*vars:
plot = generated plot id's (from initial randomization)
sspp = 5 characters
trmt = treatment combo--sand/gravel x no/low/high [sn, sl, sh, gn, gl, gh].
burn = burn severity [1: not burned, 2: low burn, 3: high burn
soil = soil type [1: sandy soil, 2: gravelly soil]
mhgt1, mhgt2 = mean height (of the 5 measured) @ census 1 and 2
stco1, stco2 = stem count @ census 1 and 2
diam1, diam2 = basal diameter @ census 1 and 2
cano1, cano2 = canopy cover--1 measurement @ census 1 and 2
stat1, stat2 = 1 (live) / 2 (dead, missing, or unfindable)
area1, area1 = area of largest stem (calculated by basal diameter) * number of stems;

proc freq data=demog2; tables sspp*trmt; run;
*		gh	gl	gn	sh	sl	sn		total (aiming for 120/sp)
ilvo	20	19	12	17	19	10		97
pita	22	19	0	19	19	2		81
quma3	20	20	1	19	16	7		83
qumax	19	11	0	19	9	0		58

total	81	69	13	74	63	19		319
(aiming for 80/'treatment')			(aiming for 480 total)

--> we originally aimed for 20 observations/sp/treatment (120 total/sp)
but some treatments just didn't *have* the species I was looking for (at least
not in the vicinity of the plot point).;

*predictor vars: mhgt1, area1, cano1, stat1
response vars: mght1/2 area1/2, cano1/2, stat1/2 burn soil;
proc sort data=demog2; by sspp;
proc glimmix data=demog2 method=laplace; by sspp;
	class burn soil;
		*seeing effect of treatment on area1;
	*model area1 = cano1/ distribution=negbin link=log solution;
		*seeing that areas match up;
	*model area2 = area1 burn soil / distribution=negbin link=log solution;
		*seeing effect of treatment and canopy cover on area;
	*model mhgt2 = mhgt1 soil mhgt1*soil/ distribution=negbin link=log solution;
		*seeing effect of treatment and canopy cover on fate;
	*model stat2 = burn cano2 / distribution=binomial link=logit solution;
	*model stco1 =  burn / distribution=negbin link=log solution;
	model stco2 =   burn / distribution=negbin link=log solution;
	lsmeans burn  / ilink cl;
	contrast 'no v low' burn -1 1 0;
	contrast 'no v hi' burn -1 0 1;
	contrast 'low v hi' burn 0 -1 1;
	output out=glmout resid=ehat;
run;
	/* *treatment contrasts;
	contrast 'gh v gl' trmt -1 1 0 0 0 0;
	contrast 'gh v gn' trmt -1 0 1 0 0 0;
	contrast 'gh v sh' trmt -1 0 0 1 0 0;
	contrast 'gh v sl' trmt -1 0 0 0 1 0;
	contrast 'gh v sn' trmt -1 0 0 0 0 1;
	contrast 'gl v gn' trmt 0 -1 1 0 0 0;
	contrast 'gl v sh' trmt 0 -1 0 1 0 0;
	contrast 'gl v sl' trmt 0 -1 0 0 1 0;
	contrast 'gl v sn' trmt 0 -1 0 0 0 1;
	contrast 'gn v sh' trmt 0 0 -1 1 0 0;
	contrast 'gn v sl' trmt 0 0 -1 0 1 0;
	contrast 'gn v sn' trmt 0 0 -1 0 0 1;
	contrast 'sh v sl' trmt 0 0 0 -1 1 0;
	contrast 'sh v sn' trmt 0 0 0 -1 0 1;
	contrast 'sl v sn' trmt 0 0 0 0 -1 1;
	*/

	/* *burn contrasts;
	contrast 'no v low' burn -1 1 0;
	contrast 'no v hi' burn -1 0 1;
	contrast 'low v hi' burn 0 -1 1;
	*/

*6-2-17: spearman correlations between variables;
proc corr data=demog2 spearman; 
var burn  cano1 cano2;
run;

*6-27--correlations between all variables;
proc corr data=demog2 spearman; 
run;

proc means data=demog2 mean noprint; by sspp;
	var stco1 stco2 area1 area2 mhgt1 mhgt2;
	output out=growthrates mean=mco1 mco2 mar1 mar2 mh1 mh2;
run;
proc print data=growthrates; title 'growthrates'; run;
