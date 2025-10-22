#!/usr/bin/env python3
"""
Interactive Database Browser for FitAI Backend
"""

import sqlite3
import os
import json
from datetime import datetime

class DatabaseBrowser:
    def __init__(self, db_path):
        self.db_path = db_path
        self.conn = None
    
    def connect(self):
        """Connect to the database"""
        if not os.path.exists(self.db_path):
            print(f"❌ Database file not found: {self.db_path}")
            return False
        
        self.conn = sqlite3.connect(self.db_path)
        self.conn.row_factory = sqlite3.Row  # Enable column access by name
        return True
    
    def disconnect(self):
        """Disconnect from the database"""
        if self.conn:
            self.conn.close()
    
    def execute_query(self, query, params=None):
        """Execute a SQL query and return results"""
        if not self.conn:
            print("❌ Not connected to database")
            return None
        
        try:
            cursor = self.conn.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            
            if query.strip().upper().startswith('SELECT'):
                return cursor.fetchall()
            else:
                self.conn.commit()
                return cursor.rowcount
        except Exception as e:
            print(f"❌ Query error: {e}")
            return None
    
    def show_tables(self):
        """Show all tables in the database"""
        query = "SELECT name FROM sqlite_master WHERE type='table';"
        tables = self.execute_query(query)
        
        if tables:
            print("\n📋 Available Tables:")
            print("-" * 30)
            for table in tables:
                table_name = table['name']
                count_query = f"SELECT COUNT(*) as count FROM {table_name};"
                count_result = self.execute_query(count_query)
                count = count_result[0]['count'] if count_result else 0
                print(f"  • {table_name} ({count} records)")
        else:
            print("❌ No tables found")
    
    def show_table_schema(self, table_name):
        """Show schema for a specific table"""
        query = f"PRAGMA table_info({table_name});"
        columns = self.execute_query(query)
        
        if columns:
            print(f"\n🏗️  Schema for '{table_name}':")
            print("-" * 40)
            for col in columns:
                col_id = col['cid']
                name = col['name']
                type_name = col['type']
                not_null = col['notnull']
                default_val = col['dflt_value']
                pk = col['pk']
                
                pk_marker = " (PRIMARY KEY)" if pk else ""
                null_marker = " NOT NULL" if not_null else ""
                default_marker = f" DEFAULT {default_val}" if default_val else ""
                
                print(f"  {col_id:2d}. {name:20s} {type_name:15s}{null_marker}{default_marker}{pk_marker}")
        else:
            print(f"❌ Table '{table_name}' not found")
    
    def show_table_data(self, table_name, limit=10):
        """Show data from a specific table"""
        query = f"SELECT * FROM {table_name} LIMIT {limit};"
        rows = self.execute_query(query)
        
        if rows:
            print(f"\n📄 Data from '{table_name}' (showing first {len(rows)} records):")
            print("-" * 60)
            
            # Get column names
            column_names = list(rows[0].keys())
            
            # Print header
            header = " | ".join([f"{name:15s}" for name in column_names])
            print(header)
            print("-" * len(header))
            
            # Print rows
            for row in rows:
                row_data = []
                for col in column_names:
                    value = row[col]
                    if value is None:
                        value = "NULL"
                    elif isinstance(value, str) and len(str(value)) > 15:
                        value = str(value)[:12] + "..."
                    else:
                        value = str(value)
                    row_data.append(f"{value:15s}")
                print(" | ".join(row_data))
        else:
            print(f"❌ No data found in '{table_name}'")
    
    def insert_sample_user(self):
        """Insert a sample user for testing"""
        import uuid
        from werkzeug.security import generate_password_hash
        
        user_id = str(uuid.uuid4())
        email = "test@example.com"
        password_hash = generate_password_hash("test123")
        name = "Test User"
        
        # Insert user
        user_query = """
        INSERT INTO users (id, email, password_hash, name, is_active, is_verified, 
                          age, gender, height, weight, activity_level, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        
        now = datetime.utcnow()
        user_params = (user_id, email, password_hash, name, True, False, 
                      25, 'male', 175.0, 70.0, 'moderate', now, now)
        
        result = self.execute_query(user_query, user_params)
        if result is not None:
            print(f"✅ User inserted successfully (ID: {user_id})")
            
            # Insert user goals
            goals_id = str(uuid.uuid4())
            goals_query = """
            INSERT INTO user_goals (id, user_id, fitness_goal, target_weight, 
                                   workout_frequency, workout_duration, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """
            goals_params = (goals_id, user_id, 'weight_loss', 65.0, 3, 45, now, now)
            self.execute_query(goals_query, goals_params)
            
            # Insert user preferences
            prefs_id = str(uuid.uuid4())
            prefs_query = """
            INSERT INTO user_preferences (id, user_id, dietary_restrictions, 
                                        preferred_cuisine, workout_time_preference, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """
            prefs_params = (prefs_id, user_id, 'vegetarian', 'mediterranean', 'morning', now, now)
            self.execute_query(prefs_query, prefs_params)
            
            print("✅ Sample data inserted successfully!")
        else:
            print("❌ Failed to insert user")
    
    def interactive_mode(self):
        """Run interactive database browser"""
        print("🗄️  FitAI Database Browser")
        print("=" * 50)
        
        if not self.connect():
            return
        
        while True:
            print("\n📋 Available Commands:")
            print("  1. Show tables")
            print("  2. Show table schema")
            print("  3. Show table data")
            print("  4. Insert sample user")
            print("  5. Execute custom query")
            print("  6. Exit")
            
            choice = input("\n🔍 Enter your choice (1-6): ").strip()
            
            if choice == '1':
                self.show_tables()
            
            elif choice == '2':
                table_name = input("📊 Enter table name: ").strip()
                self.show_table_schema(table_name)
            
            elif choice == '3':
                table_name = input("📄 Enter table name: ").strip()
                limit = input("🔢 Enter limit (default 10): ").strip()
                limit = int(limit) if limit.isdigit() else 10
                self.show_table_data(table_name, limit)
            
            elif choice == '4':
                self.insert_sample_user()
            
            elif choice == '5':
                query = input("💻 Enter SQL query: ").strip()
                if query:
                    result = self.execute_query(query)
                    if result is not None:
                        if isinstance(result, list):
                            print(f"\n📊 Query returned {len(result)} rows:")
                            for row in result:
                                print(dict(row))
                        else:
                            print(f"✅ Query executed successfully ({result} rows affected)")
            
            elif choice == '6':
                print("👋 Goodbye!")
                break
            
            else:
                print("❌ Invalid choice. Please try again.")
        
        self.disconnect()

def main():
    db_path = "/Users/coditas/fitness_app/backend/instance/fitness_tracker.db"
    browser = DatabaseBrowser(db_path)
    browser.interactive_mode()

if __name__ == "__main__":
    main()
