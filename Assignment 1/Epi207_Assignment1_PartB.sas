/*****************************************************************************
NAME: Epi207_Assignment1_PartB.sas
DATE: 01/19/2022
CREATED BY: Ken Kitayama 
PURPOSE: To complete tasks for Assignment 1 Part B
******************************************************************************/

/* Import dataset */
LIBNAME project1 "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1";

PROC IMPORT OUT= project1.kim2021 
			DATAFILE= "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\pone.0248856.s001.xlsx" 
            DBMS=xlsx REPLACE;
     GETNAMES=YES;
RUN;

/* Keep only variables in Table 1 */
DATA project1.kim2021_1;
	SET project1.kim2021 (KEEP = ID Sex Age bexam_wt bexam_BMI bexam_wc bexam_BP_systolic bexam_BP_diastolic VFA_cm2 ASM_kg ASM_Wt_ chol HDL LDL TG glu GOT GPT uric_acid HbA1c insulin CRP MS HT DM Obesity shx_smoke_yn shx_alcohol_yn);
RUN;

/* Create values */
OPTIONS FMTSEARCH=(project1);
PROC FORMAT LIBRARY=project1; 
	VALUE yesnofmt		 1 = 'Yes'
						 0 = 'No';
    VALUE sexfmt		 1 = 'Male'
		  				 2 = 'Female';
RUN;


DATA project1.project1B;
	SET project1.kim2021_1;
/* Create homa_ir, Overweight_BMI, Normal_BMI, and Underweight_BMI variables */
homa_ir = (glu*insulin)/405;
IF bexam_BMI >=23 & bexam_BMI <25 THEN Overweight_BMI = 1;
ELSE IF bexam_BMI ne . THEN Overweight_BMI = 0;
IF bexam_BMI >=18.5 & bexam_BMI <23 THEN Normal_BMI = 1;
ELSE IF bexam_BMI ne . THEN Normal_BMI = 0; 
IF bexam_BMI <18.5 THEN Underweight_BMI = 1;
ELSE IF bexam_BMI ne . THEN Underweight_BMI = 0; 
/* Label variables */
	LABEL		          ID = "ID"
						 Sex = "Sex"
						 Age = "Age (years)"
		            bexam_wt = "Weight (kg)"	
		           bexam_BMI = "BMI, (kg/m^2)"
	                bexam_wc = "Waist circumference (cm)"
           bexam_BP_systolic = "Systolic blood pressure (mmHg)"	
		  bexam_BP_diastolic = "Diastolic blood pressure (mmHg)"
		             VFA_cm2 = "Visceral fat area (cm^2)"
					  ASM_kg = "ASM (kg)"
					 ASM_Wt_ = "ASM%"
					    chol = "Cholesterol (mg/dL)"
						 HDL = "HDL (mg/dL)"
						 LDL = "LDL (mg/dL)"
						  TG = "Triglyceride (mg/dL)"
						 glu = "Glucose (mg/dL)"
						 GOT = "AST (IU/L)" /* Note: AST = GOT; ALT = GPT; see: PMC3894536 */
						 GPT = "ALT (IU/L)"
				   uric_acid = "Uric acid (mg/dL)"
				       HbA1c = "HbAc (%)"
				     insulin = "Insulin"
					 homa_ir = "HOMA-IR"
					     CRP = "C-reactive protein (mg/dL)"
						  MS = "Metabolic syndrome"
						  HT = "Hypertension"
				   		  DM = "Diabetes mellitus"
					 Obesity = "Obesity (BMI >=25 kg/m^2)"
			  Overweight_BMI = "Overweight (BMI 23-24.9 kg/m^2)"
			      Normal_BMI = "Normal (BMI 18.5-22.9 kg/m^2)"
		     Underweight_BMI = "Underweight (BMI < 18.5 kg/m^2)"
			    shx_smoke_yn = "Smoking"
			  shx_alcohol_yn = "Alcohol intake";
FORMAT Sex sexfmt. MS HT DM Obesity Overweight_BMI Normal_BMI Underweight_BMI shx_smoke_yn shx_alcohol_yn yesnofmt.;
RUN;

/* Create data dictionary */
DATA project1.project1B_1;
	SET project1.project1B;
RUN;
PROC DATASETS LIBRARY=project1;
	MODIFY project1B_1;
	XATTR SET VAR
		Age (Unit = "years")
		bexam_wt (Unit = "kg")
		bexam_BMI (Unit = "kg/m^2") 
		bexam_wc (Unit = "cm")
		bexam_BP_systolic (Unit = "mmHg")
		bexam_BP_diastolic (Unit = "mmHg")
		VFA_cm2 (Unit = "cm^2")
		ASM_kg (Unit = "kg")
		ASM_Wt_ (Unit = "%")
		chol (Unit = "mg/dL")
		HDL (Unit = "mg/dL")
		LDL (Unit = "mg/dL")
		TG (Unit = "mg/dL")
		glu (Unit = "mg/dL")
		GOT (Unit = "IU/L")
		GPT (Unit = "IU/L")
		uric_acid (Unit = "mg/dL")  
		HbA1c (Unit = "%")
		insulin (Unit = "microU/mL")
		CRP (Unit = "mg/dL")
		Sex (ValidValues = "1 = Male, 2 = Female")
		MS (ValidValues = "1 = Yes, 0 = No")
		HT (ValidValues = "1 = Yes, 0 = No")
		DM (ValidValues = "1 = Yes, 0 = No")
		Obesity (ValidValues = "1 = Yes, 0 = No")
		Overweight_BMI (ValidValues = "1 = Yes, 0 = No")
		Normal_BMI (ValidValues = "1 = Yes, 0 = No")
		Underweight_BMI (ValidValues = "1 = Yes, 0 = No")
		shx_smoke_yn (ValidValues = "1 = Yes, 0 = No")
		shx_alcohol_yn (ValidValues = "1 = Yes, 0 = No");
RUN;
QUIT;

ODS OUTPUT variables=varlist;
ODS OUTPUT ExtendedAttributesVar=varlist2;
PROC CONTENTS DATA=project1.project1B_1; 
RUN;

PROC SORT DATA=varlist2; 
	BY attributevariable; 
RUN;

PROC TRANSPOSE DATA=varlist2 OUT=varlist2B;
	BY attributevariable;
	ID extendedattribute;
	VAR attributecharvalue;
RUN;

PROC SQL;
CREATE TABLE datadictionaryB AS
	SELECT v.num LABEL='#',
	v.variable LABEL='Variable',
	v.type LABEL = 'Type',
	v.len LABEL = 'Length',
	v.label LABEL='Label',
	x.validvalues LABEL='Valid values',
	x.unit LABEL='Unit of measurement'
FROM varlist AS v LEFT JOIN varlist2b AS x
ON upcase(v.variable) = upcase(x.attributevariable);
QUIT;
ODS tagsets.excelxp FILE="C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\Data Dictionary B.xls" style=statistical;
PROC PRINT DATA=datadictionaryB NOOBS LABEL; 
RUN;
ODS tagsets.excelxp CLOSE;

/* Create codebook */

TITLE HEIGHT=12PT 'Master Codebook for Kim et al. 2021';
TITLE2 HEIGHT=10PT 'Association between sarcopenia level and metabolic syndrome';
/* LIBNAME library "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\Codebook"; */
 
%TK_codebook(lib=project1,
	file1=project1B,
	FMTLIB=project1,
	cb_type=RTF,
	cb_file=C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\Codebook\Codebook.rtf,
	var_order=INTERNAL,
	organization = One record per CASEID,
	include_warn=YES;)
RUN;


/* */
title height=12pt 'Master Codebook for Study A Preliminary Data';
title2 height=10pt 'Simulated Data for Participants in a Health Study';
title3 height=10pt 'Data simulated to include anomalies illustrating the power of %TK_codebook';
 
libname library "/Data_Detective/Formats/Blog_1_Codebooks";
 
%TK_codebook(lib=work,
	file1=STUDYA_PRELIM,
	fmtlib=LIBRARY,
	cb_type=RTF,
	cb_file=/Data_Detective/Book/Blog/SAS_Programs/My_Codebook.rtf,
	var_order=INTERNAL,
	organization = One record per CASEID,
	include_warn=YES;
run;
