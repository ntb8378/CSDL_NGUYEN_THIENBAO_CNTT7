create database hospital_db;
use hospital_db;

CREATE TABLE Patients (
Patient_ID INT PRIMARY KEY,
Full_Name VARCHAR(100),
Age INT,
Room_Number INT,
HIV_Status VARCHAR(50),
Mental_Health_History VARCHAR(255)
);
-- Chèn một số dữ liệu
INSERT INTO Patients (Patient_ID, Full_Name, Age, Room_Number, HIV_Status, Mental_Health_History)
VALUES
(1, 'Minh Thu', 30, 101, 'Negative', 'None'),
(2, 'Hồng Vân', 40, 102, 'Positive', 'Anxiety'),
(3, 'Cao Cường', 25, 103, 'Negative', 'None');

create view Reception_Patient_View as 
select Patient_ID, Full_Name, Age, Room_Number
from Patients 
where age > 0 WITH CHECK OPTION ;

update Reception_Patient_View
set age = 1
where Patient_ID = 3;