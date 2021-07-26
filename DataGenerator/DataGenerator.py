from PIL import Image
import numpy
from pylab import *

#convert to 512*512
imageaddress='../data/Image/Image.bmp'
image = Image.open(imageaddress)
new_image = image.resize((512, 512))			
image.close() 									
new_image.save(imageaddress)		
new_image.close()							

#open image
im=Image.open(imageaddress)
im=numpy.array(im)
im=where (im>100,1,0) #convert to binary image
(M,N)=im.shape

#save original data
numpy.savetxt("../data/Txt/orginalData.txt",im.astype(float), fmt='%i', delimiter=",",encoding='utf-8')

# Add noise
noisy=im.copy()
noise=numpy.random.rand(M,N)
ind=where(noise<0.2)
noisy[ind]=1-noisy[ind]

print(noisy)

#save noisy data
numpy.savetxt("../data/Txt/noisyData.txt",noisy.astype(float), fmt='%i', delimiter=",",encoding='utf-8')
noisyMem = np.fliplr(noisy)
numpy.savetxt("../data/Txt/noisyDataMem.txt",noisyMem.astype(float), fmt='%i', delimiter="",encoding='utf-8')

