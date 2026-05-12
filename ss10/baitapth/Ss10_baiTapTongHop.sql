CREATE DATABASE hospital_2_db;

USE hospital_2_db;

CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID CHAR(5),

    Heart_Rate INT CHECK (Heart_Rate > 0),

    Blood_Pressure VARCHAR(20),

    Record_Time DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_patient
        FOREIGN KEY (Patient_ID)
        REFERENCES Patients(Patient_ID)
);

-- =========================
-- DỮ LIỆU BẢNG Patients
-- =========================

INSERT INTO Patients (Patient_ID, Full_Name)
VALUES
('BN001', 'Nguyen Van An'),
('BN002', 'Tran Thi Bich'),
('BN003', 'Le Hoang Nam'),
('BN004', 'Pham Minh Quan'),
('BN005', 'Vo Thi Lan'),
('BN006', 'Dang Gia Huy'),
('BN007', 'Bui Thanh Tung'),
('BN008', 'Hoang Thu Trang'),
('BN009', 'Doan Quoc Bao'),
('BN010', 'Nguyen Thi Mai');

-- =========================
-- DỮ LIỆU BẢNG Vitals_Logs
-- =========================

INSERT INTO Vitals_Logs
(Patient_ID, Heart_Rate, Blood_Pressure)
VALUES
('BN001', 72, '120/80'),
('BN002', 88, '130/85'),
('BN003', 76, '118/78'),
('BN004', NULL, '140/90'),
('BN005', 69, '110/70'),
('BN006', 82, '125/82'),
('BN007', 90, '135/88'),
('BN008', 74, '117/76'),
('BN009', NULL, '122/81'),
('BN010', 68, '108/68');

CREATE INDEX Vitals_Logs_idx 
ON Vitals_Logs(Patient_ID,Record_Time);

DROP VIEW ER_Dashboard_View;

CREATE VIEW ER_Dashboard_View AS
SELECT p.Patient_ID,p.Full_Name,p.Admission_Time, IFNULL(vl.Heart_Rate,'Pending') AS Heart_Rate, vl.Blood_Pressure, vl.Record_Time, 
CASE
WHEN Heart_Rate BETWEEN 50 AND 120 THEN 'STABLE'
ELSE 'CRITICAL'
END AS Urgency_Level
FROM Patients p
LEFT JOIN Vitals_Logs vl
ON p.Patient_ID = vl.Patient_ID;

SHOW CREATE VIEW ER_Dashboard_View;

-- không cập nhật được 
UPDATE ER_Dashboard_View
SET Heart_Rate = NULL
WHERE Patient_ID = 'BN001';

