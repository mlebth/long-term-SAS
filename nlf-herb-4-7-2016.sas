proc sort data=herb1; by sspp;
data datnlf; set herb1;
  if (sspp  NE '     ');   * drops observations;
  type = 1;     * default - it is a plant;
  if (sspp = 'XXXXx' | sspp = 'LITTx') then type = 2;   * type 2 means non-plant;

proc means data=herb1 noprint n sum mean min max; by sspp; var coun;
  output out=sumstems n=n sum=sumcount mean=meancount min=mincount max=maxcount;
proc sort data=sumstems; by sumcount;
proc print data=sumstems; title 'sumstems';
run;

proc sort dat=sumstems; by n;
proc print data=sumstems; title 'sumstems';
run;

data plotnums1; set herb1; dummy = 1; keep plot dummy;
proc sort data=plotnums1; by plot;
proc means data=plotnums1 noprint mean noprint; by plot; var dummy;
  output out=plotnums2 mean = mean;
proc print data=plotnums2; title 'plotnums2'; 
run;
data plotnums3; set plotnums2; newplotid = _n_; keep plot newplotid;
proc print data=plotnums3; title 'plotnums3';
run;
/*
export plotnums3 to iml;   iml code:
  plotid=0; 
  * have a data matrix datxxx, and you have a new matrix that you are filling, using plotid to calculate rowid;
  do i = 1 to 56; if datxxxx[<of the row >] = plotnum3[i,1] then plotid = plotnum3[i,2]; end; 
if plotid = 0 then do; print 'plotid missing!'; end;
 
proc iml;
* order of variables in matnum: 
plot, quad, coun, year, covm, soileb, elev, slope, hydrn, aspect, bcat, prpo;

*reading in numeric data;
use dat1n; read all into matnum;	*12 columns, 12548 rows;
nrecords = nrow(matnum);

* only variable is species name;
*reading in character data;
use dat1c; read all var _char_ into matchar;	* print matchar;  *1 column, 12548 rows;
nrecords = nrow(matchar);	* print nrecords; *12548;

spid=.; 										* setting species id (spidn) to .;
datids2=j(nrecords,1,spid); 					* creating matrix to fill with numeric species ids--version2;
*print (datids2[1:20,]);
datids1=j(uniquad,nsp,.);						* creating matrix to fill with  counts--version1;
*print (datids1[1:20,]);

do i=1 to nrecords; 
*assigning a numeric id to each species in matchar;
 *version2;
	if (matchar[i,1]='ACGR2') then datids2[i,1]=1;  if (matchar[i,1]='CHTE1') then datids2[i,1]=46;	if (matchar[i,1]='DILI5') then datids2[i,1]=91;		if (matchar[i,1]='GAPE2') then datids2[i,1]=136;	if (matchar[i,1]='LERE2') then datids2[i,1]=181;	if (matchar[i,1]='PHCI4') then datids2[i,1]=226;	if (matchar[i,1]='SOCA6') then datids2[i,1]=271;
	if (matchar[i,1]='AGFA2') then datids2[i,1]=2;	if (matchar[i,1]='CIHO2') then datids2[i,1]=47;	if (matchar[i,1]='DIOLS') then datids2[i,1]=92;		if (matchar[i,1]='GAPI2') then datids2[i,1]=137;	if (matchar[i,1]='LESPE') then datids2[i,1]=182;	if (matchar[i,1]='PHHE4') then datids2[i,1]=227;	if (matchar[i,1]='SOEL3') then datids2[i,1]=272;
	if (matchar[i,1]='AGHYx') then datids2[i,1]=3;	if (matchar[i,1]='CITE2') then datids2[i,1]=48;	if (matchar[i,1]='DIOLx') then datids2[i,1]=93;		if (matchar[i,1]='GAPU3') then datids2[i,1]=138;	if (matchar[i,1]='LEST4') then datids2[i,1]=183;	if (matchar[i,1]='PHHE5') then datids2[i,1]=228;	if (matchar[i,1]='SONU2') then datids2[i,1]=273;
	if (matchar[i,1]='AIEL4') then datids2[i,1]=4;	if (matchar[i,1]='CLMA4') then datids2[i,1]=49;	if (matchar[i,1]='DIOVx') then datids2[i,1]=94;		if (matchar[i,1]='GAPUx') then datids2[i,1]=139;	if (matchar[i,1]='LEST5') then datids2[i,1]=184;	if (matchar[i,1]='PHMO9') then datids2[i,1]=229;	if (matchar[i,1]='SOOLx') then datids2[i,1]=274;
	if (matchar[i,1]='ALCA3') then datids2[i,1]=5;	if (matchar[i,1]='CNTEx') then datids2[i,1]=50;	if (matchar[i,1]='DIRAx') then datids2[i,1]=95;		if (matchar[i,1]='GAREx') then datids2[i,1]=140;	if (matchar[i,1]='LETEx') then datids2[i,1]=185;	if (matchar[i,1]='PHTEx') then datids2[i,1]=230;	if (matchar[i,1]='SOPYx') then datids2[i,1]=275;
	if (matchar[i,1]='AMAR2') then datids2[i,1]=6;	if (matchar[i,1]='COBA2') then datids2[i,1]=51;	if (matchar[i,1]='DISC3') then datids2[i,1]=96;		if (matchar[i,1]='GAST2') then datids2[i,1]=141;	if (matchar[i,1]='LEVI7') then datids2[i,1]=186;	if (matchar[i,1]='PLHOx') then datids2[i,1]=231;	if (matchar[i,1]='SORAx') then datids2[i,1]=276;
	if (matchar[i,1]='AMPSx') then datids2[i,1]=7;	if (matchar[i,1]='COCA5') then datids2[i,1]=52;	if (matchar[i,1]='DISP2') then datids2[i,1]=97;		if (matchar[i,1]='GECA5') then datids2[i,1]=142;	if (matchar[i,1]='LIARx') then datids2[i,1]=187;	if (matchar[i,1]='PLODx') then datids2[i,1]=232;	if (matchar[i,1]='SPCLx') then datids2[i,1]=277;
	if (matchar[i,1]='ANGL2') then datids2[i,1]=8;	if (matchar[i,1]='COERx') then datids2[i,1]=53;	if (matchar[i,1]='DITE2') then datids2[i,1]=98;		if (matchar[i,1]='GIINx') then datids2[i,1]=143;	if (matchar[i,1]='LIASx') then datids2[i,1]=188;	if (matchar[i,1]='PLVIx') then datids2[i,1]=233;	if (matchar[i,1]='SPCO1') then datids2[i,1]=278;
	if (matchar[i,1]='ANVI2') then datids2[i,1]=9;	if (matchar[i,1]='COTI3') then datids2[i,1]=54;	if (matchar[i,1]='DIVI7') then datids2[i,1]=99;		if (matchar[i,1]='GOGO2') then datids2[i,1]=144;	if (matchar[i,1]='LIEL1') then datids2[i,1]=189;	if (matchar[i,1]='PLWRx') then datids2[i,1]=234;	if (matchar[i,1]='SPINx') then datids2[i,1]=279;
	if (matchar[i,1]='ARAL3') then datids2[i,1]=10;	if (matchar[i,1]='COWR3') then datids2[i,1]=55;	if (matchar[i,1]='DRAN3') then datids2[i,1]=100;	if (matchar[i,1]='GYAMx') then datids2[i,1]=145;	if (matchar[i,1]='LIELx') then datids2[i,1]=190;	if (matchar[i,1]='POERx') then datids2[i,1]=235;	if (matchar[i,1]='SPOBx') then datids2[i,1]=280;
	if (matchar[i,1]='ARDE3') then datids2[i,1]=11;	if (matchar[i,1]='CRCA6') then datids2[i,1]=56;	if (matchar[i,1]='ELAN5') then datids2[i,1]=101;	if (matchar[i,1]='HEAMx') then datids2[i,1]=146;	if (matchar[i,1]='LIME2') then datids2[i,1]=191;	if (matchar[i,1]='POPEx') then datids2[i,1]=236;	if (matchar[i,1]='SPVAx') then datids2[i,1]=281;
	if (matchar[i,1]='ARERx') then datids2[i,1]=12;	if (matchar[i,1]='CRDI1') then datids2[i,1]=57;	if (matchar[i,1]='ELIN3') then datids2[i,1]=102;	if (matchar[i,1]='HEAN3') then datids2[i,1]=147;	if (matchar[i,1]='LOPUx') then datids2[i,1]=192;	if (matchar[i,1]='POPOx') then datids2[i,1]=237;	if (matchar[i,1]='STBI2') then datids2[i,1]=282;
	if (matchar[i,1]='ARLA6') then datids2[i,1]=13;	if (matchar[i,1]='CRGL2') then datids2[i,1]=58;	if (matchar[i,1]='ERCUx') then datids2[i,1]=103;	if (matchar[i,1]='HECR9') then datids2[i,1]=148;	if (matchar[i,1]='LOSQx') then datids2[i,1]=193;	if (matchar[i,1]='POPR4') then datids2[i,1]=238;	if (matchar[i,1]='STHE4') then datids2[i,1]=283;
	if (matchar[i,1]='ARLO1') then datids2[i,1]=14;	if (matchar[i,1]='CRHOH') then datids2[i,1]=59;	if (matchar[i,1]='ERGEx') then datids2[i,1]=104;	if (matchar[i,1]='HEDE4') then datids2[i,1]=149;	if (matchar[i,1]='LURE2') then datids2[i,1]=194;	if (matchar[i,1]='POTEx') then datids2[i,1]=239;	if (matchar[i,1]='STLE5') then datids2[i,1]=284;
	if (matchar[i,1]='ARPU8') then datids2[i,1]=15;	if (matchar[i,1]='CRMI8') then datids2[i,1]=60;	if (matchar[i,1]='ERHI2') then datids2[i,1]=105;	if (matchar[i,1]='HEGEx') then datids2[i,1]=150;	if (matchar[i,1]='MADE3') then datids2[i,1]=195;	if (matchar[i,1]='POVEx') then datids2[i,1]=240;	if (matchar[i,1]='STLE6') then datids2[i,1]=285;
	if (matchar[i,1]='ARPUP') then datids2[i,1]=16;	if (matchar[i,1]='CRMO6') then datids2[i,1]=61;	if (matchar[i,1]='ERHI9') then datids2[i,1]=106;	if (matchar[i,1]='HEGR1') then datids2[i,1]=151;	if (matchar[i,1]='MEPE3') then datids2[i,1]=196;	if (matchar[i,1]='PSOB3') then datids2[i,1]=241;	if (matchar[i,1]='STPI3') then datids2[i,1]=286;
	if (matchar[i,1]='ASNU4') then datids2[i,1]=17;	if (matchar[i,1]='CRRI3') then datids2[i,1]=62;	if (matchar[i,1]='ERHIx') then datids2[i,1]=107;	if (matchar[i,1]='HELA5') then datids2[i,1]=152;	if (matchar[i,1]='MINU6') then datids2[i,1]=197;	if (matchar[i,1]='PTAQx') then datids2[i,1]=242;	if (matchar[i,1]='STSYx') then datids2[i,1]=287;
	if (matchar[i,1]='ASOEx') then datids2[i,1]=18;	if (matchar[i,1]='CRSA4') then datids2[i,1]=63;	if (matchar[i,1]='ERINx') then datids2[i,1]=108;	if (matchar[i,1]='HELA6') then datids2[i,1]=153;	if (matchar[i,1]='MOCAx') then datids2[i,1]=198;	if (matchar[i,1]='PTVI2') then datids2[i,1]=243;	if (matchar[i,1]='STUM2') then datids2[i,1]=288;
	if (matchar[i,1]='ASTUx') then datids2[i,1]=19;	if (matchar[i,1]='CRWI5') then datids2[i,1]=64;	if (matchar[i,1]='ERLO5') then datids2[i,1]=109;	if (matchar[i,1]='HENI4') then datids2[i,1]=154;	if (matchar[i,1]='MOCIx') then datids2[i,1]=199;	if (matchar[i,1]='PYCA2') then datids2[i,1]=244;	if (matchar[i,1]='SYPA1') then datids2[i,1]=289;
	if (matchar[i,1]='BABR2') then datids2[i,1]=20;	if (matchar[i,1]='CYCR6') then datids2[i,1]=65;	if (matchar[i,1]='ERMU4') then datids2[i,1]=110;	if (matchar[i,1]='HERO2') then datids2[i,1]=155;	if (matchar[i,1]='MOPUx') then datids2[i,1]=200;	if (matchar[i,1]='PYMU2') then datids2[i,1]=245;	if (matchar[i,1]='TAOFx') then datids2[i,1]=290;
	if (matchar[i,1]='BOHI2') then datids2[i,1]=21;	if (matchar[i,1]='CYEC2') then datids2[i,1]=66;	if (matchar[i,1]='ERSE2') then datids2[i,1]=111;	if (matchar[i,1]='HIGR3') then datids2[i,1]=156;	if (matchar[i,1]='MOVEx') then datids2[i,1]=201;	if (matchar[i,1]='RHGL2') then datids2[i,1]=246;	if (matchar[i,1]='TEONx') then datids2[i,1]=291;
	if (matchar[i,1]='BOLA2') then datids2[i,1]=22;	if (matchar[i,1]='CYFI2') then datids2[i,1]=67;	if (matchar[i,1]='ERSEx') then datids2[i,1]=112;	if (matchar[i,1]='HYAR3') then datids2[i,1]=157;	if (matchar[i,1]='NELU2') then datids2[i,1]=202;	if (matchar[i,1]='RHHAx') then datids2[i,1]=247;	if (matchar[i,1]='TRBE3') then datids2[i,1]=292;
	if (matchar[i,1]='BOLAT') then datids2[i,1]=23;	if (matchar[i,1]='CYFI4') then datids2[i,1]=68;	if (matchar[i,1]='ERSPx') then datids2[i,1]=113;	if (matchar[i,1]='HYDRx') then datids2[i,1]=158;	if (matchar[i,1]='NOBI2') then datids2[i,1]=203;	if (matchar[i,1]='RHLAx') then datids2[i,1]=248;	if (matchar[i,1]='TRBE4') then datids2[i,1]=293;
	if (matchar[i,1]='BRJAx') then datids2[i,1]=24;	if (matchar[i,1]='CYHYx') then datids2[i,1]=69;	if (matchar[i,1]='ERST3') then datids2[i,1]=114;	if (matchar[i,1]='HYGEx') then datids2[i,1]=159;	if (matchar[i,1]='NUCAx') then datids2[i,1]=204;	if (matchar[i,1]='RHMI4') then datids2[i,1]=249;	if (matchar[i,1]='TRBEx') then datids2[i,1]=294;
	if (matchar[i,1]='BRMI2') then datids2[i,1]=25;	if (matchar[i,1]='CYLU2') then datids2[i,1]=70;	if (matchar[i,1]='EUCO1') then datids2[i,1]=115;	if (matchar[i,1]='HYGL2') then datids2[i,1]=160;	if (matchar[i,1]='NUTEx') then datids2[i,1]=205;	if (matchar[i,1]='RUABx') then datids2[i,1]=250;	if (matchar[i,1]='TRBI2') then datids2[i,1]=295;
	if (matchar[i,1]='BRTRx') then datids2[i,1]=26;	if (matchar[i,1]='CYPER') then datids2[i,1]=71;	if (matchar[i,1]='EUCO7') then datids2[i,1]=116;	if (matchar[i,1]='HYHI2') then datids2[i,1]=161;	if (matchar[i,1]='OELAx') then datids2[i,1]=206;	if (matchar[i,1]='RUAL4') then datids2[i,1]=251;	if (matchar[i,1]='TRDI2') then datids2[i,1]=296;
	if (matchar[i,1]='BUCA2') then datids2[i,1]=27;	if (matchar[i,1]='CYPL3') then datids2[i,1]=72;	if (matchar[i,1]='EUDE1') then datids2[i,1]=117;	if (matchar[i,1]='HYMI2') then datids2[i,1]=162;	if (matchar[i,1]='OELIx') then datids2[i,1]=207;	if (matchar[i,1]='RUCO2') then datids2[i,1]=252;	if (matchar[i,1]='TRFL2') then datids2[i,1]=297;
	if (matchar[i,1]='BUCIx') then datids2[i,1]=28;	if (matchar[i,1]='CYRE1') then datids2[i,1]=73;	if (matchar[i,1]='EUHE1') then datids2[i,1]=118;	if (matchar[i,1]='HYSEx') then datids2[i,1]=163;	if (matchar[i,1]='OLBOx') then datids2[i,1]=208;	if (matchar[i,1]='RUHA2') then datids2[i,1]=253;	if (matchar[i,1]='TRFLC') then datids2[i,1]=298;
	if (matchar[i,1]='CAFAx') then datids2[i,1]=29;	if (matchar[i,1]='CYRE2') then datids2[i,1]=74;	if (matchar[i,1]='EUPI3') then datids2[i,1]=119;	if (matchar[i,1]='JATAx') then datids2[i,1]=164;	if (matchar[i,1]='OXDI2') then datids2[i,1]=209;	if (matchar[i,1]='RUHI2') then datids2[i,1]=254;	if (matchar[i,1]='TRFLF') then datids2[i,1]=299;
	if (matchar[i,1]='CAIN2') then datids2[i,1]=30;	if (matchar[i,1]='CYRE5') then datids2[i,1]=75;	if (matchar[i,1]='EUSE2') then datids2[i,1]=120;	if (matchar[i,1]='JUBRx') then datids2[i,1]=165;	if (matchar[i,1]='OXSTx') then datids2[i,1]=210;	if (matchar[i,1]='RUHU6') then datids2[i,1]=255;	if (matchar[i,1]='TRHIx') then datids2[i,1]=300;
	if (matchar[i,1]='CALE6') then datids2[i,1]=31;	if (matchar[i,1]='CYSUx') then datids2[i,1]=76;	if (matchar[i,1]='EUSEx') then datids2[i,1]=121;	if (matchar[i,1]='JUCO1') then datids2[i,1]=166;	if (matchar[i,1]='PAANx') then datids2[i,1]=211;	if (matchar[i,1]='SACA1') then datids2[i,1]=256;	if (matchar[i,1]='TRPE4') then datids2[i,1]=301;
	if (matchar[i,1]='CAMI5') then datids2[i,1]=32;	if (matchar[i,1]='DADRx') then datids2[i,1]=77;	if (matchar[i,1]='EVCAx') then datids2[i,1]=122;	if (matchar[i,1]='JUDIx') then datids2[i,1]=167;	if (matchar[i,1]='PABR2') then datids2[i,1]=212;	if (matchar[i,1]='SACA3') then datids2[i,1]=257;	if (matchar[i,1]='TRPU4') then datids2[i,1]=302;
	if (matchar[i,1]='CAMI8') then datids2[i,1]=33;	if (matchar[i,1]='DEAC3') then datids2[i,1]=78;	if (matchar[i,1]='EVSEx') then datids2[i,1]=123;	if (matchar[i,1]='JUMA4') then datids2[i,1]=168;	if (matchar[i,1]='PADRx') then datids2[i,1]=213;	if (matchar[i,1]='SCCA4') then datids2[i,1]=258;	if (matchar[i,1]='TRRA5') then datids2[i,1]=303;
	if (matchar[i,1]='CAMU4') then datids2[i,1]=34;	if (matchar[i,1]='DECA3') then datids2[i,1]=79;	if (matchar[i,1]='EVVEx') then datids2[i,1]=124;	if (matchar[i,1]='JUTEx') then datids2[i,1]=169;	if (matchar[i,1]='PAHI1') then datids2[i,1]=214;	if (matchar[i,1]='SCCIx') then datids2[i,1]=259;	if (matchar[i,1]='TRUR2') then datids2[i,1]=304;
	if (matchar[i,1]='CEMIx') then datids2[i,1]=35;	if (matchar[i,1]='DECIx') then datids2[i,1]=80;	if (matchar[i,1]='FAREx') then datids2[i,1]=125;	if (matchar[i,1]='JUVA2') then datids2[i,1]=170;	if (matchar[i,1]='PAHOx') then datids2[i,1]=215;	if (matchar[i,1]='SCOL2') then datids2[i,1]=260;	if (matchar[i,1]='TYDOx') then datids2[i,1]=305;
	if (matchar[i,1]='CENCH') then datids2[i,1]=36;	if (matchar[i,1]='DELA2') then datids2[i,1]=81;	if (matchar[i,1]='FIAU2') then datids2[i,1]=126;	if (matchar[i,1]='KRDAx') then datids2[i,1]=171;	if (matchar[i,1]='PALU2') then datids2[i,1]=216;	if (matchar[i,1]='SCSCx') then datids2[i,1]=261;	if (matchar[i,1]='UNGR3') then datids2[i,1]=306;
	if (matchar[i,1]='CESP4') then datids2[i,1]=37;	if (matchar[i,1]='DESEx') then datids2[i,1]=82;	if (matchar[i,1]='FIPUx') then datids2[i,1]=127;	if (matchar[i,1]='KROCx') then datids2[i,1]=172;	if (matchar[i,1]='PANO2') then datids2[i,1]=217;	if (matchar[i,1]='SEARx') then datids2[i,1]=262;	if (matchar[i,1]='URCIx') then datids2[i,1]=307;
	if (matchar[i,1]='CEVI2') then datids2[i,1]=38;	if (matchar[i,1]='DIAC2') then datids2[i,1]=83;	if (matchar[i,1]='FRFLx') then datids2[i,1]=128;	if (matchar[i,1]='KRVIx') then datids2[i,1]=173;	if (matchar[i,1]='PAPE5') then datids2[i,1]=218;	if (matchar[i,1]='SIABx') then datids2[i,1]=263;	if (matchar[i,1]='VEARx') then datids2[i,1]=308;
	if (matchar[i,1]='CHAMx') then datids2[i,1]=39;	if (matchar[i,1]='DIACx') then datids2[i,1]=84;	if (matchar[i,1]='FRGR3') then datids2[i,1]=129;	if (matchar[i,1]='LAHIx') then datids2[i,1]=174;	if (matchar[i,1]='PAPL3') then datids2[i,1]=219;	if (matchar[i,1]='SIAN2') then datids2[i,1]=264;	if (matchar[i,1]='VETE3') then datids2[i,1]=309;
	if (matchar[i,1]='CHAN5') then datids2[i,1]=40;	if (matchar[i,1]='DIAN4') then datids2[i,1]=85;	if (matchar[i,1]='GAAEx') then datids2[i,1]=130;	if (matchar[i,1]='LALUx') then datids2[i,1]=175;	if (matchar[i,1]='PAROx') then datids2[i,1]=220;	if (matchar[i,1]='SICIx') then datids2[i,1]=265;	if (matchar[i,1]='VILE2') then datids2[i,1]=310;
	if (matchar[i,1]='CHCO1') then datids2[i,1]=41;	if (matchar[i,1]='DICA3') then datids2[i,1]=86;	if (matchar[i,1]='GAAMx') then datids2[i,1]=131;	if (matchar[i,1]='LASEx') then datids2[i,1]=176;	if (matchar[i,1]='PASE5') then datids2[i,1]=221;	if (matchar[i,1]='SILIx') then datids2[i,1]=266;	if (matchar[i,1]='VIMIx') then datids2[i,1]=311;
	if (matchar[i,1]='CHIMx') then datids2[i,1]=42;	if (matchar[i,1]='DICO1') then datids2[i,1]=87;	if (matchar[i,1]='GAAN1') then datids2[i,1]=132;	if (matchar[i,1]='LEAR3') then datids2[i,1]=177;	if (matchar[i,1]='PASEC') then datids2[i,1]=222;	if (matchar[i,1]='SIRHx') then datids2[i,1]=267;	if (matchar[i,1]='VISOx') then datids2[i,1]=312;
	if (matchar[i,1]='CHMA1') then datids2[i,1]=43;	if (matchar[i,1]='DICO6') then datids2[i,1]=88;	if (matchar[i,1]='GAAR1') then datids2[i,1]=133;	if (matchar[i,1]='LEDUx') then datids2[i,1]=178;	if (matchar[i,1]='PHABx') then datids2[i,1]=223;	if (matchar[i,1]='SOAL6') then datids2[i,1]=268;	if (matchar[i,1]='VUOCx') then datids2[i,1]=313;
	if (matchar[i,1]='CHPI8') then datids2[i,1]=44;	if (matchar[i,1]='DILA9') then datids2[i,1]=89;	if (matchar[i,1]='GABR2') then datids2[i,1]=134;	if (matchar[i,1]='LEHI2') then datids2[i,1]=179;	if (matchar[i,1]='PHAM4') then datids2[i,1]=224;	if (matchar[i,1]='SOAM4') then datids2[i,1]=269;	if (matchar[i,1]='WAMAx') then datids2[i,1]=314;
	if (matchar[i,1]='CHSE2') then datids2[i,1]=45;	if (matchar[i,1]='DILI2') then datids2[i,1]=90;	if (matchar[i,1]='GACA6') then datids2[i,1]=135;	if (matchar[i,1]='LEMU3') then datids2[i,1]=180;	if (matchar[i,1]='PHAN5') then datids2[i,1]=225;	if (matchar[i,1]='SOASx') then datids2[i,1]=270;	if (matchar[i,1]='XXXXx') then datids2[i,1]=315;



