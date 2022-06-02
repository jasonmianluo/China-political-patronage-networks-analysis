import snap
import numpy
import matplotlib.pyplot as plt
import operator
import csv
from scipy import stats
import numpy as np

G = snap.TNGraph.Load(snap.TFIn("promotion.graph"))	# promotion-based


NIdHubH = snap.TIntFltH()
NIdAuthH = snap.TIntFltH()
snap.GetHits(G, NIdHubH, NIdAuthH)

hubdict = {}
for k in NIdHubH:
	hubdict[k] = NIdHubH[k]


authdict = {}
for k in NIdAuthH:
	authdict[k] = NIdAuthH[k]

finalLevel = {}
with open('../parseCsv/id_work.csv') as csv_file:
	csv_reader = csv.DictReader(csv_file)
	for row in csv_reader:
		level = row.values()[0].split('\t')
		finalLevel[int(level[0])] = int(level[len(level)-1])


finalLevelsorted = sorted(finalLevel.items(), key=operator.itemgetter(0))
finalLevelVals = list(finalLevelsorted[n][1] for n in range(len(finalLevelsorted)))
finalLevelKeys = list(finalLevelsorted[n][0] for n in range(len(finalLevelsorted)))

removePending = []
for k in hubdict:
	if k not in finalLevelKeys:
		removePending.append(k)

for k in removePending:
	del hubdict[k]
	del authdict[k]


plt.scatter(finalLevelVals, hubdict.values(), label='hub score', alpha = 0.3)
# plt.scatter(finalLevelVals, authdict.values(), label='authority score', alpha=0.3, c='red')
plt.xlabel('final rank of a political leader')
plt.ylabel('hub score')
plt.title('Hub Score VS. Final Rank in Promotion-Based Patronage Network')



levelDict = {0:[], 1:[], 2:[], 3:[], 4:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[]}
for i in range(len(finalLevelVals)):
	levelDict[finalLevelVals[i]].append(hubdict.values()[i])

avgscore = []
for k in levelDict:
	if len(levelDict[k]) == 0:
		avgscore.append(0)
	else:
		avgscore.append(float(sum(levelDict[k]))/len(levelDict[k]))

# print avgscore
plt.plot([0,1,2,3,4,5,6,7,8,9], avgscore, label='average line')
plt.legend()
plt.show()


# levelDict = {0:[], 1:[], 2:[], 3:[], 4:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[]}
# for i in range(len(finalLevelVals)):
# 	levelDict[finalLevelVals[i]].append(authdict.values()[i])

# avgscore = []
# for k in levelDict:
# 	if len(levelDict[k]) == 0:
# 		avgscore.append(0)
# 	else:
# 		avgscore.append(float(sum(levelDict[k]))/len(levelDict[k]))

# # print avgscore
# plt.plot([0,1,2,3,4,5,6,7,8,9], avgscore, c='red', label='average line')
# plt.legend()
# plt.show()


# G = snap.LoadEdgeList(snap.PUNGraph, "../edge_list_use.txt", 0, 1)	# overlap-based


# NIdHubH = snap.TIntFltH()
# NIdAuthH = snap.TIntFltH()
# snap.GetHits(G, NIdHubH, NIdAuthH)

# hubdict = {}
# for k in NIdHubH:
# 	hubdict[k] = NIdHubH[k]

# authdict = {}
# for k in NIdAuthH:
# 	authdict[k] = NIdAuthH[k]


# finalLevel = {}
# with open('../parseCsv/id_work.csv') as csv_file:
# 	csv_reader = csv.DictReader(csv_file)
# 	for row in csv_reader:
# 		level = row.values()[0].split('\t')
# 		finalLevel[int(level[0])] = int(level[len(level)-1])


# finalLevelsorted = sorted(finalLevel.items(), key=operator.itemgetter(0))
# finalLevelVals = list(finalLevelsorted[n][1] for n in range(len(finalLevelsorted)))
# finalLevelKeys = list(finalLevelsorted[n][0] for n in range(len(finalLevelsorted)))


# removePending = []
# for k in finalLevelKeys:
# 	if k not in hubdict:
# 		removePending.append(k)

# for k in removePending:
# 	del finalLevel[k]

# finalLevelsorted = sorted(finalLevel.items(), key=operator.itemgetter(0))
# finalLevelVals = list(finalLevelsorted[n][1] for n in range(len(finalLevelsorted)))
# finalLevelKeys = list(finalLevelsorted[n][0] for n in range(len(finalLevelsorted)))


# # plt.scatter(finalLevelVals, hubdict.values(), label='hub score', alpha = 0.3)
# plt.scatter(finalLevelVals, authdict.values(), label='authority score', alpha=0.3, c='red')
# plt.xlabel('final rank of a political leader')
# plt.ylabel('authority score')
# plt.title('Authority Score VS. Final Rank in Overlap-Based Patronage Network')




# levelDict = {0:[], 1:[], 2:[], 3:[], 4:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[]}
# for i in range(len(finalLevelVals)):
# 	levelDict[finalLevelVals[i]].append(hubdict.values()[i])

# avgscore = []
# for k in levelDict:
# 	if len(levelDict[k]) == 0:
# 		avgscore.append(0)
# 	else:
# 		avgscore.append(float(sum(levelDict[k]))/len(levelDict[k]))

# # print avgscore
# plt.plot([0,1,2,3,4,5,6,7,8,9], avgscore, label='average line')
# plt.legend()
# plt.show()




# levelDict = {0:[], 1:[], 2:[], 3:[], 4:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[]}
# for i in range(len(finalLevelVals)):
# 	levelDict[finalLevelVals[i]].append(authdict.values()[i])

# avgscore = []
# for k in levelDict:
# 	if len(levelDict[k]) == 0:
# 		avgscore.append(0)
# 	else:
# 		avgscore.append(float(sum(levelDict[k]))/len(levelDict[k]))

# print avgscore
# plt.plot([0,1,2,3,4,5,6,7,8,9], avgscore, c='red', label='average line')

# xi = [0,1,2,3,4,5,6,7,8,9]
# slope, intercept, r_value, p_value, std_err = stats.linregress(xi,avgscore)
# line = slope*np.asarray(xi)+intercept

# plt.plot(xi, line, c='black', label='fitted line')

# plt.legend()
# plt.show()