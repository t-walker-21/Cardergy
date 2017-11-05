#Tevon Walker

# -- IMPORTANT -- #

"IN ORDER TO USE MODULE 'qrtools', YOU MAY HAVE TO MODIFY SOURCE SCRIPT. CHANGE 'tostring()' to 'tobytes' IN MODULE LINE 181"

import qrtools # qr code reader
import sys # command line args

qr = qrtools.QR() # create reader

qr.decode(sys.argv[1]) # decode image 

print qr.data # print data
