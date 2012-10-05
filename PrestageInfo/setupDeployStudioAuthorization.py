#!/usr/bin/python
# Very rough prompter script to store the Deploy Studio authorization, by default in the same directory as instaUp2Date.py

import os, sys, optparse
from getpass	import getpass
from base64		import b64encode

scriptPath = os.path.split(os.path.abspath(sys.argv[0]))[0]

# set up options
parser = optparse.OptionParser()
parser.add_option("-d", "--destination", action="store", type="string", dest="authFileOutputName", help="write output to PATH instead of default 'DeployStudioAuthorization' in %s)" % scriptPath, metavar="FILE")
(options, args) = parser.parse_args()

# set the default location at [INSTADMG_ROOT]/AddOns/InstaUp2Date/DeployStudioAuthorization
if options.authFileOutputName is None:
	dsAuthFileName = 'DeployStudioAuthorization'
	outputFileLoc = os.path.join(scriptPath, dsAuthFileName)
# unless the user specified elsewhere
else:
	if not os.path.isdir(os.path.split(options.authFileOutputName)[0]):
		print '%s is not a valid path.' % os.path.split(options.authFileOutputName)[0]
		sys.exit(1)
	else:
		outputFileLoc = options.authFileOutputName

outputFile = open(outputFileLoc, 'w')

# print some helpful info
print "\n*** DeployStudio authorization setup ***"
print "\nYou'll be prompted for your DeployStudio credentials.\nThey will be encoded and stored in the file at:\n%s" % outputFileLoc
if options.authFileOutputName is None:
	print \
"\n\nSince you've not specified a different path to store the credentials, \
\nwe're using the default location. You won't need to give any special \
\ninstructions to InstaUp2Date besides the URL to the server.\n"
else:
	print \
"\n\nSince you've specified an alternate location to store the credentials,\
\nremember that you must provide instaUp2Date.py with the --deploystudio-auth-file \
\noption specifying the location."

# get the info
theUser = getpass('DeployStudio Admin user:')
thePass = getpass('Password:')

# write and close
outputFile.write(b64encode(theUser + ':' + thePass))
outputFile.close()
sys.exit(0)