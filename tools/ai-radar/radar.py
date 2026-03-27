#!/usr/bin/env python3
import sqlite3, sys, json, os

# Automatically defaults the database to the root .gemini brain
db_path = os.path.expanduser('~/.gemini/ai-radar.db')

def init_db():
    conn = sqlite3.connect(db_path)
    with open(os.path.join(os.path.dirname(__file__), 'schema.sql'), 'r') as f:
        conn.cursor().executescript(f.read())
    conn.commit()
    return conn

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python radar.py [add|list] '<json_string>'")
        sys.exit(1)

    action = sys.argv[1]
    conn = init_db()

    if action == 'add':
        data = json.loads(sys.argv[2])
        try:
            conn.execute('''
            INSERT INTO links (url, title, tags, category, usefulness, integration_status, our_use_case)
            VALUES (?, ?, ?, ?, ?, 'PENDING', ?)
            ''', (
                data.get('url'), data.get('title'), data.get('tags'), 
                data.get('category'), data.get('usefulness', 5), data.get('our_use_case')
            ))
            conn.commit()
            print(f"✅ Successfully added to AI Radar DB: {data.get('title')}")
        except sqlite3.IntegrityError:
            print("⚠️ URL already exists in radar database.")
    
    elif action == 'list':
        for row in conn.execute('SELECT id, usefulness, title, integration_status FROM links ORDER BY added_at DESC'):
            print(f"[{row[0]}] Score {row[1]}/10 | Status: {row[3]} | {row[2]}")
    
    conn.close()
