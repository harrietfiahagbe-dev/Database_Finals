import os
from contextlib import contextmanager

import mysql.connector
from mysql.connector import Error as MySQLError

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    pass

MySQLError = MySQLError


def get_config():
    return {
        "host": os.getenv("MYSQL_HOST", "127.0.0.1"),
        "user": os.getenv("MYSQL_USER", "root"),
        "password": os.getenv("MYSQL_PASSWORD", ""),
        "database": os.getenv("MYSQL_DATABASE", "NPIMS"),
        "port": int(os.getenv("MYSQL_PORT", "3306")),
    }


@contextmanager
def get_conn():
    conn = mysql.connector.connect(**get_config())
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def query(sql, params=None, one=False):
    with get_conn() as conn:
        cur = conn.cursor(dictionary=True)
        cur.execute(sql, params or ())
        rows = cur.fetchall()
        cur.close()
        if one:
            return rows[0] if rows else None
        return rows


def execute(sql, params=None):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        rowcount = cur.rowcount
        cur.close()
        return rowcount


def callproc(name, args):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.callproc(name, args)
        cur.close()
