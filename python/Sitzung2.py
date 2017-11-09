#W02-1 Loops
import pandas as pd
url = "http://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt"
oni = pd.read_fwf(url, widths = [5, 5, 7, 7])

print(oni.head(), "\n")
print(oni.tail(), "\n")

sst = oni['TOTAL'].tolist()
sst[:10]

#Task W02-1.1: Sum values using for and calculate the mean
sm = 0
for i in range(len(sst)): 
    sm = sm + sst[i]

arithmx = sm/len(sst)

#einfachere L�sung ohne for-loop w�re
sum(sst)/len(sst)

#Task W02-1.2: Identify the first occurrence of very strong ENSO events using while
#warm (El Ni�o) and cold (La Ni�a) ENSO events very strong: SST >= 2.0

#write two while loops (one for El Ni�o, the other for La Ni�a) to identify 
#the index at which very strong conditions (i.e. exceeding the warm or falling 
#below the cold anomaly threshold in oni['ANOM']) were first observed.
#and subsequently, print the corresponding season and year to the console.

b = oni['ANOM'].tolist()
i=0
while b[i] <= 2: 
    print(i)
    i = i+1

#erste Stelle El Nino: i=274
oni['ANOM'][274]
oni['SEAS'][274]
oni['YR'][274]

i=0
while b[i] >= -2: 
    print(i)
    i = i+1
#i=287
#erste Stelle La Nina: i=287
oni['ANOM'][287]
oni['SEAS'][287]
oni['YR'][287]

#W02-02 Conditionals
import pandas as pd
url = "http://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt"

# help(pd.read_fwf)
oni = pd.read_fwf(url, widths = [5, 5, 7, 7])
oni.head()

#W02-2.1: Count the number of occurrences of each warm ENSO category
#number of months with weak,medium,strong,and very strong warm ENSO conditions (i.e. El Niño only)
w = 0 #weak
m= 0 #medium
s = 0 #strong
vs = 0 #very strong
for i in range(len(oni)):
    if 0.5 < oni['ANOM'][i] <= 0.9:
        w = w+1
    elif 0.9 < oni['ANOM'][i] <= 1.4:
        m = m+1
    elif 1.4 < oni['ANOM'][i] <= 1.9:
        s=s+1
    elif 1.9 < oni['ANOM'][i] > 2:
        vs = vs+1

#calculate the percentage of months characterized by at least weak El Niño conditions?
countnin = (w+m+s+vs)
pnin = countnin/len(oni)


#W02-2.2: Do the same for cold ENSO events...
wc = 0 #weak
mc= 0 #medium
sc = 0 #strong
vsc = 0 #very strong
for i in range(len(oni)):
    if -0.5 > oni['ANOM'][i] >= -0.9:
        wc = wc+1
    elif -0.9 > oni['ANOM'][i] >= -1.4:
        mc = mc+1
    elif -1.4 > oni['ANOM'][i] >= -1.9:
        sc=sc+1
    elif -1.9 > oni['ANOM'][i] < -2:
        vsc = vsc+1

countninc = (wc+mc+sc+vsc)
pninc = countninc/len(oni)

#...and put the stage-specific counter variables for both warm and cold ENSO stages together in a single 
#dictionary using meaningful and clearly distinguishable keys (e.g. 'Weak El Nino', 'Moderate El Nino', 
#..., 'Weak La Nina', ...).
countcwn = {"weak El Nino": w, "medium El Nino": m, "strong El Nino": s, "very strong El Nino": vs, 
             "weak La Nina": wc, "medium La Nina": mc, "strong La Nina": sc, "very strong La Nina": vsc}

countcwn["strong La Nina"]