#!/bin/sh

# Library
#. ./ip_utility.sh

# PATH TO YOUR HOSTS FILE
ETC_HOSTS=/etc/hosts

# Function: changehostname
# Usage
#    change_hostname vm2_test
# Return
#    0: Success
#    1: Fail
function change_hostname() {
    local hostname_file=/etc/hostname
    local hosts_file=/etc/hosts
    local newhostname=$1

    if [ -z "$newhostname" ]; then
        echo "Usage: changehostname HOSTNAME"
        return 1
    fi
   
    # check hostname
    valid_hostname $newhostname
    if [[ $? -eq 1 ]]; then
        #echo "Invalid hostname: $newhostname"
        return 1
    fi

    # update /etc/hostname
    # sudo -- sh -c -e "echo '$newhostname' > ${hostname_file}";
    echo "$newhostname" | sudo tee ${hostname_file}

    # update /etc/hosts
    sudo sed -i "s#^.*\b127.0.1.1\b.*\$#127.0.1.1\t${newhostname}#g" ${hosts_file}

    # update the machine hostname
    echo "Change name: $HOSTNAME -> $newhostname"
    sudo hostname ${newhostname}

    #sudo hostnamectl set-hostname $newhostname
}

#Function valid_hostanme
# Usage:
#    valid_hostname abc_123
#    if [[ $? -eq 0 ]]; then
#      echo  valid_hostname_test::OK
#    else
#       echo valid_hostname_test::Error
#    fi
# Return
#   0: valid
#   1: invalid
function valid_hostname(){
    local name=$1

    LC_CTYPE="C"
    name="${name//[^-0-9A-Z_a-z]/}"
    if [ "$name" != "" ] &&
       [ "$name" != "${name#[0-9A-Za-z]}" ] &&
       [ "$name" != "${name%[0-9A-Za-z]}" ] &&
       [ "$name" == "${name//-_/}" ] &&
       [ "$name" == "${name//_-/}" ] ; then
         if [[ $name == *"_"* ]]; then
             echo "valid_hostname::Error"
             return 1
         else
             echo "valid_hostname::OK"
             return 0
         fi
    else
        echo "valid_hostname::Error"
        return 1
    fi
}

function valid_hostname_test(){
    valid_hostname abc_123
    if [[ $? -eq 0 ]]; then
       echo  valid_hostname_test::OK
    else
        echo valid_hostname_test::Error
    fi

    valid_hostname "abc-123"
    if [[ $? -eq 0 ]]; then
        echo valid_hostname_test::OK
    else
        echo valid_hostname_test::Error
    fi

}


# Function: removehost
# Usage:
#   remove_host vm4
# Return:
#   0: success
#   1: fail
function remove_host() {
    local HOSTNAME=$1
    if [ -z "$HOSTNAME" ]; then
        echo "Usage: removehost HOSTNAME"
        return 1
    fi

    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
    then
        echo "$HOSTNAME Found in your $ETC_HOSTS, Removing now...";
        sudo sed -i".bak" "/$HOSTNAME/d" $ETC_HOSTS
        return 0
    else
        echo "$HOSTNAME was not found in your $ETC_HOSTS";
        return 1 
    fi
}

# Function: remove_host_array
# Usage:
#    HostnameArray=(vm1 vm2 vm3)
#    remove_host_array $HostnameArray
# Return
#    0: Success
#    1: Fail
function remove_host_array(){
    HostnameArray=$1
    for (( i=0; i<${#HostnameArray[@]}; i++)); do
       echo ${HostnameArray[i]}  
       remove_host ${HostnameArray[i]} 
    done
}

function remove_host_array_test(){
    HostnameArray=(vm1 vm2 vm3)
    remove_host_array $HostnameArray
}
 

function add_host_array(){
    HostNameArray=$1
    IPArray=$2

    for (( i=0; i<${#HostNameArray[@]}; i++)); do
       echo ${HostNameArray[i]} ${IPArray[i]} 
       add_host ${HostNameArray[i]} ${IPArray[i]} 
    done
}

function add_host_array_test(){
    HostNameArray=(vm1 vm2 vm3)
    IPArray=("10.109.62.118" "10.109.62.124" "10.109.62.138")
 
    add_host_array $HostNameArray $IPArray
}

# Function: addhost
# Usage:
#   . ./ip_utility.sh
#   add_host vm4 10.109.62.233
# Return:
#   0: success
#   1: fail
function add_host() {
    HOSTNAME=$1
    IP=$2
   
    valid_ip ${IP}
   
    if [[ $? -eq 1 ]]
    then 
        echo "Usage: addhost hostname ip"
        return 1
    fi

    HOSTS_LINE="$IP\t$HOSTNAME"
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
        then
            echo "$HOSTNAME already exists : $(grep $HOSTNAME $ETC_HOSTS)"
        else
            echo "Adding $HOSTNAME to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
                then
                    echo "$HOSTNAME was added succesfully \n $(grep $HOSTNAME /etc/hosts)";
                else
                    echo "Failed to Add $HOSTNAME, Try again!";
            fi
    fi
}
