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

load data infile 'path' into table employee fields terminated by ',' lines terminated by ';';

select * from employee;
select ssn, fname, dname from employee e, department d where (e.ssn = d.mgr_ssn);

select fname, dependent_name, relationship from employee, dependent where essn = ssn;

select bdate, address from employee where fname = 'John' and minit = 'B' and lname = 'Smith';

select * from department where dname = 'Research';

select fname, lname, address from employee, department where dname = 'Research' and dnumber = dno;

desc works_on;
select * from project;

select pname, essn, fname, hours from project, works_on, employee where pnumber = pno and essn = ssn;

select fname, employee.fname, address from employee, department where department.dname = 'Research' and department.dnumber = employee.dno;

select employee.fname, employee.lname, employee.address from employee, department where department.dname = 'Research' and department.dnumber = employee.dno;

select e.fname, e.lname, s.fname, s.lname from employee as e, employee as s where e.super_ssn = s.ssn;

select e.fname, e.lname, e.address from employee as e, department as d where d.dname = 'Research' and d.dnumber = e.dno;

use company_constraints;
show tables;

desc department;
desc dept_locations;

select * from department;
select * from dept_locations;

select dname as department_name, l.dlocation from department as d, dept_locations as l where d.dnumber = l.dnumber;

select * from employee;
select concat(fname, ' ', lname) as Employee from employee;
use first_example;
desc person;
update person set birth_date = str_to_date('DEC-21-1980', '%b-%d-%Y') where person_id = 1;

select now() as Timestamp;

create database if not exists manipulation;

use manipulation;

create table bankAccounts (
id_account int auto_increment primary key,
ag_num int not null,
ac_num int not null,
saldo float,
constraint identification_account_constraint unique (ag_num, ac_num)
);

drop table bankClient;
create table bankClient(
id_client int auto_increment,
clientAccount int,
cpf char(11) not null,
rg char(9) not null,
nome varchar(50) not null,
endereco varchar(100) not null,
renda_mensal float,
primary key(id_client, clientAccount),
constraint fk_account_client foreign key (clientAccount) references bankAccounts(id_account)
on update cascade
);

create table bankTransactions(
id_transaction int auto_increment primary key,
ocorrencia datetime,
status_transaction varchar(20),
valor_transferido float,
source_account int,
destination_account int,
constraint fk_source_transaction foreign key (source_account) references bankAccounts(id_account),
constraint fk_destination_transaction foreign key (destination_account) references bankAccounts(id_account)
);

drop table bankClient;

alter table bankAccounts add limiteCredito float not null default 500.00;

alter table bankAccounts add email varchar(60);
alter table bankAccounts drop email;

desc bankAccounts;

alter table bankClient add UF char(2) not null default 'RJ';
update bankClient set UF = 'MG' where nome = 'Fulano';

select * from bankClient;

insert into bankClient (clientAccount,cpf,rg,nome,endereco,renda_mensal) values(1,12345678912,123456578,'Fulano','rua de lá',6500.6);



insert into bankAccounts (ag_num,ac_num,saldo) values (156,264358,0);
select * from bankAccounts;
select * from bankClient;


 


