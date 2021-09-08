
*********************************************
**
** Syntax for Stata for Survey Research Data Analysis
**
** revised for 2nd edition
**
** Masa Aida   Oct 2012
** 
** Revised again in 2021
**
*********************************************


clear all
version 15

cd "/home/masabu/StataBook"

*** read target counts

import delimited "data/target.tsv", clear 

total target, over(citysize)
matrix total_citysize = e(b)
matrix rownames total_citysize= citysize
matrix list total_citysize

total target, over(region)
matrix total_region = e(b)
matrix rownames total_region=region
matrix list total_region

gen strataID = region  + citysize * 10

total target, over(strataID)
matrix total_strata = e(b)
matrix rownames total_strata=strataID
matrix list total_strata

*** survey response
insheet using data/sample2.csv, clear

gen strataID = region + citysize* 10 

gen weight = 1
gen target = 1

** weight on the marignal of city size only
ipfraking [pw=weight], ctotal(total_citysize) generate(rakedwgt1)

** weight on the marignal of region size only
ipfraking [pw=weight], ctotal(total_region) generate(rakedwgt2)

** weight on the marignal of both citysize and region size 
ipfraking [pw=weight], ctotal(total_citysize total_region) generate(rakedwgt3)


** weight on the marignal of both citysize and region size 
ipfraking [pw=weight], ctotal(total_strata) generate(rakedwgt4)



capture program drop myDeff
program define myDeff,

	** approximation by Kish 1992
	
	quietly: su `1'
	local DEFF = `r(Var)' / `r(mean)' / `r(mean)' + 1
	
	local N = `r(N)'
	local N_effective = round(`r(N)' / `DEFF')
	
	display "design effect is `DEFF'"
	display "Nominal N-size is `N'"
	display "Effective N-size is `N_effective'"

end


myDeff rakedwgt1
myDeff rakedwgt2
myDeff rakedwgt3
myDeff rakedwgt4


**************************************************
**
** check set up
**
**************************************************


svyset _n [pweight=weight]
svy: tabulate citysize region, count format(%1.0f)

svyset _n [pweight=rakedwgt1]
svy: tabulate citysize region, count format(%1.0f)

svyset _n [pweight=rakedwgt2]
svy: tabulate citysize region, count format(%1.0f)

svyset _n [pweight=rakedwgt3]
svy: tabulate citysize region, count format(%1.0f)

svyset _n [pweight=rakedwgt4]
svy: tabulate citysize region, count format(%1.0f)





/*

*** for table 9-3
log using log/tab_9_3.txt,replace text

tab weight

log close


*** for table 9-4
log using log/tab_9_4.txt,replace text

svydes

log close

*** for table 9-5
log using log/tab_9_5.txt,replace text

tab citysize

log close

*** for table 9-6
log using log/tab_9_6.txt,replace text

svy: tabulate citysize, percent

log close

*** for table 9-7
log using log/tab_9_7.txt,replace text

tabulate region citysize, cell nofreq

log close

*** for table 9-8
log using log/tab_9_8.txt,replace text

svy: tabulate region citysize, percent format(%3.2f)

log close

*******************************************************************
**
** Analysis
**
*******************************************************************

gen    SameLocation = q4
recode SameLocation 2/7 = 0 9 = . 999 = .

gen Urban = citysize
recode Urban 1/3 = 1 4/5 = 0

*** for table 9-9
log using log/tab_9_9.txt,replace text

tab Urban SameLocation, row

log close

*** for table 9-10
log using log/tab_9_10.txt,replace text

mean SameLocation

log close


*** for table 9-11
log using log/tab_9_11.txt,replace text

svy : tab Urban SameLocation, row

log close

*** for table 9-12
log using log/tab_9_12.txt,replace text

svy : mean SameLocation

log close

*/



