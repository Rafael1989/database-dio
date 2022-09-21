show databases;

create database if not exists first_example;

use first_example;

show tables;

CREATE TABLE if not exists person(person_id smallint unsigned,
fname varchar(20),
lname varchar(20),
gender enum('M','F'),
birth_date DATE,
street varchar(30),
city varchar(20),
state varchar(20),
country varchar(20),
postal_code varchar(20),
constraint pk_person primary key(person_id)
);

show tables;

desc person;
desc favorite_food;

create table if not exists favorite_food(
	person_id smallint unsigned,
    food varchar(20),
    constraint pk_favorite_food primary key (person_id, food),
    constraint fk_favorite_food_person_id foreign key(person_id) references person(person_id)
);

desc information_schema.table_constraints;

select * from information_schema.table_constraints where constraint_schema = 'first_example';
select CONSTRAINT_NAME from information_schema.table_constraints where table_name = 'person';

desc person;

insert into person values ('1','Carolina','Silva','F','1979-08-21','rua tal','Cidade J','RJ', 'Brasil', '26054-89');
insert into person values ('2','Carolina','Silva','F','1979-08-21','rua tal','Cidade J','RJ', 'Brasil', '26054-89');
insert into person values ('3','Carolina','Silva','F','1979-08-21','rua tal','Cidade J','RJ', 'Brasil', '26054-89'),
('4','Carolina','Silva','F','1979-08-21','rua tal','Cidade J','RJ', 'Brasil', '26054-89');
insert into person values ('5','Roberta','Silva','F','1979-08-21','rua tal','Cidade J','RJ', 'Brasil', '26054-89'),
('6','Luiz','Silva','F','1979-08-21','rua tal','Cidade J','RJ', 'Brasil', '26054-89');

select * from person;

delete from person where person_id = 2 or person_id = 3 or person_id = 4;

insert into favorite_food values (1, 'lasanha'),(5, 'carne assada'), (6, 'fetuccine');
select * from favorite_food;

select now();

create schema if not exists company;
create table company.employee(
	fname varchar(15) not null,
    minit char,
    lname varchar(15) not null,
    ssn char(9) not null,
    bdate date,
    address varchar(30),
    sex char,
    salary decimal(10,2),
    super_ssn char(9),
    dno int not null,
    primary key(ssn)
);

use company;
create table company.department(
dname varchar(15) not null,
dnumber int not null,
mgr_ssn char(9),
mgr_start_date date,
primary key(dnumber),
unique(dname),
foreign key (mgr_ssn) references employee(ssn)
);

create table company.dept_locations(
	dnumber int not null,
    dlocation varchar(15) not null,
    primary key(dnumber, dlocation),
    foreign key(dnumber) references department(dnumber)
);

create table company.project(
pname varchar(15) not null,
pnumber int not null,
plocation varchar(15),
dnum int not null,
primary key(pnumber),
unique(pname),
foreign key(dnum) references department(dnumber)
);

create table company.works_on(
	essn char(9) not null,
    pno int not null,
    hours decimal(3,1) not null,
    primary key(essn, pno),
    foreign key(essn) references employee(ssn),
    foreign key(pno) references project(pnumber)
);

create table company.dependent(
	essn char(9) not null,
    dependent_name varchar(15) not null,
    sex char,
    bdate date,
    relationship varchar(3),
    primary key(essn, dependent_name),
    foreign key(essn) references employee(ssn)
);


show tables;

desc department;
desc employee;
desc works_on;
desc dependent;

select * from information_schema.table_constraints where constraint_schema = 'company';
select * from information_schema.referential_constraints where constraint_schema = 'company';

drop database company_constraints;
create schema if not exists company_constraints;
create table company_constraints.employee(
	fname varchar(15) not null,
    minit char,
    lname varchar(15) not null,
    ssn char(9) not null,
    bdate date,
    address varchar(30),
    sex char,
    salary decimal(10,2),
    super_ssn char(9),
    dno int not null,
    constraint chk_salary_employee check (salary > 2000.0),
    constraint pk_employee primary key(ssn)
);


create table company_constraints.department(
dname varchar(15) not null,
dnumber int not null,
mgr_ssn char(9),
mgr_start_date date,
Dept_create_date date,
constraint chk_date_dept check (Dept_create_date < mgr_start_date),
constraint pk_dept primary key(dnumber),
constraint unique_name_dept unique(dname),
foreign key (mgr_ssn) references employee(ssn)
);

desc company_constraints.department;

create table company_constraints.dept_locations(
	dnumber int not null,
    dlocation varchar(15) not null,
    constraint pk_dept_locations primary key(dnumber, dlocation),
    constraint fk_dept_locations foreign key(dnumber) references department(dnumber)
);

create table company_constraints.project(
pname varchar(15) not null,
pnumber int not null,
plocation varchar(15),
dnum int not null,
primary key(pnumber),
constraint unique_project unique(pname),
constraint fk_project foreign key(dnum) references department(dnumber)
);

create table company_constraints.works_on(
	essn char(9) not null,
    pno int not null,
    hours decimal(3,1) not null,
    primary key(essn, pno),
    constraint fk_employee_works_on foreign key(essn) references employee(ssn),
    constraint fk_project_works_on foreign key(pno) references project(pnumber)
);

drop table company_constraints.dependent;
create table company_constraints.dependent(
	essn char(9) not null,
    dependent_name varchar(15) not null,
    sex char,
    bdate date,
    relationship varchar(3),
    primary key(essn, dependent_name),
    constraint fk_dependent foreign key(essn) references employee(ssn)
);

select * from information_schema.table_constraints where constraint_schema = 'company_constraints';

alter table company_constraints.employee 
	add constraint fk_employee
    foreign key(super_ssn) references company_constraints.employee(ssn)
    on delete set null
    on update cascade;
    
    alter table company_constraints.dept_locations drop constraint fk_dept_locations;
    alter table company_constraints.department add constraint fk_dept foreign key(mgr_ssn) references company_constraints.employee(ssn) on update cascade;
    alter table company_constraints.dept_locations add constraint fk_dept_locations foreign key (dnumber) references company_constraints.department(dnumber) on delete cascade on update cascade;
    
    use company_constraints;
    
    show tables;
    
    insert into employee values('John','B','Smith',123456789,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5);
    
    insert into employee values('Franklin','B','Smith',123456781,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5),
    ('Alicia','B','Smith',123456782,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5),
    ('Jennifer','B','Smith',123456783,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5),
    ('Ramesh','B','Smith',123456784,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5),
    ('Joyce','B','Smith',123456785,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5),
    ('Ahmad','B','Smith',123456786,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5),
    ('James','B','Smith',123456787,'1965-01-09','711-Fondren-Houston-TX','M',50000,null,5);
    
    
    select * from employee;
    
    insert into dependent values (123456782,'Alice','F','1984-04-05','Dau'),
    (123456781,'Theodore','F','1984-04-05','Dau'),
    (123456783,'Joy','F','1984-04-05','Dau'),
    (123456784,'Abner','F','1984-04-05','Dau'),
    (123456785,'Michael','F','1984-04-05','Dau'),
    (123456786,'Alice','F','1984-04-05','Dau');
    
    select * from dependent;
    
    desc dependent;
    
    insert into department values ('Research',5,123456781,'1988-05-22','1986-05-22'),
    ('Administration',6,123456781,'1988-05-22','1986-05-22'),
    ('Headquarters',7,123456781,'1988-05-22','1986-05-22');
    
    insert into dept_locations values (5, 'Houston'),
    (6, 'Stafford'),
    (7, 'Bellaire'),
    (7, 'Sugarland'),
    (7, 'Houston');
    
    insert into project values ('Product',1,'Bellaire',5),
    ('Product1',2,'Bellaire',5),
    ('Product2',3,'Bellaire',5),
    ('Product3',4,'Bellaire',5),
    ('Product4',5,'Bellaire',5),
    ('Product5',6,'Bellaire',5);
    
    insert into works_on values (123456781,5,32.5),
    (123456781,6,32.5),
    (123456781,2,32.5),
    (123456783,5,32.5);
    
    desc works_on;
    
    show tables;
    select * from dependent;
    
select * from dependent;
select * from dept_locations;
select * from employee;
select * from project;
select * from works_on;

show databases;
load data infile 'path' into table employee fields terminated by ',' lines terminated by ';';
use company_constraints;
select fname, lname, salary, salary * 0.11 as INSS from employee;

desc employee;

select concat(fname, ' ',minit,' ',lname) as Complete_name from employee;

select fname, lname, salary, salary * 0.011 as INSS from employee;
select fname, lname, salary, round(salary * 0.011,2) as INSS from employee;

select concat(fname, ' ', lname) as Complete_name, salary, salary * 1.1 as inscreased_salary  from employee e, works_on as w, project as p where (e.ssn = w.essn and w.pno = p.pnumber and p.pname='Product1');

select concat(fname, ' ', lname) as Complete_name, salary, round(1.1 * salary,2)  as inscreased_salary  from employee e, works_on as w, project as p where (e.ssn = w.essn and w.pno = p.pnumber and p.pname='Product1');

desc department;

select fname, lname, address from employee where address like '%711-Fondren%';
select fname, lname, address from employee where address like '_11-Fondren%';
select fname, lname, address from employee where address like '71_-Fondren%';

select * from employee where (salary between 30000 and 60000) and dno =5;

desc dept_locations;
select * from dept_locations;
select dname as Department_name, concat(fname, ' ', lname), mgr_ssn as Manager, address from department d, dept_locations l, employee e where d.dnumber = l.dnumber and dlocation = 'Stafford';

select dname as Department_name, concat(fname, ' ', lname), mgr_ssn as Manager, address, dlocation from department d, dept_locations l, employee e where d.dnumber = l.dnumber and mgr_ssn = e.ssn;

desc project;
select pnumber, dnum, lname, address, bdate, p.plocation  from department d, project p, employee e where d.dnumber = p.dnum and p.plocation = 'Bellaire' and mgr_ssn = e.ssn;

select * from employee;

select concat(fname, ' ', lname) Complete_Name, dname as department_name from employee, department where (dno = dnumber and address like '%Houston%');
select concat(fname, ' ', lname) Complete_Name, address from employee, department where (address like '%Houston%');

select fname, lname from employee where (salary > 30000 and salary < 60000);

select fname, lname, salary from employee where (salary between 20000 and 60000);


select bdate, address from employee where fname = 'John' and minit = 'B' and lname = 'Smith';

select * from department where dname = 'Research' or dname = 'Administration';
select concat(fname, ' ', lname) as Complete_name from employee, department where dname = 'Research' and dnumber = dno;

(select distinct pnumber from project, department, employee where dnum = dnumber and mgr_ssn = ssn and lname = 'Smith')
UNION
(select distinct pnumber from project, works_on, employee where pnumber = pno and essn = ssn and lname = 'Smith');

create database teste;

use teste;

create table R(
	A char(2)
    );
    
    create table S(
    A char(2)
    );
    
    insert into R(A) values ('a1'),('a2'),('a2'),('a3');
    insert into S(A) values ('a1'),('a1'),('a2'),('a3'),('a4'),('a5');
    
    select * from R;
    select * from S;
    
    select * from S where A not in (select A from R);
    
    (select distinct R.A from R)
    UNION
    (select distinct S.A from S);
    
     (select R.A from R)
    UNION
    (select S.A from S);
    
    select distinct R.A from R where R.A in (select S.A from S);
    
    select distinct pnumber
    from project
    where pnumber in 
    (select pnumber
    from project, department, employee
    where dnum = dnumber and 
    mgr_ssn = ssn and lname = 'Smith')
    or
    pnumber in 
    (select pno
    from works_on, employee
    where essn = ssn and lname = 'Smith');
    
    select e.fname, e.lname from employee as e where exists (
    select * from dependent as d where e.ssn = d.essn and e.sex = d.sex and e.fname = d.dependent_name);
    
    
    use company_constraints;
    select distinct pnumber from project where pnumber in 
    (select distinct pno from works_on, employee where (essn = ssn and lname = 'Smith')
     or
    (select pnumber from project, department, employee where (mgr_ssn = ssn and lname = 'Wallace' and dnum = dnumber))
    );
    
    select pno, hours,essn from works_on;
    
    select distinct * from works_on where (pno, hours) in (select pno, hours from works_on where essn = 123456781);
    
    select e.fname, e.lname, d.dependent_name from employee as e, dependent d where exists (select * from dependent as d where e.ssn = d.essn and Relationship = 'dau');
    
    select e.fname, e.lname, d.dependent_name from employee as e, dependent d where not exists (select * from dependent as d where e.ssn = d.essn and Relationship = 'dau');
    
    select e.fname, e.lname from employee as e, department d where (e.ssn = d.mgr_ssn) and exists (select * from dependent as d where e.ssn = d.essn);
    
    
    select fname, lname from employee where (select count(*) from dependent where ssn=essn)>0;
    
    select distinct essn, pno from works_on where pno in (1,2,3);
    
    
    

