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

*herbbyquad count models;
proc sort data=herbbyquad; by spnum plotnum yearnum bcat soil hydr aspect elev slope;
proc means data=herbbyquad sum mean noprint; by spnum plotnum yearnum bcat soil hydr aspect elev slope;
	var count cover; output out=herbbyquad2 sum=counts covers mean=countm coverm;
run;
data herbbyquad3; set herbbyquad2; keep counts coverm spnum plotnum yearnum bcat soil hydr aspect elev slope;
*proc print data=herbbyquad3; title 'herbbyquad3'; run;

proc sort data=herbbyquad3; by spnum; run;
proc glimmix data=herbbyquad3; by spnum;
	class bcat soil yearnum ;  
	*NS: bcat*soil, soil*yearnum;
	*model counts = bcat soil yearnum coverm slope elev aspect hydr / dist=negbin solution; 
	model counts = bcat soil yearnum  bcat*soil bcat*yearnum soil*yearnum / dist=negbin solution; 
	*model counts = bcat soil yearnum  / dist=negbin solution; 
	*lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;

*breaking down modeling per species;
proc sort data=herbbyquad3; by spnum;
data herbbyquadDILI; set herbbyquad3; if spnum=1; run;
data herbbyquadDIOL; set herbbyquad3; if spnum=2; run;
data herbbyquadDISP; set herbbyquad3; if spnum=3; run;
data herbbyquadHELA; set herbbyquad3; if spnum=4; run;
data herbbyquadLETE; set herbbyquad3; if spnum=5; run;

proc glimmix data=herbbyquadDILI; 
	class soil yearnum  ;  
	*model counts = bcat soil yearnum bcat*soil bcat*yearnum soil*yearnum / dist=negbin solution; 
	model counts = soil yearnum / dist=negbin solution; 
	*model counts = slope / dist=negbin solution; 
	lsmeans  soil yearnum  / ilink cl;
	*output out=glmout resid=ehat;
run;
/*
data noburn; set fivesp; if bcat=1; run;
proc print data=noburn; run;
bcat=1 in:
	plot 1218, year 2005. 16 DISP.
	plot 1223, year 2006. 7 DIOL, 6 LETE;
*/

data dilinoburn; set herbbyquadDILI; if bcat NE 1; run;

* coverm yearnum bcat soil hydr aspect elev slope;
proc glimmix data=dilinoburn; 
	class bcat soil yearnum ;  
	*model counts = bcat soil yearnum bcat*soil bcat*yearnum soil*yearnum / dist=negbin solution; 
	model counts = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution;  *best model;
		* bcat*soil*elev NS;
	*model counts = bcat / dist=negbin solution; 
	*model counts = slope / dist=negbin solution; 
	*lsmeans bcat soil yearnum bcat*soil  / ilink cl;
	lsmestimate 'sand vs gravel' soil 1 -1 ;
	*output out=glmout resid=ehat;
run;

*re-run and record;
proc glimmix data=herbbyquadDIOL; 
	class soil yearnum aspect;  
	*NS: bcat*soil, soil*yearnum, elev, hydr, slope, hydr, coverm bcat;
	model counts = soil yearnum  aspect / dist=negbin solution; 
	lsmeans  soil yearnum aspect / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=herbbyquadDISP; 
	class bcat soil yearnum;  
	*NS: bcat*soil, soil*yearnum;
	model counts = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution; 
	lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=herbbyquadHELA; 
	class bcat soil yearnum;  
	*NS: bcat*soil, soil*yearnum;
	model counts = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution; 
	lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=herbbyquadLETE; 
	class bcat soil yearnum;  
	*NS: bcat*soil, soil*yearnum;
	model counts = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution; 
	lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;
