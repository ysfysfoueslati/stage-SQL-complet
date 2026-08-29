-- SQLite

PRAGMA foreign_keys= ON;

DROP TABLE IF EXISTS categories_recipes;
DROP TABLE IF EXISTS ingredients_recipes;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS ingredients;

CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    username VARCHAR(150),
    email VARCHAR(150)
);

CREATE TABLE recipes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title VARCHAR(150),
    slug VARCHAR(150),
    date DATETIME,
    duration INTEGER DEFAULT 0 NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE categories(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title VARCHAR(150) NOT NULL
);

CREATE TABLE categories_recipes(
    recipe_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id,category_id),
    UNIQUE(recipe_id,category_id)
);

CREATE TABLE ingredients(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name VARCHAR(150)
);

CREATE TABLE ingredients_recipes(
    recipe_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity INTEGER,
    unit VARCHAR(20),
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id,ingredient_id),
    UNIQUE(recipe_id,ingredient_id)
);


INSERT INTO users (username,email) VALUES 
('John Doe','john@gmail.com');


INSERT INTO categories (title) VALUES 
    ('Plats'),
    ('Dessert'),
    ('Gateau');

INSERT INTO recipes (title,slug,duration,user_id) VALUES 
    ('Soupe' , 'soupe' , 10, 1),
    ('Madeline', 'madeline', 30, 1);

INSERT INTO categories_recipes(recipe_id,category_id) VALUES 
    (1,1),
    (2,2),
    (2,3);

SELECT r.title,c.title as category
FROM recipes r 
JOIN categories_recipes cr ON cr.recipe_id=r.id
JOIN categories c ON cr.category_id=c.id;

INSERT INTO ingredients (name) VALUES
    ('sucre'),
    ('farine'),
    ('levure chimique'),
    ('lait'),
    ('legume'),
    ('fromage');

INSERT INTO ingredients_recipes (recipe_id, ingredient_id , quantity , unit) VALUES
    (2,2,200,'g'),
    (2,1,150,'g'),
    (2,3,8,'g'),
    (2,4,100,'g'),
    (2,5,50,'g'),
    (2,6,3,NULL);

SELECT r.title 
FROM ingredients i
JOIN ingredients_recipes ir ON ir.ingredient_id = i.id
JOIN recipes r ON ir.recipe_id = r.id
WHERE i.name='legume';

SELECT *
FROM recipes r
LEFT JOIN ingredients_recipes ir ON ir.recipe_id=r.id
WHERE ir.recipe_id IS NULL;

DELETE FROM ingredients WHERE id=3;
SELECT * FROM ingredients_recipes;

UPDATE ingredients_recipes 
SET quantity=10
WHERE recipe_id=2 AND ingredient_id=3;

SELECT r.title,ir.quantity,i.name as ingredient
from recipes r
Join ingredients_recipes ir ON ir.recipe_id=r.id
Join ingredients i ON ir.ingredient_id=i.id;