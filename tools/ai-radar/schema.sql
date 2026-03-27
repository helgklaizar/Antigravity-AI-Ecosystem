-- SQLite Schema for AI Radar Database
CREATE TABLE IF NOT EXISTS links (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    url TEXT UNIQUE,               -- The source URL (GitHub, Twitter, Article)
    title TEXT,                    -- Name of the project/article
    tags TEXT,                     -- Comma-separated tags (e.g. MCP, React, Agents)
    category TEXT,                 -- Repo / Article / Prompt / Concept
    usefulness INT,                -- 1 to 10 rating based on PM evaluation
    integration_status TEXT,       -- PENDING / INTEGRATING / REJECTED / DONE
    our_use_case TEXT,             -- Explains WHY this was saved and HOW it helps our spec
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
