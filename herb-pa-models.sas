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
