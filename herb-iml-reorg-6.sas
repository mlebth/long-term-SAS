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

*getting stem counts;
proc sort data=herb1; by sspp; run;
proc means data=herb1 noprint n sum mean min max; by sspp; var coun;
  output out=sumstems n=n sum=sumcount mean=meancount min=mincount max=maxcount;
data sumstems1; set sumstems; drop _TYPE_ _FREQ_; RUN;
proc sort data=sumstems1; by sumcount n;
*proc print data=sumstems1; title 'sumstems';
run;

*renaming plots 1-56;
data plotid; set herb1; dummy = 1; keep plot dummy;
proc sort data=plotid; by plot; run;
proc means data=plotid noprint mean noprint; by plot; var dummy;
  output out=plotid2 mean = mean;
*proc print data=rowcount2; title 'rowcount2'; 
run;
data plotid3; set plotid2; newplotid = _n_; keep plot newplotid;
*proc print data=plotid3; title 'plotid3';
run; *n=55;

data herb2; set herb1;
	*reassigning plot ids;
	if plot = 1181 then plotnew = 1; if plot = 1186 then plotnew = 2; if plot = 1188 then plotnew = 3; 
	if plot = 1189 then plotnew = 4; if plot = 1190 then plotnew = 5; if plot = 1191 then plotnew = 6; 
	if plot = 1192 then plotnew = 7; if plot = 1193 then plotnew = 8; if plot = 1194 then plotnew = 9; 
	if plot = 1195 then plotnew = 10; if plot = 1196 then plotnew = 11; if plot = 1197 then plotnew = 12; 
	if plot = 1198 then plotnew = 13; if plot = 1199 then plotnew = 14; if plot = 1200 then plotnew = 15; 
	if plot = 1201 then plotnew = 16; if plot = 1202 then plotnew = 17; if plot = 1203 then plotnew = 18; 
	if plot = 1204 then plotnew = 19; if plot = 1205 then plotnew = 20; if plot = 1206 then plotnew = 21; 
	if plot = 1207 then plotnew = 22; if plot = 1208 then plotnew = 23; if plot = 1209 then plotnew = 24; 
	if plot = 1210 then plotnew = 25; if plot = 1211 then plotnew = 26; if plot = 1212 then plotnew = 27; 
	if plot = 1213 then plotnew = 28; if plot = 1214 then plotnew = 29; if plot = 1215 then plotnew = 30; 
	if plot = 1216 then plotnew = 31; if plot = 1217 then plotnew = 32; if plot = 1218 then plotnew = 33; 
	if plot = 1219 then plotnew = 34; if plot = 1220 then plotnew = 35; if plot = 1221 then plotnew = 36;
	if plot = 1222 then plotnew = 37; if plot = 1223 then plotnew = 38; if plot = 1224 then plotnew = 39; 
	if plot = 1225 then plotnew = 40; if plot = 1227 then plotnew = 41; if plot = 1228 then plotnew = 42; 
	if plot = 1229 then plotnew = 43; if plot = 1230 then plotnew = 44; if plot = 1231 then plotnew = 45; 
	if plot = 1232 then plotnew = 46; if plot = 1233 then plotnew = 47; if plot = 1234 then plotnew = 48; 
	if plot = 1235 then plotnew = 49; if plot = 1236 then plotnew = 50; if plot = 1237 then plotnew = 51; 
	if plot = 1238 then plotnew = 52; if plot = 1239 then plotnew = 53; if plot = 1240 then plotnew = 54; 
	if plot = 5300 then plotnew = 55; 
	*reassigning species codes;
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
proc sort data=herb2; by plotnew year spid;
*proc print data=herb2 (firstobs=1 obs=20); title 'herb2'; run;
*proc contents data=herb2; run;

data herbsp; set herb1; keep sspp; run;

proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs); 

*reading in numeric data;
use herb2; read all into matnum;				* print (matnum[1:20,]); *14 columns, 12544 rows;
nrecords = nrow(matnum);						* print nrecords; *12544;

*creating a new matrix;
matnumdat=j(nrecords,18,9999); 					
do i = 1 to nrecords;    						* record by record loop;
  do j = 1 to nyrs;      						* yr by yr loop;
    if (matnum[i,4] = inputyrs[j]) then matnumdat[i,1] = j; 
  end;                   						* end yr by yr loop;
end;                     						* end record by record loop;
* print (matnumdat[1:20,]);

*order of variables in matnum: 
1-plot, 2-quad, 3-coun, 4-year, 5-covm, 6-soileb, 7-elev, 8-slope, 
9-hydrn, 10-aspect, 11-bcat, 12-prpo, 13-type, 14-plotnew, 15-spid;

* fill matnumdat; 
do i = 1 to nrecords;    						* record by record loop;
  uniquad=10*(matnum[i,14]-1)+ matnum[i,2];		* unique quadrat id;
  time1 = matnumdat[i,1];
  time2 = time1 + 1;
  matnumdat[i,2]  = time2;	
  matnumdat[i,3]  = matnum[i,4];   * year1;
  *matnumdat[i,4] will be year2;
  matnumdat[i,5]  = matnum[i,12];  * prpo;
  matnumdat[i,6]  = matnum[i,14];  * plot;
  matnumdat[i,7]  = uniquad;  	   * quad;
  matnumdat[i,8]  = matnum[i,13];  * type;
  matnumdat[i,9]  = matnum[i,15];  * spid;
  matnumdat[i,10] = matnum[i,3];   * coun;
  matnumdat[i,11] = matnum[i,11];  * bcat;
  matnumdat[i,12] = matnum[i,10];  * aspect;
  matnumdat[i,13] = matnum[i,9];   * hydrn;
  matnumdat[i,14] = matnum[i,6];   * soileb;
  matnumdat[i,15] = matnum[i,7];   * elev;
  matnumdat[i,16] = matnum[i,8];   * slope;
  matnumdat[i,17] = matnum[i,5];   * covm1;
  *matnumdat[i,18] will be covm2;     
end;
* print (matnumdat[12524:12544,]);

*fills in year2 and covm2;
do i = 1 to nrecords;
  plot = matnumdat[i,6]; time2 = matnumdat[i,2];
  do j = 1 to nrecords;
    if (matnumdat[j,6] = plot & matnumdat[j,1] = time2) then do;
	  *print i,j;
  	  matnumdat[i,4]  = matnumdat[j,3];  * year2;
	  matnumdat[i,18] = matnumdat[j,17]; * covm2;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print (matnumdat[10:20,]);

/*
*reading in character data;
use herbsp; read all var _char_ into matchar;	* print matchar;  *1 column, 12544 rows;
* print (matchar[10:20,]);

create matdat from matnumdat;
append from matchar;
close matdat; 	

*presence/absence matrix;
matpa=matnumdat;

do i=1 to nrecords;
	countcol=10;
	matpa[i,countcol]=99;
		if (matnumdat[i,countcol]=0) then matpa[i,countcol]=0;
		if (matnumdat[i,countcol]>0) then matpa[i,countcol]=1;
end;
* print (matpa[10:20,]);
*/

*labeling columns;
cnames = {'time1', 'time2', 'year1', 'year2', 'prpo', 'plot', 'quad', 'type', 'spid',
		  'coun',  'bcat', 'aspect', 'hydr', 'soil', 'elev', 'slope', 'cov1', 'cov2'};
create herbdat from matnumdat [colname = cnames];
append from matnumdat;

quit;

*proc print data=herbdat (firstobs=111 obs=120); title 'herbdat'; run;

*checking that values make sense;
proc sort data=herbdat; by spid;
proc means data=herbdat noprint; 
	output out=datcheck;
*proc print data=datcheck; title 'datcheck'; run;

*adding back in species names for reduced confusion;
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

************reorganizing herbdat--structure 1--pref/post;
data herbdat2; set herbdat1;
	if (year1<2011)  then yrcat=1; 
	if (year1>=2011) then yrcat=2;	
	drop time1 time2 year2 cov2 prpo; 
	rename year1=year cov1=caco;
run;

*herbs pre-fire;
data herbspre;  set herbdat2;
	if yrcat=1;
run; *N=1388;
*pooling data in herbspre;
proc sort  data=herbspre; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect;
proc means data=herbspre n mean noprint; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspre n=ncov ncoun 
		   			  mean=mcov mcoun;
run;
*proc print data=mherbspre (firstobs=1 obs=20); title 'mherbspre'; run; *N=1063;

*herbs post-fire;
data herbspost; set herbdat2;
	if yrcat=2; 
run; *N=11156;
proc sort  data=herbspost; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect;
proc means data=herbspost n mean noprint; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspost n=ncov ncoun 
		   			  	  mean=mcov mcoun;
run;
*proc print data=mherbspost (firstobs=1 obs=20); title 'mherbspost'; run; *N=5782;

*merging pre/post;
proc sort data=mherbspost; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect;
proc sort data=mherbspre; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect; run;
data herbmerge1; merge mherbspost mherbspre; by yrcat plot bcat quad spid sspp type elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_; 
run;
*proc print data=herbmerge1 (firstobs=1 obs=20); title 'herbmerge1'; run;	*N=6845;


************reorganizing herbdat--structure 2--pref/2011-2015;
*herbs pre-fire;
data herbspre;  set herbdat2;
	if yrcat=1;
	year=1111;
run; *N=1388;
*pooling data in herbspre;
proc sort  data=herbspre; by yrcat year plot bcat quad spid sspp type elev hydr slope soil aspect;
proc means data=herbspre n mean noprint; by yrcat year plot bcat quad spid sspp type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspre n=ncov ncoun 
		   			  mean=mcov mcoun;
run;
*proc print data=mherbspre (firstobs=1 obs=20); title 'mherbspre'; run; *N=1063;

*herbs post-fire;
data herbspost; set herbdat2;
	if yrcat=2; 
run; *N=11156;
proc sort  data=herbspost; by year plot bcat quad spid type elev hydr slope soil aspect;
proc means data=herbspost n mean noprint; by year plot bcat quad spid type elev hydr slope soil aspect;
	var caco coun;
	output out=mherbspost n=ncov ncoun 
		   			  	  mean=mcov mcoun;
run;
*proc print data=mherbspost (firstobs=1 obs=20); title 'mherbspost'; run; *N=11156;

*merging pre/post;
proc sort data=mherbspost; by year plot bcat quad spid type elev hydr slope soil aspect;
proc sort data=mherbspre; by year plot bcat quad spid type elev hydr slope soil aspect; run;
data herbmerge2; merge mherbspost mherbspre; by year plot bcat quad spid type elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_; 
run;
*proc print data=herbmerge2 (firstobs=1 obs=20); title 'herbmerge2'; run;	*N=12189;
