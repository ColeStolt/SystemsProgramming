#!/usr/bin/gawk

#calculates the coterminal angle (0 <= coterminal <= 360) of a given angle.

{if($1>0 && NR>1)

        printf("%5d  %d\n", $1,  $1 % 360)

else if($1<0&&((-1*$1)-360)<=0 && NR>1)

        printf("%5d  %d\n", $1, $1+360)

else if (NR>1)

        printf("%5d  %d\n", $1, $1+360*(int( $1/360-1)*-1))
}
