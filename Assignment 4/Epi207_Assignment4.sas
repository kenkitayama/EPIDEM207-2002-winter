

/* Load data */
proc import datafile="C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 2\Data\pone.0248856.s001" dbms=xlsx out=data replace;
run;

proc contents data=data varnum;
run;

/*Setup data*/
/*Filter age 25-60 years and select needed varibles*/
DATA outdata;
	SET data;
	where 25<=age & age <=60;
	KEEP ID 
		 Sex 
		 Age 
		 HT 
		 ASM_Wt_
		 shx_smoke_yn
		 shx_alcohol_yn
		 mhx_HT_yn
		 bexam_BP_diastolic
		 bexam_BP_systolic;
RUN;

/*n=10759*/
PROC CONTENTS data=outdata VARNUM;
RUN;

/*Format data set*/

PROC FORMAT;
	value Sex 	1='Male'
				2='Female';
	value YN	0='No'
				1='Yes';
RUN;	

DATA outdata2;
	set outdata;
	MAP = bexam_BP_diastolic + (1/3 * (bexam_BP_systolic - bexam_BP_diastolic));
	ASM_10 = ASM_Wt_/10;
RUN;

PROC CONTENTS data=outdata2 VARNUM;
RUN;

DATA outdata_label;
SET outdata2;

Label	ID 					= "ID"
		Sex 				= "Sex (1=Male, 2=Female)"
		Age  				= "Age (years)"
		mhx_HT_yn			= "Medical history of hypertension"
		HT  				= "Hypertension (0=No, 1=Yes)"
		ASM_Wt_ 			= "Appendicular skeletal muscle mass (%)"
		shx_smoke_yn		= "History of smoking (0=No, 1=Yes)"
		shx_alcohol_yn 		= "History of alcohol intake (0=No, 1=Yes)"
		bexam_BP_diastolic 	= "Diastolic blood pressure (mmHg)"
		bexam_BP_systolic	= "Systolic blood pressure (mmHg)"
		MAP					= "Mean arterial blood pressure (mmHg)"
		ASM_10				= "Re-scaled ASM%, 1 unit = 10% ASM"
;
FORMAT 	Sex 				Sex.;
FORMAT	mhx_HT_yn--HT    	YN.;
FORMAT	shx_smoke_yn		YN.;
FORMAT	shx_alcohol_yn		YN.;
RUN;

PROC CONTENTS data=outdata_label VARNUM out=outdatalabdes;
RUN;

/*Descriptive statistics for codebook and Table 1*/
PROC FREQ data = outdata_label;
	TABLES 	Sex 
			mhx_HT_yn
			HT 
			shx_smoke_yn
			shx_alcohol_yn;
RUN;

PROC MEANS data = outdata_label n mean std median min max nmiss;
	var Age
		ASM_Wt_
		bexam_BP_diastolic
		bexam_BP_systolic
		MAP
		ASM_10;
RUN;

/* Logistic regressions (ASM% and HT) */
PROC LOGISTIC DATA=outdata_label;
TITLE "HTN: Crude Model";
MODEL HT (EVENT='Yes') = ASM_Wt_; 
RUN;
TITLE;

PROC LOGISTIC DATA=outdata_label;
TITLE "HTN: Model 1";
CLASS Sex (PARAM=REF REF='Female'); 
MODEL HT (EVENT='Yes') = ASM_Wt_ Sex Age; 
RUN;
TITLE;

PROC LOGISTIC DATA=outdata_label;
TITLE "HTN: Model 2";
CLASS Sex (PARAM=REF REF='Female') shx_smoke_yn (PARAM=REF REF='Yes') shx_alcohol_yn (PARAM=REF REF='Yes'); 
MODEL HT (EVENT='Yes') = ASM_Wt_ Sex Age shx_smoke_yn shx_alcohol_yn; 
RUN;
TITLE;


/* Linear regressions (ASM% and MAP) */
PROC REG DATA=outdata_label
  plots =(DiagnosticsPanel ResidualPlot(smooth));
TITLE "MAP: Crude Model";
MODEL MAP = ASM_10/clb; 
RUN;
QUIT;
TITLE;

PROC REG DATA=outdata_label
  plots =(DiagnosticsPanel ResidualPlot(smooth));
TITLE "MAP: Model 1";
MODEL MAP = ASM_10 Sex Age/clb; 
RUN;
QUIT;
TITLE;

PROC REG DATA=outdata_label;
TITLE "MAP: Model 2"
  plots =(DiagnosticsPanel ResidualPlot(smooth));
MODEL MAP = ASM_10 Sex Age shx_smoke_yn shx_alcohol_yn/clb; 
RUN;
QUIT;
TITLE;

/* Sensitivity analysis for MAP linear regression, excluding history of HTN */
ods graphics on;
PROC REG DATA=outdata_label
  plots =(DiagnosticsPanel ResidualPlot(smooth));
TITLE "MAP: Crude Model";
MODEL MAP = ASM_10/clb; 
RUN;
QUIT;
TITLE;

ods graphics on;
PROC REG DATA=outdata_label
  plots =(DiagnosticsPanel ResidualPlot(smooth));
TITLE "MAP: Model 1";
MODEL MAP = ASM_10 Sex Age/clb; 
RUN;
QUIT;
TITLE;

ods graphics on
  plots =(DiagnosticsPanel ResidualPlot(smooth));
PROC REG DATA=outdata_label;
TITLE "MAP: Model 2";
MODEL MAP = ASM_10 Sex Age shx_smoke_yn shx_alcohol_yn/clb; 
RUN;
QUIT;
TITLE;

/* Data visualization (Figure 3) */

proc sgplot data=outdata_label;
title "Scatterplot ASM & MAP by Sex";
  reg x=ASM_Wt_ y=MAP / group=Sex;
run;
title;

proc univariate data=outdata_label;
histogram;
var ASM_Wt_;
run;

proc univariate data=outdata_label;
histogram;
var MAP;
run;

proc univariate data=outdata_label;
histogram;
var ASM_10;
run;

/* ASM% quintiles analysis */

PROC FORMAT;
	value Quint 1='Quintile 1'
				2='Quintile 2'
				3='Quintile 3'
				4='Quintile 4'
				5='Quintile5';
RUN;	

proc means data=outdata_label min p20 p40 p60 p80 max;
var ASM_Wt_;
run;

data outdata_label2;
   set outdata_label;
ASM5=.;
if ASM_Wt_ < 27.1135940 then ASM5=1;
if ASM_Wt_ >= 27.1135940 & ASM_Wt_ < 29.3322204 then ASM5=2;
if ASM_Wt_ >= 29.3322204 & ASM_Wt_ < 31.2752525 then ASM5=3;
if ASM_Wt_ >= 31.2752525 & ASM_Wt_ < 33.2106038 then ASM5=4;
if ASM_Wt_ >= 33.2106038 then ASM5=5;
label	ASM5 = "ASM% Quintiles";
format ASM5 Quint.;
run;

PROC CONTENTS data=outdata_label2 VARNUM;
RUN;

PROC FREQ data = outdata_label2;
	TABLES 	ASM5;
RUN;

PROC FREQ data = outdata_label2;
	TABLES 	ASM5*HT;
RUN;

PROC LOGISTIC DATA=outdata_label2;
TITLE "HTN: Crude Model";
CLASS ASM5 (PARAM=REF REF='Quintile 1'); 
MODEL HT (EVENT='Yes') = ASM5; 
RUN;
TITLE;

PROC LOGISTIC DATA=outdata_label2;
TITLE "HTN: Model 1";
CLASS Sex (PARAM=REF REF='Female') ASM5 (PARAM=REF REF='Quintile 1'); 
MODEL HT (EVENT='Yes') = ASM5 Sex Age; 
RUN;
TITLE;

PROC LOGISTIC DATA=outdata_label2;
TITLE "HTN: Model 2";
CLASS Sex (PARAM=REF REF='Female') shx_smoke_yn (PARAM=REF REF='Yes') shx_alcohol_yn (PARAM=REF REF='Yes') ASM5 (PARAM=REF REF='Quintile 1'); 
MODEL HT (EVENT='Yes') = ASM5 Sex Age shx_smoke_yn shx_alcohol_yn; 
RUN;
TITLE;

ods graphics on;
PROC LOGISTIC DATA=outdata_label2;
TITLE "HTN: Model 1";
CLASS Sex (PARAM=REF REF='Female') ASM5 (PARAM=REF REF='Quintile 1'); 
MODEL HT (EVENT='Yes') = ASM5 Sex; 
effectplot/clm alpha=0.05;
RUN;
TITLE;
ods graphics off;
