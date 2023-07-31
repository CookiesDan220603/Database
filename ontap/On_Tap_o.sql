use master

if exists(select * from sysdatabases where name = 'On_tap')
	drop database On_tap
	go

create database On_tap
go

use On_tap

---- CREATE TABLE ----

if exists(select * from sysobjects where name = 'NhaSanXuat')
	drop table NhaSanXuat
	go

create table NhaSanXuat
(
	maNSX varchar(30),
	tenNSX nvarchar(30),
	primary key (maNSX)
)

if exists(select * from sysobjects where name = 'XeMay')
	drop table XeMay
	go

create table XeMay
(
	maXe varchar(30),
	tenXe nvarchar(30),
	maNSX varchar(30),
	soLuong int,
	donGia int,
	primary key(maXe),
	foreign key(maNSX) references NhaSanXuat(maNSX)
)

if exists(select * from sysobjects where name = 'KhachHang')
	drop table KhachHang
	go

create table KhachHang
(
	SDT varchar(30),
	ten nvarchar(30),
	diaChi nvarchar(30),
	primary key (SDT)
)

if exists(select * from sysobjects where name = 'HoaDon')
	drop table HoaDon
	go

create table HoaDon
(
	soHD varchar(30),
	ngayLap date,
	maKH varchar(30),
	primary key (soHD),
	foreign key(maKH) references KhachHang(SDT)
)

if exists(select * from sysobjects where name = 'ChiTietHD')
	drop table ChiTietHD
	go

create table ChiTietHD
(
	soHD varchar(30),
	maXe varchar(30),
	soLuong int,
	donGia int,
	primary key (soHD,maXe)
)

---- INSERT----

-- NhaSanXuat --
insert into NhaSanXuat values('N01','HONDA')
insert into NhaSanXuat values('N02','YAMAHA')
insert into NhaSanXuat values('N03','WAVE')
insert into NhaSanXuat values('N04','SH')


-- XeMay --
insert into XeMay values('X01','HONDA_01','N01',11,150)
insert into XeMay values('X02','YAMAHA_02','N02',12,250)
insert into XeMay values('X03','WAVE_03','N03',13,350)
insert into XeMay values('X04','SH','N04',14,450)


-- KhachHang --
insert into KhachHang values('0812453139','TRUNG','BINH_HOA')
insert into KhachHang values('0123456789','CUONG','QUANG_DIEN')
insert into KhachHang values('0987654321','HIEU','BUON_TRAP')

-- HoaDon --
insert into HoaDon values('HD01', '2022/03/23','0812453139')
insert into HoaDon values('HD02', '2022/05/02','0123456789')
insert into HoaDon values('HD03', '2022/05/19','0123456789')

-- ChiTietHD --
insert into ChiTietHD values('HD01','X01',11,150)
insert into ChiTietHD values('HD02','X02',12,250)
insert into ChiTietHD values('HD03','X03',13,350)


---- YEU CAU ----

-- TRUY VAN --
-- a) DC: Binh Hoa - mua quy 1 2022
select k.* from KhachHang k, HoaDon h where k.SDT = h.maKH and
										diaChi like 'BINH_HOA' and 
										DATEPART(QUARTER,h.ngayLap) =1

-- b) mua o QUANG_DIEN
select x.maXe, x.tenXe, x.maNSX, x.soLuong, x.donGia
from XeMay x
where x.maNSX in (select maNSX from NhaSanXuat 
				  where tenNSX = 'YAMAHA') 
and x.maXe in (select maXe from ChiTietHD ct, HoaDon h, KhachHang k 
			   where ct.soHD = h.soHD and h.maKH = k.SDT and diaChi = 'QUANG_DIEN')

-- c) 
--select XeMay.* from XeMay, ChiTietHD where XeMay.maXe = ChiTietHD.maXe and soLuong 
--select x.maXe from ChiTietHD x
--group by x.maXe 
--having sum(soLuong) >= ALL(select sum(soLuong) from (XeMay x inner join ChiTietHD ct on x.maXe =ct.maXe)
--inner join HoaDon d on ct.soHD = d.soHD where year(ngayLap) = 2022 group by x.maXe)

select top 1 maXe, sum(soLuong) as so_luong from ChiTietHD, HoaDon 
where ChiTietHD.soHD = HoaDon.soHD and YEAR(ngayLap) =2022
group by maXe order by SUM(soLuong) desc

--d) 
select x.* from XeMay x where maXe not in (select maXe from ChiTietHD)

--e)
CREATE FUNCTION AUTO_IDHD()
RETURNS VARCHAR(14)
AS
BEGIN
	DECLARE @ID VARCHAR(14)
	IF (SELECT COUNT(HoaDon.soHD) FROM HoaDon) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(soHD, 3)) FROM HoaDon
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN CONVERT(varchar,GETDATE()) + 'HD000' + CONVERT(varchar,CONVERT(int,@ID)+1)
			WHEN @ID >= 9 and @ID<99 THEN CONVERT(varchar,GETDATE()) + 'HD00' + CONVERT(varchar,CONVERT(int,@ID)+1)
			WHEN @ID >= 99 and @ID<999 THEN CONVERT(varchar,GETDATE()) + 'HD0' + CONVERT(varchar,CONVERT(int,@ID)+1)
			WHEN @ID >=999 and @ID<9999 then CONVERT(varchar,GETDATE()) + 'HD' + CONVERT(varchar,convert(int,@ID)+1)
		END
	RETURN @ID
END
drop function AUTO_IDHD
go
declare @a varchar(14)
set @a = dbo.AUTO_IDHD()
print(@a)

