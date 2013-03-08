

**
** create dataset for mediating effect analysis
**

clear all

set mem 500m

use if regex(SURVEY_CLIENT, "Corps") == 1 & SURVEY_DATE >= 20120101 ///
& regex(SURVEY_GEOGRAPHY, "National") == 1 using "L:\Analytics_Share\AFL_PC\Consortium files\Data\front_end_database.dta" , clear

ds , has(type numeric)
di "`r(varlist)'"

foreach var of varlist `r(varlist)' {

	quietly: su `var'
	if (`r(N)' == 0){
	
		drop `var'
	
	}

}


su OBAMA_THERM 
recode OBAMA_THERM 101/203 = .
su OBAMA_THERM 

su PARTY_ID_COMBINED

tab IDEOLOGY

gen     Liberal = .
replace Liberal = 1 if IDEOLOGY == 1
replace Liberal = 0 if IDEOLOGY == 2 & IDEOLOGY == 3

gen     Conservative = .
replace Conservative = 1 if IDEOLOGY == 3
replace Conservative = 0 if IDEOLOGY == 1 & IDEOLOGY == 2

keep  Liberal Conservative PARTY_ID_COMBINED OBAMA_THERM

cd "L:\Analytics_Share"

save DcorpsData.dta, replace




