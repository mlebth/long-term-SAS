
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

* if processes get too slow, run this to free up memory, then rerun relevant 
	sections;
* proc datasets library=work kill noprint; run; 

*import herb data;
proc import datafile="C:\Users\eb23667\Desktop\Book1.csv"
out=invasives dbms=csv replace; getnames=yes; run;  * N = 500;

proc contents data=invasives; run;

data inv; set invasives;
	if INVSPP1 =  '    '  then pa=0;
	if INVSPP1 ne '    ' then pa=1;
run;
proc print data=inv; run;

proc freq data=inv; tables plot*pa; run;
