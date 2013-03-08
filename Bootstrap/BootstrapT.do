


clear all
cd "C:\My_Document\My Box Files\Masahiko Aida\Bootstrap"
set mem 10m
set matsize 500

use DcorpsData.dta , clear

** bootstrap T

su OBAMA_THERM

scalar theta = r(mean)
scalar se    = sqrt(r(Var) / r(N))
di theta, se

** boostrap
** Do it for 2000 times?

local B   = 2000
local REP = 500
local ITR = 4

forvalues i = 1(1)`ITR' {

	matrix BOOT = J(`REP',4,.)

	forvalues b = 1(1)`REP' {

		preserve

			di "bootstrap iteration of `b'"
			bsample _N

			quietly: su OBAMA_THERM
			scalar theta_b = r(mean)
			scalar se_b    = sqrt(r(Var) / r(N))
			*di theta_b, se_b
			
			scalar z = (theta_b - theta ) / se_b
			*di z

			matrix BOOT[`b',1] = `b' + (`i'-1)*500
			matrix BOOT[`b',2] = z
			matrix BOOT[`b',3] = theta_b
			matrix BOOT[`b',4] = se_b
		
			if (`b'==`REP'){
			
				matrix list BOOT
				drop _all
				svmat BOOT
				save Boot-T_`i'.dta, replace
			
			}
		
		restore
	}

}

use Boot-T_1.dta, clear
append using Boot-T_2.dta
append using Boot-T_3.dta
append using Boot-T_4.dta

save Boot-T_`i'.dta, replace
	

shell "C:\Program Files\R\R-2.13.2\bin\Rscript.exe" Boot-T.R

