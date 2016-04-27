#!/bin/bash

strSubNet=$1
. ./common.sh

# restore the key
fun_restore_key

# deploy another monitor
fun_get_public_ip $strSubNet
echo RstrSubNet=$strSubNet
echo strBridgedIP=$strBridgedIP

fun_mon $strBridgedIP $strSubNet"0"
