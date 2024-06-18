create database QuanLyHocVien;

use QuanLyHocVien;

-- Bảng Nhân viên
CREATE TABLE NhanVien (
    MaNV NVARCHAR(20) PRIMARY KEY NOT NULL,
    MatKhau NVARCHAR(50) NOT NULL,
    HoTen NVARCHAR(50) NOT NULL,
    VaiTro BIT DEFAULT 0
);

-- Bảng Chuyên đề
CREATE TABLE ChuyenDe (
    MaCD NCHAR(5) PRIMARY KEY NOT NULL,
    TenCD NVARCHAR(50) NOT NULL,
    HocPhi FLOAT NOT NULL,
    ThoiLuong INT NOT NULL,
    Hinh NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(255) NOT NULL
);

-- Bảng Người học
CREATE TABLE NguoiHoc (
    MaNH NCHAR(7) PRIMARY KEY NOT NULL,
    HoTen NVARCHAR(50) NOT NULL,
    GioiTinh BIT DEFAULT 1,
    NgaySinh DATE NOT NULL,
    DienThoai NVARCHAR(24) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    GhiChu NVARCHAR(255) NULL,
    MaNV NVARCHAR(20) NOT NULL,
    NgayDK DATE DEFAULT GETDATE(),
    CONSTRAINT FK_NguoiHoc_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Khóa học
CREATE TABLE KhoaHoc (
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    MaCD NCHAR(5) NOT NULL,
    HocPhi FLOAT NOT NULL,
    ThoiLuong INT NOT NULL,
    NgayKG DATE NOT NULL,
    GhiChu NVARCHAR(255) NULL,
    MaNV NVARCHAR(20) NOT NULL,
    NgayTao DATE DEFAULT GETDATE(),
    CONSTRAINT FK_KhoaHoc_ChuyenDe FOREIGN KEY (MaCD) REFERENCES ChuyenDe(MaCD),
    CONSTRAINT FK_KhoaHoc_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Học viên
CREATE TABLE HocVien (
    MaHV INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT NOT NULL,
    MaNH NCHAR(7) NOT NULL,
    Diem FLOAT DEFAULT -1,
    CONSTRAINT FK_HocVien_KhoaHoc FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKH),
    CONSTRAINT FK_HocVien_NguoiHoc FOREIGN KEY (MaNH) REFERENCES NguoiHoc(MaNH)
);

-- Thủ tục lấy bảng điểm của một khóa học
CREATE PROC sp_BangDiem(@MaKH INT)
AS BEGIN
    SELECT
        nh.MaNH,
        nh.HoTen,
        hv.Diem
    FROM HocVien hv
        JOIN NguoiHoc nh ON nh.MaNH = hv.MaNH
    WHERE hv.MaKH = @MaKH
    ORDER BY hv.Diem DESC
END
GO

-- Thủ tục lấy điểm của các chuyên đề
CREATE PROC sp_DiemChuyenDe
AS BEGIN
    SELECT
        TenCD AS ChuyenDe,
        COUNT(MaHV) AS SoHV,
        MIN(Diem) AS ThapNhat,
        MAX(Diem) AS CaoNhat,
        AVG(Diem) AS TrungBinh
    FROM KhoaHoc kh
        JOIN HocVien hv ON kh.MaKH = hv.MaKH
        JOIN ChuyenDe cd ON cd.MaCD = kh.MaCD
    GROUP BY TenCD
END
GO

-- Thủ tục lấy doanh thu theo năm
CREATE PROC sp_DoanhThu(@Year INT)
AS BEGIN
    SELECT
        TenCD AS ChuyenDe,
        COUNT(DISTINCT kh.MaKH) AS SoKH,
        COUNT(hv.MaHV) AS SoHV,
        SUM(kh.HocPhi) AS DoanhThu,
        MIN(kh.HocPhi) AS ThapNhat,
        MAX(kh.HocPhi) AS CaoNhat,
        AVG(kh.HocPhi) AS TrungBinh
    FROM KhoaHoc kh
        JOIN HocVien hv ON kh.MaKH = hv.MaKH
        JOIN ChuyenDe cd ON cd.MaCD = kh.MaCD
    WHERE YEAR(NgayKG) = @Year
    GROUP BY TenCD
END
GO

-- Thủ tục lấy lượng người học theo năm
CREATE PROC sp_LuongNguoiHoc
AS BEGIN
    SELECT
        YEAR(NgayDK) AS Nam,
        COUNT(*) AS SoLuong,
        MIN(NgayDK) AS DauTien,
        MAX(NgayDK) AS CuoiCung
    FROM NguoiHoc
    GROUP BY YEAR(NgayDK)
END
GO

-- Inserting sample data into NhanVien table
INSERT INTO NhanVien (MaNV, MatKhau, HoTen, VaiTro) VALUES
('NV001', '12345678', 'Nguyen Van A', 1),
('NV002', '123456789', 'Le Thi B', 0),
('NV003', 'pass123', 'Tran Van C', 0);

-- Inserting sample data into ChuyenDe table
INSERT INTO ChuyenDe (MaCD, TenCD, HocPhi, ThoiLuong, Hinh, MoTa) VALUES
(N'JAV01', N'Lập trình Java cơ bản', 250, 90, N'GAME.png', N'JAV01 - Lập trình Java cơ bản'),
(N'JAV02', N'Lập trình Java nâng cao', 300, 90, N'HTCS.jpg', N'JAV02 - Lập trình Java nâng cao'),
(N'JAV03', N'Lập trình mạng với Java', 200, 70, N'INMA.jpg', N'JAV03 - Lập trình mạng với Java'),
(N'JAV04', N'Lập trình desktop với Swing', 200, 70, N'ADAV.jpg', N'JAV04 - Lập trình desktop với Swing'),
(N'PRO01', N'Dự án với công nghệ MS.NET MVC', 300, 90, N'MOWE.png', N'PRO01 - Dự án với công nghệ MS.NET MVC'),
(N'PRO02', N'Dự án với công nghệ Spring MVC', 300, 90, N'Subject.png', N'PRO02 - Dự án với công nghệ Spring MVC'),
(N'PRO03', N'Dự án với công nghệ Servlet/JSP', 300, 90, N'GAME.png', N'PRO03 - Dự án với công nghệ Servlet/JSP'),
(N'PRO04', N'Dự án với AngularJS & WebAPI', 300, 90, N'HTCS.jpg', N'PRO04 - Dự án với AngularJS & WebAPI'),
(N'PRO05', N'Dự án với Swing & JDBC', 300, 90, N'INMA.jpg', N'PRO05 - Dự án với Swing & JDBC'),
(N'PRO06', N'Dự án với WindowForm', 300, 90, N'LAYO.jpg', N'PRO06 - Dự án với WindowForm'),
(N'RDB01', N'Cơ sở dữ liệu SQL Server', 100, 50, N'MOWE.png', N'RDB01 - Cơ sở dữ liệu SQL Server'),
(N'RDB02', N'Lập trình JDBC', 150, 60, N'Subject.png', N'RDB02 - Lập trình JDBC'),
(N'RDB03', N'Lập trình cơ sở dữ liệu Hibernate', 250, 80, N'GAME.png', N'RDB03 - Lập trình cơ sở dữ liệu Hibernate'),
(N'SER01', N'Lập trình web với Servlet/JSP', 350, 100, N'HTCS.jpg', N'SER01 - Lập trình web với Servlet/JSP'),
(N'SER02', N'Lập trình Spring MVC', 400, 110, N'INMA.jpg', N'SER02 - Lập trình Spring MVC'),
(N'SER03', N'Lập trình MS.NET MVC', 400, 110, N'LAYO.jpg', N'SER03 - Lập trình MS.NET MVC'),
(N'SER04', N'Xây dựng Web API với Spring MVC & ASP.NET MVC', 200, 70, N'MOWE.png', N'SER04 - Xây dựng Web API với Spring MVC & ASP.NET MVC'),
(N'WEB01', N'Thiết kế web với HTML và CSS', 200, 70, N'Subject.png', N'WEB01 - Thiết kế web với HTML và CSS'),
(N'WEB02', N'Thiết kế web với Bootstrap', 0, 40, N'GAME.png', N'WEB02 - Thiết kế web với Bootstrap'),
(N'WEB03', N'Lập trình front-end với JavaScript và jQuery', 150, 60, N'HTCS.jpg', N'WEB03 - Lập trình front-end với JavaScript và jQuery'),
(N'WEB04', N'Lập trình AngularJS', 250, 80, N'INMA.jpg', N'WEB04 - Lập trình AngularJS');
-- Inserting sample data into NguoiHoc table
INSERT INTO NguoiHoc (MaNH, HoTen, GioiTinh, NgaySinh, DienThoai, Email, GhiChu, MaNV, NgayDK) VALUES
(N'PS01638', N'LỮ HUY CƯỜNG', 0, '2003-10-15', N'0928768265', N'PS01638@fpt.edu.vn', N'0928768265 - LỮ HUY CƯỜNG', N'NV001', '2022-10-15'),
(N'PS02037', N'ĐỖ VĂN MINH', 1, '2002-11-15', N'0968095685', N'PS02037@fpt.edu.vn', N'0968095685 - ĐỖ VĂN MINH', N'NV001', '2022-11-15'),
(N'PS02771', N'NGUYỄN TẤN HIẾU', 1, '2005-02-15', N'0927594734', N'PS02771@fpt.edu.vn', N'0927594734 - NGUYỄN TẤN HIẾU', N'NV001', '2023-02-15'),
(N'PS02867', N'NGUYỄN HỮU TRÍ', 1, '2004-01-15', N'0946984711', N'PS02867@fpt.edu.vn', N'0946984711 - NGUYỄN HỮU TRÍ', N'NV001', '2023-01-15'),
(N'PS02930', N'TRẦN VĂN NAM', 1, '2005-03-15', N'0924774498', N'PS02930@fpt.edu.vn', N'0924774498 - TRẦN VĂN NAM', N'NV001', '2023-03-15'),
(N'PS02979', N'ĐOÀN TRẦN NHẬT VŨ', 1, '2003-12-15', N'0912374818', N'PS02979@fpt.edu.vn', N'0912374818 - ĐOÀN TRẦN NHẬT VŨ', N'NV001', '2022-12-15'),
(N'PS02983', N'NGUYỄN HOÀNG THIÊN PHƯỚC', 1, '2004-12-10', N'0912499836', N'PS02983@fpt.edu.vn', N'0912499836 - NGUYỄN HOÀNG THIÊN PHƯỚC', N'NV001', '2022-12-10'),
(N'PS02988', N'HỒ HỮU HẬU', 1, '2003-09-15', N'0924984876', N'PS02988@fpt.edu.vn', N'0924984876 - HỒ HỮU HẬU', N'NV001', '2022-09-15'),
(N'PS03031', N'PHAN TẤN VIỆT', 1, '2003-09-10', N'0924832716', N'PS03031@fpt.edu.vn', N'0924832716 - PHAN TẤN VIỆT', N'NV001', '2022-09-10'),
(N'PS03046', N'NGUYỄN CAO PHƯỚC', 1, '2004-08-15', N'0977117727', N'PS03046@fpt.edu.vn', N'0977117727 - NGUYỄN CAO PHƯỚC', N'NV001', '2022-08-15'),
(N'PS03080', N'HUỲNH THANH HUY', 1, '2003-12-15', N'0916436052', N'PS03080@fpt.edu.vn', N'0916436052 - HUỲNH THANH HUY', N'NV001', '2022-12-15'),
(N'PS03088', N'NGUYỄN HOÀNG TRUNG', 1, '2004-11-10', N'0938101529', N'PS03088@fpt.edu.vn', N'0938101529 - NGUYỄN HOÀNG TRUNG', N'NV001', '2022-11-10'),
(N'PS03096', N'ĐOÀN HỮU KHANG', 1, '2004-11-05', N'0945196719', N'PS03096@fpt.edu.vn', N'0945196719 - ĐOÀN HỮU KHANG', N'NV001', '2022-11-05'),
(N'PS03104', N'LÊ THÀNH PHƯƠNG', 0, '2003-09-10', N'0922948096', N'PS03104@fpt.edu.vn', N'0922948096 - LÊ THÀNH PHƯƠNG', N'NV001', '2022-09-10'),
(N'PS03120', N'PHẠM NGỌC NHẬT TRƯỜNG', 1, '2005-03-15', N'0994296169', N'PS03120@fpt.edu.vn', N'0994296169 - PHẠM NGỌC NHẬT TRƯỜNG', N'NV001', '2022-03-15'),
(N'PS03130', N'ĐẶNG BẢO VIỆT', 1, '2005-05-15', N'0917749344', N'PS03130@fpt.edu.vn', N'0917749344 - ĐẶNG BẢO VIỆT', N'NV001', '2022-05-15'),
(N'PS03134', N'LÊ DUY BẢO', 1, '2003-10-15', N'0926714368', N'PS03134@fpt.edu.vn', N'0926714368 - LÊ DUY BẢO', N'NV001', '2022-10-15'),
(N'PS03172', N'NGUYỄN ANH TUẤN', 1, '2004-11-20', N'0920020472', N'PS03172@fpt.edu.vn', N'0920020472 - NGUYỄN ANH TUẤN', N'NV001', '2022-11-20'),
(N'PS03202', N'PHAN QUỐC QUI', 1, '2005-01-15', N'0930649274', N'PS03202@fpt.edu.vn', N'0930649274 - PHAN QUỐC QUI', N'NV001', '2023-01-15'),
(N'PS03203', N'ĐẶNG LÊ QUANG VINH', 1, '2005-05-10', N'0920197355', N'PS03203@fpt.edu.vn', N'0920197355 - ĐẶNG LÊ QUANG VINH', N'NV001', '2022-05-10'),
(N'PS03205', N'NGUYỄN MINH SANG', 1, '2003-09-15', N'0967006218', N'PS03205@fpt.edu.vn', N'0967006218 - NGUYỄN MINH SANG', N'NV001', '2022-09-15'),
(N'PS03222', N'TRẦM MINH MẪN', 1, '2003-12-20', N'0911183649', N'PS03222@fpt.edu.vn', N'0911183649 - TRẦM MINH MẪN', N'NV001', '2022-12-20'),
(N'PS03230', N'NGUYỄN PHẠM MINH HÂN', 1, '2005-03-20', N'0983469892', N'PS03230@fpt.edu.vn', N'0983469892 - NGUYỄN PHẠM MINH HÂN', N'NV001', '2023-03-20'),
(N'PS03233', N'LƯU KIM HOÀNG DUY', 1, '2005-02-15', N'0938357735', N'PS03233@fpt.edu.vn', N'0938357735 - LƯU KIM HOÀNG DUY', N'NV001', '2022-02-15'),
(N'PS03251', N'TRẦN QUANG VŨ', 1, '2005-04-15', N'0914531913', N'PS03251@fpt.edu.vn', N'0914531913 - TRẦN QUANG VŨ', N'NV001', '2022-04-15'),
(N'PS03252', N'TRẦN HỮU ĐỨC', 1, '2004-12-20', N'0919247555', N'PS03252@fpt.edu.vn', N'0919247555 - TRẦN HỮU ĐỨC', N'NV001', '2022-12-20'),
(N'PS03253', N'TRẦN MINH NHẬT', 1, '2003-09-20', N'0938749184', N'PS03253@fpt.edu.vn', N'0938749184 - TRẦN MINH NHẬT', N'NV001', '2022-09-20'),
(N'PS03257', N'PHAN LÂM QUANG TUẤN', 1, '2004-01-15', N'0915714139', N'PS03257@fpt.edu.vn', N'0915714139 - PHAN LÂM QUANG TUẤN', N'NV001', '2022-01-15'),
(N'PS03259', N'NGUYỄN KHẢI ANH', 1, '2004-11-15', N'0913263124', N'PS03259@fpt.edu.vn', N'0913263124 - NGUYỄN KHẢI ANH', N'NV001', '2022-11-15'),
(N'PS03265', N'TRẦN HOÀI THƯƠNG', 0, '2004-04-20', N'0912432658', N'PS03265@fpt.edu.vn', N'0912432658 - TRẦN HOÀI THƯƠNG', N'NV001', '2023-04-20'),
(N'PS03279', N'PHẠM LÊ TRƯỜNG AN', 1, '2004-03-20', N'0967019820', N'PS03279@fpt.edu.vn', N'0967019820 - PHẠM LÊ TRƯỜNG AN', N'NV001', '2023-03-20');

-- Inserting sample data into KhoaHoc table
INSERT INTO KhoaHoc (MaCD, HocPhi, ThoiLuong, NgayKG, GhiChu, MaNV, NgayTao) VALUES
('JAV01', 300, 90, '2023-02-24', N'', 'NV001', '2023-01-24'),
('JAV02', 300, 90, '2023-03-15', N'', 'NV001', '2023-02-15'),
('JAV03', 100, 50, '2023-04-12', N'', 'NV001', '2023-03-12'),
('JAV04', 250, 80, '2023-05-15', N'', 'NV001', '2023-04-15'),
('PRO01', 300, 90, '2023-02-28', N'', 'NV001', '2023-01-28'),
('JAV01', 300, 90, '2023-03-01', N'Lập trình Java cơ bản', 'NV001', '2023-02-01'),
('JAV02', 300, 90, '2023-03-02', N'Lập trình Java nâng cao', 'NV001', '2023-02-02'),
('JAV03', 200, 70, '2023-03-03', N'Lập trình mạng với Java', 'NV001','2023-02-03'),
('JAV04', 200, 70, '2023-03-04', N'Lập trình ứng dụng Desktop với Java', 'NV001', '2023-02-04'),
('PRO01', 300, 90, '2023-03-05', N'Lập trình .NET MVC', 'NV001', '2023-02-05'),
('PRO02', 300, 90, '2023-03-06', N'Lập trình Spring MVC', 'NV001', '2023-02-06'),
('PRO03', 300, 90, '2023-03-07', N'Làm dự án với Servlet và JSP', 'NV001', '2023-02-07'),
('PRO04', 300, 90, '2023-03-08', N'Làm dự án với REST API và AngularJS', 'NV001', '2023-02-08'),
('JAV01', 300, 90, '2023-03-09', N'Lập trình Java cơ bản', 'NV001', '2023-02-09'),
('JAV01', 250, 90, '2023-03-10', N'Lập trình Java cơ bản', 'NV001', '2023-02-10');

select * from NhanVien
select * from ChuyenDe
select * from NguoiHoc
select * from HocVien
select * from KhoaHoc

SELECT COUNT(*) FROM KhoaHoc WHERE MaCD like 'JAV01'

EXEC sp_BangDiem @MaKH = 3;
EXEC sp_DiemChuyenDe;
EXEC sp_DoanhThu @Year = 2023;
EXEC sp_LuongNguoiHoc;
