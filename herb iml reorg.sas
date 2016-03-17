*if running just from herbs;
data herbx; set herb5;
	*dropping all data from 1999. useless sfa data;
	if year = 1999 then delete;
	if (plot = 1242 | plot = 1244 |plot = 1245 |plot = 1246 |plot = 1247) then delete;
	*splitting to into pre/post fire variable 'prpo';
	if year < 2011  then prpo = 1;
   	if year >= 2011 then prpo = 2;
	* 12 'missing' years that come from postburn severity metric, all come from 2011;
	if year = '.' 	then year = 2011;
run;

/* *if running from alld;
data herbx; set alld;
	if (subp = 'herb'); 
run;  *N=12544;
*/

data herb1; set herbx;
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo; 
	if year=2011 then delete; *herbs were not measured in 2011;
run;

proc sort data=herb1; by plot sspp year bcat covm coun quad soileb elev slope aspect hydrn prpo; run; *N=12548;

*numeric dataset;   data dat1n; set herb1; keep aspect bcat plot quad coun covm elev hydrn slope soileb year prpo; 
*character dataset; data dat1c; set herb1; keep sspp;			


*proc contents data=dat1n; run;
*proc print    data=dat1n; run;
*proc contents data=dat1c; run;
*proc print    data=dat1c; run;

proc iml;

*reading in data (o=original);
use dat1n; read all into mat1on;			*print mat1on;	 *12 columns, 12548 rows;

nquads=10*56; *number of quadrats (10/plot, 56 plots);
nsp=315;	  *number of species;
spid='warn';  *in case a species is missing an id;
										
mat1n=j(nquads,nsp,9999); 				*print matcount; *315 columns, 560 rows;
nobs=nrow(mat1n);						*print nobs; 	 *560;

datids=mat1on;
do i=1 to nquads;
	datids[i,3]=10*(datids[i,1]-1)*datids[i,2];
end;

quit;

proc iml;

use dat1c; read all into mat1oc;			*print mat1on;	 *12 columns, 12548 rows;

do i=1 to nobs;
*assigning a numeric id to each species;
if (dat1c[i,1]='ACGR2') then spid=1;
if (dat1c[i,1]='AGFA2') then spid=2;
if (dat1c[i,1]='AGHYx') then spid=3;
if (dat1c[i,1]='AIEL4') then spid=4;
*etc....fill out for all species;
	uniquad=10*(mat1on[i,1]-1)+ mat1on[i,2];	*unique quadrat id;
	mat1n[uniquad,spid]=mat1on[1,3];
end;

mat3=datids//mat1n; *sticks the 2 together;
matpa=mat3;

do i=1 to nquads;
	do j=1 to nsp;
		colno=j+3;
		matpa[i,colno]=99;
			if (mat3[i,colno]=0) then matpa[i,colno]=0;
			if (mat3[i,colno]>0) then matpa[i,colno]=1;
	end;
end;
quit;
