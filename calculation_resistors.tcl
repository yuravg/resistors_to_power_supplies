#!/usr/bin/env tclsh

# calculation_resistors.tcl --
#
#       Calculation of resistor divider for some Power Supplies:
#        - LTC3564, LT3065
#        - ADP122/ADP123
#        - LT8610
#        - ADP3334

set tcl_precision 5

# Standard value decade for 1% resistors
# NOTE: List of resistors *NOT COMPLETE*! Only the resistors that I use are listed.
set stdR    { 1 1.07 1.1 1.5 1.6 1.78 2.74 3.32 5.62 9.76 10.2 11.8 15.4 16.9 20 22.1 }
append stdR { 23.7 24.9 30.1 30.9 32.4 33.2 43.2 52.3 54.9 60.4 61.9 64.9 75.0 78.7 }
append stdR { 84.5 88.7 90.9 93.1 95.3 100 107 121 127 140 147 162 169 182 191 200 210 }
append stdR { 237 274 301 332 365 412 432 453 475 562 634 698 768 866 909 1000 }

# Write to files
proc writeFile {fname strHeader vList} {
    set pFile [open $fname w]
    set vListSorted [lsort -real -index 2 $vList]
    puts $pFile "$strHeader"
    foreach i $vListSorted {
        puts $pFile $i
    }
    close $pFile
    puts "write: '$fname'"
}

# LTC3564, LT3065
set headerLTC3564 "Power Supplies: LTC3564, LT3065
 Output Voltage Programming:
  Vout = 0.6V ( 1 + R2/R1)

R1(connect to gnd); R2;    Vout"

proc calcLTC3564 {r1 r2 vName} {
    upvar $vName v
    set v [expr 0.6*(1+$r2/$r1)]
}

# ADP122/ADP123
set headerADP122 "Power Supplies: ADP122/ADP123
Output Voltage Programming:
  Vout = 0.5V ( 1 + R1/R2)

R1; R2(connect to gnd);    Vout"

proc calcADP122 {r1 r2 vName} {
    upvar $vName v
    set v [expr 0.5*(1+$r1/$r2)]
}

# LT8610
set headerLT8610 "Power Supplies: LT8610
 FB Resistor Network:
  R1 = R2 ( Vout/0.8 - 1)

R1; R2(connect to gnd);    Vout"

proc calcLT8610 {r1 r2 vName} {
    upvar $vName v
    set v [expr 0.8*(1+$r1/$r2)]
}

# ADP3334
set headerADP3334 "Power Supplies: ADP3334
 Output Voltage:
  Vout = 1.178 ( R1/R2 + 1 )

R1; R2(connect to gnd);    Vout"

proc calcADP3334 {r1 r2 vName} {
    upvar $vName v
    set v [expr 1.178*($r1/$r2 + 1)]
}

# Start:
puts "Calculation Power Supplies resistors ..."

set vList {}
foreach r1 $stdR {
    foreach r2 $stdR {
        calcLTC3564 $r1 $r2 vout
        set voutMax 5.5
        if {$vout < $voutMax} {
            lappend vList "$r1\t$r2\t\t$vout"
        }
    }
}
writeFile "vout_ltc3564.log" $headerLTC3564 $vList

set vList {}
foreach r1 $stdR {
    foreach r2 $stdR {
        calcADP122 $r1 $r2 vout
        set voutMax 5.5
        if {$vout < $voutMax} {
            lappend vList "$r1\t$r2\t\t$vout"
        }
    }
}
writeFile "vout_adp122.log" $headerADP122 $vList

set vList {}
foreach r1 $stdR {
    foreach r2 $stdR {
        calcLT8610 $r1 $r2 vout
        set voutMax 42
        if {$vout < $voutMax} {
            lappend vList "$r1\t$r2\t\t$vout"
        }
    }
}
writeFile "vout_lt8610.log" $headerLT8610 $vList

set vList {}
foreach r1 $stdR {
    foreach r2 $stdR {
        calcADP3334 $r1 $r2 vout
        set voutMax 10.1
        if {$vout < $voutMax} {
            lappend vList "$r1\t$r2\t\t$vout"
        }
    }
}
writeFile "vout_adp3334.log" $headerADP3334 $vList
