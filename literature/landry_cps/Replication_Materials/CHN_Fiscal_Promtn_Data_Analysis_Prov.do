log using "CHN_Fiscal_Promtn_Data_Analysis_Prov.txt", text replace

/**********************************************************************/
/* Replication Stata do file for "Does Performance Matter? Evaluating */
/* Political Selection along the Chinese Administrative Ladder"       */  
/* Xiaobo Lu, Pierre Landry, Haiyan Duan                              */
/* June 2017                                                           */
/* This file analyzes the provincial dataset for the results reported */
/* in the main manuscript and online appendix              */
/**********************************************************************/


# delimit;
clear;
set more off;


/* Tables 3 & 5 Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors) */


use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr sec_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  sec_promotion sec_position_next_year year (last) prov_sec_pw_cg_r_any sec_age ,by(prov ccp_sec);

/* Generate interaction terms for performance and political connection */
gen tax_connection=prov_sec_pw_cg_r_any*rel_nol_rev_gr;
gen gdp_connection=prov_sec_pw_cg_r_any*rel_nol_gdp_gr;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table 2, Column 1 */
tab sec_position_next_year;
sum sec_age sec_tty;

/* Table 3, Columns 1-4 */
/* Growth rate of Tax revenues */
         
reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


/* Table 5, Columns 1-4 */
/* Growth rate of GDP */
reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);



/* Tables 4 & 6 Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr gov_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  gov_promotion gov_position_next_year year (last) prov_gov_pw_cg_r_any gov_age ,by(prov governor);

/* Generate interaction terms for performance and political connection */
gen tax_connection=prov_gov_pw_cg_r_any*rel_nol_rev_gr;
gen gdp_connection=prov_gov_pw_cg_r_any*rel_nol_gdp_gr;

/* Generate the squared term for politicians' age and total year in office */
gen gov_age2=gov_age^2;
gen gov_tty2=gov_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if gov_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table 2, Column 2 */
tab gov_position_next_year;
sum gov_age gov_tty;


/* Table 4, Columns 1-4 */
/* Growth rate of Tax revenues */
reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


/* Table 6, Columns 1-4 */
/* Growth rate of GDP */
reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);




/********************************************/
/* Aanlysis reported in the online Appendix */
/********************************************/

/* Tables A1 & A3 Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to Competitors; Excluding Top and Bottom Performing Jurisdictions) */

use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Identify the top/bottom performance provinces */
sort prov_py;
by prov_py: egen total_tax_rev_pc_avg=mean(total_tax_rev_pc);
egen total_tax_rev_pc_avg_90=pctile(total_tax_rev_pc_avg), p(90);
egen total_tax_rev_pc_avg_10=pctile(total_tax_rev_pc_avg), p(10);
keep if total_tax_rev_pc_avg<total_tax_rev_pc_avg_90 & total_tax_rev_pc_avg>total_tax_rev_pc_avg_10;

sort prov ccp_sec year;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr sec_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  sec_promotion sec_position_next_year year (last) prov_sec_pw_cg_r_any sec_age ,by(prov ccp_sec);

/* Generate interaction terms for performance and political connection */
gen tax_connection=prov_sec_pw_cg_r_any*rel_nol_rev_gr;
gen gdp_connection=prov_sec_pw_cg_r_any*rel_nol_gdp_gr;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table A1, Columns 1-4 */
/* Relative performance */
/* Growth rate of Tax revenues */
         
reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


/* Table A3, Columns 1-4 */
/* Relative performance */
/* Growth rate of GDP */
reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);



/* Tables A2 & A4 Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to Competitors; Excluding Top and Bottom Performing Jurisdictions) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Identify the top/bottom performance provinces */
sort prov_py;
by prov_py: egen total_tax_rev_pc_avg=mean(total_tax_rev_pc);
egen total_tax_rev_pc_avg_90=pctile(total_tax_rev_pc_avg), p(90);
egen total_tax_rev_pc_avg_10=pctile(total_tax_rev_pc_avg), p(10);
keep if total_tax_rev_pc_avg<total_tax_rev_pc_avg_90 & total_tax_rev_pc_avg>total_tax_rev_pc_avg_10;

sort prov governor year;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr gov_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  gov_promotion gov_position_next_year year (last) prov_gov_pw_cg_r_any gov_age ,by(prov governor);

/* Generate interaction terms for performance and political connection */
gen tax_connection=prov_gov_pw_cg_r_any*rel_nol_rev_gr;
gen gdp_connection=prov_gov_pw_cg_r_any*rel_nol_gdp_gr;

/* Generate the squared term for politicians' age and total year in office */
gen gov_age2=gov_age^2;
gen gov_tty2=gov_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if gov_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table A2, Columns 1-4 */
/* Growth rate of Tax revenues */
reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


/* Table A4, Columns 1-4 */
/* Growth rate of GDP */
reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);



/* Tables A5 & A7 Promotion of Party Secretaries upon Term Completion (Relative Revenue/GDP Performance to the Predecessor in the Same Jurisdiction) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr sec_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  sec_promotion sec_position_next_year year (last) prov_sec_pw_cg_r_any sec_age ,by(prov ccp_sec);

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Generate a variable to compare with the previous politician */
sort prov year;
by prov: gen rel_nol_rev_gr_pr=rel_nol_rev_gr[_n-1];
by prov: gen rel_nol_rev_gr_diff=rel_nol_rev_gr-rel_nol_rev_gr_pr;
by prov: gen rel_nol_gdp_gr_pr=rel_nol_gdp_gr[_n-1];
by prov: gen rel_nol_gdp_gr_diff=rel_nol_gdp_gr-rel_nol_gdp_gr_pr;

/* Generate interaction terms for performance and political connection */
gen tax_connection=rel_nol_rev_gr_diff*prov_sec_pw_cg_r_any;
gen gdp_connection=rel_nol_gdp_gr_diff*prov_sec_pw_cg_r_any;

/* Table A5, Columns 1-4 */
/* Relative performance */
/* Growth rate of Tax revenues */
reg sec_promotion rel_nol_rev_gr_diff prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_rev_gr_diff prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_rev_gr_diff prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_rev_gr_diff prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


/* Table A7, Columns 1-4 */
/* Relative performance */
/* Growth rate of GDP */
reg sec_promotion rel_nol_gdp_gr_diff prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr_diff prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_gdp_gr_diff prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr_diff prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);



/* Tables A6 & A8 Promotion of Government Executives upon Term Completion (Relative Revenue/GDP Performance to the Predecessor in the Same Jurisdiction) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr gov_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  gov_promotion gov_position_next_year year (last) prov_gov_pw_cg_r_any gov_age ,by(prov governor);

/* Generate the squared term for politicians' age and total year in office */
gen gov_age2=gov_age^2;
gen gov_tty2=gov_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if gov_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate a variable to compare with the previous politician */
sort prov year;
by prov: gen rel_nol_rev_gr_pr=rel_nol_rev_gr[_n-1];
by prov: gen rel_nol_rev_gr_diff=rel_nol_rev_gr-rel_nol_rev_gr_pr;
by prov: gen rel_nol_gdp_gr_pr=rel_nol_gdp_gr[_n-1];
by prov: gen rel_nol_gdp_gr_diff=rel_nol_gdp_gr-rel_nol_gdp_gr_pr;

/* Generate interaction terms for performance and political connection */
gen tax_connection=rel_nol_rev_gr_diff*prov_gov_pw_cg_r_any;
gen gdp_connection=rel_nol_gdp_gr_diff*prov_gov_pw_cg_r_any;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table A6, Columns 1-4 */
/* Growth rate of Tax revenues */              
reg gov_promotion rel_nol_rev_gr_diff prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
                    
reg gov_promotion rel_nol_rev_gr_diff prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_rev_gr_diff prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_rev_gr_diff prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


/* Table A8, Columns 1-4 */
/* Growth rate of GDP */
reg gov_promotion rel_nol_gdp_gr_diff prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr_diff prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_gdp_gr_diff prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr_diff prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


/* Tables A9 & A11 Promotion of Party Secretaries upon Term Completion (Relative Ranking of Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;


/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr sec_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  sec_promotion sec_position_next_year year (last) prov_sec_pw_cg_r_any sec_age ,by(prov ccp_sec);

/* Generate interaction terms for performance and political connection */
gen tax_connection=prov_sec_pw_cg_r_any*rk_nol_rev_gr_ps;
gen gdp_connection=prov_sec_pw_cg_r_any*rk_nol_gdp_gr_ps;

/* Generate the squared term for politicians' age and total year in office */
gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if sec_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table A9, Columns 1-4 */
/* Growth rate of Tax revenues */
reg sec_promotion rk_nol_rev_gr_ps prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg sec_promotion rk_nol_rev_gr_ps prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rk_nol_rev_gr_ps prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rk_nol_rev_gr_ps prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


/* Table A11, Columns 1-4 */
/* Growth rate of GDP */
reg sec_promotion rk_nol_gdp_gr_ps prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rk_nol_gdp_gr_ps prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rk_nol_gdp_gr_ps prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rk_nol_gdp_gr_ps prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);



/* Tables A10 & A12 Promotion of Government Executives upon Term Completion (Relative Ranking of Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Generate per-term measures */
collapse rel_nol_rev_gr rel_nol_gdp_gr gov_tty log_light log_pop2 rural_pop_pct rk_nol_rev_gr_ps rk_nol_gdp_gr_ps (max)  gov_promotion gov_position_next_year year (last) prov_gov_pw_cg_r_any gov_age ,by(prov governor);

/* Generate the squared term for politicians' age and total year in office */
gen gov_age2=gov_age^2;
gen gov_tty2=gov_tty^2;

/* Generate interaction terms for performance and political connection */
gen tax_connection=prov_gov_pw_cg_r_any*rk_nol_rev_gr_ps;
gen gdp_connection=prov_gov_pw_cg_r_any*rk_nol_gdp_gr_ps;

/* Delete right censoring: people do not have position change next year in 2007 */
drop if gov_position_next_year==0;
/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* Generate year dummies */
tab year, gen(yrdmy);

/* Table A10, Columns 1-4 */
/* Growth rate of Tax revenues */           
reg gov_promotion rk_nol_rev_gr_ps prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg gov_promotion rk_nol_rev_gr_ps prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rk_nol_rev_gr_ps prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rk_nol_rev_gr_ps prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


/* Table A12, Columns 1-4 */
/* Growth rate of GDP */
reg gov_promotion rk_nol_gdp_gr_ps prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rk_nol_gdp_gr_ps prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rk_nol_gdp_gr_ps prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rk_nol_gdp_gr_ps prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);



/* Tables A21 & A23  Promotion of Party Secretaries on Yearly Data (Relative Revenue/GDP Performance to Competitors) */
use CHN_Fiscal_Promtn_Data_Prov.dta, clear;

/* Generate the squared term for politicians' age and total year in office */

gen sec_age2=sec_age^2;
gen sec_tty2=sec_tty^2;

/* Delete left censoring: people have position change before 1999 */
drop if year<1999;

/* generate interaction terms */
gen tax_connection=prov_sec_pw_cg_r_any*rel_nol_rev_gr;
gen gdp_connection=prov_sec_pw_cg_r_any*rel_nol_gdp_gr;

/* Generate year dummies */
tab year, gen(yrdmy);


/* Table A21, Columns 1-4 */
/* Growth rate of Tax revenues */      
reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_rev_gr prov_sec_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


/* Table A23, Columns 1-4 */
/* Growth rate of GDP */
reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg sec_promotion rel_nol_gdp_gr prov_sec_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light sec_tty sec_tty2 sec_age sec_age2 yrdmy*, cluster(prov);


/* Tables A22 & A24  Promotion of Party Secretaries on Yearly Data (Relative Revenue/GDP Performance to Competitors) */

/* Generate the squared term for politicians' age and total year in office */
gen gov_age2=gov_age^2;
gen gov_tty2=gov_tty^2;

/* generate interaction terms */
drop tax_connection gdp_connection;
gen tax_connection=prov_gov_pw_cg_r_any*rel_nol_rev_gr;
gen gdp_connection=prov_gov_pw_cg_r_any*rel_nol_gdp_gr;


/* Table A22, Columns 1-4 */
/* Growth rate of Tax revenues */          
reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);
               
reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_rev_gr prov_gov_pw_cg_r_any tax_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


/* Table A24, Columns 1-4 */
/* Growth rate of GDP */
reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);


reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light yrdmy*, cluster(prov);

reg gov_promotion rel_nol_gdp_gr prov_gov_pw_cg_r_any gdp_connection log_pop2 rural_pop_pct log_light gov_tty gov_tty2 gov_age gov_age2 yrdmy*, cluster(prov);



log close;




