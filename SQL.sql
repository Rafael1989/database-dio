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

create table company_constraints.dependent(
	essn char(9) not null,
    dependent_name varchar(15) not null,
    sex char,
    bdate date,
    relationship varchar(3),
    age int not null,
    constraint chk_age_dependent check (age < 22),
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
