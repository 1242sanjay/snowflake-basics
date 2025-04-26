-- DECLARE section allows us to declare variables
-- lets declare a variable with name but without assigning any data type
DECLARE 
    text_variable text;
BEGIN
    RETURN text_variable;
END;

-- with stored procedure
CREATE OR REPLACE PROCEDURE my_variable_sp()
RETURNS FLOAT
LANGUAGE SQL
AS
DECLARE 
    text_variable text;
BEGIN
    RETURN text_variable;
END;

CALL my_variable_sp();


-- Case sensitivity (below should give error)
DECLARE 
    text_variable text;
    TEXT_VARIABLE text;
    Text_Variable text;
BEGIN
    RETURN text_variable;
END;


-- Default value (text, string, varchar all belong to single text family)
DECLARE 
    text_variable default '<not-known>';
BEGIN
    RETURN text_variable;
END;

DECLARE 
    text_variable varchar default '<not-known>';
BEGIN
    RETURN text_variable;
END;

DECLARE 
    text_variable string default '<not-known>';
BEGIN
    RETURN text_variable;
END;


-- Expression with select
DECLARE 
    tbl_count number default (select count(*) from snowflake_sample_data.tpch_sf1.customer);
BEGIN
    RETURN tbl_count;
END;

-- with sp
CREATE OR REPLACE PROCEDURE my_variable_exp_select_sp()
RETURNS FLOAT
LANGUAGE SQL
AS
DECLARE 
    tbl_count number default (select count(*) from snowflake_sample_data.tpch_sf1.customer);
BEGIN
    RETURN tbl_count;
END;

call my_variable_exp_select_sp();


-- Assign variable to other variable
DECLARE 
    first_variable number default 10;
    second_variable number default first_variable;
BEGIN
    RETURN second_variable;
END;

DECLARE 
    first_variable number default 10;
    second_variable number default square(first_variable);
BEGIN
    RETURN second_variable;
END;

-- with sp
CREATE OR REPLACE PROCEDURE my_variable_to_variable_sp()
RETURNS FLOAT
LANGUAGE SQL
AS
DECLARE 
    first_variable number default 10;
    second_variable number default square(first_variable);
BEGIN
    RETURN second_variable;
END;

call my_variable_to_variable_sp();


-- Different data types
DECLARE
    text_var text default 'Simple Text';
    int_var number default 100;
    decimal_var number(5, 2) default 10.10;
    date_var date default current_date();
    time_var time default current_time();
    ts_var timestamp default current_timestamp();
    boolean_var boolean default False;
    json_var variant default parse_json('{"key-1":"value-1"}');
    array_var array default [1, 2, 3];
    object_var object default {'Alberta':'Edmonton', 'Manitoba':'Winnipeg'};
BEGIN
    RETURN json_var;
END;

