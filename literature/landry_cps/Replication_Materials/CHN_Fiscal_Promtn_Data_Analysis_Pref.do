log using "CHN_Fiscal_Promtn_Data_Analysis_Pref.txt", text replace

/**********************************************************************/
/* Replication Stata do file for "Does Performance Matter? Evaluating */
/* Political Selection along the Chinese Administrative Ladder"       */  
/* Xiaobo Lu, Pierre Landry, Haiyan Duan                              */
/* June 2017                                                           */
/* This file analyzes the prefecture dataset for the results reported  */
/* in the main manuscript and the online appendix              */
/**********************************************************************/



# delimit;
 
clear;
set more off;


/* Tables 3 & 5 Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors) */

use CHN_Fiscal_Promtn_Data_Pref.dta,clear;


/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov sec_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) sec_promotion sec_position_next_year pref_id  year pref_type_id prov_id (last) pref_sec_pw_prov sec_age,by(pref_ch2 ccp_sec);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;
/* Generate interaction terms */
gen tax_connection=rel_all_tax_gr*pref_sec_pw_prov;
gen gdp_connection=rel_gdp_gr*pref_sec_pw_prov;

tab year, gen(yrdmy);

/* Table 2, Column 3 */
tab sec_position_next_year;
sum sec_age sec_tty;



/* Table 3, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table 5, Columns 5-8 */
/* Growth rate of GDP */             
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Tables 4 & 6 Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to Competitors) */

use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov mayor_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) mayor_promotion mayor_position_next_year pref_id  year pref_type_id prov_id (last) pref_mayor_pw_prov mayor_age,by(pref_ch2 mayor);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen mayor_age2=mayor_age^2;
gen mayor_tty2=mayor_tty^2;

/* Generate interaction terms */
gen tax_connection=rel_all_tax_gr*pref_mayor_pw_prov;
gen gdp_connection=rel_gdp_gr*pref_mayor_pw_prov;

tab year, gen(yrdmy);

/* Table 2, Column 4 */
tab mayor_position_next_year;
sum mayor_age mayor_tty;


/* Table 4, Columns 5-8 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table 6, Columns 5-8 */
/* Growth rate of GDP */            
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);



/* Table A1 & A3: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Excluding Top and Bottom Performing Jurisdictions) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Drop top 10% and bottom 10% jurisdiction in terms of tax collection per capita */
sort prov_py pref_ch2;
by prov_py pref_ch2: egen all_tax_pc_avg=mean(all_tax_pc);
by prov_py: egen all_tax_pc_avg_90=pctile(all_tax_pc_avg), p(90);
by prov_py: egen all_tax_pc_avg_10=pctile(all_tax_pc_avg), p(10);
by prov_py: keep if all_tax_pc_avg<all_tax_pc_avg_90 & all_tax_pc_avg>all_tax_pc_avg_10;

/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov sec_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) sec_promotion sec_position_next_year pref_id  year pref_type_id prov_id (last) pref_sec_pw_prov sec_age,by(pref_ch2 ccp_sec);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Generate interaction terms */
gen tax_connection=rel_all_tax_gr*pref_sec_pw_prov;
gen gdp_connection=rel_gdp_gr*pref_sec_pw_prov;

tab year, gen(yrdmy);


/* Table A1, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A3, Columns 5-8 */
/* Growth rate of GDP */             
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A2 & A4 Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to Competitors; Excluding Top and Bottom Performing Jurisdictions) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Drop top 10% and bottom 10% jurisdiction in terms of tax collection per capita */
sort prov_py pref_ch2;
by prov_py pref_ch2: egen all_tax_pc_avg=mean(all_tax_pc);
by prov_py: egen all_tax_pc_avg_90=pctile(all_tax_pc_avg), p(90);
by prov_py: egen all_tax_pc_avg_10=pctile(all_tax_pc_avg), p(10);
by prov_py: keep if all_tax_pc_avg<all_tax_pc_avg_90 & all_tax_pc_avg>all_tax_pc_avg_10;


/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov mayor_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) mayor_promotion mayor_position_next_year pref_id  year pref_type_id prov_id (last) pref_mayor_pw_prov mayor_age,by(pref_ch2 mayor);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen mayor_age2=mayor_age^2;
gen mayor_tty2=mayor_tty^2;

/* Generate interaction terms */
gen tax_connection=rel_all_tax_gr*pref_mayor_pw_prov;
gen gdp_connection=rel_gdp_gr*pref_mayor_pw_prov;

tab year, gen(yrdmy);


/* Table A2, Columns 5-8 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A4, Columns 5-8 */
/* Growth rate of GDP */            
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);



/* Table A5 & A7: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to the Predecessor in the Same Jurisdiction) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov sec_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) sec_promotion sec_position_next_year pref_id  year pref_type_id prov_id (last) pref_sec_pw_prov sec_age,by(pref_ch2 ccp_sec);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Generate a variable to compare with the previous politician */
sort pref_id year;
by pref_id: gen rel_all_tax_gr_pr=rel_all_tax_gr[_n-1];
by pref_id: gen rel_all_tax_gr_diff=rel_all_tax_gr-rel_all_tax_gr_pr;
by pref_id: gen rel_gdp_gr_pr=rel_gdp_gr[_n-1];
by pref_id: gen rel_gdp_gr_diff=rel_gdp_gr-rel_gdp_gr_pr;

/* Generate interaction terms */
gen tax_connection=rel_all_tax_gr_diff*pref_sec_pw_prov;
gen gdp_connection=rel_gdp_gr_diff*pref_sec_pw_prov;


tab year, gen(yrdmy);

/* Table A5, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax_gr_diff pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr_diff pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_all_tax_gr_diff pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr_diff pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A7, Columns 5-8 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr_diff pref_sec_pw_pro log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr_diff pref_sec_pw_pro log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_gdp_gr_diff pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr_diff pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);




/* Table A6 & A8: Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to the Predecessor in the Same Jurisdiction) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;


/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov mayor_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) mayor_promotion mayor_position_next_year pref_id  year pref_type_id prov_id (last) pref_mayor_pw_prov mayor_age,by(pref_ch2 mayor);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen mayor_age2=mayor_age^2;
gen mayor_tty2=mayor_tty^2;

tab year, gen(yrdmy);

/* Generate a variable to compare with the previous politician */
sort pref_id year;
by pref_id: gen rel_all_tax_gr_pr=rel_all_tax_gr[_n-1];
by pref_id: gen rel_all_tax_gr_diff=rel_all_tax_gr-rel_all_tax_gr_pr;
by pref_id: gen rel_gdp_gr_pr=rel_gdp_gr[_n-1];
by pref_id: gen rel_gdp_gr_diff=rel_gdp_gr-rel_gdp_gr_pr;

/* Generate interaction terms */
gen tax_connection=rel_all_tax_gr_diff*pref_mayor_pw_prov;
gen gdp_connection=rel_gdp_gr_diff*pref_mayor_pw_prov;

/* Table A6, Columns 5-8 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax_gr_diff pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr_diff pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_all_tax_gr_diff pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr_diff pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A8, Columns 5-8 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr_diff pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr_diff pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_gdp_gr_diff pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr_diff pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);



/* Table A9 & A11: Promotion of Party Secretaries upon Term Completion (Relative Ranking of Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov sec_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) sec_promotion sec_position_next_year pref_id  year pref_type_id prov_id (last) pref_sec_pw_prov sec_age,by(pref_ch2 ccp_sec);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Generate interaction terms */
gen tax_connection=rk_all_tax_gr_ps*pref_sec_pw_prov;
gen gdp_connection=rk_gdp_gr_ps*pref_sec_pw_prov;

tab year, gen(yrdmy);

/* Table A9, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rk_all_tax_gr_ps pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rk_all_tax_gr_ps pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rk_all_tax_gr_ps pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rk_all_tax_gr_ps pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A11, Columns 5-8 */
/* Growth rate of GDP */         
areg sec_promotion rk_gdp_gr_ps pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg sec_promotion rk_gdp_gr_ps pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rk_gdp_gr_ps pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rk_gdp_gr_ps pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);



/* Table A10 & A12: Promotion of  Government Executives upon Term Completion (Relative Ranking of Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;
/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov mayor_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) mayor_promotion mayor_position_next_year pref_id  year pref_type_id prov_id (last) pref_mayor_pw_prov mayor_age,by(pref_ch2 mayor);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen mayor_age2=mayor_age^2;
gen mayor_tty2=mayor_tty^2;

/* Generate intearction terms */
gen tax_connection=rk_all_tax_gr_ps*pref_mayor_pw_prov;
gen gdp_connection=rk_gdp_gr_ps*pref_mayor_pw_prov;

tab year, gen(yrdmy);


/* Table A10, Columns 5-8 */
/* Growth rate of Tax revenues */
areg mayor_promotion rk_all_tax_gr_ps pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rk_all_tax_gr_ps pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rk_all_tax_gr_ps pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rk_all_tax_gr_ps pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A12, Columns 5-8 */
/* Growth rate of GDP */          
areg mayor_promotion rk_gdp_gr_ps pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg mayor_promotion rk_gdp_gr_ps pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rk_gdp_gr_ps pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rk_gdp_gr_ps pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);



/* Table A13 & 14: Promotion of Prefecture-Level Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; by Age Eligibility for Promotion) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov sec_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) sec_promotion sec_position_next_year pref_id  year pref_type_id prov_id (last) pref_sec_pw_prov sec_age,by(pref_ch2 ccp_sec);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Generate interaction terms */
gen tax_connection=rk_all_tax_gr_ps*pref_sec_pw_prov;
gen gdp_connection=rk_gdp_gr_ps*pref_sec_pw_prov;

tab year, gen(yrdmy);

/* Age eligible */
gen age_eligible=.;
replace age_eligible=1 if sec_age<=55 & sec_age~=.;
replace age_eligible=0 if sec_age>55 & sec_age~=.;

/* Table A13, Columns 1-4 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


/* Table A14, Columns 1-4 */
/* Growth rate of GDP */            
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);
              
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


/* Table A13, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);


/* Table A14, Columns 5-8 */
/* Growth rate of GDP */            
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);
              
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);



/* Table A13 & 14: Promotion of Prefecture-Level Mayors upon Term Completion (Relative Revenue/GDP Performance to Competitors; by Age Eligibility for Promotion) */
use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

use CHN_Fiscal_Promtn_Data_Pref.dta,clear;
/* Generate per-term measures */
collapse rel_all_tax_gr rel_gdp_gr log_pop rural_pop_pct log_light  pool_size log_dist_prefprov mayor_tty rk_all_tax_gr_ps rk_gdp_gr_ps all_tax_pc all_tax_gdp (max) mayor_promotion mayor_position_next_year pref_id  year pref_type_id prov_id (last) pref_mayor_pw_prov mayor_age,by(pref_ch2 mayor);

/* Eliminate some outliers */
drop if all_tax_gdp>=100; 

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate the squared term for politicians' age and total year in office */
gen mayor_age2=mayor_age^2;
gen mayor_tty2=mayor_tty^2;

/* Generate intearction terms */
gen tax_connection=rk_all_tax_gr_ps*pref_mayor_pw_prov;
gen gdp_connection=rk_gdp_gr_ps*pref_mayor_pw_prov;

tab year, gen(yrdmy);


/* Age eligible */
gen age_eligible=.;
replace age_eligible=1 if mayor_age<=55 & mayor_age~=.;
replace age_eligible=0 if mayor_age>55 & mayor_age~=.;


/* Table A13, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


/* Table A14, Columns 9-12 */
/* Growth rate of GDP */

areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);
              
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==1,  cluster(pref_id) absorb(prov_id);


/* Table A13, Columns 13-16 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);


/* Table A14, Columns 13-16 */
/* Growth rate of GDP */
              
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);
              
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id if age_eligible==0,  cluster(pref_id) absorb(prov_id);



/* Tables 21 - 24 Promotion of Party Secretaries/Mayors on Yearly Data (Relative Revenue/GDP Performance to Competitors) */

use CHN_Fiscal_Promtn_Data_Pref.dta,clear;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;
drop if all_tax_gdp>=100; /* Eliminate some outliers */
tab year, gen(yrdmy);

/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection_sec=rel_all_tax_gr*pref_sec_pw_prov;
gen gdp_connection_sec=rel_gdp_gr*pref_sec_pw_prov;

/* Table A21, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection_sec log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_all_tax_gr pref_sec_pw_prov tax_connection_sec log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A23, Columns 5-8 */
/* Growth rate of GDP */             
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg sec_promotion rel_gdp_gr pref_sec_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection_sec log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg sec_promotion rel_gdp_gr pref_sec_pw_prov gdp_connection_sec log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Mayor */

/* Generate the squared term for politicians' age and total year in office */
gen mayor_age2=mayor_age^2;
gen mayor_tty2=mayor_tty^2;

/* Generate intearction terms */
gen tax_connection_mayor=rel_all_tax_gr*pref_mayor_pw_prov;
gen gdp_connection_mayor=rel_gdp_gr*pref_mayor_pw_prov;

/* Table A22, Columns 5-8 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection_mayor log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_all_tax_gr pref_mayor_pw_prov tax_connection_mayor log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


/* Table A24, Columns 5-8 */
/* Growth rate of GDP */             
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);
              
areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);


areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection_mayor log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);

areg mayor_promotion rel_gdp_gr pref_mayor_pw_prov gdp_connection_mayor log_pop rural_pop_pct log_light  pool_size log_dist_prefprov  mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.pref_type_id ,  cluster(pref_id) absorb(prov_id);



log close;



