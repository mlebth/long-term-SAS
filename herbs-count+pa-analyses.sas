proc print data=quadhistory3 (firstobs=1 obs=20); title 'quadhistory3'; run; *n=270;

*import herb data--rank 1-5;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\quadhistory-2ndrun.csv"
out=run2 dbms=csv replace; getnames=yes; run;  * N = 2700;
*proc print data=run2 ; title 'run2'; run;
*proc contents data=run2; run;

proc glimmix data=quadhistory3; by spnum;
    class burn ;
    **tested yrs 3-5, NS: bcat*soil, hydr, aspect, slope, interactions;
    *cover3m NS in any count3s models;
    *year2: slope only included for species 1 and 3, other species' models are better without.
        none of the interactions are sig.;
    *year1: soil, cover1m, slope, elev;
    *model count1s =  burn soil slope  / dist=negbin solution;
    *model count2s = bcat soil slope / dist=negbin solution;
    *model count2s = bcat soil aspect / dist=negbin solution;
    *model count2s = bcat soil hydr / dist=negbin solution;
    *model count2s = bcat soil bcat*soil / dist=negbin solution;
    model count5s = cover5m   / dist=negbin solution;
    *model count2s = bcat soil cover2m elev bcat*cover2m bcat*elev soil*cover3m soil*elev cover2m*elev/ dist=negbin solution;
    *lsmeans  burn  / ilink cl;
    *output out=glmout resid=ehat;
run;
*2 datasets (quadhistory, herbbyquad), both contain: 
rowid, plot, plotnum, quad, sspp, spnum, bcat, soil, hydr, aspect, elev, slope
	--reminder: bcat [1-u, 2-s/l, 3-m/h], soil [1-sandy, 2-gravelly], hydr [1-no 2-yes]
				aspect [0-flat, 1-north, 2-east, 3-south, 4-west]
quadhistory also includes: count1-count5, pa1-pa5, cover1-cover5 (1 col/var/yr in dataset)
herbbyquad also includes:  count, cover, pa, yearnum, _FREQ_, _TYPE_;

*import herb data--rank 6-10;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\quadhistory-1strun.csv"
out=run2 dbms=csv replace; getnames=yes; run;  * N = 2750;
*proc print data=run2 (firstobs=1 obs=20); title 'run2'; run;
*proc contents data=run2; run;

*import plothist for burn;
proc import datafile="D:\Werk\Research\FMH Raw Data, SAS, Tables\FFI long-term data\plothist.csv"
out=plothist dbms=csv replace; getnames=yes; run;  * N = 2750;
*proc print data=plothist (firstobs=1 obs=20); title 'plothist'; run;
*proc contents data=plothist; run;

*cover was imported as char, converting to numeric;
data run3;set run2;
   orig1=cover1;orig2=cover2;orig3=cover3;orig4=cover4;orig5=cover5;
   new1 = input(orig1, best32.);new2 = input(orig2, best32.);new3 = input(orig3, best32.);
	new4 = input(orig4,best32.);new5 = input(orig5,best32.);
   rename new1=cov1 new2=cov2 new3=cov3 new4=cov4 new5=cov5;
   drop orig1 orig2 orig3 orig4 orig5 cover1 cover2 cover3 cover4 cover5;
run;
*proc contents data=run3; run;
*proc print data=run3 (firstobs=1 obs=20); title 'run3'; run;

*plot translation--numbering them 1-56;
data plotid; set plothist; dummy = 1; keep plot burn dummy;
proc sort data=plotid; by plot; run;
proc means data=plotid noprint mean; by plot; var dummy;
  output out=plotid2 mean = mean;
* proc print data=plotid2; title 'plotid2'; run;
data plotid3; set plotid2; plotnum = _n_; keep plot plotnum;
* proc print data=plotid3; title 'plothist';
run; * n = 54, max = 55;
*proc print data=plotid3 (firstobs=1 obs=3); title 'plotid3'; run;
proc sort data=plotid3; by plot; proc sort data=plothist; by plot; run;
data plothistfinal; merge plotid3 plothist; by plot; keep plot plotnum burn; run;
*proc print data=plothistfinal (firstobs=1 obs=3); title 'plothistfinal'; run;

*merging herb data with plothist to put back in burn severity;
*burn: 1=unburned, 2=scorch, 3=light, 4=mod, 5=heavy;
proc sort data=run3; by plotnum;
proc sort data=plothistfinal; by plotnum; 
data quadhistory; merge run3 plothistfinal; by plot; drop rowid plotnum; run; *N=2751;
*proc print data=quadhistory (firstobs=1 obs=400); title 'quadhistory'; run;


*visualizing data;
proc plot data=herbbyquad; title 'herbbyquad'; 
	plot count*bcat count*yearnum count*soil; run;
proc plot data=quadhistory; title 'quadhistory counts'; 
	plot count1*sspp count2*sspp count3*sspp count4*sspp count5*sspp; run;

*checking species list;
proc print data=splist2; run;
*round1: 1-DILI, 2-DIOL, 3-DISP, 4-HELA, 5-LETE;
*round2: 1-DIAN, 2-ERSP, 3-LEDU, 4-PAPL, 5-SCSC;

**************quadhistory pa models;
proc sort data=quadhistory; by spnum;
proc glimmix data=quadhistory method=laplace; 
	*pa5 NS: bcat*soil, slope, aspect;
	*pa5 sig: bcat soil cover5 hydr elev;
	class bcat soil ; by spnum; 
 	model pa5 = bcat soil cov5 elev / dist=binomial  solution;
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

**************herbbyquad pa models;
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

***************quadhistory count models;
proc sort data=quadhistory; by plot spnum burn bcat soil hydr aspect elev slope;
proc means data=quadhistory sum mean noprint; by plot spnum burn bcat soil hydr aspect elev slope;
	var count1 count2 count3 count4 count5 cov1 cov2 cov3 cov4 cov5;
	output out=quadhistory2 sum=count1s count2s count3s count4s count5s  
								cover1s cover2s cover3s cover4s cover5s 
							mean=count1m count2m count3m count4m count5m 
								 cover1m cover2m cover3m cover4m cover5m;
run;
data quadhistory3; set quadhistory2; keep count1s count2s count3s count4s count5s 
										  cover1m cover2m cover3m cover4m cover5m 
										  spnum plot burn bcat soil hydr aspect elev slope;
if spnum=. then delete;
*proc print data=quadhistory3 ; title 'quadhistory3'; run; *n=270;

*all these notes are for 1st run;
proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3; by spnum;
	class  bcat soil hydr aspect;
	*model count1s =   cover1m / dist=negbin solution;
*with all: sp1: soil, elev, sp2: soil but poor fit, sp3: none, sp4 and 5: na;
*with soil and elev: sp1: less good. sp2: better. sp3-5: better, nothing sig.;
	model count2s =  bcat       / dist=negbin link=log solution;
	*model count3s =  burn soil  / dist=negbin solution;
	*model count4s =  burn soil  / dist=negbin solution;
	*model count4s =  burn soil cover4m burn*soil / dist=negbin solution;
	*lsmeans  burn soil burn*soil / ilink cl;
	*output out=glmout resid=ehat;
run;

*all these notes are for 2nd run;
proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3; by spnum;
	class  bcat soil hydr aspect;
	**tested yrs 3-5, NS: bcat*soil, hydr, aspect, slope, interactions;
	*cover3m NS in any count3s models;
	*year2: slope only included for species 1 and 3, other species' models are better without.
		none of the interactions are sig.;
	*year1: soil, cover1m, slope, elev;
	*model count1s =  burn soil slope  / dist=negbin solution;
	*model count5s =  cover5m / dist=negbin solution;
	*model count2s = burn soil aspect / dist=negbin solution;
	*model count2s = burn soil hydr / dist=negbin solution;
	model count5s = aspect/ dist=negbin solution;
	*model count4s =  burn/ dist=negbin solution;
	*model count2s = burn soil cover2m elev bcat*cover2m bcat*elev soil*cover3m soil*elev cover2m*elev/ dist=negbin solution;
	contrast 'flat v N' aspect 1 -1 0 0 0 ;
	contrast 'flat v E' aspect 1 0 -1 0 0 ;
	contrast 'flat v S' aspect 1 0 0 -1 0 ;
	contrast 'flat v W' aspect 1 0 0 0 -1 ;
	contrast 'N v E' aspect 0 1 -1 0 0 ;
	contrast 'N v S' aspect 0 1 0 -1 0 ;
	contrast 'N v W' aspect 0 1 0 0 -1 ;
	contrast 'E v S' aspect 0 0 1 -1 0 ;
	contrast 'E v W' aspect 0 0 1 0 -1 ;
	contrast 'S v W' aspect 0 0 0 1 -1;
	lsmeans  aspect / ilink cl;
	*output out=glmout resid=ehat;
run;

*redoing 2nd run using bcat instead of burn;
proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3 ; by spnum;
	class bcat soil hydr aspect;
	model count5s =  soil aspect slope elev aspect*slope / dist=negbin solution;
	*lsmeans bcat aspect  / ilink cl;
	*output out=glmout resid=ehat;
run;


***testing for correlations/colliniarity;
*categorical vars--using proc freq;
proc freq data=quadhistory3; tables bcat*soil / chisq ;  run;

*continuous vars--Spearman/Pearson correlation coefficients;
proc corr data=quadhistory3 spearman pearson; 
   var  cover2m;
   with burn;
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

***************************herbbyquad count models;
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

******************breaking down modeling per species, from quadhistory3;
proc sort data=quadhistory3; by spnum;
data quadhistoryDIAN; set quadhistory3; if spnum=1; run;
data quadhistoryERSP; set quadhistory3; if spnum=2; run;
data quadhistoryLEDU; set quadhistory3; if spnum=3; run;
data quadhistoryPAPL; set quadhistory3; if spnum=4; run;
data quadhistorySCSC; set quadhistory3; if spnum=5; run;

PROC PRINT data=quadhistoryledu; run; 
proc freq data=quadhistoryledu; run;
* coverm yearnum bcat soil hydr aspect elev slope;

proc glimmix data=quadhistoryLEDU; 
	class bcat ;  
	*NS: bcat*soil, soil*yearnum;
	*model count2s = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution; 
	model count2s = bcat elev slope / dist=negbin solution; 
	*not great--missing too many values for bcat*soil;
	lsmeans bcat / ilink cl;
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

proc glimmix data=quadhistoryLETE; 
	class bcat soil yearnum;  
	*NS: bcat*soil, soil*yearnum;
	model count2s = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution; 
	lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;


***********breaking down modeling per species and removing noburn, from herbbyquad3;
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
	*NS: bcat*soil, soil*yearnum;
	model counts = bcat soil yearnum elev bcat*soil soil*elev / dist=negbin solution; 
	lsmeans bcat*soil / ilink cl;
	*output out=glmout resid=ehat;
run;
