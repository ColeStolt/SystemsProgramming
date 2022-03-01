curve(){
        arr=("$@")
        curve="$6"

        for((i=0 ; i<5; i=$i+1))
        do
                echo "grades[$i] = $((arr[$i]+curve))"
        done
}

if [ $# -eq 0 ]
then
        echo 'usage: ./rec05.sh <curve amount>'

else
        x=1

        for((i=0; $i<5; i=$i+1))
        do
                read -p "Enter QUIZ #$x: " var
                vars[$i]=$var
                x=$((x+1))
        done
        echo 'Curved Grades:'
        curve "${vars[@]}" "$1"
fi
