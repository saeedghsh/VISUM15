import numpy as np
import scipy.signal
import cv2
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import scipy.ndimage

#######################################
############# Functions ###############
#######################################

def hessianResponse(img,sigma):
    dxx = scipy.ndimage.filters.gaussian_filter1d(img, sigma**2, axis=1, order=2)
    dyy = scipy.ndimage.filters.gaussian_filter1d(img, sigma**2, axis=0, order=2)
    dx = scipy.ndimage.filters.gaussian_filter1d(img, sigma**2, axis=1, order=1)
    dxy = scipy.ndimage.filters.gaussian_filter1d(dx, sigma**2, axis=0, order=1)
    response = dxx*dyy - dxy*dxy
    return response

def nonmaxsup2d(response,thresh):
    h,w = response.shape
    maxImg = np.zeros((h,w))
    for r in range(1,h-1):
        for c in range(1,w-1):
            if response[r,c] > thresh:
                window = response[r-1:r+2,c-1:c+2]
                if response[r,c] == window.max():
                    if np.nonzero(window==window.max())[0][0] == 1:
                        maxImg[r,c] = 1.0
    return maxImg

def hessian(img,sigma,thresh):
    x,y = nonmaxsup2d(hessianResponse(img,sigma), thresh).nonzero()
    return np.vstack((x,y)).T

###################### Harris
def harrisResponse(img, sigmaI, sigmaD, alpha=0.04):
    image = scipy.ndimage.filters.gaussian_filter1d(img, sigmaI**2, order=0)
    dxx = scipy.ndimage.filters.gaussian_filter1d(image, sigmaD**2, axis=1, order=2)
    dyy = scipy.ndimage.filters.gaussian_filter1d(image, sigmaD**2, axis=0, order=2)
    dx = scipy.ndimage.filters.gaussian_filter1d(image, sigmaD**2, axis=1, order=1)
    dxy = scipy.ndimage.filters.gaussian_filter1d(dx, sigmaD**2, axis=0, order=1)
    detC = dxx*dyy - dxy*dxy
    traceC = 2*dxy
    response =  detC - alpha* (traceC**2)
    return response

def harris(img, sigmaI, sigmaD, thresh):
    x,y = nonmaxsup2d(harrisResponse(img, sigmaI, sigmaD), thresh).nonzero()
    return np.vstack((x,y)).T



#######################################
############### xxxxx #################
#######################################

image = cv2.imread('sunflowers.png')
imageGray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

sigma = 1.7 #1.0
thresh = 250
hessResponse = hessianResponse(imageGray,sigma)
hessMaxImg = nonmaxsup2d(hessResponse,thresh)

sigmaI, sigmaD = 2.7 , 0.5
harrResponse = harrisResponse(imageGray,sigmaI,sigmaD)
harrMaxImg = nonmaxsup2d(harrResponse,thresh)


#######################################
############### Plots #################
#######################################
rows,cols = 2,2
fig = plt.figure(figsize=(cols*16,rows*8))
axes = [plt.subplot2grid((rows, cols), (r, c), rowspan=1, colspan=1, axisbg = 'w')
        for c in range(cols) for r in range(rows)]
axes[0].imshow(image)#, origin='lower')
axes[2].imshow(imageGray, cmap='gray')#, origin='lower)'
axes[1].imshow(scipy.ndimage.filters.gaussian_filter1d(imageGray, sigma**2, axis=1, order=1), cmap='gray')#, origin='lower)'
# axes[1].imshow(harrResponse, cmap='gray')#, origin='lower)'
axes[3].imshow(harrMaxImg, cmap='gray')#, origin='lower)'

plt.tight_layout()
plt.show()
