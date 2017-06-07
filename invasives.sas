
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory, then rerun relevant 
	sections;
* proc datasets library=work kill noprint; run; 

***6-6-17;
*import herb data;
proc import datafile="D:\Werk\Research\Invasives\invasivedata5.csv"
out=invasives dbms=csv replace; getnames=yes; run;  * N = 363;
*proc contents data=invasives; title 'invasives'; run;
*proc print data=invasives; title 'invasives'; run;

*vars:
plot: plot id
date: date visited
can1/can2: canopy cover (using densiometer, facing opposite directions)
cancov: mean canopy cover for plot
gcover: estimated ground cover in increments of 10 (rough visual estimate_
invsp1/2: invasive species name 1/2
invc1/2: invasive cover 1/2
stems1/2: invasive stem/tiller count 1/2
ntsp1/2/3: non-invasive species name 1/2/3 (only recorded up to 3 most abundant)
comments;

data inv; set invasives;
	*there's one with nothing for some reason;
	if plot=. then delete;
	*invasive presence/absence;
	if invsp1 NE 'XXXX' then invpa=1;
	if invsp1 = 'XXXX' then invpa=0;
	*native presence/absence;
	if ntsp1 NE 'XXXX' then natpa=1;
	if ntsp1 = 'XXXX' then natpa=0;
	*native cover;
	natcov=gcover-invc1-invc2;
	drop gcover date can1 can2 comments;
run;
proc print data=inv; title 'inv'; run;

*species frequencies;
proc freq data=inv;
	tables invsp1 invsp2;
run;
*bois: 4
cyda: 4
meaz: 3
padi: 1
pano: 3
phse: 1
cyda: 1;

proc sql;
	select cancov, invsp1, stems1, invc1, invsp2, stems2, invc2, ntsp1, ntsp2, natcov
	from inv
	where invsp1='BOIS' | invsp1='CYDA' | invsp1='MEAZ' | invsp1='PADI' |
		  invsp1='PANO' | invsp1='PHSE' | invsp1='CYDA' | 
		  invsp2='BOIS' | invsp2='CYDA' | invsp2='MEAZ' | invsp2='PADI' |
		  invsp2='PANO' | invsp2='PHSE' | invsp2='CYDA' ;
quit;

*response vars: invpa, natpa, invc1/2, gcover, stems1/2
predictor vars: cancov, gcover, ;
proc glimmix data=inv;
	*class invpa;
	model stems1=cancov / dist=negbin link=log solution;
	*model invpa=natpa / dist=binomial link=logit solution;
	output out=mout resid=ehat;
run;
