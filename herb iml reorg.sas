data dat1n; set herb1; keep aspect bcat plot quad coun covm elev hydrn slope soileb year prpo; *numeric dataset;
data dat1c; set herb1; keep sspp;			*character dataset;

proc iml;

nquads=10*56; *number of quadrats;
nsp=350;	  *number of species;
matcount=j(nquads,nsp,9999); spid='warn'; *;
nobs=nrow(mat1n);


do i=1 to nobs; *calculates the unique quad/row';
	uniquad=10*(dat1n[i,1]-1)+dat1n[i,3];
		if (dat1c[i,1]='disp') then spid=1;
		if (dat1c[i,1]='scsc') then spid=2;
		*etc....fill out for all species;
			matcount[uniquad,spid]=dat1n[1,3];
		end;
			datids=dat1n;
			do i=1 to nquads;
			datids[i,3]=10*(datids[i,1]-1)*datids[i,2];
			end;
			mat3=datids//matcount; *sticks the 2 together;
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
