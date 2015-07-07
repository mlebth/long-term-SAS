*use dataset seedpairs: piquil 2002-2014
	 and seedpairspost: 2011-2014;

proc glm data=seedpairs; title 'seedpairs glm2'; 
	*model pita2 = covm2 pita1 covm2*pita1;
	*model pita2 = covm2 pita1;
	*model pita2 = bcat1 pita1 pita1*bcat1;
	model pita2 = bcat1 pita1;
	*model pita2 = covm2;
	output out=glmout2 r=ehat;
run;
proc univariate data=glmout2 plot normal; var ehat pita2; run;

/*
ods html;
proc sgplot data=seedpairs;
	scatter y=covm2 x=pita2 /group=soil name="data";
	keylegend "data"/ title="group";
run;
ods html close;
*/
   
*BCAT1 models;
proc glimmix data=seedpairspost; title 'seedpairspost bcat1';
  class plot bcat1;
  model pita2 = pita1 bcat1 pita1*bcat1 / distribution=normal link=identity solution; *DDFM=bw; *DDFM=KR;
  *model pita2 = pita1 bcat1 / distribution=negbin link=log solution; *DDFM=bw; *DDFM=KR;
  random plot(bcat1) / subject=plot;
  lsmeans bcat1 / ilink cl;
  output out=glmout2 resid=ehat;
run;  

*can cover cover be predicted by bcat1?;
proc glimmix data=seedpairspost; title 'seedpairspost covm/bcat';
  class bcat1;
  model covm2 = bcat1 covm1 bcat1*covm1/ distribution=negbin link=log solution;
  random plot(bcat1);
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
  class plot bcat1;
  *model pita2 = pita1 covm2 pita1*covm2 / distribution=normal link=identity solution; *DDFM=bw; *DDFM=KR;
  model pita2 = pita1 covm2 / distribution=negbin link=log solution; *DDFM=bw; *DDFM=KR;
  random plot(bcat1) / subject=plot;
  lsmeans bcat1 / ilink cl;
  output out=glmout2 resid=ehat;
run;  
