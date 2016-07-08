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
	*pa5 NS: bcat*soil, slope, aspect;
	*pa5 sig: bcat soil cover5 hydr elev;
	class bcat soil ; by spnum; 
 	model pa5 = bcat soil cover5 elev / dist=binomial  solution;
	*model pa5 = bcat soil slope / dist=binomial solution;
	*model pa5 = bcat soil aspect / dist=binomial solution;
	*model pa5 = bcat soil hydr / dist=binomial solution;
	*model pa5 = bcat soil cover5 / dist=binomial solution;
	*model pa5 = bcat soil cover5 hydr elev / dist=binomial solution;
	*model pa5 = bcat soil cover5 hydr elev / dist=binomial ddfm=bw solution;
	*model pa5 = bcat soil bcat*soil / dist=binomial solution;
	*model pa5 = bcat soil cover5 elev  / dist=binomial solution;
	random plotnum / subject = bcat*soil;
	*lsmeans bcat soil / ilink cl;
	*output out=glmout resid=ehat;
run;

*herbbyquad pa models;
proc sort data=herbbyquad; by spnum;
proc glimmix data=herbbyquad; 
	class bcat soil plotnum yearnum; by spnum; 
	*model pa = cover yearnum / dist=binomial solution;  
	model pa = bcat soil cover bcat*soil yearnum/ dist=binomial solution; 
	*model pa = bcat soil yearnum / dist=binomial solution; *best models;
	random plotnum / subject = bcat*soil;
	*lsmeans bcat / ilink cl;
	*output out=glmout resid=ehat;
run;

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
	class  soil ;
	*tested yrs 3-5, NS: bcat*soil, hydr, aspect, slope, interactions;
	*cover3m NS in any count3s models;
		*year2: recheck slope, sig. on some.;
	*model count2s =  bcat soil / dist=negbin solution;
	*model count2s = bcat soil slope / dist=negbin solution;
	*model count2s = bcat soil aspect / dist=negbin solution;
	*model count2s = bcat soil hydr / dist=negbin solution;
	*model count2s = bcat soil bcat*soil / dist=negbin solution;
	*model count2s = bcat soil  elev / dist=negbin solution;
	*model count2s = bcat soil cover2m elev bcat*cover2m bcat*elev soil*cover3m soil*elev cover2m*elev/ dist=negbin solution;
	lsmeans  soil / ilink cl;
	output out=glmout resid=ehat;
run;

*herbbyquad count models;
proc sort data=herbbyquad; by spnum plotnum yearnum bcat soil hydr aspect elev slope;
proc means data=herbbyquad sum mean noprint; by spnum plotnum yearnum bcat soil hydr aspect elev slope;
	var count cover; output out=herbbyquad2 sum=counts covers mean=countm coverm;
run;
data herbbyquad3; set herbbyquad2; keep counts coverm spnum plotnum yearnum bcat soil hydr aspect elev slope;
proc print data=herbbyquad3; title 'herbbyquad3'; run;

proc sort data=herbbyquad3; by spnum;
proc glimmix data=herbbyquad3; 
	class bcat soil yearnum; by spnum; 
	model counts = bcat soil yearnum bcat*soil / dist=negbin solution; 
	*random plotnum / subject = bcat*soil;
	*lsmeans bcat*soil / ilink cl;
	output out=glmout resid=ehat;
run;
