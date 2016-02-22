proc import datafile="G:\Research\seedlings.xls"
out=seed
dbms=excel replace; sheet=sheet1;
getnames=yes;
run;
proc contents data=seed; run;
proc print data=seed; run;


/**************hydromulch--logistic regression model with poisson distribution for count data*/
proc genmod data=seed;
freq num;
class hydromulch spp; 
model num = hydromulch spp hydromulch*spp/ dist=poi link=log;
lsmeans hydromulch/pdiff;
lsmeans spp/pdiff;
output out=results p =pred_num pred=re; 
run;
/*logliklihood (L1): 76375.2767*/

proc genmod data=seed  ;
freq num;
class hydromulch spp; 
model num = hydromulch spp / dist=poi link=log;
lsmeans hydromulch/pdiff;
lsmeans spp/pdiff;
output out=results p =pred_num pred=re; 
run;
/*logliklihood (L0): 76238.1561
-2(L0-L1)=-2(76238.1561-76375.2767)=274.2412
keep interaction in model?*/

/***********wildfire severity*/
proc genmod data=seed  ;
freq num;
class burnsev spp; 
model num = burnsev spp burnsev*spp/ dist=poi link=log;
output out=results p =pred_num pred=re; ; 
run;
/*logliklihood (L1): 79583.2247*/

proc genmod data=seed  ;
freq num;
class hydromulch spp; 
model num = hydromulch spp / dist=poi link=log;
lsmeans hydromulch/pdiff;
lsmeans spp/pdiff;
output out=results p =pred_num pred=re; 
run;
/*logliklihood (L0): 76238.1561
-2(L0-L1)=-2(76238.1561-79583.2247)=6690.1732
significant interaction, keep in model?*/



/*trying something different--burn severity and hydromulch at the same time*/
proc genmod data=seed  ;
freq num;
class burnsev hydromulch spp; 
model num = burnsev hydromulch spp/ dist=pois link=log;
output out=results p =pred_num pred=re; ; 
run;





proc import datafile="G:\Research\seedlings.xls"
out=oneperplot
dbms=excel replace; sheet=sheet3;
getnames=yes;
run;
proc contents data=oneperplot; run;
proc print data=oneperplot; run;


/***********glms etc***********/
/*hydro glm pita*/
data seed2; set seed; if spp=x then num=0;
	proc sort data=seed2; by plot; 
	proc print data=seed2;run;
data pita; set seed2; if spp="pita"; 
	proc sort data=pita; by plot; 
	proc print data=pita;run;
data quma; set seed2; if spp="quma";
	proc sort data=quma; by plot; 
data pita2; merge pita oneperplot; if num="." then num=0; by plot;
data quma2; merge quma oneperplot; if num="." then num=0; by plot;
	
proc print data=pita2; run;
proc glm data=pita2;
class hydromulch;
model num = hydromulch ; 
lsmeans  hydromulch/ pdiff;
output out=results p=pred_dist;
run;

proc print data=quma2; run;
proc glm data=quma2;
class hydromulch;
model num = hydromulch; 
lsmeans  hydromulch/ pdiff;
output out=results p=pred_dist;
run;




proc glm data=seed;
class hydromulch spp;
model num = spp;
output out=results p=pred_dist;
run;

/*not working??*/
proc sort data=results_pois; by hydromulch; run;

symbol1 i = join v=point l=32  c = black;
PROC GPLOT DATA=results_pois;
PLOT  pred_num*hydromulch ;
RUN;

/*burn glm?*/
proc glm data=seed;
class burnsev spp;
model num = burnsev;
output out=results p=pred_dist r=residuals;
run;

/*after genmod*/
proc sort data=results; by burnsev; run;

symbol1 i = join v=point l=32  c = black;
PROC GPLOT DATA=results;
PLOT  pred_num*burnsev ;
RUN;

