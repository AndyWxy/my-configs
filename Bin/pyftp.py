#!/usr/bin/env python
#Fast upload files to specific ftp server

import ftplib
import os
import sys

if len(sys.argv) < 2:
    print "Usage: %s file [file2] [file3] ..." % os.path.split(sys.argv[0])[1]
    sys.exit()

# Clear the screen?
#os.system('clear')
print "Files to upload:"
print sys.argv[1:], "\n"
ftp = ftplib.FTP('blog.andywxy.cn')
login  = "andywxy"
passwd = "btnew1984@"

ftp.login(login, passwd)
ftp.dir()
# Move to the desired upload directory.
dir = raw_input("\nType the directory name (leave empty to use the current dir): ")
if dir:
    ftp.cwd(dir)

print "\nCurrently in:", ftp.pwd()

for file in sys.argv[1:]: 
    name = os.path.split(file)[1]
    print "Uploading \"%s\" ..." % name,
    f = open(file, "rb")
    ftp.storbinary('STOR ' + name, f)
    f.close()
    print "OK"

print "Quitting..."
ftp.quit()
