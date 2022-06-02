# prediction
rm(list=ls())
setwd("~/Dropbox/r0-field-paper-2019/data")


#########
options(scipen=999)
library(readr)


# 1) link network features to cadre_dat_2005

# load cadre_dat
cadre_dat_2005 = readr::read_csv("raw_cped/cadre_dat_2005_cleaned.csv")
cadre_dat_2005_wperf = readr::read_csv("raw_cped/cadre_dat_2005_cleaned_wperf.csv")

# load network features
twohop_features_2005 <- read_csv("two_hop_features/twohop_features_2005.csv")
names(twohop_features_2005)[1] = 'uid'

rw_2005_p1q0_5 <- read_csv("random_walk_features/rw-2005-p1q0-5.csv")
rw_2005_p1q2 <- read_csv("random_walk_features/rw-2005-p1q2.csv")
#rw_2005 = as.data.frame(merge(rw_2005_p1q0_5, rw_2005_p1q2, by = 'X1'))
#names(rw_2005)[1] = 'uid'
names(rw_2005_p1q2)[1] = 'uid'
names(rw_2005_p1q0_5)[1] = 'uid'

# 2) prediction!
cadre_dat_2005 = cadre_dat_2005[complete.cases(cadre_dat_2005),] 

# fill in NAs in econ performace set

cadre_dat_2005_wperf$gdpidx = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx), 
  mean(cadre_dat_2005_wperf$gdpidx, na.rm = T),
  cadre_dat_2005_wperf$gdpidx)

cadre_dat_2005_wperf$gdpidx_1st = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_1st), 
  mean(cadre_dat_2005_wperf$gdpidx_1st, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_1st)

cadre_dat_2005_wperf$gdpidx_2nd = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_2nd), 
  mean(cadre_dat_2005_wperf$gdpidx_2nd, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_2nd)

cadre_dat_2005_wperf$gdpidx_3rd = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_3rd), 
  mean(cadre_dat_2005_wperf$gdpidx_3rd, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_3rd)

cadre_dat_2005_wperf$f2gdpidx = ifelse(
  is.na(cadre_dat_2005_wperf$f2gdpidx), 
  mean(cadre_dat_2005_wperf$f2gdpidx, na.rm = T),
  cadre_dat_2005_wperf$f2gdpidx)

cadre_dat_2005_wperf$logltavg = ifelse(
  is.na(cadre_dat_2005_wperf$logltavg), 
  mean(cadre_dat_2005_wperf$logltavg, na.rm = T),
  cadre_dat_2005_wperf$logltavg)


cadre_dat_2005_wperf$gdpidx_rl = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_rl), 
  mean(cadre_dat_2005_wperf$gdpidx_rl, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_rl)

cadre_dat_2005_wperf$gdpidx_1st_rl = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_1st_rl), 
  mean(cadre_dat_2005_wperf$gdpidx_1st_rl, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_1st_rl)

cadre_dat_2005_wperf$gdpidx_2nd_rl = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_2nd_rl), 
  mean(cadre_dat_2005_wperf$gdpidx_2nd_rl, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_2nd_rl)

cadre_dat_2005_wperf$gdpidx_3rd_rl = ifelse(
  is.na(cadre_dat_2005_wperf$gdpidx_3rd_rl), 
  mean(cadre_dat_2005_wperf$gdpidx_3rd_rl, na.rm = T),
  cadre_dat_2005_wperf$gdpidx_3rd_rl)

cadre_dat_2005_wperf$f2gdpidx_rl = ifelse(
  is.na(cadre_dat_2005_wperf$f2gdpidx_rl), 
  mean(cadre_dat_2005_wperf$f2gdpidx_rl, na.rm = T),
  cadre_dat_2005_wperf$f2gdpidx_rl)

cadre_dat_2005_wperf$logltavg_rl = ifelse(
  is.na(cadre_dat_2005_wperf$logltavg_rl), 
  mean(cadre_dat_2005_wperf$logltavg_rl, na.rm = T),
  cadre_dat_2005_wperf$logltavg_rl)



## save complete cases only
cadre_dat_2005_wperf = cadre_dat_2005_wperf[
  complete.cases(cadre_dat_2005_wperf),] 

cadre_dat_2005 = cadre_dat_2005[
  complete.cases(cadre_dat_2005),] 

#cadre_dat_2005_wperf = cadre_dat_2005_wperf[, -2]

# create two performance datasets 
# one for absolute; the other for relative measures
performance_abs = cadre_dat_2005_wperf[,c(1, 5, 8, 10:15)]
performance_rlt = cadre_dat_2005_wperf[,c(1, 5, 8, 16:21)]


############ 1 ############
########### OLS class



est_ols = function(dat){
  mod = lm(rank_2015 ~ ., data = dat)
  r_2 = summary(mod)$r.squared
  
  preds = predict(mod)
  acc = sum(round(preds)==dat$rank_2015)/nrow(dat)
  mse = mean((preds - dat$rank_2015)^2)
  
  results = c(r_2*100, acc*100, mse)
  names(results) = c("R2", "Acc", "MSE")
  return(results)
}

res_mat = matrix(NA, nrow=4, ncol=3)

# a) ols null
pred_dat = cadre_dat_2005[, "rank_2015"]
est_ols(pred_dat)
res_mat[1,] = est_ols(pred_dat)

# b) ols two hop
pred_dat_twohop = as.data.frame(
  merge(cadre_dat_2005[, c("uid", "rank_2015", "rank_2005")], 
        twohop_features_2005, by = 'uid'))
est_ols(pred_dat_twohop)
res_mat[2,] = est_ols(pred_dat_twohop)

# c) ols rw (BFS + DFS)
rw_2005 = as.data.frame(merge(rw_2005_p1q0_5, rw_2005_p1q2, by="uid"))
pred_rw = as.data.frame(merge(
  cadre_dat_2005[,c("uid","rank_2015", "rank_2005")], rw_2005, by = 'uid'))
est_ols(pred_rw)
res_mat[3,] = est_ols(pred_rw)

# regression table for patronage, performance comparison
pred_rw = pred_rw[, -c(1)]
names(pred_rw)[3:258] = paste0(rep("rw-d", 256), 1:256)

# patronage only
mod1 = lm(rank_2015 ~. , data = pred_rw)
summary(mod1)
preds = predict(mod1)
acc = sum(round(preds)==pred_rw$rank_2015)/nrow(pred_rw)
acc

# relative performance only
performance_rlt = performance_rlt[, -c(1)]
mod2 = lm(rank_2015 ~. , data = performance_rlt)
summary(mod2)
preds = predict(mod2)
acc = sum(round(preds)==performance_rlt$rank_2015)/nrow(performance_rlt)
acc

# absolute performance only
performance_abs = performance_abs[, -c(1)]
mod3 = lm(rank_2015 ~. , data = performance_abs)
summary(mod3)
preds = predict(mod3)
acc = sum(round(preds)==performance_abs$rank_2015)/nrow(performance_abs)
acc

# patronage + rlt performance
pred_rw = as.data.frame(merge(
  cadre_dat_2005[,c("uid","rank_2015", "rank_2005")], 
  rw_2005, by = 'uid'))
names(pred_rw)[4:259] = paste0(rep("rw-d", 256), 1:256)
performance_rlt = cadre_dat_2005_wperf[,c(1, 5, 8, 16:21)]

dat4 = as.data.frame(merge(performance_rlt, pred_rw,  
                           by = c('uid', 'rank_2015','rank_2005')))
dat4 = dat4[,-c(1)]

mod4 = lm(rank_2015 ~. , data = dat4)
summary(mod4)
preds = predict(mod4)
acc = sum(round(preds)==dat4$rank_2015)/nrow(dat4)
acc

# patronage + abs performance
performance_abs = cadre_dat_2005_wperf[,c(1, 5, 8, 10:15)]
dat5 = as.data.frame(merge(performance_abs, pred_rw,  
                           by = c('uid', 'rank_2015','rank_2005')))
dat5 = dat5[,-c(1)]

mod5 = lm(rank_2015 ~. , data = dat5)
summary(mod5)
preds = predict(mod5)
acc = sum(round(preds)==dat5$rank_2015)/nrow(dat5)
acc

library(stargazer)

stargazer(mod1, mod2, mod3, mod4, mod5, title="OLS Results",
          align=TRUE, omit.stat=c("LL","ser","f"), no.space=TRUE)


# d) ols full (two hop + rw + cov)
net_features = as.data.frame(
  merge(twohop_features_2005, rw_2005, by='uid'))
pred_full = as.data.frame(
  merge(cadre_dat_2005, net_features, by = 'uid'))
est_ols(pred_full)
res_mat[4,] = est_ols(pred_full)

colnames(res_mat) = c("R2", "Acc", "mse")
round(res_mat, 2)

# e)-1 ols (performance only) 

# absolute performance
est_ols(performance_abs)
# relative performance
est_ols(performance_rlt)

# e)-2 ols (performance + patronage) 
pred_dat = as.data.frame(merge(performance_abs, rw_2005, by = 'uid'))
est_ols(pred_dat)

pred_dat = as.data.frame(merge(performance_rlt, rw_2005, by = 'uid'))
est_ols(pred_dat)

################

# ####### LASSO
# library(glmnet)
# 
# x = as.matrix(subset(pred_rw, select=-c(rank_2015)))
# y = pred_rw$rank_2015
# 
# mod = cv.glmnet(x=x, y=y, type.measure = "mse")
# mod$lambda.min
# 
# preds = predict(mod, newx = x, s = 0)
# dat = pred_rw
# acc = sum(round(preds)==dat$rank_2015)/nrow(dat)
# mse = mean((preds - dat$rank_2015)^2)
# acc
# mse

############ 2 ############
########## ordered logit
library(MASS)

est_polr = function(dat){
  mod = polr(factor(rank_2015, ordered=T)~., 
             data = dat,
             method = c("logistic"))

  preds = predict(mod)
  acc = sum(preds==dat$rank_2015)/nrow(dat)
  mse = mean((as.numeric(preds) - dat$rank_2015)^2)
  
  y = dat$rank_2015
  R_2 = 1 - sum((y-as.numeric(preds))^2)/sum((y-mean(y))^2)

  results = c(R_2*100, acc*100, mse, mod$deviance, BIC(mod))
  names(results) = c("R2","Acc", "MSE", 
                     "Residual.Dev", "BIC")
  return(results)
}

res_mat = matrix(NA, nrow=4, ncol=5)


# null
res_mat[1, ] = est_polr(pred_dat)
res_mat[1, ]

#  two hop
res_mat[2, ] = est_polr(pred_dat_twohop)
res_mat[2, ]

# rw (BFS + DFS)
res_mat[3, ] = est_polr(pred_rw)

# full (two hop + rw + cov)
res_mat[4, ] = est_polr(pred_full)

colnames(res_mat) = c("R2", "Acc", "MSE", 
                      "Residual.Dev", "BIC")
round(res_mat, 2)

# # full2 (two hop + cov)
# pred_full2 = as.data.frame(merge(
#   cadre_dat_2005, twohop_features_2005, by = 'uid'))
# est_polr(pred_full2)
# 
# dat= pred_full2
# mod = polr(factor(rank_2015, ordered=T)~., 
#            data = dat,
#            method = c("logistic"))
# 
# preds = predict(mod, type = "class")
# acc = sum(preds==dat$rank_2015)/nrow(dat)
# acc


################ 3 ##############
# trees (random forests)
library(randomForest)
library(caret)
#library(gbm)

est_rf = function(dat){
  mod = randomForest(rank_2015 ~ .,
                     dat, importance = F, ntree = 1000)
  
  preds = predict(mod)
  acc = sum(round(preds)==dat$rank_2015)/nrow(dat)
  mse = mean((as.numeric(preds) - dat$rank_2015)^2)
  
  y = dat$rank_2015
  R_2 = 1 - sum((y-preds)^2)/sum((y-mean(y))^2)
  
  results = c(R_2, acc, mse)
  names(results) = c("R2", "Acc", "MSE")
  return(results)
}

res_mat = matrix(NA, nrow=4, ncol=3)


# null
res_mat[1, ] = est_rf(pred_dat)

# two hop
names(pred_dat_twohop)[4:30] = paste0(rep("d", 27), 1:27)
res_mat[2, ] = est_rf(pred_dat_twohop)

# rw (BFS + DFS)
names(pred_rw)[4:259] = paste0(rep("d", 256), 1:256)
res_mat[3, ] = est_rf(pred_rw)

# full (two hop + rw + cov)
names(pred_full)[9:291] = paste0(rep("d", 283), 1:283)
res_mat[4, ] = est_rf(pred_full)

# cov
# est_rf(cadre_dat_2005)
res_mat[, 1:2] = res_mat[, 1:2]*100
colnames(res_mat) = c("R2", "Acc", "MSE")
round(res_mat, 2)


# 1 rf (performance only) 

# absolute performance
est_rf(performance_abs)
# relative performance
est_rf(performance_rlt)





# e)-2 rf (performance + patronage) 
# absolute
pred_dat = as.data.frame(merge(performance_abs, 
                               pred_rw[, c(1,4:259)], by = 'uid'))
est_rf(pred_dat)

# relative
pred_dat = as.data.frame(merge(performance_rlt, 
                               pred_rw[, c(1,4:259)], by = 'uid'))
est_rf(pred_dat)


############ 4 ##############
## Multinomial Logit (Un-ordered) 
# via a single-layer neural network
library(nnet)

source("neuralnet.R")

est_multinom = function(dat){
  mod = multinom(rank_2015~., data = dat, 
                 maxit=500, MaxNWts=30000)
  preds = predict(mod)
  
  acc = sum(preds==dat$rank_2015)/nrow(dat)
  mse = mean((as.numeric(preds) 
              - dat$rank_2015)^2)
  
  y = dat$rank_2015
  R_2 = 1 - sum((y-as.numeric(preds))^2)/sum((y-mean(y))^2)
  
  results = c(R_2*100, acc*100, mse, mod$deviance, BIC(mod))
  names(results) = c("R2", "Acc", 
                     "MSE", "Residual.Dev", "BIC")
  return(results)
}


res_mat = matrix(NA, nrow=4, ncol=5)
colnames(res_mat) = c("R2", "Acc", 
                      "MSE", "Residual.Dev", "BIC")
# null
pred_dat = cadre_dat_2005[, "rank_2015"]
res_mat[1, ] = est_multinom(pred_dat)
res_mat[1, ]

#  two hop
res_mat[2, ] = est_multinom(pred_dat_twohop)
res_mat[2, ]

# rw (BFS + DFS)
rw_2005 = as.data.frame(merge(rw_2005_p1q0_5, rw_2005_p1q2, by="uid"))
pred_rw = as.data.frame(merge(
  cadre_dat_2005[,c("uid","rank_2015", "rank_2005")], rw_2005, by = 'uid'))
pred_rw = pred_rw[, -c(1)]

res_mat[3, ] = est_multinom(pred_rw)
res_mat[3, ]

# #### CROSS VALIDATION!!
# dat = pred_rw
# nfold = 10
# N = nrow(dat)
# dat$fold = sample(c(1:10), N, replace = T)
# table(dat$fold)
# 
# for (i in 1:nfold){
#   train = dat[dat$fold!=i, -c(259)]
#   test = dat[dat$fold==i, -c(259)]
#   
#   mod_train = multinom2(rank_2015~., data = train, 
#                  maxit=500, MaxNWts=30000)
#   preds = predict(mod_train, newdata = test)
#   
#   acc = sum(preds==test$rank_2015)/nrow(test)
#   mse = mean((as.numeric(preds) 
#               - test$rank_2015)^2)
#   
#   print(c(i, acc, mse))
# }
# 1.0000000 0.6759259 0.4722222
# 2.0000000 0.6301370 0.5041096
# 3.0000000 0.6235955 0.4775281
# 4.0000000 0.6534954 0.5592705
# 5.0000000 0.6238806 0.4686567
# 6.0000000 0.5965418 0.5273775
# 7.0000000 0.6450617 0.4228395
# 8.0000000 0.6383648 0.4811321
# 9.0000000 0.6735294 0.4264706
# 10.00000  0.6614907  0.4285714


# full (two hop + rw + cov)
res_mat[4, ] = est_multinom(pred_full)
res_mat[4, ]

#####
# performance only

# abs
est_multinom(performance_abs)

#rlt
est_multinom(performance_rlt)


# nn (performance + patronage) 
# absolute
pred_dat = as.data.frame(merge(performance_abs, 
                               pred_rw[, c(1,4:259)], by = 'uid'))
est_multinom(pred_dat)

# relative
pred_dat = as.data.frame(merge(performance_rlt, 
                               pred_rw[, c(1,4:259)], by = 'uid'))
est_multinom(pred_dat)

round(res_mat, 2)

# cov
est_multinom(cadre_dat_2005)


#######


###### Visualization Plot for Predicted Outcomes
##### Predicted Rank (RW NNet Model) v.s. True Outcomes
library(ggplot2)
library(reshape2)

ranks = as.data.frame(cbind(pred_rw$rank_2015, preds))
colnames(ranks)[1] = "True Ranks in 2015"  
colnames(ranks)[2] = "Predicted Ranks in 2015"  

plot_data = melt(ranks)
#colnames(plot_data)[2] = "variable"

p22 = ggplot(data=plot_data, aes(x=value, 
                               fill=variable,color=variable)) +
  geom_histogram(binwidth=0.5, position="dodge") +
  # geom_density(alpha=0.5, bw=0.3) + 
  # geom_vline(xintercept=mean(ranks[,1]),
  #            color = "#00BFC4", linetype='dashed', size=0.9)+
  # geom_vline(xintercept=mean(ranks[,2]),
  #            color = "#F8766D", linetype='dashed', size=0.9)+
  labs(title = "Neural Networks Model \n with Patronage + Performance",
       x="Political Rank Levels", 
       y="Density") +
  coord_cartesian(xlim = c(4.5, 9.5)) +
  theme(legend.position="bottom")
p22

#####

######## Results table (Error Distribution)
dat = performance_rlt

dat = pred_rw

dat = as.data.frame(merge(performance_rlt, pred_rw,  
                          by = c('uid', 'rank_2015','rank_2005')))
colnames(dat)[10:265] = paste0(rep("rw_d", 256), 1:256)
dat = dat[,-c(1)]

mod = randomForest(rank_2015 ~ .,
                   dat, importance = T, ntree = 1000)

mod = multinom(rank_2015~., data = dat, 
               maxit=500, MaxNWts=30000)


y = dat$rank_2015
preds = round(predict(mod))
sum(preds==dat$rank_2015)/nrow(dat)

# ranks2 = ranks  
ranks_prt_perf_rf = as.data.frame(cbind(dat$rank_2015, preds))

##node purities tabel comparison
importance_table = importance(mod)[
  order(importance(mod)[,1], decreasing = T),]
importance_table = importance_table[c(1:78)]
row.names(importance_table)

performance = importance_table[c(10, 16, 25, 27, 76, 78),]
performance

patronage = importance_table[c(2:9, 11,12),]
patronage


xtable(as.matrix(patronage), digits = 2)
xtable(as.matrix(performance), digits = 2)


###
library(gridExtra)
grid.arrange(p1, p2, p3, p4, ncol=2, nrow=2)

grid.arrange(p01, p02, p11, p12, p21, p22, ncol=2, nrow=3)

##############




