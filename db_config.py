import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Kissu",  # apna password yahan daalo
        database="event_mgmt_db"         # apna database name
    )
