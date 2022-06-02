

##########
cadre_dat = readxl::read_xlsx("raw_cped/Full Data.xlsx", sheet = 1)
cadre_dat = cadre_dat[, 1:12]
colnames(cadre_dat) = c("uid", "name", 'gender', 'ethnicity', 'DOB', 'home_province', 
                        'home_city', 'home_town', 'highest_edu_level', 'year_join_party',
                        'current_state', 'military')


###### Get highest Rank for each leader
library(readr)
expr_dat = read_csv("experience_dats/expr_dat_2015.csv")

library(tidyverse)
rank_2015 =
  expr_dat %>% 
  group_by(uid) %>% 
  summarise(rank_2015= max(rank))
######

cadre_dat = as.data.frame(merge(cadre_dat, rank_2015, by = 'uid'))
cadre_dat = subset(cadre_dat, select= -c(name, home_province, 
                                         home_city, home_town, military))

# clean codes
cadre_dat$gender = ifelse(cadre_dat$gender =='男', 1, 0)
cadre_dat$ethnicity = ifelse(cadre_dat$ethnicity  == '汉族', 1, 0)
cadre_dat$in_office = ifelse(cadre_dat$current_state=='在职', 1, 0)

cadre_dat$age = as.numeric(as.POSIXct("2015-07-01", tz="UTC") 
                           - cadre_dat$DOB)/365
cadre_dat$party_membership_age = as.numeric(as.POSIXct("2015-07-01", tz="UTC") 
                           - cadre_dat$year_join_party)/365
cadre_dat = subset(cadre_dat, select= -c(current_state, DOB,
                                         year_join_party))


# clean edu levels
cadre_dat$highest_edu_level[cadre_dat$highest_edu_level=='博士后'] = '博士'
edu_num = factor(cadre_dat$highest_edu_level, levels = c("不详", "初中", "高中", "专科",
                                                         "本科", "硕士", "博士"))
cadre_dat$highest_edu_level = as.numeric(edu_num) - 1
cadre_dat$highest_edu_level = ifelse(cadre_dat$highest_edu_level==0, 
                                     NA, cadre_dat$highest_edu_level)

sum(is.na(cadre_dat$ethnicity))
sum(is.na(cadre_dat$highest_edu_level))

#cadre_dat = cadre_dat[complete.cases(cadre_dat),]
write.csv(cadre_dat, file="raw_cped/cadre_dat_cleaned.csv")


# summary stats

sums <- function(var){
  mean = mean(var, na.rm = T)
  sd = sd(var, na.rm = T)
  quantile_25 = quantile(var, probs=0.25, na.rm = T)
  quantile_75 = quantile(var, probs=0.75, na.rm = T)
  
  return(c(mean,sd, quantile_25, quantile_75))
}

sum_stat = apply(cadre_dat, 2, sums)
sum_stat = t(round(sum_stat, 2))

library(xtable)
xtable(sum_stat)

####


library(ggplot2)

plot1 <- ggplot(expr_output, aes(x=rank))+
  geom_histogram(binwidth=0.5, col='black', fill='blue') +
  labs(title="Distribution of Rank in Career Experiences") +
  stat_bin(aes(label=ifelse(..count.. > 0, ..count.., "")), 
           geom="text", binwidth=0.5, vjust=-.5) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  labs(x="Cadre Rank", y="Count") + 
  ylim(c(0, 15000)) +
  theme_minimal()
plot1


plot2 <- ggplot(expr_output, aes(x=job_type))+
  geom_histogram(binwidth=0.5, col='black', fill='red') +
  labs(title="Distribution of Job Type in Career Experiences") +
  stat_bin(aes(label=ifelse(..count.. > 0, ..count.., "")), 
           geom="text", binwidth=0.5, vjust=-.5) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6)) +
  labs(x="Job Type", y="Count") + 
  ylim(c(0, 25000)) +
  theme_minimal()
plot2

library(gridExtra)
grid.arrange(plot1, plot2, nrow = 2)

