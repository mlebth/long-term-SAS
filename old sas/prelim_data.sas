* Streptanthus greenhouse Ca and Magnesium experiment;

*preliminary data analysis
 June 16, 2014 modified July 30, 2014
 Ashley Green;

*only have full data for parts of the second pilot;

OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";


* pilot 1 import. 1st set that was planted;
* Data just from Pilot 1, (Ca:Mg treatments): 5:1 (red) AND 1:1 (black)
data dat1; 
PROC IMPORT OUT= WORK.streptwork1
  datafile= "E:\Streptanthus\SAS prelim\Strept_Mg_P1_raw.csv"
  DBMS=CSV REPLACE; GETNAMES=YES; DATAROW=2; 
RUN;

proc print data=streptwork1; title 'pilot1 raw data'; run;


* n = 73 and 36 vars;
*THERE should only be 60 streptanthus plants based on the design but 36 had two germinate so labeled 36.1 and 36.2;

proc contents data= streptwork1; run;
*The capsella numbers were 23-28 and 52-57. These are in the data set.;

proc anova data=streptwork1; class tr;
	title 'anova of germination';
	model germ = tr;
run;
*treatment may be significant in whether a plant germinates;


data work1; set streptwork1;
	grow = .;
  	if ((germ = .) & (firsttruelvs = .)) then grow = 0;
  	if ((germ ^= .) | (firsttruelvs ^= .)) then grow = 1;
run;
*This drops the plants that did not germinate from the analysis;

proc freq data = work1; table grow*tr; run;
* The difference in the number of plants that germinated in 3 plants;


*Pilot 2 import; 
*treatments here were red= 5:1, blue = 35:1, and green is 1:5 (Ca:Mg);
* all plants were streptanthus not capsella;
PROC IMPORT OUT= WORK.streptwork2
  datafile= "E:\Streptanthus\SAS prelim\Strept_Mg_P2_raw.csv"
  DBMS=CSV REPLACE; GETNAMES=YES; DATAROW=2; 
RUN;
* N = 72 and 24 vars;

proc contents data = streptwork2; title 'contents streptwork2';
run;
proc print data=streptwork2; title 'pilot2 raw data';
run;

proc anova data=streptwork2; class tr;
	title 'anova of germination';
	model germ = tr;
run;
* treatment is not significantly different;

data work2; set streptwork2;
	grow = .;
  	if ((sprout = .) & (germ = .)) then grow = 0;
  	if ((sprout ^= .) | (germ ^= .)) then grow = 1;
run;

proc freq data = work2; table grow*tr; run;
* about 1/3 blue, 1/3 green, and 1/4 red planted seeds grew;




*Now to concatenate datasets, the num/id of plants will not be unique;

data all; set work1 work2; run; * N = 133 and 26 var;

*NOTE: census are NOT same times in development, so analysis on these data should be separate;

proc contents data = all; run;
proc print data = all; title 'all data'; run;
*Everything seemed to combine well; 
*Coms on the 6_20 census are a problem and need to be fixed;

*Quick look at differences germinating and growing first leaves (true leaves) between treatments with both pilots present;

proc freq data = all; table tr*grow; run;
* 84 percent did not germinate, 35:1 had 6.21%, 5:1 had 17.24 %, 1:1 had 11.03%, and 1:5 had 7.59% germinating.
  5:1 had more plants total than any other group (30 + 12) because planted for both pilots. 
  Also, second pilot had much lower overall germination rate.
  The ones that did germinate were planted roughly in order (came from the same silques);

/*
proc sort data = all; by tr; run;
proc means data = all n; by tr; var id1 id; 
	output out = trnum; title 'means by tr'; run;
* total number planted per treatment (ca:mg) is: blk (1:1) =31,
  blu (35: 1) = 30, gre (1:5) = 30, and red (5:1) = 42;


data trnum2; set trnum;
	numplant = (id1 +id);
	if _STAT_ ^= 'N' then delete;
	drop _TYPE_ _FREQ_ _STAT_ id1 id;
run;

proc print data = trnum2; title 'trnum2'; run;

data all2; merge all trnum2; by tr; run;

proc print data = all2; title 'all with tot num per tr'; run;

proc freq data = all2; table tr*grow*numplant; run;
* blk had 51.6 % germ, blu had 30.0% germ, gre had 36.7 % germ and red had 59.5% germ;
* The second exper had only 3/12 plants in red germ, so there may be a much lower germination rate in the second 
  experiment that has nothing to do with the treatments and more with planting date;

*/


proc glm data = work1; class tr;
	*model secondpairtruelvs = tr;						* this model was not significant;
	*model secondpairtruelvs = tr firsttruelvs;			* the initial size not treament determined when the next leaves grew;
	*model firsttruelvs = tr;							* the time until the first true lvs may be significant p=0.0366;
	*model firsttruelvs = tr germ;						* the germination time not the tr is the significant value;
	model c1numlvs = tr;
  title 'glm of p1';
run;

proc anova data = work1; class tr;
	*model c1numlvs = tr;								* significant treatment effect;
	*model c2numlvs = tr;								* not significant;
	*model c3numlvs = tr;								* not significant;
	*model c4numlvs = tr;								* not significant;
	*model c4repro = tr;								* not significant;
	*model c1numfunglvs = tr;							* close to significant p=0.0552;
	*model c1class = tr;								* not significant;
	*model c1numdeadlvs = tr;							* not significant;
	model c2class = tr;									* not significant;
title 'anova of p1';
run;

* proxy for biomass;
data p1size; set work1;
	c2size= (c2numlvs*c2lenlvs);
	c3size= (c3numlvs*c3lenlvs);
	c4size= (c4numlvs*c4lenlvs);
run;

proc anova data = p1size; class tr;
	model c2size = tr;									* not significant;		
run;



proc glm data = work2; class tr;
	*model secondpairtruelvs = tr;						* not significant;
	*model secondpairtruelvs = tr firsttruelvs;			* the initial size not treament determined when the next leaves grew;
	*model firsttruelvs = tr;							* not significant;
	*model firsttruelvs = tr germ;						* the germination time not the tr is the significant value;
	model germ = tr;									* not significant
  title 'glm of p1';
run;

proc anova data = work2; class tr;
	*model grow = tr;									* not significant;
	*model c1numlvs = tr;								* not significant;
	*model c2numlvs = tr;								* not significant;
	*model c3numlvs = tr;								* not significant;
	*model c4numlvs = tr;								* not significant;
	*model c5numlvs = tr;								* not significant;
	*model c1lenlvs = tr;								* not significant;
	*model c2lenlvs = tr;								* not significant;	
	*model c3lenlvs = tr;								* not significant;	
	*model c4lenlvs = tr;								* not significant;
	model c5lenlvs = tr;								* not significant;
  title 'anova of p2';
run;

data p2size; set work2;
	c1size= (c1numlvs*c1lenlvs);
	c2size= (c2numlvs*c2lenlvs);
	c3size= (c3numlvs*c3lenlvs);
	c4size= (c4numlvs*c4lenlvs);
	c5size= (c5numlvs*c5lenlvs);
run;

proc glm data = p2size; class tr;
	model c5size = germ tr;		* the germination date is significant in future size, but treatment is not;
	*model germ = id2;				* not significant because germ = the time to germinate;
	*model grow = id2;				* this var is highly significant, so seed order is playing a huge role: 
									  germination is determined by original silique not treatment;
run;

* size seem to correlate with previous size, but germination does not correlate to anything;

proc sort data = p2size; by grow id; run;
proc print data = p2size; title 'id number'; run;

data viable; set p2size;
	if id2>35 then delete;
run;

proc glm data = viable;
	class tr grow;
	model grow = tr;		*removing the unviable seed did not make treatment more significant to whether plants would germinate;
					
run;

*Treatment does not seem to significantly effect growth of streptanthus;






