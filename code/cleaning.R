
# data cleaning and preprocessing

rm(list=ls())
setwd("~/Dropbox/r0-field-paper-2019/data")


# code to construct Patronage Network SNAP graph
# data cleaning and preprocessing

raw_dat = readxl::read_xlsx("raw_cped/Full Data.xlsx", sheet = 2)
expr_dat = raw_dat[, c(1, 3, 4, 5, 8, 10, 15, 22, 24)]
colnames(expr_dat) = c("uid", "exprid", 'start_t', 'end_t', 'loc1', 'loc2', 
                       'job_type', 'rank', 'edu_level')

#clean ranks
rank_num = factor(expr_dat$rank, levels = c("无级别", "小于副处", "副处", "正处", "副厅", 
                              "正厅", "副部",  "正部", "副国", "正国"))
expr_dat$rank = as.numeric(rank_num) - 1
table(expr_dat$rank)



#clean job types
table(expr_dat$job_type)
type = expr_dat$job_type
type[type=="党委"] = "党委_共青团"
type[type=="共青团"] = "党委_共青团"
type[type=="基层组织"] = "党委_共青团"

type[type=="政府_国务院"] = "政府"
type[type=="法院_检察院"] = "政府"

type[type=="人大"] = "人大_政协_企业"
type[type=="政协"] = "人大_政协_企业"
type[type=="民主党派"] = "人大_政协_企业"
type[type=="中央企业"] = "人大_政协_企业"
type[type=="地方企业"] = "人大_政协_企业"
type[type=="行业协会_人民团体"] = "人大_政协_企业"

type =  factor(type, levels = c("党委_共青团", "政府", "军队", "人大_政协_企业",
                                "学校", "其他")) # This is 党、政、军、民、学、其他
expr_dat$job_type = as.numeric(type)
table(expr_dat$job_type, useNA = "ifany")


# #clean edu levels
edu_num = factor(expr_dat$edu_level, levels = c("不详", "初中", "高中", "专科",
                                                "本科", "硕士", "博士"))
edu_num = as.numeric(edu_num) - 1
expr_dat$edu_level = ifelse(edu_num==0, NA, edu_num)
table(expr_dat$edu_level, useNA = "ifany")


#convert time/date representation
expr_dat$start_t = as.numeric(expr_dat$start_t - as.POSIXct("1900-01-01", tz="UTC"))
expr_dat$end_t = as.numeric(expr_dat$end_t - as.POSIXct("1900-01-01", tz="UTC"))

# clean loc2 
expr_dat$loc2 = ifelse(is.na(expr_dat$loc2), expr_dat$loc1, expr_dat$loc2)


#########
## drop and recode experiences to keep ONLY those until 
# a. 2000.12.31
# b. 2005.12.31
# c. 2010.12.31
cutoff_2000 = as.numeric(as.POSIXct("2000-12-31", tz="UTC") 
                         - as.POSIXct("1900-01-01", tz="UTC"))
cutoff_2005 = as.numeric(as.POSIXct("2005-12-31", tz="UTC") 
                    - as.POSIXct("1900-01-01", tz="UTC"))
cutoff_2010 = as.numeric(as.POSIXct("2010-12-31", tz="UTC") 
                         - as.POSIXct("1900-01-01", tz="UTC"))

# 1. remove exprs starting after cutoff
keep_index_2000 = (expr_dat$start_t <= cutoff_2000) 
expr_dat_2000 = expr_dat[keep_index_2000, ]

keep_index_2005 = (expr_dat$start_t <= cutoff_2005) 
expr_dat_2005 = expr_dat[keep_index_2005, ]

keep_index_2010 = (expr_dat$start_t <= cutoff_2010) 
expr_dat_2010 = expr_dat[keep_index_2010, ]

# 2. recode exprs_end_t exceeding cufoff to cutoff
expr_dat_2000$end_t = ifelse(expr_dat_2000$end_t>cutoff_2000, 
                             cutoff_2000, expr_dat_2000$end_t)

expr_dat_2005$end_t = ifelse(expr_dat_2005$end_t>cutoff_2005, 
                             cutoff_2005, expr_dat_2005$end_t)

expr_dat_2010$end_t = ifelse(expr_dat_2010$end_t>cutoff_2010, 
                             cutoff_2010, expr_dat_2010$end_t)

#########
# drop incomplete cases (optional)
# expr_output = expr_dat[complete.cases(expr_dat), ]
# 
# expr_output_2000 = expr_dat_2000[complete.cases(expr_dat_2000), ]
# 
# expr_output_2005 = expr_dat_2005[complete.cases(expr_dat_2005), ]
# 
# expr_output_2010 = expr_dat_2010[complete.cases(expr_dat_2010), ]


#output to use in R/python
write.csv(expr_dat, row.names = F, file="experience_dats/expr_dat_2015.csv")
write.csv(expr_dat_2000, row.names = F, file="experience_dats/expr_dat_2000.csv")
write.csv(expr_dat_2005, row.names = F, file="experience_dats/expr_dat_2005.csv")
write.csv(expr_dat_2010, row.names = F, file="experience_dats/expr_dat_2010.csv")








