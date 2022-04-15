#########################################################################################
################## Brainteaser SQL Practise Questions ###################################
#########################################################################################
/*
Suppose we have the following schema with two tables: Ads and Events

Ads(ad_id, campaign_id, status)
status could be active or inactive
Events(event_id, ad_id, source, event_type, date, hour)
event_type could be impression, click, conversion
*/

 
--Write SQL queries to extract the following information:-

--1) The number of active ads.
SELECT count(1) FROM Ads WHERE status = 'active';

--2) All active campaigns. A campaign is active, if there’s at least one active ad.
SELECT DISTINCT a.campaign_id
FROM Ads AS a
WHERE a.status = 'active';

--3) The number of active campaigns.

SELECT COUNT(DISTINCT a.campaign_id)
FROM Ads AS a
WHERE a.status = 'active';

--4) The number of events per ad — broken down by event type.

SELECT a.ad_id, e.event_type, count(*) as "count"
FROM Ads AS a
  JOIN Events AS e
      ON a.ad_id = e.ad_id
GROUP BY a.ad_id, e.event_type
ORDER BY a.ad_id, "count" DESC;

--5) The number of events over the last week per each active ad — broken down by event type and date (most recent first).

SELECT a.ad_id, e.event_type, e.date, count(*) as "count"
FROM Ads AS a
  JOIN Events AS e
      ON a.ad_id = e.ad_id
WHERE a.status = 'active'
   AND e.date >= DATEADD(week, -1, GETDATE())
GROUP BY a.ad_id, e.event_type, e.date
ORDER BY e.date ASC, "count" DESC;

--6) The number of events per campaign — by event type.

SELECT a.campaign_id, e.event_type, count(*) as count
FROM Ads AS a
  INNER JOIN Events AS e
    ON a.ad_id = e.ad_id
GROUP BY a.campaign_id, e.event_type
ORDER BY a.campaign_id, "count" DESC

--7) The number of events over the last week per each campaign and event type — broken down by date (most recent first).

SELECT a.campaign_id, e.event_type, e.date, count(*)
FROM Ads AS a
  INNER JOIN Events AS e
    ON a.ad_id = e.ad_id
WHERE e.date >= DATEADD(week, -1, GETDATE())
GROUP BY a.campaign_id, e.event_type, e.date
ORDER BY a.campaign_id, e.date DESC, "count" DESC;

--8) CTR (click-through rate) for each ad. Note:- CTR = number of clicks / number of impressions.

SELECT impressions_clicks_table.ad_id,
       (impressions_clicks_table.clicks * 100 / impressions_clicks_table.impressions)::FLOAT || '%' AS CTR
FROM
  (
  SELECT a.ad_id,
         SUM(CASE e.event_type WHEN 'impression' THEN 1 ELSE 0 END) impressions,
         SUM(CASE e.event_type WHEN 'click' THEN 1 ELSE 0 END) clicks
  FROM Ads AS a
    INNER JOIN Events AS e
      ON a.ad_id = e.ad_id
  GROUP BY a.ad_id
  ) AS impressions_clicks_table
ORDER BY impressions_clicks_table.ad_id;

--9) CVR (conversion rate) for each ad. Note:- CVR = number of conversions / number of clicks.

SELECT conversions_clicks_table.ad_id,
       (conversions_clicks_table.conversions * 100 / conversions_clicks_table.clicks)::FLOAT || '%' AS CVR
FROM
  (
  SELECT a.ad_id,
         SUM(CASE e.event_type WHEN 'conversion' THEN 1 ELSE 0 END) conversions,
         SUM(CASE e.event_type WHEN 'click' THEN 1 ELSE 0 END) clicks
  FROM Ads AS a
    INNER JOIN Events AS e
      ON a.ad_id = e.ad_id
  GROUP BY a.ad_id
  ) AS conversions_clicks_table
ORDER BY conversions_clicks_table.ad_id;

--10) CTR and CVR for each ad broken down by day and hour (most recent first).

SELECT conversions_clicks_table.ad_id,
       conversions_clicks_table.date,
       conversions_clicks_table.hour,
       (impressions_clicks_table.clicks * 100 / impressions_clicks_table.impressions)::FLOAT || '%' AS CTR,
       (conversions_clicks_table.conversions * 100 / conversions_clicks_table.clicks)::FLOAT || '%' AS CVR
FROM
  (
  SELECT a.ad_id, e.date, e.hour,
         SUM(CASE e.event_type WHEN 'conversion' THEN 1 ELSE 0 END) conversions,
         SUM(CASE e.event_type WHEN 'click' THEN 1 ELSE 0 END) clicks,
         SUM(CASE e.event_type WHEN 'impression' THEN 1 ELSE 0 END) impressions
  FROM Ads AS a
    INNER JOIN Events AS e
      ON a.ad_id = e.ad_id
  GROUP BY a.ad_id, e.date, e.hour
  ) AS conversions_clicks_table
ORDER BY conversions_clicks_table.ad_id, conversions_clicks_table.date DESC, conversions_clicks_table.hour DESC, "CTR" DESC, "CVR" DESC;

11) CTR for each ad broken down by source and day

SELECT conversions_clicks_table.ad_id,
       conversions_clicks_table.date,
       conversions_clicks_table.source,
       (impressions_clicks_table.clicks * 100 / impressions_clicks_table.impressions)::FLOAT || '%' AS CTR
FROM
  (
  SELECT a.ad_id, e.date, e.source,
         SUM(CASE e.event_type WHEN 'click' THEN 1 ELSE 0 END) clicks,
         SUM(CASE e.event_type WHEN 'impression' THEN 1 ELSE 0 END) impressions
  FROM Ads AS a
    INNER JOIN Events AS e
      ON a.ad_id = e.ad_id
  GROUP BY a.ad_id, e.date, e.source
  ) AS conversions_clicks_table
ORDER BY conversions_clicks_table.ad_id, conversions_clicks_table.date DESC, conversions_clicks_table.source, "CTR" DESC;

#########################################################################################
################################ Telcom Data Analysis ###################################
#########################################################################################
/*
#####################################################################################
Usecase-1: Write an SQL query to get the browsage history of the telecom Prepaid or Postpaid mobile users. 
Group the into different categories for the period June-Dec 2021.
#####################################################################################
*/

########################### BROWSE USAGE CONTENT ####################################

select a.proceramsisdn,
sum(case when a.proceracontentcategorie like '%Abortion%' then 1 else 0 end) Abortion,sum(case when a.proceracontentcategorie like '%Advertising%' then 1 else 0 end) Advertising,
sum(case when a.proceracontentcategorie like '%Adware/Spyware%' then 1 else 0 end) Adware_Spyware,sum(case when a.proceracontentcategorie like '%Alcohol%' then 1 else 0 end) Alcohol,
sum(case when a.proceracontentcategorie like '%Anonymizer%' then 1 else 0 end) Anonymizer,sum(case when a.proceracontentcategorie like '%Art & Museums%' then 1 else 0 end) Art_Museums,
sum(case when a.proceracontentcategorie like '%Art Nudes%' then 1 else 0 end) Art_Nudes,sum(case when a.proceracontentcategorie like '%Automotive%' then 1 else 0 end) Automotive,
sum(case when a.proceracontentcategorie like '%Bikini%' then 1 else 0 end) Bikini,sum(case when a.proceracontentcategorie like '%Blog%' then 1 else 0 end) Blog,
sum(case when a.proceracontentcategorie like '%Business%' then 1 else 0 end) Business,sum(case when a.proceracontentcategorie like '%Chat%' then 1 else 0 end) Chat,
sum(case when a.proceracontentcategorie like '%Criminal Skills%' then 1 else 0 end) Criminal_Skills,sum(case when a.proceracontentcategorie like '%Cults%' then 1 else 0 end) Cults,
sum(case when a.proceracontentcategorie like '%Cyberbullying%' then 1 else 0 end) Cyberbullying,sum(case when a.proceracontentcategorie like '%Drugs%' then 1 else 0 end) Drugs,
sum(case when a.proceracontentcategorie like '%Education%' then 1 else 0 end) Education,sum(case when a.proceracontentcategorie like '%Energy%' then 1 else 0 end) Energy,
sum(case when a.proceracontentcategorie like '%Entertainment%' then 1 else 0 end) Entertainment,sum(case when a.proceracontentcategorie like '%File Sharing%' then 1 else 0 end) File_Sharing,
sum(case when a.proceracontentcategorie like '%Finance%' then 1 else 0 end) Finance,sum(case when a.proceracontentcategorie like '%Food & Restaurants%' then 1 else 0 end) Food_Restaurants,
sum(case when a.proceracontentcategorie like '%Forums & Message Boards%' then 1 else 0 end) Forums_Message_Boards,
sum(case when a.proceracontentcategorie like '%Freeware & Shareware%' then 1 else 0 end) Freeware_Shareware,sum(case when a.proceracontentcategorie like '%Gambling%' then 1 else 0 end) Gambling,
sum(case when a.proceracontentcategorie like '%Gaming%' then 1 else 0 end) Gaming,sum(case when a.proceracontentcategorie like '%Glamour%' then 1 else 0 end) Glamour,
sum(case when a.proceracontentcategorie like '%Gore%' then 1 else 0 end) Gore,sum(case when a.proceracontentcategorie like '%Government%' then 1 else 0 end) Government,
sum(case when a.proceracontentcategorie like '%Hacking%' then 1 else 0 end) Hacking,sum(case when a.proceracontentcategorie like '%Hate%' then 1 else 0 end) Hate,
sum(case when a.proceracontentcategorie like '%Health%' then 1 else 0 end) Health,sum(case when a.proceracontentcategorie like '%Hobbies%' then 1 else 0 end) Hobbies,
sum(case when a.proceracontentcategorie like '%Hosting%' then 1 else 0 end) Hosting,sum(case when a.proceracontentcategorie like '%Internet Telephony%' then 1 else 0 end) Internet_Telephony,
sum(case when a.proceracontentcategorie like '%Job Search%' then 1 else 0 end) Job_Search,sum(case when a.proceracontentcategorie like '%Kids%' then 1 else 0 end) Kids,
sum(case when a.proceracontentcategorie like '%Law%' then 1 else 0 end) Law,sum(case when a.proceracontentcategorie like '%Lingerie%' then 1 else 0 end) Lingerie,
sum(case when a.proceracontentcategorie like '%Malware%' then 1 else 0 end) Malware,sum(case when a.proceracontentcategorie like '%Mature Content%' then 1 else 0 end) Mature_Content,
sum(case when a.proceracontentcategorie like '%Military%' then 1 else 0 end) Military,sum(case when a.proceracontentcategorie like '%Music%' then 1 else 0 end) Music,
sum(case when a.proceracontentcategorie like '%News%' then 1 else 0 end) News,sum(case when a.proceracontentcategorie like '%Non-profit%' then 1 else 0 end) Non_profit,
sum(case when a.proceracontentcategorie like '%Nudism%' then 1 else 0 end) Nudism,sum(case when a.proceracontentcategorie like '%Occult%' then 1 else 0 end) Occult,
sum(case when a.proceracontentcategorie like '%Online Backup and File Sto%' then 1 else 0 end) Online_Backup_and_File_Sto,
sum(case when a.proceracontentcategorie like '%Personal Ads & Dating%' then 1 else 0 end) Personal_Ads_Dating,sum(case when a.proceracontentcategorie like '%Pets%' then 1 else 0 end) Pets,
sum(case when a.proceracontentcategorie like '%Photography%' then 1 else 0 end) Photography,sum(case when a.proceracontentcategorie like '%Plagiarism%' then 1 else 0 end) Plagiarism,
sum(case when a.proceracontentcategorie like '%Politics%' then 1 else 0 end) Politics,sum(case when a.proceracontentcategorie like '%Pornography%' then 1 else 0 end) Pornography,
sum(case when a.proceracontentcategorie like '%Portal%' then 1 else 0 end) Portal,sum(case when a.proceracontentcategorie like '%Real Estate%' then 1 else 0 end) Real_Estate,
sum(case when a.proceracontentcategorie like '%Reference%' then 1 else 0 end) Reference,sum(case when a.proceracontentcategorie like '%Religion%' then 1 else 0 end) Religion,
sum(case when a.proceracontentcategorie like '%Remote Access%' then 1 else 0 end) Remote_Access,sum(case when a.proceracontentcategorie like '%Science%' then 1 else 0 end) Science,
sum(case when a.proceracontentcategorie like '%Self Harm%' then 1 else 0 end) Self_Harm,sum(case when a.proceracontentcategorie like '%Sexual Advice%' then 1 else 0 end) Sexual_Advice,
sum(case when a.proceracontentcategorie like '%Shopping%' then 1 else 0 end) Shopping,sum(case when a.proceracontentcategorie like '%Sports%' then 1 else 0 end) Sports,
sum(case when a.proceracontentcategorie like '%Streaming Media%' then 1 else 0 end) Streaming_Media,sum(case when a.proceracontentcategorie like '%Suicide%' then 1 else 0 end) Suicide,
sum(case when a.proceracontentcategorie like '%Technology & Telecommunica%' then 1 else 0 end) Technology_Telecommunica,sum(case when a.proceracontentcategorie like '%Tobacco%' then 1 else 0 end) Tobacco,
sum(case when a.proceracontentcategorie like '%Travel%' then 1 else 0 end) Travel,sum(case when proceracontentcategorie like '%Violence%' then 1 else 0 end) Violence,
sum(case when a.proceracontentcategorie like '%Virtual Community/Social N%' then 1 else 0 end) Virtual_Community_Social_N,sum(case when a.proceracontentcategorie like '%Weapons%' then 1 else 0 end) Weapons,
sum(case when a.proceracontentcategorie like '%Webmail%' then 1 else 0 end) Webmail,sum(case when a.proceracontentcategorie like '%Wedding%' then 1 else 0 end) Wedding
from procera.tbl_mobile a
left join xxxx.dim_subscriber b on concat('0',substring(cast(a.proceramsisdn as string),3,11)) = b.msisdn
where a.ld_date between '2021-06-01' and '2021-12-31'
and a.proceramsisdn between 66000000000 and 66999999999 /**ProceraPART41**/ 
and b.cur_pp_code in ('R15NSBALL','R14NRFT02')
and b.subs_type = 'PREP' # 'POST'
group by a.proceramsisdn

/*
#####################################################################################
Usecase-2: Write an SQL query to get the AVERAGE REVENUE PER USER (ARPU) for the Prepaid or Postpaid Mobile users from their billing history 
for the period March 2021.
We calculate ARPU as sum of cur_rc_amt + discount_amt + cur_uc_amt + cur_oc_amt. 
The Average ARPU is calculated as ARPU for total number of active subscribers.
#####################################################################################
*/

################### AVERAGE REVENUE PER USER (ARPU) #########################

-----######## ARPU POSTPAID ##### -----------
--- # ARPU: AVERAGE REVENUE PER USER ##-----

select A.ban_num, 
(case when B.NUM_SUBS is not null then (A.ARPU/B.NUM_SUBS) else A.ARPU end) as avg_arpu 
from
(select ban_num, round(sum(nvl(cur_rc_amt,0) + nvl(discount_amt,0) + nvl(cur_uc_amt,0) + nvl(cur_oc_amt,0)),2) 
as ARPU
from xxxx.FCT_INVOICE t where cycle_mth in ('03') and cycle_year in ('2021')
group by ban_num) A
left join 
(select a.ban_num, count(a.msisdn) as num_subs
from xxxx.DIM_SUBSCRIBER a 
where (a.subs_deactv_tm_key_day is null or a.subs_deactv_tm_key_day > '20210330' )
and (a.subs_actv_tm_key_day <= '20210330')
and a.dwh_subs_status not in ('B') and a.subs_type in ('POST') 
group by a.ban_num) B
on (A.BAN_NUM=B.BAN_NUM)

/*
#####################################################################################
Usecase-3: Write an SQL query to get the information of customers that access the broadband competitors 
helpline number through calling to their call center & accessing competitors websites for the period of Mar - June 2021.
#####################################################################################
*/

--- ###########################################################################################################
--Customer that access the broadband competitor through calling to their call center   

-------- # final pl/sql ver # ----
select distinct msisdn,a_party,b_party,
count(distinct case when b_party = '01686' /*TOL*/ then day end) as Day_call_TOL,
count(distinct case when b_party = '01530' /*3BB*/ then day end) as Day_call_3BB,
count(distinct case when (b_party = '01100' or b_party = '01177') /*TOT*/then day end) as Day_call_TOT,
count(distinct case when b_party = '01185'/*AIS Fiber*/then day end) as Day_call_ais   
from xxxx.DAILY_EXTRACT 
where msisdn = a_party
and call_type_key = 1
and day between to_date('20210301','YYYYMMDD') and to_date('20210630','YYYYMMDD')
and length(msisdn) = 10
and b_party in ('01530','01100','01177','01185','01686') 
group by msisdn, a_party, b_party

-------- ##### final hadoop cluster ver ###### -------------
##--Customer that access the broadband competitor through calling to their call center   

select msisdn
,count(msisdn) as n_call_competitor   
from xxxx.daily_extract
where msisdn = a_party
and call_type_key = 1
and day >= '2021-03-01' and day <= '2021-06-30' 
and length(msisdn) = 10
and b_party in ('01530','01100','01177','01185') 
group by msisdn


------------------------------------------------------------------------------------------
##--Customers that access the broadband competitor's information by accessing their websites 
## -- final ver
------------------------------------------------------------------------------------------

select procerasubscriberidentifier
,count(proceraserverhostname) as n_competitor_website
from xxxx.tbl_broadband
where (proceraserverhostname like '%ais.co.th/fibre%' or proceraserverhostname like '%fibre.ais.co.th%'
or proceraserverhostname like '%tot.co.th%' or proceraserverhostname like '%3bb.co.th%')
and  ld_date >= '2021-03-01' and ld_date <= '2021-06-30'
group by procerasubscriberidentifier


----
/*
#####################################################################################
Usecase-4: Write an SQL query to calculate the avg. Quality of experience (QoE) estimator for the broadband users for the period Mar 2021.
#####################################################################################
*/

### -- final query -----
select procerasubscriberidentifier, 
proceraservice,
ld_date,
count(proceraservice), 
sum(octettotalcount), 
sum(proceraexternalrtt), 
sum(procerainternalrtt),  
round(avg((proceraqoeincomingexternal+proceraqoeincominginternal+proceraqoeoutgoingexternal+proceraqoeoutgoinginternal)/4),0) as avg_qoe
from xxxx.tbl_broadband
where ld_date >= '2021-03-01' and ld_date <= '2021-03-30' 
group by proceraservice,
 procerasubscriberidentifier,
 ld_date
-----------------------------------------------------------------------

------########################################### -----
--- from other alternative table
select telecircuit_num, round(sum(download_vol)/1000000000) as DL_GB, round(sum(upload_vol)/1000000000) as UL_GB 
from xxxx.TOL_TI_USAGE t
where stop_tm_key_day <=20210330
and stop_tm_key_day >=20210301
group by telecircuit_num

/*
#####################################################################################
Usecase-5: Write an SQL query to get the ACTIVE Mobile SUBSCRIBERS (Prepaid or Postpaid)
#####################################################################################
*/
################### ACTIVE CUSTOMERS #################################

/********* Query Mobile active Subscribers for Prepaid/Postpaid *****************/


select distinct a.msisdn, a.ban_num, a.subs_key, a.subs_type, a.subs_status, a.dwh_subs_status, cert_type, a.title, a.subscriber_name, a.gender, a.company_code, a.marital_status, a.birthdate, round(MONTHS_BETWEEN(SYSDATE,a.birthdate)/12,0) AS age,
a.cert_id, a.subs_actv_tm_key_day, a.subs_deactv_tm_key_day, ceil(months_between(to_date(20210630,'YYYYMMDD'),to_date(a.subs_actv_tm_key_day,'YYYYMMDD'))) as duration_months, 
a.cur_pp_code, d.pp_desc, c.bu_channel, c.tds_channel, c.dealer_code, c.dealer_name, c.province
 from xxxx.snap_DIM_SUBSCRIBER a left join xxxx.DIM_SUBS_ACTIVATION b
on a.msisdn = b.msisdn and a.ban_num = b.ban_num  left join xxxx.TDS_DEALER c on  b.dealer_actv_code = c.dealer_code
left join xxxx.DIM_PRICE_PLAN d on a.cur_pp_code=d.pp_code
where a.dwh_subs_status not in ('B') and a.subs_type in('PREP') and a.company_code in ('RM','RF') and a.subs_actv_tm_key_day is not null
and a.snapshot_tm_key_day = 20210630;



/********* Query Mobile active Subscribers for Prepaid/Postpaid *****************/


select distinct a.msisdn, a.ban_num, a.subs_key, a.subs_type, a.subs_status, a.dwh_subs_status, cert_type, a.title, a.subscriber_name, a.gender, a.company_code, a.marital_status, a.birthdate, round(MONTHS_BETWEEN(SYSDATE,a.birthdate)/12,0) AS age,
a.cert_id, a.subs_actv_tm_key_day, a.subs_deactv_tm_key_day, ceil(months_between(to_date(20210630,'YYYYMMDD'),to_date(a.subs_actv_tm_key_day,'YYYYMMDD'))) as duration_months, 
a.cur_pp_code, d.pp_desc, c.bu_channel, c.tds_channel, c.dealer_code, c.dealer_name, c.province, c.province_cluster, c.region
 from xxxx.snap_DIM_SUBSCRIBER a left join xxxx.DIM_SUBS_ACTIVATION b
on a.msisdn = b.msisdn and a.ban_num = b.ban_num  left join xxxx.TDS_DEALER c on  b.dealer_actv_code = c.dealer_code
left join xxxx.DIM_PRICE_PLAN d on a.cur_pp_code=d.pp_code
left join xxxx.DIM_STATUS e on a.cur_stat_key =  e.stat_key 
where a.dwh_subs_status in ('B') and a.subs_type in('PREP')  and a.company_code in ('RM','RF') and a.subs_actv_tm_key_day is not null
and (a.subs_deactv_tm_key_day between 20210601 and 20210630) and a.snapshot_tm_key_day = 20210630 and e.kpi_stat_group_desc in ('Voluntary','Involuntary');

/*
#####################################################################################
Usecase-6: Write an SQL query to get the records of Churned Customers,
Write a SQL query to get the Churned Customer Report with detailed information categorized into reason for churning
#####################################################################################
*/


##############  GET CHURN CUSTOMERS INFORMATION with Churn Reason #####################
select t.asset_num, t.ban_num, t.id_num, t.billing_name, t.order_tm_key_mth, t.order_tm_key_day, t.technology,
t.house_num, t.room, t.building, t.khwang, t.khet, t.province, t.zipcode, t.x_disc_reason_cd,
(case 
    when t.x_disc_reason_cd in ('A1','EA1','A16','EA16') then 'Save_Cost'
    when t.x_disc_reason_cd in ('A2','Network Event') then 'Bad Network'
    when t.x_disc_reason_cd in ('A3','A4','EA3','EA4') then 'Bad Service'
    when t.x_disc_reason_cd in ('EA5','A5') then 'Competitor'
    when t.x_disc_reason_cd in ('A8','F1','EA8')then 'Re-Location'
    when t.x_disc_reason_cd in ('E1')  then 'No need FL'
    when t.x_disc_reason_cd in ('A17') then  'No need FTTH' 
end ) as DISC_REASON
from xxxx.STG_TOL_ACTIVITY t
where t.connect_type = 'Disconnect' and 
(t.order_tm_key_mth like '%202012%' or
 t.order_tm_key_mth like '%202101%' or
 t.order_tm_key_mth like '%202102%' or
 t.order_tm_key_mth like '%202103%' or
 t.order_tm_key_mth like '%202104%' or
 t.order_tm_key_mth like '%202105%' or
 t.order_tm_key_mth like '%202106%' or
 t.order_tm_key_mth like '%202107%' or
 t.order_tm_key_mth like '%202108%' or
 t.order_tm_key_mth like '%202109%' or
 t.order_tm_key_mth like '%202110%') 
 and t.x_disc_reason_cd in ('A1','EA1','A16','EA16',
 'A2','Network Event','A3','A4','A3','A4','EA3','EA4',
 'EA5','A5','A8','F1','EA8',
 'E1','A17')                                                    
 and t.tp_type = 'Broadband' and t.churn_ind = 1 and t.technology <> '-99'             
 group by t.asset_num, t.ban_num, t.id_num, t.billing_name,t.order_tm_key_mth, t.order_tm_key_day, t.technology,
t.house_num, t.room, t.building, t.khwang, t.khet, t.province, t.zipcode, t.x_disc_reason_cd


---###### EVERY MONTH get BROADBAND CUSTOMERS ####### --------
select t.order_tm_key_mth,t.order_tm_key_day,
t.ban_num, t.asset_num, t.technology from xxxx.STG_TOL_ACTIVITY t
where t.connect_type = 'Disconnect' and 
(t.order_tm_key_mth like '%202106%')
and 
(t.x_disc_reason_cd like '%A1%' or
t.x_disc_reason_cd like '%A2%' or
t.x_disc_reason_cd like '%A3%' or
t.x_disc_reason_cd like '%A4%' or
t.x_disc_reason_cd like '%A5%' or
t.x_disc_reason_cd like '%A6%' or
t.x_disc_reason_cd like '%A7%' or
t.x_disc_reason_cd like '%A8%' ) 
and t.tp_type = 'Broadband'


--------##########################################################################
# Get total number of churned customers after the categorization
select count(1) from
(
select distinct t.asset_num, t.ban_num, 
t.id_num, t.billing_name, t.cust_name, t.order_tm_key_mth, t.order_tm_key_day, t.technology,
t.house_num, t.room, t.building, t.khwang, t.khet, t.province, t.zipcode, 
t.cust_house_num, t.cust_street, t.cust_district, t.cust_sub_district, t.cust_province, t.cust_zip_code,
t.x_disc_reason_cd, extract(month from t.verify_dt) as churn_mth, 
extract(year from t.verify_dt) as churn_year, t.verify_dt,t.customer_type, t.id_type, t.cust_business_unit, t.cust_segment, t.campaign, t.campaign_group, t.bundle, t.rc_price, 
t.promotion_code, t.first_promotion, t.promotion_desc, t.item_prod_name,
t.emp_num, t.fst_name, t.sale_dept,
t.partner_bu_sub_channel_2 as sale_channel,  
t.speed, t.speed_download, t.speed_upload,
t.item_start_date, t.item_end_date, t.installation_date, t.x_disconnect_date as Disconnect_Date,
round((TO_DATE((TO_char(t.x_disconnect_date,'DD/MM/YYYY')),'DD/MM/YYYY') - TO_date(t.installation_date,'DD/MM/YYYY'))/365)*12 as aos_mth,
t.rcu, t.cab, t.dp,
(case 
    when t.x_disc_reason_cd in ('A1','EA1','A16','EA16') then 'Save_Cost'
    when t.x_disc_reason_cd in ('A2','Network Event') then 'Bad Network'
    when t.x_disc_reason_cd in ('A3','A4','EA3','EA4') then 'Bad Service'
    when t.x_disc_reason_cd in ('EA5','A5') then 'Competitor'
    when t.x_disc_reason_cd in ('A8','F1','EA8')then 'Re-Location'
    when t.x_disc_reason_cd in ('E1')  then 'No need FL'
    when t.x_disc_reason_cd in ('A17') then  'No need FTTH' 
end ) as DISC_REASON
from xxxx.STG_TOL_ACTIVITY t
where t.connect_type = 'Disconnect' and 
extract(month from t.verify_dt) between 5 and 6
and extract(year from t.verify_dt) = 2021
 and t.x_disc_reason_cd in ('A1','EA1','A16','EA16',
 'A2','Network Event','A3','A4','A3','A4','EA3','EA4',
 'EA5','A5','A8','F1','EA8',
 'E1','A17')                                                        
 and t.tp_type = 'Broadband' and t.churn_ind = 1 and t.technology <> '-99'  
)

/*
#####################################################################################
Usecase-7: Write an SQL query to get the call quality information for the churned customers
#####################################################################################
*/

####################### drop call analysis ######################################

--- #### drop call analysis ####--------

--- ### count_dropcall, count_successcall  & count_totalcall #### ---

select a.msisdn as mobile_num, count(case when dropcall_ind = 0 then a.msisdn end) as count_successcall,
count(case when dropcall_ind > 0 then a.msisdn end) as count_dropcall,
sum(a.voice_outgoing_call+ a.voice_incoming_call) as count_totalcall
from xxxx.AGG_NW_AREA_USG_MTH a 
left join xxxx.DIM_SUBSCRIBER b on a.msisdn = b.msisdn and a.ban_num = b.ban_num
left join xxxx.dim_status c on b.cur_stat_key = c.stat_key
where
b.subs_type = 'POST'
AND c.kpi_stat_group_desc = 'Voluntary'  
--AND kpi_stat_group_desc = 'Involuntary'
AND b.dwh_subs_status in ('B')
AND b.subs_deactv_tm_key_day is not null
AND b.subs_deactv_tm_key_day like '202106%'
group by a.msisdn


---------------------------------------------------------------

select a.msisdn as mobile_num, count(case when dropcall_ind = 0 then a.msisdn end) as count_successcall,
count(case when dropcall_ind > 0 then a.msisdn end) as count_dropcall,
sum(a.voice_outgoing_call) as count_totalcall,
d.longitude, d.latitude
from xxxx.AGG_NW_AREA_USG_MTH a 
left join xxxx.DIM_SUBSCRIBER b on a.msisdn = b.msisdn and a.ban_num = b.ban_num
left join xxxx.dim_status c on b.cur_stat_key = c.stat_key
left join xxxx.DIM_CELLSITE_LOCATION d on d.lac_cell_key = substr(a.high_firstcgi,4,length(a.high_firstcgi)) 
where
b.subs_type = 'POST'
AND c.kpi_stat_group_desc = 'Voluntary'  
--AND kpi_stat_group_desc = 'Involuntary'
AND b.dwh_subs_status in ('B')
AND b.subs_deactv_tm_key_day is not null
AND b.subs_deactv_tm_key_day like '202106%'
group by a.msisdn, d.longitude, d.latitude
     
----------------------------------------------------------------

select d.longitude, d.latitude, count(case when dropcall_ind = 0 then a.msisdn end) as count_successtimes,
count(case when dropcall_ind > 0 then a.msisdn end) as count_droptimes,
sum(a.voice_outgoing_call+ a.voice_incoming_call) as count_totalcall
from xxxx.AGG_NW_AREA_USG_MTH a 
left join xxxx.DIM_SUBSCRIBER b on a.msisdn = b.msisdn and a.ban_num = b.ban_num
left join xxxx.dim_status c on b.cur_stat_key = c.stat_key
left join xxxx.DIM_CELLSITE_LOCATION d on d.lac_cell_key = substr(a.high_firstcgi,4,length(a.high_firstcgi)) 
where
b.subs_type = 'POST'
AND c.kpi_stat_group_desc = 'Voluntary'  
--AND kpi_stat_group_desc = 'Involuntary'
AND b.dwh_subs_status in ('B')
AND b.subs_deactv_tm_key_day is not null
AND b.subs_deactv_tm_key_day like '202106%'
group by d.longitude, d.latitude
#################################################################################


/*
#####################################################################################
Usecase-8: Write an SQL query to get usage history for the customers, most usage history of the customers based on state/region/district etc.
#####################################################################################
*/

############################### GET usage information ############################

select  B.call_st_tm_key_mth, B.imei, B.msisdn, B.ban_num, B.subs_type, B.company_code,
         round(sum(B.voice_outgoing_dur_sec)/60,2) as voice_outgoing_dur_mins_202106
       , round(sum(B.voice_incoming_dur_sec)/60,2) as voice_incoming_dur_mins_202106
       , sum(B.voice_outgoing_call) as voice_outgoing_call_202106
       , sum(B.voice_incoming_call) as voice_incoming_call_202106
       , sum(B.num_of_data_connect) as num_of_data_connect_202106
       , sum(B.num_of_sms_mo) as num_of_sms_mo_202106
       , sum(B.num_of_sms_mt) as num_of_sms_mt_202106
       , round(sum(B.upload_volume_kb)/1024,2) as upload_volume_mb_202106
       , round(sum(B.download_volume_kb)/1024,2) as download_volume_mb_202106
       , round(sum(B.upload_volume_kb + download_volume_kb)/1024,2) as data_usage_mb_202106
        from xxxx.agg_nw_area_usg_mth b 
where b.call_st_tm_key_mth in (202106) and b.company_code not in ('CAT3G') 
group by B.call_st_tm_key_mth, B.imei, B.msisdn, B.ban_num, B.subs_type, B.company_code

##################################################################################


################ most usage by state or province ##############################

select * from
(
select rank() over (partition by C.ban_num, C.msisdn order by (C.voice_outgoing_call + C.voice_incoming_call + C.num_of_data_connect) desc,
C.voice_outgoing_dur_mins, C.voice_incoming_dur_mins, C.voice_outgoing_call, C.voice_incoming_call, C.num_of_sms_mo,
C.num_of_sms_mt, C.num_of_data_connect, C.upload_volume_mb, C.download_volume_mb, C.data_usage_mb) rank, C.* from
(
select * from
(
select  B.msisdn, B.ban_num, B.sub_district_th, B.district_th, B.province_th, B.region_th, 
         round(sum(B.voice_outgoing_dur_sec)/60,2) as voice_outgoing_dur_mins
       , round(sum(B.voice_incoming_dur_sec)/60,2) as voice_incoming_dur_mins
       , sum(B.voice_outgoing_call) as voice_outgoing_call
       , sum(B.voice_incoming_call) as voice_incoming_call
       , sum(B.num_of_sms_mo) as num_of_sms_mo
       , sum(B.num_of_sms_mt) as num_of_sms_mt
       , sum(B.num_of_data_connect) as num_of_data_connect
       , round(sum(B.upload_volume_kb)/1024,2) as upload_volume_mb
       , round(sum(B.download_volume_kb)/1024,2) as download_volume_mb
       , round(sum(B.upload_volume_kb + download_volume_kb)/1024,2) as data_usage_mb
        from xxxx.agg_nw_area_usg_mth b 
where b.call_st_tm_key_mth in (202106) and b.company_code not in ('CAT3G') and length(msisdn) = 10 and b.province_th not in('-99')
group by B.msisdn, B.ban_num, B.sub_district_th, B.district_th, B.province_th, B.region_th ) 
) C
) D
where D.rank = 1


/*
#####################################################################################
Usecase-9: Write an SQL query to get the billing details of the subscribers. 
#####################################################################################
*/

###############################################################################


############# get invoice/billing details ###################################

/**************************** Query Invoice *********************************/


select A.ban_num, (case when B.NUM_SUBS is not null then (A.INVOICE_202106/B.NUM_SUBS) else A.INVOICE_202106 end) as invoice_202106 
from
(select ban_num, round(sum(nvl(cur_rc_amt,0) + nvl(discount_amt,0) + nvl(cur_uc_amt,0) + nvl(cur_oc_amt,0)),2) as invoice_202106  
from xxxx.FCT_INVOICE t where cycle_mth in ('6') and cycle_year in ('2021')
group by ban_num) A
left join 
(select a.ban_num, count(a.msisdn) as num_subs
from xxxx.SNAP_DIM_SUBSCRIBER a 
where a.dwh_subs_status not in ('B') and a.subs_type in ('POST') and a.snapshot_tm_key_day = 20210630
group by a.ban_num) B
on (A.BAN_NUM=B.BAN_NUM)

# oR

/****************************Query Invoice (Invoice_as of)*********************************/


select A.ban_num
       , (case when B.NUM_SUBS is not null then (A.INVOICE/B.NUM_SUBS) else A.INVOICE end) as invoice_202106
from(select ban_num
            , round(sum(nvl(cur_rc_amt,0) + nvl(discount_amt,0) + nvl(cur_uc_amt,0) + nvl(cur_oc_amt,0)),2) as invoice
     from xxxx.FCT_INVOICE t 
     where cycle_mth in ('06') 
           and cycle_year in ('2021')
     group by ban_num
     ) A
left join 
     (select a.ban_num
             , count(a.msisdn) as num_subs
      from xxxx.SNAP_DIM_SUBSCRIBER a 
      where a.dwh_subs_status not in ('B') 
            and a.subs_type in ('POST') 
            and a.snapshot_tm_key_day = 20210630
      group by a.ban_num
      ) B
on (A.BAN_NUM=B.BAN_NUM)


############################################################################################

/*
#####################################################################################
Usecase-10: Write an SQL query towards the following objectives  
            a)  Misbehavior analysis
            b) fault complaint analysis 
  along with their geographical history (latitude/longitude)
#####################################################################################
*/

############### MISBEHAVIOR ANALYSIS #####################################################

-----########### Misbehavior analysis #########-----------
--- #### without lat/long ####----

select distinct a.msisdn,a.b_party,
count(distinct case when b_party = '01175' /*AIS MOBILE*/ then day end) as CALL_AIS,
count(distinct case when b_party = '01678'/*DTAC */then day end) as CALL_DTAC   
from xxxx.DAILY_EXTRACT a
right join xxxx.DIM_SUBSCRIBER b
on  a.msisdn = b.msisdn
where (b.subs_deactv_tm_key_day is null or b.subs_deactv_tm_key_day > '20210630' )
and (b.subs_actv_tm_key_day <= '20210630')
and b.dwh_subs_status not in ('B') and b.company_code in ('RM','RF')  
and b.subs_type in ('POST') 
and a.msisdn = a_party
and a.call_type_key = 1
and day between to_date('20210601','YYYYMMDD') and to_date('20210630','YYYYMMDD')
and length(a.msisdn) = 10
and a.b_party in ('01175','01678') 
group by a.msisdn,a.b_party

----#### with latitude/longitude #####---
select distinct a.msisdn,
count(distinct case when b_party = '01175' /*AIS MOBILE*/ then day end) as CALL_AIS,
count(distinct case when b_party = '01678'/*DTAC */then day end) as CALL_DTAC, 
d.latitude,d.longitude
from xxxx.DAILY_EXTRACT a
left join xxxx.DIM_SUBSCRIBER b on  a.msisdn = b.msisdn
left join xxxx.AGG_NW_AREA_USG_MTH c on c.msisdn = b.msisdn
left join xxxx.DIM_CELLSITE_LOCATION d on d.lac_cell_key = substr(c.high_firstcgi,4,length(c.high_firstcgi))
where (b.subs_deactv_tm_key_day is null or b.subs_deactv_tm_key_day > '20210630' )
and (b.subs_actv_tm_key_day <= '20210630')
and b.dwh_subs_status not in ('B') and b.company_code in ('RM','RF')  
and b.subs_type in ('POST') 
and a.msisdn = a_party
and a.call_type_key = 1
and day between to_date('20210601','YYYYMMDD') and to_date('20210630','YYYYMMDD')
and length(a.msisdn) = 10
and a.b_party in ('01175','01678')
group by a.msisdn, d.latitude,d.longitude

----#### inclusion of Competitor BROADBAND call centre NUMBERS ######-------

select distinct a.msisdn,a.b_party,
count(distinct case when b_party = '01530' /*3BB*/ then day end) as Day_call_3BB,
count(distinct case when (b_party = '01100' or b_party = '01177') /*TOT*/then day end) as Day_call_TOT,
count(distinct case when b_party = '01185'/*AIS Fiber*/then day end) as Day_call_ais   
from xxxx.DAILY_EXTRACT a
right join xxxx.DIM_SUBSCRIBER b
on  a.msisdn = b.msisdn
where (b.subs_deactv_tm_key_day is null or b.subs_deactv_tm_key_day > '20210630' )
and (b.subs_actv_tm_key_day <= '20210630')
and b.dwh_subs_status not in ('B') and b.company_code in ('RM','RF')  
and b.subs_type in ('POST') 
and a.msisdn = a_party
and a.call_type_key = 1
and day between to_date('20210601','YYYYMMDD') and to_date('20210630','YYYYMMDD')
and length(a.msisdn) = 10
and a.b_party in ('01530','01100','01177','01185') 
group by a.msisdn,a.b_party

----##### 

select distinct a.msisdn,
count(distinct case when b_party = '01530' /*3BB*/ then day end) as Day_call_3BB,
count(distinct case when (b_party = '01100' or b_party = '01177') /*TOT*/then day end) as Day_call_TOT,
count(distinct case when b_party = '01185'/*AIS Fiber*/then day end) as Day_call_ais,   
d.latitude,d.longitude
from xxxx.DAILY_EXTRACT a
left join xxxx.DIM_SUBSCRIBER b on  a.msisdn = b.msisdn
left join xxxx.AGG_NW_AREA_USG_MTH c on c.msisdn = b.msisdn
left join xxxx.DIM_CELLSITE_LOCATION d on d.lac_cell_key = substr(c.high_firstcgi,4,length(c.high_firstcgi))
where (b.subs_deactv_tm_key_day is null or b.subs_deactv_tm_key_day > '20210630' )
and (b.subs_actv_tm_key_day <= '20210630')
and b.dwh_subs_status not in ('B') and b.company_code in ('RM','RF')  
and b.subs_type in ('POST') 
and a.msisdn = a_party
and a.call_type_key = 1
and day between to_date('20210601','YYYYMMDD') and to_date('20210630','YYYYMMDD')
and length(a.msisdn) = 10
and a.b_party in ('01530','01100','01177','01185')
group by a.msisdn, d.latitude,d.longitude


----##### with most last usage info #####--

select b.msisdn, a.latitude, a.longitude, a.province_en from xxxx.DIM_CELLSITE_LOCATION a
right join xxxx.ECM_MOST_LAST_USE_MTH b on a.lac_cell_key = substr(b.most_last_use_firstcgi,4,length(b.most_last_use_firstcgi))
where b.call_st_tm_key_mth like '202106'
group by b.msisdn, a.latitude, a.longitude, a.province_en

######################################################################


##################### fault complaint mapping ###########################

---##### for fault & complaint report mapping to lat,long ####-----

---#### PREPAID ####---

select a.msisdn as mobile_num,c.longitude, c.latitude
from xxxx.AGG_NW_AREA_USG_MTH a 
left join xxxx.DIM_SUBSCRIBER b on a.msisdn = b.msisdn and a.ban_num = b.ban_num
left join xxxx.DIM_CELLSITE_LOCATION c on c.lac_cell_key = substr(a.high_firstcgi,4,length(a.high_firstcgi)) 
where
b.subs_type = 'PREP'
AND b.dwh_subs_status not in ('B')
AND b.subs_deactv_tm_key_day is null
and a.call_st_tm_key_mth like '202106%'
and upper(c.status)='ACTIVATED'
group by a.msisdn, c.longitude, c.latitude


---#### POSTPAID ####---

select a.msisdn as mobile_num,c.longitude, c.latitude
from xxxx.AGG_NW_AREA_USG_MTH a 
left join xxxx.DIM_SUBSCRIBER b on a.msisdn = b.msisdn and a.ban_num = b.ban_num
left join xxxx.DIM_CELLSITE_LOCATION c on c.lac_cell_key = substr(a.high_firstcgi,4,length(a.high_firstcgi)) 
where
b.subs_type = 'POST'
AND b.dwh_subs_status not in ('B')
AND b.subs_deactv_tm_key_day is null
and a.call_st_tm_key_mth like '202106%'
and upper(c.status)='ACTIVATED'
group by a.msisdn, c.longitude, c.latitude

#########################################################################################
################################ Retail Store Data Analysis #############################
#########################################################################################

#how many customer has bought and how many never bought  
select
customer , 
flag_purchase , 
nb_items , 
case 
when nb_items = 0 then 'Never' 
when nb_items = 1 then 'Mono'  
else 'Multi' end as flag_mono_multi 
from ( 
  select 
  a.customer as customer,
  case when b.customer_b is not null then 'Buy' else 'Never_Buy' end as  flag_purchase, 
  coalesce(cast(nb_items as integer),0) as nb_items 
  from xxxx.dim_customer a 
  left join
  (
  SELECT customer as customer_b,
  count(*) as nb_items
  FROM xxxx.tr_product 
  group by 1 ) b  on a.customer = b.customer_b 
  limit 100 
) temp  ;


#most purchased item 
select
product , 
count(*) as nb_times
from xxxx.tr_product
group by 1
order by 2 desc 
