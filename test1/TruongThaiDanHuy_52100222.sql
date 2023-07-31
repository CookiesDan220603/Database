use master
go
if exists (select name from sys.databases where name = 'QLSV_Test')
	drop database QLSV_Test
go
create database QLSV_Test
go
use QLSV_Test
go
create table DMKHOA
(
	MAKHOA varchar(10),
	TENKHOA nvarchar(30),
	constraint MAKHOA_PK primary key (MAKHOA)
)
go
create table DMSV
(
	MASV varchar(10),
	HOSV nvarchar(30),
	TENSV nvarchar(20),
	PHAI int,
	NGAYSINH smalldatetime,
	NOISINH nvarchar(30),
	MAKHOA varchar(10),
	HOCBONG int,
	constraint MSV_PK primary key (MASV),
	constraint MAKHOA_FK foreign key (MAKHOA) references DMKHOA(MAKHOA)
)
go
create table DMMH
(
	MAMH varchar(10),
	TENMH nvarchar(40),
	SOTIET int
	constraint MAMH_PK primary key (MAMH)
)
go
create table KETQUA
(
	MASV varchar(10) ,
	MAMH varchar(10),
	LANTHI int,
	DIEM float,
	constraint PK primary key (MASV,MAMH,LANTHI),
	constraint MASV_FK foreign key (MASV) references DMSV(MASV),
	constraint MAMH_FK foreign key (MAMH) references DMMH(MAMH)
)
go
insert into DMKHOA(MAKHOA,TENKHOA)
values
	('AV',N'Anh Văn'),
	('TH',N'Tin Học'),
	('TR',N'Triết'),
	('VL',N'Vật Lý');
go
set DATEFORMAT dmy
go
insert into DMSV(MASV,HOSV,TENSV,PHAI,NGAYSINH,NOISINH,MAKHOA,HOCBONG)
values
	('A01',N'Nguyễn Thị',N'Hải',1,'23/02/1993',N'Hà Nội','TH',130000),
	('A02',N'Nguyễn Văn',N'Chính',0,'24/12/1992',N'Bình Định','VL',150000),
	('A03',N'Lê Thu Bạch',N'Yến',1,'21/02/1993',N'Tp HCM','TH',170000),
	('A04',N'Trần Anh',N'Tuấn',0,'20/12/1994',N'Hà Nội','AV',80000),
	('B01',N'Trần Thanh',N'Mai',1,'12/08/1993',N'Hải Phòng','TR',0),
	('B02',N'Trần Thị Thu',N'Thủy',1,'02/01/1994',N'Tp HCM','AV',0)
go
insert into DMMH(MAMH,TENMH,SOTIET)
values
	('01',N'Cơ sở dữ liệu',45),
	('02',N'Trí tuệ nhân tạo',45),
	('03',N'Truyền tin',45),
	('04',N'Đồ họa',60),
	('05',N'Văn Phạm',60),
	('06',N'Kỹ thuật lập trình',45);
go
insert into KETQUA(MASV,MAMH,LANTHI,DIEM)
values
	('A01','01',1,3),
	('A01','01',2,6),
	('A01','02',2,6),
	('A01','03',1,5),
	('A02','01',1,4.5),
	('A02','01',2,7),
	('A02','03',1,10),
	('A02','05',1,9),
	('A03','01',1,2),
	('A03','01',2,5),
	('A03','03',1,2.5),
	('A03','03',2,4),
	('A04','05',2,10),
	('B01','01',1,7),
	('B01','03',1,2.5),
	('B01','03',2,5),
	('B02','02',1,6),
	('B02','04',1,10);
go
select * from DMKHOA
select * from DMSV
select * from DMMH
select * from KETQUA
--QUERY
--1
select * from DMSV,DMKHOA
	where DMSV.MAKHOA = DMKHOA.MAKHOA and DMKHOA.TENKHOA = N'Tin học'
--2
select MASV,HOSV,TENSV,PHAI,NGAYSINH from DMSV
	order by PHAI desc
--3
Select DMSV.MASV, DMSV.HOSV,DMSV.TENSV, YEAR(DMSV.NGAYSINH) as N'Năm Sinh' from DMSV
where YEAR(getdate()) - YEAR(NGAYSINH) <18 or (YEAR(getdate()) - YEAR(NGAYSINH) = 18 and MONTH(GETDATE())-MONTH(NGAYSINH)<0)or
		(YEAR(getdate()) - YEAR(NGAYSINH) = 18 and MONTH(GETDATE())-MONTH(NGAYSINH)>=0 and DAY(GETDATE())-DAY(NGAYSINH)<0)

--4
select * from DMSV,DMKHOA
where DMSV.MAKHOA = DMKHOA.MAKHOA 
and DMSV.MAKHOA = 'TH'
and DMSV.MASV NOT IN (select KETQUA.MASV from KETQUA,DMMH
						where KETQUA.MAMH = DMMH.MAMH and TENMH = N'Cơ sở dữ liệu')
--5
select DMSV.MASV,HOSV,TENSV,PHAI,NGAYSINH,NOISINH,MAKHOA from DMSV,KETQUA
where KETQUA.MASV = DMSV.MASV
and MAMH = '01' and DIEM <5 
and KETQUA.MASV in (select MASV from (select MASV,COUNT(LANTHI) as SOLANTHI from KETQUA
									where MAMH = '01'
									group by MASV
									having COUNT(*)=1) as abc)

--6
select DMSV.HOSV,DMSV.TENSV,KETQUA.MAMH,KETQUA.LANTHI,KETQUA.DIEM,'Kết quả' = 
case 
	when DIEM < 5 then N'Rớt'
	when DIEM >=5 then N'Đậu'
end from DMSV,KETQUA where DMSV.MASV=KETQUA.MASV
--7
select DMSV.NOISINH from DMSV
	group by NOISINH
	having COUNT(NOISINH)>=2
--8
select DMSV.MASV,HOSV,TENSV from DMSV
where MASV in (select MASV from (select MASV,COUNT(LANTHI) as SOLANTHI from KETQUA
									where LANTHI =1 and DIEM <5
									group by MASV
									having COUNT(*)>1) as abc)
--9
select DMSV.MASV,HOSV,TENSV from DMSV,KETQUA
where DMSV.MASV = KETQUA.MASV and MAMH ='05' and MAKHOA = 'AV' and LANTHI = 1
and KETQUA.MASV in (select MASV from KETQUA
					where DIEM = ( select MIN(DIEM) from KETQUA,DMSV
					where DMSV.MASV = KETQUA.MASV and MAKHOA ='AV') )
--10
select DMSV.MASV,HOSV,TENSV from DMSV
where HOCBONG > (select max(HOCBONG) from DMSV
				where MAKHOA ='AV')
--11
select DMSV.MASV,HOSV,TENSV from DMSV
where MAKHOA ='AV' and MASV not in (select MASV from KETQUA
									where MAMH='05')
--12
Select COUNT(DMSV.MaSV) as NumberOfStudent, DMSV.MAKHOA from DMSV
	Group by DMSV.MAKHOA
--B
--B Funtion
-- 1. Với 1 mã sinh viên và 1 mã khoa, kiểm tra xem sinh viên có thuộc khoa này không (trả về đúng hoặc sai)
create function kiemTraSinhVien (@msv varchar(10), @mk varchar(10))
returns nvarchar(10)
as begin
	declare @result nvarchar(10)
	if((select maKhoa from DMSV where MASV = @msv) = @mk)
		set @result = N'Đúng'
	else
		set @result = N'Sai'
	return @result
end
go
print dbo.kiemTraSinhVien('A01','AV')
go
-- 2.Tính điểm thi sau cùng của một sinh viên trong một môn học cụ thể
create function diemThiSauCung (@msv varchar(10), @mh varchar(10))
returns float
as begin
	declare @result float
	set @result = (select top 1 DIEM from KETQUA where MASV = @msv and MAMH = @mh order by LANTHI desc)
	return @result
end
go
print dbo.diemThiSauCung('A01','01')
go
-- 3. Tính điểm trung bình của một sinh viên (chú ý : điểm trung bình được tính dựa trên lần thi sau cùng), sử dụng function 2 đã viết
create function diemTrungBinhSV(@msv varchar(10))
returns float
as begin
	declare @result float
	set @result = (select avg(DIEM) from KETQUA where MASV = @msv and DIEM = dbo.diemThiSauCung('A01', maMH))
	return @result
end
go
--drop function dbo.diemTrungBinhSV
print dbo.diemTrungBinhSV('A01')
go
-- 4. Nhập vào 1 sinh viên và 1 môn học, trả về các điểm thi của sinh viên này trong các lần thi của môn học đó.
create function diemTrongCacLanThi (@msv varchar(10), @mh varchar(10))
returns table
as
	return (select DIEM, LANTHI from KETQUA where @msv = MASV and @mh = MAMH)
go
drop function diemTrongCacLanThi
print dbo.diemTrongCacLanThi('A01','01')
--C
--1. Nhập vào 1 khoa, in danh sách các sinh viên (mã sinh viên, họ tên, ngày sinh) thuộc khoa này.
create proc DSSV_Khoa @MK varchar(10)
as begin
	select MASV, HOSV, TENSV, NGAYSINH 
	from DMSV 
	where MAKHOA = @MK
end
exec DSSV_Khoa 'TH'
go
-- 2. Nhập vào 2 sinh viên, 1 môn học, tìm xem sinh viên nào có điểm thi môn học đó lần đầu tiên là cao hơn
create proc soSanhDiemThi @sv1 varchar(10), @sv2 varchar(10), @mh varchar(10)
as begin
	select top 1 MASV,DIEM
	from KetQua
	where (@sv1 = MASV or @sv2 = MASV) and @mh = maMH and lanThi = 1
	order by DIEM desc
end
drop proc soSanhDiemThi
exec soSanhDiemThi 'A01' , 'A02', '01'
go
-- 3.Nhập vào 1 môn học và 1 mã sv, kiểm tra xem sinh viên có đậu môn này trong lần thi đầu tiên không, nếu đậu thì xuất ra là “Đậu”, không thì xuất ra “Không đậu”
create proc dauTrongLanThiDau @msv varchar(10), @mh varchar(10)
as begin
	if((select DIEM from KETQUA where MASV = @msv and MAMH = @mh and LANTHI = 1) >= 5)
		return 1
	else
		return
end

go
declare @check3 int
exec @check3 = dauTrongLanThiDau 'A01', '01'
if(@check3 = 1)
	print N'Đậu'
else
	print N'Không đậu'
go
--4 Nhập vào 1 sinh viên và 1 môn học, in điểm thi của sinh viên này của các lần thi môn học đó.
create proc diemVaLanThi @msv varchar(10), @mh varchar(10)
as begin
	select DIEM, LANTHI
	from KETQUA
	where @msv = MASV and @mh = MAMH
end

exec diemVaLanThi 'A01', '01'
go
--5. Nhập vào 1 sinh viên, in ra các môn học mà sinh viên này phải học.
create proc KiemTraMH @MASV varchar(10)
	as
	begin
	select KETQUA.MAMH,TENMH from KETQUA,DMMH
		where DMMH.MAMH=KETQUA.MAMH and @MASV = KETQUA.MASV
	end
go
exec KiemTraMH 'A01'
--6. Nhập vào 1 môn học, in danh sách các sinh viên đậu môn này trong lần thi đầu tiên
create proc dsDauMonThiLanDau @mh varchar(10)
as begin
	select MASV
	from KETQUA
	where @mh = MAMH and LANTHI = 1 and DIEM >= 5
end

exec dsDauMonThiLanDau '01'
go
--7. Viết thủ tục nhập sinh viên mới
create proc nhapSVMoi @msv varchar(10), @ho nvarchar(30), @ten nvarchar(30), @gt int, @ns date, @nois nvarchar(50), @mk varchar(10), @hb int
as begin
	insert into DMSV(MASV, HOSV, TENSV, PHAI, NGAYSINH, NGAYSINH, MAKHOA, HOCBONG) values (@msv, @ho, @ten, @gt, @ns, @nois, @mk, @hb)
end
go
--8. Viết thủ tục nhập sinh viên mới có kiểm tra ràng buộc khóa chính, ràng buộc khóa ngoại với bảng Khoa và ràng buộc tuổi của sinh viên lớn hơn hoặc bằng 18 và nhỏ hơn 40.
create proc nhapSVMoiLonTuoi @msv varchar(10), @ho nvarchar(30), @ten nvarchar(30), @gt int, @ns date, @nois nvarchar(50), @mk varchar(10), @hb int
as begin
	if(year(GETDATE()) - year(@ns) < 18)
		return
	insert into DMSV(MASV, HOSV, TENSV, PHAI, NGAYSINH, NOISINH, MAKHOA, HOCBONG) values (@msv, @ho, @ten, @gt, @ns, @nois, @mk, @hb)
end
go
--9. Viết thủ tục nhập kết quả của sinh viên có kiểm tra ràng buộc khóa ngoại giữa bảng Ketqua và bảng Sinhvien và bảng Monhoc.
create proc nhapSVMoiRangBuoc @msv varchar(10), @ho nvarchar(30), @ten nvarchar(30), @gt int, @ns date, @nois nvarchar(50), @mk varchar(10), @hb int
as begin
	insert into DMSV(MASV, HOSV, TENSV, PHAI, NGAYSINH, NOISINH, MAKHOA, HOCBONG) values (@msv, @ho, @ten, @gt, @ns, @nois, @mk, @hb)
end
go
--10. Viết thủ tục cho biết số lượng sinh viên của khoa có mã nhập vào từ bàn phím.
create proc soLuongSinhVien @mk varchar(10)
as begin
	select count(maSV) as N'Số Lượng' 
	from DMSV 
	where MAKHOA = @mk
end
go
--drop proc soLuongSinhVien
exec soLuongSinhVien 'AV'
go
--11. Viết hàm xem danh sách sinh viên của khoa có mã được nhập vào từ bàn phím
create proc xemDSSV @mk varchar(10)
as begin
	select * 
	from DMSV 
	where MAKHOA = @mk
end
go
exec xemDSSV 'TH'
go
--12. Viết hàm thống kê số lượng sinh viên của mỗi khoa
create proc soLuongSinhVienCuaKhoa
as begin
	select maKhoa, count(maKhoa)[Số lượng] 
	from DMSV 
	group by maKhoa
end
go
exec soLuongSinhVienCuaKhoa
go
--13. Viết hàm xem kết quả học tập của sinh viên có mã được nhập từ bàn phím.
create proc xemKetQuaHocTap @msv varchar(10)
as begin
	select maMH, lanThi, diem
	from KetQua
	where maSV = @msv
end
go
exec xemKetQuaHocTap 'A01'
go
--14. Viết hàm đếm số lượng sinh viên của khoa có mã khoa được nhập vào từ bàn phím
create proc demSoLuongSinhVien @mk varchar(10)
as begin
	select count(maSV)[Số lượng]
	from DMSV
	where maKhoa = @mk
end
go
exec demSoLuongSinhVien 'TH'
