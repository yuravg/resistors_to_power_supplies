#!/usr/bin/env tclsh

# calculation_resistors.tcl --
#
#       Calculation of resistor divider for some Power Supplies:
#        - LTC3564, LT3065
#        - ADP122/ADP123
#        - LT8610

# Standards nominal resistance
set stdR { 1 1.1 1.21 1.5 1.6 1.78 2.37 2.74 3.32 4.75 6.98 9.76 }
append stdR { 10.2 12.1 15.4 16.9 20 22.1 23.7 24.9 30.1 30.9 32.4 }
append stdR { 33.2 54.9 100 1.07 107 115 11.8 121 127 130 140 147 }
append stdR { 162 169 182 191 200 210 274 332 365 562 5.62 60.4 }
append stdR { 61.9 64.9 68.1 75.0 768 76.8 84.5 88.7 909 93.1 95.3 }

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