*2 datasets (quadhistory, herbbyquad), both contain: 
rowid, plot, plotnum, quad, sspp, spnum, bcat, cover, soil, hydr, aspect, elev, slope
	--reminder: bcat [1-u, 2-s/l, 3-m/h], soil [1-sandy, 2-gravelly], hydr [1-no 2-yes]
				aspect [0-flat, 1-north, 2-east, 3-south, 4-west]

quadhistory also includes: count1-count5, pa1-pa5 (one for each of the 5 sp in dataset)
herbbyquad also includes:  count,         pa, yearnum, _FREQ_, _TYPE_;

*visualizing data;
proc plot data=herbbyquad; title 'herbbyquad'; 
	plot coun*bcat coun*yearnum coun*soil; run;
proc plot data=quadhistory; title 'quadhistory counts'; 
	plot count1*sspp count2*sspp count3*sspp count4*sspp count5*sspp; run;
/* *not very useful;
proc plot data=quadhistory; title 'quadhistory env (class vars)'; 
	plot bcat*sspp soil*sspp hydr*sspp aspect*sspp; run;
proc plot data=quadhistory; title 'quadhistory env (continuous vars)'; 
	plot cover*sspp elev*sspp slope*sspp; run;
*/

*checking species list;
proc print data=splist2; run;
*1-DILI, 2-DIOL, 3-DISP, 4-HELA, 5-LETE;

*quadhistory pa models;
proc sort data=quadhistory; by spnum;
proc glimmix data=quadhistory; 
	class plotnum bcat soil; by spnum; 
	*model pa5 = cover / dist=binomial solution;  
	*model pa5 = bcat soil cover bcat*soil / dist=binomial solution; 
	model pa5 = bcat soil cover / dist=binomial solution; *best models;
	random plotnum / subject = bcat*soil;
	lsmeans bcat / ilink cl;
	output out=glmout resid=ehat;
run;

*quadhistory count models;
proc sort data=quadhistory; by spnum plotnum;
proc means data=quadhistory sum mean noprint; by spnum plotnum;
	var count5 bcat soil cover;
	output out=quadhistory2 sum=count5s bcats soils covsum mean=count5m bcatm soilm covmean;
run;
data quadhistory3; set quadhistory2; keep count5s bcatm soilm covmean spnum plotnum;
proc print data=quadhistory3; title 'quadhistory3'; run;

proc univariate data=quadhistory3 plot; var count5s;
run;

proc sort data=quadhistory3; by spnum;
proc glimmix data=quadhistory3; by spnum;
	class bcatm soilm;
	*model count5s=bcatm soilm bcatm*soilm / dist=negbin solution;
	model count5s=bcatm soilm covmean / dist=negbin solution;
run;

*herbbyquad models;
proc sort data=herbbyquad; by spnum plotnum yearnum;
proc means data=herbbyquad sum mean noprint; by spnum plotnum yearnum;
	var count bcat soil cover;
	output out=herbbyquad2 sum=counts bcats soils covsum mean=countm bcatm soilm covmean;
run;
data herbbyquad3; set herbbyquad2; keep counts bcatm soilm covmean spnum plotnum yearnum;
proc print data=herbbyquad3; title 'herbbyquad3'; run;

proc print data=herbbyquad (firstobs=1 obs=100); title 'herbbyquad'; run;

proc univariate data=herbbyquad3 plot; var counts;
run;
proc sort data=herbbyquad3; by spnum;

proc glimmix data=herbbyquad3; 
	class bcatm soilm yearnum; by spnum; 
	model counts = bcatm soilm yearnum bcatm*soilm / dist=negbin solution; 
	*random plotnum / subject = bcat*soil;
	*lsmeans bcat*soil / ilink cl;
	output out=glmout resid=ehat;
run;
