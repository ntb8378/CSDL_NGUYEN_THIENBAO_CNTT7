CREATE DATABASE StudentDB;
USE StudentDB;

-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

-- câu 1
create view ViewStudentBasic as
select s.StudentID, s.FullName, d.DeptName
from Student s
join Department d
on s.DeptID=d.DeptID;

-- câu 2
CREATE INDEX idxFullName
ON Student (FullName );
-- câu 3
delimiter //
	create procedure GetStudentsIT()
begin
	select s.FullName,d. DeptName  from student s
    join Department d
    on s.DeptID=d.DeptID
    where
    d. DeptName='Information Technology';
end //
delimiter ;

call GetStudentsIT();
-- câu 4

create view ViewStudentCountByDept as
select d.DeptName, count(s.StudentID) total_student from Department  d
join student s
on d.DeptID=s.DeptID
group by d.DeptName;

-- hiển thị khóa có nhiều sv nhất
-- ..................

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','Programming Fundamentals',4),
('C00003','Accounting Principles',3),
('C00004','Business Management',3),
('C00005','Web Development',4);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00002','C00001',9.0),
('S00003','C00004',7.5),
('S00004','C00003',8.0),
('S00005','C00001',9.2),
('S00006','C00004',6.8),
('S00007','C00003',8.7),
('S00008','C00001',7.9),
('S00001','C00002',8.8),
('S00002','C00005',9.1),
('S00005','C00005',8.9),
('S00008','C00002',9.3);

-- cau 5
delimiter //
	create procedure GetTopScoreStudent(IN varCourseID VARCHAR(6), out STU_MAX_CORE varchar(50))
begin
	select s.FullName , 
    where
end //
delimiter ;


-- câu 6


create view ViewITEnrollmentDB as
select 