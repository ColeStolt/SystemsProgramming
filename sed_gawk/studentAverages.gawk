#!/usr/bin/gawk

BEGIN {print "Average Student Grades"} # Executes only once
BEGIN {print "Name              Average"} 

{if($3 == "A" && NR!= 1) # Ignore first line
        printf("%s %s    %.2f\n", $2, $1, ($4 + $5 + $6)/3 )} # calculate and print on same line
