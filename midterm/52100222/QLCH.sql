USE master
go
if exists (select name from sys.databases where name = 'QLCH')
	drop database QLCH
go
create database QLCH
go
use QLCH
go

create table NCC(
	MA_NCC varchar(10) primary key,
	SDT varchar(15),
	DIACHI varchar(30),
	KHUVUC varchar(20),
	GHICHU varchar(30)
)
go
CREATE FUNCTION AUTO_IDNV()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MA_NV) FROM NHANVIEN) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MA_NV, 3)) FROM NHANVIEN
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'NV00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'NV0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
go
Create table NHANVIEN(
	MA_NV varchar(10) primary key constraint IDNV default DBO.AUTO_IDNV() ,
	SDT varchar(15),
	DIACHI varchar(30),
	GIOITINH int,
	constraint check_GIOITINH check (GIOITINH = 1 or GIOITINH = 0),
	TEN_NV nvarchar(30)
)
go
Create table THANNHAN(
	TEN_TN nvarchar(30),
	SDT varchar(15),
	DIACHI varchar(30),
	QUANHE varchar(20),
	MA_NV varchar(10),
	constraint FK_THANNHAN foreign key (MA_NV) references NHANVIEN(MA_NV)
)
go
create table HANGHOA(
	MA_HANGHOA varchar(10) primary key,
	TEN_HANG nvarchar(30),
	DV_TINH varchar(10),
	GIA int check(GIA > 0),
	XUATXU varchar(30)
)
go
create table HANGTUOISONG(
	MA_HANGHOA varchar(10) foreign key (MA_HANGHOA) references HANGHOA(MA_HANGHOA),
	CANNANG float,
	TG_BAOQUAN varchar(10),
)
go
create table HANGCHEBIEN(
	MA_HANGHOA varchar(10) foreign key (MA_HANGHOA) references HANGHOA(MA_HANGHOA),
	HANSUDUNG varchar(10),
	CACHCHEBIEN nvarchar(50),
	CACHBAOQUAN nvarchar(50),
)
go
create table HDNHAP(
	MA_HDNHAP varchar(10) primary key,
	TRANGTHAI int,
	constraint check_TT check (TRANGTHAI =1 or TRANGTHAI = 0),
	NGAYLAP smalldatetime,
	MA_NCC varchar(10),
	MA_NV varchar(10),
	constraint FK_MANV foreign key (MA_NV) references NHANVIEN(MA_NV),
	constraint FK_MANCC foreign key (MA_NCC) references NCC(MA_NCC)
)
go
create table ChiTietHoaDonNhap(
	ID_NHAP varchar(10) primary key,
	SOLUONG int,
	DONGIA int,
	MA_HDNHAP varchar(10) foreign key (MA_HDNHAP) references HDNHAP(MA_HDNHAP),
	MA_HANGHOA varchar(10) foreign key (MA_HANGHOA) references HANGHOA(MA_HANGHOA)
)
go
create table KHO(
	ID_KHO varchar(10) primary key,
	SOLUONG int,
	MA_HANGHOA varchar(10) foreign key (MA_HANGHOA) references HANGHOA(MA_HANGHOA)
)
go
CREATE FUNCTION AUTO_IDKH()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MA_KH) FROM KHACHHANG) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MA_KH, 3)) FROM KHACHHANG
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'KH00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'KH0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
go
create table KHACHHANG(
	MA_KH varchar(10) primary key constraint IDKH default DBO.AUTO_IDKH(),
	SDT varchar(15),
	TEN_KH varchar(30),
	DIACHI varchar(30)
)
go
create table HDXUAT(
	MA_HDXUAT varchar(10) primary key,
	TRANGTHAI int,
	constraint check_TT_xuat check (TRANGTHAI =1 or TRANGTHAI = 0),
	NGAYLAP smalldatetime,
	MA_NV varchar(10) foreign key (MA_NV) references NHANVIEN(MA_NV),
	MA_KH varchar(10) foreign key (MA_KH) references KHACHHANG(MA_KH)
)
go
create table ChiTietHoaDonXuat(
	SOLUONG int,
	MA_HANGHOA varchar(10) foreign key (MA_HANGHOA) references HANGHOA(MA_HANGHOA),
	MA_HDXUAT varchar(10) foreign key (MA_HDXUAT) references HDXUAT(MA_HDXUAT),
	DONGIA int
)
go
create proc ADDNHANVIEN
	@SDT varchar(15),
	@DIACHI varchar(30),
	@GIOITINH int,
	@TEN_NV varchar(30)
as
	insert into NHANVIEN(SDT,DIACHI,GIOITINH,TEN_NV) values(@SDT,@DIACHI,@GIOITINH,@TEN_NV)
go
create proc ADDKHACHHANG
	@SDT varchar(15),
	@TEN varchar(30),
	@DIACHI varchar(30)
as
	insert into KHACHHANG(SDT,TEN_KH,DIACHI) values(@SDT,@TEN,@DIACHI)
go

CREATE TRIGGER trg_NhapHang ON ChiTietHoaDonNhap AFTER INSERT AS 
BEGIN
	UPDATE KHO
	SET SOLUONG = KHO.SOLUONG + (
		SELECT SOLUONG
		FROM inserted
		WHERE MA_HANGHOA = KHO.MA_HANGHOA
	)
	FROM KHO
	JOIN inserted ON KHO.MA_HANGHOA = inserted.MA_HANGHOA
END
GO
/* cập nhật hàng trong kho sau khi đặt hàng hoặc cập nhật */
CREATE TRIGGER trg_DatHang ON ChiTietHoaDonXuat AFTER INSERT AS 
BEGIN
	UPDATE KHO
	SET SOLUONG = KHO.SOLUONG - (
		SELECT SOLUONG
		FROM inserted
		WHERE MA_HANGHOA = KHO.MA_HANGHOA
	)
	FROM KHO
	JOIN inserted ON KHO.MA_HANGHOA = inserted.MA_HANGHOA
END
GO
/* cập nhật hàng trong kho sau khi cập nhật đặt hàng */
CREATE TRIGGER trg_CapNhatDatHang on ChiTietHoaDonXuat after update AS
BEGIN
   UPDATE KHO SET SOLUONG = KHO.SOLUONG -
	   (SELECT SOLUONG FROM inserted WHERE MA_HANGHOA = KHO.MA_HANGHOA) +
	   (SELECT SOLUONG FROM deleted WHERE MA_HANGHOA = KHO.MA_HANGHOA)
   FROM KHO
   JOIN deleted ON KHO.MA_HANGHOA = deleted.MA_HANGHOA
end
GO
/* cập nhật hàng trong kho sau khi hủy đặt hàng */
create TRIGGER trg_HuyDatHang ON ChiTietHoaDonXuat FOR DELETE AS 
BEGIN
	UPDATE KHO
	SET SOLUONG = KHO.SOLUONG + (SELECT SOLUONG FROM deleted WHERE MA_HANGHOA = KHO.MA_HANGHOA)
	FROM KHO 
	JOIN deleted ON KHO.MA_HANGHOA = deleted.MA_HANGHOA
END
go
exec ADDKHACHHANG '909111056','ME DAN HUY','CAO LANH DONG THAP'
exec ADDKHACHHANG '915725805','BA DAN HUY','CAO LANH DONG THAP'
exec ADDKHACHHANG '939726205','DAN HUY','HCM'
exec ADDNHANVIEN '0939726205','60/56 LVB',1,'Truong Thai Dan Huy'
exec ADDNHANVIEN '0939777111','60/78/4',0,'Nguyen Cat Tuong'
exec ADDNHANVIEN '0903572602','1150 HTP',1,'Pham Phuc Xuyen'
insert into NCC values 
('N001','0939111xxx','LVB HCM','HCM','anh nay vip'),
('N002','0939222xxx','NLB HCM','HCM','anh nay cung vip luon'),
('N003','0939333xxx','CL Dong Thap','Dong Thap','anh nay la developer');
go
insert into THANNHAN values
('Tanh Tu','0903227504','Q8','Chong Phuc Xuyen','NV003'),
('Cat Tuong','0907777125','Q7','Vo Dan Huy','NV001')
insert into HANGHOA values
('HH001','Rau muong','Bo','5000','Nong Trai'),					
('HH002','Carot','Kg','10000','Nong Trai'),						
('HH003','Thit ba roi ','Kg','30000','Nong Trai'),
('HH004','Hat Nem','Goi','5000','Sieu Thi'),						
('HH005','Mi Goi','Goi','4000','Sieu Thi')					
insert into HANGTUOISONG values
('HH001','10','5 ngay'),					
('HH002','10','1 tuan'),						
('HH003','20','2 tuan')									
insert into HANGCHEBIEN values
('HH004','6 Thang','Dung ngay','kho rao'),						
('HH005','6 thang','Dung Ngay','kho rao')					
insert into HDNHAP values
('HD001','0','5/1/2022','N001','NV001'),					
('HD002','0','6/2/2022','N002','NV002'),					
('HD003','1','7/3/2022','N003','NV003'),						
('HD004','1','8/4/2022','N001','NV001'),					
('HD005','1','9/5/2022','N002','NV002')	
insert into KHO values
('KHO001',0,'HH001'),
('KHO002',10,'HH002'),
('KHO003',2,'HH003'),
('KHO004',4,'HH004'),
('KHO005',5,'HH005')
insert into ChiTietHoaDonNhap values
('IDN001',20,10000,'HD001','HH001')
insert into HDXUAT values
('IDX001',1,'6/22/2022','NV003','KH001')
insert into ChiTietHoaDonXuat values
(2,'HH002','IDX001',5000)

select * from NCC
select * from NHANVIEN
select * from THANNHAN
select * from HDNHAP
select * from ChiTietHoaDonNhap
select * from HANGHOA
select * from HANGTUOISONG
select * from HANGCHEBIEN
select * from KHO
select * from HDXUAT
select * from ChiTietHoaDonXuat
select * from KHACHHANG