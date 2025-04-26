-- Step-1: The basic SQL construct
create or replace schema my_db.my_schema;

create or replace transient table customer (
    customer_id int,
    salutation varchar,
    first_name varchar,
    last_name varchar,
    birth_day int,
    birth_month int,
    birth_year int,
    birth_country varchar,
    email_address varchar,
    cust_status varchar
) comment ='this is simple customer table';

insert into customer (customer_id ,salutation ,first_name ,last_name ,birth_day ,birth_month ,birth_year ,birth_country ,email_address,cust_status )
values 
(101,'Mr.', 'Cust-1','LName-1',10,12,2000,'Japan','cust-1.lname-1@gmail.com','Active'),
(102,'Mr.', 'Cust-2','LName-2',27,11,1999,'USA','cust-2.lname-2@gmail.com','Inactive'),
(103,'Mr.', 'Cust-3','LName-3',21,2,1998,'UK','cust-3.lname-3@gmail.com','Blocked'),
(104,'Mr.', 'Cust-4','LName-4',19,9,1997,'USA','cust-4.lname-4@gmail.com','Active'),
(105,'Mr.', 'Cust-5','LName-5',11,3,1997,'Canada','cust-5.lname-5@gmail.com','Unknown');

-- lets validate the data
select * from customer;


