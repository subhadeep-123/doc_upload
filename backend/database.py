import os
from typing import List
import mysql.connector as sql
from dotenv import load_dotenv

load_dotenv()

try:
    conn = sql.connect(
        user=os.getenv('MYSQL_ROOT_USERNAME'),
        password=os.getenv('MYSQL_ROOT_PASSWORD'),
        host='127.0.0.1',
        database='userinfo'
    )
except sql.Error as err:
    if err.errno == sql.errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with the databse login credential")
    elif err.errno == sql.errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(f"The error is - {err}")
else:
    cursor = conn.cursor()
    print("Connected to Database")

TABLENAME = 'data'


class create_dict(dict):

    # __init__ function
    def __init__(self):
        self = dict()

    # Function to add key:value
    def add(self, key, value):
        self[key] = value


def _show_tables():
    cursor.execute("SHOW TABLES")
    tables = [table for table in cursor]
    print(tables)
    return tables


def create_table() -> None:
    print(TABLENAME, _show_tables())
    if TABLENAME in _show_tables():
        print("Not Creating Table Exists")
    else:
        cursor.execute(
            f"CREATE TABLE {TABLENAME} (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), filename VARCHAR(255))")
        tables = _show_tables()
        print("Table Created", tables)


def delete_table() -> None:
    command = f"DROP TABLE IF EXISTS {TABLENAME}"
    cursor.execute(command)
    print("Before ", _show_tables())
    print("Table Deleted")
    print("After ", _show_tables())


def insert_value(name: str, filename: str) -> str:
    command = f"INSERT INTO {TABLENAME} (name, filename) VALUES (%s, %s)"
    values = (name, filename)
    cursor.execute(command, values)
    conn.commit()
    return f"Data Inserted for {name}, Login Now"


def fetch_data(name: str) -> List:
    command = f"SELECT * FROM {TABLENAME} WHERE name = %s"
    values = (name,)
    cursor.execute(command, values)
    search_result = cursor.fetchall()
    searched_filenames = [i[2] for i in search_result]
    return searched_filenames


def showAll():
    cursor.execute(f"SELECT * FROM {TABLENAME}")
    result = cursor.fetchall()
    myDict = create_dict()
    for row in result:
        myDict.add(
            row[0], ({"name": row[1], "filename": row[2]}))
    return myDict


if __name__ == '__main__':
    print(_show_tables())
    # delete_table()
