start
    = lines

lines
    = line "\n" lines
    / line

line
    = "paper" whitespace color:number

number
    = [0-9]+

whitespace
    = [ \t]*