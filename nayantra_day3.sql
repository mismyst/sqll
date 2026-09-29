
-- activity 2 hands on part 2 --
select * from employees;
select * from DEPARTMENTS;
select * from REGIONS;
-- q1  Display the Emp_Id, Full name, Department, and Division for each employee --
select e.employee_id,(e.first_name || ' ' || e.last_name) as full_name,e.department,d.division from EMPLOYEES e inner join DEPARTMENTS d on e.DEPARTMENT = d.DEPARTMENT;
--q2  Display the Emp_Id, Full name, Department, Division, Region, and Country for each employee.  --
select e.employee_id,(e.first_name || ' ' || e.last_name) as full_name,e.department,r.region,r.COUNTRY from employees e 
inner join REGIONS r 
on e.REGION_ID = r.REGION_ID;
--q3 Display the Emp_Id, Full name, Department, and Division for all employees working in either 'Central 
-- Asia' or 'East Asia' --
select e.employee_id,(e.first_name || ' ' || e.last_name) as full_name,e.department,d.division from EMPLOYEES e inner join DEPARTMENTS d on e.DEPARTMENT = d.DEPARTMENT inner join REGIONS r on e.REGION_ID = r.REGION_ID where r.REGION in ('Central','East Asia');

--q4  Display last_name of employees working in 'Home' division along with their completed tenure.--
select e.last_name, FLOOR(months_between(SYSDATE,e.hire_date) / 12)as completed_tenure from EMPLOYEES e inner join DEPARTMENTS d on e.DEPARTMENT = d.DEPARTMENT where d.DIVISION = 'Home';

--q5  Display each department’s name, division, number of employees and average salary for all employees in 
-- that department. Round the salary to two decimal places if needed. Order the results in descending 
--order of salary. -- 
select d.department ,d.division , count(e.EMPLOYEE_ID) as number_of_employees,ROUND(AVG(e.SALARY)) AS average_salary from DEPARTMENTS d inner join EMPLOYEES e on d.DEPARTMENT = e.DEPARTMENT group by d.DEPARTMENT,d.DIVISION order by ROUND(AVG(e.SALARY))  desc;

-- Note : In select how many column u represent for grouping those many will come for example in above we wrote division too so in group by division , department shd be mentioned  

--q6 is same as day2 q7 --

--q7 Display names and division of those departments where total salary is greater than one tenth (1/10) of  the total salary of all employees. --

select d.division,d.department ,sum(e.salary) from DEPARTMENTS d inner join EMPLOYEES e on d.DEPARTMENT = e.DEPARTMENT group by d.DEPARTMENT,d.DIVISION 
having sum(e.salary) > (select sum(salary)/ 10  from EMPLOYEES  );

-- q8 Display Emp_Id, Full name, and salary of any employee whose division and region are same as any  employee hired in March 2015.
select e.employee_id,(e.first_name|| ' ' || e.last_name) as full_name,e.SALARY from EMPLOYEES e  inner join DEPARTMENTS d on e.department = d.DEPARTMENT inner join REGIONS r on e.region_id=r.REGION_ID 
where (d.DIVISION,r.region) in (select d.division,r.region from employees e  inner join DEPARTMENTS d on e.department = d.DEPARTMENT inner join REGIONS r on e.region_id=r.REGION_ID  WHERE e.hire_date >= DATE '2015-03-01'
      AND e.hire_date < DATE '2015-04-01');

-- q9 Display department name, division, and number of employees working in each of the following 
-- department(s)
-- 1. Department with maximum employees
-- 2.Department with minimum employees
-- 3.Department(s) with less than 30 employees


-- 1 . max and count and group by together as cte  we cannot instead we can create a cte with one aggreagate and compare it with subquery query as down 
--  max and count and group by together as cte because they wanted department wise max numbers 
with department_count as(
    select d.department,d.division,count(e.employee_id)as employee_count from DEPARTMENTS d  inner join EMPLOYEES e on d.DEPARTMENT = e.DEPARTMENT group by d.department,d.DIVISION 
)
select department,division,employee_count from department_count where employee_count = (select max(employee_count) from department_count);

--2. Min and count 
with department_count as(
    select d.department,d.division,count(e.employee_id)as employee_count from DEPARTMENTS d  inner join EMPLOYEES e on d.DEPARTMENT = e.DEPARTMENT group by d.department,d.DIVISION
)
select department,division,employee_count from department_count where employee_count = (select min(employee_count) from department_count);

-- 3. here max or min we need to compare it with greater or lesser 
with department_count as(
    select d.department,d.division,count(e.employee_id)as employee_count from DEPARTMENTS d  inner join EMPLOYEES e on d.DEPARTMENT = e.DEPARTMENT group by d.department,d.DIVISION
)
select department,division,employee_count from department_count where employee_count <30;

-- or --
select d.department,d.division,count(e.employee_id)as employee_count from DEPARTMENTS d  inner join EMPLOYEES e on d.DEPARTMENT = e.DEPARTMENT group by d.department,d.DIVISION having count(e.employee_id) <30;

-- Activty 2 part 3 (students) -- 
select * from STUDENTS;
-- q1 Write a query to display the name of those students that have the letters "ae" or "ph" in their name and are NOT 19 years old.
select student_name from students where student_name like '%ae%' or student_name like '%ph' and age !=19;

--q2    Write a query that displays the names and ages of the top 4 oldest students.
select student_name , age from  (select student_name ,age , rank() over(order by age desc)as r from students )where r<=4;

--q3 Write a query that returns students based on the given criteria.
-- "The student must not be older than age 20 if their student_no is either between 3 and 5 or their student_no is 7. Your query should also 
-- return students older than age 20 but in that case they must have a student_no that is at least 4."

-- Note there are 2 conditons all together to be followed (probability + where both needed case )
-- Student number is 3–5 or 7, and age is 20 or younger.
--Student is older than 20, but student number is at least 4.

select * from students 
where (

((student_no BETWEEN 3 AND 5 or student_no = 7)
 and age <=20) 

or 
(age>=20 and student_no=4)

);

-- on professors table --

select *  from professors ;
--q1 Write a SQL query against the professors table that would return the following result:
-- "It is false that professor Chong is highly paid"
--"It is true that professor Brown is highly paid"
--"It is false that professor Jones is highly paid"
--"It is true that professor Wilson is highly paid"
--"It is false that professor Miller is highly paid"
--"It is true that professor Williams is highly paid"
--NOTE: A professor is highly paid if they make greater than 95000
select 'It is ' || 
case when salary >95000 then 'true' else 'false' end || ' that professor ' || last_name || ' highly paid '
from professors;

-- activity on fruits table --
select * from fruit_imports;

-- q1 Write a query that returns the seasons that produce either 3 fruits or 4 fruits. --
with grouped_fruits as (
    select season ,count(*) as no_fruits_produced from fruit_imports group by season 
)
select season from grouped_fruits where no_fruits_produced in (3,4);

-- q2 Write a query that takes into consideration thesupplyandcost_per_unitcolumns for determining 
-- the total cost and returns the most expensive state with the total cost.

with cost_supply as (select name,(supply * cost_per_unit) as total_cost from fruit_imports)
select name from cost_supply where total_cost = (select max(total_cost)from cost_supply);

-- q3 Write a query that displays 3 columns. The query should display the fruit and its total supply along 
-- with a category of either LOW,ENOUGHorFULL.Lowcategory means that the total supply of the 
-- fruit is less than 20,000. The enough category means that the total supply is between 20,000 and 
-- 50,000. If the total supply is greater than 50,000 then that fruit falls in thefullcategory.
select name,supply as total_supply , 
case 
when supply <20000 then 'LOW'
when supply between 20000 and 50000 then 'ENOUGH'
ELSE 'GREATER' 
END AS category from fruit_imports;

-- activity on students table --
select * from student_enrollment ;
select * from courses;
-- q1 Write a SQL query that returns the names of those students who are taking Physics and US History courses. Use subqueries only
-- here there are multiple tbales connections we can use either joins or subqueries 

-- subqueries version 
select student_name from students where student_no in 
(select student_no from student_enrollment where course_no in 
(select course_no from courses where course_title = 'Physics' )
)
and 
student_no in (select student_no from student_enrollment where course_no in (select course_no from courses where course_title = 'US History'));

-- q2 Write a query that returns name of the student who is taking the highest number of courses. Use 
-- subqueries only.
select student_name from students where student_no in (select student_no,count(*) from student_enrollment where count(*) = (select max(count(*)) from student_enrollment) group by course_no) ;

-- a twist in this question and the above approach is we needed to return student name with most courses enrolled not with 
-- courses with most student prespective changes 
SELECT student_name
FROM students
WHERE student_no IN (
    SELECT student_no
    FROM student_enrollment
    GROUP BY student_no
    HAVING COUNT(*) = (
        SELECT MAX(course_count)
        FROM (
            SELECT COUNT(*) AS course_count
            FROM student_enrollment
            GROUP BY student_no
        )
    )
);

-- q3 Write a query that returns ALL the students as well as any courses they may or may not be taking.
select s.student_name,c.course_no from students s left join student_enrollment s1 on s.student_no = s1.student_no left join courses c on s1.course_no = c.course_no
order by c.course_no;

-- activity for using teach & professor -- 
select * from professors;
select * from teach;
-- q4 Write a query that displays the student's name, the courses the student is taking, and the professors that teach that course. Please note that each record in the output must be 
select s.student_name ,c.course_title,t.last_name  from students s left join student_enrollment s1 on s.student_no = s1.student_no left join courses c on s1.course_no = c.course_no left join teach t on c.course_no = t.course_no;

-- 
-- question on ddl activity 3 hand on --
-- filename: meeting-room-schema-employees1.sql
-- Code Generated by Sidekick is for learning and experimentation purposes only.

CREATE TABLE employees1 (
    employees_id VARCHAR2(10)
        CONSTRAINT pk_employees1 PRIMARY KEY,
    emp_name VARCHAR2(100) NOT NULL,
    contact_no VARCHAR2(20) NOT NULL
        CONSTRAINT uq_employees1_contact UNIQUE
);

CREATE TABLE reservations (
    booking_id VARCHAR2(10)
        CONSTRAINT pk_reservations PRIMARY KEY,
    employees_id VARCHAR2(10) NOT NULL,
    approval_receipt VARCHAR2(30),
    event_title VARCHAR2(150) NOT NULL,
    spocs VARCHAR2(150),
    start_date_time TIMESTAMP NOT NULL,
    accessories VARCHAR2(250),
    status VARCHAR2(15) NOT NULL,
    number_of_attendees NUMBER(4) NOT NULL,
    room_types VARCHAR2(50) NOT NULL,

    CONSTRAINT fk_reservations_employees1
        FOREIGN KEY (employees_id)
        REFERENCES employees1(employees_id),

    CONSTRAINT chk_reservation_status
        CHECK (status IN ('Confirmed', 'Canceled', 'Pending')),

    CONSTRAINT chk_attendees_positive
        CHECK (number_of_attendees > 0)
);
INSERT INTO employees1
    (employees_id, emp_name, contact_no)
VALUES
    ('E01', 'Alice Johnson', '555-1001');

INSERT INTO employees1
    (employees_id, emp_name, contact_no)
VALUES
    ('E02', 'Brian Smith', '555-1002');

INSERT INTO employees1
    (employees_id, emp_name, contact_no)
VALUES
    ('E03', 'Catherine Brown', '555-1003');

INSERT INTO employees1
    (employees_id, emp_name, contact_no)
VALUES
    ('E04', 'David Wilson', '555-1004');

INSERT INTO reservations
    (booking_id, employees_id, approval_receipt, event_title,
     spocs, start_date_time, accessories, status,
     number_of_attendees, room_types)
VALUES
    ('B001', 'E01', 'AR001', 'Project Kickoff',
     'Alice Johnson', TIMESTAMP '2026-11-03 09:00:00',
     'Projector, Whiteboard', 'Confirmed',
     12, 'Meeting Room A');

INSERT INTO reservations
    (booking_id, employees_id, approval_receipt, event_title,
     spocs, start_date_time, accessories, status,
     number_of_attendees, room_types)
VALUES
    ('B002', 'E01', 'AR002', 'Client Discussion',
     'Alice Johnson', TIMESTAMP '2026-11-10 14:00:00',
     'Projector', 'Canceled',
     8, 'Meeting Room B');

INSERT INTO reservations
    (booking_id, employees_id, approval_receipt, event_title,
     spocs, start_date_time, accessories, status,
     number_of_attendees, room_types)
VALUES
    ('B003', 'E01', 'AR003', 'Monthly Review',
     'Alice Johnson', TIMESTAMP '2026-12-05 10:00:00',
     'Whiteboard', 'Confirmed',
     10, 'Meeting Room A');

INSERT INTO reservations
    (booking_id, employees_id, approval_receipt, event_title,
     spocs, start_date_time, accessories, status,
     number_of_attendees, room_types)
VALUES
    ('B004', 'E02', 'AR004', 'Training Session',
     'Brian Smith', TIMESTAMP '2026-11-15 09:30:00',
     'Projector, Microphone', 'Confirmed',
     20, 'Conference Room');

INSERT INTO reservations
    (booking_id, employees_id, approval_receipt, event_title,
     spocs, start_date_time, accessories, status,
     number_of_attendees, room_types)
VALUES
    ('B005', 'E02', 'AR005', 'Team Meeting',
     'Brian Smith', TIMESTAMP '2026-11-20 13:00:00',
     'Whiteboard', 'Canceled',
     6, 'Meeting Room B');

INSERT INTO reservations
    (booking_id, employees_id, approval_receipt, event_title,
     spocs, start_date_time, accessories, status,
     number_of_attendees, room_types)
VALUES
    ('B006', 'E03', 'AR006', 'Planning Session',
     'Catherine Brown', TIMESTAMP '2026-11-25 11:00:00',
     'Projector', 'Confirmed',
     9, 'Meeting Room A');

COMMIT;

-- Using reservations table and employees1 tables -- 
select * from reservations;
select * from employees1;
-- q1 Write a query to display the reservation details of meeting room(s) booked with employee id 'E01'
select * from reservations r inner join employees1 e on r.employees_id = e.employees_id;

--q2 Write a query to display the total number of Confirmed and Canceled Reservations for the month of 'November'.
select status ,count(*) from reservations  where upper(to_char(start_date_time,'MON')) = 'NOV' group by status;
--q3 Write a query to display the count of reservations made by each employee.
select employees_id,count(booking_id) as reservation_count from reservations group by employees_id;

-- Activity 4 hands on part 1 -- 
-- q1 
with employee_sales as (
   select  e.emp_id,
    d.dep_id,sum(sales) as emp_sales from empsales e join department d on e.dep_id = d.dep_id group by d.dep_id
),
emp_arrange as (
select emp_id, row_number() over(partition by dep_id order by emp_sales desc) as employee_rank from employee_sales 
),
client_sales as (
    select c.client_id , d.dep_id , sum(sales) as cli_sales from empsales c join department d on c.dep_id = d.dep_id  group by d.dep_id 
),
client_arrange as (
    select client_id , row_number() over(partition by dep_id order by cli_sales desc)as client_rank from client_sales 
)
select c1.client_id ,e1.emp_id from client_arrange c1 join emp_arrange e1 on c1.dep_id = e1.dep_id where c1.client_rank = 1 and e1.employee_rank = 1;





-- activity 5 hands on -- 

select * from OLYMPIC;

-- q1 Which year saw the highest and lowest no of countries participating in Olympics?
with groups as (select year,count(DISTINCT team) as number_of_people  from OLYMPIC group by year),
ranked as (
select year,number_of_people , dense_rank() over(order by number_of_people  desc) as highest_rank,
dense_rank() over(order by number_of_people asc) as lowest_rank from groups )

select year ,number_of_people from ranked 
where highest_rank = 1  or lowest_rank = 1;

-- q2 Which nation has participated in all of the Olympic games?
-- means the number of distinct games grouped by nations shd be = to total no. of distinct games available ! 
select noc from OLYMPIC group by noc having  count(distinct games) =  (select count(distinct games) from Olympic );

-- q3  Identify the sport that was played in all summer Olympics.
-- first find the sports which has season and count(distinct year ) means how many years this sprots repeated shd be 
-- equal to how many year summer games has been held 
-- REMEMBER - the table is for atheletics so one of record has sport with a year thats enough becoz we have multiple sport with same year 
-- multiple time because same sport but more people will participate 

-- q4(mini) sport which have played only 1 time in summer  sports olympic 
select sport from olympic where season = 'Summer' group by sport having (count(  year)) = 1 ;
-- q4 (actual) •Which sports were played only once in the Olympics?
select sport from OLYMPIC group by sport having count( distinct games ) = 1 ;

-- q5 • Fetch the total no of sports played in each Olympic games.
select games ,count(distinct sport )as number_of_games from OLYMPIC group by games;
-- q6 • Fetch details of the oldest athletes to win a gold medal.
select name,age from OLYMPIC  where age = (select max(age) from OLYMPIC where medal='Gold');

-- q7 • Find the Ratio of male and female athletes who participated in all Olympic games.
with ctem as (select count(sex) as male_count,games from OLYMPIC where sex = 'M' group by games),
ctef as (select count(sex) as female_count,games from OLYMPIC where sex = 'F'  group by games )
select ((m.male_count/f.female_count)) from ctem m inner join ctef f on m.games = f.games;

--q8 • Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
-- first i needed each athletes with their no. of medals and group them by name because every athelete more medals can be 
-- Because one athlete can appear in multiple rows—different Games, events, or years—we group those rows by athlete and count only medal-winning records.
-- Then ranking them in using rank and their number 
-- Use select query to select the rank and order by desc 
with athletes_medals as (select  name , count(*) as count_of_medals from olympic where medal in('Gold','Silver','Bronze') group by name ),
ranked_athletes as (select name,count_of_medals, rank() over (order by count_of_medals) as ranks from athletes_medals)
select name, count_of_medals from ranked_athletes where ranks >=5 order by count_of_medals desc;

--q9• Fetch the top 5 most successful countries in Olympics. Success is defined by no of medals won.
with athletes_medals as (select  name,team , count(*) as count_of_medals from olympic where medal in('Gold','Silver','Bronze') group by name,team ),
ranked_athletes as (select team,name,count_of_medals, rank() over (order by count_of_medals) as ranks from athletes_medals)
select team,name, count_of_medals from ranked_athletes where ranks >=5 order by count_of_medals desc;

--q10 List down the total gold, silver, and bronze medals won by each country corresponding to each Olympic games.
with grouped_medals as (select medal,count(medal)as counted, team,games from OLYMPIC where medal in ('Gold','Silver','Bromze') group by medal ,team,games)
select team , count(*)as no_of_total from grouped_medals group by team;


--q11  Identify which country won the most gold, most silver, most bronze medals, and the most medals in each Olympic games

-- Create a aggregate cte with count of each medals per games(becoz per games differ rt ) 
with counted_medals as (
    select games , noc,
    sum (case when medal = 'Gold' then 1 Else 0 end ) as gold_count,
    sum(case when medal = 'Silver' then 1 Else 0 end ) as silver_count,
    sum(case when medal = 'Bronze' then 1 Else 0 end)as bronze_count,
    sum(CASE WHEN medal IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE 0 END) AS total_count
    from OLYMPIC 
    where medal in ('Gold','Silver','Bronze')
    group by games ,noc  
), 
ranked_medals as (
    select games , noc,gold_count,silver_count,bronze_count,
    dense_rank()over(partition by games order by gold_count desc) as ranked_gold,
    dense_rank()over(partition by games order by silver_count desc)as ranked_silver,
    dense_rank()over (partition by games order by bronze_count desc) as ranked_bronze
    from counted_medals 
) -- here partition by games becoz we needed games wise thats y we grouped from the start 
select games,
max(case when ranked_gold = 1 then noc end ) as most_gold_country ,
max(gold_count) as gold_counted,
max(case when ranked_silver = 1 then noc end ) as most_silver_country,
max(silver_count) as silver_counted, 
max(case when ranked_bronze =1 then noc end ) as most_bronze_country
from ranked_medals 
group by games
order by games;


-- q12 •Which countries have never won gold medal but have won silver/bronze medals?
with counted_medals as (
    select games , noc,
    sum (case when medal = 'Gold' then 1 Else 0 end ) as gold_count,
    sum(case when medal = 'Silver' then 1 Else 0 end ) as silver_count,
    sum(case when medal = 'Bronze' then 1 Else 0 end)as bronze_count,
    sum(CASE WHEN medal IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE 0 END) AS total_count
    from OLYMPIC 
    where medal in ('Gold','Silver','Bronze')
    group by games ,noc  
)
select games , noc as country from counted_medals where gold_count = 0 and (silver_count != 0 or bronze_count != 0);

-- Remember after finding the count we just needed to use and , where logics to retreive the countrys with particular conditions 

-- q13• In which Sport/event, India has won highest medals.
with india_medals as (
select sport , count(*) as total_medals 
from olympic where noc = 'IND' and medal in ('Gold','Silver','Bronze')
group by sport
),
ranked_medals as (
select sport , rank()over(order by total_medals) as ranked_med from india_medals 
)
select sport , ranked_med from ranked_medals where ranked_med = 1 ;

-- asked baseline 
-- select to_char(enrolment_date ,'MM-YYYY') 
-- FROM students
-- group by to_char(enrolment_date ,'MM-YYYY')
-- where is_active = 'Y' 
-- having count(*) >2;
