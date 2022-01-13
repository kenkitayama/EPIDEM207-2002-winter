/*****************************************************************************
NAME: Epi207_Assignment1_PartA.sas
DATE: 01/13/2022
CREATED BY: Ken Kitayama 
PURPOSE: To import data for Assignment 1
******************************************************************************/

LIBNAME assignment1 "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1";

PROC IMPORT OUT= assignment1.kim2021 
			DATAFILE= "C:\Users\Ken Kitayama\Dropbox\Dropbox\UCLA FSPH\2021-2022\Winter 21-22\EPI 209 - Reproducibility in Epidemiologic Research\Assignments\Assignment 1\pone.0248856.s001.xlsx" 
            DBMS=xlsx REPLACE;
     SHEET="table1_021621";
     GETNAMES=YES;
RUN;
