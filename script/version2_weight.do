
*********************************************
**
** Syntax for Stata for Survey Research Data Analysis
**
** revised for 2nd edition
**
** Masa Aida   Oct 2012
**
*********************************************


clear
set mem 100m
cd "C:\My_Document\Dropbox\StataBook"

insheet using sample2.csv, clear

gen strataID = 0

local s = 1
forvalues r = 1(1)6{

	forvalues c = 1(1)5{
	
		replace strataID = `s' if citysize == `c' & region == `r'

		local ++s
	
	}

}


tab strataID region
tab strataID citysize

gen Stratum_Pop = 0
replace Stratum_Pop = 1910605 if strataID == 1
replace Stratum_Pop = 5190967 if strataID == 2
replace Stratum_Pop = 1806037 if strataID == 3
replace Stratum_Pop = 841226 if strataID == 4
replace Stratum_Pop = 310929 if strataID == 5
replace Stratum_Pop = 10356420 if strataID == 6
replace Stratum_Pop = 17190217 if strataID == 7
replace Stratum_Pop = 3114404 if strataID == 8
replace Stratum_Pop = 474498 if strataID == 9
replace Stratum_Pop = 163039 if strataID == 10
replace Stratum_Pop = 1436947 if strataID == 11
replace Stratum_Pop = 8194987 if strataID == 12
replace Stratum_Pop = 1833729 if strataID == 13
replace Stratum_Pop = 244534 if strataID == 14
replace Stratum_Pop = 62764 if strataID == 15
replace Stratum_Pop = 3639376 if strataID == 16
replace Stratum_Pop = 8793660 if strataID == 17
replace Stratum_Pop = 940016 if strataID == 18
replace Stratum_Pop = 303996 if strataID == 19
replace Stratum_Pop = 89424 if strataID == 20
replace Stratum_Pop = 744837 if strataID == 21
replace Stratum_Pop = 5199204 if strataID == 22
replace Stratum_Pop = 1065317 if strataID == 23
replace Stratum_Pop = 414430 if strataID == 24
replace Stratum_Pop = 209536 if strataID == 25
replace Stratum_Pop = 1533406 if strataID == 26
replace Stratum_Pop = 5289802 if strataID == 27
replace Stratum_Pop = 1759087 if strataID == 28
replace Stratum_Pop = 623232 if strataID == 29
replace Stratum_Pop = 180766 if strataID == 30


log using tab_9_2.txt,replace text

tab Stratum_Pop

log close

**************************************************
**
** check set up
**
**************************************************

gen weight = 1
survwgt poststratify weight, by(strataID) totvar( Stratum_Pop) replace

svyset cityid [pweight=weight], strata(strataID)
svydes

svy: tab region citysize, percent format(%3.2f)
