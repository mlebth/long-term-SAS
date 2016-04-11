data herb1; set herbx;
	if sspp='     ' then delete;
	if year=1999 	then delete;
  	type = 1;     		  			  	 * default - it is a plant;
 	if (sspp = 'XXXXx') then type = 2;   * type 2 means non-plant;
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo type; 
run; *n=12,544;

proc sort data=herb1; by sspp plot quad year bcat covm coun soileb elev slope aspect hydrn prpo type; run; 
*proc print data=herb1 (firstobs=1 obs=20); title 'herb1'; run;

/* *56 plots total, only 55 in herb1--missing 1226, finding out why;

proc sort data=herbx; by plot; run;
proc means data=herbx noprint n; by plot; 
  output out=HERBCHECK n=n ;
RUN;
proc print data=HERBCHECK; run;

proc sort data=herb1; by plot; run;
proc means data=herb1 noprint n; by plot; 
  output out=HERBCHECK2 n=n ;
RUN;
proc print data=HERBCHECK2; run;

proc sql;
	select plot, sspp, year
	from herbx
	where plot eq 1226;
quit;

*55 plots in herb1--herbaceous data were never collected at all in plot 1226, plot gets dropped;
*/

*begin norma code;

*getting stem counts;
proc sort data=herb1; by sspp; run;
proc means data=herb1 noprint n sum mean min max; by sspp; var coun;
  output out=sumstems n=n sum=sumcount mean=meancount min=mincount max=maxcount;
data sumstems1; set sumstems; drop _TYPE_ _FREQ_; RUN;
proc sort data=sumstems1; by sumcount n;
proc print data=sumstems1; title 'sumstems';
run;

*renaming plots 1-56;
data rowcount; set herb1; dummy = 1; keep plot dummy;
proc sort data=rowcount; by plot; run;
proc means data=rowcount noprint mean noprint; by plot; var dummy;
  output out=rowcount2 mean = mean;
*proc print data=rowcount2; title 'rowcount2'; 
run;
data rowcount3; set rowcount2; newplotid = _n_; keep plot newplotid;
proc print data=rowcount3; title 'rowcount3';
run;

*end norma code;

data herb2; set herb1;
	if (sspp='ACGR2') then spid=1;  if (sspp='CHTE1') then spid=46;	if (sspp='DILI5') then spid=91;		if (sspp='GAPE2') then spid=136;	if (sspp='LERE2') then spid=181;	if (sspp='PHCI4') then spid=226;	if (sspp='SOCA6') then spid=271;
	if (sspp='AGFA2') then spid=2;	if (sspp='CIHO2') then spid=47;	if (sspp='DIOLS') then spid=92;		if (sspp='GAPI2') then spid=137;	if (sspp='LESPE') then spid=182;	if (sspp='PHHE4') then spid=227;	if (sspp='SOEL3') then spid=272;
	if (sspp='AGHYx') then spid=3;	if (sspp='CITE2') then spid=48;	if (sspp='DIOLx') then spid=93;		if (sspp='GAPU3') then spid=138;	if (sspp='LEST4') then spid=183;	if (sspp='PHHE5') then spid=228;	if (sspp='SONU2') then spid=273;
	if (sspp='AIEL4') then spid=4;	if (sspp='CLMA4') then spid=49;	if (sspp='DIOVx') then spid=94;		if (sspp='GAPUx') then spid=139;	if (sspp='LEST5') then spid=184;	if (sspp='PHMO9') then spid=229;	if (sspp='SOOLx') then spid=274;
	if (sspp='ALCA3') then spid=5;	if (sspp='CNTEx') then spid=50;	if (sspp='DIRAx') then spid=95;		if (sspp='GAREx') then spid=140;	if (sspp='LETEx') then spid=185;	if (sspp='PHTEx') then spid=230;	if (sspp='SOPYx') then spid=275;
	if (sspp='AMAR2') then spid=6;	if (sspp='COBA2') then spid=51;	if (sspp='DISC3') then spid=96;		if (sspp='GAST2') then spid=141;	if (sspp='LEVI7') then spid=186;	if (sspp='PLHOx') then spid=231;	if (sspp='SORAx') then spid=276;
	if (sspp='AMPSx') then spid=7;	if (sspp='COCA5') then spid=52;	if (sspp='DISP2') then spid=97;		if (sspp='GECA5') then spid=142;	if (sspp='LIARx') then spid=187;	if (sspp='PLODx') then spid=232;	if (sspp='SPCLx') then spid=277;
	if (sspp='ANGL2') then spid=8;	if (sspp='COERx') then spid=53;	if (sspp='DITE2') then spid=98;		if (sspp='GIINx') then spid=143;	if (sspp='LIASx') then spid=188;	if (sspp='PLVIx') then spid=233;	if (sspp='SPCO1') then spid=278;
	if (sspp='ANVI2') then spid=9;	if (sspp='COTI3') then spid=54;	if (sspp='DIVI7') then spid=99;		if (sspp='GOGO2') then spid=144;	if (sspp='LIEL1') then spid=189;	if (sspp='PLWRx') then spid=234;	if (sspp='SPINx') then spid=279;
	if (sspp='ARAL3') then spid=10;	if (sspp='COWR3') then spid=55;	if (sspp='DRAN3') then spid=100;	if (sspp='GYAMx') then spid=145;	if (sspp='LIELx') then spid=190;	if (sspp='POERx') then spid=235;	if (sspp='SPOBx') then spid=280;
	if (sspp='ARDE3') then spid=11;	if (sspp='CRCA6') then spid=56;	if (sspp='ELAN5') then spid=101;	if (sspp='HEAMx') then spid=146;	if (sspp='LIME2') then spid=191;	if (sspp='POPEx') then spid=236;	if (sspp='SPVAx') then spid=281;
	if (sspp='ARERx') then spid=12;	if (sspp='CRDI1') then spid=57;	if (sspp='ELIN3') then spid=102;	if (sspp='HEAN3') then spid=147;	if (sspp='LOPUx') then spid=192;	if (sspp='POPOx') then spid=237;	if (sspp='STBI2') then spid=282;
	if (sspp='ARLA6') then spid=13;	if (sspp='CRGL2') then spid=58;	if (sspp='ERCUx') then spid=103;	if (sspp='HECR9') then spid=148;	if (sspp='LOSQx') then spid=193;	if (sspp='POPR4') then spid=238;	if (sspp='STHE4') then spid=283;
	if (sspp='ARLO1') then spid=14;	if (sspp='CRHOH') then spid=59;	if (sspp='ERGEx') then spid=104;	if (sspp='HEDE4') then spid=149;	if (sspp='LURE2') then spid=194;	if (sspp='POTEx') then spid=239;	if (sspp='STLE5') then spid=284;
	if (sspp='ARPU8') then spid=15;	if (sspp='CRMI8') then spid=60;	if (sspp='ERHI2') then spid=105;	if (sspp='HEGEx') then spid=150;	if (sspp='MADE3') then spid=195;	if (sspp='POVEx') then spid=240;	if (sspp='STLE6') then spid=285;
	if (sspp='ARPUP') then spid=16;	if (sspp='CRMO6') then spid=61;	if (sspp='ERHI9') then spid=106;	if (sspp='HEGR1') then spid=151;	if (sspp='MEPE3') then spid=196;	if (sspp='PSOB3') then spid=241;	if (sspp='STPI3') then spid=286;
	if (sspp='ASNU4') then spid=17;	if (sspp='CRRI3') then spid=62;	if (sspp='ERHIx') then spid=107;	if (sspp='HELA5') then spid=152;	if (sspp='MINU6') then spid=197;	if (sspp='PTAQx') then spid=242;	if (sspp='STSYx') then spid=287;
	if (sspp='ASOEx') then spid=18;	if (sspp='CRSA4') then spid=63;	if (sspp='ERINx') then spid=108;	if (sspp='HELA6') then spid=153;	if (sspp='MOCAx') then spid=198;	if (sspp='PTVI2') then spid=243;	if (sspp='STUM2') then spid=288;
	if (sspp='ASTUx') then spid=19;	if (sspp='CRWI5') then spid=64;	if (sspp='ERLO5') then spid=109;	if (sspp='HENI4') then spid=154;	if (sspp='MOCIx') then spid=199;	if (sspp='PYCA2') then spid=244;	if (sspp='SYPA1') then spid=289;
	if (sspp='BABR2') then spid=20;	if (sspp='CYCR6') then spid=65;	if (sspp='ERMU4') then spid=110;	if (sspp='HERO2') then spid=155;	if (sspp='MOPUx') then spid=200;	if (sspp='PYMU2') then spid=245;	if (sspp='TAOFx') then spid=290;
	if (sspp='BOHI2') then spid=21;	if (sspp='CYEC2') then spid=66;	if (sspp='ERSE2') then spid=111;	if (sspp='HIGR3') then spid=156;	if (sspp='MOVEx') then spid=201;	if (sspp='RHGL2') then spid=246;	if (sspp='TEONx') then spid=291;
	if (sspp='BOLA2') then spid=22;	if (sspp='CYFI2') then spid=67;	if (sspp='ERSEx') then spid=112;	if (sspp='HYAR3') then spid=157;	if (sspp='NELU2') then spid=202;	if (sspp='RHHAx') then spid=247;	if (sspp='TRBE3') then spid=292;
	if (sspp='BOLAT') then spid=23;	if (sspp='CYFI4') then spid=68;	if (sspp='ERSPx') then spid=113;	if (sspp='HYDRx') then spid=158;	if (sspp='NOBI2') then spid=203;	if (sspp='RHLAx') then spid=248;	if (sspp='TRBE4') then spid=293;
	if (sspp='BRJAx') then spid=24;	if (sspp='CYHYx') then spid=69;	if (sspp='ERST3') then spid=114;	if (sspp='HYGEx') then spid=159;	if (sspp='NUCAx') then spid=204;	if (sspp='RHMI4') then spid=249;	if (sspp='TRBEx') then spid=294;
	if (sspp='BRMI2') then spid=25;	if (sspp='CYLU2') then spid=70;	if (sspp='EUCO1') then spid=115;	if (sspp='HYGL2') then spid=160;	if (sspp='NUTEx') then spid=205;	if (sspp='RUABx') then spid=250;	if (sspp='TRBI2') then spid=295;
	if (sspp='BRTRx') then spid=26;	if (sspp='CYPER') then spid=71;	if (sspp='EUCO7') then spid=116;	if (sspp='HYHI2') then spid=161;	if (sspp='OELAx') then spid=206;	if (sspp='RUAL4') then spid=251;	if (sspp='TRDI2') then spid=296;
	if (sspp='BUCA2') then spid=27;	if (sspp='CYPL3') then spid=72;	if (sspp='EUDE1') then spid=117;	if (sspp='HYMI2') then spid=162;	if (sspp='OELIx') then spid=207;	if (sspp='RUCO2') then spid=252;	if (sspp='TRFL2') then spid=297;
	if (sspp='BUCIx') then spid=28;	if (sspp='CYRE1') then spid=73;	if (sspp='EUHE1') then spid=118;	if (sspp='HYSEx') then spid=163;	if (sspp='OLBOx') then spid=208;	if (sspp='RUHA2') then spid=253;	if (sspp='TRFLC') then spid=298;
	if (sspp='CAFAx') then spid=29;	if (sspp='CYRE2') then spid=74;	if (sspp='EUPI3') then spid=119;	if (sspp='JATAx') then spid=164;	if (sspp='OXDI2') then spid=209;	if (sspp='RUHI2') then spid=254;	if (sspp='TRFLF') then spid=299;
	if (sspp='CAIN2') then spid=30;	if (sspp='CYRE5') then spid=75;	if (sspp='EUSE2') then spid=120;	if (sspp='JUBRx') then spid=165;	if (sspp='OXSTx') then spid=210;	if (sspp='RUHU6') then spid=255;	if (sspp='TRHIx') then spid=300;
	if (sspp='CALE6') then spid=31;	if (sspp='CYSUx') then spid=76;	if (sspp='EUSEx') then spid=121;	if (sspp='JUCO1') then spid=166;	if (sspp='PAANx') then spid=211;	if (sspp='SACA1') then spid=256;	if (sspp='TRPE4') then spid=301;
	if (sspp='CAMI5') then spid=32;	if (sspp='DADRx') then spid=77;	if (sspp='EVCAx') then spid=122;	if (sspp='JUDIx') then spid=167;	if (sspp='PABR2') then spid=212;	if (sspp='SACA3') then spid=257;	if (sspp='TRPU4') then spid=302;
	if (sspp='CAMI8') then spid=33;	if (sspp='DEAC3') then spid=78;	if (sspp='EVSEx') then spid=123;	if (sspp='JUMA4') then spid=168;	if (sspp='PADRx') then spid=213;	if (sspp='SCCA4') then spid=258;	if (sspp='TRRA5') then spid=303;
	if (sspp='CAMU4') then spid=34;	if (sspp='DECA3') then spid=79;	if (sspp='EVVEx') then spid=124;	if (sspp='JUTEx') then spid=169;	if (sspp='PAHI1') then spid=214;	if (sspp='SCCIx') then spid=259;	if (sspp='TRUR2') then spid=304;
	if (sspp='CEMIx') then spid=35;	if (sspp='DECIx') then spid=80;	if (sspp='FAREx') then spid=125;	if (sspp='JUVA2') then spid=170;	if (sspp='PAHOx') then spid=215;	if (sspp='SCOL2') then spid=260;	if (sspp='TYDOx') then spid=305;
	if (sspp='CENCH') then spid=36;	if (sspp='DELA2') then spid=81;	if (sspp='FIAU2') then spid=126;	if (sspp='KRDAx') then spid=171;	if (sspp='PALU2') then spid=216;	if (sspp='SCSCx') then spid=261;	if (sspp='UNGR3') then spid=306;
	if (sspp='CESP4') then spid=37;	if (sspp='DESEx') then spid=82;	if (sspp='FIPUx') then spid=127;	if (sspp='KROCx') then spid=172;	if (sspp='PANO2') then spid=217;	if (sspp='SEARx') then spid=262;	if (sspp='URCIx') then spid=307;
	if (sspp='CEVI2') then spid=38;	if (sspp='DIAC2') then spid=83;	if (sspp='FRFLx') then spid=128;	if (sspp='KRVIx') then spid=173;	if (sspp='PAPE5') then spid=218;	if (sspp='SIABx') then spid=263;	if (sspp='VEARx') then spid=308;
	if (sspp='CHAMx') then spid=39;	if (sspp='DIACx') then spid=84;	if (sspp='FRGR3') then spid=129;	if (sspp='LAHIx') then spid=174;	if (sspp='PAPL3') then spid=219;	if (sspp='SIAN2') then spid=264;	if (sspp='VETE3') then spid=309;
	if (sspp='CHAN5') then spid=40;	if (sspp='DIAN4') then spid=85;	if (sspp='GAAEx') then spid=130;	if (sspp='LALUx') then spid=175;	if (sspp='PAROx') then spid=220;	if (sspp='SICIx') then spid=265;	if (sspp='VILE2') then spid=310;
	if (sspp='CHCO1') then spid=41;	if (sspp='DICA3') then spid=86;	if (sspp='GAAMx') then spid=131;	if (sspp='LASEx') then spid=176;	if (sspp='PASE5') then spid=221;	if (sspp='SILIx') then spid=266;	if (sspp='VIMIx') then spid=311;
	if (sspp='CHIMx') then spid=42;	if (sspp='DICO1') then spid=87;	if (sspp='GAAN1') then spid=132;	if (sspp='LEAR3') then spid=177;	if (sspp='PASEC') then spid=222;	if (sspp='SIRHx') then spid=267;	if (sspp='VISOx') then spid=312;
	if (sspp='CHMA1') then spid=43;	if (sspp='DICO6') then spid=88;	if (sspp='GAAR1') then spid=133;	if (sspp='LEDUx') then spid=178;	if (sspp='PHABx') then spid=223;	if (sspp='SOAL6') then spid=268;	if (sspp='VUOCx') then spid=313;
	if (sspp='CHPI8') then spid=44;	if (sspp='DILA9') then spid=89;	if (sspp='GABR2') then spid=134;	if (sspp='LEHI2') then spid=179;	if (sspp='PHAM4') then spid=224;	if (sspp='SOAM4') then spid=269;	if (sspp='WAMAx') then spid=314;
	if (sspp='CHSE2') then spid=45;	if (sspp='DILI2') then spid=90;	if (sspp='GACA6') then spid=135;	if (sspp='LEMU3') then spid=180;	if (sspp='PHAN5') then spid=225;	if (sspp='SOASx') then spid=270;	if (sspp='XXXXx') then spid=315;
	drop sspp; 
run;
*proc print data=herb2 (firstobs=1 obs=20); title 'herb2'; run;

/*
*proc contents data=dat1n; run;
*proc print    data=dat1n (firstobs=1 obs=20); title 'dat1n'; run;
*proc contents data=dat1c; run;
*proc print    data=dat1c (firstobs=1 obs=20); title 'dat1c'; run;
*/

proc iml;

*sas datasets to import:
	sumstems1: counts of stems per species
	rowcount3: reassigns plots to numbers 1-55
	herb2: 	   species codes (sspp) reassigned to numbers (spid) ;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs); 

*reading in numeric data;
use herb2; read all into matnum;				* print (matnum[1:20,]); *14 columns, 12544 rows;
nrecords = nrow(matnum);						* print nrecords; *12544;

*creating a new matrix;
matnumdat=j(nrecords,16,9999); 					
do i = 1 to nrecords;    						* record by record loop;
  do j = 1 to nyrs;      						* yr by yr loop;
    if (matnum[i,4] = inputyrs[j]) then matnumdat[i,1] = j;
  end;                   						* end yr by yr loop;
end;                     						* end record by record loop;
* print (matnumdat[1:20,]);

*order of variables in matnum: 
plot, quad, coun, year, covm, soileb, elev, slope, hydrn, aspect, bcat, prpo spid;

* fill matnumdat; 
do i = 1 to nrecords;    						* record by record loop;
  uniquad=10*(matnum[i,1]-1)+ matnum[i,2];		* unique quadrat id;
  time1 = matnumdat[i,1];
  time2 = time1 + 1;
  matnumdat[i,2]  = time2;	
  matnumdat[i,3]  = matnum[i,4];  * year1;
  *matnumdat[i,4] will be year2;
  matnumdat[i,5]  = matnum[i,12]; * prpo;
  matnumdat[i,6]  = matnum[i,1];  * plot;
  matnumdat[i,7]  = uniquad;  	  * quad;
  matnumdat[i,8]  = matnum[i,11]; * bcat;
  matnumdat[i,9]  = matnum[i,10]; * aspect;
  matnumdat[i,10] = matnum[i,9];  * hydrn;
  matnumdat[i,11] = matnum[i,6];  * soileb;
  matnumdat[i,12] = matnum[i,7];  * elev;
  matnumdat[i,13] = matnum[i,8];  * slope;
  matnumdat[i,14] = matnum[i,5];  * covm1;
  *matnumdat[i,15] will be covm2;     
  matnumdat[i,16] = matnum[i,3];  * coun;
end;
* print (matnumdat[1:20,]);


*create uniquad;
/*
export rowcount3 to iml;   iml code:
  plotid=0; 
  * have a data matrix datxxx, and you have a new matrix that you are filling, using plotid to calculate rowid;
  do i = 1 to 56; if datxxxx[<of the row >] = plotnum3[i,1] then plotid = plotnum3[i,2]; end; 
if plotid = 0 then do; print 'plotid missing!'; end;
*/
