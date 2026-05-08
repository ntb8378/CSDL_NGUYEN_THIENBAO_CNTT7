-- câu 1

create database CompanyDB;
use CompanyDB;

create table Department(
	dept_id INT PRIMARY KEY AUTO_INCREMENT ,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

create table Employee(
	emp_id INT PRIMARY KEY AUTO_INCREMENT ,
    emp_name VARCHAR(100) NOT NULL,
    gender INT DEFAULT (1),
    birth_date DATE,
    salary DECIMAL,
    dept_id INT,
    FOREIGN KEY (dept_id)
    references Department(dept_id)
    ON UPDATE CASCADE
);

create table Project(
	project_id INT PRIMARY KEY AUTO_INCREMENT ,
    project_name VARCHAR(150) NOT NULL,
	start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE,
    emp_id INT ,
	FOREIGN KEY (emp_id)
    references Employee(emp_id)
);

-- câu 2

alter table Employee
add column email VARCHAR(100) UNIQUE;

alter table Project
modify project_name VARCHAR(200) ;



-- câu 3
insert into Department (dept_id,dept_name,location)
values 
(1 ,'IT' , 'Ha Noi'),
(2, 'HR', 'HCM'),
(3, 'Marketing', 'Da Nang');

insert into Employee (emp_id, emp_name,gender, birth_date,salary,dept_id,email)
values (1, 'Nguyen Van A', 1, '1990-01-15', 1500,1, 'a@gmail.com'),
(2, 'Tran Thi B', 0, '1995-05-20', 1200,1, 'b@gmail.com'),
(3, 'Le Minh C', 1, '1988-10-10', 2000,2, 'c@gmail.com'),
(4, 'Pham Thi D', 0, '1992-12-05', 1800,3, 'd@gmail.com');

insert into Project (project_id,project_name,emp_id,start_date,end_date)
values (101, 'Website Redesign', 1, '2024-01-01','2024-06-01'),
(102, 'Recruitment System', 3, '2024-02-01', '2024-06-01'),
(103, 'Marketing Campaign', 4, '2024-03-01', null);


update Employee
set salary = salary+ 200
where dept_id = 1;

update Project
set end_date = '2024-12-31'
where end_date is null;

DELETE FROM Project WHERE start_date < '2024-02-01';

-- câu 4

select emp_name, email , check gender in ()