import snap
import math
import operator
import matplotlib.pyplot as plt

num = 19

def q1_1():
	G = snap.TNGraph.Load(snap.TFIn("promotion.graph"))
	degMap = {}
	numEgoEdgeMap = {}
	numConnectingEdgeMap = {}

	for n in G.Nodes():
		deg = 0
		neighbors = [n.GetId()]
		for neighbor in n.GetOutEdges():
			deg += 1
			neighbors.append(neighbor)

		for neighbor in n.GetInEdges():
			deg += 1
			neighbors.append(neighbor)


		numEgoEdge = 0
		numConnectingEdge = 0
		for node in neighbors:
			for e in G.GetNI(node).GetOutEdges():
				if e in neighbors:
					numEgoEdge += 1
				else:
					numConnectingEdge += 1
			for e in G.GetNI(node).GetInEdges():
				if e in neighbors:
					numEgoEdge += 1
				else:
					numConnectingEdge += 1
		#snumEgoEdge = numEgoEdge/2

		degMap[n.GetId()] = deg
		numEgoEdgeMap[n.GetId()] = numEgoEdge
		numConnectingEdgeMap[n.GetId()] = numConnectingEdge

	print 'The degree of node 9 is ' + str(degMap[num])
	print 'The number of edges in the egonet of v is ' + str(numEgoEdgeMap[num])
	print 'The number of edges that enters or leaves the egonet is ' + str(numConnectingEdgeMap[num])


	sim = {}
	sqrtx = math.sqrt(math.pow(degMap[num],2) + math.pow(numEgoEdgeMap[num],2) + math.pow(numConnectingEdgeMap[num],2))
	for n in G.Nodes():
		nodeIndex = n.GetId()
		if nodeIndex != num:
			numerator = float(degMap[num])*degMap[nodeIndex] + float(numEgoEdgeMap[num])*numEgoEdgeMap[nodeIndex] + float(numConnectingEdgeMap[num])*numConnectingEdgeMap[nodeIndex]
			denom = sqrtx * math.sqrt(math.pow(degMap[nodeIndex],2) + math.pow(numEgoEdgeMap[nodeIndex],2) + math.pow(numConnectingEdgeMap[nodeIndex],2))
			if denom == 0:
				sim[nodeIndex] = 0
			else:
				sim[nodeIndex] = numerator/float(denom)

	simSorted = sorted(sim.items(), key=operator.itemgetter(1), reverse = True)
	for i in range(5):
		print list(simSorted)[i]


	print '1_1 done'

	return G, degMap, numEgoEdgeMap, numConnectingEdgeMap


def q1_2(G, degMap, numEgoEdgeMap, numConnectingEdgeMap):
	newFVMap = {}
	
	for n in G.Nodes():
		nodeIndex = n.GetId()
		newFVMap[nodeIndex] = [degMap[nodeIndex]]
		newFVMap[nodeIndex].append(numEgoEdgeMap[nodeIndex])
		newFVMap[nodeIndex].append(numConnectingEdgeMap[nodeIndex])

		neilist = []
		for neighbor in n.GetOutEdges():
			neilist.append(neighbor)

		neiDeg = []
		neiEgo = []
		neiConn = []
		for neighbor in neilist:
			neiDeg.append(degMap[neighbor])
			neiEgo.append(numEgoEdgeMap[neighbor])
			neiConn.append(numConnectingEdgeMap[neighbor])


		if neilist == []:
			for i in range(6):
				newFVMap[nodeIndex].append(0)
		else:
			newFVMap[nodeIndex].append(sum(neiDeg)/float(len(neiDeg)))
			newFVMap[nodeIndex].append(sum(neiEgo)/float(len(neiEgo)))
			newFVMap[nodeIndex].append(sum(neiConn)/float(len(neiConn)))
			newFVMap[nodeIndex].append(sum(neiDeg))
			newFVMap[nodeIndex].append(sum(neiEgo))
			newFVMap[nodeIndex].append(sum(neiConn))

	# --------------------pass 2------------------------
	FVMap2 = {}
	for n in G.Nodes():
		nodeIndex = n.GetId()
		FVMap2[nodeIndex] = newFVMap[nodeIndex]
		
		neivec = []
		for nn in n.GetOutEdges():
			neivec.append(newFVMap[nn])

		if neivec == []:
			for i in range(18):
				FVMap2[nodeIndex].append(0)
		else:
			for i in range(9):
				col = []
				for vec in neivec:
					col.append(vec[i])

				FVMap2[nodeIndex].append(sum(col)/float(len(col)))

			for i in range(9):
				col = []
				for vec in neivec:
					col.append(vec[i])

				FVMap2[nodeIndex].append(sum(col))


	# --------------------sim measure----------------------
	sim = {}

	x = 0
	for i in range(27):
		x += math.pow(FVMap2[num][i], 2)

	sqrtx = math.sqrt(x)
	
	for n in G.Nodes():
		nodeIndex = n.GetId()
		if nodeIndex != num:
			numerator = 0
			denom = 0
			for i in range(27):
				numerator += FVMap2[nodeIndex][i]*FVMap2[num][i]
				denom += math.pow(FVMap2[nodeIndex][i],2)
			denom = sqrtx * math.sqrt(denom)
			if denom == 0:
				sim[nodeIndex] = 0
			else:
				sim[nodeIndex] = numerator/float(denom)

	simSorted = sorted(sim.items(), key=operator.itemgetter(1), reverse = True)
	for i in range(5):
		print list(simSorted)[i]

	print '1_2 done'

	return list(simSorted[n][1] for n in range(len(simSorted)))


def q1_3(simSorted):
	n, bins, patches = plt.hist(simSorted, bins = 20)
	plt.title('Cosine Similarity Distribution between Node 19 and Other Nodes in Promotion-based Patronage Network')
	plt.show()

	print '1_3 done'

	

if __name__ == "__main__":
	G, degMap, numEgoEdgeMap, numConnectingEdgeMap = q1_1()
	simSorted = q1_2(G, degMap, numEgoEdgeMap, numConnectingEdgeMap)
	q1_3(simSorted)
	print 'done'