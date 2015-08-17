data temp; set survresiduals;
 if t1 < 25 then sclass = t1;
 if (t1 > 24 & t1 < 50) then sclass = round(t1,10);
 if (t1 > 49 & t1 < 100) then sclass = round(t1,20);
 if (t1 > 99) then sclass = 150;
proc sort data=temp; by sclass;
proc means data=temp n sum; by sclass; var surv logt1 pred predp t1;
  output out=temp2 n=nclass nlogt1 npred npredp nt1
                 sum = nsurv sumlogt1 sumpred sumpredp sumt1;
run;
data temp3; set temp2;
  survnew = nsurv/nclass;      * linear scale for survival;

  * alternatives for t1 (size);  
  avgt = sumt1/nt1;            * linear scale for size: probably less useful than logt1;
  backavlogt1 = exp(avglogt1); * linear scale for size;
  avglogt1 = sumlogt1/nt1;     * log scale for size;   * probably most useful;

  * logit scale;  * pred already logit-scale; 
  avgpred = sumpred/npred;     * still on logit scale;
  logitsurvnew = log(survnew / (1 - survnew));  * logit transformation;

  * linear scale for survival;
  avgpredp = sumpredp/npredp;            * back-transformed plant-by-plant, then averaged. probably most useful;
  backavgpred = 1/(1 + exp(-avgpred));   * backtransformed average;
run;
proc print data=temp3;
run;
proc plot data=temp3; 
  plot survnew*avglogt1 logitsurvnew*avglogt1
       avgpred * logitsurvnew 
       avgpredp*survnew backavgpred*survnew; 
run;

/*
* response:   mass, cover, count, plant survival (0 or 1
* continuous predictor: cover, light level, previous size, previous count, ....
* categorical predictor: cover class, light level class, soil type, burn type

* if binning (= pooling into classes and averaging) is not necessary, then

plot:  nature:  response v predictor                                [bar graphs for class predictors]
                (transformed) response v (transformed) predictor

	   fit:     predicted v (transformed) response

	   also useful:  backtransformed predicted v (untransformed) response


for example: y = count. negative binomial. link = log. 

plot:  nature: count v cover  
               log(count) v cover

	   fit:    predicted v log(obs count)

	   also useful:  exp(predicted) v obs count 
	
*/
