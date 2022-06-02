import snap
import numpy as np
from matplotlib import pyplot as plt
from sets import Set
import networkx as nx
import operator
from scipy.spatial import distance

part_1 = True
part_2 = False
part_3 = False
part_4 = False

def dot(K, L):
   if len(K) != len(L):
      return 0
   return sum(i[0] * i[1] for i in zip(K, L))

def Q2():

	path = '/Users/jasonluo/Dropbox/Stanford 2018-2019 RR/cs224w/homeworks/Sine\'s hws/hw3/Q2/node2vec/'
	G = snap.LoadEdgeList(snap.PUNGraph, path + "src/karate.edgelist", 0, 1)
	GNx = nx.read_edgelist(path + "src/karate.edgelist", nodetype=int)

	if part_1:
		# 2.1
		nx.draw(GNx, with_labels=True)
		plt.show()
		# plt.savefig("path.png")

	if part_4:
		fname = "emb/karateSpecial.emd"
		with open(fname) as f:
			content = f.readlines()
		head = True
		nodeVecMap = {}
		for row in content:
			if head:
				head = False
				continue
			row = row.strip()
			rowList = row.split(" ")
			node = int(rowList[0])
			vec = [ float(f) for f in rowList[1:] ]
			nodeVecMap[node] = vec
		vec33 = nodeVecMap[33]
		# print "Node 33 vector: "
		# print nodeVecMap[33]
		id2degreeMap = {}
		for NI in G.Nodes():
			id2degreeMap[NI.GetId()] = NI.GetOutDeg()
		scoreMap = {}
		for node in nodeVecMap.keys():
			scoreMap[node] = distance.euclidean(vec33, nodeVecMap[node])
		scoreMap = sorted(scoreMap.items(), key=operator.itemgetter(1))
		print "Node 33 with Degree: %d" % id2degreeMap[33]
		for i in scoreMap[:6]:
			print "Node %d with Degree %d Sim Score %f." % (i[0], id2degreeMap[i[0]], i[1])

	if part_3:
		# 2.3 Node 33
		NI = G.GetNI(33)
		nbrL = []
		for Id in NI.GetOutEdges():
			nbrL.append(Id)
		print "Node 33 1 hop Nbrs:"
		print nbrL
		# using node2vec to get nbr (sort of)
		# load the node2vec result
		#  python src/main.py --input graph/karate.edgelist --p 1 --q 0.5 --output emb/karate.emd
		fname = "emb/karate.emd"
		with open(fname) as f:
			content = f.readlines()
		head = True
		nodeVecMap = {}
		for row in content:
			if head:
				head = False
				continue
			row = row.strip()
			rowList = row.split(" ")
			node = int(rowList[0])
			vec = [ float(f) for f in rowList[1:] ]
			nodeVecMap[node] = vec
		vec33 = nodeVecMap[33]
		# print "Node 33 vector: "
		# print nodeVecMap[33]

		scoreMap = {}
		for node in nodeVecMap.keys():
			scoreMap[node] = dot(vec33, nodeVecMap[node])
		scoreMap = sorted(scoreMap.items(), key=operator.itemgetter(1))
		# [(25, 1.5349781065473143), (27, 1.5376717194245453), (26, 1.539334887410666), (34, 1.5395159466211277), (30, 1.623216897530339), (24, 1.625038367146459)]
		print scoreMap

		# Node 34 with Degree: 17
		# Node 34 with Degree 17 Sim Score 1.587977.
		# Node 26 with Degree 3 Sim Score 1.613966.
		# Node 33 with Degree 12 Sim Score 1.624562.
		# Node 27 with Degree 2 Sim Score 1.654883.
		# Node 19 with Degree 2 Sim Score 1.673022.
		# Node 30 with Degree 4 Sim Score 1.705983.
		# python src/main.py --input graph/karate.edgelist --p 1 --q 2 --output emb/karateBfs.emd
		# fname = "emb/karateBFS.emd"
		# with open(fname) as f:
		# 	content = f.readlines()
		# head = True
		# nodeVecMap = {}
		# for row in content:
		# 	if head:
		# 		head = False
		# 		continue
		# 	row = row.strip()
		# 	rowList = row.split(" ")
		# 	node = int(rowList[0])
		# 	vec = [ float(f) for f in rowList[1:] ]
		# 	nodeVecMap[node] = vec
		# vec34 = nodeVecMap[34]
		# # print "Node 33 vector: "
		# # print nodeVecMap[33]
		# id2degreeMap = {}
		# for NI in G.Nodes():
		# 	id2degreeMap[NI.GetId()] = NI.GetOutDeg()

		# scoreMap = {}
		# for node in nodeVecMap.keys():
		# 	scoreMap[node] = dot(vec34, nodeVecMap[node])
		# scoreMap = sorted(scoreMap.items(), key=operator.itemgetter(1))
		# print "Node 34 with Degree: %d" % id2degreeMap[34]
		# for i in scoreMap[-6:]:
		# 	print "Node %d with Degree %d Sim Score %f." % (i[0], id2degreeMap[i[0]], i[1])

Q2()

