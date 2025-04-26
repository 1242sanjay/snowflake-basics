-- Lets print 1 to 20
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at DO
        return_msg := return_msg || i || ' ';
    END FOR;
    RETURN return_msg;
END;


-- Lets print even number between 1 to 20
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at DO
        IF (i%2 = 0) THEN
            return_msg := return_msg || i || ' ';
        END IF;
    END FOR;
    RETURN return_msg;
END;


-- DO vs LOOP Keyword
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at DO
        return_msg := return_msg || i || ' ';
    END FOR;
    RETURN return_msg;
END;

DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at LOOP
        return_msg := return_msg || i || ' ';
    END LOOP;
    RETURN return_msg;
END;


-- REVERSE Keyword
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN REVERSE start_at TO end_at DO
        return_msg := return_msg || i || ' ';
    END FOR;
    RETURN return_msg;
END;


-- BREAK keyword
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at DO
        IF (i > 15) THEN
            BREAK;
        END IF;
        return_msg := return_msg || i || ' ';
    END FOR;
    RETURN return_msg;
END;

-- CONTINUE keyword
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 20;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at DO
        IF (i > 15) THEN
            CONTINUE;
        END IF;
        return_msg := return_msg || i || ' ';
    END FOR;
    RETURN return_msg;
END;



-- Loop with Label
DECLARE
    start_at INTEGER DEFAULT 1;  -- Counter starts at
    end_at INTEGER DEFAULT 5;  -- Counter ends at
    return_msg TEXT DEFAULT '';  -- Return variable
BEGIN
    FOR i IN start_at TO end_at DO
        return_msg := return_msg || i || ' (';
        FOR j IN start_at TO end_at DO
            IF (j=1 AND i=3) THEN
                break outer_loop;
                -- break;
            END IF;
            return_msg := return_msg || i*j || ' ';
        END FOR inner_loop;
        return_msg := return_msg || ') ';
    END FOR outer_loop;
    RETURN return_msg;
END;


-- CURSOR based loop
DECLARE
    return_msg text default '';
BEGIN
    -- create table + insert records
    execute immediate 'create or replace temp table sales(order_id int, order_value int)';
    execute immediate 'insert into sales values (1, 100), (2, 90), (3, 287), (4, 76), (5, 99)';

    let sales_cursor CURSOR FOR select order_id, order_value from sales;
    let total_sales int := 0;

    FOR record IN sales_cursor DO
        total_sales := total_sales + record.order_value;
    END FOR total_sales;

    return_msg := 'Total Sales '|| total_sales;

    RETURN return_msg;
END;


-- Use Case
create or replace database ch12;
use ch12;
create or replace schema my_schema;
use schema my_schema;

create or replace temp table tbl1 (id int);
create or replace temp table tbl2 (id int);
create or replace transient table tbl3 (id int);
create or replace transient table tbl4 (id int);
create or replace table tbl4 (id int);

create or replace table tbl5 (id int);
alter table tbl5 set data_retention_time_in_days=5;
create or replace table tbl6 (id int);
alter table tbl6 set data_retention_time_in_days=9;

show tables;
select * from table(result_scan());

DECLARE
    return_msg text default '';
BEGIN
    execute immediate 'show tables in database ch12';
    let all_tables CURSOR FOR select "name" as name, "database_name" as database_name, "schema_name" as schema_name, "kind" as kind, "retention_time" as retention_time from table(result_scan()) order by "created_on";

    FOR record IN all_tables DO
        LET table_name text := record.name;
        LET db_name text := record.database_name;
        LET schema_name text := record.schema_name;
        LET table_type text := record.kind;
        LET retention_time int := record.retention_time;
        IF (table_type = 'TABLE') THEN
            IF (retention_time > 1) THEN
                continue;
            END IF;
        END IF;
        return_msg := return_msg || 'drop table if exists '|| db_name||'.'||schema_name||'.'||table_name||';\n';
    END FOR outer_loop;
    RETURN return_msg;
END;




-- While loop
-- Lets print 1 to 10 using while loop
DECLARE
    return_msg text default '';
BEGIN
    LET counter integer := 1;
    WHILE (counter <= 10) DO
        return_msg := return_msg || counter || ' ';
        counter := counter +1;
    END WHILE;

    RETURN return_msg;
END;


-- Repeat Loop
create or replace table emp (emp_name text not null, mgr_name text);

insert into emp values
    ('Emp01', null),
    ('Emp02', 'Emp01'),
    ('Emp03', 'Emp01'),
    ('Emp04', 'Emp02'),
    ('Emp05', 'Emp03'),
    ('Emp06', 'Emp05'),
    ('Emp07', 'Emp06')
;

select * from emp;


BEGIN
    LET input_txt text DEFAULT 'Emp07';
    LET mgr_name text := '';
    LET return_msg text := input_txt;

    REPEAT 
        mgr_name := (select mgr_name from emp where emp_name = :input_txt);
        input_txt := mgr_name;
        if(mgr_name is not null) then
            return_msg := return_msg || ' > ' || mgr_name;
        end if;
    UNTIL (mgr_name is null)
    END REPEAT;
    RETURN return_msg;
END;
    
