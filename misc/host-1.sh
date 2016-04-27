#!/bin/bash

strSubNet=$1

. ./common.sh


fun_get_public_ip $strSubNet
echo RstrSubNet=$strSubNet
echo strBridgedIP=$strBridgedIP

fun_mon $strBridgedIP $strSubNet"0"
fun_save_key
