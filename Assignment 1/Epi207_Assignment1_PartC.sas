/*****************************************************************************
NAME: Epi207_Assignment1_PartC.sas
DATE: 01/26/2022
CREATED BY: Ken Kitayama 
PURPOSE: To complete tasks for Assignment 1 Part C
******************************************************************************/

/* Note: a HUGE "Thank You!" to Tahmineh Romero for helping me with the code, especially macros for Tables 2-5 and PROC SGPLOT for figures */

/* Import dataset */
LIBNAME project1 "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1";

PROC IMPORT OUT= project1.kim2021 
			DATAFILE= "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\pone.0248856.s001.xlsx" 
            DBMS=xlsx REPLACE;
     GETNAMES=YES;
RUN;

/* Keep only variables in Table 1 */
DATA project1.kim2021_1;
	SET project1.kim2021 (KEEP = ID Sex Age bexam_wt bexam_BMI bexam_wc bexam_BP_systolic bexam_BP_diastolic VFA_cm2 ASM_kg ASM_Wt_ chol HDL LDL TG glu GOT GPT uric_acid HbA1c insulin CRP MS HT DM Obesity shx_smoke_yn shx_alcohol_yn Sarco_ASM_Wt_ DysL_ VFA_cm2 MS_5cri);
RUN;

/* Create values */
OPTIONS FMTSEARCH=(project1);
PROC FORMAT LIBRARY=project1; 
	VALUE yesnofmt		 1 = 'Yes' 
						 0 = 'No';
    VALUE sexfmt		 1 = 'Male'
		  				 2 = 'Female';
	VALUE agefmt		 1 = '20-29'
						 2 = '30-39'
						 3 = '40-49'
						 4 = '50-59'
						 5 = '60-69'
						 6 = '>=70';
	VALUE asmquartfmt    1 = 'Q1'
						 2 = 'Q2'
						 3 = 'Q3'
						 4 = 'Q4';
RUN;


DATA project1.project1B;
	SET project1.kim2021_1;
/* Create homa_ir, Overweight_BMI, Normal_BMI, Underweight_BMI, and age_cat variables */
homa_ir = (glu*insulin)/405;
IF bexam_BMI >=23 & bexam_BMI <25 THEN Overweight_BMI = 1;
ELSE IF bexam_BMI ne . THEN Overweight_BMI = 0;
IF bexam_BMI >=18.5 & bexam_BMI <23 THEN Normal_BMI = 1;
ELSE IF bexam_BMI ne . THEN Normal_BMI = 0; 
IF bexam_BMI <18.5 THEN Underweight_BMI = 1;
ELSE IF bexam_BMI ne . THEN Underweight_BMI = 0; 
IF Age>=20 & Age<30 THEN age_cat=1;
IF Age>=30 & Age<40 THEN age_cat=2;
IF Age>=40 & Age<50 THEN age_cat=3;
IF Age>=50 & Age<60 THEN age_cat=4;
IF Age>=60 & Age<70 THEN age_cat=5;
IF Age>=70 THEN age_cat=6;
IF VFA_cm2>=100 THEN visc_obesity=1;
IF VFA_cm2>=0 & VFA_cm2<100 THEN visc_obesity=0;
/* Label variables */
	LABEL		          ID = "ID"
						 Sex = "Sex"
						 Age = "Age (years)"
				     age_cat = "Age (categorical)"
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
			  shx_alcohol_yn = "Alcohol intake"
			   Sarco_ASM_Wt_ = "Sarcopenia"
					   DysL_ = "Dyslipidemia";
FORMAT age_cat agefmt. Sex sexfmt. MS HT DM Obesity Overweight_BMI Normal_BMI Underweight_BMI shx_smoke_yn shx_alcohol_yn Sarco_ASM_Wt_ DysL_ visc_obesity yesnofmt.;
RUN;

/* Determine ASM% quartiles for Table 1 */
PROC MEANS data=project1.project1B Q1 MEDIAN Q3;
CLASS Sex;
VAR ASM_Wt_;
RUN;

/* Add asm_quart variable */
DATA project1.project1C;
	SET project1.project1B;
IF ASM_Wt_<30.4915912 & Sex=1 THEN asm_quart=1;
IF ASM_Wt_>=30.4915912 & ASM_Wt_<32.0951165 & Sex=1 THEN asm_quart=2;
IF ASM_Wt_>=32.0951165 & ASM_Wt_<33.8514443 & Sex=1 THEN asm_quart=3;
IF ASM_Wt_>=33.8514443 & Sex=1 THEN asm_quart=4;
IF ASM_Wt_<25.4079254 & Sex=2 THEN asm_quart=1;
IF ASM_Wt_>=25.4079254 & ASM_Wt_<27.2257313 & Sex=2 THEN asm_quart=2;
IF ASM_Wt_>=27.2257313 & ASM_Wt_<28.9863548 & Sex=2 THEN asm_quart=3;
IF ASM_Wt_>=28.9863548 & Sex=2 THEN asm_quart=4;
LABEL asm_quart = "ASM% Quartiles";
FORMAT asm_quart asmquartfmt.;
RUN;

/* Check means of ASM% quartiles */	
PROC MEANS DATA=project1.project1C;
CLASS asm_quart;
VAR ASM_Wt_;
RUN;


/* Table 1 */

options nodate nocenter ls = 147 ps = 47 orientation = landscape;

/** change this to location where you saved the .sas files**/
%let MacroDir=C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\Tables\macroTable1\Table1;

filename tab1  "&MacroDir./Table1.sas";
%include tab1;

/***********************/
/****UTILITY SASJOBS****/
/***********************/
filename tab1prt  "&MacroDir./Table1Print.sas";
%include tab1prt;

filename npar1way  "&MacroDir./Npar1way.sas";
%include npar1way;

filename CheckVar  "&MacroDir./CheckVar.sas";
%include CheckVar;

filename Uni  "&MacroDir./Univariate.sas";
%include Uni;

filename Varlist  "&MacroDir./Varlist.sas";
%include Varlist;

filename Words  "&MacroDir./Words.sas";
%include Words;

filename Append  "&MacroDir./Append.sas";
%include Append;

/** specify folder in which to store results***/

%let results=C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\Tables;

/*** Table 1 macro call ***/
%Table1(DSName=project1.project1C,
        GroupVar=asm_quart,
        NumVars=Age bexam_wt bexam_bmi bexam_wc bexam_BP_systolic bexam_BP_diastolic VFA_cm2 ASM_kg ASM_Wt_ chol HDL LDL TG glu GOT GPT uric_acid HbA1c insulin HOMA_IR CRP,
        FreqVars=MS HT DM Obesity Overweight_BMI Normal_BMI Underweight_BMI shx_smoke_yn shx_alcohol_yn,
        Mean=Y,
        Total=RC,
        P=N,
        FreqCell=N(CP),
        Missing=Y,
        Print=Y,
        Label=L,
        Out=Test,
		Dec=2,
        Out1way=)
*options mprint  symbolgen mlogic;
RUN;

ODS PDF FILE="&results.\Kim_Table1.pdf";
TITLE 'Clinical characteristics according to ASM% quartiles';
%Table1Print(DSname=test,Space=Y)
RUN;
ODS PDF CLOSE;

/* Figure 3 */

PROC FREQ DATA=project1.project1C;
TABLES asm_quart*MS / OUT=project1.fig3 OUTPCT;
RUN;

DATA project1.fig3;
	SET project1.fig3;
Percent = Percent/100;
format Percent PERCENT5.;
RUN;

DATA project1.fig3_1;
	SET project1.fig3;
DROP PCT_COL PERCENT;
WHERE MS=1;
RUN;

ODS PDF FILE="&results.\Kim_Fig3.pdf";
TITLE 'Fig 3. Prevalence of metaolic syndrome according to ASM% quartiles';
PROC SGPLOT DATA=project1.fig3_1;
VBAR asm_quart / response=PCT_ROW;
YAXIS VALUES = (0 to 40 by 5) GRID;
LABEL PCT_ROW = "Metabolic Syndrome (%)";
RUN;
ODS PDF CLOSE;

/* Table 2 */
/* Thank you to Tahmineh Romero for sharing her macro with me! */

%macro table2(data, class, vars, model_number, model);
PROC LOGISTIC DATA=&data;
CLASS Sarco_ASM_Wt_(ref="No") &class/ param=ref;
MODEL MS (event="Yes") =Sarco_ASM_Wt_ &vars;
estimate &model_number Sarco_ASM_Wt_ 1 /exp cl;
ODS OUTPUT ESTIMATES=&model;
RUN;
DATA &model(KEEP = Label OR CI Probz);
RETAIN Label OR CI Probz;
SET &model;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
label CI = "95% CI"
	  OR = "OR"
   Probz = "P value"; 
RUN;
%mend;

%table2(project1.project1C, , ,"Crude", project1.crude);
%table2(project1.project1C, Sex(ref="Female"), Sex Age, "Model 1", project1.M1);
%table2(project1.project1C, Sex(ref="Female"), Sex Age Obesity, "Model 2", project1.M2);
%table2(project1.project1C, Sex(ref="Female"), Sex Age Obesity HT DM DysL_, "Model 3", project1.M3);
%table2(project1.project1C, Sex(ref="Female"), Sex Age Obesity HT DM DysL_ shx_smoke_yn shx_alcohol_yn, "Model 4", project1.M4);
%table2(project1.project1C, Sex(ref="Female"), Sex Age Obesity HT DM DysL_ shx_smoke_yn shx_alcohol_yn CRP, "Model 5", project1.M5);

DATA project1.table2;
LENGTH Label $10.;
SET project1.crude project1.M1 project1.M2 project1.M3 project1.M4 project1.M5;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Kim_Table2.pdf";
TITLE "Table 2. Association between metabolic syndrome and sarcopenia.";
PROC PRINT DATA=project1.table2 LABEL;
FOOTNOTE "Model 1: Adjusted for age, sex.";
FOOTNOTE2 "Model 2: Adjusted for age, sex, obesity.";
FOOTNOTE3 "Model 3: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia.";
FOOTNOTE4 "Model 4: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia, smoking, alcohol intake.";
FOOTNOTE5 "Model 5: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia, smoking, alcohol intake, CRP.";
FOOTNOTE6 "OR, odds ratio; CI, confidence interval; CRP, C-reactive protein.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;
FOOTNOTE6;

/* Table 3 */

/* Visceral obesity */
PROC LOGISTIC DATA=project1.project1C;
CLASS Sarco_ASM_Wt_(PARAM=REF REF="No") visc_obesity(PARAM = REF REF="No");
MODEL MS (EVENT="Yes") = Sarco_ASM_Wt_ | visc_obesity;
ODDSRATIOS Sarco_ASM_Wt_;
ESTIMATE "Visceral obesity Yes" Sarco_ASM_Wt_ 1 visc_obesity 0 Sarco_ASM_Wt_* visc_obesity 1 0 / exp cl;
ESTIMATE "Visceral obesity No" Sarco_ASM_Wt_ 1 visc_obesity 0 Sarco_ASM_Wt_* visc_obesity 0 0 / exp cl;
ODS OUTPUT estimates=visc_obesity;
RUN;
*Store OR, 95% CI, p-value;
DATA project1.visc_obesity (KEEP = Label OR CI Probz);
RETAIN Label OR CI Probz;
SET work.visc_obesity;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI"
	  OR = "OR"
   Probz = "P value"; 
RUN;

/* Obesity */
PROC LOGISTIC DATA=project1.project1C;
CLASS Sarco_ASM_Wt_(PARAM=REF REF="No") Obesity(PARAM = REF REF="No");
MODEL MS (EVENT="Yes") = Sarco_ASM_Wt_ | Obesity;
ODDSRATIOS Sarco_ASM_Wt_;
ESTIMATE "Obesity Yes" Sarco_ASM_Wt_ 1 Obesity 0 Sarco_ASM_Wt_* Obesity 1 0 / exp cl;
ESTIMATE "Obesity No" Sarco_ASM_Wt_ 1 Obesity 0 Sarco_ASM_Wt_* Obesity 0 0 / exp cl;
ODS OUTPUT estimates=Obesity;
RUN;
*Store OR, 95% CI, p-value;
DATA project1.Obesity (KEEP = Label OR CI Probz);
RETAIN Label OR CI Probz;
SET work.Obesity;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI"
	  OR = "OR"
   Probz = "P value"; 
RUN;

/* Underweight */
PROC LOGISTIC DATA=project1.project1C;
CLASS Sarco_ASM_Wt_(PARAM=REF REF="No") Underweight_BMI(PARAM = REF REF="No");
MODEL MS (EVENT="Yes") = Sarco_ASM_Wt_ | Underweight_BMI;
ODDSRATIOS Sarco_ASM_Wt_;
ESTIMATE "Underweight Yes" Sarco_ASM_Wt_ 1 Underweight_BMI 0 Sarco_ASM_Wt_* Underweight_BMI 1 0 / exp cl;
ESTIMATE "Underweight No" Sarco_ASM_Wt_ 1 Underweight_BMI 0 Sarco_ASM_Wt_* Underweight_BMI 0 0 / exp cl;
ODS OUTPUT estimates=Underweight_BMI;
RUN;
*Store OR, 95% CI, p-value;
DATA project1.Underweight_BMI (KEEP = Label OR CI Probz);
RETAIN Label OR CI Probz;
SET work.Underweight_BMI;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI"
	  OR = "OR"
   Probz = "P value"; 
RUN;

/* Sex */
PROC LOGISTIC DATA=project1.project1C;
CLASS Sarco_ASM_Wt_(PARAM=REF REF="No") Sex(PARAM = REF REF="Male");
MODEL MS (EVENT="Yes") = Sarco_ASM_Wt_ | Sex;
ODDSRATIOS Sarco_ASM_Wt_;
ESTIMATE "Female" Sarco_ASM_Wt_ 1 Sex 0 Sarco_ASM_Wt_* Sex 1 0 / exp cl;
ESTIMATE "Male" Sarco_ASM_Wt_ 1 Sex 0 Sarco_ASM_Wt_* Sex 0 0 / exp cl;
ODS OUTPUT estimates=Sex;
RUN;
*Store OR, 95% CI, p-value;
DATA project1.Sex (KEEP = Label OR CI Probz);
RETAIN Label OR CI Probz;
SET work.Sex;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI"
	  OR = "OR"
   Probz = "P value"; 
RUN;

* Put stored data for Table 3 together;
DATA project1.table3;
LEGNTH label $25.;
SET project1.visc_obesity project1.Obesity project1.Underweight_BMI project1.Sex;
FORMAT label;
INFORMAT label;
RUN;
QUIT;

ODS PDF FILE="&results.\Kim_Table3.pdf";
TITLE "Table 3. Stratified association between metabolic syndrome and sarcopenia.";
PROC PRINT DATA=project1.table3 LABEL;
FOOTNOTE "OR, odds ratio; CI, confidence interval; visceral obesity, VFAs>=100cm^2; obesity, BMI>=25 kg/m^2; underweight, BMI<18.5 kg/m^2.";
RUN;
ODS PDF CLOSE;
FOOTNOTE;

/* Figure 4 */

PROC SORT DATA=project1.project1C OUT=project1.project1C_age;
BY Age_cat;
RUN;

PROC FREQ data=project1.project1C_age;
BY Age_cat;
TABLES MS*Sarco_ASM_Wt_ /OUT=project1.fig4 OUTPCT;
RUN;

DATA project1.fig4;
	SET project1.fig4;
Percent = Percent / 100;
FORMAT Percent PERCENT5.;
RUN;

DATA project1.fig4_1;
	SET project1.fig4;
DROP PCT_ROW PERCENT;
WHERE MS=1;
IF Age_cat=. THEN DELETE;
RUN;

PROC FREQ DATA=project1.project1C;
TABLES MS*Sarco_ASM_Wt_ /OUT=project1.fig4_total OUTPCT;
RUN; 

PROC FORMAT;
VALUE agecat2fmt  1= "20-29"
				  2= "30-39"
			      3= "40-49"
				  4= "50-59"
				  5= "60-69"
				  6= ">=70"
				  10 = "Total";
RUN;

DATA project1.fig4_total;
	SET project1.fig4_total;
Percent = Percent / 100;
FORMAT Percent PERCENT5.;
RUN;

DATA project1.fig4_total_1;
	SET project1.fig4_total;
DROP PCT_ROW PERCENT;
WHERE MS=1;
Age_cat=10;
FORMAT Age_cat agecat2fmt.;
RUN;

DATA project1.fig4_final;
	SET project1.fig4_1 project1.fig4_total_1;
FORMAT Age_cat agecat2fmt.;
RUN;

ODS PDF FILE="&results.\Kim_Fig4.pdf";
PROC SGPLOT DATA=project1.fig4_final;
VBAR Age_cat / GROUP = Sarco_ASM_Wt_ GROUPDISPLAY=cluster RESPONSE=PCT_COL;
YAXIS VALUES = (0 to 60 by 10) GRID;
TITLE "Fig 4. The prevalence of metabolic syndrome in a 10-year age strata according to the presence of sarcopenia.";
LABEL PCT_COL = "Metabolic syndrome (%)";
RUN;
ODS PDF CLOSE; 

/*Table 4*/

DATA project1.table4;
	SET project1.project1C;
IF MS_5cri >=4 THEN MS_45=1;
ELSE IF MS_5cri <4 & MS_5cri ne . THEN MS_45=0;
IF MS_5cri =5 THEN MS_5=1;
ELSE IF MS_5cri <5 & MS_5cri ne . THEN MS_5=0;
FORMAT MS_45 MS_5 yesnofmt.;
RUN;
QUIT;

* Macro for Table 4;

%macro table4_a(data, class, vars, model_number, model);
PROC LOGISTIC DATA=&data;
CLASS Sarco_ASM_Wt_(ref="No") &class/ param=ref;
MODEL  MS_45(event="Yes") =Sarco_ASM_Wt_ &vars;
ESTIMATE &model_number Sarco_ASM_Wt_ 1 /EXP CL;
ODS OUTPUT estimates=&model;
RUN;
data &model (KEEP = Label OR CI Probz);
RETAIN Label OR CI Probz;
SET &model;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI MS 4 or 5 criteria"
      OR = "OR MS 4 or 5 criteria"
   Probz = "p value MS 4 or 5 criteria";
RUN;
%mend;

%table4_a(project1.table4, , , "Crude", project1.Crude_4a);
%table4_a(project1.table4, Sex (ref="Female"), Sex Age, "Model 1", project1.M1_4a);
%table4_a(project1.table4, Sex (ref="Female"), Sex Age Obesity, "Model 2", project1.M2_4a);
%table4_a(project1.table4, Sex (ref="Female"), Sex Age Obesity HT DM DysL_, "Model 3", project1.M3_4a);
%table4_a(project1.table4, Sex (ref="Female"), Sex Age Obesity HT DM DysL_ shx_smoke_yn shx_alcohol_yn, "Model 4", project1.M4_4a);
%table4_a(project1.table4, Sex (ref="Female"), Sex Age Obesity HT DM DysL_ shx_smoke_yn shx_alcohol_yn CRP, "Model 5", project1.M5_4a);

*Store OR, 95%CI, p-value for Table 4 part a;
DATA project1.table4a;
LENGTH label $10.;
SET project1.Crude_4a project1.M1_4a project1.M2_4a project1.M3_4a project1.M4_4a project1.M5_4a;
FORMAT Label;
INFORMAT Label;
RUN;

%macro table4_B(data, class, vars, model_number, model);
PROC LOGISTIC DATA=&data;
CLASS Sarco_ASM_Wt_(ref="No") &class/ param=ref;
MODEL  MS_5(event="Yes") =Sarco_ASM_Wt_ &vars;
ESTIMATE &model_number Sarco_ASM_Wt_ 1 /EXP CL;
ODS OUTPUT estimates=&model;
RUN;
data &model (KEEP = Label OR2 CI2 Probz2 Probz);
RETAIN Label OR2 CI2 Probz2;
SET &model;
OR2 = compress(put(ExpEstimate,8.3));
CI2 = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI2 = "95% CI MS 5 criteria"
      OR2 = "OR MS 5 criteria"
   Probz2 = "p value MS 5 criteria"
    Probz = "p value MS 5 criteria";
RUN;
%mend;


%macro table4_B(data, class, vars, model_number, model);
PROC LOGISTIC DATA=&data;
CLASS Sarco_ASM_Wt_(ref="No") &class/ param=ref;
MODEL  MS_5(event="Yes") = Sarco_ASM_Wt_ &vars;
ESTIMATE &model_number Sarco_ASM_Wt_ 1 /EXP CL;
ODS OUTPUT estimates=&model;
RUN;
data &model (KEEP = Label OR2 CI2 Probz2 Probz);
RETAIN Label OR2 CI2 Probz2;
SET &model;
OR2 = compress(put(ExpEstimate,8.3));
CI2 = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL Probz = "p value MS 5 criteria";
RENAME Probz=Probz2;
LABEL CI2 = "95% CI MS 5 criteria"
      OR2 = "OR MS 5 criteria"
   Probz2 = "p value MS 5 criteria";
RUN;
%mend;

%table4_b(project1.table4, , , "Crude", project1.Crude_4b);
%table4_b(project1.table4, Sex (ref="Female"), Sex Age, "Model 1", project1.M1_4b);
%table4_b(project1.table4, Sex (ref="Female"), Sex Age Obesity, "Model 2", project1.M2_4b);
%table4_b(project1.table4, Sex (ref="Female"), Sex Age Obesity HT DM DysL_, "Model 3", project1.M3_4b);
%table4_b(project1.table4, Sex (ref="Female"), Sex Age Obesity HT DM DysL_ shx_smoke_yn shx_alcohol_yn, "Model 4", project1.M4_4b);
%table4_b(project1.table4, Sex (ref="Female"), Sex Age Obesity HT DM DysL_ shx_smoke_yn shx_alcohol_yn CRP, "Model 5", project1.M5_4b);

*Store OR, 95%CI, p-value for Table 4 part b;
DATA project1.table4b;
LENGTH label $10.;
SET project1.Crude_4b project1.M1_4b project1.M2_4b project1.M3_4b project1.M4_4b project1.M5_4b;
FORMAT Label;
INFORMAT Label;
RUN;

PROC SORT DATA=project1.table4a;
BY Label;
RUN;

PROC SORT DATA=project1.table4b;
BY Label;
RUN;

DATA project1.table4_final;
MERGE project1.table4a project1.table4b;
BY Label;
RUN;

ODS PDF FILE="&results.\Kim_Table4.pdf";
TITLE "Table 4. Association between severe metabolic syndrome (4 or 5 criteria) and sarcopenia.";
PROC PRINT DATA=project1.table4_final LABEL;
FOOTNOTE "Model 1: Adjusted for age, sex.";
FOOTNOTE2 "Model 2: Adjusted for age, sex, obesity.";
FOOTNOTE3 "Model 3: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia.";
FOOTNOTE4 "Model 4: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia, smoking, alcohol intake.";
FOOTNOTE5 "Model 5: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia, smoking, alcohol intake, CRP.";
FOOTNOTE6 "OR, odds ratio; CI, confidence interval; CRP, C-reactive protein.";
RUN;
ODS PDF CLOSE;
QUIT;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;
FOOTNOTE6;

/* Table 5 */

%macro table5(data, vars, model, model_name);
PROC LOGISTIC DATA=&data;
CLASS asm_quart(ref="Q1") / param=ref;
MODEL MS (event="Yes") = asm_quart &vars;
ESTIMATE "Q1" asm_quart 0 0 0 /EXP CL;
ESTIMATE "Q2" asm_quart 1 0 0 /EXP CL;
ESTIMATE "Q3" asm_quart 0 1 0 /EXP CL;
ESTIMATE "Q4" asm_quart 0 0 1 /EXP CL;
ODS OUTPUT estimates=&model;
RUN;
DATA &model (KEEP = Label OR CI Probz model);
RETAIN model Label OR CI Probz;
SET &model;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI"
	  OR = "OR"
   Probz = "P value"; 
model = &model_name;
RUN;
%mend;

%table5(project1.project1C, , project1.table5_unadj, "Unadjusted");
%table5(project1.project1C, Sex Age, project1.table5_M1, "Model 1");
%table5(project1.project1C, Sex Age Obesity, project1.table5_M2, "Model 2");
%table5(project1.project1C, Sex Age Obesity HT DM DysL_, project1.table5_M3, "Model 3");
%table5(project1.project1C, Sex Age Obesity HT DM DysL_  shx_smoke_yn shx_alcohol_yn, project1.table5_M4, "Model 4");
%table5(project1.project1C, Sex Age Obesity HT DM DysL_  shx_smoke_yn shx_alcohol_yn CRP, project1.table5_M5, "Model 5");

DATA project1.table5a;
LENGTH label $20.;
SET project1.table5_unadj project1.table5_M1 project1.table5_M2 project1.table5_M3 project1.table5_M4 project1.table5_M5;
FORMAT Label;
INFORMAT Label;
FORMAT model;
INFORMAT model;
RUN;


%macro table5_trend(data, vars, model, model_name);
PROC LOGISTIC DATA=&data;
MODEL MS (event="Yes") = asm_quart &vars;
ESTIMATE "Per 1Q" asm_quart 1 /EXP CL;
ODS OUTPUT estimates=&model;
RUN;
DATA &model (keep = Label OR CI Probz model);
RETAIN model Label OR CI Probz;
SET &model;
OR = compress(put(ExpEstimate,8.3));
CI = put(LowerExp,8.3)||'-'||put(UpperExp,8.3);
LABEL CI = "95% CI"
	  OR = "OR"
   Probz = "P value";
model = &model_name;
RUN; 
%mend;

%table5_trend(project1.project1C, , project1.table5_unadj_trend, "Unadjusted");
%table5_trend(project1.project1C, Sex Age, project1.table5_M1_trend, "Model 1");
%table5_trend(project1.project1C, Sex Age Obesity, project1.table5_M2_trend, "Model 2");
%table5_trend(project1.project1C, Sex Age Obesity HT DM DysL_, project1.table5_M3_trend, "Model 3");
%table5_trend(project1.project1C, Sex Age Obesity HT DM DysL_  shx_smoke_yn shx_alcohol_yn, project1.table5_M4_trend, "Model 4");
%table5_trend(project1.project1C, Sex Age Obesity HT DM DysL_  shx_smoke_yn shx_alcohol_yn CRP, project1.table5_M5_trend, "Model 5");

DATA project1.table5;
LENGTH label $20.;
LENGTH model $20.;
SET project1.table5_unadj project1.table5_M1 project1.table5_M2 project1.table5_M3 project1.table5_M4 project1.table5_M5 project1.table5_unadj_trend project1.table5_M1_trend project1.table5_M2_trend project1.table5_M3_trend project1.table5_M4_trend project1.table5_M5_trend;
FORMAT Label;
INFORMAT Label;
FORMAT model;
INFORMAT model;
RUN;

DATA project1.table5_final;
RETAIN model Label OR CI Probz;
SET project1.table5;
RUN;

ODS PDF FILE="&results.\Kim_Table5.pdf";
TITLE 'Table 5. Risk of metabolic syndrome in each quartile of sarcopenia.';
PROC PRINT DATA=project1.table5_final LABEL;
FOOTNOTE "Model 1: Adjusted for age, sex.";
FOOTNOTE2 "Model 2: Adjusted for age, sex, obesity.";
FOOTNOTE3 "Model 3: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia.";
FOOTNOTE4 "Model 4: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia, smoking, alcohol intake.";
FOOTNOTE5 "Model 5: Adjusted for age, sex, obesity, hypertension, diabetes mellitus, dyslipidemia, smoking, alcohol intake, CRP.";
FOOTNOTE6 "OR, odds ratio; CI, confidence interval; CRP, C-reactive protein.";
RUN;
ODS PDF CLOSE;
QUIT;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;
FOOTNOTE6;
