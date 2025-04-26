BEGIN 
    EXECUTE IMMEDIATE 'use schema my_db.sp';
    EXECUTE IMMEDIATE 'show tables';
    LET rs RESULTSET := (EXECUTE IMMEDIATE 'select "name", "owner", "rows", "bytes" from table(result_scan())');
    return table(rs);
END;


BEGIN 
    use schema my_db.sp;
    show tables;
    LET rs RESULTSET := (select "name", "owner", "rows", "bytes" from table(result_scan()));
    return table(rs);
END;

-- both are giving same result, so not all block required EXECUTE IMMEDIATE. But snowsql cli it required
-- EXECUTE IMMEDIATE always return a resultset data type


-- Session level parameter/variable
set sql_in_session = 'select "name", "owner" from table(result_scan()) where "owner" = ?';
select $sql_in_session;

DECLARE
    change_context text := 'use schema my_db.public';
    show_cmd text := 'show tables';
BEGIN
    EXECUTE IMMEDIATE :change_context;
    EXECUTE IMMEDIATE :show_cmd;
    LET owner := 'SYSADMIN';
    LET rs RESULTSET := (EXECUTE IMMEDIATE $sql_in_session using(owner));
    return table(rs);
END;
