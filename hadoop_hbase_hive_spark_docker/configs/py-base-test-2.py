import happybase
import random

# Connect to HBase
connection = happybase.Connection('hbase', port=9090)

# Create a table
table_name = 'test_table_01'
column_family = 'cf'
connection.create_table(table_name, {column_family: dict()})

# Insert 100 rows
table = connection.table(table_name)
for i in range(100):
    row_key = f'row{i}'
    data = {f'{column_family}:col1': str(random.randint(0, 100)),
            f'{column_family}:col2': str(random.randint(0, 100))}
    table.put(row_key, data)

# Retrieve data for some rows
rows_to_get = ['row0', 'row9', 'row19']
for row_key in rows_to_get:
    row = table.row(row_key)
    print(row)
