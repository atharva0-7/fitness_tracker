#!/usr/bin/env python3
"""
Database inspection script for FitAI Backend
"""

import sqlite3
import os
from datetime import datetime

def check_database():
    """Check database status and contents"""
    db_path = "/Users/coditas/fitness_app/backend/instance/fitness_tracker.db"
    
    if not os.path.exists(db_path):
        print("❌ Database file not found!")
        return
    
    print("🗄️  FitAI Database Status")
    print("=" * 50)
    print(f"📁 Database Path: {db_path}")
    print(f"📊 File Size: {os.path.getsize(db_path)} bytes")
    print(f"📅 Last Modified: {datetime.fromtimestamp(os.path.getmtime(db_path))}")
    print()
    
    # Connect to database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Get all tables
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    
    print("📋 Database Tables:")
    print("-" * 30)
    for table in tables:
        table_name = table[0]
        cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
        count = cursor.fetchone()[0]
        print(f"  • {table_name}: {count} records")
    
    print()
    
    # Show table schemas
    print("🏗️  Table Schemas:")
    print("-" * 30)
    for table in tables:
        table_name = table[0]
        print(f"\n📊 {table_name.upper()}:")
        cursor.execute(f"PRAGMA table_info({table_name});")
        columns = cursor.fetchall()
        for col in columns:
            col_id, name, type_name, not_null, default_val, pk = col
            pk_marker = " (PRIMARY KEY)" if pk else ""
            null_marker = " NOT NULL" if not_null else ""
            print(f"  • {name}: {type_name}{null_marker}{pk_marker}")
    
    # Show foreign key relationships
    print("\n🔗 Foreign Key Relationships:")
    print("-" * 30)
    for table in tables:
        table_name = table[0]
        cursor.execute(f"PRAGMA foreign_key_list({table_name});")
        fks = cursor.fetchall()
        if fks:
            print(f"\n📊 {table_name}:")
            for fk in fks:
                id, seq, table_ref, from_col, to_col, on_update, on_delete, match = fk
                print(f"  • {from_col} → {table_ref}.{to_col}")
    
    # Show sample data if any exists
    print("\n📄 Sample Data:")
    print("-" * 30)
    for table in tables:
        table_name = table[0]
        cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
        count = cursor.fetchone()[0]
        if count > 0:
            cursor.execute(f"SELECT * FROM {table_name} LIMIT 3;")
            rows = cursor.fetchall()
            print(f"\n📊 {table_name} (showing first {len(rows)} records):")
            for i, row in enumerate(rows, 1):
                print(f"  {i}. {row}")
        else:
            print(f"📊 {table_name}: No data")
    
    conn.close()
    print("\n✅ Database check complete!")

if __name__ == "__main__":
    check_database()
