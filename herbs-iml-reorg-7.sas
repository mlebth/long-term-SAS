*this file organizes herbs in 2 ways:
	structure 1 (herbmerge1) pools pre-fire data and pools post-fire data (can compare before/after)
	structure 2 (herbmerge2) pools pre-fire data but not post-fire data (can compare before with 2011-2015);

*creating a set of herbs;
data herb1; set herbx;
	*removing blank lines;
	if sspp='     ' then delete;
	*removing 1999--data are of extremely poor quality;
	if year=1999 	then delete;
	*type 1--it is a plant. type 2--zero plants were found in year 2005-plot 1203;
  	type = 1;     		  			  	 
 	if (sspp = 'XXXXx') then type = 2;   
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo type; 
run; *n=12,544;
proc sort data=herb1; by plot sspp quad year bcat covm coun soileb elev slope aspect hydrn prpo type; run; 
*proc print data=herb1 (firstobs=1 obs=20); title 'herb1'; run;

*new datasets--each species is now a variable with count as the value;
data holdANGL2; set herb1; if sspp='ANGL2'; nANGL2=coun; proc sort data=holdANGL2; by plot bcat year;
data holdKRVIx; set herb1; if sspp='KRVIx'; nKRVIx=coun; proc sort data=holdKRVIx; by plot bcat year;
data holdCOERx; set herb1; if sspp='COERx'; nCOERx=coun; proc sort data=holdCOERx; by plot bcat year;
data holdPABR2; set herb1; if sspp='PABR2'; nPABR2=coun; proc sort data=holdPABR2; by plot bcat year;
data holdWAMAx; set herb1; if sspp='WAMAx'; nWAMAx=coun; proc sort data=holdWAMAx; by plot bcat year;
data holdPASEC; set herb1; if sspp='PASEC'; nPASEC=coun; proc sort data=holdPASEC; by plot bcat year;
data holdSILIx; set herb1; if sspp='SILIx'; nSILIx=coun; proc sort data=holdSILIx; by plot bcat year;
data holdARPUP; set herb1; if sspp='ARPUP'; nARPUP=coun; proc sort data=holdARPUP; by plot bcat year;
data holdDITE2; set herb1; if sspp='DITE2'; nDITE2=coun; proc sort data=holdDITE2; by plot bcat year;
data holdSOEL3; set herb1; if sspp='SOEL3'; nSOEL3=coun; proc sort data=holdSOEL3; by plot bcat year;
data holdNUCAx; set herb1; if sspp='NUCAx'; nNUCAx=coun; proc sort data=holdNUCAx; by plot bcat year;
data holdCITE2; set herb1; if sspp='CITE2'; nCITE2=coun; proc sort data=holdCITE2; by plot bcat year;
data holdPHAM4; set herb1; if sspp='PHAM4'; nPHAM4=coun; proc sort data=holdPHAM4; by plot bcat year;
data holdTRUR2; set herb1; if sspp='TRUR2'; nTRUR2=coun; proc sort data=holdTRUR2; by plot bcat year;
data holdPAPE5; set herb1; if sspp='PAPE5'; nPAPE5=coun; proc sort data=holdPAPE5; by plot bcat year;
data holdCRGL2; set herb1; if sspp='CRGL2'; nCRGL2=coun; proc sort data=holdCRGL2; by plot bcat year;
data holdPAHI1; set herb1; if sspp='PAHI1'; nPAHI1=coun; proc sort data=holdPAHI1; by plot bcat year;
data holdCHTE1; set herb1; if sspp='CHTE1'; nCHTE1=coun; proc sort data=holdCHTE1; by plot bcat year;
data holdPSOB3; set herb1; if sspp='PSOB3'; nPSOB3=coun; proc sort data=holdPSOB3; by plot bcat year;
data holdSPCO1; set herb1; if sspp='SPCO1'; nSPCO1=coun; proc sort data=holdSPCO1; by plot bcat year;
data holdFRFLx; set herb1; if sspp='FRFLx'; nFRFLx=coun; proc sort data=holdFRFLx; by plot bcat year;
data holdNELU2; set herb1; if sspp='NELU2'; nNELU2=coun; proc sort data=holdNELU2; by plot bcat year;
data holdDICO6; set herb1; if sspp='DICO6'; nDICO6=coun; proc sort data=holdDICO6; by plot bcat year;
data holdJUBRx; set herb1; if sspp='JUBRx'; nJUBRx=coun; proc sort data=holdJUBRx; by plot bcat year;
data holdCOBA2; set herb1; if sspp='COBA2'; nCOBA2=coun; proc sort data=holdCOBA2; by plot bcat year;
data holdDIOLS; set herb1; if sspp='DIOLS'; nDIOLS=coun; proc sort data=holdDIOLS; by plot bcat year;
data holdJUTEx; set herb1; if sspp='JUTEx'; nJUTEx=coun; proc sort data=holdJUTEx; by plot bcat year;
data holdDICA3; set herb1; if sspp='DICA3'; nDICA3=coun; proc sort data=holdDICA3; by plot bcat year;
data holdERSEx; set herb1; if sspp='ERSEx'; nERSEx=coun; proc sort data=holdERSEx; by plot bcat year;
data holdGYAMx; set herb1; if sspp='GYAMx'; nGYAMx=coun; proc sort data=holdGYAMx; by plot bcat year;
data holdSTPI3; set herb1; if sspp='STPI3'; nSTPI3=coun; proc sort data=holdSTPI3; by plot bcat year;
data holdLEHI2; set herb1; if sspp='LEHI2'; nLEHI2=coun; proc sort data=holdLEHI2; by plot bcat year;
data holdCRSA4; set herb1; if sspp='CRSA4'; nCRSA4=coun; proc sort data=holdCRSA4; by plot bcat year;
data holdERINx; set herb1; if sspp='ERINx'; nERINx=coun; proc sort data=holdERINx; by plot bcat year;
data holdANVI2; set herb1; if sspp='ANVI2'; nANVI2=coun; proc sort data=holdANVI2; by plot bcat year;
data holdHERO2; set herb1; if sspp='HERO2'; nHERO2=coun; proc sort data=holdHERO2; by plot bcat year;
data holdCAMU4; set herb1; if sspp='CAMU4'; nCAMU4=coun; proc sort data=holdCAMU4; by plot bcat year;
data holdTRBI2; set herb1; if sspp='TRBI2'; nTRBI2=coun; proc sort data=holdTRBI2; by plot bcat year;
data holdDIACx; set herb1; if sspp='DIACx'; nDIACx=coun; proc sort data=holdDIACx; by plot bcat year;
data holdTRPE4; set herb1; if sspp='TRPE4'; nTRPE4=coun; proc sort data=holdTRPE4; by plot bcat year;
data holdPTAQx; set herb1; if sspp='PTAQx'; nPTAQx=coun; proc sort data=holdPTAQx; by plot bcat year;
data holdDIRAx; set herb1; if sspp='DIRAx'; nDIRAx=coun; proc sort data=holdDIRAx; by plot bcat year;
data holdLERE2; set herb1; if sspp='LERE2'; nLERE2=coun; proc sort data=holdLERE2; by plot bcat year;
data holdPHCI4; set herb1; if sspp='PHCI4'; nPHCI4=coun; proc sort data=holdPHCI4; by plot bcat year;
data holdSPCLx; set herb1; if sspp='SPCLx'; nSPCLx=coun; proc sort data=holdSPCLx; by plot bcat year;
data holdFIPUx; set herb1; if sspp='FIPUx'; nFIPUx=coun; proc sort data=holdFIPUx; by plot bcat year;
data holdCALE6; set herb1; if sspp='CALE6'; nCALE6=coun; proc sort data=holdCALE6; by plot bcat year;
data holdHYDRx; set herb1; if sspp='HYDRx'; nHYDRx=coun; proc sort data=holdHYDRx; by plot bcat year;
data holdCRMO6; set herb1; if sspp='CRMO6'; nCRMO6=coun; proc sort data=holdCRMO6; by plot bcat year;
data holdCYHYx; set herb1; if sspp='CYHYx'; nCYHYx=coun; proc sort data=holdCYHYx; by plot bcat year;
data holdSONU2; set herb1; if sspp='SONU2'; nSONU2=coun; proc sort data=holdSONU2; by plot bcat year;
data holdNUTEx; set herb1; if sspp='NUTEx'; nNUTEx=coun; proc sort data=holdNUTEx; by plot bcat year;
data holdHYGL2; set herb1; if sspp='HYGL2'; nHYGL2=coun; proc sort data=holdHYGL2; by plot bcat year;
data holdTRRA5; set herb1; if sspp='TRRA5'; nTRRA5=coun; proc sort data=holdTRRA5; by plot bcat year;
data holdJUMA4; set herb1; if sspp='JUMA4'; nJUMA4=coun; proc sort data=holdJUMA4; by plot bcat year;
data holdACGR2; set herb1; if sspp='ACGR2'; nACGR2=coun; proc sort data=holdACGR2; by plot bcat year;
data holdPASE5; set herb1; if sspp='PASE5'; nPASE5=coun; proc sort data=holdPASE5; by plot bcat year;
data holdCYCR6; set herb1; if sspp='CYCR6'; nCYCR6=coun; proc sort data=holdCYCR6; by plot bcat year;
data holdEUCO7; set herb1; if sspp='EUCO7'; nEUCO7=coun; proc sort data=holdEUCO7; by plot bcat year;
data holdCYLU2; set herb1; if sspp='CYLU2'; nCYLU2=coun; proc sort data=holdCYLU2; by plot bcat year;
data holdARLO1; set herb1; if sspp='ARLO1'; nARLO1=coun; proc sort data=holdARLO1; by plot bcat year;
data holdBUCA2; set herb1; if sspp='BUCA2'; nBUCA2=coun; proc sort data=holdBUCA2; by plot bcat year;
data holdEUSEx; set herb1; if sspp='EUSEx'; nEUSEx=coun; proc sort data=holdEUSEx; by plot bcat year;
data holdEUCO1; set herb1; if sspp='EUCO1'; nEUCO1=coun; proc sort data=holdEUCO1; by plot bcat year;
data holdGAREx; set herb1; if sspp='GAREx'; nGAREx=coun; proc sort data=holdGAREx; by plot bcat year;
data holdCEVI2; set herb1; if sspp='CEVI2'; nCEVI2=coun; proc sort data=holdCEVI2; by plot bcat year;
data holdDISC3; set herb1; if sspp='DISC3'; nDISC3=coun; proc sort data=holdDISC3; by plot bcat year;
data holdVUOCx; set herb1; if sspp='VUOCx'; nVUOCx=coun; proc sort data=holdVUOCx; by plot bcat year;
data holdBUCIx; set herb1; if sspp='BUCIx'; nBUCIx=coun; proc sort data=holdBUCIx; by plot bcat year;
data holdCYEC2; set herb1; if sspp='CYEC2'; nCYEC2=coun; proc sort data=holdCYEC2; by plot bcat year;
data holdAGHYx; set herb1; if sspp='AGHYx'; nAGHYx=coun; proc sort data=holdAGHYx; by plot bcat year;
data holdDIOVx; set herb1; if sspp='DIOVx'; nDIOVx=coun; proc sort data=holdDIOVx; by plot bcat year;
data holdHEGEx; set herb1; if sspp='HEGEx'; nHEGEx=coun; proc sort data=holdHEGEx; by plot bcat year;
data holdDIAC2; set herb1; if sspp='DIAC2'; nDIAC2=coun; proc sort data=holdDIAC2; by plot bcat year;
data holdGAPE2; set herb1; if sspp='GAPE2'; nGAPE2=coun; proc sort data=holdGAPE2; by plot bcat year;
data holdOXDI2; set herb1; if sspp='OXDI2'; nOXDI2=coun; proc sort data=holdOXDI2; by plot bcat year;
data holdCRDI1; set herb1; if sspp='CRDI1'; nCRDI1=coun; proc sort data=holdCRDI1; by plot bcat year;
data holdDIVI7; set herb1; if sspp='DIVI7'; nDIVI7=coun; proc sort data=holdDIVI7; by plot bcat year;
data holdCHPI8; set herb1; if sspp='CHPI8'; nCHPI8=coun; proc sort data=holdCHPI8; by plot bcat year;
data holdRHHAx; set herb1; if sspp='RHHAx'; nRHHAx=coun; proc sort data=holdRHHAx; by plot bcat year;
data holdGAAN1; set herb1; if sspp='GAAN1'; nGAAN1=coun; proc sort data=holdGAAN1; by plot bcat year;
data holdARDE3; set herb1; if sspp='ARDE3'; nARDE3=coun; proc sort data=holdARDE3; by plot bcat year;
data holdSCSCx; set herb1; if sspp='SCSCx'; nSCSCx=coun; proc sort data=holdSCSCx; by plot bcat year;
data holdLEMU3; set herb1; if sspp='LEMU3'; nLEMU3=coun; proc sort data=holdLEMU3; by plot bcat year;
data holdSEARx; set herb1; if sspp='SEARx'; nSEARx=coun; proc sort data=holdSEARx; by plot bcat year;
data holdPAPL3; set herb1; if sspp='PAPL3'; nPAPL3=coun; proc sort data=holdPAPL3; by plot bcat year;
data holdGAAR1; set herb1; if sspp='GAAR1'; nGAAR1=coun; proc sort data=holdGAAR1; by plot bcat year;
data holdDIAN4; set herb1; if sspp='DIAN4'; nDIAN4=coun; proc sort data=holdDIAN4; by plot bcat year;
data holdERSPx; set herb1; if sspp='ERSPx'; nERSPx=coun; proc sort data=holdERSPx; by plot bcat year;
data holdCYRE5; set herb1; if sspp='CYRE5'; nCYRE5=coun; proc sort data=holdCYRE5; by plot bcat year;
data holdCAMI8; set herb1; if sspp='CAMI8'; nCAMI8=coun; proc sort data=holdCAMI8; by plot bcat year;
data holdSCCIx; set herb1; if sspp='SCCIx'; nSCCIx=coun; proc sort data=holdSCCIx; by plot bcat year;
data holdLEDUx; set herb1; if sspp='LEDUx'; nLEDUx=coun; proc sort data=holdLEDUx; by plot bcat year;
data holdCOCA5; set herb1; if sspp='COCA5'; nCOCA5=coun; proc sort data=holdCOCA5; by plot bcat year;
data holdLETEx; set herb1; if sspp='LETEx'; nLETEx=coun; proc sort data=holdLETEx; by plot bcat year;
data holdPOPR4; set herb1; if sspp='POPR4'; nPOPR4=coun; proc sort data=holdPOPR4; by plot bcat year;
data holdDISP2; set herb1; if sspp='DISP2'; nDISP2=coun; proc sort data=holdDISP2; by plot bcat year;
data holdHELA5; set herb1; if sspp='HELA5'; nHELA5=coun; proc sort data=holdHELA5; by plot bcat year;
data holdDIOLx; set herb1; if sspp='DIOLx'; nDIOLx=coun; proc sort data=holdDIOLx; by plot bcat year;
data holdDILI2; set herb1; if sspp='DILI2'; nDILI2=coun; proc sort data=holdDILI2; by plot bcat year;
run;

*creating dataset with species as variables, each 2 ways: n (count) and pa (presence/absence);
proc sort data=herb1; by plot bcat year; run;
*merging all species datasets;
data herb2; merge holdANGL2	holdKRVIx	holdCOERx	holdPABR2	holdWAMAx	holdPASEC	holdSILIx	
				  holdARPUP	holdDITE2	holdSOEL3	holdNUCAx	holdCITE2	holdPHAM4	holdTRUR2	
				  holdPAPE5	holdCRGL2	holdPAHI1	holdCHTE1	holdPSOB3	holdSPCO1	holdFRFLx	
				  holdNELU2	holdDICO6	holdJUBRx	holdCOBA2	holdDIOLS	holdJUTEx	holdDICA3	
				  holdERSEx	holdGYAMx	holdSTPI3	holdLEHI2	holdCRSA4	holdERINx	holdANVI2	
				  holdHERO2	holdCAMU4	holdTRBI2	holdDIACx	holdTRPE4	holdPTAQx	holdDIRAx	
				  holdLERE2	holdPHCI4	holdSPCLx	holdFIPUx	holdCALE6	holdHYDRx	holdCRMO6	
				  holdCYHYx	holdSONU2	holdNUTEx	holdHYGL2	holdTRRA5	holdJUMA4	holdACGR2	
				  holdPASE5	holdCYCR6	holdEUCO7	holdCYLU2	holdARLO1	holdBUCA2	holdEUSEx	
				  holdEUCO1	holdGAREx	holdCEVI2	holdDISC3	holdVUOCx	holdBUCIx	holdCYEC2	
				  holdAGHYx	holdDIOVx	holdHEGEx	holdDIAC2	holdGAPE2	holdOXDI2	holdCRDI1	
				  holdDIVI7	holdCHPI8	holdRHHAx	holdGAAN1	holdARDE3	holdSCSCx	holdLEMU3	
				  holdSEARx	holdPAPL3	holdGAAR1	holdDIAN4	holdERSPx	holdCYRE5	holdCAMI8	
				  holdSCCIx	holdLEDUx	holdCOCA5	holdLETEx	holdPOPR4	holdDISP2	holdHELA5	
				  holdDIOLx	holdDILI2 	herb1; 
by plot bcat year;  
drop sspp coun;  * dropping sspp & coun -- this information is in the species variables now;
run; * N = 12544;
*proc print data=herb2 (firstobs=1 obs=20) ; run;
*proc contents data=herb2; title 'herb2'; run; 

* Contents:
#   Variable    Type    Len    	Format     	Informat
1 	plot 		Num 	8 		BEST12. 	BEST32. 
11 	prpo 		Num 	8     
2 	quad 		Num 	8 		BEST12. 	BEST32. 
7 	slope 		Num 	8 		BEST12. 	BEST32. 
5 	soileb		Num 	8 		BEST12.		BEST32. 
12 	type 		Num 	8     
3 	year 		Num 	8 		BEST12. 	BEST32. 
9 	aspect 		Num 	8     
10 	bcat 		Num 	8     
4 	covm 		Num 	8 		BEST12. 	BEST32. 
6 	elev 		Num 	8		BEST12. 	BEST32. 
8 	hydrn 		Num 	8     
+all species variables
;

*mean counts and canopy cover;
*dropping out quad so counts are per plot-year, not per quad-year;
proc sort data=herb2; by plot year bcat covm soileb elev slope aspect hydrn prpo type;
proc means data=herb2 mean noprint; by plot year bcat covm soileb elev slope aspect hydrn prpo type;
  var covm 	nANGL2	nKRVIx	
	nCOERx	nPABR2	nWAMAx	nPASEC	nSILIx	nARPUP	nDITE2	nSOEL3	nNUCAx	nCITE2	nPHAM4	nTRUR2	
	nPAPE5	nCRGL2	nPAHI1	nCHTE1	nPSOB3	nSPCO1	nFRFLx	nNELU2	nDICO6	nJUBRx	nCOBA2	nDIOLS	
	nJUTEx	nDICA3	nERSEx	nGYAMx	nSTPI3	nLEHI2	nCRSA4	nERINx	nANVI2	nHERO2	nCAMU4	nTRBI2	
	nDIACx	nTRPE4	nPTAQx	nDIRAx	nLERE2	nPHCI4	nSPCLx	nFIPUx	nCALE6	nHYDRx	nCRMO6	nCYHYx	
	nSONU2	nNUTEx	nHYGL2	nTRRA5	nJUMA4	nACGR2	nPASE5	nCYCR6	nEUCO7	nCYLU2	nARLO1	nBUCA2	
	nEUSEx	nEUCO1	nGAREx	nCEVI2	nDISC3	nVUOCx	nBUCIx	nCYEC2	nAGHYx	nDIOVx	nHEGEx	nDIAC2	
	nGAPE2	nOXDI2	nCRDI1	nDIVI7	nCHPI8	nRHHAx	nGAAN1	nARDE3	nSCSCx	nLEMU3	nSEARx	nPAPL3	
	nGAAR1	nDIAN4	nERSPx	nCYRE5	nCAMI8	nSCCIx	nLEDUx	nCOCA5	nLETEx	nPOPR4	nDISP2	nHELA5	
	nDIOLx	nDILI2;
  output out=herb3 mean = mcov	mANGL2	mKRVIx	mCOERx	mPABR2	mWAMAx	mPASEC		
	mARPUP	mDITE2	mSOEL3	mNUCAx	mCITE2	mPHAM4	mTRUR2	mPAPE5	mCRGL2	mPAHI1	mCHTE1	mPSOB3	
	mSPCO1	mFRFLx	mNELU2	mDICO6	mJUBRx	mCOBA2	mDIOLS	mJUTEx	mDICA3	mERSEx	mGYAMx	mSTPI3	
	mLEHI2	mCRSA4	mERINx	mANVI2	mHERO2	mCAMU4	mTRBI2	mDIACx	mTRPE4	mPTAQx	mDIRAx	mLERE2	
	mPHCI4	mSPCLx	mFIPUx	mCALE6	mHYDRx	mCRMO6	mCYHYx	mSONU2	mNUTEx	mHYGL2	mTRRA5	mJUMA4	
	mACGR2	mPASE5	mCYCR6	mEUCO7	mCYLU2	mARLO1	mBUCA2	mEUSEx	mEUCO1	mGAREx	mCEVI2	mDISC3	
	mVUOCx	mBUCIx	mCYEC2	mAGHYx	mDIOVx	mHEGEx	mDIAC2	mGAPE2	mOXDI2	mCRDI1	mDIVI7	mCHPI8	
	mRHHAx	mGAAN1	mARDE3	mSCSCx	mLEMU3	mSEARx	mPAPL3	mGAAR1	mDIAN4	mERSPx	mCYRE5	mCAMI8	
	mSCCIx	mLEDUx	mCOCA5	mLETEx	mPOPR4	mDISP2	mHELA5	mDIOLx	mDILI2	mSILIx;
run;
data herb4; set herb3; drop _FREQ_ _TYPE_ covm; *N=243; run;
*proc print data=herb4 (firstobs=100 obs=110); title 'herb4'; run; 
*proc contents data=herb4; run;

* Contents:
#   Variable    Type    Len    	Format     	Informat
1 	plot 		Num 	8 		BEST12. 	BEST32. 
9 	prpo 		Num 	8     
6 	slope 		Num 	8 		BEST12. 	BEST32. 
4 	soileb		Num 	8 		BEST12.		BEST32. 
10 	type 		Num 	8     
2 	year 		Num 	8 		BEST12. 	BEST32. 
7 	aspect 		Num 	8     
3 	bcat 		Num 	8     
11 	mcov 		Num 	8 		BEST12. 	BEST32. 
5 	elev 		Num 	8		BEST12. 	BEST32. 
8 	hydrn 		Num 	8     
+all species variables
;

proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use herb4; read all into mat1;
* print (mat1[1:20,]); 

nrecords = nrow(mat1);   *print nrecords; *N = 10,143;

mat2 = j(nrecords,214,.); * create mat2 has 10,143 rows, 24 columns, each element=0;
do i = 1 to nrecords;    * record by record loop;
  do j = 1 to nyrs;      * yr by yr loop;
    if (mat1[i,3] = inputyrs[j]) then mat2[i,1] = j;  * pref in col 1;
  end;                   * end yr by yr loop;
end;                     * end yr by yr loop;
* print (mat2[1:20,]);

* variables the same each year: plot, slope, soileb, aspect, bcat, elev, hydrn,
  variables that change each year: _FREQ_, mcov, mcoun, year, mspecies;

*order of variables in mat1:					
1 plot, 2 year, 3 bcat, 4 soileb, 5 elev, 6 slope, 7 aspect, 8 hydrn, 9 prpo, 10 type, 11 mcov;   	 

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,2];   * year1;
  mat2[i,5] = mat1[i,1];   * plot;
  mat2[i,6] = mat1[i,3];   * bcat;
  mat2[i,7] = mat1[i,7];   * aspect;
  mat2[i,8] = mat1[i,8];   * hydrn;
  mat2[i,9] = mat1[i,4];   * soileb;
  mat2[i,10] = mat1[i,5];  * elev;
  mat2[i,11] = mat1[i,6];  * slope;
  mat2[i,12] = mat1[i,11]; * mcov1;
  mat2[i,14]=mat1[i,12]; *mANGL2;
  mat2[i,16]=mat1[i,13]; *mKRVIx;
  mat2[i,18]=mat1[i,14]; *mCOERx;
  mat2[i,20]=mat1[i,15]; *mPABR2;
  mat2[i,22]=mat1[i,16]; *mWAMAx;
  mat2[i,24]=mat1[i,17]; *mPASEC;
  mat2[i,26]=mat1[i,18]; *mARPUP;
  mat2[i,28]=mat1[i,19]; *mDITE2;
  mat2[i,30]=mat1[i,20]; *mSOEL3;
  mat2[i,32]=mat1[i,21]; *mNUCAx;
  mat2[i,34]=mat1[i,22]; *mCITE2;
  mat2[i,36]=mat1[i,23]; *mPHAM4;
  mat2[i,38]=mat1[i,24]; *mTRUR2;
  mat2[i,40]=mat1[i,25]; *mPAPE5;
  mat2[i,42]=mat1[i,26]; *mCRGL2;
  mat2[i,44]=mat1[i,27]; *mPAHI1;
  mat2[i,46]=mat1[i,28]; *mCHTE1;
  mat2[i,48]=mat1[i,29]; *mPSOB3;
  mat2[i,50]=mat1[i,30]; *mSPCO1;
  mat2[i,52]=mat1[i,31]; *mFRFLx;
  mat2[i,54]=mat1[i,32]; *mNELU2;
  mat2[i,56]=mat1[i,33]; *mDICO6;
  mat2[i,58]=mat1[i,34]; *mJUBRx;
  mat2[i,60]=mat1[i,35]; *mCOBA2;
  mat2[i,62]=mat1[i,36]; *mDIOLS;
  mat2[i,64]=mat1[i,37]; *mJUTEx;
  mat2[i,66]=mat1[i,38]; *mDICA3;
  mat2[i,68]=mat1[i,39]; *mERSEx;
  mat2[i,70]=mat1[i,40]; *mGYAMx;
  mat2[i,72]=mat1[i,41]; *mSTPI3;
  mat2[i,74]=mat1[i,42]; *mLEHI2;
  mat2[i,76]=mat1[i,43]; *mCRSA4;
  mat2[i,78]=mat1[i,44]; *mERINx;
  mat2[i,80]=mat1[i,45]; *mANVI2;
  mat2[i,82]=mat1[i,46]; *mHERO2;
  mat2[i,84]=mat1[i,47]; *mCAMU4;
  mat2[i,86]=mat1[i,48]; *mTRBI2;
  mat2[i,88]=mat1[i,49]; *mDIACx;
  mat2[i,90]=mat1[i,50]; *mTRPE4;
  mat2[i,92]=mat1[i,51]; *mPTAQx;
  mat2[i,94]=mat1[i,52]; *mDIRAx;
  mat2[i,96]=mat1[i,53]; *mLERE2;
  mat2[i,98]=mat1[i,54]; *mPHCI4;
  mat2[i,100]=mat1[i,55]; *mSPCLx;
  mat2[i,102]=mat1[i,56]; *mFIPUx;
  mat2[i,104]=mat1[i,57]; *mCALE6;
  mat2[i,106]=mat1[i,58]; *mHYDRx;
  mat2[i,108]=mat1[i,59]; *mCRMO6;
  mat2[i,110]=mat1[i,60]; *mCYHYx;
  mat2[i,112]=mat1[i,61]; *mSONU2;
  mat2[i,114]=mat1[i,62]; *mNUTEx;
  mat2[i,116]=mat1[i,63]; *mHYGL2;
  mat2[i,118]=mat1[i,64]; *mTRRA5;
  mat2[i,120]=mat1[i,65]; *mJUMA4;
  mat2[i,122]=mat1[i,66]; *mACGR2;
  mat2[i,124]=mat1[i,67]; *mPASE5;
  mat2[i,126]=mat1[i,68]; *mCYCR6;
  mat2[i,128]=mat1[i,69]; *mEUCO7;
  mat2[i,130]=mat1[i,70]; *mCYLU2;
  mat2[i,132]=mat1[i,71]; *mARLO1;
  mat2[i,134]=mat1[i,72]; *mBUCA2;
  mat2[i,136]=mat1[i,73]; *mEUSEx;
  mat2[i,138]=mat1[i,74]; *mEUCO1;
  mat2[i,140]=mat1[i,75]; *mGAREx;
  mat2[i,142]=mat1[i,76]; *mCEVI2;
  mat2[i,144]=mat1[i,77]; *mDISC3;
  mat2[i,146]=mat1[i,78]; *mVUOCx;
  mat2[i,148]=mat1[i,79]; *mBUCIx;
  mat2[i,150]=mat1[i,80]; *mCYEC2;
  mat2[i,152]=mat1[i,81]; *mAGHYx;
  mat2[i,154]=mat1[i,82]; *mDIOVx;
  mat2[i,156]=mat1[i,83]; *mHEGEx;
  mat2[i,158]=mat1[i,84]; *mDIAC2;
  mat2[i,160]=mat1[i,85]; *mGAPE2;
  mat2[i,162]=mat1[i,86]; *mOXDI2;
  mat2[i,164]=mat1[i,87]; *mCRDI1;
  mat2[i,166]=mat1[i,88]; *mDIVI7;
  mat2[i,168]=mat1[i,89]; *mCHPI8;
  mat2[i,170]=mat1[i,90]; *mRHHAx;
  mat2[i,172]=mat1[i,91]; *mGAAN1;
  mat2[i,174]=mat1[i,92]; *mARDE3;
  mat2[i,176]=mat1[i,93]; *mSCSCx;
  mat2[i,178]=mat1[i,94]; *mLEMU3;
  mat2[i,180]=mat1[i,95]; *mSEARx;
  mat2[i,182]=mat1[i,96]; *mPAPL3;
  mat2[i,184]=mat1[i,97]; *mGAAR1;
  mat2[i,186]=mat1[i,98]; *mDIAN4;
  mat2[i,188]=mat1[i,99]; *mERSPx;
  mat2[i,190]=mat1[i,100]; *mCYRE5;
  mat2[i,192]=mat1[i,101]; *mCAMI8;
  mat2[i,194]=mat1[i,102]; *mSCCIx;
  mat2[i,196]=mat1[i,103]; *mLEDUx;
  mat2[i,198]=mat1[i,104]; *mCOCA5;
  mat2[i,200]=mat1[i,105]; *mLETEx;
  mat2[i,202]=mat1[i,106]; *mPOPR4;
  mat2[i,204]=mat1[i,107]; *mDISP2;
  mat2[i,206]=mat1[i,108]; *mHELA5;
  mat2[i,208]=mat1[i,109]; *mDIOLx;
  mat2[i,210]=mat1[i,110]; *mDILI2;
  mat2[i,212]=mat1[i,111]; *mSILIx;
  mat2[i,214]=mat1[i,9]; *prpo;
end;
* print (mat2[1:20,]);

do i = 1 to nrecords;
  plot = mat2[i,5]; time2 = mat2[i,2];
  do j = 1 to nrecords;
    if (mat2[j,5] = plot & mat2[j,1] = time2) then do;
	  *print i,j;
  	  mat2[i,4]  = mat2[j,3];  * year2;
	  mat2[i,13] = mat2[j,12]; * covm2;
      mat2[i,15]=mat2[j,14]; *mANGL2;
      mat2[i,17]=mat2[j,16]; *mKRVIx;
      mat2[i,19]=mat2[j,18]; *mCOERx;
      mat2[i,21]=mat2[j,20]; *mPABR2;
      mat2[i,23]=mat2[j,22]; *mWAMAx;
      mat2[i,25]=mat2[j,24]; *mPASEC;
      mat2[i,27]=mat2[j,26]; *mARPUP;
      mat2[i,29]=mat2[j,28]; *mDITE2;
      mat2[i,31]=mat2[j,30]; *mSOEL3;
      mat2[i,33]=mat2[j,32]; *mNUCAx;
      mat2[i,35]=mat2[j,34]; *mCITE2;
      mat2[i,37]=mat2[j,36]; *mPHAM4;
      mat2[i,39]=mat2[j,38]; *mTRUR2;
      mat2[i,41]=mat2[j,40]; *mPAPE5;
      mat2[i,43]=mat2[j,42]; *mCRGL2;
      mat2[i,45]=mat2[j,44]; *mPAHI1;
      mat2[i,47]=mat2[j,46]; *mCHTE1;
      mat2[i,49]=mat2[j,48]; *mPSOB3;
      mat2[i,51]=mat2[j,50]; *mSPCO1;
      mat2[i,53]=mat2[j,52]; *mFRFLx;
      mat2[i,55]=mat2[j,54]; *mNELU2;
      mat2[i,57]=mat2[j,56]; *mDICO6;
      mat2[i,59]=mat2[j,58]; *mJUBRx;
      mat2[i,61]=mat2[j,60]; *mCOBA2;
      mat2[i,63]=mat2[j,62]; *mDIOLS;
      mat2[i,65]=mat2[j,64]; *mJUTEx;
      mat2[i,67]=mat2[j,66]; *mDICA3;
      mat2[i,69]=mat2[j,68]; *mERSEx;
      mat2[i,71]=mat2[j,70]; *mGYAMx;
      mat2[i,73]=mat2[j,72]; *mSTPI3;
      mat2[i,75]=mat2[j,74]; *mLEHI2;
      mat2[i,77]=mat2[j,76]; *mCRSA4;
      mat2[i,79]=mat2[j,78]; *mERINx;
      mat2[i,81]=mat2[j,80]; *mANVI2;
      mat2[i,83]=mat2[j,82]; *mHERO2;
      mat2[i,85]=mat2[j,84]; *mCAMU4;
      mat2[i,87]=mat2[j,86]; *mTRBI2;
      mat2[i,89]=mat2[j,88]; *mDIACx;
      mat2[i,91]=mat2[j,90]; *mTRPE4;
      mat2[i,93]=mat2[j,92]; *mPTAQx;
      mat2[i,95]=mat2[j,94]; *mDIRAx;
      mat2[i,97]=mat2[j,96]; *mLERE2;
      mat2[i,99]=mat2[j,98]; *mPHCI4;
      mat2[i,101]=mat2[j,100]; *mSPCLx;
      mat2[i,103]=mat2[j,102]; *mFIPUx;
      mat2[i,105]=mat2[j,104]; *mCALE6;
      mat2[i,107]=mat2[j,106]; *mHYDRx;
      mat2[i,109]=mat2[j,108]; *mCRMO6;
      mat2[i,111]=mat2[j,110]; *mCYHYx;
      mat2[i,113]=mat2[j,112]; *mSONU2;
      mat2[i,115]=mat2[j,114]; *mNUTEx;
      mat2[i,117]=mat2[j,116]; *mHYGL2;
      mat2[i,119]=mat2[j,118]; *mTRRA5;
      mat2[i,121]=mat2[j,120]; *mJUMA4;
      mat2[i,123]=mat2[j,122]; *mACGR2;
      mat2[i,125]=mat2[j,124]; *mPASE5;
      mat2[i,127]=mat2[j,126]; *mCYCR6;
      mat2[i,129]=mat2[j,128]; *mEUCO7;
      mat2[i,131]=mat2[j,130]; *mCYLU2;
      mat2[i,133]=mat2[j,132]; *mARLO1;
      mat2[i,135]=mat2[j,134]; *mBUCA2;
      mat2[i,137]=mat2[j,136]; *mEUSEx;
      mat2[i,139]=mat2[j,138]; *mEUCO1;
      mat2[i,141]=mat2[j,140]; *mGAREx;
      mat2[i,143]=mat2[j,142]; *mCEVI2;
      mat2[i,145]=mat2[j,144]; *mDISC3;
      mat2[i,147]=mat2[j,146]; *mVUOCx;
      mat2[i,149]=mat2[j,148]; *mBUCIx;
      mat2[i,151]=mat2[j,150]; *mCYEC2;
      mat2[i,153]=mat2[j,152]; *mAGHYx;
      mat2[i,155]=mat2[j,154]; *mDIOVx;
      mat2[i,157]=mat2[j,156]; *mHEGEx;
      mat2[i,159]=mat2[j,158]; *mDIAC2;
      mat2[i,161]=mat2[j,160]; *mGAPE2;
      mat2[i,163]=mat2[j,162]; *mOXDI2;
      mat2[i,165]=mat2[j,164]; *mCRDI1;
      mat2[i,167]=mat2[j,166]; *mDIVI7;
      mat2[i,169]=mat2[j,168]; *mCHPI8;
      mat2[i,171]=mat2[j,170]; *mRHHAx;
      mat2[i,173]=mat2[j,172]; *mGAAN1;
      mat2[i,175]=mat2[j,174]; *mARDE3;
      mat2[i,177]=mat2[j,176]; *mSCSCx;
      mat2[i,179]=mat2[j,178]; *mLEMU3;
      mat2[i,181]=mat2[j,180]; *mSEARx;
      mat2[i,183]=mat2[j,182]; *mPAPL3;
      mat2[i,185]=mat2[j,184]; *mGAAR1;
      mat2[i,187]=mat2[j,186]; *mDIAN4;
      mat2[i,189]=mat2[j,188]; *mERSPx;
      mat2[i,191]=mat2[j,190]; *mCYRE5;
      mat2[i,193]=mat2[j,192]; *mCAMI8;
      mat2[i,195]=mat2[j,194]; *mSCCIx;
      mat2[i,197]=mat2[j,196]; *mLEDUx;
      mat2[i,199]=mat2[j,198]; *mCOCA5;
      mat2[i,201]=mat2[j,200]; *mLETEx;
      mat2[i,203]=mat2[j,202]; *mPOPR4;
      mat2[i,205]=mat2[j,204]; *mDISP2;
      mat2[i,207]=mat2[j,206]; *mHELA5;
      mat2[i,209]=mat2[j,208]; *mDIOLx;
      mat2[i,211]=mat2[j,210]; *mDILI2;
      mat2[i,213]=mat2[j,212]; *mSILIx;
	                                                  end;
  end;  * end j loop;
end;    * end i loop;
* print (mat2[1:20,]);

cnames1 = {	'time1', 'time2', 	'year1', 'year2', 	'plot', 'bcat', 	'aspect', 'hydr', 'soil', 'elev', 
'slope', 	'covm1', 'covm2', 	'ANGL21', 'ANGL22',	'KRVIx1', 'KRVIx2',	'COERx1', 'COERx2',	'PABR21', 
'PABR22',	'WAMAx1', 'WAMAx2',	'PASEC1', 'PASEC2',	'ARPUP1', 'ARPUP2',	'DITE21', 'DITE22',	'SOEL31', 
'SOEL32',	'NUCAx1', 'NUCAx2',	'CITE21', 'CITE22',	'PHAM41', 'PHAM42',	'TRUR21', 'TRUR22',	'PAPE51', 
'PAPE52',	'CRGL21', 'CRGL22',	'PAHI11', 'PAHI12',	'CHTE11', 'CHTE12',	'PSOB31', 'PSOB32',	'SPCO11', 
'SPCO12',	'FRFLx1', 'FRFLx2',	'NELU21', 'NELU22',	'DICO61', 'DICO62',	'JUBRx1', 'JUBRx2',	'COBA21', 
'COBA22',	'DIOLS1', 'DIOLS2',	'JUTEx1', 'JUTEx2',	'DICA31', 'DICA32',	'ERSEx1', 'ERSEx2',	'GYAMx1', 
'GYAMx2',	'STPI31', 'STPI32',	'LEHI21', 'LEHI22',	'CRSA41', 'CRSA42',	'ERINx1', 'ERINx2',	'ANVI21', 
'ANVI22',	'HERO21', 'HERO22',	'CAMU41', 'CAMU42',	'TRBI21', 'TRBI22',	'DIACx1', 'DIACx2',	'TRPE41', 
'TRPE42',	'PTAQx1', 'PTAQx2',	'DIRAx1', 'DIRAx2',	'LERE21', 'LERE22',	'PHCI41', 'PHCI42',	'SPCLx1', 
'SPCLx2',	'FIPUx1', 'FIPUx2',	'CALE61', 'CALE62',	'HYDRx1', 'HYDRx2',	'CRMO61', 'CRMO62',	'CYHYx1', 
'CYHYx2',	'SONU21', 'SONU22',	'NUTEx1', 'NUTEx2',	'HYGL21', 'HYGL22',	'TRRA51', 'TRRA52',	'JUMA41', 
'JUMA42',	'ACGR21', 'ACGR22',	'PASE51', 'PASE52',	'CYCR61', 'CYCR62',	'EUCO71', 'EUCO72',	'CYLU21', 
'CYLU22',	'ARLO11', 'ARLO12',	'BUCA21', 'BUCA22',	'EUSEx1', 'EUSEx2',	'EUCO11', 'EUCO12',	'GAREx1', 
'GAREx2',	'CEVI21', 'CEVI22',	'DISC31', 'DISC32',	'VUOCx1', 'VUOCx2',	'BUCIx1', 'BUCIx2',	'CYEC21', 
'CYEC22',	'AGHYx1', 'AGHYx2',	'DIOVx1', 'DIOVx2',	'HEGEx1', 'HEGEx2',	'DIAC21', 'DIAC22',	'GAPE21', 
'GAPE22',	'OXDI21', 'OXDI22',	'CRDI11', 'CRDI12',	'DIVI71', 'DIVI72',	'CHPI81', 'CHPI82',	'RHHAx1', 
'RHHAx2',	'GAAN11', 'GAAN12',	'ARDE31', 'ARDE32',	'SCSCx1', 'SCSCx2',	'LEMU31', 'LEMU32',	'SEARx1', 
'SEARx2',	'PAPL31', 'PAPL32',	'GAAR11', 'GAAR12',	'DIAN41', 'DIAN42',	'ERSPx1', 'ERSPx2',	'CYRE51', 
'CYRE52',	'CAMI81', 'CAMI82',	'SCCIx1', 'SCCIx2',	'LEDUx1', 'LEDUx2',	'COCA51', 'COCA52',	'LETEx1', 
'LETEx2',	'POPR41', 'POPR42',	'DISP21', 'DISP22',	'HELA51', 'HELA52',	'DIOLx1', 'DIOLx2',	'DILI21', 
'DILI22',	'SILIx1', 'SILIx2', 'prpo'};
create herbpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

/* 
proc print data=herbpairs (firstobs=1 obs=20); title 'herbpairs'; run; *N=243;
proc freq data=herbpairs; tables soil; run; 	   * 185 sand, 58 gravel;
*/

*dropping staggered organization;
data herbpairs1; set herbpairs;
	drop time1 time2 year2 covm2 ANGL22	KRVIx2	COERx2	PABR22	WAMAx2	PASEC2	ARPUP2	DITE22	SOEL32	
NUCAx2	CITE22	PHAM42	TRUR22	PAPE52	CRGL22	PAHI12	CHTE12	PSOB32	SPCO12	FRFLx2	NELU22	DICO62	
JUBRx2	COBA22	DIOLS2	JUTEx2	DICA32	ERSEx2	GYAMx2	STPI32	LEHI22	CRSA42	ERINx2	ANVI22	HERO22	
CAMU42	TRBI22	DIACx2	TRPE42	PTAQx2	DIRAx2	LERE22	PHCI42	SPCLx2	FIPUx2	CALE62	HYDRx2	CRMO62	
CYHYx2	SONU22	NUTEx2	HYGL22	TRRA52	JUMA42	ACGR22	PASE52	CYCR62	EUCO72	CYLU22	ARLO12	BUCA22	
EUSEx2	EUCO12	GAREx2	CEVI22	DISC32	VUOCx2	BUCIx2	CYEC22	AGHYx2	DIOVx2	HEGEx2	DIAC22	GAPE22	
OXDI22	CRDI12	DIVI72	CHPI82	RHHAx2	GAAN12	ARDE32	SCSCx2	LEMU32	SEARx2	PAPL32	GAAR12	DIAN42	
ERSPx2	CYRE52	CAMI82	SCCIx2	LEDUx2	COCA52	LETEx2	POPR42	DISP22	HELA52	DIOLx2	DILI22	SILIx2; 
	rename year1=year covm1=caco ANGL21=ANGL2	KRVIx1=KRVIx	COERx1=COERx	PABR21=PABR2	WAMAx1=WAMAx	
PASEC1=PASEC	ARPUP1=ARPUP	DITE21=DITE2	SOEL31=SOEL3	NUCAx1=NUCAx	CITE21=CITE2	PHAM41=PHAM4	
TRUR21=TRUR2	PAPE51=PAPE5	CRGL21=CRGL2	PAHI11=PAHI1	CHTE11=CHTE1	PSOB31=PSOB3	SPCO11=SPCO1	
FRFLx1=FRFLx	NELU21=NELU2	DICO61=DICO6	JUBRx1=JUBRx	COBA21=COBA2	DIOLS1=DIOLS	JUTEx1=JUTEx	
DICA31=DICA3	ERSEx1=ERSEx	GYAMx1=GYAMx	STPI31=STPI3	LEHI21=LEHI2	CRSA41=CRSA4	ERINx1=ERINx	
ANVI21=ANVI2	HERO21=HERO2	CAMU41=CAMU4	TRBI21=TRBI2	DIACx1=DIACx	TRPE41=TRPE4	PTAQx1=PTAQx	
DIRAx1=DIRAx	LERE21=LERE2	PHCI41=PHCI4	SPCLx1=SPCLx	FIPUx1=FIPUx	CALE61=CALE6	HYDRx1=HYDRx	
CRMO61=CRMO6	CYHYx1=CYHYx	SONU21=SONU2	NUTEx1=NUTEx	HYGL21=HYGL2	TRRA51=TRRA5	JUMA41=JUMA4	
ACGR21=ACGR2	PASE51=PASE5	CYCR61=CYCR6	EUCO71=EUCO7	CYLU21=CYLU2	ARLO11=ARLO1	BUCA21=BUCA2	
EUSEx1=EUSEx	EUCO11=EUCO1	GAREx1=GAREx	CEVI21=CEVI2	DISC31=DISC3	VUOCx1=VUOCx	BUCIx1=BUCIx	
CYEC21=CYEC2	AGHYx1=AGHYx	DIOVx1=DIOVx	HEGEx1=HEGEx	DIAC21=DIAC2	GAPE21=GAPE2	OXDI21=OXDI2	
CRDI11=CRDI1	DIVI71=DIVI7	CHPI81=CHPI8	RHHAx1=RHHAx	GAAN11=GAAN1	ARDE31=ARDE3	SCSCx1=SCSCx	
LEMU31=LEMU3	SEARx1=SEARx	PAPL31=PAPL3	GAAR11=GAAR1	DIAN41=DIAN4	ERSPx1=ERSPx	CYRE51=CYRE5	
CAMI81=CAMI8	SCCIx1=SCCIx	LEDUx1=LEDUx	COCA51=COCA5	LETEx1=LETEx	POPR41=POPR4	DISP21=DISP2	
HELA51=HELA5	DIOLx1=DIOLx	DILI21=DILI2	SILIx1=SILIx;
run;

*pooling data in herbspref;
data herbspref;  set herbpairs1;
	if prpo=1;
	year=1111;
run; *N=73;
proc sort  data=herbspref; by year plot bcat elev hydr slope soil aspect;
proc means data=herbspref n mean noprint; by year plot bcat elev hydr slope soil aspect;
	var caco 	ANGL2	KRVIx	COERx	PABR2	WAMAx	PASEC	ARPUP	DITE2	SOEL3	NUCAx	CITE2	PHAM4	TRUR2	
PAPE5	CRGL2	PAHI1	CHTE1	PSOB3	SPCO1	FRFLx	NELU2	DICO6	JUBRx	COBA2	DIOLS	JUTEx	DICA3	ERSEx
GYAMx	STPI3	LEHI2	CRSA4	ERINx	ANVI2	HERO2	CAMU4	TRBI2	DIACx	TRPE4	PTAQx	DIRAx	LERE2	PHCI4
SPCLx	FIPUx	CALE6	HYDRx	CRMO6	CYHYx	SONU2	NUTEx	HYGL2	TRRA5	JUMA4	ACGR2	PASE5	CYCR6	EUCO7
CYLU2	ARLO1	BUCA2	EUSEx	EUCO1	GAREx	CEVI2	DISC3	VUOCx	BUCIx	CYEC2	AGHYx	DIOVx	HEGEx	DIAC2
GAPE2	OXDI2	CRDI1	DIVI7	CHPI8	RHHAx	GAAN1	ARDE3	SCSCx	LEMU3	SEARx	PAPL3	GAAR1	DIAN4	ERSPx
CYRE5	CAMI8	SCCIx	LEDUx	COCA5	LETEx	POPR4	DISP2	HELA5	DIOLx	DILI2	SILIx;
	output out=mherbspref n=ncov nANGL2	nKRVIx	nCOERx	nPABR2	nWAMAx	nPASEC	nARPUP	nDITE2	nSOEL3	nNUCAx	nCITE2
nPHAM4	nTRUR2	nPAPE5	nCRGL2	nPAHI1	nCHTE1	nPSOB3	nSPCO1	nFRFLx	nNELU2	nDICO6	nJUBRx	nCOBA2	nDIOLS	nJUTEx
nDICA3	nERSEx	nGYAMx	nSTPI3	nLEHI2	nCRSA4	nERINx	nANVI2	nHERO2	nCAMU4	nTRBI2	nDIACx	nTRPE4	nPTAQx	nDIRAx
nLERE2	nPHCI4	nSPCLx	nFIPUx	nCALE6	nHYDRx	nCRMO6	nCYHYx	nSONU2	nNUTEx	nHYGL2	nTRRA5	nJUMA4	nACGR2	nPASE5
nCYCR6	nEUCO7	nCYLU2	nARLO1	nBUCA2	nEUSEx	nEUCO1	nGAREx	nCEVI2	nDISC3	nVUOCx	nBUCIx	nCYEC2	nAGHYx	nDIOVx
nHEGEx	nDIAC2	nGAPE2	nOXDI2	nCRDI1	nDIVI7	nCHPI8	nRHHAx	nGAAN1	nARDE3	nSCSCx	nLEMU3	nSEARx	nPAPL3	nGAAR1
nDIAN4	nERSPx	nCYRE5	nCAMI8	nSCCIx	nLEDUx	nCOCA5	nLETEx	nPOPR4	nDISP2	nHELA5	nDIOLx	nDILI2	nSILIx
		   			  mean=mcov mANGL2	mKRVIx	mCOERx	mPABR2	mWAMAx	mPASEC	mARPUP	mDITE2	mSOEL3	mNUCAx	mCITE2
mPHAM4	mTRUR2	mPAPE5	mCRGL2	mPAHI1	mCHTE1	mPSOB3	mSPCO1	mFRFLx	mNELU2	mDICO6	mJUBRx	mCOBA2	mDIOLS	mJUTEx
mDICA3	mERSEx	mGYAMx	mSTPI3	mLEHI2	mCRSA4	mERINx	mANVI2	mHERO2	mCAMU4	mTRBI2	mDIACx	mTRPE4	mPTAQx	mDIRAx
mLERE2	mPHCI4	mSPCLx	mFIPUx	mCALE6	mHYDRx	mCRMO6	mCYHYx	mSONU2	mNUTEx	mHYGL2	mTRRA5	mJUMA4	mACGR2	mPASE5
mCYCR6	mEUCO7	mCYLU2	mARLO1	mBUCA2	mEUSEx	mEUCO1	mGAREx	mCEVI2	mDISC3	mVUOCx	mBUCIx	mCYEC2	mAGHYx	mDIOVx
mHEGEx	mDIAC2	mGAPE2	mOXDI2	mCRDI1	mDIVI7	mCHPI8	mRHHAx	mGAAN1	mARDE3	mSCSCx	mLEMU3	mSEARx	mPAPL3	mGAAR1
mDIAN4	mERSPx	mCYRE5	mCAMI8	mSCCIx	mLEDUx	mCOCA5	mLETEx	mPOPR4	mDISP2	mHELA5	mDIOLx	mDILI2	mSILIx;
run;
*proc print data=mherbspref; title 'mherbspref'; run; *N=39;

*structure 1--pre-fire pooled, post-fire not pooled. Species counts are not separated by year;
data herbspost;  set herbpairs1;
	if prpo=2;
run; *N=170;
proc sort data=herbspost; by year plot bcat elev hydr slope soil aspect;
proc sort data=mherbspref; by year plot bcat elev hydr slope soil aspect; run;
data herbmerge1; merge herbspost mherbspref; by year plot bcat elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ prpo; 
run;
*proc print data=herbmerge1 (firstobs=1 obs=10); title 'herbmerge1'; run;	*N=209;
*proc contents data=herbmerge1; run;

*structure 2--pre-fire pooled, post-fire not pooled. Species variables are by year;
data dat2012; set herbspost; if year=2012; 
	 rename caco=cov12 ANGL2=ANGL212	KRVIx=KRVIx12	COERx=COERx12	PABR2=PABR212	WAMAx=WAMAx12	PASEC=PASEC12	ARPUP=ARPUP12	
DITE2=DITE212	SOEL3=SOEL312	NUCAx=NUCAx12	CITE2=CITE212	PHAM4=PHAM412	TRUR2=TRUR212	PAPE5=PAPE512	CRGL2=CRGL212	PAHI1=PAHI112	
CHTE1=CHTE112	PSOB3=PSOB312	SPCO1=SPCO112	FRFLx=FRFLx12	NELU2=NELU212	DICO6=DICO612	JUBRx=JUBRx12	COBA2=COBA212	DIOLS=DIOLS12	
JUTEx=JUTEx12	DICA3=DICA312	ERSEx=ERSEx12	GYAMx=GYAMx12	STPI3=STPI312	LEHI2=LEHI212	CRSA4=CRSA412	ERINx=ERINx12	ANVI2=ANVI212	
HERO2=HERO212	CAMU4=CAMU412	TRBI2=TRBI212	DIACx=DIACx12	TRPE4=TRPE412	PTAQx=PTAQx12	DIRAx=DIRAx12	LERE2=LERE212	PHCI4=PHCI412	
SPCLx=SPCLx12	FIPUx=FIPUx12	CALE6=CALE612	HYDRx=HYDRx12	CRMO6=CRMO612	CYHYx=CYHYx12	SONU2=SONU212	NUTEx=NUTEx12	HYGL2=HYGL212	
TRRA5=TRRA512	JUMA4=JUMA412	ACGR2=ACGR212	PASE5=PASE512	CYCR6=CYCR612	EUCO7=EUCO712	CYLU2=CYLU212	ARLO1=ARLO112	BUCA2=BUCA212	
EUSEx=EUSEx12	EUCO1=EUCO112	GAREx=GAREx12	CEVI2=CEVI212	DISC3=DISC312	VUOCx=VUOCx12	BUCIx=BUCIx12	CYEC2=CYEC212	AGHYx=AGHYx12	
DIOVx=DIOVx12	HEGEx=HEGEx12	DIAC2=DIAC212	GAPE2=GAPE212	OXDI2=OXDI212	CRDI1=CRDI112	DIVI7=DIVI712	CHPI8=CHPI812	RHHAx=RHHAx12	
GAAN1=GAAN112	ARDE3=ARDE312	SCSCx=SCSCx12	LEMU3=LEMU312	SEARx=SEARx12	PAPL3=PAPL312	GAAR1=GAAR112	DIAN4=DIAN412	ERSPx=ERSPx12	
CYRE5=CYRE512	CAMI8=CAMI812	SCCIx=SCCIx12	LEDUx=LEDUx12	COCA5=COCA512	LETEx=LETEx12	POPR4=POPR412	DISP2=DISP212	HELA5=HELA512	
DIOLx=DIOLx12	DILI2=DILI212	SILIx=SILIx12;  
data dat2013; set herbspost; if year=2013; 
	 rename caco=cov13 ANGL2=ANGL213	KRVIx=KRVIx13	COERx=COERx13	PABR2=PABR213	WAMAx=WAMAx13	PASEC=PASEC13	ARPUP=ARPUP13	
DITE2=DITE213	SOEL3=SOEL313	NUCAx=NUCAx13	CITE2=CITE213	PHAM4=PHAM413	TRUR2=TRUR213	PAPE5=PAPE513	CRGL2=CRGL213	PAHI1=PAHI113	
CHTE1=CHTE113	PSOB3=PSOB313	SPCO1=SPCO113	FRFLx=FRFLx13	NELU2=NELU213	DICO6=DICO613	JUBRx=JUBRx13	COBA2=COBA213	DIOLS=DIOLS13	
JUTEx=JUTEx13	DICA3=DICA313	ERSEx=ERSEx13	GYAMx=GYAMx13	STPI3=STPI313	LEHI2=LEHI213	CRSA4=CRSA413	ERINx=ERINx13	ANVI2=ANVI213	
HERO2=HERO213	CAMU4=CAMU413	TRBI2=TRBI213	DIACx=DIACx13	TRPE4=TRPE413	PTAQx=PTAQx13	DIRAx=DIRAx13	LERE2=LERE213	PHCI4=PHCI413	
SPCLx=SPCLx13	FIPUx=FIPUx13	CALE6=CALE613	HYDRx=HYDRx13	CRMO6=CRMO613	CYHYx=CYHYx13	SONU2=SONU213	NUTEx=NUTEx13	HYGL2=HYGL213	
TRRA5=TRRA513	JUMA4=JUMA413	ACGR2=ACGR213	PASE5=PASE513	CYCR6=CYCR613	EUCO7=EUCO713	CYLU2=CYLU213	ARLO1=ARLO113	BUCA2=BUCA213	
EUSEx=EUSEx13	EUCO1=EUCO113	GAREx=GAREx13	CEVI2=CEVI213	DISC3=DISC313	VUOCx=VUOCx13	BUCIx=BUCIx13	CYEC2=CYEC213	AGHYx=AGHYx13	
DIOVx=DIOVx13	HEGEx=HEGEx13	DIAC2=DIAC213	GAPE2=GAPE213	OXDI2=OXDI213	CRDI1=CRDI113	DIVI7=DIVI713	CHPI8=CHPI813	RHHAx=RHHAx13	
GAAN1=GAAN113	ARDE3=ARDE313	SCSCx=SCSCx13	LEMU3=LEMU313	SEARx=SEARx13	PAPL3=PAPL313	GAAR1=GAAR113	DIAN4=DIAN413	ERSPx=ERSPx13	
CYRE5=CYRE513	CAMI8=CAMI813	SCCIx=SCCIx13	LEDUx=LEDUx13	COCA5=COCA513	LETEx=LETEx13	POPR4=POPR413	DISP2=DISP213	HELA5=HELA513	
DIOLx=DIOLx13	DILI2=DILI213	SILIx=SILIx13; 
data dat2014; set herbspost; if year=2014; 
	 rename caco=cov14 ANGL2=ANGL214	KRVIx=KRVIx14	COERx=COERx14	PABR2=PABR214	WAMAx=WAMAx14	PASEC=PASEC14	ARPUP=ARPUP14	
DITE2=DITE214	SOEL3=SOEL314	NUCAx=NUCAx14	CITE2=CITE214	PHAM4=PHAM414	TRUR2=TRUR214	PAPE5=PAPE514	CRGL2=CRGL214	PAHI1=PAHI114	
CHTE1=CHTE114	PSOB3=PSOB314	SPCO1=SPCO114	FRFLx=FRFLx14	NELU2=NELU214	DICO6=DICO614	JUBRx=JUBRx14	COBA2=COBA214	DIOLS=DIOLS14	
JUTEx=JUTEx14	DICA3=DICA314	ERSEx=ERSEx14	GYAMx=GYAMx14	STPI3=STPI314	LEHI2=LEHI214	CRSA4=CRSA414	ERINx=ERINx14	ANVI2=ANVI214	
HERO2=HERO214	CAMU4=CAMU414	TRBI2=TRBI214	DIACx=DIACx14	TRPE4=TRPE414	PTAQx=PTAQx14	DIRAx=DIRAx14	LERE2=LERE214	PHCI4=PHCI414	
SPCLx=SPCLx14	FIPUx=FIPUx14	CALE6=CALE614	HYDRx=HYDRx14	CRMO6=CRMO614	CYHYx=CYHYx14	SONU2=SONU214	NUTEx=NUTEx14	HYGL2=HYGL214	
TRRA5=TRRA514	JUMA4=JUMA414	ACGR2=ACGR214	PASE5=PASE514	CYCR6=CYCR614	EUCO7=EUCO714	CYLU2=CYLU214	ARLO1=ARLO114	BUCA2=BUCA214
EUSEx=EUSEx14	EUCO1=EUCO114	GAREx=GAREx14	CEVI2=CEVI214	DISC3=DISC314	VUOCx=VUOCx14	BUCIx=BUCIx14	CYEC2=CYEC214	AGHYx=AGHYx14
DIOVx=DIOVx14	HEGEx=HEGEx14	DIAC2=DIAC214	GAPE2=GAPE214	OXDI2=OXDI214	CRDI1=CRDI114	DIVI7=DIVI714	CHPI8=CHPI814	RHHAx=RHHAx14	
GAAN1=GAAN114	ARDE3=ARDE314	SCSCx=SCSCx14	LEMU3=LEMU314	SEARx=SEARx14	PAPL3=PAPL314	GAAR1=GAAR114	DIAN4=DIAN414	ERSPx=ERSPx14	
CYRE5=CYRE514	CAMI8=CAMI814	SCCIx=SCCIx14	LEDUx=LEDUx14	COCA5=COCA514	LETEx=LETEx14	POPR4=POPR414	DISP2=DISP214	HELA5=HELA514	
DIOLx=DIOLx14	DILI2=DILI214	SILIx=SILIx14;  
data dat2015; set herbspost; if year=2015; 
	 rename caco=cov15	ANGL2=ANGL215	KRVIx=KRVIx15	COERx=COERx15	PABR2=PABR215	WAMAx=WAMAx15	PASEC=PASEC15	ARPUP=ARPUP15	
DITE2=DITE215	SOEL3=SOEL315	NUCAx=NUCAx15	CITE2=CITE215	PHAM4=PHAM415	TRUR2=TRUR215	PAPE5=PAPE515	CRGL2=CRGL215	PAHI1=PAHI115	
CHTE1=CHTE115	PSOB3=PSOB315	SPCO1=SPCO115	FRFLx=FRFLx15	NELU2=NELU215	DICO6=DICO615	JUBRx=JUBRx15	COBA2=COBA215	DIOLS=DIOLS15	
JUTEx=JUTEx15	DICA3=DICA315	ERSEx=ERSEx15	GYAMx=GYAMx15	STPI3=STPI315	LEHI2=LEHI215	CRSA4=CRSA415	ERINx=ERINx15	ANVI2=ANVI215	
HERO2=HERO215	CAMU4=CAMU415	TRBI2=TRBI215	DIACx=DIACx15	TRPE4=TRPE415	PTAQx=PTAQx15	DIRAx=DIRAx15	LERE2=LERE215	PHCI4=PHCI415	
SPCLx=SPCLx15	FIPUx=FIPUx15	CALE6=CALE615	HYDRx=HYDRx15	CRMO6=CRMO615	CYHYx=CYHYx15	SONU2=SONU215	NUTEx=NUTEx15	HYGL2=HYGL215	
TRRA5=TRRA515	JUMA4=JUMA415	ACGR2=ACGR215	PASE5=PASE515	CYCR6=CYCR615	EUCO7=EUCO715	CYLU2=CYLU215	ARLO1=ARLO115	BUCA2=BUCA215	
EUSEx=EUSEx15	EUCO1=EUCO115	GAREx=GAREx15	CEVI2=CEVI215	DISC3=DISC315	VUOCx=VUOCx15	BUCIx=BUCIx15	CYEC2=CYEC215	AGHYx=AGHYx15	
DIOVx=DIOVx15	HEGEx=HEGEx15	DIAC2=DIAC215	GAPE2=GAPE215	OXDI2=OXDI215	CRDI1=CRDI115	DIVI7=DIVI715	CHPI8=CHPI815	RHHAx=RHHAx15	
GAAN1=GAAN115	ARDE3=ARDE315	SCSCx=SCSCx15	LEMU3=LEMU315	SEARx=SEARx15	PAPL3=PAPL315	GAAR1=GAAR115	DIAN4=DIAN415	ERSPx=ERSPx15	
CYRE5=CYRE515	CAMI8=CAMI815	SCCIx=SCCIx15	LEDUx=LEDUx15	COCA5=COCA515	LETEx=LETEx15	POPR4=POPR415	DISP2=DISP215	HELA5=HELA515	
DIOLx=DIOLx15	DILI2=DILI215	SILIx=SILIx15; 
data prefavg; set mherbspref; 
	 rename ncov=ncovpre  nANGL2=nANGL2pre	nKRVIx=nKRVIxpre	nCOERx=nCOERxpre	nPABR2=nPABR2pre	nWAMAx=nWAMAxpre	nPASEC=nPASECpre	
nARPUP=nARPUPpre	nDITE2=nDITE2pre	nSOEL3=nSOEL3pre	nNUCAx=nNUCAxpre	nCITE2=nCITE2pre	nPHAM4=nPHAM4pre	nTRUR2=nTRUR2pre	
nPAPE5=nPAPE5pre	nCRGL2=nCRGL2pre	nPAHI1=nPAHI1pre	nCHTE1=nCHTE1pre	nPSOB3=nPSOB3pre	nSPCO1=nSPCO1pre	nFRFLx=nFRFLxpre	
nNELU2=nNELU2pre	nDICO6=nDICO6pre	nJUBRx=nJUBRxpre	nCOBA2=nCOBA2pre	nDIOLS=nDIOLSpre	nJUTEx=nJUTExpre	nDICA3=nDICA3pre	
nERSEx=nERSExpre	nGYAMx=nGYAMxpre	nSTPI3=nSTPI3pre	nLEHI2=nLEHI2pre	nCRSA4=nCRSA4pre	nERINx=nERINxpre	nANVI2=nANVI2pre	
nHERO2=nHERO2pre	nCAMU4=nCAMU4pre	nTRBI2=nTRBI2pre	nDIACx=nDIACxpre	nTRPE4=nTRPE4pre	nPTAQx=nPTAQxpre	nDIRAx=nDIRAxpre	
nLERE2=nLERE2pre	nPHCI4=nPHCI4pre	nSPCLx=nSPCLxpre	nFIPUx=nFIPUxpre	nCALE6=nCALE6pre	nHYDRx=nHYDRxpre	nCRMO6=nCRMO6pre	
nCYHYx=nCYHYxpre	nSONU2=nSONU2pre	nNUTEx=nNUTExpre	nHYGL2=nHYGL2pre	nTRRA5=nTRRA5pre	nJUMA4=nJUMA4pre	nACGR2=nACGR2pre	
nPASE5=nPASE5pre	nCYCR6=nCYCR6pre	nEUCO7=nEUCO7pre	nCYLU2=nCYLU2pre	nARLO1=nARLO1pre	nBUCA2=nBUCA2pre	nEUSEx=nEUSExpre	
nEUCO1=nEUCO1pre	nGAREx=nGARExpre	nCEVI2=nCEVI2pre	nDISC3=nDISC3pre	nVUOCx=nVUOCxpre	nBUCIx=nBUCIxpre	nCYEC2=nCYEC2pre	
nAGHYx=nAGHYxpre	nDIOVx=nDIOVxpre	nHEGEx=nHEGExpre	nDIAC2=nDIAC2pre	nGAPE2=nGAPE2pre	nOXDI2=nOXDI2pre	nCRDI1=nCRDI1pre	
nDIVI7=nDIVI7pre	nCHPI8=nCHPI8pre	nRHHAx=nRHHAxpre	nGAAN1=nGAAN1pre	nARDE3=nARDE3pre	nSCSCx=nSCSCxpre	nLEMU3=nLEMU3pre	
nSEARx=nSEARxpre	nPAPL3=nPAPL3pre	nGAAR1=nGAAR1pre	nDIAN4=nDIAN4pre	nERSPx=nERSPxpre	nCYRE5=nCYRE5pre	nCAMI8=nCAMI8pre	
nSCCIx=nSCCIxpre	nLEDUx=nLEDUxpre	nCOCA5=nCOCA5pre	nLETEx=nLETExpre	nPOPR4=nPOPR4pre	nDISP2=nDISP2pre	nHELA5=nHELA5pre	
nDIOLx=nDIOLxpre	nDILI2=nDILI2pre	nSILIx=nSILIxpre	
		   	mcov=mcovpre mANGL2=mANGL2pre	mKRVIx=mKRVIxpre	mCOERx=mCOERxpre	mPABR2=mPABR2pre	mWAMAx=mWAMAxpre	mPASEC=mPASECpre
mARPUP=mARPUPpre	mDITE2=mDITE2pre	mSOEL3=mSOEL3pre	mNUCAx=mNUCAxpre	mCITE2=mCITE2pre	mPHAM4=mPHAM4pre	mTRUR2=mTRUR2pre	
mPAPE5=mPAPE5pre	mCRGL2=mCRGL2pre	mPAHI1=mPAHI1pre	mCHTE1=mCHTE1pre	mPSOB3=mPSOB3pre	mSPCO1=mSPCO1pre	mFRFLx=mFRFLxpre	
mNELU2=mNELU2pre	mDICO6=mDICO6pre	mJUBRx=mJUBRxpre	mCOBA2=mCOBA2pre	mDIOLS=mDIOLSpre	mJUTEx=mJUTExpre	mDICA3=mDICA3pre	
mERSEx=mERSExpre	mGYAMx=mGYAMxpre	mSTPI3=mSTPI3pre	mLEHI2=mLEHI2pre	mCRSA4=mCRSA4pre	mERINx=mERINxpre	mANVI2=mANVI2pre	
mHERO2=mHERO2pre	mCAMU4=mCAMU4pre	mTRBI2=mTRBI2pre	mDIACx=mDIACxpre	mTRPE4=mTRPE4pre	mPTAQx=mPTAQxpre	mDIRAx=mDIRAxpre	
mLERE2=mLERE2pre	mPHCI4=mPHCI4pre	mSPCLx=mSPCLxpre	mFIPUx=mFIPUxpre	mCALE6=mCALE6pre	mHYDRx=mHYDRxpre	mCRMO6=mCRMO6pre	
mCYHYx=mCYHYxpre	mSONU2=mSONU2pre	mNUTEx=mNUTExpre	mHYGL2=mHYGL2pre	mTRRA5=mTRRA5pre	mJUMA4=mJUMA4pre	mACGR2=mACGR2pre	
mPASE5=mPASE5pre	mCYCR6=mCYCR6pre	mEUCO7=mEUCO7pre	mCYLU2=mCYLU2pre	mARLO1=mARLO1pre	mBUCA2=mBUCA2pre	mEUSEx=mEUSExpre	
mEUCO1=mEUCO1pre	mGAREx=mGARExpre	mCEVI2=mCEVI2pre	mDISC3=mDISC3pre	mVUOCx=mVUOCxpre	mBUCIx=mBUCIxpre	mCYEC2=mCYEC2pre	
mAGHYx=mAGHYxpre	mDIOVx=mDIOVxpre	mHEGEx=mHEGExpre	mDIAC2=mDIAC2pre	mGAPE2=mGAPE2pre	mOXDI2=mOXDI2pre	mCRDI1=mCRDI1pre	
mDIVI7=mDIVI7pre	mCHPI8=mCHPI8pre	mRHHAx=mRHHAxpre	mGAAN1=mGAAN1pre	mARDE3=mARDE3pre	mSCSCx=mSCSCxpre	mLEMU3=mLEMU3pre	
mSEARx=mSEARxpre	mPAPL3=mPAPL3pre	mGAAR1=mGAAR1pre	mDIAN4=mDIAN4pre	mERSPx=mERSPxpre	mCYRE5=mCYRE5pre	mCAMI8=mCAMI8pre	
mSCCIx=mSCCIxpre	mLEDUx=mLEDUxpre	mCOCA5=mCOCA5pre	mLETEx=mLETExpre	mPOPR4=mPOPR4pre	mDISP2=mDISP2pre	mHELA5=mHELA5pre	
mDIOLx=mDIOLxpre	mDILI2=mDILI2pre	mSILIx=mSILIxpre;
run;
data herbmerge2; merge prefavg dat2012 dat2013 dat2014 dat2015; by plot; drop year; run;
*proc print data=herbmerge2; title 'herbmerge2'; run; 
*prefavg n=39, dat2012 n=32, dat2013 n=46, dat2014 n=46, dat2015 n=46, herbmerge2 n=55;
proc contents data=herbmerge2; run;
data counts; set herbmerge2; 
	drop ncovpre mcovpre cov12 cov13 cov14 cov15 plot prpo 
	slope soil hydr elev aspect _FREQ_ _TYPE_ bcat;
run;

proc iml;

*reading in counts;
use counts; read all into matcount;	*print matcount;
nrecords=nrow(matcount);			*print nrecords; *n=55;
ncolumns=ncol(matcount);			*print ncolumns; *n=600;

*creating a duplicate to fill with p/a;
matpa=matcount;						*print matpa;

do i = 1 to nrecords;
	do j = 1 to ncolumns;
		*fill matpa with 999;
		matpa[i,j]=999;
			*fill matpa with 0s (absent) or 1s (present);
			if (matcount[i,j]=0) then matpa[i,j]=0;
			if (matcount[i,j]>0) then matpa[i,j]=1;
	end;
end;
print matpa;	*not working--still includes values >1;

quit;
run;

/*
proc export data=herbmerge2
   outfile='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\herbmerge2.csv'
   dbms=csv
   replace;
run;
*/

