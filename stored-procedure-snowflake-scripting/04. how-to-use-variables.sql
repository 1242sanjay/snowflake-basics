-- 1.0 Numeric variables
-- define a procedure
CREATE OR REPLACE PROCEDURE my_procedure()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS 
DECLARE
    -- 3 global variable defined
    gross_salary number(10, 2);
    tax_percentage number(10, 2) default 0.33;
    taxable_salary number(10, 2);
BEGIN
    -- gross salary
    gross_salary := 120000;

    -- taxable salary calculation
    taxable_salary := gross_salary * tax_percentage;

    -- return the taxable salary
    return taxable_salary;
END;

show procedures like '%my_procedure%';
desc procedure my_procedure();

call my_procedure();

-- 2.0 String/Text variable
create or replace temporary table customer_table(
    cust_id number,
    cust_name text,
    inactive_flag number(1)
);

insert into customer_table values 
(1, 'Cust-1', 1),
(2, 'Cust-2', -1),
(3, 'Cust-3', -1),
(4, 'Cust-4', -1),
(5, 'Cust-5', 1);

-- check customer count
select inactive_flag, count(1) from customer_table group by inactive_flag;

-- lets create a stored procedure
CREATE OR REPLACE PROCEDURE delete_inactive_customer()
RETURNS text
LANGUAGE SQL
AS
DECLARE
    -- 1 global variable defined
    flag_val number(1) default -1;
    
BEGIN

    LET sql_statement := 'delete from customer_table where inactive_flag  = ' || flag_val;

    execute immediate sql_statement;

    -- return the taxable salary
    return 'Inactive customers deleted successfully';
END;


desc procedure delete_inactive_customer();

call delete_inactive_customer();

-- check customer count
select inactive_flag, count(1) from customer_table group by inactive_flag;


-- 3.0 Colon Notation and Identifier Function
create or replace temporary table employee_table(
    id number,
    gross_salary number(10, 2)
);

insert into employee_table values 
(1000, 150000),
(1001, 160000),
(1002, 170000);

-- lets create stored procedure
CREATE OR REPLACE PROCEDURE my_procedure_colon()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    -- 3 global variable defined
    emp_id number(5) default 1000;
    tax_percentage number(2, 2) default 0.33;
    taxable_salary number(10, 2);
BEGIN
    -- gross salary
    LET gross_salary number(10, 2) default (select gross_salary from employee_table where id = :emp_id);

    -- taxable salary calculation
    taxable_salary := gross_salary * tax_percentage;

    -- return the taxable salary
    return taxable_salary;
END;


desc procedure my_procedure_colon();

call my_procedure_colon();



-- lets create stored procedure
CREATE OR REPLACE PROCEDURE my_procedure_colon_and_identifier()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    -- 4 global variable defined
    table_name text default 'employee_table';
    pk_val number(5) default 1000;
    tax_percentage number(2, 2) default 0.33;
    taxable_salary number(10, 2);
BEGIN
    -- gross salary
    LET gross_salary number(10, 2) default (select gross_salary from identifier(:table_name) where id = :pk_val);

    -- taxable salary calculation
    taxable_salary := gross_salary * tax_percentage;

    -- return the taxable salary
    return taxable_salary;
END;


desc procedure my_procedure_colon_and_identifier();

call my_procedure_colon_and_identifier();
    
