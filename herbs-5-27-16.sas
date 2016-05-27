proc sort data=herbdat2; by  plot sspp year bcat covm coun soileb elev slope aspect hydrn prpo; run;
'time1', 'time2', 'year1', 'year2', 'prpo', 'plot', 'quad', 'type', 'spid',
		  'coun',  'bcat', 'aspect', 'hydr', 'soil', 'elev', 'slope', 'cov1', 'cov2' yrcat sspp
proc means data=herbdat2 noprint sum; by subp plot sspp year bcat covm coun soileb elev slope aspect hydrn prpo; var coun; 
  output out=herb2 sum=nperspp; run; *N=11100;

*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set piquilseed2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'QUMA3'); nquma3 = nperspp; 
	proc sort data=holdquma3; by plot bcat year; 
data holdqumax; set piquilseed2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'QUMAx'); nqumax = nperspp;
	proc sort data=holdqumax; by plot bcat year; 
data holdpitax; set piquilseed2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'PITAx'); npitax = nperspp; 
	proc sort data=holdpitax; by plot bcat year; 
data holdilvox; set piquilseed2; if (subp = 'seep' | subp = 'shru') & (sspp = 'ILVOx'); nilvox = nperspp; 
data holdxxxxx; set piquilseed2; if (subp = 'seed' | subp = 'shru') & (sspp = 'XXXXx'); 
	nquma3 = nperspp; nqumax = nperspp;	npitax = nperspp; nilvox = nperspp; 
	proc sort data=holdxxxxx; by plot bcat year; 
run;
/* proc print data=holdquma3; run; 	*N=299;
   proc print data=holdqumax; run; 	*N=216;	
   proc print data=holdpitax; run; 	*N=231;
   proc print data=holdilvox; run; 	*N=252;    
   proc print data=holdxxxxx; run; 	*N=24; */

proc sort data=piquilseed2; by plot bcat year pltd; run;
*n(spp) is count, pa(spp) is presence/absence;
data piquilseed3; merge holdquma3 holdqumax holdpitax holdilvox holdxxxxx piquilseed2; by plot bcat year pltd;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nilvox = .) then nilvox=0; if (nilvox=0) then pailvox=0; if (nilvox ^= 0) then pailvox=1; 
  drop _TYPE_ _FREQ_ sspp nperspp;  * dropping sspp & nperspp - become garbage;
run;

/* proc print data=piquilseed3; title 'piquil'; run;  * N = 2247; 
proc contents data = piquilseed3; run;
proc freq data=piquilseed3; tables soileb*npitax; title 'piquil'; run;
proc freq data=piquilseed3; tables soileb*npitax; title 'piquil'; run;

*finding whether each is counted more than once
proc sql;
	select year, plot, sspp, subp
	from piquil
	where year eq 2002 and
		  sspp = 'QUMA3';
quit;
*A: NO, they are not counted twice. Won't affect abundance.

*checking for missing values. NONE;

*/

data piquilseed4; set piquilseed3; 	
 	keep aspect bcat covm elev heig hydrn nilvox npitax nquma3 nqumax plot year prpo slope soileb pltd;
run;  * N = 2247;
proc sort data=piquilseed4; by year prpo plot bcat aspect hydrn soileb pltd; run;

/* proc freq data=piquilseed4; tables pltd; run; *1776 sand, 471 gravel;
   proc contents data=piquilseed4; run; 
   proc print data=piquilseed4; title 'piquil4'; run; */

* Contents:
 				   	   #    Variable    Type    Len    Format     Informat
                      10    aspect      Num       8
                       3    bcat        Num       8
                       5    covm        Num       8
                       8    elev        Num       8    BEST12.    BEST32.
                       6    heig        Num       8    BEST12.    BEST32.
                      11    hydrn       Num       8
                      15    nilvox      Num       8
                      14    npitax      Num       8
                      12    nquma3      Num       8
                      13    nqumax      Num       8
                       1    plot        Num       8    BEST12.    BEST32. 
					  12    pltd        Num       8
                       4    prpo        Num       8
                       9    slope       Num       8    BEST12.    BEST32.
                       7    soileb      Num       8    BEST12.    BEST32.
                       2    year        Num       8    BEST12.    BEST32
;

proc means data=piquilseed4 mean noprint; by year plot bcat aspect hydrn soileb pltd;
  var nilvox npitax nquma3 nqumax covm elev slope heig;
  output out=piquilseed5 mean = milvox mpitax mquma3 mqumax mcov elev slope mhgt;
run;
data piquilseed6; set piquilseed5; drop _TYPE_; 
*proc print data=piquilseed6; title 'piquil6'; run; *N=267;
