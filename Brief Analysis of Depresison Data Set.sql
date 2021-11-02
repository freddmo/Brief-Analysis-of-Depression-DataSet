--Status: On Progress.

create database Depression_DataSet;
use Depression_DataSet;
--Data arrange
UPDATE scores
		SET afftype = 0, inpatient = 0, marriage = 0, work = 0,
		madrs1 = 0, madrs2 = 0
		WHERE afftype = 'NA' or  inpatient = 'NA' or marriage = 'NA'
		or work = 'NA' or madrs1 = 'NA' or madrs2 = 'NA';

		DELETE FROM scores WHERE number like '%control%';

 --Data
			--Gender
						--	1. female 2. Male 
			--afftype 
						--	1: bipolar II - 2: unipolar depressive - 3: bipolar I
									
			--melanch 
						--	1: melancholia - 2: no melancholia
			--inpatient 
						--	1: inpatient - 2: outpatient
			--edu (education grouped in years)

			--marriage 
						--	1: married or cohabiting - 2: single
			--work 
						--	1: working or studying - 2: unemployed/sick leave/pension

			--madrs1 (MADRS score when measurement started)
						--	0 to 6 normal range "no depression"
						--	7 to 19 indicates “mild depression” 
						--	20 to 34 indicates “moderate depression”
						--	35 and greater indicates “severe depression,”
						--	60 or greater indicates “very severe depression."

			--madrs2 (MADRS when measurement stopped)
						--	0 to 6 normal range "no depression"
						--	7 to 19 indicates “mild depression” 
						--	20 to 34 indicates “moderate depression”
						--	35 and greater indicates “severe depression,”
						--	60 or greater indicates “very severe depression."

----Brief analysis of the brain activity in a day of a person with unipolar depression v.s. one with bipolar II depression----

	--Objective: analyze the brain activity for the two  types of participants during their days with most activity.
	--Purpose: I want to see and understand the reason for high activity in the days 

--Questions
--1. a) How many patients only have unipolar depressive
		select number from scores where number like '%condition%' and melanch = 2 ;
		select * from scores;
	 --b) How many patients only have bipolar II 
		select number from scores where number like '%condition%' and melanch = 1 ;

 --From all 23 participants I picked the n°1 

--2. What date it showed major activity?
	 --Answer: May 12, 2003
update Condition_1 
set  date = cast(timestamp as date);

select /*TOP 1*/  sum(activity) as ActivityPerDay, date as PerDay 
	from Condition_1 group by date order by ActivityPerDay desc
	;

--3. In that day, at what hour there was most activity?
	-- Answer: 5 pm
	 

select /*TOP 1 */ datepart(hour,timestamp) as HoursPerDay, 
		 sum(activity) as ActivityPerHour
from Condition_1 where date = '2003-05-12'
		group by datepart(hour,timestamp)
		order by ActivityPerHour desc
;

--Does the patient has: no depresion, mild depresion, moderate depretion, or severe depression?(Based on madrs)
  
 select LvlPerDepression_WhenStarted =
		case 	
			when madrs1 >= 0 and madrs1 < =6 then 'This person has no depression'
			when madrs1 > = 7 and madrs1 <=19 then 'This person has mild depression'
			when madrs1 > = 20 and madrs1 <=34 then 'This person has moderate depression'
		ELSE 'This person has severe depression'
		end 
from scores 
 where  number = 'condition_1'
  ;

  --The patient doesn´t have a job. Maybe that is the reason why during 8 am from 5 pm there is a higher activity 
  --because of a lack of purpose during the day. The lack of purpose of alterations in routines affects the mental 
  --health of an individual. Note: Is just an hypothesis, but there is not enough information.

  -- He has a companion or spouse. This detail can be a factor on why his brain activity 
  --during sleep is better than one person without a spouse.(further testing needs to be done) 


	--Analiysis of patient with bipolar II disorder 
	
		update Condition_20 
		set  date = cast(timestamp as date) ;
		select * from condition_20;

--What date it showed major activity?
	--Answer: May 28, 2002

		select top 1 sum(activity) as ActivityPerDay, date as PerDay 
		from Condition_20 group by date order by ActivityPerDay desc
		;

--In that day, at what hour there was most activity?
	-- Answer: 11 am 
	 

	select datepart(hour,timestamp) as HoursPerDay, 
			 sum(activity) as ActivityPerHour
	from Condition_20 where date = '2002-05-28'
			group by datepart(hour,timestamp)
			order by ActivityPerHour desc
	;

--Does the patient has: no depresion, mild depresion, moderate depretion, or severe depression?(Based on madrs)

select * from scores;
  
 select LvlPerDepression_WhenStarted =
		case 	
			when madrs1 >= 0 and madrs1 < =6 then 'This person has no depression'
			when madrs1 > = 7 and madrs1 <=19 then 'This person has mild depression'
			when madrs1 > = 20 and madrs1 <=34 then 'This person has moderate depression'
		ELSE 'This person has severe depression'
		end 
from scores 
 where  number = 'condition_20'
  ;

--Who has the major activity of both clients
	--nota: Patient 1 stayed less days than patient 20.


select sum(activity) as TotalActivity1 from Condition_1;
select sum(activity) as TotalActivity20 from Condition_20;