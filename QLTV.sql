CREATE DATABASE CSDL
go
USE CSDL
GO

CREATE TABLE PRODUCT(
	MaSanPham NVARCHAR(20) PRIMARY KEY,
	TenSanPham NVARCHAR(50),
	MoTa NVARCHAR(50),
	GiaSanPham decimal(18,0),
	SoLuongSanPham INT
)

CREATE TABLE ORDERS(
	MaDonHang NVARCHAR(20) PRIMARY KEY,
	MaPhuongThucThanhToan NVARCHAR(20),
	MaOrder_Detail NVARCHAR(20),
	NgayDatHang DATE,
	TrangThaiDatHang NVARCHAR(50),
	TongTien decimal(18,0)
)

CREATE TABLE CUSTOMER(
	MaKhachHang NVARCHAR(20) PRIMARY KEY,
	MaDonHang NVARCHAR(20),
	HoVaTen NVARCHAR(100),
	Email NVARCHAR(50),
	Phone NVARCHAR(50),
	DiaChi NVARCHAR(100)
)

CREATE TABLE PAYMENT(
	MaPhuongThucThanhToan NVARCHAR(20) PRIMARY KEY,
	TenPhuongThucThanhToan NVARCHAR(50),
	PhiThanhToan decimal(18,0)
)

CREATE TABLE ORDER_DETAIL(
	MaOrder_Detail NVARCHAR(20) PRIMARY KEY,
	MaSanPham NVARCHAR(20),
	SoLuongSanPhamMua INT,
	GiaSanPhamMua decimal(18,0),
	ThanhTien decimal(18,0)
)
alter table CUSTOMER
add foreign key(MaDonHang) references ORDERS(MaDonHang);

alter table ORDERS
add foreign key(MaPhuongThucThanhToan) references PAYMENT(MaPhuongThucThanhToan);

alter table ORDERS
add FOREIGN key(MaOrder_Detail) references ORDER_DETAIL(MaOrder_Detail);

alter table ORDER_DETAIL
add FOREIGN key(MaSanPham) references PRODUCT(MaSanPham);
insert INTO CUSTOMER 
	(MaKhachHang, MaDonHang, HoVaTen, Email, Phone, DiaChi) values
	('KH1', 'DH1', 'Nguyễn Đăng Khoa', 'dangkhoa@gmail.com' , '0934806624' , 'Da Nang'),
	('KH2', 'DH2', 'Nguyễn Hữu khoa','huukhoa@gmail.com', '0905306524', 'Hue'),
	('KH3', 'DH3', 'Nguyễn Thị Huyền', 	'thihuyen@gmail.com', '0934336226', 'Quang Nam'),
	('KH4', 'DH2', 'Võ Hoàng Kim',  'hoangkim@gmail.com', '0905486674', 'Quang Ngai'),
	('KH5', 'DH3', 'Nguyễn Nhật Long',   'nhatlong@gmail.com', '0934886633', 'Da Nang'),	
	('KH6', 'DH1', 'Nguyễn Tấn Hoàng long',   'hoanglong@gmail.com', '0934159753', 'Da Nang')

INSERT INTO PRODUCT (MaSanPham, TenSanPham, MoTa, GiaSanPham, SoLuongSanPham) VALUES
	('SP1', 'But chi', 'cay', 3000,	150),
	('SP2', 'vo', 'quyen', 5000, 50),
	('SP3', 'Phan viet bang', 'hop', 12000, 10)
insert INTO ORDERS (MaDonHang, MaPhuongThucThanhToan, MaOrder_Detail, NgayDatHang, TrangThaiDatHang, TongTien) values 
	('DH1', 'PTTT1', 'CTDH1', '05/03/2020', 'da nhan hang',12000),
	('DH2', 'PTT2', 'CTDH2', '02/10/2021', 'dang giao hang', 25000),
	('DH3', 'PTT3', 'CTDH3', '03/04/2020', 'dang xac nhan', 36000)
INSERT INTO PAYMENT(MaPhuongThucThanhToan, TenPhuongThucThanhToan, PhiThanhToan) VALUES
	('PTTT1','ZaloPay',12000),
    ('PTT2','Momo',36000),
	('PTT3','tien mat',25000)
insert into ORDER_DETAIL (MaOrder_Detail, MaSanPham, SoLuongSanPhamMua, GiaSanPhamMua, ThanhTien) values
	('CTDH1', 'SP1', 4, 3000, 12000),
	('CTDH2', 'SP2', 5,  5000,25000),
	('CTDH3', 'SP3', 3, 12000, 36000)
go
--TẠO KHUNG NHÌN HIỂN THỊ THÔNG TIN KHÁCH HÀNG ĐỊA CHỈ Ở ĐÀ NẴNG VÀ TRẠNG THÁI 'Da nhan hang'
CREATE VIEW thongtinkhachhang as
SELECT DBO.CUSTOMER.MaKhachHang, DBO.CUSTOMER.HoVaTen,DBO.ORDERS.TrangThaiDatHang from DBO.ORDERS
INNER JOIN CUSTOMER on DBO.CUSTOMER.MaDonHang =DBO.ORDERS.MaDonHang
WHERE DBO.CUSTOMER.DiaChi = 'Da Nang' and DBO.ORDERS.TrangThaiDatHang = 'da nhan hang'

select * from thongtinkhachhang
update DBO.CUSTOMER set DiaChi = 'Da Nang'
where MaKhachHang = 'KH1' 
drop VIEW thongtinkhachhang

--TẠO KHUNG NHÌN HIỂN THỊ THÔNG TIN SẢN PHÂM CÓ SỐ LƯỢNG TRÊN 50 VÀ THANH TIEN TRÊN 10000
CREATE VIEW THONGTINSANPHAM AS
SELECT DBO.PRODUCT.TenSanPham, DBO.PRODUCT.MoTa,DBO.PRODUCT.SoLuongSanPham,DBO.ORDER_DETAIL.ThanhTien from DBO.PRODUCT
INNER JOIN	ORDER_DETAIL ON DBO.PRODUCT.MaSanPham = DBO.ORDER_DETAIL.MaSanPham
WHERE  DBO.PRODUCT.SoLuongSanPham >50 AND DBO.ORDER_DETAIL.ThanhTien >10000
-- tạo function  
select * from THONGTINSANPHAM

--drop VIEW  
create function SanPham(@TenSP VARCHAR(50))
returns Int
as
begin
		declare @SoLuongSanPham int
		select @SoLuongSanPham= SoLuongSanPham from DBO.PRODUCT where TenSanPham = @tenSP
		return @SoLuongSanPham
end
go
select dbo.SanPham('But chi') as soluongsanpham
drop function


create procedure Sp_deleCus (@id_cus nvarchar(10)) 
	as 
	 begin 
		delete from CUSTOMER where CUSTOMER.MaKhachHang = @id_cus ;  
	 end  ;
 
	execute Sp_deleCus 'KH6' ;
	select * from CUSTOMER;
	insert into CUSTOMER (MaKhachHang, MaDonHang, HoVaTen, Email, Phone, DiaChi) values
	('KH6', 'DH1', N'Nguyễn Tấn Hoàng long',   'hoanglong@gmail.com', '0987658', 'Da Nang')



	DROP PROCEDURE Sp_deleCus

use CSDL
go
create trigger CheckSp on PRODUCT
for insert
as 
	begin
		if exists(select * from inserted where SoLuongSanPham <10)
			begin
				print 'so luong san pham duoi 10 ';
				rollback transaction;
				end
	end
Go

CREATE TRIGGER trg_XoaKh3
ON dbo.CUSTOMER
FOR DELETE
AS
IF 'KH5' IN (SELECT Deleted.MaKhachHang FROM Deleted)
BEGIN
PRINT N'Không Thể Xóa Bản ghi này'
ROLLBACK Tran
END

DELETE FROM dbo.CUSTOMER WHERE MaKhachHang LIKE	'KH5'

-----------------------------------------------------
--Tao trigger check so luong san pham
CREATE TRIGGER trg_checkQuantity
ON dbo.PRODUCT
FOR INSERT, UPDATE
AS
	IF(SELECT Inserted.SoLuongSanPham FROM Inserted) < 1
BEGIN
PRINT N'Số lượng sản phẩm tối thiểu là 1'
ROLLBACK TRANSACTION
END

INSERT dbo.PRODUCT(MaSanPham,TenSanPham,MoTa,GiaSanPham,SoLuongSanPham)
VALUES(N'SP5',N'Vở',N'Giấy',6000,0)
-----------------------


