create database if not exists company;
drop database company;
use company;

show tables;

CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR,
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(30),
    sex CHAR,
    Salary DECIMAL(10 , 2 ),
    Super_ssn CHAR(9),
    Dno INT NOT NULL,
    constraint chk_salary_employee check (Salary > 1412),
    constraint pk_employee PRIMARY KEY (Ssn)
);

alter table employee 
add constraint fk_employee 
foreign key (Super_ssn) references employee (Ssn)
on delete set null
on update cascade;

alter table employee modify Dno int not null default 1;

CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    CONSTRAINT fk_dpt FOREIGN KEY (Mgr_ssn)
        REFERENCES employee (Ssn)
);

alter table departament drop constraint fk_dpt;

alter table departament 
add constraint fk_dept 
FOREIGN KEY (Mgr_ssn) REFERENCES employee (Ssn)
on update cascade;

CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    constraint pk_dept_locations PRIMARY KEY (Dnumber , Dlocation),
    constraint fk_dept_locations FOREIGN KEY (Dnumber)
        REFERENCES departament (Dnumber)
);

alter table dept_locations drop constraint fk_dept_locations;

alter table dept_locations 
add constraint fk_dept_locations 
FOREIGN KEY (Dnumber) REFERENCES departament (Dnumber)
on delete cascade
on update cascade;

CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    constraint pk_project PRIMARY KEY (Pnumber),
    constraint unique_project UNIQUE (Pname),
    constraint fk_project FOREIGN KEY (Dnum)
        REFERENCES departament (Dnumber)
);

CREATE TABLE work_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3 , 1 ) NOT NULL,
    constraint pk_work_on PRIMARY KEY (Essn , Pno),
    constraint fk_work_on_employee FOREIGN KEY (Essn)
        REFERENCES employee (Ssn),
    constraint fk_work_on_project FOREIGN KEY (Pno)
        REFERENCES project (Pnumber)
);

create table dependent(
Essn char(9) not null,
Dependent_name varchar(15) not null,
sex char,
Bdate date,
Relationship varchar(8),
constraint pk_dependent primary key (Essn, Dependent_name),
constraint fk_dependent foreign key (Essn) references employee (Ssn)
);

drop table dependent;

show tables;

SELECT * FROM information_schema.table_constraints WHERE constraint_schema = 'company';

INSERT INTO employee VALUES ('Alice', 'B', 'Johnson', '987654321', '1985-04-12', 'Rua das Flores', 'F', 45000, null, 2);
INSERT INTO employee VALUES ('Bob', 'C', 'Brown', '123098451', '1979-12-25', 'Avenida Brasil', 'M', 50000, null, 3);
INSERT INTO employee VALUES ('Carol', 'D', 'Davis', '456123789', '1990-06-15', 'Rua Primavera', 'F', 35000, '987654321', 4);
INSERT INTO employee VALUES ('David', 'E', 'Miller', '789456123', '1983-03-18', 'Avenida Paulista', 'M', 40000, '456123789', 5);
INSERT INTO employee VALUES ('Eve', 'F', 'Garcia', '321789456', '1978-01-09', 'Rua das Acácias', 'F', 38000, '789456123', 6);
INSERT INTO employee VALUES ('Frank', 'G', 'Martinez', '654987321', '1992-10-22', 'Alameda Santos', 'M', 42000, '321789456', 1);
INSERT INTO employee VALUES ('Grace', 'H', 'Wilson', '987321654', '1987-08-30', 'Rua do Sol', 'F', 47000, '654987321', 2);
INSERT INTO employee VALUES ('Hank', 'I', 'Moore', '321654987', '1981-11-11', 'Avenida dos Autonomistas', 'M', 52000, '987321654', 3);
INSERT INTO employee VALUES ('Ivy', 'J', 'Taylor', '654321987', '1975-05-14', 'Rua do Comércio', 'F', 44000, '321654987', 4);
INSERT INTO employee VALUES ('Jack', 'K', 'Anderson', '789123654', '1980-07-23', 'Avenida Boa Viagem', 'M', 55000, '654321987', 5);

select * from employee;

insert into dependent values (987654321, 'Alice', 'F', '1985-04-05', 'Daughter');
insert into dependent values (321654987, 'Marge', 'F', '1985-04-05', 'Daughter');
insert into dependent values (987654321, 'Moe', 'M', '1985-04-05', 'Father');
insert into dependent values (654987321, 'Homer', 'M', '1985-04-05', 'Father');
insert into dependent values (789456123, 'Bart', 'M', '1985-04-05', 'Son');
insert into dependent values (456123789, 'Lisa', 'F', '1985-04-05', 'Daughter');
insert into dependent values (321789456, 'Meg', 'F', '1985-04-05', 'Daughter');

select * from dependent;

insert into departament values ('TI', 2, 654987321, '1988-03-05', '1986-09-07'),
('RH', 3, 789456123, '1995-03-05', '1994-09-07'),
('DP', 6, 123098451, '1990-03-05', '1989-09-07');

select * from departament;

insert into dept_locations values (1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

select * from dept_locations;

insert into project values ('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

select * from project;

insert into work_on values 
(789456123, 1, 30.5),
(654987321, 1, 15.0),
(987654321, 2, 10.0);

-- Gerente e seu departamento
select ssn, Fname, Dname from employee e, departament d where e.Ssn = d.Mgr_ssn;

-- Recuperando dependentes dos empregados
select Fname, Dependent_name, Relationship from employee, dependent where Essn = Ssn;

-- Recuperando um empregado específico
select Bdate, Address from employee where Fname = 'Bob' and Lname = 'Brown';

-- Recuperando departamento específico
select * from departament where Dname = 'TI';

select Fname, Lname, address from employee, departament where Dname = 'RH' and Dnumber=Dno;

select Pname, Essn, Fname, Hours from project, work_on, employee where Pnumber=Pno and Essn=Ssn;

-- Retira a ambiguidade através do alias ou AS Statement
select Dname, l.Dlocation as Location_name from departament as d, dept_locations l where d.Dnumber = l.Dnumber;

select concat(Fname, ' ', Lname) as Employee from employee;