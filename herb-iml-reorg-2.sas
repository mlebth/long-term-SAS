/* *if running from alld;
data herbx; set alld;
	if (subp = 'herb'); 
run;  *N=12544;
*/

data herb1; set herbx;
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo; 
run;

proc sort data=herb1; by plot quad year sspp bcat covm coun soileb elev slope aspect hydrn prpo; run; *N=12548;
*proc print data=herb1 (firstobs=1 obs=20); title 'herb1'; run;

*numeric dataset;   data dat1n; set herb1; keep aspect bcat plot quad coun covm elev hydrn slope soileb year prpo; 
*character dataset; data dat1c; set herb1; keep sspp;	run;		

*proc contents data=dat1n; run;
*proc print    data=dat1n (firstobs=1 obs=20); title 'dat1n'; run;
*proc contents data=dat1c; run;
*proc print    data=dat1c (firstobs=1 obs=20); title 'dat1c'; run;

proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

*reading in numeric data;
use dat1n; read all into matnum;				*print (matnum[1:20,]);	 *12 columns, 12548 rows;
nrecords = nrow(matnum);						*print nrecords; *12548;

*reading in character data;
use dat1c; read all var _char_ into matchar;	*print matchar;	 *1 column, 12548 rows;

nsp=315;	  	*number of species;
*order of variables in matnum: plot, quad, coun, year, covm, soileb, elev, slope, hydrn, aspect, bcat, prpo;
ncols=nsp+12;	*nsp plus number of columns in matnum;

matcount=j(nrecords,ncols,9999); 				*print matcount; *327 columns, 12548 rows;
do i = 1 to nrecords;    * record by record loop;
  do j = 1 to nyrs;      * yr by yr loop;
    if (matnum[i,1] = inputyrs[j]) then matcount[i,1] = j;
  end;                   * end yr by yr loop;
end;                     * end record by record loop;
* print (matcount[1:20,]);
nobs=nrow(matcount);							*print nobs; *12548;

*order of variables in matnum: 
plot, quad, coun, year, covm, soileb, elev, slope, hydrn, aspect, bcat, prpo;
* fill matcount; 
do i = 1 to nrecords;    * record by record loop;
  uniquad=10*(matnum[i,1]-1)+ matnum[i,2];	*unique quadrat id;
  time1 = matcount[i,4];
  time2 = time1 + 1;
  matcount[i,2]  = time2;	
  matcount[i,3]  = matnum[i,4];  * year1;
  *matcount[i,4] will be year2;
  matcount[i,5]  = matnum[i,12]; * prpo;
  matcount[i,6]  = matnum[i,1];  * plot;
  matcount[i,7]  = uniquad;  	 * quad;
  matcount[i,8]  = matnum[i,11]; * bcat;
  matcount[i,9]  = matnum[i,10]; * aspect;
  matcount[i,10] = matnum[i,9];  * hydrn;
  matcount[i,11] = matnum[i,6];  * soileb;
  matcount[i,12] = matnum[i,7];  * elev;
  matcount[i,13] = matnum[i,8];  * slope;
  matcount[i,14] = matnum[i,5];  * covm1;
end;
* print (matcount[1:20,]);

do i = 1 to nrecords;
  plot = matcount[i,6]; time2 = matcount[i,2];
  do j = 1 to nrecords;
    if (matcount[j,6] = plot & matcount[j,1] = time2) then do;
	  *print i,j;
  	  matcount[i,4]  = matcount[j,3];  * year2;
	  matcount[i,15] = matcount[j,14]; * covm2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print (matcount[110:120,]);

do i=1 to nobs;
	*assigning a numeric id to each species;
if (dat1c[i,1]='ACGR2') then spid=1;    if (dat1c[i,1]='CHTE1') then spid=46;	if (dat1c[i,1]='DILI5') then spid=91;	if (dat1c[i,1]='GAPE2') then spid=136;	if (dat1c[i,1]='LERE2') then spid=181;	if (dat1c[i,1]='PHCI4') then spid=226;	if (dat1c[i,1]='SOCA6') then spid=271;
if (dat1c[i,1]='AGFA2') then spid=2;	if (dat1c[i,1]='CIHO2') then spid=47;	if (dat1c[i,1]='DIOLS') then spid=92;	if (dat1c[i,1]='GAPI2') then spid=137;	if (dat1c[i,1]='LESPE') then spid=182;	if (dat1c[i,1]='PHHE4') then spid=227;	if (dat1c[i,1]='SOEL3') then spid=272;
if (dat1c[i,1]='AGHYx') then spid=3;	if (dat1c[i,1]='CITE2') then spid=48;	if (dat1c[i,1]='DIOLx') then spid=93;	if (dat1c[i,1]='GAPU3') then spid=138;	if (dat1c[i,1]='LEST4') then spid=183;	if (dat1c[i,1]='PHHE5') then spid=228;	if (dat1c[i,1]='SONU2') then spid=273;
if (dat1c[i,1]='AIEL4') then spid=4;	if (dat1c[i,1]='CLMA4') then spid=49;	if (dat1c[i,1]='DIOVx') then spid=94;	if (dat1c[i,1]='GAPUx') then spid=139;	if (dat1c[i,1]='LEST5') then spid=184;	if (dat1c[i,1]='PHMO9') then spid=229;	if (dat1c[i,1]='SOOLx') then spid=274;
if (dat1c[i,1]='ALCA3') then spid=5;	if (dat1c[i,1]='CNTEx') then spid=50;	if (dat1c[i,1]='DIRAx') then spid=95;	if (dat1c[i,1]='GAREx') then spid=140;	if (dat1c[i,1]='LETEx') then spid=185;	if (dat1c[i,1]='PHTEx') then spid=230;	if (dat1c[i,1]='SOPYx') then spid=275;
if (dat1c[i,1]='AMAR2') then spid=6;	if (dat1c[i,1]='COBA2') then spid=51;	if (dat1c[i,1]='DISC3') then spid=96;	if (dat1c[i,1]='GAST2') then spid=141;	if (dat1c[i,1]='LEVI7') then spid=186;	if (dat1c[i,1]='PLHOx') then spid=231;	if (dat1c[i,1]='SORAx') then spid=276;
if (dat1c[i,1]='AMPSx') then spid=7;	if (dat1c[i,1]='COCA5') then spid=52;	if (dat1c[i,1]='DISP2') then spid=97;	if (dat1c[i,1]='GECA5') then spid=142;	if (dat1c[i,1]='LIARx') then spid=187;	if (dat1c[i,1]='PLODx') then spid=232;	if (dat1c[i,1]='SPCLx') then spid=277;
if (dat1c[i,1]='ANGL2') then spid=8;	if (dat1c[i,1]='COERx') then spid=53;	if (dat1c[i,1]='DITE2') then spid=98;	if (dat1c[i,1]='GIINx') then spid=143;	if (dat1c[i,1]='LIASx') then spid=188;	if (dat1c[i,1]='PLVIx') then spid=233;	if (dat1c[i,1]='SPCO1') then spid=278;
if (dat1c[i,1]='ANVI2') then spid=9;	if (dat1c[i,1]='COTI3') then spid=54;	if (dat1c[i,1]='DIVI7') then spid=99;	if (dat1c[i,1]='GOGO2') then spid=144;	if (dat1c[i,1]='LIEL1') then spid=189;	if (dat1c[i,1]='PLWRx') then spid=234;	if (dat1c[i,1]='SPINx') then spid=279;
if (dat1c[i,1]='ARAL3') then spid=10;	if (dat1c[i,1]='COWR3') then spid=55;	if (dat1c[i,1]='DRAN3') then spid=100;	if (dat1c[i,1]='GYAMx') then spid=145;	if (dat1c[i,1]='LIELx') then spid=190;	if (dat1c[i,1]='POERx') then spid=235;	if (dat1c[i,1]='SPOBx') then spid=280;
if (dat1c[i,1]='ARDE3') then spid=11;	if (dat1c[i,1]='CRCA6') then spid=56;	if (dat1c[i,1]='ELAN5') then spid=101;	if (dat1c[i,1]='HEAMx') then spid=146;	if (dat1c[i,1]='LIME2') then spid=191;	if (dat1c[i,1]='POPEx') then spid=236;	if (dat1c[i,1]='SPVAx') then spid=281;
if (dat1c[i,1]='ARERx') then spid=12;	if (dat1c[i,1]='CRDI1') then spid=57;	if (dat1c[i,1]='ELIN3') then spid=102;	if (dat1c[i,1]='HEAN3') then spid=147;	if (dat1c[i,1]='LOPUx') then spid=192;	if (dat1c[i,1]='POPOx') then spid=237;	if (dat1c[i,1]='STBI2') then spid=282;
if (dat1c[i,1]='ARLA6') then spid=13;	if (dat1c[i,1]='CRGL2') then spid=58;	if (dat1c[i,1]='ERCUx') then spid=103;	if (dat1c[i,1]='HECR9') then spid=148;	if (dat1c[i,1]='LOSQx') then spid=193;	if (dat1c[i,1]='POPR4') then spid=238;	if (dat1c[i,1]='STHE4') then spid=283;
if (dat1c[i,1]='ARLO1') then spid=14;	if (dat1c[i,1]='CRHOH') then spid=59;	if (dat1c[i,1]='ERGEx') then spid=104;	if (dat1c[i,1]='HEDE4') then spid=149;	if (dat1c[i,1]='LURE2') then spid=194;	if (dat1c[i,1]='POTEx') then spid=239;	if (dat1c[i,1]='STLE5') then spid=284;
if (dat1c[i,1]='ARPU8') then spid=15;	if (dat1c[i,1]='CRMI8') then spid=60;	if (dat1c[i,1]='ERHI2') then spid=105;	if (dat1c[i,1]='HEGEx') then spid=150;	if (dat1c[i,1]='MADE3') then spid=195;	if (dat1c[i,1]='POVEx') then spid=240;	if (dat1c[i,1]='STLE6') then spid=285;
if (dat1c[i,1]='ARPUP') then spid=16;	if (dat1c[i,1]='CRMO6') then spid=61;	if (dat1c[i,1]='ERHI9') then spid=106;	if (dat1c[i,1]='HEGR1') then spid=151;	if (dat1c[i,1]='MEPE3') then spid=196;	if (dat1c[i,1]='PSOB3') then spid=241;	if (dat1c[i,1]='STPI3') then spid=286;
if (dat1c[i,1]='ASNU4') then spid=17;	if (dat1c[i,1]='CRRI3') then spid=62;	if (dat1c[i,1]='ERHIx') then spid=107;	if (dat1c[i,1]='HELA5') then spid=152;	if (dat1c[i,1]='MINU6') then spid=197;	if (dat1c[i,1]='PTAQx') then spid=242;	if (dat1c[i,1]='STSYx') then spid=287;
if (dat1c[i,1]='ASOEx') then spid=18;	if (dat1c[i,1]='CRSA4') then spid=63;	if (dat1c[i,1]='ERINx') then spid=108;	if (dat1c[i,1]='HELA6') then spid=153;	if (dat1c[i,1]='MOCAx') then spid=198;	if (dat1c[i,1]='PTVI2') then spid=243;	if (dat1c[i,1]='STUM2') then spid=288;
if (dat1c[i,1]='ASTUx') then spid=19;	if (dat1c[i,1]='CRWI5') then spid=64;	if (dat1c[i,1]='ERLO5') then spid=109;	if (dat1c[i,1]='HENI4') then spid=154;	if (dat1c[i,1]='MOCIx') then spid=199;	if (dat1c[i,1]='PYCA2') then spid=244;	if (dat1c[i,1]='SYPA1') then spid=289;
if (dat1c[i,1]='BABR2') then spid=20;	if (dat1c[i,1]='CYCR6') then spid=65;	if (dat1c[i,1]='ERMU4') then spid=110;	if (dat1c[i,1]='HERO2') then spid=155;	if (dat1c[i,1]='MOPUx') then spid=200;	if (dat1c[i,1]='PYMU2') then spid=245;	if (dat1c[i,1]='TAOFx') then spid=290;
if (dat1c[i,1]='BOHI2') then spid=21;	if (dat1c[i,1]='CYEC2') then spid=66;	if (dat1c[i,1]='ERSE2') then spid=111;	if (dat1c[i,1]='HIGR3') then spid=156;	if (dat1c[i,1]='MOVEx') then spid=201;	if (dat1c[i,1]='RHGL2') then spid=246;	if (dat1c[i,1]='TEONx') then spid=291;
if (dat1c[i,1]='BOLA2') then spid=22;	if (dat1c[i,1]='CYFI2') then spid=67;	if (dat1c[i,1]='ERSEx') then spid=112;	if (dat1c[i,1]='HYAR3') then spid=157;	if (dat1c[i,1]='NELU2') then spid=202;	if (dat1c[i,1]='RHHAx') then spid=247;	if (dat1c[i,1]='TRBE3') then spid=292;
if (dat1c[i,1]='BOLAT') then spid=23;	if (dat1c[i,1]='CYFI4') then spid=68;	if (dat1c[i,1]='ERSPx') then spid=113;	if (dat1c[i,1]='HYDRx') then spid=158;	if (dat1c[i,1]='NOBI2') then spid=203;	if (dat1c[i,1]='RHLAx') then spid=248;	if (dat1c[i,1]='TRBE4') then spid=293;
if (dat1c[i,1]='BRJAx') then spid=24;	if (dat1c[i,1]='CYHYx') then spid=69;	if (dat1c[i,1]='ERST3') then spid=114;	if (dat1c[i,1]='HYGEx') then spid=159;	if (dat1c[i,1]='NUCAx') then spid=204;	if (dat1c[i,1]='RHMI4') then spid=249;	if (dat1c[i,1]='TRBEx') then spid=294;
if (dat1c[i,1]='BRMI2') then spid=25;	if (dat1c[i,1]='CYLU2') then spid=70;	if (dat1c[i,1]='EUCO1') then spid=115;	if (dat1c[i,1]='HYGL2') then spid=160;	if (dat1c[i,1]='NUTEx') then spid=205;	if (dat1c[i,1]='RUABx') then spid=250;	if (dat1c[i,1]='TRBI2') then spid=295;
if (dat1c[i,1]='BRTRx') then spid=26;	if (dat1c[i,1]='CYPER') then spid=71;	if (dat1c[i,1]='EUCO7') then spid=116;	if (dat1c[i,1]='HYHI2') then spid=161;	if (dat1c[i,1]='OELAx') then spid=206;	if (dat1c[i,1]='RUAL4') then spid=251;	if (dat1c[i,1]='TRDI2') then spid=296;
if (dat1c[i,1]='BUCA2') then spid=27;	if (dat1c[i,1]='CYPL3') then spid=72;	if (dat1c[i,1]='EUDE1') then spid=117;	if (dat1c[i,1]='HYMI2') then spid=162;	if (dat1c[i,1]='OELIx') then spid=207;	if (dat1c[i,1]='RUCO2') then spid=252;	if (dat1c[i,1]='TRFL2') then spid=297;
if (dat1c[i,1]='BUCIx') then spid=28;	if (dat1c[i,1]='CYRE1') then spid=73;	if (dat1c[i,1]='EUHE1') then spid=118;	if (dat1c[i,1]='HYSEx') then spid=163;	if (dat1c[i,1]='OLBOx') then spid=208;	if (dat1c[i,1]='RUHA2') then spid=253;	if (dat1c[i,1]='TRFLC') then spid=298;
if (dat1c[i,1]='CAFAx') then spid=29;	if (dat1c[i,1]='CYRE2') then spid=74;	if (dat1c[i,1]='EUPI3') then spid=119;	if (dat1c[i,1]='JATAx') then spid=164;	if (dat1c[i,1]='OXDI2') then spid=209;	if (dat1c[i,1]='RUHI2') then spid=254;	if (dat1c[i,1]='TRFLF') then spid=299;
if (dat1c[i,1]='CAIN2') then spid=30;	if (dat1c[i,1]='CYRE5') then spid=75;	if (dat1c[i,1]='EUSE2') then spid=120;	if (dat1c[i,1]='JUBRx') then spid=165;	if (dat1c[i,1]='OXSTx') then spid=210;	if (dat1c[i,1]='RUHU6') then spid=255;	if (dat1c[i,1]='TRHIx') then spid=300;
if (dat1c[i,1]='CALE6') then spid=31;	if (dat1c[i,1]='CYSUx') then spid=76;	if (dat1c[i,1]='EUSEx') then spid=121;	if (dat1c[i,1]='JUCO1') then spid=166;	if (dat1c[i,1]='PAANx') then spid=211;	if (dat1c[i,1]='SACA1') then spid=256;	if (dat1c[i,1]='TRPE4') then spid=301;
if (dat1c[i,1]='CAMI5') then spid=32;	if (dat1c[i,1]='DADRx') then spid=77;	if (dat1c[i,1]='EVCAx') then spid=122;	if (dat1c[i,1]='JUDIx') then spid=167;	if (dat1c[i,1]='PABR2') then spid=212;	if (dat1c[i,1]='SACA3') then spid=257;	if (dat1c[i,1]='TRPU4') then spid=302;
if (dat1c[i,1]='CAMI8') then spid=33;	if (dat1c[i,1]='DEAC3') then spid=78;	if (dat1c[i,1]='EVSEx') then spid=123;	if (dat1c[i,1]='JUMA4') then spid=168;	if (dat1c[i,1]='PADRx') then spid=213;	if (dat1c[i,1]='SCCA4') then spid=258;	if (dat1c[i,1]='TRRA5') then spid=303;
if (dat1c[i,1]='CAMU4') then spid=34;	if (dat1c[i,1]='DECA3') then spid=79;	if (dat1c[i,1]='EVVEx') then spid=124;	if (dat1c[i,1]='JUTEx') then spid=169;	if (dat1c[i,1]='PAHI1') then spid=214;	if (dat1c[i,1]='SCCIx') then spid=259;	if (dat1c[i,1]='TRUR2') then spid=304;
if (dat1c[i,1]='CEMIx') then spid=35;	if (dat1c[i,1]='DECIx') then spid=80;	if (dat1c[i,1]='FAREx') then spid=125;	if (dat1c[i,1]='JUVA2') then spid=170;	if (dat1c[i,1]='PAHOx') then spid=215;	if (dat1c[i,1]='SCOL2') then spid=260;	if (dat1c[i,1]='TYDOx') then spid=305;
if (dat1c[i,1]='CENCH') then spid=36;	if (dat1c[i,1]='DELA2') then spid=81;	if (dat1c[i,1]='FIAU2') then spid=126;	if (dat1c[i,1]='KRDAx') then spid=171;	if (dat1c[i,1]='PALU2') then spid=216;	if (dat1c[i,1]='SCSCx') then spid=261;	if (dat1c[i,1]='UNGR3') then spid=306;
if (dat1c[i,1]='CESP4') then spid=37;	if (dat1c[i,1]='DESEx') then spid=82;	if (dat1c[i,1]='FIPUx') then spid=127;	if (dat1c[i,1]='KROCx') then spid=172;	if (dat1c[i,1]='PANO2') then spid=217;	if (dat1c[i,1]='SEARx') then spid=262;	if (dat1c[i,1]='URCIx') then spid=307;
if (dat1c[i,1]='CEVI2') then spid=38;	if (dat1c[i,1]='DIAC2') then spid=83;	if (dat1c[i,1]='FRFLx') then spid=128;	if (dat1c[i,1]='KRVIx') then spid=173;	if (dat1c[i,1]='PAPE5') then spid=218;	if (dat1c[i,1]='SIABx') then spid=263;	if (dat1c[i,1]='VEARx') then spid=308;
if (dat1c[i,1]='CHAMx') then spid=39;	if (dat1c[i,1]='DIACx') then spid=84;	if (dat1c[i,1]='FRGR3') then spid=129;	if (dat1c[i,1]='LAHIx') then spid=174;	if (dat1c[i,1]='PAPL3') then spid=219;	if (dat1c[i,1]='SIAN2') then spid=264;	if (dat1c[i,1]='VETE3') then spid=309;
if (dat1c[i,1]='CHAN5') then spid=40;	if (dat1c[i,1]='DIAN4') then spid=85;	if (dat1c[i,1]='GAAEx') then spid=130;	if (dat1c[i,1]='LALUx') then spid=175;	if (dat1c[i,1]='PAROx') then spid=220;	if (dat1c[i,1]='SICIx') then spid=265;	if (dat1c[i,1]='VILE2') then spid=310;
if (dat1c[i,1]='CHCO1') then spid=41;	if (dat1c[i,1]='DICA3') then spid=86;	if (dat1c[i,1]='GAAMx') then spid=131;	if (dat1c[i,1]='LASEx') then spid=176;	if (dat1c[i,1]='PASE5') then spid=221;	if (dat1c[i,1]='SILIx') then spid=266;	if (dat1c[i,1]='VIMIx') then spid=311;
if (dat1c[i,1]='CHIMx') then spid=42;	if (dat1c[i,1]='DICO1') then spid=87;	if (dat1c[i,1]='GAAN1') then spid=132;	if (dat1c[i,1]='LEAR3') then spid=177;	if (dat1c[i,1]='PASEC') then spid=222;	if (dat1c[i,1]='SIRHx') then spid=267;	if (dat1c[i,1]='VISOx') then spid=312;
if (dat1c[i,1]='CHMA1') then spid=43;	if (dat1c[i,1]='DICO6') then spid=88;	if (dat1c[i,1]='GAAR1') then spid=133;	if (dat1c[i,1]='LEDUx') then spid=178;	if (dat1c[i,1]='PHABx') then spid=223;	if (dat1c[i,1]='SOAL6') then spid=268;	if (dat1c[i,1]='VUOCx') then spid=313;
if (dat1c[i,1]='CHPI8') then spid=44;	if (dat1c[i,1]='DILA9') then spid=89;	if (dat1c[i,1]='GABR2') then spid=134;	if (dat1c[i,1]='LEHI2') then spid=179;	if (dat1c[i,1]='PHAM4') then spid=224;	if (dat1c[i,1]='SOAM4') then spid=269;	if (dat1c[i,1]='WAMAx') then spid=314;
if (dat1c[i,1]='CHSE2') then spid=45;	if (dat1c[i,1]='DILI2') then spid=90;	if (dat1c[i,1]='GACA6') then spid=135;	if (dat1c[i,1]='LEMU3') then spid=180;	if (dat1c[i,1]='PHAN5') then spid=225;	if (dat1c[i,1]='SOASx') then spid=270;	if (dat1c[i,1]='XXXXx') then spid=315;
	matcount[i,spid]=matnum[i,3];
end;
print (matcount[1:20,]);

datids=matnum;
do i=1 to nquads;						
	datids[i,3]=10*(datids[i,1]-1)*datids[i,2];
end;
*print datids;

mat3=datids//matnum; *sticks the 2 together;
matpa=mat3;

do i=1 to nquads;
	do j=1 to nsp;
		colno=j+3;
		matpa[i,colno]=99;
			if (mat3[i,colno]=0) then matpa[i,colno]=0;
			if (mat3[i,colno]>0) then matpa[i,colno]=1;
	end;
end;
quit;
