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

*quadhistory count models;
proc sort data=quadhistory; by spnum plotnum bcat soil hydr aspect elev slope;
proc means data=quadhistory sum mean noprint; by spnum plotnum bcat soil hydr aspect elev slope;
	var count1 count2 count3 count4 count5 cover1 cover2 cover3 cover4 cover5;
	output out=quadhistory2 sum=count1s count2s count3s count4s count5s  
								cover1s cover2s cover3s cover4s cover5s 
							mean=count1m count2m count3m count4m count5m 
								 cover1m cover2m cover3m cover4m cover5m;
run;
data quadhistory3; set quadhistory2; keep count1s count2s count3s count4s count5s 
										  cover1m cover2m cover3m cover4m cover5m 
										  spnum plotnum bcat soil hydr aspect elev slope;
*proc print data=quadhistory3 (firstobs=1 obs=30); title 'quadhistory3'; run;

proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3; by spnum;
	class soil ;
	**tested yrs 3-5, NS: bcat*soil, hydr, aspect, slope, interactions;
	*cover3m NS in any count3s models;
	*year2: slope only included for species 1 and 3, other species' models are better without.
		none of the interactions are sig.;
	*year1: soil, cover1m, slope, elev;
	model count1s =  soil   / dist=negbin solution;
	*model count2s = bcat soil slope / dist=negbin solution;
	*model count2s = bcat soil aspect / dist=negbin solution;
	*model count2s = bcat soil hydr / dist=negbin solution;
	*model count2s = bcat soil bcat*soil / dist=negbin solution;
	*model count2s = bcat soil  elev / dist=negbin solution;
	*model count2s = bcat soil cover2m elev bcat*cover2m bcat*elev soil*cover3m soil*elev cover2m*elev/ dist=negbin solution;
	*lsmeans soil  / ilink cl;
	*output out=glmout resid=ehat;
run;

*breaking down modeling per species;
proc sort data=quadhistory3; by spnum;
data quadhistoryDILI; set quadhistory3; if spnum=1; run;
data quadhistoryDIOL; set quadhistory3; if spnum=2; run;
data quadhistoryDISP; set quadhistory3; if spnum=3; run;
data quadhistoryHELA; set quadhistory3; if spnum=4; run;
data quadhistoryLETE; set quadhistory3; if spnum=5; run;

proc glimmix data=quadhistoryDILI; 
	*class soil ;  
	model count1s =  elev / dist=negbin solution; 
	*lsmeans soil / ilink cl;
	output out=glmout resid=ehat;
run;
*soil, cover1m, and elev are separately sig (+ good fit models), but any combination and all NS;

proc glimmix data=quadhistoryDIOL; 
	class soil;  
	*sig: soil;
	model count1s = soil / dist=negbin solution; 
	lsmeans  soil / ilink cl;
	output out=glmout resid=ehat;
run;

proc glimmix data=quadhistoryDISP; 
	class soil ;  
	model count1s = soil / dist=negbin solution; 
	*lsmeans soil / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=quadhistoryHELA; 
	*class aspect;  
	model count1s = slope  / dist=negbin solution; 
	*model with soil is no good--converges but nonsensical results, prob not enough in gravel;
	*other vars NS except slope, but again--model is no good (scale parameter is ~0);
	*lsmeans soil / ilink cl;
	output out=glmout resid=ehat;
run;
proc univariate data=glmout plot ; var soil slope; run; 
proc plot data=quadhistoryHELA; plot count3s*soil count1s*slope ; run;

* cover1m bcat soil hydr aspect elev slope;
proc glimmix data=quadhistoryLETE; 
	*class aspect ;  
	model count1s = slope  / dist=negbin solution; 
	*lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;
