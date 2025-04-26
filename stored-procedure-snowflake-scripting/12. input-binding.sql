-- Input Binding
-- without binding
CREATE OR REPLACE PROCEDURE my_proc_v3(client_driver text, auth_factor text)
RETURNS text
LANGUAGE SQL
AS
BEGIN
    let sql_stmt resultset := (select * from snowflake.account_usage.login_history where reported_client_type = :client_driver and first_authentication_factor = :auth_factor);
    let login_history_cursor CURSOR FOR sql_stmt;
    let msg text default '';
    for row_item in login_history_cursor do
        if (row_item.is_success = 'No') then
            msg := msg || '(' || row_item.user_name || ' --> ' || row_item.error_message || ') ';
        end if;
    end for cursor_loop;
    RETURN msg;
END;

call my_proc_v3('SNOWFLAKE_UI', 'PASSWORD');

-- with binding (also instead of ? you can use :1 and :2)
CREATE OR REPLACE PROCEDURE my_proc_v4(client_driver text, auth_factor text)
RETURNS text
LANGUAGE SQL
AS
BEGIN
    let login_history_cursor CURSOR FOR (select * from snowflake.account_usage.login_history where reported_client_type = ? and first_authentication_factor = ?);
    OPEN login_history_cursor using (client_driver, auth_factor);
    let msg text default '';
    for row_item in login_history_cursor do
        if (row_item.is_success = 'No') then
            msg := msg || '(' || row_item.user_name || ' --> ' || row_item.error_message || ') ';
        end if;
    end for cursor_loop;
    RETURN msg;
END;

call my_proc_v4('SNOWFLAKE_UI', 'PASSWORD');


-- json format
CREATE OR REPLACE PROCEDURE my_proc_v5(client_driver text, auth_factor text)
RETURNS text
LANGUAGE SQL
AS
DECLARE
    failed_cnt number default 0;
    success_cnt number default 0;
    failed_users variant := array_construct();
    login_history_cursor CURSOR FOR (select * from snowflake.account_usage.login_history where reported_client_type = ? and first_authentication_factor = ?);
BEGIN
    OPEN login_history_cursor using (client_driver, auth_factor);
    FOR row_item IN login_history_cursor DO
        IF (row_item.is_success = 'No') THEN
            failed_users := array_append(failed_users, object_construct(
                'user_name', row_item.user_name,
                'error_message', row_item.error_message
            ));
            failed_cnt := failed_cnt +1;
        ELSE
            success_cnt := success_cnt +1;
        END IF;
    END FOR cursor_loop;
    CLOSE login_history_cursor;
    RETURN object_construct(
        'failed_count', failed_cnt,
        'success_count', success_cnt,
        'failed_users', failed_users
    );
END;

call my_proc_v5('SNOWFLAKE_UI', 'PASSWORD');