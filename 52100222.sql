--MSSV: 52100222 Fullname: Trương Thái Đan Huy
use master
go
if exists (SELECT name FROM sys.databases where name = 'QLSV')
	drop database QLSV
go
create database QLSV
go
use QLSV
go
create table Department
(
	Did varchar(10),
	Dname nvarchar(30),
	Dyear int,
	primary key(Did)
)
create table Student
(
	Sid varchar(10),
	Sname nvarchar(30),
	Birthday smalldatetime,
	primary key(Sid),
	Did varchar(10),
	foreign key(Did) references Department(Did)
)
create table Courses
(
	Cid varchar(10),
	Cname nvarchar(30),
	Credit int,
	Did varchar(10),
	primary key(Cid),
	foreign key(Did) references Department(Did)

)
create table Condition
(
	Cid varchar(10),
	PreCid varchar (10),
	primary key(Cid,PreCid),
	foreign key (Cid) references Courses(Cid),
	foreign key (PreCid) references Courses(Cid)
)
create table Results
(
	Sid varchar(10),
	Cid varchar(10),
	Score float
	--primary key(Sid,Cid),
	--foreign key (Sid) references Student(Sid),
	--foreign key(Cid) references Courses(Cid)
)
insert into Department (Did,Dname,Dyear)
Values 
('IT','Information Technology',2012),
('ET','Electronic Technology',1997),
('BT','Biotechnology',1997),
('FL','Foreign language',2000),
('CT','Chemical Technology',2011);
insert into Student
Values
('S01',N'Phước Trần','1990/02/24','IT'),
('S02',N'Timothy','2000/12/12','IT'),
('S03',N'Kaily','2001/10/01','ET'),
('S04',N'Tâm Nguyễn','1998/12/20','ET'),
('S05',N'Lee Nguyễn','1999/02/28','BT');
insert into Courses
Values
('OOP','Object oriented Programming',4,'IT'),
('PM','Programming method',4,'IT'),
('DBS','Database system',4,'IT'),
('SE','Software engineering',4,'IT'),
('CN','Computer network',3,'IT');


insert into Condition
values
('OOP','PM'),
('DBS','PM'),
('DBS','OOP'),
('SE','OOP'),
('SE','DBS');
insert into Results
values 
('S01','PM',9.5),
('S01','OOP',10),
('S02','PM',4.5),
('S02','DBS',6),
('S03','DBS',8);
select * from Department
select *from Student
select *from Courses
select *from Condition
select *from Results


--Ex1
Select Did from Department
	where Department.Did not in (select Student.Did from Student
									inner join Department
									on Department.Did = Student.Did)
--Ex2
select distinct Department.Did from Department,Courses
	where Department.Did not in (select Courses.Did from Courses)
--Ex3
select Courses.Cid from Courses
	where Courses.Cid not in(select Results.Cid from Results)
--Ex4
select distinct Student.Sid from Student
	where Student.Sid not in (select Results.Sid from Results)
--Ex5

select Student.Sid,Student.Sname,AVG(Results.Score)as TB from Student
	inner join Results
		on Results.Sid = Student.Sid
			group by Student.Sid,Student.Sname
			having AVG(Results.Score) < 5
--Ex6
select  Student.Sid,Student.Sname,AVG(Results.Score)as TB from Student
	inner join Results
		on Results.Sid = Student.Sid
			group by Student.Sid,Student.Sname
			having AVG(Results.Score) = (select MAX(average) from (
																	select Student.Sid,Student.Sname,AVG(Results.Score)as average from Student
																		inner join Results
																			on Results.Sid = Student.Sid
																				group by Student.Sid,Student.Sname) as abc)
--EX7
Select  Courses.Cid,COUNT(Results.Cid) as N from Courses
	inner join Results
		on Results.Cid = Courses.Cid
		group by Courses.Cid
		having COUNT(Results.Cid) = (select Max(rs) from(
														Select  Courses.Cid,COUNT(Results.Cid) as rs from Courses
															inner join Results
																on Results.Cid = Courses.Cid
																group by Courses.Cid) as abc)
		
--Ex8
Select Courses.Cid,COUNT(Results.Cid) as N from Courses
	inner join Results
		on Results.Cid = Courses.Cid
		group by Courses.Cid
		having COUNT(*) <5
--EX9
Select Courses.Cid,COUNT(Results.Cid) as N from Courses
	inner join Results
		on Results.Cid = Courses.Cid
		group by Courses.Cid
		having COUNT(*)  >= 2
--EX10
select Department.Did,AVG(Results.Score) as TB from Department
inner join Courses
	on Department.Did = Courses.Did
inner join Results
	on Results.Cid = Courses.Cid
	
	group by Department.Did
	having AVG(Results.Score) = (select MAX(TB) from (
															select Department.Did,AVG(Results.Score) as TB from Department
																inner join Courses
																	on Department.Did = Courses.Did
																inner join Results
																	on Results.Cid = Courses.Cid
	
																	group by Department.Did )as abc)

--EX11
update Results
set Score = Score + 1
where Results.Sid in (select Student.Sid from Student
						inner join Department
						on Department.Did = Student.Did
						group by Student.Sid)
go
--EX12
update Results
set Score = 10
where Score > 10
go
select * from Results

--Ex13
select Student.Sid, Student.Sname, Student.Birthday, AVG(Results.Score) as DIEMTB from Student
inner join Results
on Results.Sid = Student.Sid
group by Student.Sid, Student.Sname, Student.Birthday
order by DIEMTB desc, Student.Birthday asc

--Ex14

--Ex15

--Ex16

