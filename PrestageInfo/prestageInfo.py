#!/usr/bin/python
"""
To Do:
1. Add better error checking along the way
2. Fix postToDeployStudio so that it ses the primary key setting instead of being hardcoded
"""

import os
import urllib2
import plistlib
import optparse


def main():
    """Main"""
    p = optparse.OptionParser()
    p.set_usage("""Usage: %prog [options]""")
    p.add_option('--computername', dest='computerName',
                 help="""Sets the computer name.""")
    p.add_option('--hostname', dest='hostName',
                 help="""Sets the host name.""")

    options, arguments = p.parse_args()
    if not options.computerName or not options.hostName:
        p.error("incorrect number of arguments")

    # Get the URL for the DS Server from the runtime plist
    os.system("/usr/bin/plutil -convert xml1 /Library/Preferences/com.deploystudio.server.plist -o /tmp/com.deploystudio.server.plist")
    dsServerURL = plistlib.readPlist("/tmp/com.deploystudio.server.plist")["server"]["url"]

    # Get DS Server Settings
    dsServerInfo = plistlib.readPlistFromString(urllib2.urlopen(urllib2.Request(dsServerURL + "/server/get/info")).read())

    # Build the settings plist
    computerPlist = {}
    computerPlist['dstudio-host-primary-key'] = dsServerInfo["computer_primary_key"]
    computerPlist['dstudio-host-serial-number'] = os.environ['DS_SERIAL_NUMBER']
    computerPlist['cn'] = options.computerName
    computerPlist['dstudio-hostname'] = options.hostName

    postToDeployStudio(dsServerURL, computerPlist)


def postToDeployStudio(repoUrl, plistToPost):
    convertedPlist = plistlib.writePlistToString(plistToPost)
    dsAuthFile = open("/tmp/DSNetworkRepository/DeployStudioAuthorization", 'r')
    authString = dsAuthFile.read()
    # Fix this to use the proper identifier based upon dstudio-host-primary-key
    submitRequest = urllib2.Request(repoUrl + "/computers/set/entry?id=" + plistToPost['dstudio-host-serial-number'],
                                    convertedPlist, {'Content-type': 'text/xml'})
    submitRequest.add_header("Authorization", "Basic %s" % authString)
    urllib2.urlopen(submitRequest)

if __name__ == '__main__':
    main()
