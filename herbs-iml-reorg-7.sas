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
				  holdDIOLx	holdDILI2 	herb1; by plot bcat year;
  *changing . to 0, then creating p/a columns;
  if (nANGL2=.) then nANGL2=0; if (nANGL2=0) then paANGL2=0; if (nANGL2^=0) then paANGL2=1;
  if (nKRVIx=.) then nKRVIx=0; if (nKRVIx=0) then paKRVIx=0; if (nKRVIx^=0) then paKRVIx=1;
  if (nCOERx=.) then nCOERx=0; if (nCOERx=0) then paCOERx=0; if (nCOERx^=0) then paCOERx=1;
  if (nPABR2=.) then nPABR2=0; if (nPABR2=0) then paPABR2=0; if (nPABR2^=0) then paPABR2=1;
  if (nWAMAx=.) then nWAMAx=0; if (nWAMAx=0) then paWAMAx=0; if (nWAMAx^=0) then paWAMAx=1;
  if (nPASEC=.) then nPASEC=0; if (nPASEC=0) then paPASEC=0; if (nPASEC^=0) then paPASEC=1;
  if (nSILIx=.) then nSILIx=0; if (nSILIx=0) then paSILIx=0; if (nSILIx^=0) then paSILIx=1;
  if (nARPUP=.) then nARPUP=0; if (nARPUP=0) then paARPUP=0; if (nARPUP^=0) then paARPUP=1;
  if (nDITE2=.) then nDITE2=0; if (nDITE2=0) then paDITE2=0; if (nDITE2^=0) then paDITE2=1;
  if (nSOEL3=.) then nSOEL3=0; if (nSOEL3=0) then paSOEL3=0; if (nSOEL3^=0) then paSOEL3=1;
  if (nNUCAx=.) then nNUCAx=0; if (nNUCAx=0) then paNUCAx=0; if (nNUCAx^=0) then paNUCAx=1;
  if (nCITE2=.) then nCITE2=0; if (nCITE2=0) then paCITE2=0; if (nCITE2^=0) then paCITE2=1;
  if (nPHAM4=.) then nPHAM4=0; if (nPHAM4=0) then paPHAM4=0; if (nPHAM4^=0) then paPHAM4=1;
  if (nTRUR2=.) then nTRUR2=0; if (nTRUR2=0) then paTRUR2=0; if (nTRUR2^=0) then paTRUR2=1;
  if (nPAPE5=.) then nPAPE5=0; if (nPAPE5=0) then paPAPE5=0; if (nPAPE5^=0) then paPAPE5=1;
  if (nCRGL2=.) then nCRGL2=0; if (nCRGL2=0) then paCRGL2=0; if (nCRGL2^=0) then paCRGL2=1;
  if (nPAHI1=.) then nPAHI1=0; if (nPAHI1=0) then paPAHI1=0; if (nPAHI1^=0) then paPAHI1=1;
  if (nCHTE1=.) then nCHTE1=0; if (nCHTE1=0) then paCHTE1=0; if (nCHTE1^=0) then paCHTE1=1;
  if (nPSOB3=.) then nPSOB3=0; if (nPSOB3=0) then paPSOB3=0; if (nPSOB3^=0) then paPSOB3=1;
  if (nSPCO1=.) then nSPCO1=0; if (nSPCO1=0) then paSPCO1=0; if (nSPCO1^=0) then paSPCO1=1;
  if (nFRFLx=.) then nFRFLx=0; if (nFRFLx=0) then paFRFLx=0; if (nFRFLx^=0) then paFRFLx=1;
  if (nNELU2=.) then nNELU2=0; if (nNELU2=0) then paNELU2=0; if (nNELU2^=0) then paNELU2=1;
  if (nDICO6=.) then nDICO6=0; if (nDICO6=0) then paDICO6=0; if (nDICO6^=0) then paDICO6=1;
  if (nJUBRx=.) then nJUBRx=0; if (nJUBRx=0) then paJUBRx=0; if (nJUBRx^=0) then paJUBRx=1;
  if (nCOBA2=.) then nCOBA2=0; if (nCOBA2=0) then paCOBA2=0; if (nCOBA2^=0) then paCOBA2=1;
  if (nDIOLS=.) then nDIOLS=0; if (nDIOLS=0) then paDIOLS=0; if (nDIOLS^=0) then paDIOLS=1;
  if (nJUTEx=.) then nJUTEx=0; if (nJUTEx=0) then paJUTEx=0; if (nJUTEx^=0) then paJUTEx=1;
  if (nDICA3=.) then nDICA3=0; if (nDICA3=0) then paDICA3=0; if (nDICA3^=0) then paDICA3=1;
  if (nERSEx=.) then nERSEx=0; if (nERSEx=0) then paERSEx=0; if (nERSEx^=0) then paERSEx=1;
  if (nGYAMx=.) then nGYAMx=0; if (nGYAMx=0) then paGYAMx=0; if (nGYAMx^=0) then paGYAMx=1;
  if (nSTPI3=.) then nSTPI3=0; if (nSTPI3=0) then paSTPI3=0; if (nSTPI3^=0) then paSTPI3=1;
  if (nLEHI2=.) then nLEHI2=0; if (nLEHI2=0) then paLEHI2=0; if (nLEHI2^=0) then paLEHI2=1;
  if (nCRSA4=.) then nCRSA4=0; if (nCRSA4=0) then paCRSA4=0; if (nCRSA4^=0) then paCRSA4=1;
  if (nERINx=.) then nERINx=0; if (nERINx=0) then paERINx=0; if (nERINx^=0) then paERINx=1;
  if (nANVI2=.) then nANVI2=0; if (nANVI2=0) then paANVI2=0; if (nANVI2^=0) then paANVI2=1;
  if (nHERO2=.) then nHERO2=0; if (nHERO2=0) then paHERO2=0; if (nHERO2^=0) then paHERO2=1;
  if (nCAMU4=.) then nCAMU4=0; if (nCAMU4=0) then paCAMU4=0; if (nCAMU4^=0) then paCAMU4=1;
  if (nTRBI2=.) then nTRBI2=0; if (nTRBI2=0) then paTRBI2=0; if (nTRBI2^=0) then paTRBI2=1;
  if (nDIACx=.) then nDIACx=0; if (nDIACx=0) then paDIACx=0; if (nDIACx^=0) then paDIACx=1;
  if (nTRPE4=.) then nTRPE4=0; if (nTRPE4=0) then paTRPE4=0; if (nTRPE4^=0) then paTRPE4=1;
  if (nPTAQx=.) then nPTAQx=0; if (nPTAQx=0) then paPTAQx=0; if (nPTAQx^=0) then paPTAQx=1;
  if (nDIRAx=.) then nDIRAx=0; if (nDIRAx=0) then paDIRAx=0; if (nDIRAx^=0) then paDIRAx=1;
  if (nLERE2=.) then nLERE2=0; if (nLERE2=0) then paLERE2=0; if (nLERE2^=0) then paLERE2=1;
  if (nPHCI4=.) then nPHCI4=0; if (nPHCI4=0) then paPHCI4=0; if (nPHCI4^=0) then paPHCI4=1;
  if (nSPCLx=.) then nSPCLx=0; if (nSPCLx=0) then paSPCLx=0; if (nSPCLx^=0) then paSPCLx=1;
  if (nFIPUx=.) then nFIPUx=0; if (nFIPUx=0) then paFIPUx=0; if (nFIPUx^=0) then paFIPUx=1;
  if (nCALE6=.) then nCALE6=0; if (nCALE6=0) then paCALE6=0; if (nCALE6^=0) then paCALE6=1;
  if (nHYDRx=.) then nHYDRx=0; if (nHYDRx=0) then paHYDRx=0; if (nHYDRx^=0) then paHYDRx=1;
  if (nCRMO6=.) then nCRMO6=0; if (nCRMO6=0) then paCRMO6=0; if (nCRMO6^=0) then paCRMO6=1;
  if (nCYHYx=.) then nCYHYx=0; if (nCYHYx=0) then paCYHYx=0; if (nCYHYx^=0) then paCYHYx=1;
  if (nSONU2=.) then nSONU2=0; if (nSONU2=0) then paSONU2=0; if (nSONU2^=0) then paSONU2=1;
  if (nNUTEx=.) then nNUTEx=0; if (nNUTEx=0) then paNUTEx=0; if (nNUTEx^=0) then paNUTEx=1;
  if (nHYGL2=.) then nHYGL2=0; if (nHYGL2=0) then paHYGL2=0; if (nHYGL2^=0) then paHYGL2=1;
  if (nTRRA5=.) then nTRRA5=0; if (nTRRA5=0) then paTRRA5=0; if (nTRRA5^=0) then paTRRA5=1;
  if (nJUMA4=.) then nJUMA4=0; if (nJUMA4=0) then paJUMA4=0; if (nJUMA4^=0) then paJUMA4=1;
  if (nACGR2=.) then nACGR2=0; if (nACGR2=0) then paACGR2=0; if (nACGR2^=0) then paACGR2=1;
  if (nPASE5=.) then nPASE5=0; if (nPASE5=0) then paPASE5=0; if (nPASE5^=0) then paPASE5=1;
  if (nCYCR6=.) then nCYCR6=0; if (nCYCR6=0) then paCYCR6=0; if (nCYCR6^=0) then paCYCR6=1;
  if (nEUCO7=.) then nEUCO7=0; if (nEUCO7=0) then paEUCO7=0; if (nEUCO7^=0) then paEUCO7=1;
  if (nCYLU2=.) then nCYLU2=0; if (nCYLU2=0) then paCYLU2=0; if (nCYLU2^=0) then paCYLU2=1;
  if (nARLO1=.) then nARLO1=0; if (nARLO1=0) then paARLO1=0; if (nARLO1^=0) then paARLO1=1;
  if (nBUCA2=.) then nBUCA2=0; if (nBUCA2=0) then paBUCA2=0; if (nBUCA2^=0) then paBUCA2=1;
  if (nEUSEx=.) then nEUSEx=0; if (nEUSEx=0) then paEUSEx=0; if (nEUSEx^=0) then paEUSEx=1;
  if (nEUCO1=.) then nEUCO1=0; if (nEUCO1=0) then paEUCO1=0; if (nEUCO1^=0) then paEUCO1=1;
  if (nGAREx=.) then nGAREx=0; if (nGAREx=0) then paGAREx=0; if (nGAREx^=0) then paGAREx=1;
  if (nCEVI2=.) then nCEVI2=0; if (nCEVI2=0) then paCEVI2=0; if (nCEVI2^=0) then paCEVI2=1;
  if (nDISC3=.) then nDISC3=0; if (nDISC3=0) then paDISC3=0; if (nDISC3^=0) then paDISC3=1;
  if (nVUOCx=.) then nVUOCx=0; if (nVUOCx=0) then paVUOCx=0; if (nVUOCx^=0) then paVUOCx=1;
  if (nBUCIx=.) then nBUCIx=0; if (nBUCIx=0) then paBUCIx=0; if (nBUCIx^=0) then paBUCIx=1;
  if (nCYEC2=.) then nCYEC2=0; if (nCYEC2=0) then paCYEC2=0; if (nCYEC2^=0) then paCYEC2=1;
  if (nAGHYx=.) then nAGHYx=0; if (nAGHYx=0) then paAGHYx=0; if (nAGHYx^=0) then paAGHYx=1;
  if (nDIOVx=.) then nDIOVx=0; if (nDIOVx=0) then paDIOVx=0; if (nDIOVx^=0) then paDIOVx=1;
  if (nHEGEx=.) then nHEGEx=0; if (nHEGEx=0) then paHEGEx=0; if (nHEGEx^=0) then paHEGEx=1;
  if (nDIAC2=.) then nDIAC2=0; if (nDIAC2=0) then paDIAC2=0; if (nDIAC2^=0) then paDIAC2=1;
  if (nGAPE2=.) then nGAPE2=0; if (nGAPE2=0) then paGAPE2=0; if (nGAPE2^=0) then paGAPE2=1;
  if (nOXDI2=.) then nOXDI2=0; if (nOXDI2=0) then paOXDI2=0; if (nOXDI2^=0) then paOXDI2=1;
  if (nCRDI1=.) then nCRDI1=0; if (nCRDI1=0) then paCRDI1=0; if (nCRDI1^=0) then paCRDI1=1;
  if (nDIVI7=.) then nDIVI7=0; if (nDIVI7=0) then paDIVI7=0; if (nDIVI7^=0) then paDIVI7=1;
  if (nCHPI8=.) then nCHPI8=0; if (nCHPI8=0) then paCHPI8=0; if (nCHPI8^=0) then paCHPI8=1;
  if (nRHHAx=.) then nRHHAx=0; if (nRHHAx=0) then paRHHAx=0; if (nRHHAx^=0) then paRHHAx=1;
  if (nGAAN1=.) then nGAAN1=0; if (nGAAN1=0) then paGAAN1=0; if (nGAAN1^=0) then paGAAN1=1;
  if (nARDE3=.) then nARDE3=0; if (nARDE3=0) then paARDE3=0; if (nARDE3^=0) then paARDE3=1;
  if (nSCSCx=.) then nSCSCx=0; if (nSCSCx=0) then paSCSCx=0; if (nSCSCx^=0) then paSCSCx=1;
  if (nLEMU3=.) then nLEMU3=0; if (nLEMU3=0) then paLEMU3=0; if (nLEMU3^=0) then paLEMU3=1;
  if (nSEARx=.) then nSEARx=0; if (nSEARx=0) then paSEARx=0; if (nSEARx^=0) then paSEARx=1;
  if (nPAPL3=.) then nPAPL3=0; if (nPAPL3=0) then paPAPL3=0; if (nPAPL3^=0) then paPAPL3=1;
  if (nGAAR1=.) then nGAAR1=0; if (nGAAR1=0) then paGAAR1=0; if (nGAAR1^=0) then paGAAR1=1;
  if (nDIAN4=.) then nDIAN4=0; if (nDIAN4=0) then paDIAN4=0; if (nDIAN4^=0) then paDIAN4=1;
  if (nERSPx=.) then nERSPx=0; if (nERSPx=0) then paERSPx=0; if (nERSPx^=0) then paERSPx=1;
  if (nCYRE5=.) then nCYRE5=0; if (nCYRE5=0) then paCYRE5=0; if (nCYRE5^=0) then paCYRE5=1;
  if (nCAMI8=.) then nCAMI8=0; if (nCAMI8=0) then paCAMI8=0; if (nCAMI8^=0) then paCAMI8=1;
  if (nSCCIx=.) then nSCCIx=0; if (nSCCIx=0) then paSCCIx=0; if (nSCCIx^=0) then paSCCIx=1;
  if (nLEDUx=.) then nLEDUx=0; if (nLEDUx=0) then paLEDUx=0; if (nLEDUx^=0) then paLEDUx=1;
  if (nCOCA5=.) then nCOCA5=0; if (nCOCA5=0) then paCOCA5=0; if (nCOCA5^=0) then paCOCA5=1;
  if (nLETEx=.) then nLETEx=0; if (nLETEx=0) then paLETEx=0; if (nLETEx^=0) then paLETEx=1;
  if (nPOPR4=.) then nPOPR4=0; if (nPOPR4=0) then paPOPR4=0; if (nPOPR4^=0) then paPOPR4=1;
  if (nDISP2=.) then nDISP2=0; if (nDISP2=0) then paDISP2=0; if (nDISP2^=0) then paDISP2=1;
  if (nHELA5=.) then nHELA5=0; if (nHELA5=0) then paHELA5=0; if (nHELA5^=0) then paHELA5=1;
  if (nDIOLx=.) then nDIOLx=0; if (nDIOLx=0) then paDIOLx=0; if (nDIOLx^=0) then paDIOLx=1;
  if (nDILI2=.) then nDILI2=0; if (nDILI2=0) then paDILI2=0; if (nDILI2^=0) then paDILI2=1;
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
	 rename caco=cov12 mANGL2=mANGL212	mKRVIx=mKRVIx12	mCOERx=mCOERx12	mPABR2=mPABR212	mWAMAx=mWAMAx12	mPASEC=mPASEC12
mARPUP=mARPUP12	mDITE2=mDITE212	mSOEL3=mSOEL312	mNUCAx=mNUCAx12	mCITE2=mCITE212	mPHAM4=mPHAM412	mTRUR2=mTRUR212	mPAPE5=mPAPE512	
mCRGL2=mCRGL212	mPAHI1=mPAHI112	mCHTE1=mCHTE112	mPSOB3=mPSOB312	mSPCO1=mSPCO112	mFRFLx=mFRFLx12	mNELU2=mNELU212	mDICO6=mDICO612	
mJUBRx=mJUBRx12	mCOBA2=mCOBA212	mDIOLS=mDIOLS12	mJUTEx=mJUTEx12	mDICA3=mDICA312	mERSEx=mERSEx12	mGYAMx=mGYAMx12	mSTPI3=mSTPI312	
mLEHI2=mLEHI212	mCRSA4=mCRSA412	mERINx=mERINx12	mANVI2=mANVI212	mHERO2=mHERO212	mCAMU4=mCAMU412	mTRBI2=mTRBI212	mDIACx=mDIACx12	
mTRPE4=mTRPE412	mPTAQx=mPTAQx12	mDIRAx=mDIRAx12	mLERE2=mLERE212	mPHCI4=mPHCI412	mSPCLx=mSPCLx12	mFIPUx=mFIPUx12	mCALE6=mCALE612	
mHYDRx=mHYDRx12	mCRMO6=mCRMO612	mCYHYx=mCYHYx12	mSONU2=mSONU212	mNUTEx=mNUTEx12	mHYGL2=mHYGL212	mTRRA5=mTRRA512	mJUMA4=mJUMA412
mACGR2=mACGR212	mPASE5=mPASE512	mCYCR6=mCYCR612	mEUCO7=mEUCO712	mCYLU2=mCYLU212	mARLO1=mARLO112	mBUCA2=mBUCA212	mEUSEx=mEUSEx12	
mEUCO1=mEUCO112	mGAREx=mGAREx12	mCEVI2=mCEVI212	mDISC3=mDISC312	mVUOCx=mVUOCx12	mBUCIx=mBUCIx12	mCYEC2=mCYEC212	mAGHYx=mAGHYx12	
mDIOVx=mDIOVx12	mHEGEx=mHEGEx12	mDIAC2=mDIAC212	mGAPE2=mGAPE212	mOXDI2=mOXDI212	mCRDI1=mCRDI112	mDIVI7=mDIVI712	mCHPI8=mCHPI812	
mRHHAx=mRHHAx12	mGAAN1=mGAAN112	mARDE3=mARDE312	mSCSCx=mSCSCx12	mLEMU3=mLEMU312	mSEARx=mSEARx12	mPAPL3=mPAPL312	mGAAR1=mGAAR112	
mDIAN4=mDIAN412	mERSPx=mERSPx12	mCYRE5=mCYRE512	mCAMI8=mCAMI812	mSCCIx=mSCCIx12	mLEDUx=mLEDUx12	mCOCA5=mCOCA512	mLETEx=mLETEx12	
mPOPR4=mPOPR412	mDISP2=mDISP212	mHELA5=mHELA512	mDIOLx=mDIOLx12	mDILI2=mDILI212	mSILIx=mSILIx12	;  
data dat2013; set herbspost; if year=2013; 
	 rename caco=cov13 mANGL2=mANGL213	mKRVIx=mKRVIx13	mCOERx=mCOERx13	mPABR2=mPABR213	mWAMAx=mWAMAx13	
mPASEC=mPASEC13	mARPUP=mARPUP13	mDITE2=mDITE213	mSOEL3=mSOEL313	mNUCAx=mNUCAx13	mCITE2=mCITE213	mPHAM4=mPHAM413	mTRUR2=mTRUR213
mPAPE5=mPAPE513	mCRGL2=mCRGL213	mPAHI1=mPAHI113	mCHTE1=mCHTE113	mPSOB3=mPSOB313	mSPCO1=mSPCO113	mFRFLx=mFRFLx13	mNELU2=mNELU213
mDICO6=mDICO613	mJUBRx=mJUBRx13	mCOBA2=mCOBA213	mDIOLS=mDIOLS13	mJUTEx=mJUTEx13	mDICA3=mDICA313	mERSEx=mERSEx13	mGYAMx=mGYAMx13
mSTPI3=mSTPI313	mLEHI2=mLEHI213	mCRSA4=mCRSA413	mERINx=mERINx13	mANVI2=mANVI213	mHERO2=mHERO213	mCAMU4=mCAMU413	mTRBI2=mTRBI213
mDIACx=mDIACx13	mTRPE4=mTRPE413	mPTAQx=mPTAQx13	mDIRAx=mDIRAx13	mLERE2=mLERE213	mPHCI4=mPHCI413	mSPCLx=mSPCLx13	mFIPUx=mFIPUx13
mCALE6=mCALE613	mHYDRx=mHYDRx13	mCRMO6=mCRMO613	mCYHYx=mCYHYx13	mSONU2=mSONU213	mNUTEx=mNUTEx13	mHYGL2=mHYGL213	mTRRA5=mTRRA513
mJUMA4=mJUMA413	mACGR2=mACGR213	mPASE5=mPASE513	mCYCR6=mCYCR613	mEUCO7=mEUCO713	mCYLU2=mCYLU213	mARLO1=mARLO113	mBUCA2=mBUCA213
mEUSEx=mEUSEx13	mEUCO1=mEUCO113	mGAREx=mGAREx13	mCEVI2=mCEVI213	mDISC3=mDISC313	mVUOCx=mVUOCx13	mBUCIx=mBUCIx13	mCYEC2=mCYEC213
mAGHYx=mAGHYx13	mDIOVx=mDIOVx13	mHEGEx=mHEGEx13	mDIAC2=mDIAC213	mGAPE2=mGAPE213	mOXDI2=mOXDI213	mCRDI1=mCRDI113	mDIVI7=mDIVI713
mCHPI8=mCHPI813	mRHHAx=mRHHAx13	mGAAN1=mGAAN113	mARDE3=mARDE313	mSCSCx=mSCSCx13	mLEMU3=mLEMU313	mSEARx=mSEARx13	mPAPL3=mPAPL313
mGAAR1=mGAAR113	mDIAN4=mDIAN413	mERSPx=mERSPx13	mCYRE5=mCYRE513	mCAMI8=mCAMI813	mSCCIx=mSCCIx13	mLEDUx=mLEDUx13	mCOCA5=mCOCA513	
mLETEx=mLETEx13	mPOPR4=mPOPR413	mDISP2=mDISP213	mHELA5=mHELA513	mDIOLx=mDIOLx13	mDILI2=mDILI213	mSILIx=mSILIx13; 
data dat2014; set herbspost; if year=2014; 
	 rename caco=cov14 mANGL2=mANGL214	mKRVIx=mKRVIx14	mCOERx=mCOERx14	mPABR2=mPABR214	mWAMAx=mWAMAx14	mPASEC=mPASEC14	
mARPUP=mARPUP14	mDITE2=mDITE214	mSOEL3=mSOEL314	mNUCAx=mNUCAx14	mCITE2=mCITE214	mPHAM4=mPHAM414	mTRUR2=mTRUR214	mPAPE5=mPAPE514	
mCRGL2=mCRGL214	mPAHI1=mPAHI114	mCHTE1=mCHTE114	mPSOB3=mPSOB314	mSPCO1=mSPCO114	mFRFLx=mFRFLx14	mNELU2=mNELU214	mDICO6=mDICO614	
mJUBRx=mJUBRx14	mCOBA2=mCOBA214	mDIOLS=mDIOLS14	mJUTEx=mJUTEx14	mDICA3=mDICA314	mERSEx=mERSEx14	mGYAMx=mGYAMx14	mSTPI3=mSTPI314	
mLEHI2=mLEHI214	mCRSA4=mCRSA414	mERINx=mERINx14	mANVI2=mANVI214	mHERO2=mHERO214	mCAMU4=mCAMU414	mTRBI2=mTRBI214	mDIACx=mDIACx14	
mTRPE4=mTRPE414	mPTAQx=mPTAQx14	mDIRAx=mDIRAx14	mLERE2=mLERE214	mPHCI4=mPHCI414	mSPCLx=mSPCLx14	mFIPUx=mFIPUx14	mCALE6=mCALE614	
mHYDRx=mHYDRx14	mCRMO6=mCRMO614	mCYHYx=mCYHYx14	mSONU2=mSONU214	mNUTEx=mNUTEx14	mHYGL2=mHYGL214	mTRRA5=mTRRA514	mJUMA4=mJUMA414	
mACGR2=mACGR214	mPASE5=mPASE514	mCYCR6=mCYCR614	mEUCO7=mEUCO714	mCYLU2=mCYLU214	mARLO1=mARLO114	mBUCA2=mBUCA214	mEUSEx=mEUSEx14	
mEUCO1=mEUCO114	mGAREx=mGAREx14	mCEVI2=mCEVI214	mDISC3=mDISC314	mVUOCx=mVUOCx14	mBUCIx=mBUCIx14	mCYEC2=mCYEC214	mAGHYx=mAGHYx14	
mDIOVx=mDIOVx14	mHEGEx=mHEGEx14	mDIAC2=mDIAC214	mGAPE2=mGAPE214	mOXDI2=mOXDI214	mCRDI1=mCRDI114	mDIVI7=mDIVI714	mCHPI8=mCHPI814	
mRHHAx=mRHHAx14	mGAAN1=mGAAN114	mARDE3=mARDE314	mSCSCx=mSCSCx14	mLEMU3=mLEMU314	mSEARx=mSEARx14	mPAPL3=mPAPL314	mGAAR1=mGAAR114	
mDIAN4=mDIAN414	mERSPx=mERSPx14	mCYRE5=mCYRE514	mCAMI8=mCAMI814	mSCCIx=mSCCIx14	mLEDUx=mLEDUx14	mCOCA5=mCOCA514	mLETEx=mLETEx14	
mPOPR4=mPOPR414	mDISP2=mDISP214	mHELA5=mHELA514	mDIOLx=mDIOLx14	mDILI2=mDILI214	mSILIx=mSILIx14;  
data dat2015; set herbspost; if year=2015; 
	 rename caco=cov15 mANGL2=mANGL215	mKRVIx=mKRVIx15	mCOERx=mCOERx15	mPABR2=mPABR215	mWAMAx=mWAMAx15	mPASEC=mPASEC15
mARPUP=mARPUP15	mDITE2=mDITE215	mSOEL3=mSOEL315	mNUCAx=mNUCAx15	mCITE2=mCITE215	mPHAM4=mPHAM415	mTRUR2=mTRUR215	mPAPE5=mPAPE515
mCRGL2=mCRGL215	mPAHI1=mPAHI115	mCHTE1=mCHTE115	mPSOB3=mPSOB315	mSPCO1=mSPCO115	mFRFLx=mFRFLx15	mNELU2=mNELU215	mDICO6=mDICO615	
mJUBRx=mJUBRx15	mCOBA2=mCOBA215	mDIOLS=mDIOLS15	mJUTEx=mJUTEx15	mDICA3=mDICA315	mERSEx=mERSEx15	mGYAMx=mGYAMx15	mSTPI3=mSTPI315	
mLEHI2=mLEHI215	mCRSA4=mCRSA415	mERINx=mERINx15	mANVI2=mANVI215	mHERO2=mHERO215	mCAMU4=mCAMU415	mTRBI2=mTRBI215	mDIACx=mDIACx15
mTRPE4=mTRPE415	mPTAQx=mPTAQx15	mDIRAx=mDIRAx15	mLERE2=mLERE215	mPHCI4=mPHCI415	mSPCLx=mSPCLx15	mFIPUx=mFIPUx15	mCALE6=mCALE615
mHYDRx=mHYDRx15	mCRMO6=mCRMO615	mCYHYx=mCYHYx15	mSONU2=mSONU215	mNUTEx=mNUTEx15	mHYGL2=mHYGL215	mTRRA5=mTRRA515	mJUMA4=mJUMA415
mACGR2=mACGR215	mPASE5=mPASE515	mCYCR6=mCYCR615	mEUCO7=mEUCO715	mCYLU2=mCYLU215	mARLO1=mARLO115	mBUCA2=mBUCA215	mEUSEx=mEUSEx15
mEUCO1=mEUCO115	mGAREx=mGAREx15	mCEVI2=mCEVI215	mDISC3=mDISC315	mVUOCx=mVUOCx15	mBUCIx=mBUCIx15	mCYEC2=mCYEC215	mAGHYx=mAGHYx15
mDIOVx=mDIOVx15	mHEGEx=mHEGEx15	mDIAC2=mDIAC215	mGAPE2=mGAPE215	mOXDI2=mOXDI215	mCRDI1=mCRDI115	mDIVI7=mDIVI715	mCHPI8=mCHPI815
mRHHAx=mRHHAx15	mGAAN1=mGAAN115	mARDE3=mARDE315	mSCSCx=mSCSCx15	mLEMU3=mLEMU315	mSEARx=mSEARx15	mPAPL3=mPAPL315	mGAAR1=mGAAR115
mDIAN4=mDIAN415	mERSPx=mERSPx15	mCYRE5=mCYRE515	mCAMI8=mCAMI815	mSCCIx=mSCCIx15	mLEDUx=mLEDUx15	mCOCA5=mCOCA515	mLETEx=mLETEx15
mPOPR4=mPOPR415	mDISP2=mDISP215	mHELA5=mHELA515	mDIOLx=mDIOLx15	mDILI2=mDILI215	mSILIx=mSILIx15; 
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
*proc print data=herbmerge2 (firstobs=1 obs=20); title 'herbmerge2'; run; 
*prefavg n=29, dat2012 n=32, dat2013 n=46, dat2014 n=46, dat2015 n=46, herbmerge2 n=55;

/*
proc export data=herbmerge2
   outfile='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\seedsmerge2.csv'
   dbms=csv
   replace;
run;
*/

