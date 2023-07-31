﻿--MSSV: 52100222 Fullname: Trương Thái Đan Huy
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
alter table Student
alter column Birthday date
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
('S01','Phước Trần','1990/02/24','IT'),
('S02','Timothy','2000/12/12','IT'),
('S03','Kaily','2001/10/01','ET'),
('S04','Tâm Nguyễn','1998/12/20','ET'),
('S05','Lee Nguyễn','1999/02/28','BT');
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
--Update-Delete querey
update Student
 set Birthday = '1999/02/20'
 where
	SID = 'S01';
select *from Student
update Results
set Score +=1
where
	Sid = 'S02' AND Cid = 'PM';
select *from Results
delete from Results
where
	Score <5;
select *from Results
--Alter table
--a
ALTER TABLE Student
add PhoneNumber int;
--b
alter table Student
alter column PhoneNumber varchar;
--c
alter table Student
add constraint df_PhoneNumber
default NULL for PhoneNumber;
select PhoneNumber from Student
--d
alter table Results
alter column Sid varchar(10) Not NULL;
alter table Results
alter column Cid varchar(10) Not NULL;
alter table Results
add primary key(Sid,Cid);
--e
alter table Results
add foreign key(Sid) references Student(Sid);
alter table Results
add foreign key(Cid) references Courses(Cid);
--f
alter table Results
add check (Score >=0 AND Score <=10);
alter table Courses
add constraint pk_Credit check (credit>=1 and credit<=12);
alter table Courses
add unique(Cname)
--g
alter table Student
drop column PhoneNumber;
--h
alter table Courses
drop  constraint  pk_Credit;