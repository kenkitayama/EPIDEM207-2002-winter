

libname fmt "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 3 formats";
libname proj3 "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 3";

options fmtsearch= (fmt); 

proc contents data =proj3.JOHN_CLEAN2  varnum; 
run; 

Proc format library=fmt  MAXLABLEN=1000
CNTLOUT = forms; 
run; 

data forms2;
set forms (keep =FMTNAME start LABEL); 
header = cats (Start, "  = ", Label);
run; 

Proc print data =forms2;
var FMTNAME header ;
run; 

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

%let results=C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 3\Tables;

/*** Table 1 macro call ***/
%Table1(DSName=proj3.john_clean2,
        GroupVar=Smoke,
        NumVars=age, 
        FreqVars=female age_grp edu health alc_cons,
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

ODS PDF FILE="&results.\Assignment3_Table1.pdf";
TITLE 'Table 1. Cohort descriptives stratified by smoking status';
%Table1Print(DSname=test,Space=Y)
RUN;
ODS PDF CLOSE;

/* Table 2 */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*cvd_mort (0) = smoke / rl ties=efron;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.model_1_cvdmort;
RUN;
DATA proj3.model_1_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.model_1_cvdmort;
RUN;
DATA proj3.model_1_cvdmort;
SET proj3.model_1_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
Model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label Model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.model_1_cvdmort;
by order;
RUN;
DATA proj3.model_1_cvdmort;
SET proj3.model_1_cvdmort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") female/ param=ref;
MODEL futime*cvd_mort (0) = smoke age female/ rl ties=efron;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.model_2_cvdmort;
RUN;
DATA proj3.model_2_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.model_2_cvdmort;
RUN;
DATA proj3.model_2_cvdmort;
SET proj3.model_2_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
Model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label Model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.model_2_cvdmort;
by order;
RUN;
DATA proj3.model_2_cvdmort;
SET proj3.model_2_cvdmort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") female health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*cvd_mort (0) = smoke age female health edu alc_cons health edu alc_cons/ rl ties=efron;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.model_3_cvdmort;
RUN;
DATA proj3.model_3_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.model_3_cvdmort;
RUN;
DATA proj3.model_3_cvdmort;
SET proj3.model_3_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
Model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label Model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.model_3_cvdmort;
by order;
RUN;
DATA proj3.model_3_cvdmort;
SET proj3.model_3_cvdmort;
drop order;
RUN;
QUIT;

DATA proj3.table2b;
LENGTH Label $50.;
SET proj3.model_1_cvdmort proj3.model_2_cvdmort proj3.model_3_cvdmort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table2a.pdf";
TITLE "Table 2a. Relationship of smoking status with cardiovascular disease mortality.";
PROC PRINT DATA=proj3.table2b LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*ca_mort (0) = smoke / rl ties=efron;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.model_1_camort;
RUN;
DATA proj3.model_1_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.model_1_camort;
RUN;
DATA proj3.model_1_camort;
SET proj3.model_1_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
Model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label Model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.model_1_camort;
by order;
RUN;
DATA proj3.model_1_camort;
SET proj3.model_1_camort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") female/ param=ref;
MODEL futime*ca_mort (0) = smoke age female/ rl ties=efron;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.model_2_camort;
RUN;
DATA proj3.model_2_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.model_2_camort;
RUN;
DATA proj3.model_2_camort;
SET proj3.model_2_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
Model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label Model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
QUIT;
PROC SORT data=proj3.model_2_camort;
by order;
RUN;
QUIT;
DATA proj3.model_2_camort;
SET proj3.model_2_camort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") female health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*ca_mort (0) = smoke age female health edu alc_cons health edu alc_cons/ rl ties=efron;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.model_3_camort;
RUN;
DATA proj3.model_3_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.model_3_camort;
RUN;
DATA proj3.model_3_camort;
SET proj3.model_3_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
Model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label Model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.model_3_camort;
by order;
RUN;
DATA proj3.model_3_camort;
SET proj3.model_3_camort;
drop order;
RUN;
QUIT;

DATA proj3.table2b;
LENGTH Label $50.;
SET proj3.model_1_camort proj3.model_2_camort proj3.model_3_camort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table2a.pdf";
TITLE "Table 2a. Relationship of smoking status with cardiovascular disease mortality.";
PROC PRINT DATA=proj3.table2b LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

/* Table 3 */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*mort (0) = smoke / rl ties=efron;
WHERE female = 1;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab3a_model_1_mort;
RUN;
QUIT;
DATA proj3.tab3a_model_1_mort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab3a_model_1_mort;
RUN;
QUIT;
DATA proj3.tab3a_model_1_mort;
SET proj3.tab3a_model_1_mort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab3a_model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab3a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
QUIT;
PROC SORT data=proj3.tab3a_model_1_mort;
by order;
RUN;
QUIT;
DATA proj3.tab3a_model_1_mort;
SET proj3.tab3a_model_1_mort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*mort (0) = smoke age / rl ties=efron;
WHERE female = 1;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab3a_model_2_mort;
RUN;
DATA proj3.tab3a_model_2_mort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab3a_model_2_mort;
RUN;
DATA proj3.tab3a_model_2_mort;
SET proj3.tab3a_model_2_mort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab3a_model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab3a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab3a_model_2_mort;
by order;
RUN;
DATA proj3.tab3a_model_2_mort;
SET proj3.tab3a_model_2_mort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*mort (0) = smoke age health edu alc_cons health edu alc_cons/ rl ties=efron;
WHERE female = 1;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab3a_model_3_mort;
RUN;
DATA proj3.tab3a_model_3_mort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab3a_model_3_mort;
RUN;
DATA proj3.tab3a_model_3_mort;
SET proj3.tab3a_model_3_mort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab3a_model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab3a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab3a_model_3_mort;
by order;
RUN;
DATA proj3.tab3a_model_3_mort;
SET proj3.tab3a_model_3_mort;
drop order;
RUN;
QUIT;

DATA proj3.table3a;
LENGTH Label $50.;
SET proj3.tab3a_model_1_mort proj3.tab3a_model_2_mort proj3.tab3a_model_3_mort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table3a.pdf";
TITLE "Table 3a. Sex-stratified relationship of smoking status with total mortality (Females).";
PROC PRINT DATA=proj3.table3a LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

/* MEN */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*mort (0) = smoke / rl ties=efron;
WHERE female = 0;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab3b_model_1_mort;
RUN;
DATA proj3.tab3b_model_1_mort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab3b_model_1_mort;
RUN;
DATA proj3.tab3b_model_1_mort;
SET proj3.tab3b_model_1_mort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab3b_model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab3b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab3b_model_1_mort;
by order;
RUN;
DATA proj3.tab3b_model_1_mort;
SET proj3.tab3b_model_1_mort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*mort (0) = smoke age / rl ties=efron;
WHERE female = 0;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab3b_model_2_mort;
RUN;
DATA proj3.tab3b_model_2_mort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab3b_model_2_mort;
RUN;
DATA proj3.tab3b_model_2_mort;
SET proj3.tab3b_model_2_mort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab3b_model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab3b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab3b_model_2_mort;
by order;
RUN;
DATA proj3.tab3b_model_2_mort;
SET proj3.tab3b_model_2_mort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*mort (0) = smoke age health edu alc_cons health edu alc_cons/ rl ties=efron;
WHERE female = 0;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab3b_model_3_mort;
RUN;
DATA proj3.tab3b_model_3_mort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab3b_model_3_mort;
RUN;
DATA proj3.tab3b_model_3_mort;
SET proj3.tab3b_model_3_mort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab3b_model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab3b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab3b_model_3_mort;
by order;
RUN;
DATA proj3.tab3b_model_3_mort;
SET proj3.tab3b_model_3_mort;
drop order;
RUN;
QUIT;

DATA proj3.table3b;
LENGTH Label $50.;
SET proj3.tab3b_model_1_mort proj3.tab3b_model_2_mort proj3.tab3b_model_3_mort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table3b.pdf";
TITLE "Table 3b. Sex-stratified relationship of smoking status with total mortality (Males).";
PROC PRINT DATA=proj3.table3b LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

/* Figure 2 */

ods graphics on; 
ods output survivalplot=_surv2; 
proc phreg data = proj3.john_clean2 plots(overlay)=survival ;
	class smoke (ref='Never smoker') female ;
	model futime*mort (0)= smoke age female  /rl ties=efron ;
	baseline covariates= proj3.john_clean2 out=base/diradj group=smoke;
run; 

proc sgplot data =_surv2; 
step x=time y=survival/group = smoke; 
styleattrs 	datacontrastcolors= ( navy green red darkorange brown ) 
			datalinepatterns=(solid dash dashdotdot  shortdashdot dot longdash );
keylegend/title= " ";
title "Figure 2. Age & Sex Adjusted Total Mortality Survival of Smoking Status with Cox proportional hazards regression";
run; 

/* Figure 3 */

ods graphics on; 
ods output survivalplot=_surv3; 
proc phreg data = proj3.john_clean2 plots(overlay)=survival ;
	class   smoke (ref='Never smoker') female health edu alc_cons;
	model futime*mort (0)= smoke age female health edu alc_cons /rl ties=efron ;
	baseline covariates= hw2.john_clean2 out=base2/diradj group=smoke;
run; 

proc sgplot data =_surv3; 
step x=time y=survival/group = smoke; 
styleattrs 	datacontrastcolors= ( navy green red darkorange brown ) 
			datalinepatterns=(solid dash dashdotdot  shortdashdot dot longdash );
keylegend/title= " ";
title "Figure 3. Age, Sex, Educational Level, Self-rated Health & Alcohol Consumption Adjusted Total Mortality Survival of Smoking Status with Cox proportional hazards regression";
run; 

/* Supplemental Table 1 */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*cvd_mort (0) = smoke / rl ties=efron;
WHERE female = 1;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4a_model_1_cvdmort;
RUN;
QUIT;
DATA proj3.tab4a_model_1_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4a_model_1_cvdmort;
RUN;
QUIT;
DATA proj3.tab4a_model_1_cvdmort;
SET proj3.tab4a_model_1_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4a_model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
QUIT;
PROC SORT data=proj3.tab4a_model_1_cvdmort;
by order;
RUN;
QUIT;
DATA proj3.tab4a_model_1_cvdmort;
SET proj3.tab4a_model_1_cvdmort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*cvd_mort (0) = smoke age / rl ties=efron;
WHERE female = 1;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4a_model_2_cvdmort;
RUN;
DATA proj3.tab4a_model_2_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4a_model_2_cvdmort;
RUN;
DATA proj3.tab4a_model_2_cvdmort;
SET proj3.tab4a_model_2_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4a_model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4a_model_2_cvdmort;
by order;
RUN;
DATA proj3.tab4a_model_2_cvdmort;
SET proj3.tab4a_model_2_cvdmort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*cvd_mort (0) = smoke age health edu alc_cons health edu alc_cons/ rl ties=efron;
WHERE female = 1;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4a_model_3_cvdmort;
RUN;
DATA proj3.tab4a_model_3_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4a_model_3_cvdmort;
RUN;
DATA proj3.tab4a_model_3_cvdmort;
SET proj3.tab4a_model_3_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4a_model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4a_model_3_cvdmort;
by order;
RUN;
DATA proj3.tab4a_model_3_cvdmort;
SET proj3.tab4a_model_3_cvdmort;
drop order;
RUN;
QUIT;

DATA proj3.table4a;
LENGTH Label $50.;
SET proj3.tab4a_model_1_cvdmort proj3.tab4a_model_2_cvdmort proj3.tab4a_model_3_cvdmort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table4a.pdf";
TITLE "Supplemental Table 1A. Sex-stratified relationship of smoking status with cardiovascular disease mortality (Females).";
PROC PRINT DATA=proj3.table4a LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

/* MEN */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*cvd_mort (0) = smoke / rl ties=efron;
WHERE female = 0;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4b_model_1_cvdmort;
RUN;
DATA proj3.tab4b_model_1_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4b_model_1_cvdmort;
RUN;
DATA proj3.tab4b_model_1_cvdmort;
SET proj3.tab4b_model_1_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4b_model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4b_model_1_cvdmort;
by order;
RUN;
DATA proj3.tab4b_model_1_cvdmort;
SET proj3.tab4b_model_1_cvdmort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*cvd_mort (0) = smoke age / rl ties=efron;
WHERE female = 0;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4b_model_2_cvdmort;
RUN;
DATA proj3.tab4b_model_2_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4b_model_2_cvdmort;
RUN;
DATA proj3.tab4b_model_2_cvdmort;
SET proj3.tab4b_model_2_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4b_model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4b_model_2_cvdmort;
by order;
RUN;
DATA proj3.tab4b_model_2_cvdmort;
SET proj3.tab4b_model_2_cvdmort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*cvd_mort (0) = smoke age health edu alc_cons health edu alc_cons/ rl ties=efron;
WHERE female = 0;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4b_model_3_cvdmort;
RUN;
DATA proj3.tab4b_model_3_cvdmort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4b_model_3_cvdmort;
RUN;
DATA proj3.tab4b_model_3_cvdmort;
SET proj3.tab4b_model_3_cvdmort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4b_model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4b_model_3_cvdmort;
by order;
RUN;
DATA proj3.tab4b_model_3_cvdmort;
SET proj3.tab4b_model_3_cvdmort;
drop order;
RUN;
QUIT;

DATA proj3.table4b;
LENGTH Label $50.;
SET proj3.tab4b_model_1_cvdmort proj3.tab4b_model_2_cvdmort proj3.tab4b_model_3_cvdmort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table4b.pdf";
TITLE "Supplemental Table 1B. Sex-stratified relationship of smoking status with cardiovascular disease mortality (Males).";
PROC PRINT DATA=proj3.table4b LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

/* Supplemental Table 2 */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*ca_mort (0) = smoke / rl ties=efron;
WHERE female = 1;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4a_model_1_camort;
RUN;
QUIT;
DATA proj3.tab4a_model_1_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4a_model_1_camort;
RUN;
QUIT;
DATA proj3.tab4a_model_1_camort;
SET proj3.tab4a_model_1_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4a_model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
QUIT;
PROC SORT data=proj3.tab4a_model_1_camort;
by order;
RUN;
QUIT;
DATA proj3.tab4a_model_1_camort;
SET proj3.tab4a_model_1_camort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*ca_mort (0) = smoke age / rl ties=efron;
WHERE female = 1;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4a_model_2_camort;
RUN;
DATA proj3.tab4a_model_2_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4a_model_2_camort;
RUN;
DATA proj3.tab4a_model_2_camort;
SET proj3.tab4a_model_2_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4a_model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4a_model_2_camort;
by order;
RUN;
DATA proj3.tab4a_model_2_camort;
SET proj3.tab4a_model_2_camort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*ca_mort (0) = smoke age health edu alc_cons health edu alc_cons/ rl ties=efron;
WHERE female = 1;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4a_model_3_camort;
RUN;
DATA proj3.tab4a_model_3_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4a_model_3_camort;
RUN;
DATA proj3.tab4a_model_3_camort;
SET proj3.tab4a_model_3_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4a_model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4a_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4a_model_3_camort;
by order;
RUN;
DATA proj3.tab4a_model_3_camort;
SET proj3.tab4a_model_3_camort;
drop order;
RUN;
QUIT;

DATA proj3.table4a_ca;
LENGTH Label $50.;
SET proj3.tab4a_model_1_camort proj3.tab4a_model_2_camort proj3.tab4a_model_3_camort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table4a_ca.pdf";
TITLE "Supplemental Table 2A. Sex-stratified relationship of smoking status with cancer mortality (Females).";
PROC PRINT DATA=proj3.table4a_ca LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;

/* MEN */

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*ca_mort (0) = smoke / rl ties=efron;
WHERE female = 0;
estimate "Model 1" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4b_model_1_camort;
RUN;
DATA proj3.tab4b_model_1_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4b_model_1_camort;
RUN;
DATA proj3.tab4b_model_1_camort;
SET proj3.tab4b_model_1_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4b_model_num = "Model 1";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4b_model_1_camort;
by order;
RUN;
DATA proj3.tab4b_model_1_camort;
SET proj3.tab4b_model_1_camort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") / param=ref;
MODEL futime*ca_mort (0) = smoke age / rl ties=efron;
WHERE female = 0;
estimate "Model 2" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4b_model_2_camort;
RUN;
DATA proj3.tab4b_model_2_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4b_model_2_camort;
RUN;
DATA proj3.tab4b_model_2_camort;
SET proj3.tab4b_model_2_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4b_model_num = "Model 2";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4b_model_2_camort;
by order;
RUN;
DATA proj3.tab4b_model_2_camort;
SET proj3.tab4b_model_2_camort;
drop order;
RUN;
QUIT;

PROC PHREG DATA=proj3.john_clean2;
CLASS smoke (ref="Never smoker") health edu alc_cons health edu alc_cons/ param=ref;
MODEL futime*ca_mort (0) = smoke age health edu alc_cons health edu alc_cons/ rl ties=efron;
WHERE female = 0;
estimate "Model 3" smoke 1 /exp cl;
ods select nobs  CensoredSummary ParameterEstimates;
ODS OUTPUT ParameterEstimates=proj3.tab4b_model_3_camort;
RUN;
DATA proj3.tab4b_model_3_camort(KEEP = label hazardratio HRLowerCL HRUpperCL);
RETAIN label hazardratio HRLowerCL HRUpperCL;
SET proj3.tab4b_model_3_camort;
RUN;
DATA proj3.tab4b_model_3_camort;
SET proj3.tab4b_model_3_camort;
if label in ('Smoker Status Current daily <20 cpd', 'Smoker Status Current daily >=20 cpd', 'Smoker Status Ever less than daily', 'Smoker Status Former daily');
tab4b_model_num = "Model 3";
if label = 'Smoker Status Ever less than daily' then order=1;
if label = 'Smoker Status Former daily' then order=2;
if label = 'Smoker Status Current daily <20 cpd' then order=3;
if label = 'Smoker Status Current daily >=20 cpd' then order=4;
label tab4b_model_num = "Model";
format hazardratio 8.2 HRLowerCL 8.2 HRUpperCL 8.2;
RUN;
PROC SORT data=proj3.tab4b_model_3_camort;
by order;
RUN;
DATA proj3.tab4b_model_3_camort;
SET proj3.tab4b_model_3_camort;
drop order;
RUN;
QUIT;

DATA proj3.table4b_ca;
LENGTH Label $50.;
SET proj3.tab4b_model_1_camort proj3.tab4b_model_2_camort proj3.tab4b_model_3_camort;
FORMAT Label;
INFORMAT Label;
RUN;

ODS PDF FILE="&results.\Table4b_ca.pdf";
TITLE "Supplemental Table 2B. Sex-stratified relationship of smoking status with cancer mortality (Males).";
PROC PRINT DATA=proj3.table4b_ca LABEL;
FOOTNOTE "Reference: Never smoker"; 
FOOTNOTE2 "cpd, cigarettes per day";
FOOTNOTE3 "Model 1: Unadjusted.";
FOOTNOTE4 "Model 2: Adjusted for age, sex.";
FOOTNOTE5 "Model 3: Adjusted for age, sex, self-rated health, ducation group and alcohol consumption.";
RUN;
ODS PDF CLOSE;
TITLE;
FOOTNOTE;
FOOTNOTE2;
FOOTNOTE3;
FOOTNOTE4;
FOOTNOTE5;
