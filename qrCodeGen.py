#Tevon Walker

import pyqrcode #python qr code generation
import sys #command line args


qr = pyqrcode.create(str(sys.argv[1])) #create qr code
qr.svg(str(sys.argv[2] + ".svg"),6) #create png file with qr image
