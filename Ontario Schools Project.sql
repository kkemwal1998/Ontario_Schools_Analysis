
--Ontario Schools Analysis
---------------------------------------------------------------------------
--Platform:PostgreSQl
--------------------------------------------------------------------------
--Table Creation:
----------------------------------------------------------------------------
--School Details table:
Create Table School_Details
(SchoolID int primary key,
SchoolName varchar(100),
OSSD_Credits_Offered varchar(100),
PrincipalName varchar(100),
SchoolWebsite varchar(200),
SchoolLevel varchar(200),
School_Special_Conditions_Code varchar(100),
ProgramType varchar(100),
Association_Membership varchar(100)
); 
 
--Geographical Detail Table:
Create Table Geographic_details
(School_Number int primary key,
 SchoolID int references School_Details(SchoolID),
 Suite int,
 PO_Box int,
 Street_Address varchar(300),
 City varchar(50), 
 Province varchar(10),
 Postal_Code varchar(100),
 Region varchar(50),
 School_Website varchar(300)

--Queries: 
-------------------------------------------------------------------------------------------------------------------------------------
---Query-1 : Find the school names with no condition code of  in eastern region.
select sd.schoolname as School_Name, sd.school_special_conditions_code as Condition_Code,GD.region as Region
from school_details sd 
INNER JOIN 
geographic_details GD
on sd.schoolid = GD.schoolid
where GD.region = 'East Region' and sd.school_special_conditions_code = 'Not applicable'
order by sd.schoolname;
--Insights: There are over 205 schools in the eastern region with no special condition code applicable.
 
---Query-2 : Calculate the count of OSSD credits for schools in each city and ranking them accordingly.
Select GD.city as City, count(sd.ossd_credits_offered) as Credits_Count 
from 
geographic_details GD
INNER JOIN
school_details sd
on sd.schoolid = GD.schoolid
group by GD.city
order by Credits_Count desc;
--Insights: Toronto has got the maximum number of schools with OSSD credits. 
 
---Query-3: Counting the number of elementary, secondary and Elem/Sec. schools within each city in Ontario.
select GD.city as City, 
sum(case when sd.schoollevel = 'Secondary' then 1 else 0 end) as Secondary_Schools,
sum(case when sd.schoollevel = 'Elementary' then 1 else 0 end) as Elementary_Schools,
sum(case when sd.schoollevel = 'Elem/Sec' then 1 else 0 end) as Elem_Secs
from 
school_details sd
inner join
geographic_details GD
on sd.schoolid = GD.schoolid
group by GD.city
order by GD.city;
--Insights: Toronto has got the maximum number of secondary schools, elementary and elem/sec schools. 
 
-------Query-4: The name of principals and the number of schools they headed.
Select S.principalname as Principal_Name, count( distinct SD.schoolid) as SchoolCount 
from 
school_details S
inner Join
school_details SD
on S.principalname = SD.principalname
group by Principal_Name
order by SchoolCount desc;
--Insights:Hassan Mirzai has headed maximum number of schools in Ontario as a principal.  
  
--------Query 5: Extracting the count of duplicate school websites.
Select schoolwebsite, count(schoolwebsite) 
from 
school_details 
group by schoolwebsite
having count(schoolwebsite) > 1
order by count(schoolwebsite) DESC;
--Insights: "www.atlastforestschools.com" has been duplicated multiple times.

—--------Query 6: Top-3 cities with average number of schools without association membership. 
select gd.city as City, avg(gd.schoolid) as Average from 
geographic_details gd inner join school_details S
on gd.schoolid = S.schoolid
where
S.association_membership != 'No'
group by gd.city
order by 
Average desc
limit 3;
--Insights: Woodstock has got the maximum average number of schools without association membership.
