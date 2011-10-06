#!/bin/sh

#This will bind the machine to a specific OU.

#This searches Active Directory for the current computer name (In this case, the serial # of the machine) and stores the results in cnpath
cnpath="$(ldapsearch -h sub.domain.com -x  -D "user@sub.domain.com" -w password -b "dc=sub,dc=domain,dc=com" -LLL "cn=$DS_SERIAL_NUMBER" dn | perl -p0e 's/\n //g' | awk 'NR < 2' | cut -c5-)"
 
#Retrieves and cleans up MAC Address
MAC=$(echo ${DS_PRIMARY_MAC_ADDRESS} | sed s/://g)
 
#Sets budget code variable to the contents of ARD field #2.  This reads only the first 4 digits of ARD field #2.
budget=$(defaults read /tmp/DSNetworkRepository/Databases/ByHost/$MAC dstudio-host-ard-field-2 | cut -c1-4)
 
#Gets the full path for the budget code's OU
futureou="$(ldapsearch -h sub.domain.com -x  -D "user@sub.domain.com" -w password -b "ou=University Computers,dc=sub,dc=domain,dc=com" -LLL "ou=$budget" dn | perl -p0e 's/\n //g' | awk 'NR < 2' | cut -c5-)"
 
#If a computer object is found for the computername, then delete the object. 
if [ -n "$cnpath" ]
	then
		ldapdelete -h sub.domain.com -x -D "user@sub.domain.com" -w password "$cnpath"
fi

#Validate that the OU exists and then edits the ds_active_directory_binding.sh file to reflect the specific OU needed.
if [ -n "$futureou" ]
	then
		defaults write /Volumes/"$DS_STARTUP_VOLUME"/etc/deploystudio/bin/ds_active_directory_binding ou "$futureou"
fi

exit 0
