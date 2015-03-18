* run allyrs import ext drive current.sas FIRST!;

* this is code03172015.sas;

* NOTE: TREE data does not have burn;

* densiometer cover = burn year burn*year;
* no densiometer data in 1999 thru 2008;
* all plots 2010 thru 2014 have densiometer data;


data alldx; set alld; if (covm NE . & burn NE .);  * N = 40224;
  if (year < 2011) then do; prepost = 'pref'; yrA = year; yrB =.;     end;
  if (year > 2011) then do; prepost = 'post'; yrA = .;    yrB = year; end;
  if (year = 2011) then do; prepost = 'fire'; yrA = .;    yrB = .;    end;
  * if (covm = .) then covcheck = 1; * if (covm NE .) then covcheck = 0;
run;
* reduce to actual N of separate values;
proc sort data=alldx; by plot burn year prepost yrA yrB;     * to keep all variables, put in this list;
proc means data=alldx mean noprint; var covm; by plot burn year prepost yrA yrB;
  output out=alldxbyplot mean=covm;
* proc print data=alldxbyplot; title 'alldxbyplot';  * N = 191 burn X year obs, all after 2008;
run;

/* checking code;
* proc freq data=alldx; * table burn*year prepost*year prepost*burn;
run;
* TREE data does not have burn;
data checkcovm; set alldx; if (burn=. & subp ^= 'tree'); run; * N = 4179 missing burn;
proc print data=checkcovm (firstobs=1000 obs=1200); var year burn covm subp; run;
proc print data=alld (firstobs=1 obs=20); var year burn covm; run;
proc print data=alldx (firstobs=1 obs=20); var year yrA yrB prepost burn covm; run;
*/
proc glm data=alldxbyplot;	title 'cover';  * N = 128 because 2010 & 2011 dropped; 
	class burn;
	model covm = yrB burn yrB*burn;
	output out=glmout2 r=ehat;
run;
proc sort data=glmout2; by burn;
proc univariate data=glmout2 plot normal; var ehat covm; run;
proc univariate data=glmout2 plot normal; var ehat covm; by burn; run;
proc sort data=glmout2; by burn;
proc univariate data=glmout2 plot normal; var covm; by burn; run;
* a few burn=4 plots have large positive ehat meaning higher cover than expected,
   mean for burn=4 is very low - due standing dead in 2012?;
* nlf thinks, burn3 and burn4 have narrow range of ehat (except for high outliers in burn4)
  which means not enough ehat value on 'shoulders' of the distribution;

* BUT plot is a random repeated factor;

data postburn; set alldxbyplot; if (year > 2011);
proc glimmix data=postburn; title 'glimmix - random plot';
  class burn plot year;
  model covm = year burn year*burn / distribution=normal;
  random plot(burn);
  output out=glmout2 resid=ehat;
run;
* use this;


proc glimmix data=postburn; title 'glimmix - repeated code';
  class burn plot year;
  model covm = year burn year*burn / distribution=normal;
  random year / subject=plot(burn);
  output out=glmout2 resid=ehat;
run;
* crash: can't estimate both var(yr) and var(res). note that df yearxplot = dfe;  

* how to do an anova in glimmix;
* note: glimmix with normal distribution reports MSE instead of chisq/df;
proc glm data=postburn; title 'simple anova';
  class burn plot year;
  model covm = year burn year*burn plot(burn);
run;
proc glimmix data=postburn; title 'simple anova via glmmix';
  class burn plot year;
  model covm = year burn year*burn plot(burn) / distribution=normal;
  output out=glmout2 resid=ehat;
run;




