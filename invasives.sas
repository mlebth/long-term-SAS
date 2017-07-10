
proc sql;
    select plot invsp1 invsp2 ntsp1  burn
    from inv
    where burn='';
quit;

OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory, then rerun relevant 
	sections;
* proc datasets library=work kill noprint; run; 

***6-36-17;
*skip all the below, straight to glimmix--just import this;
proc import datafile="D:\Werk\Research\My papers\Invasives\inv.csv"
out=inv dbms=csv replace; getnames=yes; run;  * N = 355;
*proc contents data=inv; title 'inv'; run;
*proc print data=inv (firstobs=1 obs=10); title 'inv'; run;

*spearman correlations;
proc corr data=inv spearman; 
var invcov stems;
run;

***6-6-17;
*import invasive data;
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

data inv1; set invasives;
	*there's one with nothing for some reason;
	if plot=. then delete;
	if cancov=999 then cancov=.;
	*invasive presence/absence;
	if invsp1 NE 'XXXX' then invpa=1;
	if invsp1 = 'XXXX' then invpa=0;
	*native presence/absence;
	if ntsp1 NE 'XXXX' then natpa=1;
	if ntsp1 = 'XXXX' then natpa=0;
	*native cover;
	natcov=gcover-invc1-invc2;
	cancovp=100-(cancov*1.04)-0.16;
	*total invasive cover and stem count per plot;
	invcov=(invc1+invc2);
	stems=(stems1+stems2);
	drop stems1 stems2 invc1 invc2 gcover date can1 can2 cancov comments;
run;
*proc print data=inv1 ; title 'inv1' ; run;

/*
proc export data=inv
   outfile='D:\Werk\Research\My papers\Invasives\inv.csv'
   dbms=csv
   replace;
run;
*/

*vars:
plot: plot id
invpa: invasive presence/absence
natpa: native presence/absence
cancoverp: percent canopy cover
invsp1/2: invasive species name 1/2
invcov: total invasive cover
stems: invasive stem/tiller count
ntsp1/2/3: non-invasive species name 1/2/3 (only recorded up to 3 most abundant);

***6-26-17;
*import attribute table;
proc import datafile="D:\Werk\Research\My papers\Invasives\attribute table.csv"
out=attributes dbms=csv replace; getnames=yes; run;  * N = 480;
*proc contents data=attributes; title 'attributes'; run;
*proc print data=attributes (firstobs=1 obs=10); title 'attributes'; run;

proc sort data=inv1; by plot;
proc sort data=attributes; by plot;
data invinfo; merge inv1 attributes; by plot; run; *n=486;
proc print data=invinfo; title 'invinfo'; run;

data inv; set invinfo;
	*removing plots with no data;
	if invsp1='' then delete;
	if cancovp=. then delete;
	*all the missing ones are unburned/sandy--they were off the burnsev gis layer;
	if burnnum=. then burnnum=1;
	if soilnum=. then soilnum=1;
run;
proc print data=inv; title 'inv'; run; *n=355;

proc sql;
	select plot, invsp1, invsp2, ntsp1, burn, cancovp, burnnum, soil, soilnum
	from inv
	where cancovp=.;
quit;

/*
proc export data=inv
   outfile='D:\Werk\Research\My papers\Invasives\inv.csv'
   dbms=csv
   replace;
run;
*/

*species frequencies;
proc freq data=inv;
	tables invsp1 invsp2 invpa natpa;
run;
*bois: 4
cyda: 4
meaz: 3
padi: 1
pano: 3
phse: 1
cyda: 1
p/a--invasives: 16 plots with, 346 plots without
p/a--natives: 334 plots with, 28 plots without;

*species frequencies--burnsev and soil type;
proc freq data=inv;
	tables invsp1*burnnum invsp1*soilnum invsp2*burnnum  invsp2*soilnum;
run;

proc sort data=inv; by plot invsp1 invsp2; 
proc means data=inv mean noprint; by plot invsp1 invsp2;
	var cancovp stems invcov natcov;
	output out=invtable mean=mcancovp mstems minvc mnatcov;
run;
proc print data=invtable; title 'invtable'; run;

proc sql;
	select cancov, invsp1, stems1, invc1, invsp2, stems2, invc2, ntsp1, ntsp2, natcov
	from inv
	where invsp1='BOIS' | invsp1='CYDA' | invsp1='MEAZ' | invsp1='PADI' |
		  invsp1='PANO' | invsp1='PHSE' | invsp1='CYDA' | 
		  invsp2='BOIS' | invsp2='CYDA' | invsp2='MEAZ' | invsp2='PADI' |
		  invsp2='PANO' | invsp2='PHSE' | invsp2='CYDA' ;
quit;

proc univariate data=inv normal plot;
	var cancov stems1 stems2 invc1 invc2 natcov; 
	title 'univariate';
run;
**fix cancov--i have 999's in there;
*maybe the 999's aren't a great idea, actually;

*response vars: invpa, invcov, stems
predictor vars: burnnum, soilnum, cancovp, natcov, natpa;
*invpa=natpa cancovp
 invcov=natcov cancovp
 stems=natcov cancovp natpa;

proc glimmix data=inv ;
	class burnnum soilnum natpa;
	*model invpa = natpa / dist=binomial link=logit solution;
	model invcov = burnnum natcov/ dist=negbin link=log solution;
	*model stems = soilnum cancovp  natpa/ dist=negbin link=logit solution;
	lsmeans  burnnum  / ilink cl;
	
	contrast 'no v scorch' 		burnnum -1 1 0 0 0;
	contrast 'no v light'  		burnnum -1 0 1 0 0;
	contrast 'no v mod'   		burnnum -1 0 0 1 0;
	contrast 'no v heavy' 		burnnum -1 0 0 0 1;
	contrast 'scorch v light' 	burnnum 0 -1 1 0 0;
	contrast 'scorch v mod'    	burnnum 0 -1 0 1 0;
	contrast 'scorch v heavy'   burnnum 0 -1 0 0 1;
	contrast 'light v mod'  	burnnum 0 0 -1 1 0;
	contrast 'light v heavy'    burnnum 0 0 -1 0 1;
	contrast 'mod v heavy'  	burnnum 0 0 0 -1 1;
	
	output out=mout resid=ehat;
run;
