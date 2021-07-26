import numpy
from pylab import *
import pickle

original = numpy.loadtxt("../data/Txt/orginalData.txt",dtype=int, delimiter=",")

noisy = numpy.loadtxt("../data/Txt/noisyData.txt",dtype=int, delimiter=",")

dnoisedpy = numpy.loadtxt("../data/Txt/denoisedDatawithPY.txt",dtype=int, delimiter=",")

dnoisedv = numpy.loadtxt("../data/Txt/denoisedDatawithV.txt",dtype=int, delimiter=",")

PYerrorcount = 0
PYpercent = 0
for i in range(len(original)):
  for j in range(len(original[0])):
    if not(original[i,j] == dnoisedpy[i,j]):
      PYerrorcount = PYerrorcount +1 ;
PYnumber = len(original)*len(original[0])
PYpercent = ((PYnumber-PYerrorcount)/PYnumber)*100
print("system denoise with python is "+str(PYpercent)+"% succceful!")

Verrorcount = 0
Vpercent = 0
for i in range(len(original)):
  for j in range(len(original[0])):
    if not(original[i,j] == dnoisedv[i,j]):
      Verrorcount = Verrorcount +1 ;
Vnumber = len(original)*len(original[0])
Vpercent = ((Vnumber-Verrorcount)/Vnumber)*100
print("system denoise with Verlog is "+str(Vpercent)+"% succceful!")

f_res = open("result.txt", 'w')
f_res.write ("system denoise with python is "+str(PYpercent)+"% succceful!"+"\nsystem denoise with Verlog is "+str(Vpercent)+"% succceful!")
f_res.close()


gray()
title('original Image')
imshow(original)

figure()		
gray()
title('Noisy Image')
imshow(noisy)

figure()		
gray()
title('Denoised Image python')
imshow(dnoisedpy)

figure()		
gray()
title('Denoised Image Verlog')
imshow(dnoisedv)
show()

