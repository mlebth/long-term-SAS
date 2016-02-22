proc sql;
	select plot
	from seedsmerge2; 
quit;

proc freq data=piquilseed6; tables plot*year; run;

proc sort data=shrubs; by MacroPlot_Name Date; run;
DATA shrubsx; 	set shrubs;
    m=MONTH(Date);
    d=DAY(Date) ;
    y=YEAR(Date);

RUN;
PROC PRINT DATA=shrubsx;
   VAR Date MacroPlot_Name m d y;
   FORMAT Date date9. ;
RUN;



proc sort data=shrubs; by MacroPlot_Name Date; run; 
data shrubs1; set shrubs;
	if Species_Symbol='' then delete; 
	if Status = 'D' then delete;
	subp = 'shru';
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything; run;
data dat2; set shrubs1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
data shrubs2 (rename=(MacroPlot_Name=plot) rename=(char3=sspp)	
			  rename=(AgeCl=agec) rename=(Count=coun));
	set dat2; run;
data shrubs3 ;
	year = year(Date);
	*if year = '.' then year = 1999;
	set shrubs2;
run; 
proc sort data=shrubs3; by plot year; run; 

proc print data=shrubs3; run;

(keep=plot year sspp agec coun subp)
