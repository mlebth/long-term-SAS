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
data herbbyquad2; set herbbyquad; if bcat=1 then delete; run;
proc sort data=herbbyquad2; by spnum;
data yearpaDILI; set herbbyquad2; if spnum=1; run;
data yearpaDIOL; set herbbyquad2; if spnum=2; run;
data yearpaDISP; set herbbyquad2; if spnum=3; run;
data yearpaHELA; set herbbyquad2; if spnum=4; run;
data yearpaLETE; set herbbyquad2; if spnum=5; run;

* yearnum bcat soil hydr aspect cover elev slope;
proc glimmix data=yearpaDILI method=laplace; 
	class yearnum bcat soil aspect;
	*model pa = yearnum bcat soil hydr  / dist=binomial solution; 
	model pa = yearnum bcat soil aspect elev / dist=binomial solution; *best model, interactions NS;
	*hydr sig. when there are fewer variables, but magnitude of effect is almost nothing, removed
	from model;
	random plotnum / subject = bcat*soil;
	lsmeans yearnum bcat soil aspect / ilink cl;
	*lsmeans yearnum bcat soil hydr  / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=yearpaDIOL method=laplace;  ************NOT YET DONE;
	class yearnum bcat soil hydr aspect;  
	model pa = yearnum bcat soil hydr aspect cover slope yearnum*bcat yearnum*hydr
	yearnum*aspect yearnum*cover yearnum*slope / dist=binomial solution; 
	random plotnum / subject = bcat*soil;
	lsmeans yearnum bcat soil hydr aspect yearnum*bcat yearnum*hydr
	yearnum*aspect / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=yearpaDISP method=laplace;  
	class yearnum bcat soil aspect;  
	model pa = yearnum bcat soil aspect cover elev slope bcat*soil bcat*aspect  
bcat*elev soil*aspect soil*elev soil*slope/ dist=binomial solution; *these are sig, interactions not tested yet;
	random plotnum / subject = bcat*soil;
	*lsmeans yearnum bcat soil aspect  bcat*soil bcat*aspect  / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=yearpaHELA method=laplace;  
	class yearnum bcat soil aspect hydr;  
	*model pa = yearnum bcat soil aspect hydr cover bcat*aspect bcat*cover
	soil*aspect aspect*hydr / dist=binomial solution; * elev + slope NS, int not tested yet;
	model pa = yearnum bcat soil aspect hydr cover yearnum*cover / dist=binomial solution; * elev + slope NS, int not tested yet;
	random plotnum / subject = bcat*soil;
	lsmeans yearnum bcat soil aspect hydr  / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=yearpaLETE method=laplace;  
	class yearnum bcat soil  aspect;  
	model pa = yearnum bcat soil aspect / dist=binomial solution; *best model;
	*soil*aspect showed as sig. but meaningless--estimates were impossible;
	random plotnum / subject = bcat*soil;
	lsmeans yearnum bcat soil aspect / ilink cl;
	*output out=glmout resid=ehat;
run;
