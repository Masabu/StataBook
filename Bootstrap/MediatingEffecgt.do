


clear all
cd "C:\My_Document\My Box Files\Masahiko Aida\Bootstrap"
set mem 10m

use DcorpsData.dta , clear

** bootstrap T

su OBAMA_THERM

scalar theta = r(mean)
scalar se    = sqrt(r(Var) / r(N))

di theta, se








bsample _N
quietly: reg  OBAMA_THERM i.PARTY_ID_COMBINED
scalar mean = e(r2)
scalar se   = r(sd)
scalar t    =  mean - th



reg  OBAMA_THERM i.PARTY_ID_COMBINED

bootstrap R2 = e(r2), rep(100) saving(temp/bootresult.dta, replace) : reg  OBAMA_THERM i.PARTY_ID_COMBINED

use temp/bootresult.dta, clear
sort R2
gen ID = _n
su R2, de
scalar mean = r(mean)
scalar se   = r(sd)

** contstruct 95% C.I.
** naive method

di mean - 1.96*se
di mean
di mean + 1.96*se






keep if OBAMA_THERM != .
keep if PARTY_ID_COMBINED != .
keep if Conservative != .

** Y = b'*X
reg OBAMA_THERM PARTY_ID_COMBINED

matrix temp = e(b)
scalar b1 = temp[1,1]
display b1

** M = a*X
reg Conservative PARTY_ID_COMBINED 

matrix temp = e(b)
scalar a = temp[1,1]
display a


** Y = b*X + c*M
reg OBAMA_THERM PARTY_ID_COMBINED Conservative

matrix temp = e(b)
scalar b2 = temp[1,1]
scalar c  = temp[1,2]

display b2 c

** b' - b =  a*c

display b1 - b2
display a*c

*********************************************************
**
** compare SE by delta method and bootstrap
**
*********************************************************

*** naive bootstrap

matrix RESULTS = J(500,7,.)

forvalues b = 1(1)500{

	preserve
		
		bsample _N

		** store index in 1st col
		matrix RESULTS[`b',1] = `b'

		** store beta of indep variable of interest
		** direct effect
		** Y = b1*X

		reg OBAMA_THERM PARTY_ID_COMBINED
		matrix temp = e(b)
		scalar b1 = temp[1,1]

		matrix RESULTS[`b',2] = b1

		** effect of variable of interest to
		** mediating variable
		** M = a*X
		reg Conservative PARTY_ID_COMBINED 

		matrix temp = e(b)
		scalar a = temp[1,1]
		display a

		matrix RESULTS[`b',3] = a

		** Y = b*X + c*M
		reg OBAMA_THERM PARTY_ID_COMBINED Conservative

		matrix temp = e(b)
		scalar b2 = temp[1,1]
		scalar c  = temp[1,2]

		display b2 c

		matrix RESULTS[`b',4] = c
		matrix RESULTS[`b',5] = b2

		** b' - b =  a*c
		display b1 - b2
		display a*c

		matrix RESULTS[`b',6] = b1 - b2
		matrix RESULTS[`b',7] = a*c

	restore
		
}

drop _all

svmat RESULTS


save ForGraph.dta, replace
shell "C:\Program Files\R\R-2.13.2\bin\Rscript.exe" Graph.R

**************************************************

