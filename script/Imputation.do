

clear all
set mem 50m
cd ~/StataBook

insheet using data/sample2.csv, case name


*******************************************
**
** recode missing values
**
*******************************************


foreach var of varlist q1 q2 q3 q4 q6 q5 q5x1 q5x2{

  di "Recoding variable `var'" 
  replace `var' = . if `var' == 999
  replace `var' = . if `var' == 888
  
}


/*
set up environmental variable for imputation

mi set mlong : this will create imputed observersation and add them in row,
this is recommended way of creating imputed dataset.

mi set M = 5 : create 5 imputed dataset.  5 will be sufficient. (Rubin, 1987)

mi register : specify variables to be imputed

*/

capture log close
log using log/Imputation.log, replace text

tab1 q1 q2 q3 q4 q6 q5 q5x1 q5x2 ,m

mi set flong
mi set M = 5
set seed 9875783

gen    EverWorked  = q5
recode EverWorked 1/3 = 1 4 = 0

gen    Occupation = q5x1
recode Occupation 1 = 1 2 = 2 3/4 = 3 5/6 = 5 7/8 = 7

gen    Industry = q5x2
recode Industry 7 = 3 6 = 4

mi register imputed q3 q4 EverWorked Occupation Industry q6

* q1 and q2 are binary
* q3 and q4 can be viewed as ordinal
* q5, Occupation and Industry are nominal

mi impute chained                   ///
(ologit                   , ascontinuous omit(i.EverWorked i.Occupation i.Industry))  q3 q4 q6  ///
(logit                    , omit(i.Occupation i.Industry)) EverWorked                   ///
(mlogit if EverWorked == 1,  omit(i.EverWorked i.Occupation)) Industry       ///
(mlogit if EverWorked == 1,  omit(i.EverWorked i.Industry))   Occupation     ///
  = q1 q2 , replace


log close




/*  
mi impute chained      ///
(ologit) q3 q4         ///
= q1 q2 , chainonly savetrace(impstats,replace) burnin(100)

use impstats.dta, clear

describe

odbc insert iter m q4_mean q4_sd q3_mean q3_sd ///
 , table(Imputation_Test) dialog(complete) dsn(Nutria) create
*/

  









