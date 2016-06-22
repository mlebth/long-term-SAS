*creating a set of herbs;
data herb1x; set herbx;
	*removing blank lines;
	if sspp='     ' then delete;
	*removing 1999--data are of extremely poor quality;
	if year=1999 	then delete;
	*type 1--it is a plant. type 2--zero plants were found in that plot/year;
  	type = 1;     		  			  	
 	if (sspp = 'XXXXx') then type = 2;   
	keep aspect bcat coun quad covm elev hydr plot slope soileb sspp year prpo type; 
	rename soileb=soil hydrn=hydr;
run; *n=12,544;
proc sort data=herb1x; by sspp plot quad year bcat covm coun soil elev slope aspect hydr prpo type; run; 
*proc print data=herb1x (firstobs=1 obs=20); title 'herb1x'; run;

proc freq data=herb1x; table plot; run;

/*
proc iml;
*import dataset with lines just for plot and quad;

quadsum=10

do i = 1 to nrows;
	mattemp[i,1] = plot;
	mattemp[i,2] = sspp;
	if quadsum < 11 then do;
		quad
		sspp = 'XXXXx';	
	end; 
end; 

quit;
*/

data fivesp; set herb1x; if (sspp='DILI2' | sspp='DIOLx' | sspp='HELA5' | sspp='DISP2' | sspp='POPR4'); 
*proc print data=fivesp (firstobs=1 obs=10); title 'fivesp'; run; *n=2994;
*********includes all vars for 5 species;

*plot translation dataset--orig plot names to nums 1-56;
data plotid; set fivesp; dummy = 1; keep plot dummy;
proc sort data=plotid; by plot; run;
proc means data=plotid noprint mean; by plot; var dummy;
  output out=plotid2 mean = mean;
*proc print data=plotid2; title 'plotid2'; run;
data plotid3; set plotid2; plotnum = _n_; keep plot plotnum;
*proc print data=plotid3; title 'plotid3';
run; *n=54;
*********includes plot and plotnum;

proc sort data=fivesp; by plot; 
proc sort data=plotid3; by plot;
data fivesp2; merge fivesp plotid3; by plot; 
proc sort data=fivesp2; by plotnum;
*proc print data=fivesp2; title 'fivesp2'; run;
*********includes all vars for 5 species plus plotnum;

*quad to plot (so that we don't need plot anymore, but can merge it back in). should be uniquad to plot;
proc sort data=fivesp; by plot quad;
proc means data=fivesp mean noprint; var coun; by plot quad;
	output out=quadtoplot mean=mcoun;
run;
data quadtoplot2; set quadtoplot; uniquad=_n_; keep plot quad uniquad;
*proc print data=quadtoplot2; title 'quadtoplot2'; run;
*********includes plot, plotnum, quad, and uniquad;

proc sort data=plotid3; by plot; 
proc sort data=quadtoplot2; by plot;
data quadplot; merge plotid3 quadtoplot2; by plot; run;
proc sort data=quadplot; by plotnum uniquad;
*proc print data=quadplot; title 'quadplot';run;
*********includes all vars for 5 species plus plotnum and uniquad;

proc sort data=fivesp2; by plot quad; 
proc sort data=quadplot; by plot quad;
data fivesp3; merge fivesp2 quadplot; by plot quad; run;
proc sort data=fivesp3; by plotnum uniquad;
*proc print data=fivesp3 (firstobs=1 obs=100); title 'fivesp3';run;
*********includes all vars for 5 species plus plotnum and uniquad;

*getting stem counts;
proc sort data=fivesp; by sspp; run;
proc means data=fivesp noprint n sum mean min max; by sspp; var coun;
  output out=sumstems n=n sum=sumcount mean=meancount min=mincount max=maxcount;
data sumstems1; set sumstems; drop _TYPE_ _FREQ_; RUN;
proc sort data=sumstems1; by sumcount n;
*proc print data=sumstems1; title 'sumstems';run;
*********includes sspp, n, sumcount, meancount, mincount, maxcount;

*species translation dataset--orig sp codes to nums 1-315;
proc sort data=fivesp; by sspp;
proc means data=fivesp mean noprint; var coun; by sspp;
	output out=splist mean=mcoun;
data splist2; set splist; spnum=_n_; keep sspp spnum;
*proc print data=splist2; title 'splist2'; run;
*********includes sspp and spnum;
 
proc sort data=fivesp3; by sspp; 
proc sort data=splist2; by sspp;
data fivesp4; merge fivesp3 splist2; by sspp; run;
proc sort data=fivesp4; by sspp spnum;
*proc print data=fivesp4 (firstobs=1000 obs=1010); title 'fivesp4';run;
*proc contents data=fivesp4; run;
*********includes all vars for 5 species plus plotnum, uniquad, and spnum;

*dataset of vars by plot-year. can be added back to any dataset organized by plot;
proc sort data=fivesp4; by plot year;
proc means data=fivesp4 mean noprint; var aspect bcat quad covm elev hydr slope soil prpo type; by plot year;
	output out=plotvars mean=aspect bcat quad mcov elev hydr slope soil prpo type;
data varplotyr; set plotvars; keep plot year aspect bcat quad mcov elev hydr slope soil type;
*proc print data=varplotyr (firstobs=1 obs=10); title 'varplotyr'; run; 

*extracting only vars used in iml;
proc sort data=fivesp4; by sspp; 
proc sort data=splist2; by sspp;
data fiveiml; merge fivesp4 splist2; by sspp;
	keep plotnum uniquad year spnum coun;
proc sort data=fiveiml; by uniquad spnum;
*proc print data=fiveiml (firstobs=1 obs=100); title 'fiveiml'; run; *2994;
*proc contents data=fiveiml; run; *coun, plotnum, spnum, uniquad, year;

*getting count means by year-quad-sp because in some plots, the same sp might be recorded
2x in the same quad. probably from partners working together;
proc sort data=fiveiml; by year plotnum uniquad spnum;
proc means data=fiveiml mean noprint; var coun; by year plotnum uniquad spnum;
	output out=fiveiml1 mean=mcoun;
data fiveiml2; set fiveiml1; if year < 2011 then year = 1111; drop _TYPE_ _FREQ_;
proc sort data=fiveiml2; by uniquad spnum;
*proc print data=fiveiml2 (firstobs=1 obs=20); title 'fiveiml2'; run; *2984;
*proc contents data=fiveiml2; run; *mcoun, plotnum, spnum, uniquad, year;

proc iml;

nsp = 5; nquad=470; newnrows = (nsp*nquad); *2350;
*set up matrixcountquad with one row per sp x quad.  
put quad into col1, put spcode into col2, col  3-7 fill with 0s;

*importing;
use fiveiml2; read all into inputmatrix;			
nrecords = nrow(inputmatrix);				* print nrecords; *2984;
ncolumns = ncol(inputmatrix);				* print ncolumns; *5;
*print inputmatrix;

*creating a new matrix;
*7 columns will be 2 from fiveiml2 (uniquad, spnum) plus a column for 
each year w/ counts (1111, 2012, 2013, 2014, 2015);
matcountquad=j(newnrows,7,0); 					

quad = 1; sp=1; 
do i = 1 to newnrows;
	matcountquad[i,1] = quad;
	matcountquad[i,2] = sp;
	quad = quad + 1;
	if quad > nquad & sp < nsp then do;
		sp=sp+1; quad = 1;
	end; 
end; 
*print matcountquad;
nrecordscount=nrow(matcountquad);	*print nrecordscount; *2350;
ncolumnscount=ncol(matcountquad);	*print ncolumnscount; *7;

*order of variables: 1--year, 2--plotnum, 3--uniquad, 4--spnim, 5--mcoun;
do i = 1 to newnrows;   * go through imported data set;
    tempyr     = inputmatrix[i,1]; 
	tempquadid = inputmatrix[i,3];  
	tempsp = inputmatrix[i,4];  
	tempcount  = inputmatrix[i,5];
	targetrow  = (tempsp-1)*nquad + tempquadid; 
	*years 2011-2015 in rows 4-8;
    if (tempyr = 1111) then targetcol = 2 + 1; 
    if (tempyr > 2000) then targetcol = 3 + (tempyr - 2011); 
    matcountquad[targetrow,targetcol] = tempcount;
end;	
*print matcountquad;

*labeling columns;
countnames = {'uniquad', 'spnum', 'pref', 'count12', 'count2013', 'count2014', 'count2015'};
create herbcount from matcountquad [colname = countnames];
append from matcountquad;

matpaquad=matcountquad;

*fill matpaquad;
do i = 1 to newnrows;
   do j = 3 to 7;
     if matcountquad[i,j] > 0 then matpaquad[i,j] = 1;
	end; 
end;
*print matpaquad; 

*labeling columns;
panames = {'uniquad', 'spnum', 'pref', 'pa12', 'pa2013', 'pa2014', 'pa2015'};
create herbpa from matpaquad [colname = panames];
append from matpaquad;

quit; run;

*proc print data=herbcount; title 'herbcount'; run;
*proc print data=herbpa; title 'herbpa'; run;

*herbcount merges;
proc sort data=herbcount; by spnum;
proc sort data=splist2; by spnum;
data herbcount1; merge herbcount splist2; by spnum;
run;
*proc print data=herbcount1 (firstobs=1 obs=30); title 'herbcount1'; run;

proc sort data=herbcount1; by uniquad;
proc sort data=quadtoplot2; by uniquad;
data herbcount2; merge herbcount1 quadtoplot2; by uniquad;
run;
*proc print data=herbcount2 (firstobs=1 obs=30); title 'herbcount2'; run;

proc sort data=herbcount3; by plot;
proc sort data=plotid3; by  plot;
data herbcount3; merge herbcount3 plotid3; by  plot;
run;
********final herbcount;
*proc print data=herbcount3 (firstobs=1 obs=30); title 'herbcount3'; run;

*herbpa merges;
proc sort data=herbpa; by spnum;
proc sort data=splist2; by spnum;
data herbpa1; merge herbpa splist2; by spnum;
run;
*proc print data=herbpa1 (firstobs=1 obs=30); title 'herbpa1'; run;

proc sort data=herbpa1; by uniquad;
proc sort data=quadtoplot2; by uniquad;
data herbpa2; merge herbpa1 quadtoplot2; by uniquad;
run;
*proc print data=herbpa2 (firstobs=1 obs=30); title 'herbpa2'; run;

proc sort data=herbpa2; by plot;
proc sort data=plotid3; by  plot;
data herbpa3; merge herbpa2 plotid3; by  plot;
run;
********final heabpa;
*proc print data=herbpa3 (firstobs=1 obs=30); title 'herbpa3'; run;


****************
*proc print data=herbcount3 (firstobs=1 obs=30); title 'herbcount3'; run;
*proc print data=herbpa3 (firstobs=1 obs=30); title 'herbpa3'; run;
