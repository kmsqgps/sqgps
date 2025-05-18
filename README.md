# Navixy
Hello and welcome to the Navixy repository! Here you will find only one script, but more to follow!

## Navixy Standalone Checker
The script here called "checker.sh" is a simple script created to assist our clients with basic troubleshooting of their Standalone system. Once downloaded, you will need to run:
```
chmod +x checker.sh

```
in order to allow the file to run on the system, and:
```
./checker.sh
```
to run it. 

Within the script, we have the hostname as "localhost" however if you wish to use another option, please edit that within the file. 


## Navixy SubPaaS Clone Tool
The JavaScript code here is a simple tool created to assist with cloning devices across Admin Panels. This is based on the Panel hierarchy allowing for cloning between resellers and others, as long as they're underneath the same master panel. You will first need to provide your Admin Panel hash (https://developers.navixy.com/docs/navixy-api/panel-api/resources/account#auth) and follow the on-screen prompts. The destination user_id is a manual input. This will not allow for devices to be cloned multiple times to the same user. 
