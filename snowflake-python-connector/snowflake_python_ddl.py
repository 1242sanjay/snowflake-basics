import snowflake.connector as sf


print("Creating connection to snowflake")

sf_conn_obj = sf.connect(
    user = '1242sanjay',
    password = '<password>',
    account = '<account>',
    warehouse = 'COMPUTE_WH',
    database = 'MY_DB',
    schema = 'MY_SCHEMA'
)

print('Connection established successfully')
print('Object => ', sf_conn_obj)
print('Object type => ', type(sf_conn_obj))
print('Account => ', sf_conn_obj.account)
print('Database => ', sf_conn_obj.database)
print('Schema => ', sf_conn_obj.schema)
print('Warehouse => ', sf_conn_obj.warehouse)
print('Application => ', sf_conn_obj.application)

print('Getting cursor object')
sf_cur_obj = sf_conn_obj.cursor()

print('Ready to execure query on cursor object')
# execute any kind of query using execute method
try:
    # running ddl statement via execute method
    sf_cur_obj.execute("create or replace table test_table(id int, name string)")

    # inserting records into the table via execute method
    sf_cur_obj.execute("insert into test_table (id, name) values" +
                    "(1, 'sanjay'),"+
                    "(2, 'santosh'),"+
                    "(3, 'Rakesh'),"+
                    "(4, 'Ram')")
    # fetching resut via execute method
    sf_cur_obj.execute("select * from test_table")

    # fetching the first row
    # print(sf_cur_obj.fetchone())

    # fetching columns seperately of the first row
    # first_row = sf_cur_obj.fetchone()
    # print('ID => ', first_row[0])
    # print('Name => ', first_row[1])

    # fetching all rows
    print(sf_cur_obj.fetchall())

    # fetching 2 rows
    # print(sf_cur_obj.fetchmany(2))

    # create a list of tuple which contains id, name
    emp_list = [(5, 'sam'),(6, 'sita'),(7, 'bharat'),(8, 'krishna')]

    # use cursor execute many to insert in test_table
    sf_cur_obj.executemany("insert into test_table (id, name) values (%s, %s)", emp_list)

    # fetching all rows
    sf_cur_obj.execute("select * from test_table")
    print(sf_cur_obj.fetchall())
finally:
    # close the cursor
    sf_cur_obj.close()

# close the connection
sf_conn_obj.close()
