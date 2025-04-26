-- Very basic structure
DECLARE
    emp_cnt number default (select count(*) from employee);
    first_emp text default (select first_name || ' ' || last_name from employee order by doj limit 1);

    -- resultset as data type
    rs ResultSet default (select * from employee);
BEGIN
    -- RETURN emp_cnt;
    -- RETURN first_emp;
    RETURN table(rs);
END;


-- Declare the resultset in DECLARE block and initialize later
DECLARE
    rs ResultSet;
BEGIN
    rs := (select * from employee);
    RETURN table(rs);
END;

-- Resultset also can be declare in begin block as well like other variables
BEGIN
    -- let rs Resultset default (select * from employee);
    let rs Resultset := (select * from employee);
    RETURN table(rs);
END;


-- Use for loop with resultset
DECLARE
    mgr_count number default 0;
    rs ResultSet default (select * from employee);
BEGIN
    FOR row_item in rs DO
        let is_mgr_flag text := row_item.is_manager;
        IF (is_mgr_flag = 'Y') THEN
            mgr_count := mgr_count + 1;
        END IF;
    END FOR;
    RETURN mgr_count;
END;

-- Also you can use cursor
DECLARE
    mgr_count number default 0;
    rs ResultSet default (select * from employee);
    my_cursor CURSOR for rs;
BEGIN
    FOR row_item in my_cursor DO
        let is_mgr_flag text := row_item.is_manager;
        IF (is_mgr_flag = 'Y') THEN
            mgr_count := mgr_count + 1;
        END IF;
    END FOR;
    RETURN mgr_count;
END;
    

-- Dynamic query
DECLARE
    mgr_count number default 0;
    mgr_status text default 'Y';
    sql_query text default $$select * from employee where is_manager = '$$ || mgr_status || $$'$$;
    rs ResultSet := (execute immediate :sql_query);
BEGIN
    FOR row_item in rs DO
        let is_mgr_flag text := row_item.is_manager;
        IF (is_mgr_flag = 'Y') THEN
            mgr_count := mgr_count + 1;
        END IF;
    END FOR;
    RETURN mgr_count;
END;