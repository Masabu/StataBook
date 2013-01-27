

clear all
set mem 50m
set more off
cd ~/StataBook

insheet using data/sample2.csv, case name

/*
set up environmental variable for imputation

mi set mlong : this will create imputed observersation and add them in row,
this is recommended way of creating imputed dataset.

mi set M = 5 : create 5 imputed dataset.  5 will be sufficient. (Rubin, 1987)

mi register : specify variables to be imputed

*/

mi set flong
mi set M = 5
set seed 9875783

*******************************************
**
** recode missing values
**
*******************************************

capture log close
log using log/Recoding.log, replace text

	tab1  q1 q2 q3 q4 q6 q5 q5x1 q5x2 q6,m

	/*
	foreach var of varlist q1 q2 q3 q4 q6 q5 q5x1 q5x2{

		di "Recoding variable `var'" 
		replace `var' = . if `var' == 999
		replace `var' = . if `var' == 888  
	}
	*/


tab1 q1 q2 q3 q4 q6 q5 q5x1 q5x2 ,m

recode q3 999 = .
recode q4 999 = .
recode q5 999 = .
recode q6 999 = .

recode  q10 999 = .
recode  q10x1 888/999 = .
recode  q10x2 888/999 = .
replace q10x2num = . if q10x2num > 700

tab q10 q10x1 if _mi_m ==0, m

** rename variables into intuitive names
** for better readability of outputs

gen Gender     = q1
gen AgeShowa   = q2
gen Education  = q3
gen Residency  = q4
gen Income     = q6
gen NumAddress = q10x2num 


gen    EverWorked  = q5
recode EverWorked 1/3 = 1 4 = 0
 
gen     AddressBook = .
replace AddressBook = 1 if q10 == 1 & q10x1 == 1
replace AddressBook = 0 if q10 == 1 & q10x1 == 2
replace AddressBook = 0 if q10 == 2

tab NumAddress AddressBook if _mi_m == 0,m


log close

capture log close
log using log/Imputation.log, replace text

mi register imputed Education EverWorked Income AddressBook NumAddress

* Binary  : Gender, Everworked, AddressBook
* Ordinal : Education, Income 
* Nominal :
* Count   : NumAddress

mi impute chained                   ///
(ologit				, ascontinuous omit(NumAddress)) Education Income	///
(logit				, ascontinuous omit(NumAddress))  EverWorked		///
(logit				, ascontinuous omit(NumAddress))  AddressBook		///
(poisson if AddressBook == 1	, omit(AddressBook)) NumAddress		///  
  = Gender AgeShowa , replace noisily

tab AddressBook _mi_m ,m

su NumAddress if _mi_m == 0 ,de
su NumAddress if _mi_m == 1 ,de


log close




  
/*
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
*/
  



/*  
mi impute chained      ///
(ologit) q3 q4         ///
= q1 q2 , chainonly savetrace(impstats,replace) burnin(100)

use impstats.dta, clear

describe

odbc insert iter m q4_mean q4_sd q3_mean q3_sd ///
 , table(Imputation_Test) dialog(complete) dsn(Nutria) create
*/

clear all

exit














