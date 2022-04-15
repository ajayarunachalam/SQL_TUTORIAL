#! /usr/bin/env python

################# SQL THRU PYTHON ###############################

import pandas as pd
import random
from Py_Sql_Alchemy_Class import DB_Table_Ops

dbto = DB_Table_Ops()

if True:
  d = {'value_1': list(range(100)),
       'value_2': list(range(100)),
       'color':[random.choice(['red','blue']) for _ in range (100)]
       }

  print(d)

  df = pd.DataFrame(data=d)

  schema_str = '''CREATE TABLE table_one (
              ident int IDENTITY(1,1) PRIMARY KEY,
              value_1 int NOT NULL,
              value_2 int NOT NULL,
              color char(4) NOT NULL);'''

  dbto.drop_table('table_one')

  print(f'table_one exists:{dbto.table_exists("table_one")}')
  dbto.create_table(schema_str)
  print(f'table_one exists:{dbto.table_exists("table_one")}')
  dbto.insert_df_to_table(df,'table_one')


############# Query 1 ###################################

query_string = 'SELECT * FROM table_one'

print('\nData from table one:')
print(dbto.query_to_df(query_string))


############# Query 2 ###################################

query_string = '''
	SELECT color,
	CAST((COUNT(value_1)) AS DECIMAL)/
	(CAST((SELECT count(value_1)
	FROM table_one) AS DECIMAL)) AS val_1_pc
	FROM table_one GROUP BY color; '''

print('\nData from table one:')
print(dbto.general_sql_command(query_string))