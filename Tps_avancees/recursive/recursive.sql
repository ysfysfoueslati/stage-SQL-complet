-- SQLite
WITH RECURSIVE children (id, name, parent_id, level, path) AS (
    SELECT id, name, parent_id, 0, name FROM categories WHERE id=11
    UNION ALL
    SELECT 
        c.id,
        c.name, 
        c.parent_id, 
        children.level + 1,
        children.path || " > " || c.name
    FROM categories c, children
    WHERE c.parent_id = children.id
)
SELECT * FROM children