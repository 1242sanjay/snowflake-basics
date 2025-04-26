-- create a stored procedure with outer and inner block
CREATE OR REPLACE PROCEDURE my_procedure_outer_inner()
RETURNS NUMBER(2, 0)
LANGUAGE SQL
AS
DECLARE
    -- global variable
    global_var NUMBER(2, 0) default 0;
BEGIN
    LET outer_var NUMBER(2, 0) := 10;

    BEGIN
        LET inner_var NUMBER(2, 0) := 20;
        -- all global and outer variable accessible here
        global_var := inner_var + outer_var;
    END;

    -- the inner_var will not be accessible in this line

    return global_var;
END;

desc procedure my_procedure_outer_inner();
call my_procedure_outer_inner();





DECLARE
    -- global variable
    global_var NUMBER(2, 0) default 0;
BEGIN
    LET outer_var NUMBER(2, 0) := 10;

    BEGIN
        LET inner_var NUMBER(2, 0) := 20;
        -- all global and outer variable accessible here
        global_var := inner_var + outer_var;
        BEGIN
            LET inner_var NUMBER(2, 0) := 25;
            -- all global and outer variable accessible here
            global_var := inner_var + outer_var;
        END;
    END;

    -- the inner_var will not be accessible in this line

    return global_var;
END;