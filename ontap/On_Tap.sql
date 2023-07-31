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
										MONTH(ngayLap) in (1,2,3)

-- b) mua o QUANG_DIEN
select x.maXe, x.tenXe, x.maNSX, x.soLuong, x.donGia
from XeMay x
where x.maNSX in (select maNSX from NhaSanXuat 
				  where tenNSX = 'YAMAHA') 
and x.maXe in (select maXe from ChiTietHD ct, HoaDon h, KhachHang k 
			   where ct.soHD = h.soHD and h.maKH = k.SDT and diaChi = 'QUANG_DIEN')

-- c)  
select x.maXe, sum(soLuong) as so_luong from ChiTietHD x
group by x.maXe 
having sum(soLuong) >= ALL(select sum(soLuong) from ChiTietHD x inner join HoaDon d on x.soHD = d.soHD where year(ngayLap) = 2022 group by x.maXe)

--select top 1 maXe, sum(soLuong) as so_luong from ChiTietHD, HoaDon 
--where ChiTietHD.soHD = HoaDon.soHD and YEAR(ngayLap) =2022
--group by maXe order by SUM(soLuong) desc

--d) 
select x.* from XeMay x where maXe not in (select maXe from ChiTietHD)

--e)
select top 1 XeMay.maNSX, tenNSX , sum(ChiTietHD.soLuong) as so_luong from NhaSanXuat, XeMay, ChiTietHD 
where NhaSanXuat.maNSX = XeMay.maNSX and XeMay.maXe = ChiTietHD.maXe
and soHD in (select soHD from HoaDon where YEAR(ngaylap) = 2022) group by XeMay.maNSX, tenNSX
order by sum(ChiTietHD.soLuong) desc
--f)
select ChiTietHD.maXe, XeMay.tenXe, sum(ChiTietHD.soLuong) as so_luong, MONTH(ngaylap) as thang
from XeMay,ChiTietHD,HoaDon where XeMay.maXe = ChiTietHD.maXe and ChiTietHD.soHD = HoaDon.soHD
group by ChiTietHD.maXe, XeMay.tenXe, MONTH(ngaylap)

--function
--a)
create function auto_idhd()
returns varchar(15)
as
begin
	declare @id varchar(15)
	if(select count(soHD) from HoaDon) = 0
		set @ID = '0'
	else
		select @ID = MAX(right(soHD, 4)) from HoaDon
		select @ID = case
			when @ID = 99 then convert(varchar, getdate(), 112) + 'HD01'
			when @ID >= 0 and @ID < 9 then convert(varchar, getdate(), 112) + 'HD0' + convert(char, convert(int, @ID)+1)
			when @ID >= 9 then convert(varchar, getdate(), 112) + 'HD' + convert(char, convert(int, @ID)+1)
		end
	return @ID
end




