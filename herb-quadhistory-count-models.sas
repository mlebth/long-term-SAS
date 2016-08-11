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
*round1: 1-DILI, 2-DIOL, 3-DISP, 4-HELA, 5-LETE;
*round2: 1-DIAN, 2-ERSP, 3-LEDU, 4-PAPL, 5-SCSC;

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
*proc sort data=quadhistory3; by plotnum spnum; 
proc print data=quadhistory3; title 'quadhistory3'; run;

proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3; by spnum;
	class soil ;
	**tested yrs 3-5, NS: bcat*soil, hydr, aspect, slope, interactions;
	*cover3m NS in any count3s models;
	*year2: slope only included for species 1 and 3, other species' models are better without.
		none of the interactions are sig.;
	*year1: soil, cover1m, slope, elev;
	*model count2s =  soil  / dist=negbin solution;
	model count2s = bcat soil slope / dist=negbin solution;
	*model count2s = bcat soil aspect / dist=negbin solution;
	*model count2s = bcat soil hydr / dist=negbin solution;
	*model count2s = bcat soil bcat*soil / dist=negbin solution;
	*model count2s = bcat soil  elev / dist=negbin solution;
	*model count2s = bcat soil cover2m elev bcat*cover2m bcat*elev soil*cover3m soil*elev cover2m*elev/ dist=negbin solution;
	*lsmeans soil  / ilink cl;
	*output out=glmout resid=ehat;
run;

***testing for correlations/colliniarity;
*categorical vars--using proc freq;
proc freq data=quadhistory3; tables bcat*soil / chisq ;  run;

*continuous vars--Spearman/Pearson correlation coefficients;
proc corr data=quadhistory3 spearman pearson; 
   var  cover1m;
   with slope;
run;

*continuous*categorical--ANOVA, Kruskal-Wallis;
proc glimmix data=quadhistory3;
	class soil;
	model soil=elev;
run;
proc npar1way data = quadhistory3;
  class soil;
  var elev;
run;
****done testing for correlations/colliniarity;

*breaking down modeling per species for years 1&2;
proc sort data=quadhistory3; by spnum;
/*
data quadhistoryDILI; set quadhistory3; if spnum=1; run;
data quadhistoryDIOL; set quadhistory3; if spnum=2; run;
data quadhistoryDISP; set quadhistory3; if spnum=3; run;
data quadhistoryHELA; set quadhistory3; if spnum=4; run;
data quadhistoryLETE; set quadhistory3; if spnum=5; run;
*/
data quadhistoryDIAN; set quadhistory3; if spnum=1; run;
data quadhistoryERSP; set quadhistory3; if spnum=2; run;
data quadhistoryLEDU; set quadhistory3; if spnum=3; run;
data quadhistoryPAPL; set quadhistory3; if spnum=4; run;
data quadhistorySCSC; set quadhistory3; if spnum=5; run;
proc print data=quadhistoryLEDU; run;

proc glimmix data=quadhistoryLEDU; 
	*class hydr ;  
	*model count5s =  cover5m / dist=negbin solution; 
	model count4s =  cover4m / dist=negbin solution; 
	*model count3s =  cover3m / dist=negbin solution; 
	* Models for years 1 and 2 can't be calculated, following errors appear:
	ERROR: Floating Point Zero Divide.
	ERROR: Termination due to Floating Point Exception;
	*lsmeans bcat / ilink cl;
	*output out=glmout resid=ehat;
run;

* bcat soil hydr aspect elev slope cover1m;
proc glimmix data=quadhistorySCSC; 
	class bcat ;  
	model count5s =  bcat / dist=negbin solution; 
	*model count4s =  bcat / dist=negbin solution; *did not converge with aspect;
	*model count3s =  bcat elev/ dist=negbin solution; 
	*model count2s =  cover2m  / dist=negbin solution; *did not converge with cover2m, no var sig.;
	*model count1s =  cover1m  / dist=negbin solution; *no var sig.;
	lsmeans bcat / ilink cl;
	*output out=glmout resid=ehat;
run;


proc glimmix data=quadhistoryDILI; 
	class soil ;  
	*model count2s =  bcat slope / dist=negbin solution; 
	model count1s =  soil / dist=negbin solution; 
	*cover1m is related to elev and soil type, best fit is cover1m;
	*lsmeans bcat / ilink cl;
	*output out=glmout resid=ehat;
run;
*year2-only bcat;
*year 1- soil, cover1m, and elev are separately sig (+ good fit models), but any combination and all NS;
proc corr data=quadhistoryDILI spearman pearson; 
   var  cover1m;
   with elev;
run;
proc plot data=quadhistorydili; plot cover1m*elev; run;
proc npar1way data = quadhistorydili;
  class soil;
  var cover1m; *var elev;
run;
*greater cover at higher elev, marginally more cover in sandy soils;
*no sig. correlation between elev and soil type;

proc glimmix data=quadhistoryDIOL; 
	class soil ;  
	*sig (year1): soil;
	model count1s = soil  / dist=negbin solution; 
	*bcat and soil separately sig, together NS;
	*model count1s = soil / dist=negbin solution; 
	lsmeans  soil / ilink cl;
	output out=glmout resid=ehat;
run;
proc freq data=quadhistoryDIOL; tables bcat*soil / chisq ;  run;
*too few obs in soil type 2 (gravel);

* bcat soil hydr aspect elev slope cover1m;
proc glimmix data=quadhistoryDISP; 
	class bcat ;  
	model count2s = bcat  / dist=negbin solution; 
		*bcat and cover2m both sig separately, together neither are--bcat doing the 'work'
		Kruskal-Wallis test--x2=8.1681, p=.0043;
	*model count1s = cover1m / dist=negbin solution; 
	lsmeans bcat / ilink cl;
	*output out=glmout resid=ehat;
run;
proc npar1way data = quadhistoryDISP;
  class bcat;
  var cover2m;
run; *greater cover in lower burn class--canopy was consumed;
proc plot data=quadhistoryDISP; plot cover2m*bcat; run;

* bcat soil hydr aspect elev slope cover1m;
proc glimmix data=quadhistoryHELA; 
	*class soil;  
	*model count2s = slope  / dist=negbin solution; 
	model count1s = slope  / dist=poisson solution; 
	*model with soil and slope sig but poor fit. switched to poisson--good fit and sig. for 
	slope, good fit but NS for soil, poor fit for other vars;
	*lsmeans soil / ilink cl;
	output out=glmout resid=ehat;
run;
proc univariate data=glmout plot ; var soil slope; run; 
proc plot data=quadhistoryHELA; plot count3s*soil count1s*slope ; run;

* bcat soil hydr aspect elev slope cover1m;
proc glimmix data=quadhistoryLETE; 
	*class aspect ;  
	*model count2s = bcat  / dist=negbin solution; *cover2m sig alone, not with bcat;
	model count1s = cover1m  / dist=negbin solution; 
	*lsmeans bcat / ilink cl;
	*output out=glmout resid=ehat;
run;
