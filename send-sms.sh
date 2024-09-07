#! /bin/bash

export TERM=vt100
export i
export s
export m
mob=09123332233:09122223322
function fun_send_sms () {
    mob2 = 'echo $mob | tr : " "' 
    for mobile in ${mob2[@]}
    do
    echo $mobile
    echo $error_message
    sleep 5
    cat << sms_send >/root/sms.txt
    send at+csmp=1,167,0,0
    send \r\n
    send at+cmgs="$mobile"
    send \r\n
    send $error_message
    send \032
    send exit
    ! kill minicom
    sms_send
    minicom -S /root/sms.txt
    
    sleep 6
    done
}

i=1
curl http://192.168.40.11:9093/api/v2/alerts > alert.txt
awk -F '**' '{i=2; while (i<=NF) {print $i; i=i+2}}' alert.txt > ts.txt
cat ts.txt >> ms.txt
s=$(wc -c alert.txt)
m=$(wc -m ms.txt)
if [[ $s != '3 alert.txt' ]]; then
        echo 1 > ok.txt
        while read line; do
                export error_message=$line
                fun_send_sms
                sleep 10
        done < ts.txt
elif [[ $i == $(cat ok.txt)  ]]; then
        error_message="Every Thing Is OK"
        fun_send_sms
        sleep
        echo 0 > ok.txt
        echo 0 > ms.txt
else
        echo 0 > ok.txt
        echo 0 > ms.txt
        echo 0 > alert.txt
        exit
fi