data piquil; set alld;
	if (subp = 'seed') | (subp = 'shrp') | (subp = 'shru') | (subp = 'seep');
	keep aspect bcat coun covm elev heig hydrn plot slope soileb sspp subp year prpo; 
run;  
proc sort data=piquil; by subp plot sspp year bcat covm coun heig soileb elev slope aspect hydrn prpo; run;
proc means data=piquil noprint sum; by subp plot sspp year bcat covm coun heig soileb elev slope aspect hydrn prpo; var coun; 
  output out=piquil2 sum=nperspp; run; *N=1753;
/* proc print data=piquil2; title 'pi-qu-il numplantdata';   run;
  var plot sspp year burn prpo covm soil elev slope aspect hydr nperspp; run;   
* N = 442 species-plot-year combinations;
* piquil2 contains: obs, plot, sspp, year, burn, prpo, covm, soil, elev, slope, aspect, hydr, nperspp
  nperspp = # of sdlngs/stems per species per plot/year;  */

*reassigning nperspp to nquma3, nqumax, npitax, nilvox. This gives num per species where each species
has its own variable for count;
data holdquma3; set piquil2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'QUMA3'); nquma3 = nperspp; 
	proc sort data=holdquma3; by plot bcat year; 
data holdqumax; set piquil2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'QUMAx'); nqumax = nperspp;
	proc sort data=holdqumax; by plot bcat year; 
data holdpitax; set piquil2; if (subp = 'seed' | subp = 'shrp') & (sspp = 'PITAx'); npitax = nperspp; 
	proc sort data=holdpitax; by plot bcat year; 
data holdilvox; set piquil2; if (subp = 'seep' | subp = 'shru') & (sspp = 'ILVOx'); nilvox = nperspp; 
run;
/* proc print data=holdquma3; run; 	*N=231;
   proc print data=holdqumax; run; 	*N=170;	
   proc print data=holdpitax; run; 	*N=166;
   proc print data=holdilvox; run; 	*N=207; */

proc sort data=piquil2; by plot bcat year; run;
*n(spp) is count, pa(spp) is presence/absence;
data piquil3; merge holdquma3 holdqumax holdpitax holdilvox piquil2; by plot bcat year;
  if (nquma3 = .) then nquma3=0; if (nquma3=0) then paquma3=0; if (nquma3 ^= 0) then paquma3=1;
  if (nqumax = .) then nqumax=0; if (nqumax=0) then paqumax=0; if (nqumax ^= 0) then paqumax=1;
  if (npitax = .) then npitax=0; if (npitax=0) then papitax=0; if (npitax ^= 0) then papitax=1;
  if (nilvox = .) then nilvox=0; if (nilvox=0) then pailvox=0; if (nilvox ^= 0) then pailvox=1; 
  drop _TYPE_ _FREQ_ sspp nperspp;  * dropping sspp & nperspp - become garbage;
run;

/* proc print data=piquil3; title 'piquil'; run;  * N = 1753; 
proc contents data = piquil3; run;
proc freq data=piquil3; tables soileb*npitax; title 'piquil'; run;
