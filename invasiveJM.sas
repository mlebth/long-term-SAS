* invasiveJM.sas;
PROC IMPORT OUT= WORK.DAThbf 
  DATAFILE= "C:\myfiles\students - my current students\Jessica Menchaca\MenchacaData 7-7-2013.xlsx" 
  DBMS=EXCEL REPLACE; RANGE="hbf$"; GETNAMES=no;
  MIXED=yes; SCANTEXT=YES; SCANTIME=YES;
RUN;  * N = 34;

* proc print data=dathbf; title 'dathbf';
run;
* 16 columns = 1 col var names, 15 cols plots, 34 rows = vars;
* char vars: 1 date, 2 site, 3 habitat, 9 slopface, 15 soildescrip, 33 distrb, 34 notes; 
* num vars: 4 plotid, 5 lat, 6 long, 7 elev, 8 distostrt, 10 soil1, 11 soil2, 12 soil3, 13 soil4,
            14 soil5, 16 wtrpres, 17 distowtr, 18 ardo, 19 boiss, 20 coes, 21 cyda, 22 laca, 23 lase, 
            24 raru, 25 soha, 26 lyja, 27 lilu, 28 nado, 29 phse, 30 meaz, 31 trsf, 32 alju;
* mixed vars: 10 soil1, 11 soil2, 12 soil3, 13 soil4, 14 soil5;

* drop two variables;
data datred; set dathbf; if (F1 NE 'soildescrip' & F1 NE 'notes');  * N = 32;
* transpose the data set;
proc transpose data=datred out=dattrans; var F1-F16;
proc print data=dattrans; title 'dattrans';
run;  * N = 16;

data datfix; set dattrans; 
  if (_name_ NE 'F1');  * drop first row;
  * rename the variables;
  if _name_ = 'F2'  then plotid = 'plot01';  if _name_ = 'F3'  then plotid = 'plot02';
  if _name_ = 'F4'  then plotid = 'plot03';  if _name_ = 'F5'  then plotid = 'plot04';
  if _name_ = 'F6'  then plotid = 'plot05';  if _name_ = 'F7'  then plotid = 'plot06';
  if _name_ = 'F8'  then plotid = 'plot07';  if _name_ = 'F9'  then plotid = 'plot08';
  if _name_ = 'F10' then plotid = 'plot09';  if _name_ = 'F11' then plotid = 'plot10';
  if _name_ = 'F12' then plotid = 'plot11';  if _name_ = 'F13' then plotid = 'plot12';
  if _name_ = 'F14' then plotid = 'plot13';  if _name_ = 'F15' then plotid = 'plot14';
  if _name_ = 'F16' then plotid = 'plot15';
  date = col1; site = col2; habitat = col3; lat = col5+0; long = col6+0; elev = col7+0;
  distostrt = col8+0; slopface = col9; soil1 = col10; soil2 = col11; soil3 = col12;
  soil4 = col13; soil5 = col14; wtrpres = col15;  distowtr = col16+0; distrb = col32;  
  ardo = col17+0; bois = col18+0; coes = col19+0; cyda = col20+0; laca = col21+0;
  lase = col22+0; raru = col23+0; soha = col24+0; lyja = col25+0; lilu = col26+0;
  nado = col27+0; phse = col28+0; meaz = col29+0; trsf = col30+0; alju = col31+0;
  * do some cleanup of soil, create new variables s1-s5;  * . means missing number;
  if (soil1 = 'unable to measure') then s1 = .; else s1=soil1 + 0;  
  if (soil2 = 'unable to measure') then s2 = .; else s2=soil2 + 0;  
  if (soil3 = 'unable to measure') then s3 = .; else s3=soil3 + 0;  
  if (soil4 = 'unable to measure') then s4 = .; else s4=soil4 + 0;  
  if (soil5 = 'unable to measure') then s5 = .; else s5=soil5 + 0;
  avgdepth = (s1 + s2 + s3 +s4 + s5)/5;  * averages soil depths;
  if (avgdepth GE 7) then soilcat = 'd'; if (avgdepth < 7) then soilcat = 's'; * categories of soiil depth;
  * cleanup of other vars;
  transectdist = distostrt + 0;   * adding 0 can convert character to numeric;
  if (distrb =  'none' & site = 'hbf') then disturb = 'no';
  if (distrb NE 'none' & site = 'hbf') then disturb = 'pm'; * partly mowed;  
  keep plotid date site habitat lat long elev disturb avgdepth soilcat
     wtrpres distowtr slopface transectdist
     ardo bois coes cyda laca lase raru soha lyja lilu 
     nado phse meaz trsf alju;
* proc print data=datfix; title 'datfix'; run;

proc means data=datfix sum noprint; 
   var ardo bois coes cyda laca lase raru soha lyja lilu 
     nado phse meaz trsf alju;
   output out = datout1 sum = ardo bois coes cyda laca lase raru soha lyja lilu 
     nado phse meaz trsf alju;
proc print data=datout1; title 'out1';
run;
data datspprops; set datout1;
  nplots = 15;
  fardo = ardo/nplots; fbois = bois/nplots; fcoes = coes/nplots;
  fcyda = cyda/nplots; flaca = laca/nplots; flase = lase/nplots; 
  fraru = raru/nplots; fsoha = soha/nplots; flyja = lyja/nplots; 
  flilu = lilu/nplots; fnado = nado/nplots; fphse = phse/nplots; 
  fmeaz = meaz/nplots; ftrsf = trsf/nplots; falju = alju/nplots;
run;
proc print data=datspprops; run;
proc transpose data=datspprops out=forplot;
  var fardo fbois  fcoes 
  fcyda flaca flase fraru fsoha flyja 
  flilu fnado fphse fmeaz ftrsf falju; 
run;
data forplot2; set forplot;
  x = _n_; fsp = col1; xlabel = _name_;
  drop col1 _name_; 
proc print data=forplot2; run;


* --- categorical variables ----;
proc freq data=datfix;  
   tables ardo bois coes cyda laca lase raru soha lyja lilu 
     nado phse meaz trsf alju
   title 'species freqs';
run;

proc freq data=datfix; tables disturb habitat wtrpres
   disturb*habitat disturb*soha disturb*meaz habitat*meaz habitat*soha 
   / expected fisher; 
title 'freqs';
run;
* extra code wtrpres*habitat wtrpres*disturb wtrpres*soha wtrpres*meaz;
proc freq data=datfix; tables disturb habitat wtrpres
   soilcat*habitat soilcat*disturb soilcat*meaz soilcat*soha 
   / expected fisher; 
title 'freqs';
run;
*---- continuous variables ------;
proc means data=datfix noprint n mean stddev;
  var lat long elev avgdepth distowtr;
  output out=datout2 n=nlat nlong nelev navgdepth ndistowtr 
                     mean = mlat mlong melev mavgdepth mdistowtr
                     stddev = slat slong selev savgdepth sdistowtr;
proc print data=datout2; title 'datout2';
run;
proc univariate data=datfix normal plot; 
   var elev avgdepth distowtr;
   title 'proc univariate';
run;
* compare continuous with categorical variable we might do this --------;
proc sort data=datfix; by disturb;
proc means data=datfix mean; by disturb; var avgdepth;
run;
proc sort data=datfix; by habitat;
proc means data=datfix mean stderr; by habitat; var avgdepth;
run;



