## construct cadre performance measures


rm(list=ls())
setwd("~/Dropbox/r0-field-paper-2019/data")


#########
options(scipen=999)
library(readr)
library(haven)

# load cadre_dat of 2005
cadre_dat_2005 = readr::read_csv("raw_cped/cadre_dat_2005_cleaned.csv")

# load city - econ panel data
econ_panel = read_dta("jiang-ajps-2018-data/econ_panel.dta")

# load city panel base
city_panel = read_dta("jiang-ajps-2018-data/citypanel_base.dta")

# add province-year var to each city obs in econ panel
econ_panel$provinceyear = paste(city_panel$provid, city_panel$year, sep="-")



## 1)
## first obtain city-year growth part that is attributed to LEADERS
## i.e. net out city, province-year, and econ develop measures by precessors:
# startmsec_loggdp, startmayor_loggdp, startmsec_logpop, startmayor_logpop, 
# startmsec_loginvest, startmayor_loginvest, startmsec_gdpidx, startmayor_gdpidx

model_gdpidx_rl = lm(gdpidx ~ startmsec_loggdp + startmayor_loggdp 
                        + startmsec_gdpidx + startmayor_gdpidx
                        + as.factor(cityid) + as.factor(provinceyear),
                        data = econ_panel)
summary(model_gdpidx_rl)

model_gdpidx_1st_rl = lm(gdpidx_1st ~ startmsec_loggdp + startmayor_loggdp 
                       + startmsec_gdpidx + startmayor_gdpidx
                       + as.factor(cityid) + as.factor(provinceyear),
                       data = econ_panel)
summary(model_gdpidx_1st_rl)

model_gdpidx_2nd_rl = lm(gdpidx_2nd ~ startmsec_loggdp + startmayor_loggdp 
                         + startmsec_gdpidx + startmayor_gdpidx
                         + as.factor(cityid) + as.factor(provinceyear),
                         data = econ_panel)
summary(model_gdpidx_2nd_rl)

model_gdpidx_3rd_rl = lm(gdpidx_3rd ~ startmsec_loggdp + startmayor_loggdp 
                         + startmsec_gdpidx + startmayor_gdpidx
                         + as.factor(cityid) + as.factor(provinceyear),
                         data = econ_panel)
summary(model_gdpidx_3rd_rl)

model_f2gdpidx_rl = lm(f2gdpidx ~ startmsec_loggdp + startmayor_loggdp 
              + startmsec_gdpidx + startmayor_gdpidx
              + as.factor(cityid) + as.factor(provinceyear),
              data = econ_panel)
summary(model_f2gdpidx_rl)


model_logltavg_rl = lm(logltavg ~ startmsec_loggdp + startmayor_loggdp 
                       + startmsec_gdpidx + startmayor_gdpidx
                       + as.factor(cityid) + as.factor(provinceyear),
                       data = econ_panel)
summary(model_logltavg_rl)

# add raw measures of performance to city panel data
city_panel2 = city_panel[, 1:7]
city_panel2$gdpidx = econ_panel$gdpidx - 100
city_panel2$gdpidx_1st = econ_panel$gdpidx_1st - 100
city_panel2$gdpidx_2nd = econ_panel$gdpidx_2nd - 100
city_panel2$gdpidx_3rd = econ_panel$gdpidx_3rd - 100
city_panel2$f2gdpidx = econ_panel$f2gdpidx - 100
city_panel2$logltavg = econ_panel$logltavg

# add the residuals to city panel
city_panel2$obsid = row.names(city_panel2)

gdpidx_rl = as.data.frame(model_gdpidx_rl$residuals)
gdpidx_rl$obsid = names(model_gdpidx_rl$residuals)
colnames(gdpidx_rl)[1] = 'gdpidx_rl'  

gdpidx_1st_rl = as.data.frame(model_gdpidx_1st_rl$residuals)
gdpidx_1st_rl$obsid = names(model_gdpidx_1st_rl$residuals)
colnames(gdpidx_1st_rl)[1] = 'gdpidx_1st_rl'  

gdpidx_2nd_rl = as.data.frame(model_gdpidx_2nd_rl$residuals)
gdpidx_2nd_rl$obsid = names(model_gdpidx_2nd_rl$residuals)
colnames(gdpidx_2nd_rl)[1] = 'gdpidx_2nd_rl'  

gdpidx_3rd_rl = as.data.frame(model_gdpidx_3rd_rl$residuals)
gdpidx_3rd_rl$obsid = names(model_gdpidx_3rd_rl$residuals)
colnames(gdpidx_3rd_rl)[1] = 'gdpidx_3rd_rl'  

f2gdpidx_rl = as.data.frame(model_f2gdpidx_rl$residuals)
f2gdpidx_rl$obsid = names(model_f2gdpidx_rl$residuals)
colnames(f2gdpidx_rl )[1] = 'f2gdpidx_rl'  

logltavg_rl = as.data.frame(model_logltavg_rl$residuals)
logltavg_rl$obsid = names(model_logltavg_rl$residuals)
colnames(logltavg_rl)[1] = 'logltavg_rl'  


# merge 
city_panel2 = merge(city_panel2, gdpidx_rl, 
                    by="obsid", all.x=T)
city_panel2 = merge(city_panel2, gdpidx_1st_rl,
                    by="obsid", all.x=T)
city_panel2 = merge(city_panel2, gdpidx_2nd_rl,
                    by="obsid", all.x=T)
city_panel2 = merge(city_panel2, gdpidx_3rd_rl,
                    by="obsid", all.x=T)
city_panel2 = merge(city_panel2, f2gdpidx_rl,
                    by="obsid", all.x=T)
city_panel2 = merge(city_panel2, logltavg_rl,
                    by="obsid", all.x=T)
city_panel2$obsid = as.numeric(city_panel2$obsid)
city_panel2 = city_panel2[order(city_panel2$obsid),]



# 2) #######
#### merge this with CADRE dataset
raw_dat = readxl::read_xlsx("raw_cped/Full Data.xlsx", sheet = 1)
colnames(raw_dat)[1] = "uid"
colnames(raw_dat)[2] = "name"

## NEED TO CLEAN UP duplications of name
#  approx 150 peoples involved
# print(raw_dat[nchar(raw_dat$name)>=7, "name"], n=200)
# city_panel2[nchar(city_panel2$msec)>=7, "msec"]
# city_panel2[nchar(city_panel2$mayor)>=7, "mayor"]


cadre_dat_2005 = merge(raw_dat[,1:2], cadre_dat_2005, by="uid")
performance = as.data.frame(matrix(NA, nrow=nrow(cadre_dat_2005), ncol=13))
colnames(performance) = c("uid", colnames(city_panel2)[9:20])
  
for (i in 1: nrow(cadre_dat_2005)){
  cname = cadre_dat_2005[i, 'name']
  
  performs = rbind(city_panel2[which(cname == city_panel2$msec), 9:20], 
                   city_panel2[which(cname == city_panel2$mayor), 9:20])
  
  performance[i,] = c(cadre_dat_2005[i, 'uid'], 
                      apply(performs, MARGIN=2, FUN = mean, na.rm=T))
}


cadre_dat_2005_wperf = merge(cadre_dat_2005, performance, 
                             by="uid")

# save data
write_csv(cadre_dat_2005_wperf, 
          "raw_cped/cadre_dat_2005_cleaned_wperf.csv")

 


