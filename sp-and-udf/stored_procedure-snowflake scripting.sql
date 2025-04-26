-- Writing stored procedures in Snowflake Scripting (snowsight)
CREATE OR REPLACE PROCEDURE output_message(message VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
  RETURN message;
END;


-- If you are creating a Snowflake Scripting procedure in SnowSQL or the Classic Console, you must use string literal delimiters (' or $$) around the body of the stored procedure.
CREATE OR REPLACE PROCEDURE output_message(message VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  RETURN message;
END;
$$
;

CALL output_message('Hello World');


-- creating and calling an anonymous stored procedure by using the WITH … CALL … command
WITH anonymous_output_message AS PROCEDURE (message VARCHAR)
  RETURNS VARCHAR NOT NULL
  LANGUAGE SQL
  AS
  $$
  BEGIN
    RETURN message;
  END;
  $$
CALL anonymous_output_message('Hello World');


-- using arguments passed to a stored procedure
CREATE OR REPLACE PROCEDURE return_greater(number_1 INTEGER, number_2 INTEGER)
RETURNS INTEGER NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  IF (number_1 > number_2) THEN
    RETURN number_1;
  ELSE
    RETURN number_2;
  END IF;
END;
$$
;

CALL return_greater(5, 7);


-- argument in a SQL statement (binding)
-- using a bind variable in a WHERE clause
CREATE OR REPLACE PROCEDURE find_invoice_by_id(id VARCHAR)
RETURNS TABLE (id INTEGER, price NUMBER(12,2))
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT * FROM invoices WHERE id = :id);
BEGIN
  RETURN TABLE(res);
END;
$$
;

CALL find_invoice_by_id('2');


-- using a bind variable to set the value of a property
CREATE OR REPLACE PROCEDURE test_bind_comment(comment VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  CREATE OR REPLACE TABLE test_table_with_comment(a VARCHAR, n NUMBER) COMMENT = :comment;
END;
$$
;

CALL test_bind_comment('My Test Table');

SELECT comment FROM information_schema.tables WHERE table_name='TEST_TABLE_WITH_COMMENT';


-- using bind variables to set parameters in a command
CREATE OR REPLACE STAGE st;
PUT file://good_data.csv @st;
PUT file://errors_data.csv @st;

CREATE OR REPLACE TABLE test_bind_stage_and_load (a VARCHAR, b VARCHAR, c VARCHAR);

CREATE OR REPLACE PROCEDURE test_copy_files_validate(
  my_stage_name VARCHAR,
  on_error VARCHAR,
  valid_mode VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  COPY INTO test_bind_stage_and_load
    FROM :my_stage_name
    ON_ERROR=:on_error
    FILE_FORMAT=(type='csv')
    VALIDATION_MODE=:valid_mode;
END;
$$
;

CALL test_copy_files_validate('@st', 'skip_file', 'return_all_errors');


-- Using an argument as an object identifier
CREATE OR REPLACE PROCEDURE get_row_count(table_name VARCHAR)
RETURNS INTEGER NOT NULL
LANGUAGE SQL
AS
$$
DECLARE
  row_count INTEGER DEFAULT 0;
  res RESULTSET DEFAULT (SELECT COUNT(*) AS COUNT FROM IDENTIFIER(:table_name));
  c1 CURSOR FOR res;
BEGIN
  FOR row_variable IN c1 DO
    row_count := row_variable.count;
  END FOR;
  RETURN row_count;
END;
$$
;

CALL get_row_count('CUSTOMER');


-- Using an argument when building a string for a SQL statement
CREATE OR REPLACE PROCEDURE find_invoice_by_id_via_execute_immediate(id VARCHAR)
RETURNS TABLE (id INTEGER, price NUMBER(12,2))
LANGUAGE SQL
AS
$$
DECLARE
  select_statement VARCHAR;
  res RESULTSET;
BEGIN
  select_statement := 'SELECT * FROM invoices WHERE id = ' || id;
  res := (EXECUTE IMMEDIATE :select_statement);
  RETURN TABLE(res);
END;
$$
;

CALL find_invoice_by_id_via_execute_immediate('2');


-- Returning tabular data
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE (sales_date DATE, quantity NUMBER)
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT sales_date, quantity FROM sales ORDER BY quantity DESC LIMIT 10);
BEGIN
  RETURN TABLE(res);
END;
$$
;

CALL get_top_sales();


-- Calling a stored procedure from another stored procedure
-- Create a table for use in the example.
CREATE OR REPLACE TABLE int_table (value INTEGER);

-- Create a stored procedure to be called from another stored procedure.
CREATE OR REPLACE PROCEDURE insert_value(value INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  INSERT INTO int_table VALUES (:value);
  RETURN 'Rows inserted: ' || SQLROWCOUNT;
END;
$$
;

-- Create a second stored procedure that calls the first stored procedure
CREATE OR REPLACE PROCEDURE insert_two_values(value1 INTEGER, value2 INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  CALL insert_value(:value1);
  CALL insert_value(:value2);
  RETURN 'Finished calling stored procedures';
END;
$$
;

CALL insert_two_values(4, 5);


-- 5.) Using and setting SQL variables in a stored procedure
/*
By default, Snowflake Scripting stored procedures run with owner’s rights. When a stored procedure runs with owner’s rights, it can’t access SQL (or session) variables.
However, a caller’s rights stored procedure can read the caller’s session variables and use them in the logic of the stored procedure.
*/
-- a.) Using a SQL variable in a stored procedure
SET example_use_variable = 2;

CREATE OR REPLACE PROCEDURE use_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
  sess_var_x_2 NUMBER;
BEGIN
  sess_var_x_2 := 2 * $example_use_variable;
  RETURN sess_var_x_2;
END;
$$
;

CALL use_sql_variable_proc();

SET example_use_variable = 9;

CALL use_sql_variable_proc();


-- b.) Setting a SQL variable in a stored procedure
SET example_set_variable = 55;

SHOW VARIABLES LIKE 'example_set_variable';

CREATE OR REPLACE PROCEDURE set_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
  SET example_set_variable = $example_set_variable - 3;
  RETURN $example_set_variable;
END;
$$
;

CALL set_sql_variable_proc();

SHOW VARIABLES LIKE 'example_set_variable';
