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

*herbbyquad count models--pooling over quad;
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
	estimate 'bcat 1 vs 2 at 142ft' bcat -1 1 bcat*elev -142 142 ;
 	estimate 'bcat 1 vs 2 at 157ft' bcat -1 1 bcat*elev -157 157 ;
 	estimate 'bcat 1 vs 2 at 172ft' bcat -1 1 bcat*elev -172 172 ;
 	*estimates of counts in bcat 1 at 3 elevations;
  	estimate 'counts for bcat 1 at 142ft' intercept 1 bcat 1 0 elev 142 bcat*elev 142 0 ; 
  	estimate 'counts for bcat 1 at 157ft' intercept 1 bcat 1 0 elev 157 bcat*elev 157 0 ; 
	estimate 'counts for bcat 1 at 172ft' intercept 1 bcat 1 0 elev 172 bcat*elev 172 0 ; 
    *estimates of counts in bcat2 at 3 elevations;                    
  	estimate 'counts for bcat 2 at 142ft' intercept 1 bcat 0 1 elev 142 bcat*elev 0 142 ; 
  	estimate 'counts for bcat 2 at 157ft' intercept 1 bcat 0 1 elev 157 bcat*elev 0 157 ; 
	estimate 'counts for bcat 2 at 172ft' intercept 1 bcat 0 1 elev 172 bcat*elev 0 172 ; 
	lsmeans yearnum bcat / ilink cl;
	output out=glmout resid=ehat;
run;
proc plot data=herbbyquadDISP; plot elev*bcat; run;
proc freq data=herbbyquadDISP; tables elev*bcat; run; 
*min-127, max-187
25%: 142, 50%: 157, 75%: 172;
*elev main effect NS, but slope of elev is different at each level of bcat;

* yearnum bcat soil hydr aspect coverm elev slope;
*hydr and slope only ones far from NS;
/* *********************ignore below chunk, too messy--final model is below;
proc glimmix data=herbbyquadHELA;  *******************NOT YET RECORDED;
	class yearnum bcat soil aspect ;  
 *discarded models;
	*model counts = yearnum bcat / dist=negbin solution; 						*bcat p=.0504. 1590, 1604, 2.14;
	*model counts = yearnum bcat yearnum*bcat/ dist=negbin solution; 			*bcat p=.1001, yearnm*bcat p=.0001, 1568, 1590, 1.26;
	*model counts = yearnum soil/ dist=negbin solution; 						*soil p=.0995. 1591, 1605, 2.05;
	*model counts = yearnum aspect / dist=negbin solution; 						*aspect p=..0524. 1586, 1606, 2.09;
	*model counts = yearnum coverm / dist=negbin solution; 						*coverm p<0.0001, 1518, 1532, 1.19;
	*model counts = yearnum coverm yearnum*coverm / dist=negbin solution; 		*coverm p=.0185, yearnum*coverm p=.0068, 1503, 1525, 1.00;
	*model counts = yearnum elev / dist=negbin solution;						*elev p=0.0163 1588 1602 1.64; 
	*model counts = yearnum elev yearnum*elev / dist=negbin solution;			*elev p=0.0051 yearnum*elev p=0.0049 1538 1560 .77; 
	*model counts = yearnum bcat soil aspect coverm elev / dist=negbin solution; *bcat .0151 soil .0014 aspect .0055 coverm .0004 elev .9094. 1495 1523 1.01; 
	*model counts = yearnum bcat soil aspect coverm / dist=negbin solution;		*bcat .0153 soil .0004 aspect .0048 coverm .0004. 1495 1521 .99;
	model counts = yearnum bcat soil aspect coverm bcat*coverm / dist=negbin solution; *best model;
	*****the below models don't work;	
	*model counts = yearnum bcat soil aspect coverm bcat*aspect bcat*coverm soil*aspect / dist=negbin solution;
		*bcat .8029 soil <0.0001 aspect <0.0001 coverm 0.0003 bcat*aspect .0014 bcat*coverm .0009 soil*aspect <0.0001
		1453 1493 3.5;		
	*model counts = yearnum bcat soil aspect coverm 			bcat*coverm soil*aspect / dist=negbin solution;
		*bcat .8122 soil <0.0001 aspect 0.0012 coverm 0.0035 bcat*coverm .0072 soil*aspect 0.0009
		1475 1507 2.28;	
	*model counts = yearnum bcat soil aspect coverm bcat*aspect 			soil*aspect / dist=negbin solution;
		*bcat .0039 soil <0.0001 aspect 0.0003 coverm <0.0001 bcat*aspect .0041 soil*aspect 0.0005
		1465 1503 1.1;		
	*model counts = yearnum bcat soil aspect coverm bcat*aspect bcat*coverm 			/ dist=negbin solution;
		*bcat .6313 soil <0.0001 aspect .0008 coverm <0.0001 bcat*aspect .0071 bcat*coverm .0059
		1470 1506 1.33;	
	lsmeans yearnum bcat soil aspect / ilink cl;
	*output out=glmout resid=ehat;
run;
*/

proc glimmix data=herbbyquadHELA;  *******************NOT YET RECORDED;
	class yearnum bcat soil aspect ;  
	model counts = yearnum bcat soil aspect coverm  / dist=negbin solution; *best model;
/*
	*comparing bcat 1 and 2 at 3 covers;
	estimate 'bcat 1 vs 2 at 23.95% canopy cover' bcat -1 1 bcat*coverm -23.95 23.95 ;
 	estimate 'bcat 1 vs 2 at 47.74% canopy cover' bcat -1 1 bcat*coverm -47.74 47.74 ;
 	estimate 'bcat 1 vs 2 at 71.53% canopy cover' bcat -1 1 bcat*coverm -71.53 71.53 ;
 	*estimates of counts in bcat 1 at 3 elevations;
  	estimate 'counts for bcat 1 at 23.95% canopy cover' intercept 1 bcat 1 0 coverm 23.95 bcat*coverm 23.95 0 ; 
  	estimate 'counts for bcat 1 at 47.74% canopy cover' intercept 1 bcat 1 0 coverm 47.74 bcat*coverm 47.74 0 ; 
	estimate 'counts for bcat 1 at 71.53% canopy cover' intercept 1 bcat 1 0 coverm 71.53 bcat*coverm 71.53 0 ; 
    *estimates of counts in bcat2 at 3 elevations;                    
  	estimate 'counts for bcat 2 at 23.95% canopy cover' intercept 1 bcat 0 1 coverm 23.95 bcat*coverm 0 23.95 ; 
  	estimate 'counts for bcat 2 at 47.74% canopy cover' intercept 1 bcat 0 1 coverm 47.74 bcat*coverm 0 47.74 ; 
	estimate 'counts for bcat 2 at 71.53% canopy cover' intercept 1 bcat 0 1 coverm 71.53 bcat*coverm 0 71.53 ; 
*/
	lsmeans yearnum bcat soil aspect / ilink cl;
	output out=glmout resid=ehat;
run;
proc plot data=herbbyquadHELA; plot coverm*bcat; run;
proc freq data=herbbyquadHELA; tables coverm*bcat; run; 
*min-.16, max-95.32  23.79
25%: 23.95, 50%: 47.74, 75%: 71.53;

proc glimmix data=herbbyquadLETE; 
	class yearnum bcat soil ;  
	model counts = yearnum bcat soil / dist=negbin solution; *best model, interactions NS;
	lsmeans yearnum bcat soil / ilink cl;
	output out=glmout resid=ehat;
run;
