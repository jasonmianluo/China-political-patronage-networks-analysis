
# clean experience (unitl 2005) data and link to cadre data 

rm(list=ls())
setwd("~/Dropbox/field-paper-2019/data")

###########
# data cleaning and preprocessing for 2005
# cadre_dat = readxl::read_xlsx("Full Data.xlsx", sheet = 1)
# cadre_dat = cadre_dat[, 1:12]
# colnames(cadre_dat) = c("uid", "name", 'gender', 'ethnicity', 'DOB', 'home_province', 
#                        'home_city', 'home_town', 'highest_edu_level', 'year_join_party',
#                        'current_state', 'military')

library(readr)
cadre_dat_2015 = read_csv("raw_cped/cadre_dat_2015_cleaned.csv")
expr_dat_2005 = read_csv("experience_dats/expr_dat_2005.csv")

# 1) extract rank and education level from expr_dat in 2005

library(tidyverse)
rank_edu_2005 =
  expr_dat_2005 %>% 
  group_by(uid) %>% 
  # filter(max(end_t)==as.numeric(as.POSIXct("2015-07-01", tz="UTC") 
  #                                 - as.POSIXct("1900-01-01", tz="UTC"))) %>%
  summarise(
    rank_2005 = max(rank, na.rm = T),
    edu_level_2005 = max(edu_level, na.rm = T)
    # rank_2015 = max(rank),
    # rank_2010 = max(rank[start_t<as.numeric(as.POSIXct("2010-12-31", tz="UTC") 
    #                                         - as.POSIXct("1900-01-01", tz="UTC"))]),
    # rank_2005 = max(rank[start_t<as.numeric(as.POSIXct("2005-12-31", tz="UTC") 
    #                                         - as.POSIXct("1900-01-01", tz="UTC"))])
    # rank_2000 = max(rank[start_t<as.numeric(as.POSIXct("2000-12-31", tz="UTC") 
    #                                         - as.POSIXct("1900-01-01", tz="UTC"))])
  ) %>%
  filter(rank_2005 != -Inf & edu_2005 != -Inf)


##### Rank distribution plot 2005 vs. 2015
library(ggplot2)
library(reshape2)

ranks = as.data.frame(merge(cadre_dat_2015[,c("uid", "rank_2015")],
                            rank_edu_2005[, c('uid', 'rank_2005')], by = 'uid'))
plot_data = melt(ranks[,2:3])

p = ggplot(data=plot_data, aes(x=value, fill=variable)) +
  geom_density(alpha=0.5, bw=0.4) + 
  geom_vline(xintercept=mean(ranks$rank_2005),
             color = "#00BFC4", linetype='dashed', size=0.9)+
  geom_vline(xintercept=mean(ranks$rank_2015),
             color = "#F8766D", linetype='dashed', size=0.9)+
  labs(title = "Cadre Rank Distribution in 2005 and 2015",
       x="Political Rank Level", 
       y="Density")
p

#####

# 2) link them to the cadre dat

# merge cadre set with ranks
cadre_dat_2005 = as.data.frame(merge(cadre_dat_2015, rank_edu_2005, by = 'uid'))
cadre_dat_2005 = subset(cadre_dat_2005, select = -c(X1, highest_edu_level,
                                                    in_office))
cadre_dat_2005$age = cadre_dat_2005$age - 10
cadre_dat_2005$party_membership_age = cadre_dat_2005$party_membership_age - 10

# fill in party membership years NA by a prediction based on AGE
mod_pmyr = lm(party_membership_age ~ age, data=cadre_dat_2005)
cadre_dat_2005$party_membership_age[is.na(cadre_dat_2005$party_membership_age)]=
  predict(mod_pmyr, newdata = cadre_dat_2005)[is.na(cadre_dat_2005$party_membership_age)]

write_csv(cadre_dat_2005, "raw_cped/cadre_dat_2005_cleaned.csv")
