*2 datasets (herbbyquad, quadhistory), both contain: 
rowid, plot, plotnum, quad, sspp, spnum, bcat, covm, soil, hydr, aspect, elev, slope, prpo, type

herbbyquad also includes: coun, pa, yearnum, _FREQ_, _TYPE_

quadhistory also includes: count1-count5, pa1-pa5 (one for each of the 5 sp in dataset);

*visualize data;
proc plot data=herbbyquad; title 'herbbyquad'; 
	plot coun*bcat coun*yearnum coun*soil; 
run;
proc plot data=herbbyquad; title 'herbbyquad'; 
	plot sspp*coun sspp*yearnum; 
run;
proc plot data=quadhistory; title 'quadhistory counts'; 
	plot count1*sspp count2*sspp count3*sspp count4*sspp count5*sspp; 
run;
proc plot data=quadhistory; title 'quadhistory counts'; 
	plot count1*sspp sspp*count1; 
run;

*nlf model;
proc sort data=quadhistory; by spnum;
proc glimmix data=quadhistory; class plotnum quad bcat; by spnum; 
  model pa5 = bcat plotnum(bcat)/ dist=binomial;
run;

*creating a set of just post-fire data;
data herbbyyr; set herbbyyr; if year > 2010; run;
proc plot data=herbbyyr; title 'herbbyyr'; 
	plot mcoun*bcat mcoun*year mcoun*soil; 
run;

*models--herbprpo;
proc glimmix data=herbprpo; title 'plot-bcat-soil';
  class plot bcat;
  model mcoun = plot bcat / distribution=negbin link=log solution; 
  random bcat / subject=plot;
  lsmeans bcat / ilink cl; 
  output out=glmout2 resid=ehat;
run;

proc glm data=herbbyyr; title 'herbmerge1';
class plot ;
model mcoun = plot; 
lsmeans plot;
output out=glmout; 
run;
