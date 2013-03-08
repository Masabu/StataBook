
clear all

set mem 100m
set obs 100

program mysim_r
version 11
regress mpg weight
end

use http://www.stata-press.com/data/r11/auto, clear


bootstrap, rep(10) saving(temp/boot.dta, replace) : regress mpg weight

use temp/boot.dta, clear

bstat  
