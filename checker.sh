#!/bin/bash

#Welcome to the simplified Navixy Standalone Status Checker!
#This script is meant as a quick check against common
#issues you might run into with your Linux server.

#Note, this is made to either be run as root or a user that
#has the correct rights to run the standalone server.
#This is also not an end-all solution, and is made for
#single-server setups.

#Please contact Navixy Support if you have any questions!

#function to check the state of the service given and try and restart it
#echoes a message after 5 attempts
function service_check {
	i=0
	state=$(service $1 status | grep "Active: active (running)")

	if [[ -n "$state" ]]; then
		echo "$1 online"
	elif [[ -z "$state" && $i < 5 ]]; then
		echo "$1 is offline. Starting instance..."
		service "$1" start
		sleep 5
		((i++))
		service_check $1
	elif [[ i -ge 5 ]]; then
		echo "$1 failed to start. Please troubleshoot by reviewing the associated logs."
	fi
}

#check ports function
#this is checking the nc exit status
#https://stackoverflow.com/questions/55889713/passing-output-of-a-netcat-command-to-a-variable-or-piping-through-read-utility
function check {
	if ! nc -dvzw1 $1 $2 2>/dev/null; then
		echo "$2 port failure"
	fi
}

# Function to check for valid yes or no input
function check_yes_no() {

	# Check if the input matches the regular expression
	if [[ $1 =~ $yes_regex ]]; then
		echo 1
		#return 0 # Valid input
	elif [[ $1 =~ $no_regex ]]; then
		#check for no
		echo 2
	elif [[ $1 =~ $quit_regex ]]; then
		#check for exit/quit
		echo 3
	else
		echo 4
	fi
}

echo "Welcome to the simple Navixy Standalone Status Checker!"
echo "This script is recommended to be run on the Standalone"
echo "Server, and as root or a user that has access to the"
echo "Standalone services as well as nginx and MySQL."

read -p "Would you like to proceed? Y/n " bool

echo ""
echo ""

# Regular expression to match "yes" or "no" in various cases
yes_regex='^(yes|y|Yes|Y|YES)$'
no_regex='^(no|n|No|N|NO|)$'
quit_regex='^(quit|Q|q|exit)$'

#checking what the value meant
bool=$(check_yes_no "$bool")

case $bool in
1)
	#if yes, check domain information

	echo "Checking domain..."
	echo ""
	#check standalone version
	version=$(cat /home/java/api-server/VERSION | grep navixy)
	echo $version

	echo ""

	#calling functions to check against
	service_check "mysql"
	service_check "nginx"
	service_check "api-server"
	service_check "tcp-server"
	service_check "sms-server"

	echo ""

	#port checking
	#hardcoded ports to check
	singles=(4779 6994 7669 7677 7685 7761)
	start_port1=46982
	end_port1=47000
	start_port2=47650
	end_port2=47780
	domain="localhost"

	echo "Checking ports..."
	#check the array of singular ports
	for port in "${singles[@]}"; do
		check "$domain" "$port"
	done

	#check the first sequence
	for port1 in $(seq "$start_port1" "$end_port1"); do
		check "$domain" "$port1"
	done

	#check the second sequence
	for port2 in $(seq "$start_port2" "$end_port2"); do
		check "$domain" "$port2"
	done

	;;
2)
	#if no
	#note these below are mainly placeholders for other options
	echo "Exiting..."
	exit
	;;
3)
	#quit
	echo "Quitting..."
	exit
	;;
*)
	echo "Unexpected error occurred. Exiting..."
	exit
	;;
esac
