/* ========================================================================
 * Program: Chinese Patent Medicine Preliminary Analysis.do
 * Data:	USP 2152
 * Aim:     处方情况分析
 * output:  July_week5_2152.dta in working data
 * Revised: 7/14/2021
 * ======================================================================= */

clear
clear matrix
set more off, perm


global root = "/Users/chenzhifei/Documents/Grad23Summer/USP"
global dofiles = "$root/Dofiles"
global logfiles = "$root/Logfiles"
global raw_data = "$root/Raw_data"
global working_data = "$root/Working_data"
global temp_data = "$root/Temp_data"
global tables = "$root/Tables"
global figures = "$root/Figures"


**************************** 1 处方情况汇总 ****************************

**************************** 1.1 访问2153应答分布情况 ****************************
import excel "$raw_data/全库stata-yh0818.xlsx", sheet("Sheet1") cellrange(A1:AM2201) firstrow

rename RecordID record_id

order record_id province case institution_type management_type drug visit_CPM visit_Combination diagnosis

destring institution_type, replace

save "$working_data/2200_8.18.dta", replace

eststo taba1 : estpost tabulate province
	
eststo taba2 : estpost tabulate case


tab  province diagnosis

tab case diagnosis

tab institution_type diagnosis

**************************** 1.2 处方数 *****************************

use "$working_data/2200_8.18.dta", clear

keep if drug==1

tab diagnosis drug


****************************1.3 中成药处方数 *****************************

use "$working_data/2200_8.18.dta", clear

keep if visit_CPM==1

tab diagnosis visit_CPM

	
*************************1.4 中成药联用处方数***************************

use "$working_data/2200_8.18.dta", clear

keep if visit_Combination == 1 

tab diagnosis visit_Combination

**************************** 1.3 chi-square test ****************************	
use "$working_data/2200_8.18.dta", clear
keep if drug==1

tab province visit_CPM, chi
tab case visit_CPM, chi
tab institution_type visit_CPM, chi
tab management_type visit_CPM, chi	


	
**************************** 1.4 chi-square test ****************************	
use "$working_data/2200_8.18.dta", clear

keep if visit_Combination != 9 

tab province visit_Combination, chi
tab case visit_Combination, chi
tab institution_type visit_Combination, chi
tab management_type visit_Combination, chi


*************************chi-square test**************************
import excel "$raw_data/病例基药使用情况stata-yh0818.xlsx", firstrow clear

tab province drug_basic, chi

tab case drug_basic, chi

tab institution_type drug_basic, chi

tab management_type drug_basic, chi

***************************

tab province drug_insurance, chi

tab case drug_insurance, chi

tab institution_type drug_insurance, chi

tab management_type drug_insurance, chi  

****************************************************
import excel "$raw_data/中成药用药合理性评价-stata_0818.xlsx", sheet("点评") cellrange(A1:X1905) firstrow clear

tab diagnosis
tab diagnosis drug_evaluation

tab 适应症是否合理
tab 用量是否合理
tab 是否存在重复用药否1是0 
tab 遴选药物是否合理 
tab 联合用药是否合理 
tab 是否存在配伍禁忌否1是0

tab province drug_evaluation
tab case drug_evaluation
tab institution_type drug_evaluation
tab management_type drug_evaluation


****************************************************
drop if drug_evaluation == 9

bysort diagnosis: tab province drug_evaluation
bysort diagnosis: tab case drug_evaluation
bysort diagnosis: tab institution_type drug_evaluation
bysort diagnosis: tab management_type drug_evaluation

import excel "$raw_data/病例基药使用情况stata-yh0818.xlsx", firstrow clear
bysort diagnosis: tab province drug_basic
bysort diagnosis: tab case drug_basic
bysort diagnosis: tab institution_type drug_basic
bysort diagnosis: tab management_type drug_basic

bysort diagnosis: tab province drug_insurance
bysort diagnosis: tab case drug_insurance
bysort diagnosis: tab institution_type drug_insurance
bysort diagnosis: tab management_type drug_insurance


