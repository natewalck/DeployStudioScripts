#!/bin/bash

kick="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
systemsetup="/usr/sbin/systemsetup"

# Printers are now managed with Munki
#genericppd="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/Generic.ppd"


echo "Setting Host Name..."
scutil --set HostName $(scutil --get LocalHostName)

# Fixes print queue pause issue.
dseditgroup -o edit -a staff -t group _lpadmin 
dseditgroup -o edit -a admin -t user _lpadmin 
 
echo "Activating ARD..."
$kick -activate -configure -access -on -users 'macadmin' -privs -all -restart -agent 

echo "Activating SSH..."
launchctl load -w /System/Library/LaunchDaemons/ssh.plist 

# Enable Kerberos (AD) auth for ssh.
echo KerberosAuthentication yes >> /etc/sshd_config 
echo KerberosOrLocalPasswd yes >> /etc/sshd_config 
echo AllowGroups DOMAIN\group admin >> /etc/sshd_config

echo "Setting munki to bootstrap mode..."
touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup

echo "Forcing MCX Settings Refresh..."
# If the machine is not Lion, kill DirectoryService
if [ "`uname -r | cut -d "." -f 1`" -lt "11" ]
	then
		echo "Killing DirectoryService..."
		killall DirectoryService
	else
		# Else it is Lion or newer and kill opendirectoryD
		echo "Killing opendirectoryD..."
		killall opendirectoryD
fi

echo "Finished applying firstboot settings."

# Makes sure that MCX policy is applied before reboot (90% of the time)
echo "Sleeping for 60 seconds..."
sleep 60

exit 0
