
***************************
**
**  example of R2
**
***************************

clear all

set mem 100m
set obs 100

use http://www.stata-press.com/data/r11/auto, clear

regress mpg weight
ereturn list

bootstrap R2 = e(r2), rep(10) saving(temp/boot.dta, replace) : ///
regress mpg weight



use temp/boot.dta, clear

bstat  
