*use dataset seedpairs: piquil 2002-2014
	 and seedpairspost: 2011-2014;

proc glm data=seedsmerge; title 'seedpairs glm2'; 
	*model pita2 = covm2 pita1 covm2*pita1;
	*model pita2 = covm2 pita1;
	*model pita2 = bcat pita1 pita1*bcat;
	model pita = bcat soil bcat*soil*year year caco;
	*model pita2 = covm2;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat pita; run;

/*
ods html;
proc sgplot data=seedpairs;
	scatter y=covm2 x=pita2 /group=soil name="data";
	keylegend "data"/ title="group";
run;
*/
   
*BCAT models;
proc glimmix data=seedpairspost; title 'seedpairspost bcat';
  class plot bcat;
  model pita2 = pita1 bcat pita1*bcat / distribution=normal link=identity solution; *DDFM=bw; *DDFM=KR;
  *model pita2 = pita1 bcat / distribution=negbin link=log solution; *DDFM=bw; *DDFM=KR;
  random plot(bcat) / subject=plot;
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;  

*can cover cover be predicted by bcat?;
proc glimmix data=seedpairspost; title 'seedpairspost covm/bcat';
  class bcat;
  model covm2 = bcat covm1 bcat*covm1/ distribution=negbin link=log solution;
  random plot(bcat);
  output out=glmout2 resid=ehat;
run;  

*SOIL models;
proc glimmix data=seedpairs; title 'seedpairs soil';
  class plot soil;
  model pita2 = pita1 soil pita1*soil / distribution=poisson link=log solution; *DDFM=bw; *DDFM=KR;
  *model pita2 = pita1 soil / distribution=normal link=identity solution; *DDFM=bw; *DDFM=KR;
  random plot(soil) / subject=plot;
  lsmeans soil / ilink cl;
  output out=glmout2 resid=ehat;
run;  

*COVM1 models;
proc glimmix data=seedpairs; title 'seedpairs glimmix';
  class plot bcat;
  *model pita2 = pita1 covm2 pita1*covm2 / distribution=normal link=identity solution; *DDFM=bw; *DDFM=KR;
  model pita2 = pita1 covm2 / distribution=negbin link=log solution; *DDFM=bw; *DDFM=KR;
  random plot(bcat) / subject=plot;
  lsmeans bcat / ilink cl;
  output out=glmout2 resid=ehat;
run;  


proc glimmix data=seedsmerge2; title 'seedsmerge2';
  class plot soil bcat;
  model pita14 = caco soil bcat soil*bcat*caco/ distribution=normal link=identity solution DDFM=bw; 
  *model pita2 = pita1 soil / distribution=normal link=identity solution; 
  random plot(soil*bcat) / subject=plot;
  lsmeans soil / ilink cl;
  output out=glmout2 resid=ehat;
run;  

proc glimmix data=seedsmerge2; title 'seedsmerge2';
  class plot soil bcat;
  model pita14 = pita13 soil bcat/ distribution=normal link=identity solution DDFM=bw; 
  *model pita2 = pita1 soil / distribution=normal link=identity solution; 
  random plot(soil*bcat) / subject=plot;
  *lsmeans soil / ilink cl;
  output out=mout2 predicted=pred resid=ehat;
run;  

proc plot data=mout2; 
  plot pita14*pita13; 
run;

data modifiedpredp; set mout2;
	predp=1/

*on iml piquil--remove all seedling data for 2011, there isn't any;
proc freq data=seedsmerge2; tables pita11*plot; run;
proc print data=seedsmerge2; var plot mpitapre pita11 pita12 pita13 pita14; run;
