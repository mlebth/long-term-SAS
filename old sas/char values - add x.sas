* try character variable splits;
data dummydat; input char1 $; datalines;
ILVO
ILVO
CAAM1
CAAM1
CAAM2
QUMA
QUMA
;
proc print data=dummydat;
run;

data dat2; set dummydat;
char2 = trim(char1)||'x'; * char2 has x's added to everything;
data dat3; set dat2;
length char3 $ 5;         * char3 has x's only in place of blanks;
char3 = char2;
proc print data=dat3;
run;

******************************* seedling cleanup example:;
data seedlings1; set seedlings;
	if Species_Symbol='' then delete;
	char2 = trim(Species_Symbol)||'x'; * char2 has x's added to everything;
data dat2; set seedlings1;
	length char3 $ 5;         * char3 has x's only in place of blanks;
	char3 = char2; run;
/*proc print data=dat3; run;*/

data seedlings2 (rename=(MacroPlot_Name=plot) rename=(Monitoring_Status=most) 
				 rename=(char3=sspp) rename=(SizeClHt=heig) rename=(Status=stat) 
				 rename=(Count=coun));
	set dat2;
data seedlings3 (keep=plot most sspp heig coun stat date);
	set seedlings2;
run;
proc sort data = seedlings3; by plot; run;

********************************


* to reverse it;
data dat4; set dat3;
length char4a $ 4;  
length char4b $ 1;
length char5 $ 5;
char4a = substr(char3,1,4);
char4b = substr(char3,5,1);
if (char4b = 'x') then char4c = ' ';
if (char4b ^= 'x') then char4c = char4b;
* char5 = char4a||char4c;
char5 = catt(char4a,char4c);              * char5 has trailing blanks if it does not have a #;
proc print data=dat4;
run;
* original was 4 character;
* ILVOx is less than ILVO1;

