*datasets: 
	herbprpo: pre-fire pooled, post-fire pooled (pre vs post).
		variables: 
			aspect, elev, hydr (1:n, 2:y), slope, soil (1:sand, 2:gravel),
			bcat (1:u, 2:s/l, 3: m/h), yrcat (1:pre-fire, 2-post), type (1:plant, 2:nothing present in quadrat), 
			mcoun, mcov, ncoun, ncov, plot, quad, spid, sspp, 
					
	herbbyyr: pre-fire pooled, then 2011-2015 (pre vs 2011, 2012, 2013, 2014, 2015)	
		variables: same as herbmerge 1 but with 'year' instead of 'yrcat'
				pre-fire is '1111'

	in both: mcov (mean of cover) is missing values (.) where it was not recorded pre-fire;

*setting up datasets with no LEDU (sprangletop--hydro seed);
data noleduprpo; set herbprpo; if sspp = 'LEDUx' then delete; run;
data noledubyyr; set herbbyyr; if sspp = 'LEDUx' then delete; run;
*proc print data=noleduprpo (firstobs=1 obs=20); run;
*proc print data=noledubyyr (firstobs=1 obs=20); run;

proc contents data=herbprpo; run;
*visualize data;
proc plot data=herbprpo; title 'herbprpo'; 
	plot mcoun*bcat mcoun*yrcat mcoun*soil; 
run;

proc plot data=herbbyyr; title 'herbbyyr'; 
	plot mcoun*bcat mcoun*year mcoun*soil; 
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

proc glimmix data=herbprpo; title 'plot-bcat-soil';
  class plot bcat;
  model mcoun = plot bcat/ distribution=negbin link=log solution; 
  random plot(bcat);
  lsmeans bcat / ilink cl; 
  output out=glmout2 resid=ehat;
run;

proc glimmix data=herbprpo; title 'plot-bcat-soil';
  class bcat soil;
  model mcoun = plot bcat soil / distribution=negbin link=log solution; 
  random plot(bcat*soil);
  lsmeans bcat soil / ilink cl; 
  output out=glmout2 resid=ehat;
run;

*models--herbbyyr;
proc glimmix data=herbbyyr; title 'plot-bcat-soil';
  class plot soil bcat;
  model mcoun = year / distribution=negbin link=log solution; 
  random plot / subject=bcat*soil;
  *lsmeans soil / ilink cl; 
  output out=glmout2 resid=ehat;
run;
