#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd


# load in data
file_path = "/Users/jasonluo/Dropbox/field-paper-2019/data/expr_dat.csv"
expr_dat = np.genfromtxt(file_path, delimiter=",", skip_header=1, dtype=int)

# note: choice to load "expr_dat_2000.csv", "expr_dat_2005.csv", "expr_dat_2010.csv"

# # now build nodes and edges information
#
# # match rules:
# 1 start_t and end_t: overlapping days exceed 180 days;
# 2 loc2: same province, and same city when available;
# 3 job_type (党、政、军、民、学、其他) matches as well;
#
# N = 4057

# 1. sort by start_t. do forward search

expr = expr_dat[expr_dat[:, 2].argsort()]


# 2. record pairs of experience match
# edge_list = np.empty(shape=[4057, 4057])
edge_list = [[None] * 5] * int(1e7)  # pre-assign 10 million overlapping exprs
count = 0

N = np.shape(expr)[0]

for i in xrange(N-1):
    j = i+1

    while expr[i, 3] - expr[j, 2] > 180:
        match = False

        overlap_days = min(expr[i, 3], expr[j, 3]) - expr[j, 2]
        if overlap_days > 180:  # overlap time req met

            # option 1: same job type & same loc2 location -> match
            # TODO: need to deal with Central Zip: 840000
            if (expr[i, 6] == expr[j, 6]) \
                    & (expr[i, 5] == expr[j, 5])\
                    & (expr[i, 0] != expr[j, 0]):
                match = True

            # option 2: same actual loc2, i.e. in a same prefecture -> match
            if (expr[i, 5] == expr[j, 5]) & (expr[i, 5] % 10000 != 0):
                match = True

        if match is True:
            edge_list[count] = \
                [expr[i, 0], expr[j, 0], overlap_days, expr[i, 7], expr[j, 7]]
            count += 1

        j += 1

    if i % 10000 == 0:
        print i

edge_list = edge_list[0:count]

# TODO: need to think about what to do with adjunt positions within a same time period

# 3. accumulate experience matches to node-level

# sort to re-arrange data
edge_mat = np.array(edge_list)
edge_mat[:, 0:2] = np.sort(edge_mat[:, 0:2], axis=1)
ind = np.lexsort((edge_mat[:, 1], edge_mat[:, 0]))
edge_mat = edge_mat[ind]
edge_mat = edge_mat.astype('float64')
edge_mat[:, 3] = np.multiply(edge_mat[:, 3], edge_mat[:, 2])
edge_mat[:, 4] = np.multiply(edge_mat[:, 4], edge_mat[:, 2])

# aggregate overlapping days and rank information by edges
df = pd.DataFrame(edge_mat).groupby([0, 1])[2, 3, 4].sum().reset_index()
print df.shape  # results in 523,027 weighted and directed edges

edge_mat2 = np.array(df)
edge_mat2[:, 3] = np.divide(edge_mat2[:, 3], edge_mat2[:, 2])
edge_mat2[:, 4] = np.divide(edge_mat2[:, 4], edge_mat2[:, 2])

edge_mat2[:, 2] = edge_mat2[:, 2]/365  # change day to year
direction = edge_mat2[:, 3] - edge_mat2[:, 4]

edge_output = pd.DataFrame(np.column_stack((edge_mat2[:, 0:3], direction.T)))
edge_output = edge_output.astype(dtype={0: 'int', 1: 'int', 2: 'float', 3: 'float'})


# save to file
edge_output.to_csv('edge_list2.txt', header=None, index=None, sep=' ')
# np.savetxt('edge_list', edge_output, delimiter=',')

