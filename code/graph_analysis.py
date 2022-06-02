#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import snap as snap

# load in data
file_path = "/Users/jasonluo/Dropbox/field-paper-2019/data/edge_lists/edge_list_2015.txt"
# file2_path = "/Users/jasonluo/Dropbox/field-paper-2019/data/edge_list2.txt"


G = snap.LoadEdgeList(snap.PUNGraph, file_path, 0, 1)
print("Number of Nodes: %d" % G.GetNodes())
print("Number of Edges: %d" % G.GetEdges())

# TODO: work on weights!
# http://snap.stanford.edu/snap/doc/snapuser-ref/de/d62/classTNodeEDatNet.html#details


####################
##### Extract Node local and global Features

# (1)
# For a node feature vector, we use node’s feature vector up to two-hop aggregation,
# which is a vector of length 27.
# the two-hop neighbors, one-hop and basic similarity
# node similarity


def sum_array(curr_aggr, new_ele):
    ret = []
    for k in range(0, len(curr_aggr)):
        temp_aggr = curr_aggr[k] + new_ele[k]
        ret.append(temp_aggr)
    return ret


def mean_array(curr_aggr, nbr_count):
    ret = []
    for i in range(0, len(curr_aggr)):
        temp_mean = curr_aggr[i]*1.0 / nbr_count
        ret.append(temp_mean)
    return ret


Graph = snap.LoadEdgeList(snap.PUNGraph, file_path, 0, 1)

# iteration 0
feature_dict = {}
for NI in Graph.Nodes():
    deg = 0
    neighbors = [NI.GetId()]
    for neighbor in NI.GetOutEdges():
        deg += 1
        neighbors.append(neighbor)

    numEgoEdge = 0
    numConnectingEdge = 0
    for node in neighbors:
        for e in Graph.GetNI(node).GetOutEdges():
            if e in neighbors:
                numEgoEdge += 1
            else:
                numConnectingEdge += 1
    numEgoEdge = numEgoEdge / 2

    temp_feature_v = [deg, numEgoEdge, numConnectingEdge]
    feature_dict[NI.GetId()] = temp_feature_v


# iteration 1
feature_dict_2 = {}
for NI in Graph.Nodes():
    ID = NI.GetId()
    NbrCount = 0
    temp_sum_v = None
    for i in NI.GetOutEdges():
        if i != ID:
            NbrCount = NbrCount + 1
            if temp_sum_v is None:
                temp_sum_v = feature_dict[i]
            else:
                temp_sum_v = sum_array(temp_sum_v, feature_dict[i])
    if NbrCount == 0:
        feature_dict_2[NI.GetId()] = 0
        continue
    curr_v = feature_dict[NI.GetId()]
    mean_v = mean_array(temp_sum_v, NbrCount)
    sum_v = temp_sum_v
    new_feature_v = []
    new_feature_v.extend(curr_v)
    new_feature_v.extend(mean_v)
    new_feature_v.extend(sum_v)
    feature_dict_2[NI.GetId()] = new_feature_v
    if feature_dict_2[NI.GetId()] == 0:
        feature_dict_2[NI.GetId()] = [0] * 9
# print feature_dict_2

############
# iteration 2
feature_dict_3 = {}
for NI in Graph.Nodes():
    ID = NI.GetId()
    NbrCount = 0
    temp_sum_v = None

    for i in NI.GetOutEdges():
        if i != ID:
            NbrCount = NbrCount + 1

            if temp_sum_v is None:
                temp_sum_v = feature_dict_2[i]
            else:
                # print temp_sum_v
                # print feature_dict_2
                temp_sum_v = sum_array(temp_sum_v, feature_dict_2[i])

    if NbrCount == 0:
        feature_dict_3[NI.GetId()] = [0] * 27
        continue

    curr_v = feature_dict_2[NI.GetId()]
    mean_v = mean_array(temp_sum_v, NbrCount)
    sum_v = temp_sum_v
    new_feature_v = []
    new_feature_v.extend(curr_v)
    new_feature_v.extend(mean_v)
    new_feature_v.extend(sum_v)
    feature_dict_3[NI.GetId()] = new_feature_v


# save these features

twohop_features = pd.DataFrame.from_dict(feature_dict_3, orient='index')
twohop_features.to_csv("/Users/jasonluo/Dropbox/field-paper-2019/data/two_hop_dats/twohop_features.csv", index=True)



######################################
# (2) random walk features

# 2.1 generate RW embeddings
## DONE THROUGH TERMINAL; BELOW IS ILLUSTRATION.
# Node2Vec, Random Walks: node2vec works by carrying out a number of random walks from each
# node in the graph, where the walks are parameterized by p and q.

# commands in terminal
# python /Users/jasonluo/Dropbox/Stanford 2018-2019 RR/cs224w/homeworks/Sine's hws/hw3/Q2/node2vec/src/main.py
# --input /Users/jasonluo/Dropbox/field-paper-2019/data/edge_list.edgelist
# --p 100 --q 0.01 --output /Users/jasonluo/Dropbox/field-paper-2019/data/rwp100q0-01.emd

## 2.2
# transform .emd to .csv

import pandas as pd

fname = '/Users/jasonluo/Dropbox/field-paper-2019/data/random_walk_embs/cbpn-2015-p1q1.emd'

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
    vec = [float(f) for f in rowList[1:]]
    nodeVecMap[node] = vec

node_feature_rw = pd.DataFrame.from_dict(nodeVecMap, orient='index')
node_feature_rw.to_csv("/Users/jasonluo/Dropbox/field-paper-2019/data/random_walk_features/rw-2015-p1q1.csv", index=True)

# (3)
# Node Influence, Spectral Clustering and Network Centrality



# Deg Distribution

import matplotlib.pyplot as plt

def getDataPointsToPlot(Graph):
    """
    :param - Graph: snap.PUNGraph object representing an undirected graph

    return values:
    X: list of degrees
    Y: list of frequencies: Y[i] = fraction of nodes with degree X[i]
    """
    ############################################################################
    X, Y = [], []

    outDegreeDict = {}
    for NI in Graph.Nodes():
        tempCount = NI.GetOutDeg()
        if tempCount != 0:
            if outDegreeDict.has_key(tempCount):
                outDegreeDict[tempCount] = outDegreeDict[tempCount] + 1
            else:
                outDegreeDict[tempCount] = 1
    X = list(outDegreeDict.keys())
    for x in X:
        Y.append(outDegreeDict[x]*1.0/Graph.GetNodes())
    ############################################################################
    return X, Y


x_G, y_G = getDataPointsToPlot(G)
plt.loglog(x_G, y_G, color='r')

plt.xlabel('Node Degree (log)')
plt.ylabel('Proportion of Nodes with a Given Degree (log)')
plt.title('Node Degree Distribution of Career Overlap Network')
plt.savefig('deg_distr_overlap')
#plt.show()
