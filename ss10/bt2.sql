create database Hospital_db;
use Hospital_db;

create table Patients(
Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
Full_Name VARCHAR(100),
Phone VARCHAR(15),
Age INT,
address VARCHAR(255)
);

DELIMITER //
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Patient', i),
            CONCAT('690', i),
            FLOOR(RAND() * 100),
            'Ho Chi Minh City'
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL SeedPatients();

select * from Patients
Where Phone = '0901234567';

EXPLAIN 
select * From Patients
Where Phone = '0901234567'; 

CREATE INDEX indexphone
ON Patients(Phone);

select * from Patients
WHERE Phone = '0901234567';

EXPLAIN 
select * From Patients
Where Phone = '0901234567'; 

drop index indexphone on patients;

DELIMITER //

CREATE PROCEDURE Insert1000_NoIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('NewPatient_', i),
            CONCAT('099', LPAD(i, 7, '0')),
            FLOOR(RAND() * 100),
            'Can Tho'
        );

        SET i = i + 1;

    END WHILE;
END //

DELIMITER ;

set profiling = 1;

call insert100_NoIndex();

show profiles;

-- kết quả so sánh thời gian thực thi:
-- Select theo phone: 
-- không dùng index: chậm ~ 0.3s
-- dùng index chậm 0.1s
-- insert dữ liệu bằng index sẽ nhanh hơn không có index

-- ưu điểm không cần index
-- insert nhanh
-- database không cần update chỉ mục
-- nhược điểm: 
-- select chậm
-- phải quét hết bảng

-- ưu điểm có index
-- select nhanh
-- tìm kiếm rẻ nhánh không cần quét hết bảng
-- nhược điểm:
-- các cú pháp insert, update, delete chậm
-- database cần phải thêm dữ liệu và cập  nhập cây index