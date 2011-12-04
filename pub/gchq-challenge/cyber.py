#!/usr/bin/python
"""
Decode the cyber challenge hex

Nick Craig-Wood <nick@craig-wood.com>
http://www.craig-wood.com/nick/
"""
data = """\
eb 04 af c2 bf a3 81 ec 00 01 00 00 31 c9 88 0c
0c fe c1 75 f9 31 c0 ba ef be ad de 02 04 0c 00
d0 c1 ca 08 8a 1c 0c 8a 3c 04 88 1c 04 88 3c 0c
fe c1 75 e8 e9 5c 00 00 00 89 e3 81 c3 04 00 00
00 5c 58 3d 41 41 41 41 75 43 58 3d 42 42 42 42
75 3b 5a 89 d1 89 e6 89 df 29 cf f3 a4 89 de 89
d1 89 df 29 cf 31 c0 31 db 31 d2 fe c0 02 1c 06
8a 14 06 8a 34 1e 88 34 06 88 14 1e 00 f2 30 f6
8a 1c 16 8a 17 30 da 88 17 47 49 75 de 31 db 89
d8 fe c0 cd 80 90 90 e8 9d ff ff ff 41 41 41 41
"""
data = data.replace(" ", "")
data = data.replace("\n", "")
data = data.decode("hex")
f = open("cyber.bin", "wb")
f.write(data)
f.close()
print repr(data)

# Base 64 string Found in cyber.png
# Decodes to 'BBBB2\x00\x00\x00\x91'...
ciphertext = "QkJCQjIAAACR2PFtcCA6q2eaC8SR+8dmD/zNzLQC+td3tFQ4qx8O447TDeuZw5P+0SsbEcYR".decode("base64")

data2 = (data + ciphertext + "\x00"*4096)[:4096]
f = open("cyber.bin.padded", "wb")
f.write(data2)
f.close()

raise SystemExit(0)

# Remains of experiments to decode as image below here

import sys
import Image

def plot(w, h):
    im = Image.new("RGB", (w,h))

    x = 0
    y = 0
    for c in data:
        i = ord(c)
        for n in range(7,-1,-1):
        #for n in range(8):
            if i & (1 << n):
                #sys.stdout.write(".")
                #print x,y
                pass
            else:
                im.putpixel((x,y), 0xFFFFFF)
                pass
                #sys.stdout.write(" ")
            x += 1
            if x >= w:
                x = 0
                y += 1

    im.save("/tmp/%04d.png" % w, "PNG")

def main():
    for w in range(1,500):
        h = 1280 // w
        if 1280 % w != 0:
            h += 1
        plot(w,h)

if __name__ == "__main__":
    main()

