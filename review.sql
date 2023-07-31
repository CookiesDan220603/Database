--MSSV: 52100222 Fullname: Trương Thái Đan Huy
use master
go
if exists (SELECT name FROM sys.databases where name = 'QLXM')
	drop database QLXM
go
create database QLXM
go
use QLXM
go
create table NhaSanXUat
(
	NSX_ID varchar(10) primary key,
	NSX_name nvarchar(30) not null,
)
create table XeMay(
	MaXe varchar(10) primary key,
	TenXe nvarchar(20) not null,
	NSX_ID varchar(10) not null,
	SoLuong int, DonGia int,
	check (SoLuong > 0),
	check (DonGia > 0),
	constraint NSX_FK foreign key (NSX_ID) references NhaSanXUat(NSX_ID)
)
create table KhachHang(
	MaKH varchar(12) primary key,
	HoTen nvarchar(30) not null,
	DiaChi nvarchar(20),
	constraint check_DC check(DiaChi = 'TPHCM' or DiaChi = 'Đồng Nai' or DiaChi ='Long An'
			or DiaChi = 'Tây Ninh'),
)
create table HoaDon(
	SoHD varchar(10) primary key,
	NgayLap smalldatetime default getdate(),
	MaKH varchar(12),
	constraint MaKH_FK foreign key (MaKH) references KhachHang(MaKH)
)
create table Detail(
	SoHD varchar(10),
	MaXe varchar(10),
	primary key (SoHD,MaXe),
	constraint SoHD_FK foreign key (SoHD) references HoaDon(SoHD),
	constraint MaXe_FK foreign key (MaXe) references XeMay(MaXe)

)

alter table NhaSanXuat
	add  QuocGia nvarchar(20);
go
alter table NhaSanXuat
add constraint QuocGia_PK check (QuocGia ='Nhật' or QuocGia = 'Hàn' or Quocgia ='Mỹ' or QuocGia='Đức');
go
alter table HoaDon
add NgayGiaoHang smalldatetime;
go
alter table HoaDon
add constraint NgayGiaohang_Pk check (NgayGiaoHang >= NgayLap);
go

alter table HoaDon
 drop constraint MaKH_PK;
go
alter table HoaDon
alter column MaKH int;
go
alter table KhachHang
alter column MaKH int;
go
 insert into NhaSanXUat
 values
 ('NSX01','nHuy','Hàn'),
 ('NSX02','nTường','Mỹ'),
 ('NSX03','nKitty','Đức');
 go
 insert into XeMay
 values
 ('XE01','YMH01','NSX01',10,2311),
 ('XE02','HD01','NSX02',15,2000),
 ('XE03','SZK01','NSX01',18,3000);
 insert into KhachHang
 values
 ('0939726000','Trương Thái Đan Huy','Long An'),
 ('0939726001','Nguyễn Cát Tường','Đồng Nai'),
 ('0193213462','Nguyễn Kitty','TPHCM');
 go
 insert into HoaDon(SoHD,MaKH,NgayLap)
 values
 ('Huy0001','0939726001','2022/10/5'),
 ('SHD01','0939726000','2022/11/4'),
 ('Huy00003','0193213462','2002/12/4');
 insert into Detail
 values 
 ('Huy0001','XE01'),
 ('SHD01','XE02'),
 ('Huy00003','XE03');
 select * from NhaSanXUat
 select * from XeMay;
 select * from KhachHang;
 select * from HoaDon;
 select * from Detail;
 update XeMay
 set SoLuong = SoLuong + 10
 where TenXe = 'YMH01'
 select * from XeMay;
 go
 update KhachHang
 set DiaChi = 'TPHCM'
 where MaKH = '0193213462'
 go
 update XeMay
 set DonGia = DonGia + 10000
 where TenXe = 'HD01'
 go
 update XeMay
 set DonGia = 20000
 where DonGia > 20000
 go
delete from KhachHang
 where MaKH in (select KhachHang.MaKH from KhachHang,HoaDon
				where YEAR(GETDATE())-YEAR(HoaDon.NgayLap)>10)
go
delete from HoaDon
where YEAR(NgayLap) > 2010
go
delete from XeMay
where SoLuong = 0
go
