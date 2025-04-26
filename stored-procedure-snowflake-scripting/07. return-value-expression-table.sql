-- PART A
-- No return statement in the stored procedure
CREATE OR REPLACE PROCEDURE my_proc_no_return()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    gross_salary number(10, 2);
    tax_percentage number(2, 2);
    taxable_salary number(10, 2);
BEGIN
    gross_salary := 120000;
    taxable_salary := gross_salary * tax_percentage;
END;

desc procedure my_proc_no_return();
call my_proc_no_return();


-- PART B
-- returning a value
CREATE OR REPLACE PROCEDURE my_proc_return_value()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    gross_salary number(10, 2);
    tax_percentage number(2, 2) default 0.33;
    taxable_salary number(10, 2);
BEGIN
    gross_salary := 120000;
    taxable_salary := gross_salary * tax_percentage;
    
    RETURN taxable_salary;
END;

desc procedure my_proc_return_value();
call my_proc_return_value();

-- returning a expression
CREATE OR REPLACE PROCEDURE my_proc_return_expression()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    gross_salary number(10, 2);
    tax_percentage number(2, 2) default 0.33;
    taxable_salary number(10, 2);
BEGIN
    gross_salary := 120000;
    
    -- RETURN (gross_salary * tax_percentage);
    RETURN (select max(c_acctbal) from snowflake_sample_data.tpch_sf1.customer);
END;

desc procedure my_proc_return_expression();
call my_proc_return_expression();



-- returning a table
CREATE OR REPLACE PROCEDURE my_proc_return_table()
RETURNS Table(role_name text, database_name text, schema_name text)
LANGUAGE SQL
AS
DECLARE
    my_result resultset default (select current_role(), current_database(), current_schema());
BEGIN
    RETURN table(my_result);
END;

desc procedure my_proc_return_table();
call my_proc_return_table();

