#!/bin/sh

echo "Developed by 4tuna kepperwork@gmail.com __ 2021"
echo "Write name:"                      #UPS Name for example   California-Rack1-APC
read name								#variable UPS read
echo "Write ip:"						#UPS IP
read ip									#variable IP read
echo "Write Site:"						#Name Site for example California => equivalent California.cfg on Nagios config
read "site"								#variable site read
echo "Write parent switch name"			#parrent equipment name "opcional"
read parent								#variable parent read

ip_end=`echo "$ip" | awk -F '.' '{print $4}' OFS='.'`    #slpit variable to last ip oktet 10.127.0.110  => 110
name=`echo $name'_'$ip_end`								 #Maked manual name  California-Rack1-APC 10.127.0.110 => California-Rack1-APC_110

parent_n=`echo "$name" | awk -F '-' '{print $1}' `       #split first part of variable California-Rack1-APC => California
parent_f=`echo $parent_n"-"$parent`						 #Maked manual parents "opcional" [California-Rack1-APC, Switch_California_01] => California-Switch_California_01 
 

(echo "###############################################################################"
echo "Add to UPS.sh"
echo "###############################################################################"
echo "define host{"
echo "        use             		esxi-servers-host-template"          				#template name 
echo "        host_name       		$name"        
echo "        alias                 $name"
echo "        address             	$ip"     
echo "        hostgroups            +$site"
echo "        parents               $parent_f"
echo "        }"
echo "###############################################################################"
echo "# SERVICES DEFINITIONS"
echo "###############################################################################"
echo "define service{"
echo "        use                     esxi-servers-service-template"
echo "        host_name               $name"
echo "        service_description     Ping"
echo "        check_command           check_ping!200.0,20%!600.0,60%"
echo "        check_interval   		  5"
echo "        retry_check_interval    1"
echo "        }"
echo ""
echo ""
echo "define service{"
echo "		use generic-service"
echo "		host_name $name"
echo "		service_description BatteryCapacity"
echo "		check_command check_snmp!-C public -o upsAdvBatteryCapacity.0 -l BatteryCapacity -P 1 -u % -w 75: -c 30:"
echo "		}"
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description BatteryTemperature"
echo "		check_interval 1"
echo "		check_command check_snmp!-C public -o upsAdvBatteryTemperature.0 -l BatteryTemperature -P 1 -u C -w 37 -c 40"
echo "		}"
echo ""
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description BatteryVoltage"
echo "		check_command check_snmp!-C public -o upsAdvBatteryActualVoltage.0 -l BatteryVoltage -P 1 -u V -w 52: -c 50:"
echo "		}"
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description InputVoltage"
echo "		check_command check_snmp!-C public -o upsAdvInputLineVoltage.0 -l InputVoltage -P 1 -u V -w 210: -c 200:"
echo "		}"
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description OutputVoltage"
echo "		check_command check_snmp!-C public -o upsAdvOutputVoltage.0 -l OutputVoltage -P 1 -u V -w 210: -c 200:"
echo "		}"
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description OutputLoad"
echo "		check_command check_snmp!-C public -o upsAdvOutputLoad.0 -l OutputLoad -P 1 -u % -w 70 -c 80"
echo "		}"
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description OutputCurrent"
echo "		check_command check_snmp!-C public -o upsAdvOutputCurrent.0 -l OutputCurrent -P 1 -u A -w 25 -c 30"
echo "		}"
echo "define service{"
echo "		use esxi-servers-service-template"
echo "		host_name $name"
echo "		service_description CommStatus"
echo "		check_command check_snmp!-C public -o upsCommStatus.0 -l CommStatus -P 1 -c :1"
echo "}"
echo ""
echo "###############################################################################") >> $site.cfg            #Save text to .cfg file
