#!/usr/bin/python
"""
Try fetching key.txt using various strings

Nick Craig-Wood <nick@craig-wood.com>
http://www.craig-wood.com/nick/
"""
import socket
import os
from struct import *
t = "gchqcyberwin"

#stage1 = 0xafc2bfa3
stage1 = 0xa3bfc2af
firmware = [0xd2ab1f05, 0xda13f110]
#firmware = [0x051fabd2, 0x10f113da]

# Make url from stage1 and stage2 keys
host = "www.canyoucrackit.co.uk"
port = 80
filename = "/hqDTK7b8K2rvw/%x/%x/%x/key.txt" % (stage1, firmware[0], firmware[1])
url = "http://" + host + filename
print "Fetching %s" % url

# Write license.txt
f = open("license.txt", "wb")
f.write(t + pack("<III", stage1, firmware[0], firmware[1]))
f.close()

# Fetch from webserver using HTTP/1.0
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.send("GET %s HTTP/1.0\r\n\r\n" % url)
data = s.recv(1024)
s.close()

print 'Received data:\n%s' % data

key = data.split("\r\n\r\n")[1]
f = open("key.txt", "wb")
f.write(key)
f.close()

print 'Received key: %r' % key

