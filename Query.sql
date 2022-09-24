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
    
    select fname, lname, dno from employee order by dno;
    
    select fname, lname, dno from employee;
    
    select fname, lname, dno from employee order by dno desc;
    
    select * from employee order by fname, lname;
    
    select distinct d.dname, concat(e.fname, ' ', e.lname) as Manager, address
    from department as d, employee e, works_on as w, project p 
    where (d.dnumber = e.dno and e.ssn = d.mgr_ssn and w.pno = p.pnumber)
    order by d.dname, e.fname, e.lname;
    
    select distinct d.dname as department, concat(e.fname, ' ', e.lname) as employee, p.pname as project_name
    from department as d, employee e, works_on w, project p
    where (d.dnumber = e.dno and e.ssn = w.essn and w.pno = p.pnumber)
    order by d.dname desc, e.fname asc, e.lname asc;
    
    select * from employee;
    select count(*) from employee;
    select count(*) from employee, department where dno=dnumber and dname = 'Research';
    
    select dno, count(*) as number_of_employees, round(avg(salary),2) as salary_avg from employee group by dno;
    
    select pnumber, pname, count(*) from project, works_on where pnumber = pno group by pnumber, pname;
    
    select count(distinct salary) from employee;
    
    select sum(salary) as total_sal, max(salary) as max_sal, min(salary) min_sal, avg(salary) avg_sal from employee;
    
    select sum(salary) as total_sal, max(salary) as max_sal, min(salary) min_sal, avg(salary) avg_sal from (employee join department on dno = dnumber)
    where dname = 'Research';
    
    select lname, fname from employee where
    (select count(*) from dependent where ssn = essn) >= 2;
    
    select pnumber, pname, count(*) number_register, round(avg(salary),2) avg_salary from project, works_on, employee where pnumber = pno and ssn = essn group by dno order by avg_salary desc;
    
    
    select pnumber, pname, count(*)
    from project, works_on
    where pnumber = pno
    group by pnumber, pname
    having count(*) < 2;
    
    select dno, count(*)
    from employee
    where salary > 40000
    group by dno
    having count(*) > 1;
    
    select dno, count(*) from employee
    where salary > 20000 and dno in (select dno from employee group by dno having count(*) > 5)
    group by dno;
    
    show databases;
    use company_constraints;
    
    show tables;
    
    select fname, salary, dno from employee;
    
    update employee set salary =
    case 
		when dno = 5 then salary + 2000
        when dno = 4 then salary + 1500
        when dno = 1 then salary + 3000
        else salary + 0
	end;
    
    desc employee;
    desc works_on;

select * from employee, works_on where ssn = essn;
select * from employee join works_on on ssn = essn; 

select * from employee join department on ssn = mgr_ssn; 

select fname, lname, address from (employee join department on dno=dnumber) where dname = 'Research';

select * from dept_locations;
select * from department;

select dname as Department, dept_create_date as StartDate, dlocation as Location from department inner join dept_locations using (dnumber) order by StartDate;

select * from employee cross join dependent;

select concat(fname, ' ', lname) as Complete_Name, dno as DeptNumber, pname as ProjectName, pno as ProjectNumber, plocation as Location from employee 
	inner join works_on on ssn = essn 
    inner join project on pno = pnumber
    where pname like 'Product%' 
    order by pnumber;
    
select dnumber, dname, concat(fname, ' ', lname) as Manager, salary, round(salary*0.05,2) as Bonus  from department 
	inner join dept_locations using (dnumber)
    inner join employee on ssn = mgr_ssn
    group by dnumber
    having count(*) > 1;
    
    select dnumber, dname, concat(fname, ' ', lname) as Manager, salary, round(salary*0.05,2) as Bonus  from department 
	inner join dept_locations using (dnumber)
    inner join (dependent inner join employee on ssn = essn) on ssn = mgr_ssn
    group by dnumber
    having count(*) > 1;
    
        select dnumber, dname, concat(fname, ' ', lname) as Manager, salary, round(salary*0.05,2) as Bonus  from department 
	inner join dept_locations using (dnumber)
    inner join (dependent inner join employee on ssn = essn) on ssn = mgr_ssn
    group by dnumber;
    
select * from employee;
select * from dependent;
select * from employee inner join dependent on ssn = essn;
select * from employee join dependent on ssn = essn;
select * from employee left join dependent on ssn = essn;
select * from employee left outer join dependent on ssn = essn;
drop database ecommerce;
create database ecommerce;

use ecommerce;

create table clients(
	idClient int auto_increment primary key,
    fname varchar(10),
    minit char(3),
    lname varchar(20),
    cpf char(11) not null,
    address varchar(30),
    constraint unique_cpf_client unique (cpf)
);

create table product(
	idProduct int auto_increment primary key,
    pname varchar(10) not null,
    classification_kids boolean default false,
    category enum('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis') not null,
    avaliacao float default 0,
    size varchar(10)
);

create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartao','Dois cartoes'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

drop table orders;
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
);

create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    cnpj char(15) not null,
    contact varchar(11) not null,
    constraint unique_supplier unique(cnpj)
);

create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not null,
    abstName varchar(255),
    cnpj char(15),
    cpf char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique(cnpj),
    constraint unique_cpf_seller unique(cpf)
);

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key(idPseller,idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponivel',
    primary key(idPOproduct,idPOorder),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key(idLproduct,idLstorage),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct)
);

show tables;

use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';
use ecommerce;
insert into clients (fname, minit, lname, cpf, address) values
	('Maria','M','Silva',123456789, 'rua silva de prata 29'),
    ('Matheus','M','Silva',123456781, 'rua silva de prata 29'),
    ('Ricardo','M','Silva',123456782, 'rua silva de prata 29'),
    ('Julia','M','Silva',123456783, 'rua silva de prata 29'),
    ('Roberta','M','Silva',123456784, 'rua silva de prata 29'),
    ('Isabela','M','Silva',123456785, 'rua silva de prata 29');
    
    insert into product (pname, classification_kids, category, avaliacao, size) values
		('Fone',false, 'Eletronico','4',null),
        ('Barbie',false, 'Eletronico','4',null),
        ('Body',false, 'Eletronico','4',null),
        ('Microfone',false, 'Eletronico','4',null),
        ('Sofá',false, 'Eletronico','4',null);
select * from clients;
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
	(7,default,'app',null,1),
    (8,default,'app',null,1),
    (9,'Confirmado','app',null,1),
    (10,default,'app',null,1);
    
    select * from orders;
    select * from product;

desc productOrder;
insert into productOrder (idPOproduct,idPOorder,poQuantity,poStatus) values
(1,13,2,null),
(2,14,1,null),
(3,15,1,null);

insert into productStorage (storageLocation, quantity) values
('Rio de Janeiro',1000),
('Rio de Janeiro',1000),
('Rio de Janeiro',1000),
('Rio de Janeiro',1000),
('Rio de Janeiro',1000),
('Rio de Janeiro',1000);

insert into storageLocation (idLproduct, idLstorage, location) values 
(1,2,'RJ'),
(2,6,'GO');

insert into supplier (socialName, cnpj, contact) values 
('Almeida e filhos',123456789123456,'21985474'),
('Almeida e filhos',123456789123452,'21985474'),
('Almeida e filhos',123456789123453,'21985474');
select * from supplier;
select * from product;
show tables;
desc productSupplier;
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
(4,1,500),
(5,2,400),
(6,4,633),
(4,3,5),
(5,5,10);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int default 1,
    primary key(idPsSupplier,idPsProduct),
    constraint fk_productsupplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_productsupplier_product foreign key (idPsProduct) references product(idProduct)
);

insert into seller (socialName, abstName, cnpj, cpf, location, contact) values 
	('Tech eletronics',null, 123456789456321,null,'Rio de Janeiro',219946287),
    ('Botique Durgas',null, null,null,'Rio de Janeiro',219946287),
    ('Tech eletronics',null, 123456789456325,null,'Rio de Janeiro',219946287);
    select * from product;
    insert into productSeller (idPseller, idPproduct, prodQuantity) values
    (4,1,80),
    (5,2,10);
    
    select count(*) from clients;
    
    select * from clients c, orders o where c.idClient = idOrderClient;
    
    select fname, lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
    select concat(fname, ' ', lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;
    
    select * from clients;
    show tables;
    desc orders;
    insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
	(7,default,'app',null,1);
    
    select count(*) from clients c, orders o 
		where c.idClient = idOrderClient;
        
        
        
        select *
			from clients 
			INNER JOIN orders ON idClient = idOrderClient
            inner join productOrder p on p.idPOorder = idOrder
			group by idClient;
            
            show tables;
            
            desc payments;
            
            select * from payments;
            
create table delivery(
	idDelivery int auto_increment primary key,
	idOrder int,
	status enum('To do','Doing','Done') default 'To do',
	trackCode int,
	constraint fk_orders_delivery foreign key (idOrder) references orders(idOrder)
);

select idClient, fname, count(*) as Number_of_orders from clients INNER JOIN orders ON idClient = idOrderClient
        group by idClient;
        
        show tables;
        
        desc seller;
        desc supplier;
        select * from seller;
        select * from supplier;
        
        select * from seller s inner join supplier p on s.cnpj = p.cnpj;
        select * from productsupplier;
        select * from product;
        select * from supplier;
        select * from productstorage;
        
        desc product;
        desc productsupplier;
        
        select * from product p 
        inner join productsupplier s on p.idProduct = s.idPsProduct
        inner join productstorage e on p.idProduct = e.idProdStorage;
        
        select * from product;
        select * from productsupplier;
        select * from supplier;
        
        select pname, socialName  from product p 
        inner join productsupplier on idPsProduct = p.idProduct
        inner join supplier s on idPsSupplier = s.idSupplier;
        
        show tables;
        drop table client;
        
        create database workshop;
        use workshop;
        show tables;
create table client(
	idClient int auto_increment primary key,
	name varchar(45) not null,
	phone varchar(45),
	email varchar(45),
    endereco varchar(45),
    cpf varchar(45)
);

create table vehicle(
	idVehicle int auto_increment primary key,
	license varchar(45) not null,
	brand varchar(45),
	model varchar(45),
    year varchar(45),
    color varchar(45),
    type varchar(45),
    idClient int,
    idOS int,
    constraint fk_vehicle_client foreign key (idClient) references client(idClient),
    constraint fk_vehicle_os foreign key (idOS) references os(idOS)
);

create table vehicleMechanical(
	idVehicle int,
	idMechanical int,
    primary key(idVehicle,idMechanical),
    constraint fk_vehicleMechanical_vehicle foreign key (idVehicle) references vehicle(idVehicle),
    constraint fk_vehicleMechanical_mechanical foreign key (idMechanical) references mechanical(idMechanical)
);

create table mechanical(
	idMechanical int auto_increment primary key,
	name varchar(45),
    cpf varchar(45),
    email varchar(45),
    phone varchar(45),
    address varchar(45),
    admissionDate datetime,
    specialty varchar(45)
);

create table vehicleWorkshop(
	idVehicle int,
	idWorkshop int,
    primary key(idVehicle,idWorkshop),
    constraint fk_vehicleWorkshop_vehicle foreign key (idVehicle) references vehicle(idVehicle),
    constraint fk_vehicleWorkshop_workshop foreign key (idWorkshop) references workshop(idWorkshop)
);

create table workshop(
	idWorkshop int auto_increment primary key,
	name varchar(45),
    cnpj varchar(45),
    email varchar(45),
    phone varchar(45),
    address varchar(45)
);

create table os(
	idOS int auto_increment primary key,
	value double,
    deliveryDate datetime,
    authorized boolean,
    issueDate datetime,
    status varchar(45)
);

create table osPiece(
	idOS int,
	idPiece int,
    primary key(idOS,idPiece),
    constraint fk_osPiece_os foreign key (idOS) references os(idOS),
    constraint fk_osPiece_piece foreign key (idPiece) references piece(idPiece)
);

create table piece(
	idPiece int auto_increment primary key,
	name varchar(45),
    value double
);

create table serviceVehicle(
	idService int,
	idVehicle int,
    primary key(idService,idVehicle),
    constraint fk_serviceVehicle_service foreign key (idService) references service(idService),
    constraint fk_serviceVehicle_vehicle foreign key (idVehicle) references vehicle(idVehicle)
);

create table service(
	idService int auto_increment primary key,
	name varchar(45),
    value double,
    idManPower int,
    constraint fk_service_manpower foreign key (idManPower) references manpower(idManPower)
);

create table manpower(
	idManPower int auto_increment primary key,
	name varchar(45),
    value double
);

show tables;

desc os;
insert into client (name,
phone,
email,
endereco,
cpf) values ('Rafael','12312313','asdasd@asdas.com','sdaasd','123123123');

insert into manpower (name,
value) values ('Consertar carro', 300);

insert into mechanical (name,
cpf,
email,
phone,
address,
admissionDate,
specialty) values ('Jose','123123123','asdas@asdasd.com','123123123','asdadsasds',now(),'Pintura');

insert into os (value,
deliveryDate,
authorized,
issueDate,
status) values (300,now(),true,now(),'DONE');

desc service;
select * from piece;
insert into ospiece (idOS,
idPiece) values (1,1);

insert into piece (name,
value) values ('Parafuso',5);
show tables;
select * from manpower;
insert into service (name,
value,
idManPower) values ('Pintura', 200, 1);
desc vehiclemechanical;
select * from mechanical;
insert into servicevehicle (idService,
idVehicle) values (1,1);
insert into vehicle (license,
brand,
model,
year,
color,
type,
idClient,
idOS) values ('asdasd','bmw','bmw','1990','blue','new',1,1);

insert into vehiclemechanical (idVehicle,
idMechanical) values (1,1);
desc vehicleworkshop;
insert into vehicleworkshop (idVehicle,
idWorkshop) values (1,1);
desc workshop;
insert into workshop (name,
cnpj,
email,
phone,
address) values ('Bras','123123123','asdasd@asdasd.com','12312331','rua asdasd');

select * from mechanical;

select * from mechanical where name = 'Jose';

select * from mechanical where name = 'Jose' order by name;

select * from mechanical group by specialty having count(*) > 0;

show tables;

select c.name, v.license from client c 
inner join vehicle v on c.idClient = v.idClient;







        
        
        
        

        
    
    
    
    
    
    
    
    
    
    
    

