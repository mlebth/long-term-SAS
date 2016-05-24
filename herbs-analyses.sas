*datasets: 
	herbmerge1, herbmerge2
	both include all variables
	herbmerge1: pre-fire pooled, post-fire pooled (pre vs post). 
				Date variable is 'yrcat'
	herbmerge2: pre-fire pooled, then 2011-2015 (pre vs 2011, 2012, 2013, 2014, 2015)
				Date variable is 'year'. Pre-fire is '1111'
	problems in both: mcov (mean of cover) is missing values (.) where it was not recorded pre-fire;

*visualize data;
proc plot data=herbmerge1; title 'plot of mean count by bcat & mean count by year'; 
	plot mcoun*bcat mcoun*yrcat mcoun*soil; 
run;

*models;
proc glimmix data=herbmerge1; title 'plot-bcat-soil';
  class plot bcat soil;
  model mcoun = plot bcat soil/ distribution=negbin link=log solution; 
  random plot(bcat*soil);
  lsmeans bcat soil / ilink cl; 
  output out=glmout2 resid=ehat;
run;

proc glimmix data=herbmerge1; title 'plot-bcat-soil';
  class plot bcat;
  model mcoun = plot bcat/ distribution=negbin link=log solution; 
  random plot(bcat);
  lsmeans bcat / ilink cl; 
  output out=glmout2 resid=ehat;
run;
