#!/usr/bin/env python
# coding: utf-8

# In[14]:


import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import emcee
import george
from george import kernels
from george.modeling import Model, CallableModel

plt.rc('text',usetex=True)
plt.rc('font', size=20)
plt.rc('font', weight='bold')
plt.rc('font', family='serif')          # controls default text sizes
#plt.rc('axes', titlesize=SMALL_SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=20)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=20)    # fontsize of the tick labels
plt.rc('ytick', labelsize=20)    # fontsize of the tick labels
plt.rc('legend', fontsize=20)    # legend fontsize
plt.rc('figure', titlesize=20)  # fontsize of the figure title
plt.rc('ytick', direction='in')
plt.rc('xtick', direction='in')
plt.rc('xtick.major',size=10)
plt.rc('ytick.major',size=10)
plt.rc('xtick.minor',size=5)
plt.rc('ytick.minor',size=5)


# In[15]:


def get_sphSW(filename=''):

    SATime = []; freqsphSW = []; sphSW = []; solarAngle = []
    fopen = open(filename)
    flines = fopen.readlines()
    for line in flines:
        split_line = line.split()
        SATime.append(float(split_line[0]))
        freqsphSW.append(float(split_line[1]))
        sphSW.append(float(split_line[2]))
        solarAngle.append(float(split_line[3]))

    SATime = np.array(SATime)
    freqsphSW = np.array(freqsphSW)
    sphSW = np.array(sphSW)
    solarAngle = np.array(solarAngle)
    
    return SATime, freqsphSW, sphSW, solarAngle

# 3rd (MJD), the 4th (DM), the 5th (DM error), the 7th (IISM model)
def read_data(filename):
    MJDs = []; DM = []; DMerr = []; IISM = []
    fopen = open(filename)
    flines = fopen.readlines()
    for line in flines:
        split_line = line.split()
        MJDs.append(float(split_line[2]))
        DM.append(float(split_line[3]))
        DMerr.append(float(split_line[4]))
        IISM.append(float(split_line[6]))
    MJDs = np.array(MJDs)
    DM = np.array(DM)
    DMerr = np.array(DMerr)
    IISM = np.array(IISM)
    
    return MJDs, DM, DMerr, IISM


# In[16]:


psr = 'J1022+1001'


# In[17]:


SATime, freqsphSW, sphSW, solarAngle = get_sphSW(filename='sphericalSW_'+psr+'.txt') 


# In[18]:


SATime_sorted = SATime[SATime.argsort()]
freqsphSW_sorted = freqsphSW[SATime.argsort()]
sphSW_sorted = sphSW[SATime.argsort()]
solarAngle_sorted = solarAngle[SATime.argsort()]


# In[19]:


plt.figure(figsize=(16,5))
firstpeak = SATime_sorted[(sphSW_sorted).argmax()]
print(firstpeak)
peaks = np.arange(-20, 10) * 365.25 + firstpeak
plt.plot(SATime_sorted, sphSW_sorted*1e4, c='red', marker='.', ls='')
for peak in peaks:
    plt.axvline(peak)
plt.xlim(SATime.min(), SATime.max())


# In[20]:


plt.figure(figsize=(15,6))
plt.title(psr)
plt.plot(SATime_sorted, sphSW_sorted*1e4, '.', label='spherical sw dm')
for peak in peaks:
    plt.axvline(peak, c='gray', alpha=0.6)
# plt.plot(SATime, freqsphSW*1e4, '.', c='magenta')
plt.ylabel(r'$DM [10^{-4}$ pc/cm$^3$]', fontsize=20)
plt.xlabel('MJD', fontsize=20)
# plt.ylim(-5,5)
plt.legend(loc=1, fontsize=15)
# plt.text(56550, 25, psr, fontsize=20)
plt.xlim(SATime.min(), SATime.max())


# ('mean:value', 'white_noise:value', 'kernel:k1:log_constant', 'kernel:k2:metric:log_M_0_0')  
# [3.4919734  2.55885056 5.12797153 9.97638418]
# 
# 

# In[21]:


# gp kernel:
# Intial guess:
amp = np.exp(1.3); metric_choice = 400**2
kernel_ExpSq = amp * kernels.ExpSquaredKernel(metric=metric_choice)
print(amp, metric_choice)
print(kernel_ExpSq)


# In[22]:


gp = george.GP(kernel_ExpSq, mean=5.2, white_noise=2.7)


# In[23]:


# gp.compute(SATime) # can use whatever time here


# In[ ]:





# In[24]:


def ispos(sample):
    for s in sample:
        if s < 0:
            return False
    return True


# In[25]:


# ispos(np.arange(10)), ispos(np.arange(20)-100), ispos(np.arange(20)-10)


# In[ ]:





# In[26]:


sample_t = SATime_sorted.copy()
Nsamples = 10
gp.compute(sample_t)
sample_y = gp.sample(sample_t,size=Nsamples)

negind = []
for i in range(sample_y.shape[0]):
    if not ispos(sample_y[i]):
        negind.append(i)
possample_y = np.delete(sample_y, negind, axis=0)
        
# print(possample_y)
fig, axes = plt.subplots(figsize=(16,12), nrows=2)

# try:
#     sample_y.shape[1]

#     for i in range(sample_y.shape[0]):
#         axes[0].plot(sample_t,sample_y[i],'-',linewidth=1, c='gray',alpha=0.5)
# except:
#     axes[0].plot(sample_t,sample_y, ls='-', linewidth=1, marker='.', c='gray',alpha=0.5)

for i in range(possample_y.shape[0]):
    axes[0].plot(sample_t, possample_y[i], ls='', marker='.')

    
# try:
#     sample_y.shape[1]

#     for i in range(sample_y.shape[0]):
#         axes[1].plot(sample_t,sample_y[i]*sphSW*1e4,'-',linewidth=1, c='gray',alpha=0.5)
# except:
#     axes[1].plot(sample_t,sample_y*sphSW*1e4, ls='-', linewidth=1, marker='.', c='gray',alpha=0.5)

for i in range(possample_y.shape[0]):
    axes[1].plot(sample_t, possample_y[i]*sphSW_sorted*1e4, ls='', marker='.')

    
# plt.ylim(-10, 60)
axes[0].set_ylabel('ratio sample')
# plt.xlabel('time')
axes[0].set_title(psr)
axes[1].plot(SATime_sorted, sphSW_sorted*1e4, 'x', label='spherical sw dm', c='k')
for peak in peaks:
    axes[1].axvline(peak, c='gray', alpha=0.6)
# plt.plot(SATime, freqsphSW*1e4, '.', c='magenta')
axes[1].set_ylabel(r'$DM [10^{-4}$ pc/cm$^3$]', fontsize=20)
axes[1].set_xlabel('MJD', fontsize=20)
# plt.ylim(-5,5)
# plt.legend(loc=1,fontsize=15)
# plt.text(56550, 25, psr, fontsize=20)
axes[0].set_xlim(SATime.min(), SATime.max())
axes[1].set_xlim(sample_t.min(), sample_t.max())
# print(np.mean(possample_y, axis=1))
print(possample_y.shape[0])


# In[ ]:


# np.savetxt('positive_SWdm_samples.txt',possample_y*sphSW*1e4, fmt='%.5f', header='DM due to SW -samples- [10^-4 pc/cm^3]')
for sample, i in zip(possample_y, range(possample_y.shape[0])):
    np.savetxt('DMvar_samples_'+psr+'_'+str(i)+'.0', np.c_[sample_t, sample*sphSW_sorted], fmt='%.7f')
    np.savetxt('ratioDMvar_samples_'+psr+'_'+str(i)+'.0', np.c_[sample_t, sample], fmt='%.7f')


# In[ ]:




