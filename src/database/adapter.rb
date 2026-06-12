require 'sqlite3'

DB_PATH = File.expand_path('../../reminder.db', __dir__)

DB = SQLite3::Database.new(DB_PATH)
DB.results_as_hash = true

DB.execute("PRAGMA foreign_keys = ON;")