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

* yearnum bcat soil hydr aspect elev slope coverm;
proc sort data=herbbyquad3; by spnum; run;
proc glimmix data=herbbyquad3; by spnum;
	class bcat soil yearnum ;  
	*NS: bcat*soil, soil*yearnum;
	model counts = bcat soil yearnum slope / dist=negbin solution; 
	*model counts = bcat soil yearnum  bcat*soil bcat*yearnum soil*yearnum / dist=negbin solution; *interactions NS;
	*model counts = bcat soil yearnum  / dist=negbin solution; 
	*lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;

*breaking down modeling per species and removing noburn;
/*
data noburn; set fivesp; if bcat=1; run;
proc print data=noburn; run;
bcat=1 in:
	plot 1218, year 2005. 16 DISP.
	plot 1223, year 2006. 7 DIOL, 6 LETE;
*/
data herbbyquad4; set herbbyquad3; if bcat=1 then delete; run;
proc sort data=herbbyquad4; by spnum;
data herbbyquadDILI; set herbbyquad4; if spnum=1; run;
data herbbyquadDIOL; set herbbyquad4; if spnum=2; run;
data herbbyquadDISP; set herbbyquad4; if spnum=3; run;
data herbbyquadHELA; set herbbyquad4; if spnum=4; run;
data herbbyquadLETE; set herbbyquad4; if spnum=5; run;

* yearnum bcat soil hydr aspect elev slope coverm;
proc glimmix data=herbbyquadDILI; 
	class yearnum bcat soil ;  
	*model counts = bcat soil yearnum bcat*soil bcat*yearnum soil*yearnum / dist=negbin solution; 
	model counts = yearnum bcat soil elev yearnum*bcat / dist=negbin solution; *best model--interactions NS;
	*model counts = slope / dist=negbin solution; 
	lsmeans  yearnum bcat soil / ilink cl;
	*lsmestimate 'sand vs gravel' soil 1 -1 ;
	*output out=glmout resid=ehat;
run;
/*
data noburn; set fivesp; if bcat=1; run;
proc print data=noburn; run;
bcat=1 in:
	plot 1218, year 2005. 16 DISP.
	plot 1223, year 2006. 7 DIOL, 6 LETE;
*/

proc glimmix data=herbbyquadDIOL; 
	class yearnum bcat soil;  
	*NS: bcat*soil, soil*yearnum, elev, hydr, slope, hydr, coverm bcat;
	*model counts = yearnum soil / dist=negbin solution;
	*model counts = yearnum soil aspect / dist=negbin solution; *aspect likely sig. b/c most obs in flat--
	most areas are flat;
	model counts = yearnum bcat soil / dist=negbin solution; *best model, interactions NS;
	*lsmeans yearnum bcat soil / ilink cl;
	*output out=glmout resid=ehat;
run;
proc freq data=herbbyquadDIOL; tables bcat*soil / chisq ;  run;
proc plot data=herbbyquadDIOL; plot bcat*soil; run;
*more light burn  obs in sandy soil;

* yearnum bcat soil hydr aspect coverm elev slope;
proc glimmix data=herbbyquadDISP; 
	class yearnum bcat ;  
	*model counts = bcat yearnum aspect elev slope / dist=negbin solution; 
	model counts = yearnum bcat elev bcat*elev / dist=negbin solution; 
	*bcat and coverm independently sig., when both included bcat becomes NS. Inclusion of coverm
	makes a poorer-fit model;
	*comparing bcat 1 and 2 at 3 elevations;
	estimate 'bcat 1 vs 2 at 130ft' bcat -1 1 bcat*elev -130 130 ;
 	estimate 'bcat 1 vs 2 at 155ft' bcat -1 1 bcat*elev -155 155 ;
 	estimate 'bcat 1 vs 2 at 180ft' bcat -1 1 bcat*elev -180 180 ;
 	*estimates of counts in bcat 1 at 3 elevations;
  	estimate 'counts for bcat 1 at 130ft' intercept 1 bcat 1 0 elev 130 bcat*elev 130 0 ; 
  	estimate 'counts for bcat 1 at 155ft' intercept 1 bcat 1 0 elev 155 bcat*elev 155 0 ; 
	estimate 'counts for bcat 1 at 180ft' intercept 1 bcat 1 0 elev 180 bcat*elev 180 0 ; 
    *estimates of counts in bcat2 at 3 elevations;                    
  	estimate 'counts for bcat 2 at 130ft' intercept 1 bcat 0 1 elev 130 bcat*elev 0 130 ; 
  	estimate 'counts for bcat 2 at 155ft' intercept 1 bcat 0 1 elev 155 bcat*elev 0 155 ; 
	estimate 'counts for bcat 2 at 180ft' intercept 1 bcat 0 1 elev 180 bcat*elev 0 180 ; 
	lsmeans yearnum bcat / ilink cl;
	output out=glmout resid=ehat;
run;
proc plot data=herbbyquadDISP; plot elev*bcat; run;
*elev main effect NS, but slope of elev is different at each level of bcat;

* yearnum bcat soil hydr aspect coverm elev slope;
*marginal--bcat, aspect;
*yes--cover;
*bad fit--bcat, soil (sort of--x2/df=2.05), hydr aspect slope--poisson much worse;
proc glimmix data=herbbyquadHELA; 
	class bcat ;  
	model counts = yearnum bcat/ dist=negbin solution; 
	*lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;

proc glimmix data=herbbyquadLETE; 
	class bcat soil yearnum;  
	model counts = bcat soil yearnum elev / dist=negbin solution; 
	lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;
