-- Bảng Khoa
CREATE TABLE Departments (
Dept_ID INT PRIMARY KEY,
Dept_Name VARCHAR(100)
);

-- Bảng Hóa đơn (Kết nối bệnh nhân và khoa)

CREATE TABLE Invoices (
Invoice_ID INT PRIMARY KEY,
Patient_ID INT,
Dept_ID INT,
Amount DECIMAL(10, 2),

FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

-- Chèn dữ liệu mâu
INSERT INTO Departments VALUES (1, 'Nội'), (2, 'Ngoại');
INSERT INTO Invoices VALUES (101, 1, 1, 500.00), (102, 2, 1, 300.00), (103, 3, 2,
1000.00);

CREATE VIEW Department_Revenue_View AS 
SELECT D.Dept_Name, COUNT(I.Patient_ID) count_pi, SUM(I.Amount) sum_a FROM Departments D
JOIN Invoices I ON D.Dept_ID = I.Dept_ID
GROUP BY D.Dept_Name;