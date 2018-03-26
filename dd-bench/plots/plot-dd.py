import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df=pd.read_csv('bw.dat',sep='\s+',names=['op','dt','rate','txt1','sz'],index_col=1,parse_dates=True,skipfooter=1,usecols=[0,1,2,4])

df["bps"]=df["rate"]*8.0

dfr=df[df.op.isin(['READ'])]
dfw=df[df.op.isin(['WRITE'])]

plt.title('I/O Bandwidth')
plt.xlabel('Date Time')

plt.ylabel('MB/s')
#dfr['rate'].plot(marker='.',linestyle='None',label='Read',legend=True,secondary_y=True)
dfr['rate'].plot(marker='.',linestyle='None',label='Read',legend=True)
dfw['rate'].plot(marker='+',linestyle='None',label='Write',legend=True) 

#plt.ylabel('Mb/s')
##dfr['bps'].plot(marker='.',linestyle='None',label='Read',legend=True,secondary_y=True)
#dfr['bps'].plot(marker='.',linestyle='None',label='Read',legend=True)
#dfw['bps'].plot(marker='+',linestyle='None',label='Write',legend=True)

plt.show()

