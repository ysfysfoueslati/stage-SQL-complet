-- SQLite
DROP TRIGGER IF EXISTS increment_usage_count_on_ingredients_linked;
DROP TRIGGER IF EXISTS decrement_usage_count_on_ingredients_unlinked;

CREATE TRIGGER increment_usage_count_on_ingredients_linked
AFTER INSERT ON ingredients_recipes
BEGIN
    UPDATE ingredients
    SET usage_count = usage_count + 1
    WHERE id = NEW.ingredient_id;
END;

CREATE TRIGGER decrement_usage_count_on_ingredients_unlinked
AFTER DELETE ON ingredients_recipes
BEGIN 
    UPDATE ingredients
    SET usage_count = usage_count - 1
    WHERE id = OLD.ingredient_id;
END;

DELETE FROM ingredients_recipes WHERE recipe_id = 1 AND ingredient_id = 7;

INSERT INTO ingredients_recipes (recipe_id, ingredient_id, quantity, unit)
VALUES (1, 7, 10, 'g');

