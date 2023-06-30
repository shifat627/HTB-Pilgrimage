#!/bin/bash
#Extracting File Content from Imagemagick image. HTB pilgrimage
found=0
i=0
payload=''

[ $# -ne 1 ] && { echo "usage $0 <file>"; exit; }

while read line
do
    
    [ $found -eq 2 ] && payload=$payload$line #string concat
    #[ $found -eq 2 ] && { found=3; read -r data <&0; echo $data; read -r data <&0; echo $data; }

    if [ -z "$line" ] && [ $found -eq 2 ];then
        break
    fi

    if [ -z "$line" ] && [ $found -eq 1 ];then
        found=2
        read -r garbagedata <&0 # reading from buffer.
        #echo $garbagedata
    fi

    if [[ "$line" =~ "Raw profile type:" ]] && [ $found -eq 0 ]
    then
        #echo "I got it . Line $i"
        found=1
    fi


    
done <<< $(identify -verbose $1) # <<< for avoding sub shell while. cause that would make any outside variable is changed inside loop is temporary

#echo "This result is: "
echo $payload
python3 -c "print(bytes.fromhex('${payload}').decode('utf-8'))"
