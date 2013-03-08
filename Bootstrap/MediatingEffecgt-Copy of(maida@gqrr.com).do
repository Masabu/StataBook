


clear all
cd "C:\My_Document\My Box Files\Masahiko Aida\Bootstrap"
set mem 10m
set matsize 500

use DcorpsData.dta , clear

capture program drop mysim_r
program mysim_r
	version 11
	syntax name(name=bvector), res(varname)
	tempvar y rid
	local xvars : colnames `bvector'
	local cons _cons
	local xvars : list xvars - cons
	matrix score double `y' = `bvector'
	gen long `rid' = int(_N*runiform()) + 1
	replace `y' = `y' + `res'[`rid']
	regress `y' `xvars'
end


capture program drop Ratio
program define Ratio , eclass 

	version 11
	syntax varlist

	reg `1' `2'
	
	matrix temp = e(b)
	scalar b1 = temp[1,1]
	display b1
	ereturn scalar Result = b1
 
end

keep if OBAMA_THERM != .
keep if PARTY_ID_COMBINED != .
keep if Conservative != .

Ratio OBAMA_THERM PARTY_ID_COMBINED

simulate, reps(200) nodots: Ratio OBAMA_THERM PARTY_ID_COMBINED

bstat, stat( _b_PARTY_ID_COMBINED) n(`n')

bootstrap result = e(Result), bca rep(10) : Ratio OBAMA_THERM PARTY_ID_COMBINED



** Y = b'*X
reg OBAMA_THERM PARTY_ID_COMBINED

matrix temp = e(b)
scalar b1 = temp[1,1]
display b1

reg  OBAMA_THERM i.PARTY_ID_COMBINED
bootstrap R2 = e(r2) ,  bca rep(1000)  : reg  OBAMA_THERM Liberal Conservative
estat bootstrap, all


drop if OBAMA_THERM == . | Liberal  == .
bootstrap r(rho) ,  bca rep(100) : corr   OBAMA_THERM Liberal 

estat bootstrap, all




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

