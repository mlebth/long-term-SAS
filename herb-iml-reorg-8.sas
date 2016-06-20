*creating a set of herbs;
data herb1; set herbx;
	*removing blank lines;
	if sspp='     ' then delete;
	*removing 1999--data are of extremely poor quality;
	if year=1999 	then delete;
	*type 1--it is a plant. type 2--zero plants were found in that plot/year;
  	type = 1;     		  			  	
 	if (sspp = 'XXXXx') then type = 2;   
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo type; 
run; *n=12,544;
proc sort data=herb1; by sspp plot quad year bcat covm coun soileb elev slope aspect hydrn prpo type; run; 
*proc print data=herb1 (firstobs=1 obs=20); title 'herb1'; run;

*quad to plot (so that we don't need plot anymore, but can merge it back in). should be uniquad to plot;
proc sort data=herb1; by plot quad;
proc means data=herb1 mean noprint; var coun; by plot quad;
	output out=quadtoplot mean=mcoun;
run;
data quadtoplot2; set quadtoplot; uniquad=_n_; keep plot quad uniquad;
*proc print data=quadtoplot2 (firstobs=1 obs=20); title 'quadtoplot2'; run;
proc sort data=herb2; by plot quad; proc sort data=quadtoplot2; by plot quad;
data herb2; merge herb1 quadtoplot2; by plot quad; run;
*proc print data=herb2 (firstobs=1 obs=20); title 'herb2';run;

proc sort data=herb2; by plot quad year;
proc means data=herb2 n noprint; var uniquad; by plot quad year;
	output out=quadsum n=nuniquad;
run;
data quadsum2; set quadsum; keep plot year nuniquad;
proc sort data=quadsum2; by nuniquad;
*proc print data=quadsum2 ; title 'quadsum2'; run;

proc iml;

use quadsum2; read all into matquad;
nrecords=nrow(matquad);
ncolumns=ncol(matquad);

do i=1 to nrecords;
	if nuniquad < 10;

/*
to add empty quads:
create new dataset--
make an iml loop.
	if sum of quads is < 10: 
		quad=quad+1
in same loop or another, create uniquad.
then back out of iml--if species='' then species ='XXXXx'	

proc iml;

use herbquad; read all into mattemp;
nrecord=nrow(mattemp);
 
matquad=mattemp;
	
do i = 1 to nrecords;
	do j = 1 to ncolumns;
		*fill mattemp with 9999;
		mattemp[i,j]=9999;
			*fill matpa with 0s (absent) or 1s (present);
			if (matcount[i,j]=0) then matpa[i,j]=0;
			if (matcount[i,j]>0) then matpa[i,j]=1;
	end;
end;
print matpa;	*not working--still includes values >1;
*/

data fivesp; set herb2; if (sspp='DILI2' | sspp='DIOLx' | sspp='HELA5' | sspp='DISP2' | sspp='POPR4'); 
*proc print data=fivesp (firstobs=1 obs=10); title 'fivesp'; run; *n=2994;

*getting stem counts;
proc sort data=fivesp; by sspp; run;
proc means data=fivesp noprint n sum mean min max; by sspp; var coun;
  output out=sumstems n=n sum=sumcount mean=meancount min=mincount max=maxcount;
data sumstems1; set sumstems; drop _TYPE_ _FREQ_; RUN;
proc sort data=sumstems1; by sumcount n;
*proc print data=sumstems1; title 'sumstems';run;

*plot translation dataset--orig plot names to nums 1-56;
data plotid; set fivesp; dummy = 1; keep plot dummy;
proc sort data=plotid; by plot; run;
proc means data=plotid noprint mean; by plot; var dummy;
  output out=plotid2 mean = mean;
*proc print data=plotid2; title 'plotid2'; run;
data plotid3; set plotid2; plotnum = _n_; keep plot plotnum;
*proc print data=plotid3; title 'plotid3';
run; *n=54;
proc sort data=fivesp; by plot; proc sort data=plotid3; by plot;
data fivesp2; merge fivesp plotid3; by plot; 
*proc print data=fivesp2 (firstobs=1 obs=10); title 'fivesp2'; run;

*species translation dataset--orig sp codes to nums 1-315;
proc sort data=fivesp2; by sspp;
proc means data=fivesp2 mean noprint; var coun; by sspp;
	output out=splist mean=mcoun;
data splist2; set splist; spnum=_n_; keep sspp spnum;
*proc print data=splist2; title 'splist2'; run;
 
*dataset of vars by plot-year. can be added back to any dataset organized by plot;
proc sort data=fivesp2; by plot year;
proc means data=fivesp2 mean noprint; var aspect bcat quad covm elev hydrn slope soileb prpo type; by plot year;
	output out=plotvars mean=aspect bcat quad mcov elev hydrn slope soileb prpo type;
data varplotyr; set plotvars; keep plot year aspect bcat quad mcov elev hydrn slope soileb type;
*proc print data=varplotyr (firstobs=1 obs=10); title 'varplotyr'; run; 

*extracting only vars used in iml;
proc sort data=fivesp2; by sspp; proc sort data=splist2; by sspp;
data herbmerge; merge fivesp2 splist2; by sspp;
	keep plotnum quad year spnum coun;
*proc print data=herbmerge (firstobs=1 obs=10); title 'herbmerge'; run;
*proc contents data=herbmerge; run;

proc iml;

nsp = 5; nquad=470; newnrows = nsp*nquad; *2350;
*set up matrixcountquad with one row per sp x quad.  
put quad into col1, put spcode into col2, col  3-7 fill with 0s;

*importing;
use herbmerge; read all into inputmatrix;			
nrecords = nrow(inputmatrix);				* print nrecords; *2994;
ncolumns = ncol(inputmatrix);				* print ncolumns; *5;

*creating a new matrix;
*7 columns will be 2 from herbmerge (quad, spnum) plus a column for 
each year w/ counts (1111, 2012, 2013, 2014, 2015);
matcountquad=j(newnrows,7,0); 					

*order of variables: 1--quad, 2--coun, 3--year, 4--plotnum, 5--spnum;
quad = 1; sp=1; 
do i = 1 to newnrows;
	matcountquad[i,1] = quad;
	matcountquad[i,2] = sp;
	quad = quad + 1;
	if quad > nquad then do;
		sp=sp+1; quad = 1;
	end; 
end; 
print matcountquad;
nrecordscount=nrow(matcountquad);	*print nrecordscount; *2350;
ncolumnscount=ncol(matcountquad);	*print ncolumnscount; *8;

do i = 1 to newnrows;   * go through imported data set;
    tempquadid = inputmatrix[i,1];
    tempcount  = inputmatrix[i,2];
    tempyr     = inputmatrix[i,3];
    *tempspid  = inputmatrix[i,5];
	targetrow  = (sp-1)*nquad + tempquadid; *for some reason says 2356 rows;
    if (tempyr = 1111) then targetcol = 2 + 1;
	*years 2011-2015 in rows 4-8;
    if (tempyr > 2000) then targetcol = 3 + (tempyr - 2011);
    matcountquad[targetrow,targetcol] = tempcount;
end;

matpaquad=matcountquad;

*fill matrixpaquad;
do i = 1 to newnrows;
   do j = 3 to 8;
     if matrixcountquad[i,j] > 0 then matrixpaquad[i,j] = 1;
	end; 
end;

*labeling columns;
cnames = {'time1', 'time2', 'year1', 'year2', 'prpo', 'plot', 'quad', 'type', 'spid',
		  'coun',  'bcat', 'aspect', 'hydr', 'soil', 'elev', 'slope', 'cov1', 'cov2'};
create herbdat from matnumdat [colname = cnames];
append from matnumdat;

quit;

*proc print data=herbdat (firstobs=111 obs=120); title 'herbdat'; run;

*checking that values for each variable look right;
proc sort data=herbdat; by spid;
proc means data=herbdat noprint; 
	output out=datcheck;
*proc print data=datcheck; title 'datcheck'; run; *looks good;

*species names were changed to codes for iml, but easier for me if they're character variables--
changing them back;
data herbdat1; set herbdat;
	if spid=1 then sspp=('ACGR2');	if spid=46 then sspp=('CHTE1');	if spid=91 then sspp=('DILI5');		if spid=136 then sspp=('GAPE2');	if spid=181 then sspp=('LERE2');	if spid=226 then sspp=('PHCI4');	if spid=271 then sspp=('SOCA6');
	if spid=2 then sspp=('AGFA2');	if spid=47 then sspp=('CIHO2');	if spid=92 then sspp=('DIOLS');		if spid=137 then sspp=('GAPI2');	if spid=182 then sspp=('LESPE');	if spid=227 then sspp=('PHHE4');	if spid=272 then sspp=('SOEL3');
	if spid=3 then sspp=('AGHYx');	if spid=48 then sspp=('CITE2');	if spid=93 then sspp=('DIOLx');		if spid=138 then sspp=('GAPU3');	if spid=183 then sspp=('LEST4');	if spid=228 then sspp=('PHHE5');	if spid=273 then sspp=('SONU2');
	if spid=4 then sspp=('AIEL4');	if spid=49 then sspp=('CLMA4');	if spid=94 then sspp=('DIOVx');		if spid=139 then sspp=('GAPUx');	if spid=184 then sspp=('LEST5');	if spid=229 then sspp=('PHMO9');	if spid=274 then sspp=('SOOLx');
	if spid=5 then sspp=('ALCA3');	if spid=50 then sspp=('CNTEx');	if spid=95 then sspp=('DIRAx');		if spid=140 then sspp=('GAREx');	if spid=185 then sspp=('LETEx');	if spid=230 then sspp=('PHTEx');	if spid=275 then sspp=('SOPYx');
	if spid=6 then sspp=('AMAR2');	if spid=51 then sspp=('COBA2');	if spid=96 then sspp=('DISC3');		if spid=141 then sspp=('GAST2');	if spid=186 then sspp=('LEVI7');	if spid=231 then sspp=('PLHOx');	if spid=276 then sspp=('SORAx');
	if spid=7 then sspp=('AMPSx');	if spid=52 then sspp=('COCA5');	if spid=97 then sspp=('DISP2');		if spid=142 then sspp=('GECA5');	if spid=187 then sspp=('LIARx');	if spid=232 then sspp=('PLODx');	if spid=277 then sspp=('SPCLx');
	if spid=8 then sspp=('ANGL2');	if spid=53 then sspp=('COERx');	if spid=98 then sspp=('DITE2');		if spid=143 then sspp=('GIINx');	if spid=188 then sspp=('LIASx');	if spid=233 then sspp=('PLVIx');	if spid=278 then sspp=('SPCO1');
	if spid=9 then sspp=('ANVI2');	if spid=54 then sspp=('COTI3');	if spid=99 then sspp=('DIVI7');		if spid=144 then sspp=('GOGO2');	if spid=189 then sspp=('LIEL1');	if spid=234 then sspp=('PLWRx');	if spid=279 then sspp=('SPINx');
	if spid=10 then sspp=('ARAL3');	if spid=55 then sspp=('COWR3');	if spid=100 then sspp=('DRAN3');	if spid=145 then sspp=('GYAMx');	if spid=190 then sspp=('LIELx');	if spid=235 then sspp=('POERx');	if spid=280 then sspp=('SPOBx');
	if spid=11 then sspp=('ARDE3');	if spid=56 then sspp=('CRCA6');	if spid=101 then sspp=('ELAN5');	if spid=146 then sspp=('HEAMx');	if spid=191 then sspp=('LIME2');	if spid=236 then sspp=('POPEx');	if spid=281 then sspp=('SPVAx');
	if spid=12 then sspp=('ARERx');	if spid=57 then sspp=('CRDI1');	if spid=102 then sspp=('ELIN3');	if spid=147 then sspp=('HEAN3');	if spid=192 then sspp=('LOPUx');	if spid=237 then sspp=('POPOx');	if spid=282 then sspp=('STBI2');
	if spid=13 then sspp=('ARLA6');	if spid=58 then sspp=('CRGL2');	if spid=103 then sspp=('ERCUx');	if spid=148 then sspp=('HECR9');	if spid=193 then sspp=('LOSQx');	if spid=238 then sspp=('POPR4');	if spid=283 then sspp=('STHE4');
	if spid=14 then sspp=('ARLO1');	if spid=59 then sspp=('CRHOH');	if spid=104 then sspp=('ERGEx');	if spid=149 then sspp=('HEDE4');	if spid=194 then sspp=('LURE2');	if spid=239 then sspp=('POTEx');	if spid=284 then sspp=('STLE5');
	if spid=15 then sspp=('ARPU8');	if spid=60 then sspp=('CRMI8');	if spid=105 then sspp=('ERHI2');	if spid=150 then sspp=('HEGEx');	if spid=195 then sspp=('MADE3');	if spid=240 then sspp=('POVEx');	if spid=285 then sspp=('STLE6');
	if spid=16 then sspp=('ARPUP');	if spid=61 then sspp=('CRMO6');	if spid=106 then sspp=('ERHI9');	if spid=151 then sspp=('HEGR1');	if spid=196 then sspp=('MEPE3');	if spid=241 then sspp=('PSOB3');	if spid=286 then sspp=('STPI3');
	if spid=17 then sspp=('ASNU4');	if spid=62 then sspp=('CRRI3');	if spid=107 then sspp=('ERHIx');	if spid=152 then sspp=('HELA5');	if spid=197 then sspp=('MINU6');	if spid=242 then sspp=('PTAQx');	if spid=287 then sspp=('STSYx');
	if spid=18 then sspp=('ASOEx');	if spid=63 then sspp=('CRSA4');	if spid=108 then sspp=('ERINx');	if spid=153 then sspp=('HELA6');	if spid=198 then sspp=('MOCAx');	if spid=243 then sspp=('PTVI2');	if spid=288 then sspp=('STUM2');
	if spid=19 then sspp=('ASTUx');	if spid=64 then sspp=('CRWI5');	if spid=109 then sspp=('ERLO5');	if spid=154 then sspp=('HENI4');	if spid=199 then sspp=('MOCIx');	if spid=244 then sspp=('PYCA2');	if spid=289 then sspp=('SYPA1');
	if spid=20 then sspp=('BABR2');	if spid=65 then sspp=('CYCR6');	if spid=110 then sspp=('ERMU4');	if spid=155 then sspp=('HERO2');	if spid=200 then sspp=('MOPUx');	if spid=245 then sspp=('PYMU2');	if spid=290 then sspp=('TAOFx');
	if spid=21 then sspp=('BOHI2');	if spid=66 then sspp=('CYEC2');	if spid=111 then sspp=('ERSE2');	if spid=156 then sspp=('HIGR3');	if spid=201 then sspp=('MOVEx');	if spid=246 then sspp=('RHGL2');	if spid=291 then sspp=('TEONx');
	if spid=22 then sspp=('BOLA2');	if spid=67 then sspp=('CYFI2');	if spid=112 then sspp=('ERSEx');	if spid=157 then sspp=('HYAR3');	if spid=202 then sspp=('NELU2');	if spid=247 then sspp=('RHHAx');	if spid=292 then sspp=('TRBE3');
	if spid=23 then sspp=('BOLAT');	if spid=68 then sspp=('CYFI4');	if spid=113 then sspp=('ERSPx');	if spid=158 then sspp=('HYDRx');	if spid=203 then sspp=('NOBI2');	if spid=248 then sspp=('RHLAx');	if spid=293 then sspp=('TRBE4');
	if spid=24 then sspp=('BRJAx');	if spid=69 then sspp=('CYHYx');	if spid=114 then sspp=('ERST3');	if spid=159 then sspp=('HYGEx');	if spid=204 then sspp=('NUCAx');	if spid=249 then sspp=('RHMI4');	if spid=294 then sspp=('TRBEx');
	if spid=25 then sspp=('BRMI2');	if spid=70 then sspp=('CYLU2');	if spid=115 then sspp=('EUCO1');	if spid=160 then sspp=('HYGL2');	if spid=205 then sspp=('NUTEx');	if spid=250 then sspp=('RUABx');	if spid=295 then sspp=('TRBI2');
	if spid=26 then sspp=('BRTRx');	if spid=71 then sspp=('CYPER');	if spid=116 then sspp=('EUCO7');	if spid=161 then sspp=('HYHI2');	if spid=206 then sspp=('OELAx');	if spid=251 then sspp=('RUAL4');	if spid=296 then sspp=('TRDI2');
	if spid=27 then sspp=('BUCA2');	if spid=72 then sspp=('CYPL3');	if spid=117 then sspp=('EUDE1');	if spid=162 then sspp=('HYMI2');	if spid=207 then sspp=('OELIx');	if spid=252 then sspp=('RUCO2');	if spid=297 then sspp=('TRFL2');
	if spid=28 then sspp=('BUCIx');	if spid=73 then sspp=('CYRE1');	if spid=118 then sspp=('EUHE1');	if spid=163 then sspp=('HYSEx');	if spid=208 then sspp=('OLBOx');	if spid=253 then sspp=('RUHA2');	if spid=298 then sspp=('TRFLC');
	if spid=29 then sspp=('CAFAx');	if spid=74 then sspp=('CYRE2');	if spid=119 then sspp=('EUPI3');	if spid=164 then sspp=('JATAx');	if spid=209 then sspp=('OXDI2');	if spid=254 then sspp=('RUHI2');	if spid=299 then sspp=('TRFLF');
	if spid=30 then sspp=('CAIN2');	if spid=75 then sspp=('CYRE5');	if spid=120 then sspp=('EUSE2');	if spid=165 then sspp=('JUBRx');	if spid=210 then sspp=('OXSTx');	if spid=255 then sspp=('RUHU6');	if spid=300 then sspp=('TRHIx');
	if spid=31 then sspp=('CALE6');	if spid=76 then sspp=('CYSUx');	if spid=121 then sspp=('EUSEx');	if spid=166 then sspp=('JUCO1');	if spid=211 then sspp=('PAANx');	if spid=256 then sspp=('SACA1');	if spid=301 then sspp=('TRPE4');
	if spid=32 then sspp=('CAMI5');	if spid=77 then sspp=('DADRx');	if spid=122 then sspp=('EVCAx');	if spid=167 then sspp=('JUDIx');	if spid=212 then sspp=('PABR2');	if spid=257 then sspp=('SACA3');	if spid=302 then sspp=('TRPU4');
	if spid=33 then sspp=('CAMI8');	if spid=78 then sspp=('DEAC3');	if spid=123 then sspp=('EVSEx');	if spid=168 then sspp=('JUMA4');	if spid=213 then sspp=('PADRx');	if spid=258 then sspp=('SCCA4');	if spid=303 then sspp=('TRRA5');
	if spid=34 then sspp=('CAMU4');	if spid=79 then sspp=('DECA3');	if spid=124 then sspp=('EVVEx');	if spid=169 then sspp=('JUTEx');	if spid=214 then sspp=('PAHI1');	if spid=259 then sspp=('SCCIx');	if spid=304 then sspp=('TRUR2');
	if spid=35 then sspp=('CEMIx');	if spid=80 then sspp=('DECIx');	if spid=125 then sspp=('FAREx');	if spid=170 then sspp=('JUVA2');	if spid=215 then sspp=('PAHOx');	if spid=260 then sspp=('SCOL2');	if spid=305 then sspp=('TYDOx');
	if spid=36 then sspp=('CENCH');	if spid=81 then sspp=('DELA2');	if spid=126 then sspp=('FIAU2');	if spid=171 then sspp=('KRDAx');	if spid=216 then sspp=('PALU2');	if spid=261 then sspp=('SCSCx');	if spid=306 then sspp=('UNGR3');
	if spid=37 then sspp=('CESP4');	if spid=82 then sspp=('DESEx');	if spid=127 then sspp=('FIPUx');	if spid=172 then sspp=('KROCx');	if spid=217 then sspp=('PANO2');	if spid=262 then sspp=('SEARx');	if spid=307 then sspp=('URCIx');
	if spid=38 then sspp=('CEVI2');	if spid=83 then sspp=('DIAC2');	if spid=128 then sspp=('FRFLx');	if spid=173 then sspp=('KRVIx');	if spid=218 then sspp=('PAPE5');	if spid=263 then sspp=('SIABx');	if spid=308 then sspp=('VEARx');
	if spid=39 then sspp=('CHAMx');	if spid=84 then sspp=('DIACx');	if spid=129 then sspp=('FRGR3');	if spid=174 then sspp=('LAHIx');	if spid=219 then sspp=('PAPL3');	if spid=264 then sspp=('SIAN2');	if spid=309 then sspp=('VETE3');
	if spid=40 then sspp=('CHAN5');	if spid=85 then sspp=('DIAN4');	if spid=130 then sspp=('GAAEx');	if spid=175 then sspp=('LALUx');	if spid=220 then sspp=('PAROx');	if spid=265 then sspp=('SICIx');	if spid=310 then sspp=('VILE2');
	if spid=41 then sspp=('CHCO1');	if spid=86 then sspp=('DICA3');	if spid=131 then sspp=('GAAMx');	if spid=176 then sspp=('LASEx');	if spid=221 then sspp=('PASE5');	if spid=266 then sspp=('SILIx');	if spid=311 then sspp=('VIMIx');
	if spid=42 then sspp=('CHIMx');	if spid=87 then sspp=('DICO1');	if spid=132 then sspp=('GAAN1');	if spid=177 then sspp=('LEAR3');	if spid=222 then sspp=('PASEC');	if spid=267 then sspp=('SIRHx');	if spid=312 then sspp=('VISOx');
	if spid=43 then sspp=('CHMA1');	if spid=88 then sspp=('DICO6');	if spid=133 then sspp=('GAAR1');	if spid=178 then sspp=('LEDUx');	if spid=223 then sspp=('PHABx');	if spid=268 then sspp=('SOAL6');	if spid=313 then sspp=('VUOCx');
	if spid=44 then sspp=('CHPI8');	if spid=89 then sspp=('DILA9');	if spid=134 then sspp=('GABR2');	if spid=179 then sspp=('LEHI2');	if spid=224 then sspp=('PHAM4');	if spid=269 then sspp=('SOAM4');	if spid=314 then sspp=('WAMAx');
	if spid=45 then sspp=('CHSE2');	if spid=90 then sspp=('DILI2');	if spid=135 then sspp=('GACA6');	if spid=180 then sspp=('LEMU3');	if spid=225 then sspp=('PHAN5');	if spid=270 then sspp=('SOASx');	if spid=315 then sspp=('XXXXx');
run;
*proc print data=herbdat1 (firstobs=1 obs=20); run;

************structure 1--prefire pooled, postfire pooled--to compare befre/after;
data herbdat2; set herbdat1;	
	drop time1 time2 year2 cov2; 
	rename year1=year cov1=caco;
run;

*herbs pre-fire;
data herbspre;  set herbdat2;
	if prpo=1;
run; *N=1388;
*pooling data in herbspre;
proc sort  data=herbspre; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect;
proc means data=herbspre n mean noprint; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspre n=ncov ncoun 
		   			  mean=mcov mcoun;
run;
*proc print data=mherbspre (firstobs=1 obs=20); title 'mherbspre'; run; *N=1063;

*herbs post-fire;
data herbspost; set herbdat2;
	if prpo=2; 
run; *N=11156;
proc sort  data=herbspost; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect;
proc means data=herbspost n mean noprint; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspost n=ncov ncoun 
		   			  	  mean=mcov mcoun;
run;
*proc print data=mherbspost (firstobs=1 obs=20); title 'mherbspost'; run; *N=5782;

*merging pre/post;
proc sort data=mherbspost; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect;
proc sort data=mherbspre; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect; run;
data herbprpo; merge mherbspost mherbspre; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_; 
run;
*proc print data=herbprpo (firstobs=1 obs=20); title 'herbprpo'; run;	*N=6845;


************structure 2--prefire pooled, 2011-2015 not pooled;
*herbs pre-fire;
data herbspre;  set herbdat2;
	if prpo=1;
	*setting year to 1111 for all pre-fire data (not 9999 so it will sort out first--logically easier;
	year=1111;
run; *N=1388;
*pooling data in herbspre;
proc sort  data=herbspre; by prpo year plot bcat quad spid sspp type elev hydr slope soil aspect;
proc means data=herbspre n mean noprint; by prpo year plot bcat quad spid sspp type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspre n=ncov ncoun 
		   			  mean=mcov mcoun;
run;
*proc print data=mherbspre (firstobs=1 obs=20); title 'mherbspre'; run; *N=1063;

*proc print data=herbspost (firstobs=1 obs=10); title 'herbspost'; run; *N=11156;
*merging pre/post;
proc sort data=mherbspre; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect;
proc sort data=herbspost; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect; run;
data herbbyyr; merge herbspost mherbspre; by prpo plot bcat quad spid sspp type elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ prpo; 
run;
*proc print data=herbbyyr (firstobs=1 obs=10); title 'herbbyyr'; run;	*N=12219;
