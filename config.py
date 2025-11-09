# config.py - Database Configuration
import os

class Config:
    # MySQL Database Configuration
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'root'
    MYSQL_DB = 'gaming_tournament_db'
    MYSQL_PORT = 3306

    # Flask Configuration
    SECRET_KEY = 'gaming-tournament-secret-key-2025'

    # Session Configuration
    SESSION_TYPE = 'filesystem'
    PERMANENT_SESSION_LIFETIME = 3600  # 1 hour

    # Debug Mode
    DEBUG = True
