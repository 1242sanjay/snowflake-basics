-- Global vs Local variables
CREATE OR REPLACE PROCEDURE my_local_vs_global_sp()
RETURNS text
LANGUAGE SQL
AS
DECLARE
    global_var_01 text; -- initialized with null
    global_var_02 DEFAULT 'global-value-02'; -- ininitialized with a default text and infer text data type
    global_var_03 text DEFAULT 'global-value-03'; -- ininitialized with a text + text data type
BEGIN
    LET local_var_01 text;   -- without default value
    LET local_var_02 DEFAULT 'local_default_var'; -- with default value
    LET local_var_03 text DEFAULT 'local_default_var'; -- default + datatype

    -- built-in function as default value
    LET local_var_04 text DEFAULT current_role(); -- default + datatype

    -- select statement as default value
    LET local_var_05 number DEFAULT (select count(*) from snowflake_sample_data.tpch_sf1.customer ); -- default + select stmt

    return local_var_01;
END;

-- calling the stored procedure
call my_local_vs_global_sp();


-- Using assignment operator
-- Global vs Local variables
CREATE OR REPLACE PROCEDURE my_variable_assignment_sp()
RETURNS text
LANGUAGE SQL
AS
BEGIN
    LET local_var_01 text;  
    LET local_var_02 := 'local_var_02'; 
    LET local_var_03 text := 'local_var_03';

    return local_var_03;
END;

call my_variable_assignment_sp();


