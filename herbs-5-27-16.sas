proc print data=herb6 (firstobs=1 obs=20); title 'herb6'; run;
data herb1; set herbx;
	if sspp='     ' then delete;
	if year=1999 	then delete;
  	type = 1;     		  			  	 * default - it is a plant;
 	if (sspp = 'XXXXx') then type = 2;   * type 2 means non-plant;
	keep aspect bcat coun quad covm elev hydrn plot slope soileb sspp year prpo type; 
run; *n=12,544;
proc sort data=herb1; by plot sspp quad year bcat covm coun soileb elev slope aspect hydrn prpo type; run; 
*proc print data=herb1 (firstobs=1 obs=20); title 'herb1'; run;
proc means data=herb1 noprint sum; by plot sspp quad year bcat covm coun soileb elev slope aspect hydrn prpo type; var coun; 
  output out=herb2 sum=nperspp; run; *N=12535;

*reassigning nperspp. This gives num per species where each species has its own variable for count;
data holdANGL2; set herb2; if sspp='ANGL2'; nANGL2=nperspp; proc sort data=holdANGL2; by plot bcat year;
data holdKRVIx; set herb2; if sspp='KRVIx'; nKRVIx=nperspp; proc sort data=holdKRVIx; by plot bcat year;
data holdCOERx; set herb2; if sspp='COERx'; nCOERx=nperspp; proc sort data=holdCOERx; by plot bcat year;
data holdPABR2; set herb2; if sspp='PABR2'; nPABR2=nperspp; proc sort data=holdPABR2; by plot bcat year;
data holdWAMAx; set herb2; if sspp='WAMAx'; nWAMAx=nperspp; proc sort data=holdWAMAx; by plot bcat year;
data holdPASEC; set herb2; if sspp='PASEC'; nPASEC=nperspp; proc sort data=holdPASEC; by plot bcat year;
data holdSILIx; set herb2; if sspp='SILIx'; nSILIx=nperspp; proc sort data=holdSILIx; by plot bcat year;
data holdARPUP; set herb2; if sspp='ARPUP'; nARPUP=nperspp; proc sort data=holdARPUP; by plot bcat year;
data holdDITE2; set herb2; if sspp='DITE2'; nDITE2=nperspp; proc sort data=holdDITE2; by plot bcat year;
data holdSOEL3; set herb2; if sspp='SOEL3'; nSOEL3=nperspp; proc sort data=holdSOEL3; by plot bcat year;
data holdNUCAx; set herb2; if sspp='NUCAx'; nNUCAx=nperspp; proc sort data=holdNUCAx; by plot bcat year;
data holdCITE2; set herb2; if sspp='CITE2'; nCITE2=nperspp; proc sort data=holdCITE2; by plot bcat year;
data holdPHAM4; set herb2; if sspp='PHAM4'; nPHAM4=nperspp; proc sort data=holdPHAM4; by plot bcat year;
data holdTRUR2; set herb2; if sspp='TRUR2'; nTRUR2=nperspp; proc sort data=holdTRUR2; by plot bcat year;
data holdPAPE5; set herb2; if sspp='PAPE5'; nPAPE5=nperspp; proc sort data=holdPAPE5; by plot bcat year;
data holdCRGL2; set herb2; if sspp='CRGL2'; nCRGL2=nperspp; proc sort data=holdCRGL2; by plot bcat year;
data holdPAHI1; set herb2; if sspp='PAHI1'; nPAHI1=nperspp; proc sort data=holdPAHI1; by plot bcat year;
data holdCHTE1; set herb2; if sspp='CHTE1'; nCHTE1=nperspp; proc sort data=holdCHTE1; by plot bcat year;
data holdPSOB3; set herb2; if sspp='PSOB3'; nPSOB3=nperspp; proc sort data=holdPSOB3; by plot bcat year;
data holdSPCO1; set herb2; if sspp='SPCO1'; nSPCO1=nperspp; proc sort data=holdSPCO1; by plot bcat year;
data holdFRFLx; set herb2; if sspp='FRFLx'; nFRFLx=nperspp; proc sort data=holdFRFLx; by plot bcat year;
data holdNELU2; set herb2; if sspp='NELU2'; nNELU2=nperspp; proc sort data=holdNELU2; by plot bcat year;
data holdDICO6; set herb2; if sspp='DICO6'; nDICO6=nperspp; proc sort data=holdDICO6; by plot bcat year;
data holdJUBRx; set herb2; if sspp='JUBRx'; nJUBRx=nperspp; proc sort data=holdJUBRx; by plot bcat year;
data holdCOBA2; set herb2; if sspp='COBA2'; nCOBA2=nperspp; proc sort data=holdCOBA2; by plot bcat year;
data holdDIOLS; set herb2; if sspp='DIOLS'; nDIOLS=nperspp; proc sort data=holdDIOLS; by plot bcat year;
data holdJUTEx; set herb2; if sspp='JUTEx'; nJUTEx=nperspp; proc sort data=holdJUTEx; by plot bcat year;
data holdDICA3; set herb2; if sspp='DICA3'; nDICA3=nperspp; proc sort data=holdDICA3; by plot bcat year;
data holdERSEx; set herb2; if sspp='ERSEx'; nERSEx=nperspp; proc sort data=holdERSEx; by plot bcat year;
data holdGYAMx; set herb2; if sspp='GYAMx'; nGYAMx=nperspp; proc sort data=holdGYAMx; by plot bcat year;
data holdSTPI3; set herb2; if sspp='STPI3'; nSTPI3=nperspp; proc sort data=holdSTPI3; by plot bcat year;
data holdLEHI2; set herb2; if sspp='LEHI2'; nLEHI2=nperspp; proc sort data=holdLEHI2; by plot bcat year;
data holdCRSA4; set herb2; if sspp='CRSA4'; nCRSA4=nperspp; proc sort data=holdCRSA4; by plot bcat year;
data holdERINx; set herb2; if sspp='ERINx'; nERINx=nperspp; proc sort data=holdERINx; by plot bcat year;
data holdANVI2; set herb2; if sspp='ANVI2'; nANVI2=nperspp; proc sort data=holdANVI2; by plot bcat year;
data holdHERO2; set herb2; if sspp='HERO2'; nHERO2=nperspp; proc sort data=holdHERO2; by plot bcat year;
data holdCAMU4; set herb2; if sspp='CAMU4'; nCAMU4=nperspp; proc sort data=holdCAMU4; by plot bcat year;
data holdTRBI2; set herb2; if sspp='TRBI2'; nTRBI2=nperspp; proc sort data=holdTRBI2; by plot bcat year;
data holdDIACx; set herb2; if sspp='DIACx'; nDIACx=nperspp; proc sort data=holdDIACx; by plot bcat year;
data holdTRPE4; set herb2; if sspp='TRPE4'; nTRPE4=nperspp; proc sort data=holdTRPE4; by plot bcat year;
data holdPTAQx; set herb2; if sspp='PTAQx'; nPTAQx=nperspp; proc sort data=holdPTAQx; by plot bcat year;
data holdDIRAx; set herb2; if sspp='DIRAx'; nDIRAx=nperspp; proc sort data=holdDIRAx; by plot bcat year;
data holdLERE2; set herb2; if sspp='LERE2'; nLERE2=nperspp; proc sort data=holdLERE2; by plot bcat year;
data holdPHCI4; set herb2; if sspp='PHCI4'; nPHCI4=nperspp; proc sort data=holdPHCI4; by plot bcat year;
data holdSPCLx; set herb2; if sspp='SPCLx'; nSPCLx=nperspp; proc sort data=holdSPCLx; by plot bcat year;
data holdFIPUx; set herb2; if sspp='FIPUx'; nFIPUx=nperspp; proc sort data=holdFIPUx; by plot bcat year;
data holdCALE6; set herb2; if sspp='CALE6'; nCALE6=nperspp; proc sort data=holdCALE6; by plot bcat year;
data holdHYDRx; set herb2; if sspp='HYDRx'; nHYDRx=nperspp; proc sort data=holdHYDRx; by plot bcat year;
data holdCRMO6; set herb2; if sspp='CRMO6'; nCRMO6=nperspp; proc sort data=holdCRMO6; by plot bcat year;
data holdCYHYx; set herb2; if sspp='CYHYx'; nCYHYx=nperspp; proc sort data=holdCYHYx; by plot bcat year;
data holdSONU2; set herb2; if sspp='SONU2'; nSONU2=nperspp; proc sort data=holdSONU2; by plot bcat year;
data holdNUTEx; set herb2; if sspp='NUTEx'; nNUTEx=nperspp; proc sort data=holdNUTEx; by plot bcat year;
data holdHYGL2; set herb2; if sspp='HYGL2'; nHYGL2=nperspp; proc sort data=holdHYGL2; by plot bcat year;
data holdTRRA5; set herb2; if sspp='TRRA5'; nTRRA5=nperspp; proc sort data=holdTRRA5; by plot bcat year;
data holdJUMA4; set herb2; if sspp='JUMA4'; nJUMA4=nperspp; proc sort data=holdJUMA4; by plot bcat year;
data holdACGR2; set herb2; if sspp='ACGR2'; nACGR2=nperspp; proc sort data=holdACGR2; by plot bcat year;
data holdPASE5; set herb2; if sspp='PASE5'; nPASE5=nperspp; proc sort data=holdPASE5; by plot bcat year;
data holdCYCR6; set herb2; if sspp='CYCR6'; nCYCR6=nperspp; proc sort data=holdCYCR6; by plot bcat year;
data holdEUCO7; set herb2; if sspp='EUCO7'; nEUCO7=nperspp; proc sort data=holdEUCO7; by plot bcat year;
data holdCYLU2; set herb2; if sspp='CYLU2'; nCYLU2=nperspp; proc sort data=holdCYLU2; by plot bcat year;
data holdARLO1; set herb2; if sspp='ARLO1'; nARLO1=nperspp; proc sort data=holdARLO1; by plot bcat year;
data holdBUCA2; set herb2; if sspp='BUCA2'; nBUCA2=nperspp; proc sort data=holdBUCA2; by plot bcat year;
data holdEUSEx; set herb2; if sspp='EUSEx'; nEUSEx=nperspp; proc sort data=holdEUSEx; by plot bcat year;
data holdEUCO1; set herb2; if sspp='EUCO1'; nEUCO1=nperspp; proc sort data=holdEUCO1; by plot bcat year;
data holdGAREx; set herb2; if sspp='GAREx'; nGAREx=nperspp; proc sort data=holdGAREx; by plot bcat year;
data holdCEVI2; set herb2; if sspp='CEVI2'; nCEVI2=nperspp; proc sort data=holdCEVI2; by plot bcat year;
data holdDISC3; set herb2; if sspp='DISC3'; nDISC3=nperspp; proc sort data=holdDISC3; by plot bcat year;
data holdVUOCx; set herb2; if sspp='VUOCx'; nVUOCx=nperspp; proc sort data=holdVUOCx; by plot bcat year;
data holdBUCIx; set herb2; if sspp='BUCIx'; nBUCIx=nperspp; proc sort data=holdBUCIx; by plot bcat year;
data holdCYEC2; set herb2; if sspp='CYEC2'; nCYEC2=nperspp; proc sort data=holdCYEC2; by plot bcat year;
data holdAGHYx; set herb2; if sspp='AGHYx'; nAGHYx=nperspp; proc sort data=holdAGHYx; by plot bcat year;
data holdDIOVx; set herb2; if sspp='DIOVx'; nDIOVx=nperspp; proc sort data=holdDIOVx; by plot bcat year;
data holdHEGEx; set herb2; if sspp='HEGEx'; nHEGEx=nperspp; proc sort data=holdHEGEx; by plot bcat year;
data holdDIAC2; set herb2; if sspp='DIAC2'; nDIAC2=nperspp; proc sort data=holdDIAC2; by plot bcat year;
data holdGAPE2; set herb2; if sspp='GAPE2'; nGAPE2=nperspp; proc sort data=holdGAPE2; by plot bcat year;
data holdOXDI2; set herb2; if sspp='OXDI2'; nOXDI2=nperspp; proc sort data=holdOXDI2; by plot bcat year;
data holdCRDI1; set herb2; if sspp='CRDI1'; nCRDI1=nperspp; proc sort data=holdCRDI1; by plot bcat year;
data holdDIVI7; set herb2; if sspp='DIVI7'; nDIVI7=nperspp; proc sort data=holdDIVI7; by plot bcat year;
data holdCHPI8; set herb2; if sspp='CHPI8'; nCHPI8=nperspp; proc sort data=holdCHPI8; by plot bcat year;
data holdRHHAx; set herb2; if sspp='RHHAx'; nRHHAx=nperspp; proc sort data=holdRHHAx; by plot bcat year;
data holdGAAN1; set herb2; if sspp='GAAN1'; nGAAN1=nperspp; proc sort data=holdGAAN1; by plot bcat year;
data holdARDE3; set herb2; if sspp='ARDE3'; nARDE3=nperspp; proc sort data=holdARDE3; by plot bcat year;
data holdSCSCx; set herb2; if sspp='SCSCx'; nSCSCx=nperspp; proc sort data=holdSCSCx; by plot bcat year;
data holdLEMU3; set herb2; if sspp='LEMU3'; nLEMU3=nperspp; proc sort data=holdLEMU3; by plot bcat year;
data holdSEARx; set herb2; if sspp='SEARx'; nSEARx=nperspp; proc sort data=holdSEARx; by plot bcat year;
data holdPAPL3; set herb2; if sspp='PAPL3'; nPAPL3=nperspp; proc sort data=holdPAPL3; by plot bcat year;
data holdGAAR1; set herb2; if sspp='GAAR1'; nGAAR1=nperspp; proc sort data=holdGAAR1; by plot bcat year;
data holdDIAN4; set herb2; if sspp='DIAN4'; nDIAN4=nperspp; proc sort data=holdDIAN4; by plot bcat year;
data holdERSPx; set herb2; if sspp='ERSPx'; nERSPx=nperspp; proc sort data=holdERSPx; by plot bcat year;
data holdCYRE5; set herb2; if sspp='CYRE5'; nCYRE5=nperspp; proc sort data=holdCYRE5; by plot bcat year;
data holdCAMI8; set herb2; if sspp='CAMI8'; nCAMI8=nperspp; proc sort data=holdCAMI8; by plot bcat year;
data holdSCCIx; set herb2; if sspp='SCCIx'; nSCCIx=nperspp; proc sort data=holdSCCIx; by plot bcat year;
data holdLEDUx; set herb2; if sspp='LEDUx'; nLEDUx=nperspp; proc sort data=holdLEDUx; by plot bcat year;
data holdCOCA5; set herb2; if sspp='COCA5'; nCOCA5=nperspp; proc sort data=holdCOCA5; by plot bcat year;
data holdLETEx; set herb2; if sspp='LETEx'; nLETEx=nperspp; proc sort data=holdLETEx; by plot bcat year;
data holdPOPR4; set herb2; if sspp='POPR4'; nPOPR4=nperspp; proc sort data=holdPOPR4; by plot bcat year;
data holdDISP2; set herb2; if sspp='DISP2'; nDISP2=nperspp; proc sort data=holdDISP2; by plot bcat year;
data holdHELA5; set herb2; if sspp='HELA5'; nHELA5=nperspp; proc sort data=holdHELA5; by plot bcat year;
data holdDIOLx; set herb2; if sspp='DIOLx'; nDIOLx=nperspp; proc sort data=holdDIOLx; by plot bcat year;
data holdDILI2; set herb2; if sspp='DILI2'; nDILI2=nperspp; proc sort data=holdDILI2; by plot bcat year;
run;

proc sort data=herb2; by plot bcat year; run;
*n(spp) is count, pa(spp) is presence/absence;
data herb3; merge holdANGL2	holdKRVIx	holdCOERx	holdPABR2	holdWAMAx	holdPASEC	holdSILIx	
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
				  holdDIOLx	holdDILI2 herb2; by plot bcat year;
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
  drop _TYPE_ _FREQ_ sspp nperspp;  * dropping sspp & nperspp - become garbage;
run;
* N = 12535; 

data herb4; set herb3; 	
	keep plot quad year bcat covm coun soileb elev slope aspect hydrn prpo type nANGL2	nKRVIx	
	nCOERx	nPABR2	nWAMAx	nPASEC	nSILIx	nARPUP	nDITE2	nSOEL3	nNUCAx	nCITE2	nPHAM4	nTRUR2	
	nPAPE5	nCRGL2	nPAHI1	nCHTE1	nPSOB3	nSPCO1	nFRFLx	nNELU2	nDICO6	nJUBRx	nCOBA2	nDIOLS	
	nJUTEx	nDICA3	nERSEx	nGYAMx	nSTPI3	nLEHI2	nCRSA4	nERINx	nANVI2	nHERO2	nCAMU4	nTRBI2	
	nDIACx	nTRPE4	nPTAQx	nDIRAx	nLERE2	nPHCI4	nSPCLx	nFIPUx	nCALE6	nHYDRx	nCRMO6	nCYHYx	
	nSONU2	nNUTEx	nHYGL2	nTRRA5	nJUMA4	nACGR2	nPASE5	nCYCR6	nEUCO7	nCYLU2	nARLO1	nBUCA2	
	nEUSEx	nEUCO1	nGAREx	nCEVI2	nDISC3	nVUOCx	nBUCIx	nCYEC2	nAGHYx	nDIOVx	nHEGEx	nDIAC2	
	nGAPE2	nOXDI2	nCRDI1	nDIVI7	nCHPI8	nRHHAx	nGAAN1	nARDE3	nSCSCx	nLEMU3	nSEARx	nPAPL3	
	nGAAR1	nDIAN4	nERSPx	nCYRE5	nCAMI8	nSCCIx	nLEDUx	nCOCA5	nLETEx	nPOPR4	nDISP2	nHELA5	
	nDIOLx	nDILI2;
run;  * N = 12535;
proc sort data=herb4; by plot quad year bcat covm coun soileb elev slope aspect hydrn prpo type; run;

*proc contents data=herb4; title 'herb4'; run; 

* Contents:
#   Variable    Type    Len    	Format     	Informat
1 	plot 		Num 	8 		BEST12. 	BEST32. 
12 	prpo 		Num 	8     
2 	quad 		Num 	8 		BEST12. 	BEST32. 
9 	slope 		Num 	8 		BEST12. 	BEST32. 
7 	soileb		Num 	8 		BEST12.		BEST32. 
13 	type 		Num 	8     
3 	year 		Num 	8 		BEST12. 	BEST32. 
10 	aspect 		Num 	8     
4 	bcat 		Num 	8     
6 	coun 		Num 	8 		BEST12. 	BEST32. 
5 	covm 		Num 	8 		BEST12. 	BEST32. 
8 	elev 		Num 	8		BEST12. 	BEST32. 
11 	hydrn 		Num 	8     
+all species variables
;

proc means data=herb4 mean noprint; by plot quad year bcat covm coun soileb aspect hydrn prpo type;
  var covm 	elev 	slope 	nANGL2	nKRVIx	
	nCOERx	nPABR2	nWAMAx	nPASEC	nSILIx	nARPUP	nDITE2	nSOEL3	nNUCAx	nCITE2	nPHAM4	nTRUR2	
	nPAPE5	nCRGL2	nPAHI1	nCHTE1	nPSOB3	nSPCO1	nFRFLx	nNELU2	nDICO6	nJUBRx	nCOBA2	nDIOLS	
	nJUTEx	nDICA3	nERSEx	nGYAMx	nSTPI3	nLEHI2	nCRSA4	nERINx	nANVI2	nHERO2	nCAMU4	nTRBI2	
	nDIACx	nTRPE4	nPTAQx	nDIRAx	nLERE2	nPHCI4	nSPCLx	nFIPUx	nCALE6	nHYDRx	nCRMO6	nCYHYx	
	nSONU2	nNUTEx	nHYGL2	nTRRA5	nJUMA4	nACGR2	nPASE5	nCYCR6	nEUCO7	nCYLU2	nARLO1	nBUCA2	
	nEUSEx	nEUCO1	nGAREx	nCEVI2	nDISC3	nVUOCx	nBUCIx	nCYEC2	nAGHYx	nDIOVx	nHEGEx	nDIAC2	
	nGAPE2	nOXDI2	nCRDI1	nDIVI7	nCHPI8	nRHHAx	nGAAN1	nARDE3	nSCSCx	nLEMU3	nSEARx	nPAPL3	
	nGAAR1	nDIAN4	nERSPx	nCYRE5	nCAMI8	nSCCIx	nLEDUx	nCOCA5	nLETEx	nPOPR4	nDISP2	nHELA5	
	nDIOLx	nDILI2;
  output out=herb5 mean = mcov elev slope 	mANGL2	mKRVIx	mCOERx	mPABR2	mWAMAx	mPASEC		
	mARPUP	mDITE2	mSOEL3	mNUCAx	mCITE2	mPHAM4	mTRUR2	mPAPE5	mCRGL2	mPAHI1	mCHTE1	mPSOB3	
	mSPCO1	mFRFLx	mNELU2	mDICO6	mJUBRx	mCOBA2	mDIOLS	mJUTEx	mDICA3	mERSEx	mGYAMx	mSTPI3	
	mLEHI2	mCRSA4	mERINx	mANVI2	mHERO2	mCAMU4	mTRBI2	mDIACx	mTRPE4	mPTAQx	mDIRAx	mLERE2	
	mPHCI4	mSPCLx	mFIPUx	mCALE6	mHYDRx	mCRMO6	mCYHYx	mSONU2	mNUTEx	mHYGL2	mTRRA5	mJUMA4	
	mACGR2	mPASE5	mCYCR6	mEUCO7	mCYLU2	mARLO1	mBUCA2	mEUSEx	mEUCO1	mGAREx	mCEVI2	mDISC3	
	mVUOCx	mBUCIx	mCYEC2	mAGHYx	mDIOVx	mHEGEx	mDIAC2	mGAPE2	mOXDI2	mCRDI1	mDIVI7	mCHPI8	
	mRHHAx	mGAAN1	mARDE3	mSCSCx	mLEMU3	mSEARx	mPAPL3	mGAAR1	mDIAN4	mERSPx	mCYRE5	mCAMI8	
	mSCCIx	mLEDUx	mCOCA5	mLETEx	mPOPR4	mDISP2	mHELA5	mDIOLx	mDILI2	mSILIx;
run;
data herb6; set herb5; drop _TYPE_ coun covm; *N=10143;
*proc print data=herb6 (firstobs=1 obs=20); title 'herb6'; run; 
*proc contents data=herb6; run;

proc iml;

inputyrs = {2002, 2003, 2005, 2006, 2008, 2010, 2011, 2012, 2013, 2014, 2015};
nyrs = nrow(inputyrs);  * print nyrs; *11 yrs;

use herb6; read all into mat1;
* print mat1;

nrecords = nrow(mat1);   *print nrecords; *N = 10,143;

mat2 = j(nrecords,213,.); * create mat2 has 10,143 rows, 24 columns, each element=0;
do i = 1 to nrecords;    * record by record loop;
  do j = 1 to nyrs;      * yr by yr loop;
    if (mat1[i,1] = inputyrs[j]) then mat2[i,1] = j;  * pref in col 1;
  end;                   * end yr by yr loop;
end;                     * end yr by yr loop;
* print mat2;

* variables the same each year: plot, quad, slope, soileb, aspect, bcat, elev, hydrn,
  variables that change each year: _FREQ_, mcov, mcoun, year, mspecies;

*order of variables in mat1:					
1	plot, 2	quad, 3	year, 4	bcat, 5	soileb, 6	aspect, 7	hydrn, 8	prpo, 9	type, 10	_FREQ_,			
11	mcov, 12	elev, 13	slope;

* fill mat2; * col1 already has first yr;
do i = 1 to nrecords;    * record by record loop;
  time1 = mat2[i,1];
  time2 = time1 + 1;
  mat2[i,2] = time2;	
  mat2[i,3] = mat1[i,3];   * year1;
  mat2[i,5] = mat1[i,1];   * plot;
  mat2[i,6] = mat1[i,4];   * bcat;
  mat2[i,7] = mat1[i,6];   * aspect;
  mat2[i,8] = mat1[i,7];   * hydrn;
  mat2[i,9] = mat1[i,5];   * soileb;
  mat2[i,10] = mat1[i,12]; * elev;
  mat2[i,11] = mat1[i,13]; * slope;
  mat2[i,12] = mat1[i,11]; * mcov1;
  mat2[i,14]=mat1[i,14]; *mANGL2;
  mat2[i,16]=mat1[i,15]; *mKRVIx;
  mat2[i,18]=mat1[i,16]; *mCOERx;
  mat2[i,20]=mat1[i,17]; *mPABR2;
  mat2[i,22]=mat1[i,18]; *mWAMAx;
  mat2[i,24]=mat1[i,19]; *mPASEC;
  mat2[i,26]=mat1[i,20]; *mARPUP;
  mat2[i,28]=mat1[i,21]; *mDITE2;
  mat2[i,30]=mat1[i,22]; *mSOEL3;
  mat2[i,32]=mat1[i,23]; *mNUCAx;
  mat2[i,34]=mat1[i,24]; *mCITE2;
  mat2[i,36]=mat1[i,25]; *mPHAM4;
  mat2[i,38]=mat1[i,26]; *mTRUR2;
  mat2[i,40]=mat1[i,27]; *mPAPE5;
  mat2[i,42]=mat1[i,28]; *mCRGL2;
  mat2[i,44]=mat1[i,29]; *mPAHI1;
  mat2[i,46]=mat1[i,30]; *mCHTE1;
  mat2[i,48]=mat1[i,31]; *mPSOB3;
  mat2[i,50]=mat1[i,32]; *mSPCO1;
  mat2[i,52]=mat1[i,33]; *mFRFLx;
  mat2[i,54]=mat1[i,34]; *mNELU2;
  mat2[i,56]=mat1[i,35]; *mDICO6;
  mat2[i,58]=mat1[i,36]; *mJUBRx;
  mat2[i,60]=mat1[i,37]; *mCOBA2;
  mat2[i,62]=mat1[i,38]; *mDIOLS;
  mat2[i,64]=mat1[i,39]; *mJUTEx;
  mat2[i,66]=mat1[i,40]; *mDICA3;
  mat2[i,68]=mat1[i,41]; *mERSEx;
  mat2[i,70]=mat1[i,42]; *mGYAMx;
  mat2[i,72]=mat1[i,43]; *mSTPI3;
  mat2[i,74]=mat1[i,44]; *mLEHI2;
  mat2[i,76]=mat1[i,45]; *mCRSA4;
  mat2[i,78]=mat1[i,46]; *mERINx;
  mat2[i,80]=mat1[i,47]; *mANVI2;
  mat2[i,82]=mat1[i,48]; *mHERO2;
  mat2[i,84]=mat1[i,49]; *mCAMU4;
  mat2[i,86]=mat1[i,50]; *mTRBI2;
  mat2[i,88]=mat1[i,51]; *mDIACx;
  mat2[i,90]=mat1[i,52]; *mTRPE4;
  mat2[i,92]=mat1[i,53]; *mPTAQx;
  mat2[i,94]=mat1[i,54]; *mDIRAx;
  mat2[i,96]=mat1[i,55]; *mLERE2;
  mat2[i,98]=mat1[i,56]; *mPHCI4;
  mat2[i,100]=mat1[i,57]; *mSPCLx;
  mat2[i,102]=mat1[i,58]; *mFIPUx;
  mat2[i,104]=mat1[i,59]; *mCALE6;
  mat2[i,106]=mat1[i,60]; *mHYDRx;
  mat2[i,108]=mat1[i,61]; *mCRMO6;
  mat2[i,110]=mat1[i,62]; *mCYHYx;
  mat2[i,112]=mat1[i,63]; *mSONU2;
  mat2[i,114]=mat1[i,64]; *mNUTEx;
  mat2[i,116]=mat1[i,65]; *mHYGL2;
  mat2[i,118]=mat1[i,66]; *mTRRA5;
  mat2[i,120]=mat1[i,67]; *mJUMA4;
  mat2[i,122]=mat1[i,68]; *mACGR2;
  mat2[i,124]=mat1[i,69]; *mPASE5;
  mat2[i,126]=mat1[i,70]; *mCYCR6;
  mat2[i,128]=mat1[i,71]; *mEUCO7;
  mat2[i,130]=mat1[i,72]; *mCYLU2;
  mat2[i,132]=mat1[i,73]; *mARLO1;
  mat2[i,134]=mat1[i,74]; *mBUCA2;
  mat2[i,136]=mat1[i,75]; *mEUSEx;
  mat2[i,138]=mat1[i,76]; *mEUCO1;
  mat2[i,140]=mat1[i,77]; *mGAREx;
  mat2[i,142]=mat1[i,78]; *mCEVI2;
  mat2[i,144]=mat1[i,79]; *mDISC3;
  mat2[i,146]=mat1[i,80]; *mVUOCx;
  mat2[i,148]=mat1[i,81]; *mBUCIx;
  mat2[i,150]=mat1[i,82]; *mCYEC2;
  mat2[i,152]=mat1[i,83]; *mAGHYx;
  mat2[i,154]=mat1[i,84]; *mDIOVx;
  mat2[i,156]=mat1[i,85]; *mHEGEx;
  mat2[i,158]=mat1[i,86]; *mDIAC2;
  mat2[i,160]=mat1[i,87]; *mGAPE2;
  mat2[i,162]=mat1[i,88]; *mOXDI2;
  mat2[i,164]=mat1[i,89]; *mCRDI1;
  mat2[i,166]=mat1[i,90]; *mDIVI7;
  mat2[i,168]=mat1[i,91]; *mCHPI8;
  mat2[i,170]=mat1[i,92]; *mRHHAx;
  mat2[i,172]=mat1[i,93]; *mGAAN1;
  mat2[i,174]=mat1[i,94]; *mARDE3;
  mat2[i,176]=mat1[i,95]; *mSCSCx;
  mat2[i,178]=mat1[i,96]; *mLEMU3;
  mat2[i,180]=mat1[i,97]; *mSEARx;
  mat2[i,182]=mat1[i,98]; *mPAPL3;
  mat2[i,184]=mat1[i,99]; *mGAAR1;
  mat2[i,186]=mat1[i,100]; *mDIAN4;
  mat2[i,188]=mat1[i,101]; *mERSPx;
  mat2[i,190]=mat1[i,102]; *mCYRE5;
  mat2[i,192]=mat1[i,103]; *mCAMI8;
  mat2[i,194]=mat1[i,104]; *mSCCIx;
  mat2[i,196]=mat1[i,105]; *mLEDUx;
  mat2[i,198]=mat1[i,106]; *mCOCA5;
  mat2[i,200]=mat1[i,107]; *mLETEx;
  mat2[i,202]=mat1[i,108]; *mPOPR4;
  mat2[i,204]=mat1[i,109]; *mDISP2;
  mat2[i,206]=mat1[i,110]; *mHELA5;
  mat2[i,208]=mat1[i,111]; *mDIOLx;
  mat2[i,210]=mat1[i,112]; *mDILI2;
  mat2[i,212]=mat1[i,113]; *mSILIx;
end;
* print mat2;

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
* print mat2;

cnames1 = {	'time1', 'time2', 	'year1', 'year2', 	'plot', 'bcat', 	'aspect', 'hydr', 'soil', 'elev', 
'slope', 	'covm1', 'covm2', 	'ANGL1', 'ANGL2',	'KRVI1', 'KRVI2',	'COER1', 'COER2',	'PABR1', 
'PABR2',	'WAMA1', 'WAMA2',	'PASE1', 'PASE2',	'ARPU1', 'ARPU2',	'DITE1', 'DITE2',	'SOEL1', 
'SOEL2',	'NUCA1', 'NUCA2',	'CITE1', 'CITE2',	'PHAM1', 'PHAM2',	'TRUR1', 'TRUR2',	'PAPE1', 
'PAPE2',	'CRGL1', 'CRGL2',	'PAHI1', 'PAHI2',	'CHTE1', 'CHTE2',	'PSOB1', 'PSOB2',	'SPCO1', 
'SPCO2',	'FRFL1', 'FRFL2',	'NELU1', 'NELU2',	'DICO1', 'DICO2',	'JUBR1', 'JUBR2',	'COBA1', 
'COBA2',	'DIOL1', 'DIOL2',	'JUTE1', 'JUTE2',	'DICA1', 'DICA2',	'ERSE1', 'ERSE2',	'GYAM1', 
'GYAM2',	'STPI1', 'STPI2',	'LEHI1', 'LEHI2',	'CRSA1', 'CRSA2',	'ERIN1', 'ERIN2',	'ANVI1', 
'ANVI2',	'HERO1', 'HERO2',	'CAMU1', 'CAMU2',	'TRBI1', 'TRBI2',	'DIAC1', 'DIAC2',	'TRPE1', 
'TRPE2',	'PTAQ1', 'PTAQ2',	'DIRA1', 'DIRA2',	'LERE1', 'LERE2',	'PHCI1', 'PHCI2',	'SPCL1', 
'SPCL2',	'FIPU1', 'FIPU2',	'CALE1', 'CALE2',	'HYDR1', 'HYDR2',	'CRMO1', 'CRMO2',	'CYHY1', 
'CYHY2',	'SONU1', 'SONU2',	'NUTE1', 'NUTE2',	'HYGL1', 'HYGL2',	'TRRA1', 'TRRA2',	'JUMA1', 
'JUMA2',	'ACGR1', 'ACGR2',	'PASE1', 'PASE2',	'CYCR1', 'CYCR2',	'EUCO1', 'EUCO2',	'CYLU1', 
'CYLU2',	'ARLO1', 'ARLO2',	'BUCA1', 'BUCA2',	'EUSE1', 'EUSE2',	'EUCO1', 'EUCO2',	'GARE1', 
'GARE2',	'CEVI1', 'CEVI2',	'DISC1', 'DISC2',	'VUOC1', 'VUOC2',	'BUCI1', 'BUCI2',	'CYEC1', 
'CYEC2',	'AGHY1', 'AGHY2',	'DIOV1', 'DIOV2',	'HEGE1', 'HEGE2',	'DIAC1', 'DIAC2',	'GAPE1', 
'GAPE2',	'OXDI1', 'OXDI2',	'CRDI1', 'CRDI2',	'DIVI1', 'DIVI2',	'CHPI1', 'CHPI2',	'RHHA1', 
'RHHA2',	'GAAN1', 'GAAN2',	'ARDE1', 'ARDE2',	'SCSC1', 'SCSC2',	'LEMU1', 'LEMU2',	'SEAR1', 
'SEAR2',	'PAPL1', 'PAPL2',	'GAAR1', 'GAAR2',	'DIAN1', 'DIAN2',	'ERSP1', 'ERSP2',	'CYRE1', 
'CYRE2',	'CAMI1', 'CAMI2',	'SCCI1', 'SCCI2',	'LEDU1', 'LEDU2',	'COCA1', 'COCA2',	'LETE1', 
'LETE2',	'POPR1', 'POPR2',	'DISP1', 'DISP2',	'HELA1', 'HELA2',	'DIOL1', 'DIOL2',	'DILI1', 
'DILI2',	'SILI1', 'SILI2'};
create herbpairs from mat2 [colname = cnames1];
append from mat2;
 
quit; run;

/* 
proc print data=seedpairs; title 'seedpairs'; run; *N=267;
proc freq data=seedpairs; tables soil; run; 	   * 204 sand, 63 gravel;
*/
*******Need to fix height---right now, just one mean height for all species/plot/year;


*reorganizing seedpairs;
data seedpairspp; set seedpairs;
	if (year1<2011)  then yrcat='pref'; 
	if (year1>=2011) then yrcat='post';	
	drop time1 time2 year2 ilvo2 pita2 qum32 quma2 covm2 mhgt2; 
	rename year1=year covm1=caco ilvo1=ilvo pita1=pita qum31=qum3 quma1=quma mhgt1=heig;
run;
data seedspref;  set seedpairspp;
	if yrcat='pref';
run; *N=94;
data seedspost; set seedpairspp;
	if yrcat='post'; 
run; *N=173;
*pooling data in seedspre;
proc sort  data=seedspref; by plot bcat elev hydr slope soil aspect;
proc means data=seedspref n mean noprint; by plot bcat elev hydr slope soil aspect;
	var ilvo pita qum3 quma caco heig;
	output out=mseedspref n=nilv npit nqm3 nqma ncov nhgt 
		   			  mean=milv mpit mqm3 mqma mcov mhgt;
run;
*proc print data=mseedspref; title 'mseedspref'; run; *N=51;

*structure 1;
proc sort data=seedspost; by plot bcat elev hydr slope soil aspect;
proc sort data=mseedspref; by plot bcat elev hydr slope soil aspect; run;
data seedsmerge1; merge seedspost mseedspref; by plot bcat elev hydr slope soil aspect; 	
	drop _TYPE_ _FREQ_ yrcat; 
run;
*proc print data=seedsmerge1; title 'seedsmerge1'; run;	*N=179;
*proc contents data=seedsmerge1; run;


*structure 2;
proc sort data=seedspost; by plot year;	run;
data dat2012; set seedspost; if year=2012; 
	 rename pita=pita12sd quma=quma12sd ilvo=ilvo12sd qum3=qum312sd caco=cov12;  
data dat2013; set seedspost; if year=2013; 
	 rename pita=pita13sd quma=quma13sd ilvo=ilvo13sd qum3=qum313sd caco=cov13; 
data dat2014; set seedspost; if year=2014; 
	 rename pita=pita14sd quma=quma14sd ilvo=ilvo14sd qum3=qum314sd caco=cov14;  
data dat2015; set seedspost; if year=2015; 
	 rename pita=pita15sd quma=quma15sd ilvo=ilvo15sd qum3=qum315sd caco=cov15; 
data prefavg; set mseedspref; 
	 rename nilv=nilvopresd npit=npitapresd nqm3=nquma3presd nqma=nqumapresd ncov=ncovpre nhgt=nhgtpre 
		   	milv=milvopresd mpit=mpitapresd mqm3=mquma3presd mqma=mqumapresd mcov=mcovpre mhgt=mhgtpre;
run;
data seedsmerge2; merge prefavg dat2012 dat2013 dat2014 dat2015; by plot; drop year; run;
*proc print data=seedsmerge2; title 'seedsmerge2'; run; 
	*N=55----not 56 like all the others b/c 1226 was never surveyed for seedlings or shrubs;

proc freq data=seedsmerge2; tables bcat; run;

/*
proc export data=seedsmerge2
   outfile='\\austin.utexas.edu\disk\eb23667\ResearchSASFiles\seedsmerge2.csv'
   dbms=csv
   replace;
run;
*/

