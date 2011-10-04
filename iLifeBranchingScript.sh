#!/bin/sh

# iLife release Dates in YYYYMMDD format

iLife06=20060110
iLife08=20070807
iLife09=20090106
iLife11=20101020

# Uncomment this and assign a date for testing purposes
#PURCHASE_DATE=20100527

# If PURCHASE_DATE is empty, exit with an error code.  
if [[ -z "${PURCHASE_DATE}" ]]; then
	echo "PURCHASE_DATE is invalid.  iLife will not be installed."
	exit 1
fi

# If the machine was purchased the day iLife06 was released or later but before the day iLife 08 was released, then install iLife 06
if [ "${PURCHASE_DATE}" -ge "${iLife06}" ] && [ "${PURCHASE_DATE}" -lt "${iLife08}" ]; then
	echo "Installing iLife 06..."
	echo "RuntimeSelectWorkflow: WorkflowID"
	
	
# If the machine was purchased the day iLife08 was released or later but before the day iLife 09 was released, then install iLife 08
elif [ "${PURCHASE_DATE}" -ge "${iLife08}" ] && [ "${PURCHASE_DATE}" -lt "${iLife09}" ]; then
	echo "Installing iLife 08..."
	echo "RuntimeSelectWorkflow: WorkflowID"

# If the machine was purchased the day iLife09 was released or later but before the day iLife 11 was released, then install iLife 09
elif [ "${PURCHASE_DATE}" -ge "$iLife09" ] && [ "${PURCHASE_DATE}" -lt "${iLife11}" ]; then
	echo "Installing iLife 09..."
	echo "RuntimeSelectWorkflow: WorkflowID"

# If the machine was purchased the day iLife 11 was released or later, install iLife 11
elif [ "${PURCHASE_DATE}" -ge "${iLife11}" ]; then
	echo "Installing iLife 11..."
	echo "RuntimeSelectWorkflow: WorkflowID"

# If the machine doesn't match any of these conditions, then it is old.
else 
	echo "Machine is has an iLife version prior to iLife 06."
fi

exit 0
