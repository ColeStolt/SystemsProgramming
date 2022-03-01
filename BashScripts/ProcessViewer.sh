#!/bin/bash

# Script that prints all the users and their processes
# Script also prints specific users and their given processes based on command line arguments

# Cole Stoltz


ctrl_c(){                                               # Function called when ctrl+c is called
        echo " (SIGINT) received"
        echo "Are you sure you wish to quit? (y/n): "
        read answer
        if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
        then
                rm users.txt
                exit 1
        else
                echo "Continuing..."
                return
        fi
}

trap "ctrl_c" SIGINT                                    # Trap and call function when ctrl+c is called

while true                                              # Infinite loop
do
        date
        echo "User ID                   Count"          # Print header
if [ $# -eq 0 ]                                         # Check if there are no arguments
then
        ps -eo user=|sort|uniq -c|gawk '{if($2 != "systemd-resolve" && $2 != "systemd-timesync")printf("%s                      %d\n", $2, $1)}'        # Pipe into awk for formatting

        totalUsers=$(w|wc -l)                           # Assigns total users
        processes=$(ps -e|wc -l)                        # Assigns total processes
        echo "$totalUsers USERS, TOTAL PROCESSES $processes"
        sleep 5                                         # Waits for 5 seconds before updating
        echo                                            # Used for a new line
else
        for arguments in "$@"                           # Iterates through all arguments entered
        do
                w $arguments > users.txt                # Gets specific data for a users
                gawk '{if(NR>2)printf("%s                         ", $1)}' users.txt    # Parses data to print
                ps -U $arguments|wc -l                  # Displays processes for a given user
                x=$(ps -U $arguments|wc -l)             # Temp variable for processes
                t=$((x+t))                              # Adds all the processes together
        done
        t=$((t-1))                                      # For some reason processes are off by one
        totalUsers="$#"                                 # Assign total users as the number of arguments
        echo "$totalUsers USERS, TOTAL PROCESSES $t"    # Print total users and number of total processes
        t=0                                             # Reset total counter
        sleep 5                                         # Wait for 5 seconds
        echo
fi
done
