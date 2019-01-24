#!/bin/bash

timeShtampFile="/vagrant/script/timeShtamp"
accessLog="/var/log/nginx/access.log"
errorLog="/var/log/nginx/error.log"
configReport=(`cat /vagrant/configReport`)
PIDfile="/tmp/reportOtus.pid"
x=${configReport[0]} 
y=${configReport[1]}
emailForReport=${configReport[2]}

    

checkRunning(){
    if [ -f $PIDfile ]
    then
        echo "Job is already running!"
        exit
    fi
    touch $PIDfile
    trap 'rm -f "$PIDfile"; exit $?' SIGINT SIGTERM SIGQUIT
    rm -f $PIDfile
    trap - INT TERM EXIT
}


checkTimeShtampFile()
{
    if [[ -f $timeShtampFile ]]
    then
        str=(`awk '{print $1, $2}' $timeShtampFile`)
        infoMessage="Event from $(awk '{print $3}' timeShtampFile) to $(date '+%d/%m/%Y:%H:%M:%S')"            
     else
        touch $timeShtampFile
        echo "0 0" > $timeShtampFile
        str=(`awk '{print $1, $2}' $timeShtampFile`)
        infoMessage="it first messages of script, and him parsing all info for {access,error}.log next messages will not contain them"
    fi
}


finfoMessage(){
    echo "Uptime Server's: "
    echo $infoMessage
    
}

sortInfo(){
sort \
| uniq -c \
| sort -rn
}

print_access_log(){
    echo "****************************************"
    echo "*****  Top $x IP client addresses  *****"
    echo "****************************************"
    echo 
    (printf "Count: IpAddress: \n"
    cat $accessLog \
        | sed  -n ''$(( ${str[0]} + 1 ))',$p' \
        | awk '{print $1}' \
        | sortInfo \
        | head -n $x) \
        | column -t 
    echo
    echo 
    echo "****************************************"
    echo "***   Top $y requested addresses     ***"
    echo "****************************************"
    echo 
    (printf "Count: Address: \n"; 
    cat $accessLog \
        | sed  -n ''$(( ${str[0]} + 1 ))',$p' \
        | awk '{print $7}' \
        | sortInfo \
        | head -n $y)  \
        | column -t 
    echo
    echo "****************************************"
    echo "**********   Response Code    **********"
    echo "****************************************"
    echo 
    (printf "Count: ResponseCode: \n"; 
    cat $accessLog \
        | sed  -n ''$(( ${str[0]} + 1 ))',$p' \
        | awk '{print $9}' \
        | sortInfo) \
        | column -t 
    echo   

}

print_error_log(){
    echo "****************************************"
    echo "************   Last errors  *************"
    echo "****************************************"
    echo 
    
    cat $errorLog \
        | sed -n ''$(( ${str[1]} + 1 ))',$p' \
        
    echo
    echo 
    
}

checkNumbLine(){
    accessNumbLine=(`wc -l /var/log/nginx/access.log | awk '{print $1}'`)
    errorNumbLine=(`wc -l /var/log/nginx/error.log | awk '{print $1}'`)
    timeFineshed=$(date '+%d/%m/%Y:%H:%M:%S')
    echo $accessNumbLine $errorNumbLine $timeFineshed > $timeShtampFile
}

sendEmail(){
    cat tempFile | mailx -s "Home Work Alexey 4he" $emailForReport
}

checkRunning
checkTimeShtampFile
finfoMessage > tempFile
print_access_log >> tempFile
print_error_log >> tempFile
sendEmail
checkNumbLine