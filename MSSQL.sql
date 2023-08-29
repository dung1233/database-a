 CREATE DATABASE MSSQL	
 GO	

 USE MSSQL
 GO

 CREATE TABLE DONDATHANG (
  MASODONHANG INT, 
  NGUOIDATHANG NVARCHAR(50),
  DIACHI NVARCHAR(50),
  PHONE INT,
  NGAYDATHANG DATE
 )
GO

CREATE TABLE DANHSACDATHANG
(
 STT INT ,
 TENHANG NVARCHAR(50),
 MOTAHANG NVARCHAR(50),
 DONVI NVARCHAR(50),
 GIA FLOAT,
 SOLUONG INT,
 THANHTIEN FLOAT
)
GO

INSERT INTO DONDATHANG 
(MASODONHANG, NGUOIDATHANG, DIACHI, PHONE, NGAYDATHANG)
VALUES
(
  123,
  N'NGUYỄN VĂN AN',
  N'11 NGUYỄN TRÃI,THANH XUÂN, HÀ NỘI',
  987654321,
  '2009-11-15'
);
GO

INSERT INTO DANHSACDATHANG
(STT, TENHANG, MOTAHANG, DONVI, GIA, SOLUONG, THANHTIEN)
VALUES 
(
  1, N'MÁY NHẬP MỚI', N'CHIẾC', N'CHIẾC', 1000, 1, 1000),
  (2, N'ĐIỆN THOẠI NOKIA5670', N'ĐIỆN THOẠI ĐANG HOT', N'CHIẾC', 200, 2, 400),
  (3, N'MÁY IN SAMSUNG 450', N'MÁY IN ĐANG Ế', N'CHIẾC', 100, 1, 100);

GO


SELECT * FROM DONDATHANG

--A)Liệt kê danh sách khách hàng đã mua hàng ở cửa hàng.
SELECT DISTINCT NGUOIDATHANG
FROM dbo.DONDATHANG
--b) Liệt kê danh sách sản phẩm của của hàng
SELECT TENHANG,GIA FROM DANHSACDATHANG
---c) Liệt kê danh sách các đơn đặt hàng của cửa hàng
SELECT * FROM DONDATHANG


--a)Liệt kê danh sách khách hàng theo thứ thự alphabet.
SELECT NGUOIDATHANG
FROM DONDATHANG
ORDER BY NGUOIDATHANG ASC;
---b) Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần.
SELECT TENHANG, GIA

FROM DANHSACDATHANG
ORDER BY GIA DESC;
--c) Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua.
SELECT TENHANG
FROM dbo.DANHSACDATHANG
WHERE TENHANG IN (
    SELECT TENHANG
    FROM dbo.DONDATHANG
    WHERE NGUOIDATHANG = N'Nguyễn Văn An'
);
--6. Viết các câu lệnh truy vấn để
--a) Số khách hàng đã mua ở cửa hàng.
--b) Số mặt hàng mà cửa hàng bán.
--c) Tổng tiền của từng đơn hàng.


SELECT COUNT(DISTINCT NGUOIDATHANG) AS SoKhachHang
FROM dbo.DONDATHANG;

SELECT COUNT(DISTINCT TENHANG) AS SoMatHang
FROM dbo.DANHSACDATHANG;

SELECT MASODONHANG, SUM(THANHTIEN) AS TongTien
FROM dbo.DONDATHANG,DANHSACDATHANG
GROUP BY MASODONHANG;

--7. Thay đổi những thông tin sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
--b) Viết câu lệnh để thay đổi ngày đặt hàng của khách hàng phải nhỏ hơn ngày hiện tại.
---c) Viết câu lệnh để thêm trường ngày xuất hiện trên thị trường của sản phẩm

UPDATE dbo.DANHSACDATHANG
SET GIA = ABS(GIA)
WHERE GIA < 0;

UPDATE dbo.DONDATHANG
SET NGAYDATHANG = GETDATE()
WHERE NGAYDATHANG > GETDATE();

ALTER TABLE dbo.DANHSACDATHANG
ADD NGAYXUATTHITRUONG date;
--- -8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (index) cho cột Tên hàng và Người đặt hàng để tăng tốc độ truy vấn dữ liệu trên
--các cột này.
--b) Xây dựng các view sau đây:
---◦ View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại
---◦ View_SanPham với các cột: Tên sản phẩm, Giá bán
---◦ View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản
---phẩm, Số lượng, Ngày mua
--c) Viết các Store Procedure (Thủ tục lưu trữ) sau:
--◦ SP_TimKH_MaKH: Tìm khách hàng theo mã khách hàng
--◦ SP_TimKH_MaHD: Tìm thông tin khách hàng theo mã hóa đơn
---◦ SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được
--truyền vào Store

CREATE INDEX idx_TENHANG ON dbo.DANHSACDATHANG(TENHANG);
CREATE INDEX idx_NGUOIDATHANG ON dbo.DONDATHANG(NGUOIDATHANG);
GO


CREATE VIEW View_KhachHang AS
SELECT NGUOIDATHANG AS [Tên khách hàng], DIACHI AS [Địa chỉ], PHONE AS [Điện thoại]
FROM dbo.DONDATHANG;


GO
CREATE VIEW View_SanPham AS
SELECT TENHANG AS [Tên sản phẩm], GIA AS [Giá bán]
FROM dbo.DANHSACDATHANG;
GO

CREATE VIEW View_KhachHang_SanPham AS
SELECT D.NGUOIDATHANG AS 'Tên khách hàng',
       D.PHONE AS 'Số điện thoại',
       DS.TENHANG AS 'Tên sản phẩm',
       DS.SOLUONG AS 'Số lượng',
       D.NGAYDATHANG AS 'Ngày mua'
FROM DONDATHANG D
INNER JOIN DANHSACDATHANG DS ON D.MASODONHANG = DS.STT;
GO
CREATE VIEW View_KhachHang_SanPham1 AS
SELECT DDH.NGUOIDATHANG AS [Tên khách hàng], DDH.PHONE AS [Số điện thoại], DSDH.TENHANG AS [Tên sản phẩm], DSDH.SOLUONG, DDH.NGAYDATHANG AS [Ngày mua]
FROM dbo.DONDATHANG DDH
JOIN dbo.DANHSACDATHANG DSDH ON DDH.MASODONHANG = DSDH.STT;
GO
SELECT * FROM View_KhachHang_SanPham1




CREATE PROCEDURE SP_TimKH_MaKH
    @MaKH int
AS
BEGIN
    SELECT *
    FROM dbo.DONDATHANG
    WHERE NGUOIDATHANG = @MaKH;
END;
GO
CREATE PROCEDURE SP_TimKH_MaHD
    @MaHD int
AS
BEGIN
    SELECT *
    FROM dbo.DONDATHANG
    WHERE MASODONHANG = @MaHD;
END;
GO
CREATE PROCEDURE SP_SanPham_MaKH
    @MaKhachHang INT
AS
BEGIN
    SELECT DS.TENHANG AS 'Tên sản phẩm',
           DS.SOLUONG AS 'Số lượng',
           D.NGAYDATHANG AS 'Ngày mua'
    FROM DONDATHANG D
    INNER JOIN DANHSACDATHANG DS ON D.MASODONHANG = DS.STT
    WHERE D.PHONE = @MaKhachHang;
END;

GO
 SELECT * FROM 