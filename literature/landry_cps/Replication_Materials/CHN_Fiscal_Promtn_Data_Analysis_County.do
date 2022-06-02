log using "CHN_Fiscal_Promtn_Data_Analysis_County.txt", text replace

/**********************************************************************/
/* Replication Stata do file for "Does Performance Matter? Evaluating */
/* Political Selection along the Chinese Administrative Ladder"       */  
/* Xiaobo Lu, Pierre Landry, Haiyan Duan                              */
/* June 2017                                                           */
/* This file analyzes the county-level dataset for the results reported*/
/* in the main manuscript and the online appendix              */
/**********************************************************************/



# delimit;
clear;
clear matrix;
clear mata;
set matsize 3000;
set maxvar 10000;
set more off;



/* Tables 3 & 5 Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;


/* Table 2, Column 5 */
tab sec_position_next_year;
sum sec_age sec_tty;


/* Table 3, Columns 9-12 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table 5, Columns 9-12 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Tables 4 & 6 Promotion of County Heads upon Term Completion (Relative Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr*mayor_pw_pref;


/* Table 2, Column 6 */
tab mayor_position_next_year;
sum mayor_age mayor_tty;

/* Table 4, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table 6, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A1 & A3: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Excluding Top and Bottom Performing Jurisdictions) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;

/* Drop top 10% and bottom 10% jurisdiction in terms of tax collection per capita */
sort prov_py pref_ch county_id;
by prov_py pref_ch county_id: egen all_tax_pc1_avg=mean(all_tax_pc1);
by prov_py pref_ch: egen all_tax_pc1_avg_90=pctile(all_tax_pc1_avg), p(90);
by prov_py pref_ch: egen all_tax_pc1_avg_10=pctile(all_tax_pc1_avg), p(10);
by prov_py pref_ch: keep if all_tax_pc1_avg<all_tax_pc1_avg_90 & all_tax_pc1_avg>all_tax_pc1_avg_10;

sort prov_py pref_ch sec_id year;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;


/* Table A1, Columns 9-12 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A3, Columns 9-12 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);




/* Table A2 & A4: Promotion of County heads upon Term Completion (Relative Revenue/GDP Performance to Competitors; Excluding Top and Bottom Performing Jurisdictions) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Drop top 10% and bottom 10% jurisdiction in terms of tax collection per capita */
sort prov_py pref_ch county_id;
by prov_py pref_ch county_id: egen all_tax_pc1_avg=mean(all_tax_pc1);
by prov_py pref_ch: egen all_tax_pc1_avg_90=pctile(all_tax_pc1_avg), p(90);
by prov_py pref_ch: egen all_tax_pc1_avg_10=pctile(all_tax_pc1_avg), p(10);
by prov_py pref_ch: keep if all_tax_pc1_avg<all_tax_pc1_avg_90 & all_tax_pc1_avg>all_tax_pc1_avg_10;

sort prov_py pref_ch mayor_id year;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr*mayor_pw_pref;

/* Table A2, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A4, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A5 & A7: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to the Predecessor in the Same Jurisdiction) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;


/* Generate a variable to compare with the previous politician */
sort county_id year;
by county_id: gen rel_all_tax1_gr_pr=rel_all_tax1_gr[_n-1];
by county_id: gen rel_all_tax1_gr_diff=rel_all_tax1_gr-rel_all_tax1_gr_pr;
by county_id: gen rel_gdp_gr_pr=rel_gdp_gr[_n-1];
by county_id: gen rel_gdp_gr_diff=rel_gdp_gr-rel_gdp_gr_pr;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr_diff*sec_pw_pref;
gen gdp_connection=rel_gdp_gr_diff*sec_pw_pref;

/* Table A5, Columns 9-12 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr_diff sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr_diff sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr_diff sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr_diff sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A7, Columns 9-12 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr_diff sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr_diff sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr_diff sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr_diff sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A6 & A8 Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to the Predecessor in the Same Jurisdiction) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate a variable to compare with the previous politician */
sort county_id year;
by county_id: gen rel_all_tax1_gr_pr=rel_all_tax1_gr[_n-1];
by county_id: gen rel_all_tax1_gr_diff=rel_all_tax1_gr-rel_all_tax1_gr_pr;
by county_id: gen rel_gdp_gr_pr=rel_gdp_gr[_n-1];
by county_id: gen rel_gdp_gr_diff=rel_gdp_gr-rel_gdp_gr_pr;


/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr_diff*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr_diff*mayor_pw_pref;

/* Table A6, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr_diff mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr_diff mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr_diff mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr_diff mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A8, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr_diff mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr_diff mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr_diff mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr_diff mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A9 & A11: Promotion of Party Secretaries upon Term Completion (Relative Ranking of Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rk_all_tax1_gr_ps*sec_pw_pref;
gen gdp_connection=rk_gdp_gr_ps*sec_pw_pref;


/* Table A9, Columns 9-12 */
/* Growth rate of Tax revenues */
areg sec_promotion rk_all_tax1_gr_ps sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rk_all_tax1_gr_ps sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rk_all_tax1_gr_ps sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rk_all_tax1_gr_ps sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A11, Columns 9-12 */
/* Growth rate of GDP */
areg sec_promotion rk_gdp_gr_ps sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rk_gdp_gr_ps sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rk_gdp_gr_ps sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rk_gdp_gr_ps sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A10 & A12: Promotion of Government Executives upon Term Completion (Relative Ranking of Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rk_all_tax1_gr_ps*mayor_pw_pref;
gen gdp_connection=rk_gdp_gr_ps*mayor_pw_pref;


/* Table A10, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rk_all_tax1_gr_ps mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rk_all_tax1_gr_ps mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rk_all_tax1_gr_ps mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rk_all_tax1_gr_ps mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A12, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rk_gdp_gr_ps mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rk_gdp_gr_ps mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rk_gdp_gr_ps mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rk_gdp_gr_ps mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A15 & A16: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; by Age Eligibility for Promotion) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;

/* Age eligible */
gen age_eligible=.;
replace age_eligible=1 if sec_age<=50 & sec_age~=.;
replace age_eligible=0 if sec_age>50 & sec_age~=.;


/* Table A15, Columns 1-4 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


/* Table A16, Columns 1-4 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


/* Table A15, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);


/* Table A16, Columns 5-8 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);



/* Table A15 & A16: Promotion of County Heads upon Term Completion (Relative Revenue/GDP Performance to Competitors; by Age Eligibility for Promotion) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rk_all_tax1_gr_ps*mayor_pw_pref;
gen gdp_connection=rk_gdp_gr_ps*mayor_pw_pref;

/* Age eligible */
gen age_eligible=.;
replace age_eligible=1 if mayor_age<=50 & mayor_age~=.;
replace age_eligible=0 if mayor_age>50 & mayor_age~=.;


/* Table A15, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


/* Table A16, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==1,  cluster(county_id) absorb(pref_id);



/* Table A15, Columns 13-16 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);


/* Table A16, Columns 13-16 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id if age_eligible==0,  cluster(county_id) absorb(pref_id);



/* Table A17 & A18: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; County vs. Urban District) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Keep only counties */
drop if county_type=="Forestry_district" | county_type=="Special_district" | county_type=="Urban_district" | county_type=="Urban_minority_district";


/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;



/* Table A17, Columns 1-4 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A18, Columns 1-4 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A17 & A18: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; County vs. Urban District) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Keep only districts */
keep  if county_type=="Urban_district" | county_type=="Urban_minority_district";


/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;



/* Table A17, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A18, Columns 5-8 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A17 & A18: Promotion of County Head upon Term Completion (Relative Revenue/GDP Performance to Competitors; County vs. Urban District) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Keep only counties */
drop if county_type=="Forestry_district" | county_type=="Special_district" | county_type=="Urban_district" | county_type=="Urban_minority_district";

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr*mayor_pw_pref;


/* Table A17, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A18, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A17 & A18: Promotion of County Head upon Term Completion (Relative Revenue/GDP Performance to Competitors; County vs. Urban District) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Keep only districts */
keep if county_type=="Urban_district" | county_type=="Urban_minority_district";

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr*mayor_pw_pref;


/* Table A17, Columns 13-16 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A18, Columns 13-16 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A19 & A20: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Minority vs. Non-Minority Jurisdictions) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Delete minority counties */
drop if prov_py=="XINJIANG" | prov_py=="TIBET" | prov_py=="NINGXIA";
drop if minority_county==1;

/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;


/* Table A19, Columns 1-4 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A20, Columns 1-4 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Table A19 & A20: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Minority vs. Non-Minority Jurisdictions) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* keep minority counties */
keep if prov_py=="XINJIANG" | prov_py=="TIBET" | prov_py=="NINGXIA" | minority_county==1;


/* Generate politician id */
egen sec_id=group(dlat dlong ccp_sec);
drop if sec_id==.;


/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size  sec_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) sec_promotion sec_position_next_year pref_id year (last) prov_id county_type_id sec_pw_pref sec_age, by(sec_id);


/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection=rel_gdp_gr*sec_pw_pref;


/* Table A19, Columns 5-8 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A20, Columns 5-8 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A19 & A20: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Minority vs. Non-Minority Jurisdictions) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Delete minority counties */
drop if prov_py=="XINJIANG" | prov_py=="TIBET" | prov_py=="NINGXIA";
drop if minority_county==1;

/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr*mayor_pw_pref;


/* Table A19, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A20, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A19 & A20: Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Minority vs. Non-Minority Jurisdictions) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* keep minority counties */
keep if prov_py=="XINJIANG" | prov_py=="TIBET" | prov_py=="NINGXIA" | minority_county==1;


/* Generate politician id */
egen mayor_id=group(dlat dlong mayor);
drop if mayor_id==.;

/* Generate per-term measures */
collapse county_id  log_pop2 rural_pop_pct log_light pool_size mayor_tty rel_gdp_gr rel_all_tax1_gr log_dist_countypref rk_all_tax1_gr_ps rk_gdp_gr_ps (max) mayor_promotion mayor_position_next_year pref_id year (last) prov_id county_type_id mayor_pw_pref mayor_age, by(mayor_id);

/* Generate nonlinear terms for year in office and age*/
gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete right censoring: people do not have position change next year in 2007 */
drop if mayor_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection=rel_gdp_gr*mayor_pw_pref;


/* Table A19, Columns 13-16 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A20, Columns 13-16 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);



/* Tables A21 - A24 Promotion of Party Secretaries/County Heads on Yearly Data (Relative Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_County.dta,clear;

/* Generate nonlinear terms for year in office and age*/
gen sec_age2=sec_age*sec_age;
gen sec_tty2=sec_tty*sec_tty;

gen mayor_age2=mayor_age*mayor_age;
gen mayor_tty2=mayor_tty*mayor_tty;

tab pref_id,gen(prefdm);
tab year, gen(yrdmy);

/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate interaction terms */
gen tax_connection_sec=rel_all_tax1_gr*sec_pw_pref;
gen gdp_connection_sec=rel_gdp_gr*sec_pw_pref;
gen tax_connection_mayor=rel_all_tax1_gr*mayor_pw_pref;
gen gdp_connection_mayor=rel_gdp_gr*mayor_pw_pref;


/* Table A21, Columns 9-12 */
/* Growth rate of Tax revenues */
areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection_sec log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_all_tax1_gr sec_pw_pref tax_connection_sec log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A23, Columns 9-12 */
/* Growth rate of GDP */
areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection_sec log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg sec_promotion rel_gdp_gr sec_pw_pref gdp_connection_sec log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id sec_tty sec_tty2 sec_age sec_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A22, Columns 9-12 */
/* Growth rate of Tax revenues */
areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection_mayor log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_all_tax1_gr mayor_pw_pref tax_connection_mayor log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


/* Table A24, Columns 9-12 */
/* Growth rate of GDP */
areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection_mayor log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);

areg mayor_promotion rel_gdp_gr mayor_pw_pref gdp_connection_mayor log_pop2 rural_pop_pct log_light  pool_size log_dist_countypref i.county_type_id mayor_tty mayor_tty2 mayor_age mayor_age2 yrdmy* i.prov_id,  cluster(county_id) absorb(pref_id);


log close;
