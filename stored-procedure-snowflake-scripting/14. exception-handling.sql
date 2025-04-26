show tables;

-- part-1
BEGIN
    DROP TABLE MY_DB.PUBLIC.TABLE_DOES_NOT_EXIST;
    RETURN 'Drop table statement executed';
END;

CREATE OR REPLACE PROCEDURE my_sp_with_exception()
RETURNS text
LANGUAGE SQL
AS
BEGIN
    DROP TABLE MY_DB.PUBLIC.TABLE_DOES_NOT_EXIST;
    RETURN 'Drop table statement executed';
END;

CALL my_sp_with_exception();

-- part-2
BEGIN
    LET total_emp number default (select count(*)/0 from employee);
    RETURN total_emp;
END;

-- how to first catch the exception
-- expression
DECLARE
    total_emp number default 0;
BEGIN
    total_emp := (select count(*)/0 from employee);
    RETURN total_emp;

    EXCEPTION
        WHEN EXPRESSION_ERROR THEN
            RETURN -1;
        WHEN STATEMENT_ERROR THEN
            RETURN -2;
        WHEN OTHER THEN
            RETURN total_emp;
END;

-- statement
DECLARE
    total_emp number default 0;
BEGIN
    select count(*) from employee1;
    RETURN total_emp;

    EXCEPTION
        WHEN EXPRESSION_ERROR THEN
            RETURN -1;
        WHEN STATEMENT_ERROR THEN
            RETURN -2;
        WHEN OTHER THEN
            RETURN total_emp;
END;


-- combine
DECLARE
    total_emp number default 0;
BEGIN
    total_emp := (select count(*)/0 from employee);
    RETURN total_emp;

    EXCEPTION
        WHEN EXPRESSION_ERROR OR STATEMENT_ERROR THEN
            RETURN -1;
        WHEN OTHER THEN
            RETURN total_emp;
END;


-- drop a table exception which is not exist
BEGIN
    DROP TABLE MY_DB.PUBLIC.TABLE_DOES_NOT_EXIST;
    RETURN 'Drop table statement executed';

    EXCEPTION
        WHEN EXPRESSION_ERROR OR STATEMENT_ERROR THEN
            EXECUTE IMMEDIATE 'SELECT 1000';
        WHEN OTHER THEN
            EXECUTE IMMEDIATE 'SELECT 2000';

    -- next set of execution
    LET rs RESULTSET := (SELECT * FROM MY_DB.PUBLIC.EMPLOYEE);
    -- return the resultset
    RETURN TABLE(rs);
END;


-- in previoius the resultset statement not executing so
BEGIN
    -- logic-1
    BEGIN
        DROP TABLE MY_DB.PUBLIC.TABLE_DOES_NOT_EXIST;
        RETURN 'Drop table statement executed';
    
        EXCEPTION
            WHEN EXPRESSION_ERROR OR STATEMENT_ERROR THEN
                EXECUTE IMMEDIATE 'SELECT 1000';
            WHEN OTHER THEN
                EXECUTE IMMEDIATE 'SELECT 2000';
    END;
    -- logic-2
    BEGIN
        LET rs RESULTSET := (SELECT * FROM MY_DB.PUBLIC.EMPLOYEE);
        RETURN TABLE(rs);
        EXCEPTION
            WHEN EXPRESSION_ERROR OR STATEMENT_ERROR THEN
                EXECUTE IMMEDIATE 'SELECT 3000';
            WHEN OTHER THEN
                EXECUTE IMMEDIATE 'SELECT 4000';
        -- return the resultset
    END;
END;



-- custom exception
DECLARE
    my_custom_exception EXCEPTION(-20001, 'I caught the expected exception');
BEGIN
    RAISE my_custom_exception;  -- use raise keyword to raise or throw an exception
    RETURN 'Before exception block';  -- this line will never be executed
    
    -- handler section
    EXCEPTION
        WHEN EXPRESSION_ERROR OR STATEMENT_ERROR THEN
            RETURN 'Standard Exception';
        WHEN OTHER THEN
            RETURN 'Other Exception';
END;


DECLARE
    my_custom_exception EXCEPTION(-20001, 'I caught the expected exception');
BEGIN
    RAISE my_custom_exception;  -- use raise keyword to raise or throw an exception
    RETURN 'Before exception block';  -- this line will never be executed
    
    -- handler section
    EXCEPTION
        WHEN EXPRESSION_ERROR OR STATEMENT_ERROR THEN
            RETURN 'Standard Exception';
        WHEN my_custom_exception THEN
            RETURN 'Custom Exception';
        WHEN OTHER THEN
            RETURN 'Other Exception';
END;




-- logging exception
CREATE OR REPLACE TABLE AUDIT_TABLE(MSG text);

DECLARE
    my_custom_exception EXCEPTION (-20001, 'Customer error msg using custom exception');
BEGIN
    LET audit_msg text default '';
    RAISE STATEMENT_ERROR;          -- use raise keyword to raise or throw an exception
    RETURN 'Before exception block';    -- this line will never be executed

    -- handler section
    EXCEPTION       
        WHEN EXPRESSION_ERROR or STATEMENT_ERROR THEN
        audit_msg := 'SQLCODE = ' ||SQLCODE || ', SQLERRM =' || SQLERRM || ', SQLSTATE = ' || SQLSTATE;
        INSERT INTO AUDIT_TABLE (MSG) VALUES (:AUDIT_MSG);
        WHEN my_custom_exception THEN
        audit_msg := 'SQLCODE = ' ||SQLCODE || ', SQLERRM =' || SQLERRM || ', SQLSTATE = ' || SQLSTATE;
        INSERT INTO AUDIT_TABLE (MSG) VALUES (:AUDIT_MSG);
        WHEN OTHER THEN
        audit_msg := 'SQLCODE = ' ||SQLCODE || ', SQLERRM =' || SQLERRM || ', SQLSTATE = ' || SQLSTATE;
        INSERT INTO AUDIT_TABLE (MSG) VALUES (:AUDIT_MSG);

    -- No executable statement after exception section
END;


select * from AUDIT_TABLE;