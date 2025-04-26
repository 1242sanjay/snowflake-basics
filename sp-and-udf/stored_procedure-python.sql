-- for python stored procedure
CREATE OR REPLACE TABLE employees(id NUMBER, name VARCHAR, role VARCHAR);
INSERT INTO employees (id, name, role) VALUES (1, 'Alice', 'op'), (2, 'Bob', 'dev'), (3, 'Cindy', 'dev');



CREATE OR REPLACE PROCEDURE filterByRole(tableName VARCHAR, role VARCHAR)
RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'filter_by_role'
AS
$$
from snowflake.snowpark.functions import col

def filter_by_role(session, table_name, role):
   df = session.table(table_name)
   return df.filter(col("role") == role)
$$;

CALL filterByRole('employees', 'dev');

-- Omitting return column names and types


CREATE OR REPLACE PROCEDURE filterByRole(tableName VARCHAR, role VARCHAR)
RETURNS TABLE()
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'filter_by_role'
AS
$$
from snowflake.snowpark.functions import col

def filter_by_role(session, table_name, role):
  df = session.table(table_name)
  return df.filter(col("role") == role)
$$;

CALL filterByRole('employees', 'dev');