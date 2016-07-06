*2 datasets (quadhistory, herbbyquad), both contain: 
rowid, plot, plotnum, quad, sspp, spnum, bcat, soil, hydr, aspect, elev, slope
	--reminder: bcat [1-u, 2-s/l, 3-m/h], soil [1-sandy, 2-gravelly], hydr [1-no 2-yes]
				aspect [0-flat, 1-north, 2-east, 3-south, 4-west]

quadhistory also includes: count1-count5, pa1-pa5, cover1-cover5 (1 col/var/yr in dataset)
herbbyquad also includes:  count, cover, pa, yearnum, _FREQ_, _TYPE_;

*visualizing data;
proc plot data=herbbyquad; title 'herbbyquad'; 
	plot count*bcat count*yearnum count*soil; run;
proc plot data=quadhistory; title 'quadhistory counts'; 
	plot count1*sspp count2*sspp count3*sspp count4*sspp count5*sspp; run;

*checking species list;
proc print data=splist2; run;
*1-DILI, 2-DIOL, 3-DISP, 4-HELA, 5-LETE;

*quadhistory pa models;
proc sort data=quadhistory; by spnum;
proc glimmix data=quadhistory method=laplace; 
	class bcat soil plotnum; by spnum; 
	*model pa1 = cover1 / dist=binomial solution;  
	*model pa1 = bcat soil cover1 bcat*soil / dist=binomial solution; 
	model pa4 = bcat soil / dist=binomial solution; *best models;
	nloptions gconv=0;
		*Using method= laplace: Convergence criterion (GCONV=1E-8) satisfied, note in log: 
		At least one element of the gradient is greater than 1e-3.
		nloptions gconv=0 forces continued estimation until max gradient is smaller.
		This gets rid of the note but affects bcat values fewer num DF, higher F-value, lower p-value);
	random plotnum / subject = bcat*soil;
	lsmeans bcat / ilink cl;
	output out=glmout resid=ehat;
run;

*quadhistory count models;
proc sort data=quadhistory; by spnum plotnum;
proc means data=quadhistory sum mean noprint; by spnum plotnum hydr aspect elev slope;
	var count1 count2 count3 count4 count5 bcat soil cover1 cover2 cover3 cover4 cover5;
	output out=quadhistory2 sum=count1s count2s count3s count4s count5s bcats soils 
								cover1s cover2s cover3s cover4s cover5s 
							mean=count1m count2m count3m count4m count5m bcatm soilm 
								 cover1m cover2m cover3m cover4m cover5m;
run;
data quadhistory3; set quadhistory2; keep count1s count2s count3s count4s count5s 
										  bcatm soilm cover1m cover2m cover3m cover4m cover5m 
										  spnum plotnum hydr aspect elev slope;
*proc print data=quadhistory3; title 'quadhistory3'; run;

proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3; by spnum;
	class bcatm soilm ;
	*tested yrs 3-5, NS: bcatm*soilm, hydr, aspect, slope, interactions;
	*cover3m NS in any count3s models;
		*year2: recheck slope and hydr, sig. on some.;
	*model count2s = bcatm soilm slope / dist=negbin solution;
	*model count2s = bcatm soilm aspect / dist=negbin solution;
	*model count2s = bcatm soilm hydr / dist=negbin solution;
	*model count2s = bcatm soilm bcatm*soilm / dist=negbin solution;
	model count2s = bcatm soilm cover2m elev  / dist=negbin solution;
	*model count2s = bcatm soilm cover2m elev bcatm*cover2m bcatm*elev soilm*cover3m soilm*elev cover2m*elev/ dist=negbin solution;
	*lsmeans bcatm soilm / ilink cl;
	*output out=glmout resid=ehat;
run;

*herbbyquad models;
proc sort data=herbbyquad; by spnum plotnum yearnum;
proc means data=herbbyquad sum mean noprint; by spnum plotnum yearnum;
	var count bcat soil cover;
	output out=herbbyquad2 sum=counts bcats soils covsum mean=countm bcatm soilm covmean;
run;
data herbbyquad3; set herbbyquad2; keep counts bcatm soilm covmean spnum plotnum yearnum;
proc print data=herbbyquad3; title 'herbbyquad3'; run;

proc sort data=herbbyquad3; by spnum;
proc glimmix data=herbbyquad3; 
	class bcatm soilm yearnum; by spnum; 
	model counts = bcatm soilm yearnum bcatm*soilm / dist=negbin solution; 
	*random plotnum / subject = bcat*soil;
	*lsmeans bcat*soil / ilink cl;
	output out=glmout resid=ehat;
run;
