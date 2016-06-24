*2 datasets (herbbyquad, quadhistory), both contain: 
rowid, plot, plotnum, quad, sspp, spnum, bcat, covm, soil, hydr, aspect, elev, slope

herbbyquad also includes:  count,         pa, yearnum, _FREQ_, _TYPE_

quadhistory also includes: count1-count5, pa1-pa5 (one for each of the 5 sp in dataset);

*visualizing data;
proc plot data=herbbyquad; title 'herbbyquad'; 
	plot coun*bcat coun*yearnum coun*soil; run;
proc plot data=quadhistory; title 'quadhistory counts'; 
	plot count1*sspp count2*sspp count3*sspp count4*sspp count5*sspp; run;
proc plot data=quadhistory; title 'quadhistory env'; 
	plot sspp*bcat sspp; run;

proc print data=splist2; run;
*species this round: 1-DILI, 2-DIOL, 3-DISP, 4-HELA, 5-LETE;

*quadhistory pa models;
proc sort data=quadhistory; by spnum;
proc glimmix data=quadhistory; 
	class plotnum bcat soil spnum; by spnum; 
	*model pa2 = bcat plotnum(bcat) / dist=binomial solution;
	*model pa2 = bcat soil covm plotnum(bcat*soil) / dist=binomial solution;
	model pa2 = bcat soil bcat*soil / dist=binomial solution; *did not converge;
	random plotnum(bcat*soil);
	lsmeans bcat*soil / ilink cl;
	output out=glmout resid=ehat;
run;

*quadhistory count models;
proc sort data=quadhistory; by spnum;
proc glimmix data=quadhistory; 
	class plotnum bcat soil spnum; by spnum; 
	*model count2 = bcat soil bcat*soil/ dist=negbin solution; *did not converge;
	model count2 = bcat / dist=negbin solution; *did not converge;
	*model count2 = bcat soil covm plotnum(bcat*soil) / dist=binomial;
	*model count2 = spnum bcat soil plotnum(bcat*soil) / dist=binomial;
	random plotnum(bcat);
	*lsmeans bcat*soil / ilink cl;
	output out=glmout resid=ehat;
run;
