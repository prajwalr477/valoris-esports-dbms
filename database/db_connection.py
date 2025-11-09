# database/db_connection.py - Database Helper Functions

import pymysql
from config import Config

def get_db_connection():
    """Create and return a database connection"""
    try:
        connection = pymysql.connect(
            host=Config.MYSQL_HOST,
            user=Config.MYSQL_USER,
            password=Config.MYSQL_PASSWORD,
            database=Config.MYSQL_DB,
            port=Config.MYSQL_PORT,
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=False  # Changed to False
        )
        return connection
    except pymysql.Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None


def execute_query(query, params=None, fetch=True):
    """Execute a query and return results"""
    connection = get_db_connection()
    if not connection:
        return None

    try:
        with connection.cursor() as cursor:
            cursor.execute(query, params or ())
            if fetch:
                result = cursor.fetchall()
            else:
                result = cursor.rowcount  # Get rows affected
            
            connection.commit()  # Commit after execute
            return result
    except pymysql.Error as e:
        connection.rollback()
        print(f"Database error: {e}")
        raise e
    finally:
        connection.close()


def execute_query_with_connection(queries_list):
    """Execute multiple queries on the SAME connection"""
    connection = get_db_connection()
    if not connection:
        return None

    results = []
    try:
        for query, params, fetch in queries_list:
            with connection.cursor() as cursor:
                cursor.execute(query, params or ())
                if fetch:
                    result = cursor.fetchall()
                else:
                    result = cursor.rowcount
                results.append(result)
        
        connection.commit()
        return results
    except pymysql.Error as e:
        connection.rollback()
        print(f"Database error: {e}")
        raise e
    finally:
        connection.close()


def execute_procedure(proc_name, params=None):
    """Execute a stored procedure"""
    connection = get_db_connection()
    if not connection:
        return None

    try:
        with connection.cursor() as cursor:
            cursor.callproc(proc_name, params or ())
            connection.commit()
            return True
    except pymysql.Error as e:
        connection.rollback()
        print(f"Procedure error: {e}")
        raise e
    finally:
        connection.close()


def call_function(func_query):
    """Call a MySQL function"""
    connection = get_db_connection()
    if not connection:
        return None

    try:
        with connection.cursor() as cursor:
            cursor.execute(func_query)
            result = cursor.fetchone()
            connection.commit()
            return result
    except pymysql.Error as e:
        connection.rollback()
        print(f"Function error: {e}")
        raise e
    finally:
        connection.close()
