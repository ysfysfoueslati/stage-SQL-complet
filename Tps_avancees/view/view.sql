-- SQLite

CREATE VIEW recipes_with_ingredients
AS
    SELECT r.title, GROUP_CONCAT(i.name, ', ') AS ingredients
    FROM recipes r
    LEFT JOIN ingredients_recipes ir ON ir.recipe_id = r.id
    LEFT JOIN ingredients i ON ir.ingredient_id = i.id
    GROUP BY r.title;

SELECT *
FROM recipes_with_ingredients;