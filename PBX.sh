#!/bin/sh

echo "Write PBX ip:"
read PBX

echo "Write Store"
read Store

(echo " ########################### ST"$Store" #############################"
echo " define host{ "
echo "        use                     store-switches-host-template"
echo "        host_name               ST"$Store"-PBX"
echo "        alias                   PBX"
echo "        address                 $PBX"
echo "        hostgroups              +ST"$Store"_h"
echo "        parents                 California_switch_01"
echo "        }"
echo " define service{"
echo "        use                     store-switches-service-template"
echo "        host_name               ST"$Store"-PBX"
echo "        service_description     PING"
echo "        check_command           check_ping!100.0,20%!500.0,60%"
echo "        }" )>> ./PBX.cfg


