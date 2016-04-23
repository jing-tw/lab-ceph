#!/bin/bash

Gateway_Subnet=`ip r | grep default | cut -d ' ' -f 3|awk -F '[.]' '{printf "%s.%s.%s.\n",$1,$2,$3}'`

Gateway_Subnet=${Gateway_Subnet} vagrant up

