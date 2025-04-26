import snowflake.connector as sf


print("Creating connection to snowflake")

sf_conn_obj = sf.connect(
    user = '1242sanjay',
    password = 'SnR@mymarch024',
    account = 'YPLNPMR-CC80971',
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
print('Cursor object => ', sf_cur_obj)

print('Ready to execure query on cursor object')
# execute any kind of query using execute method
try:
    sf_cur_obj.execute('select \
        current_version(), current_database(),current_schema(), \
        current_warehouse(), current_account(), current_client()')
    
    # Same cursor object help to fetch the data
    one_row = sf_cur_obj.fetchone()
    print('Current version => ', one_row[0])
    print('Current database => ', one_row[1])
    print('Current schema => ', one_row[2])
    print('Current warehouse => ', one_row[3])
    print('Current account => ', one_row[4])
    print('Current client => ', one_row[5])
finally:
    # closing the connection
    sf_conn_obj.close()
