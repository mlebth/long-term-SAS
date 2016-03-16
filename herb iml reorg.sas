data herbx; set alld;
	if (subp = 'herb'); 
run;  *N=12544;
data herb1; set herbx;
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo; 
run;
proc sort data=herb1; by plot sspp year bcat covm coun quad soileb elev slope aspect hydrn prpo; run;

*numeric dataset;   data dat1n; set herb1; keep aspect bcat plot quad coun covm elev hydrn slope soileb year prpo; 
*character dataset; data dat1c; set herb1; keep sspp;			

*proc contents data=dat1n; run;
*proc contents data=dat1c; run;

proc iml;

nquads=10*56; *number of quadrats (10/plot, 56 plots);
nsp=315;	  *number of species;
spid='warn';  *in case a species is missing an id;

mat1n=j(nquads,nsp,9999); 		*print matcount; *315 columns, 560 rows;
nobs=nrow(mat1n);				*print nobs; *560;

do i=1 to nobs; *calculates the unique quad/row;
	uniquad=10*(dat1n[i,1]-1)+dat1n[i,3];
if (dat1c[i,1]='ACGR2') then spid=1;
if (dat1c[i,1]='AGFA2') then spid=2;
if (dat1c[i,1]='AGHYx') then spid=3;
if (dat1c[i,1]='AIEL4') then spid=4;
	*etc....fill out for all species;
	mat1n[uniquad,spid]=dat1n[1,3];
end;

datids=dat1n;
do i=1 to nquads;
	datids[i,3]=10*(datids[i,1]-1)*datids[i,2];
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
