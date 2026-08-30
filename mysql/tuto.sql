
CREATE TABLE posts(
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT,
    online TINYINT DEFAULT 0
);

INSERT INTO posts(title,online) VALUES ('Hello',0);
INSERT INTO posts(title,online) VALUES ('Hello online',1);
INSERT INTO posts(title,online) VALUES ('Hello bad','azaezae');

UPDATE posts set online = 1 WHERE id='3';

ALTER TABLE posts MODIFY online BOOLEAN NOT NULL DEFAULT 0;
SELECT * FROM posts;

ALTER Table posts 
add published_at DATETIME;

INSERT INTO posts (title,published_at) VALUES ('hello world','2026-8-30 00:00:00');

SELECT title,TIMEDIFF(NOW(),published_at) FROM posts;

ALTER Table posts
ADD created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

UPDATE posts SET title='hello2' WHERE id=1;

SELECT * FROM posts;


/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */
DROP TABLE posts;
CREATE TABLE posts(
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT,
    online TINYINT DEFAULT 0
);
/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */

ALTER TABLE posts
ADD location POINT;

INSERT INTO posts (title, location) VALUES 
('Poitiers', ST_GeomFromText('POINT(0.340196 46.580260)')),
('Montpellier', ST_GeomFromText('POINT(3.876734 43.611242)')),
('Paris', ST_GeomFromText('POINT(2.349014 48.864716)'));

SELECT ROUND(ST_Distance_Sphere(
    (SELECT location FROM posts WHERE title='Montpellier'),
    (SELECT location FROM posts WHERE title='Paris')
)/1000) as distance;

SELECT title FROM posts WHERE ST_Distance_Sphere(
    location,
    (SELECT location FROM posts WHERE title = "Montpellier")
) > 200000;


/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */
DROP TABLE posts;
CREATE TABLE posts(
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT,
    online VARCHAR(255) DEFAULT 0
);
/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */


/* creation JSON*/


ALTER TABLE posts
ADD author JSON;

INSERT INTO posts (title,author) VALUES ('Titre de John', '{"age":20,"firstname":"John"}');
INSERT INTO posts (title,author) VALUES ('Titre de Jane', '{"age":30,"firstname":"Jane"}');

SELECT * FROM posts WHERE author->"$.age">20;

INSERT INTO posts(title) VALUES('titre sans author');

SELECT author->"$.age" FROM posts ;

UPDATE posts SET author=JSON_SET(author , '$.age',author->'$.age'+2) WHERE id=1;

SELECT author->"$.age" FROM posts ;

INSERT INTO posts (title,author) VALUES ('Titre de John Doe', '{"age":25,"firstname":"John\\"Doe"}');

SELECT author->>"$.firstname" FROM posts;


/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */
DROP TABLE posts;
CREATE TABLE posts(
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT,
    online TINYINT DEFAULT 0,
    FULLTEXT(content)
);
/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */

INSERT INTO posts (title, content) VALUES
    ('Lorem', 'Laudantium laudantium doloribus aperiam. Molestias est iste commodi numquam molestias veritatis dolor'),
    ('Raton Laveur', 'Le raton laveur est une espèce de mammifère'),
    ('Raton rat', 'Le raton est le bébé du rat'),
    ('Raton space', 'Le raton qui avait comme emploi laveur de carreau'),
    ('Raton double', 'Le raton qui avait comme ami un autre raton laveur');

SELECT *
FROM posts 
WHERE MATCH (content) AGAINST ('raton' IN NATURAL LANGUAGE MODE);

SELECT * FROM INFORMATION_SCHEMA.INNODB_FT_DEFAULT_STOPWORD;


/* <-------------------------------------------> */
                /* Permissions */
/* <-------------------------------------------> */
CREATE USER 'YoussefSQL'@'%' IDENTIFIED BY '080106';

GRANT SELECT ON tuto.posts TO 'YoussefSQL'@'%';

CREATE Table users(
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);

SELECT * FROM mysql.user;

SHOW GRANTS FOR 'YoussefSQL'@'%';

REVOKE SELECT ON `tuto`.`posts` FROM 'YoussefSQL'@'%'

SHOW GRANTS FOR 'YoussefSQL'@'%';

DROP USER 'YoussefSQL'@'%';



/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */
DROP TABLE posts;
CREATE TABLE posts(
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT,
    online TINYINT DEFAULT 0
);
/* <-------------------------------------------> */
/* reset de table*/
/* <-------------------------------------------> */

ALTER TABLE posts
ADD location POINT;

INSERT INTO posts (title, location) VALUES 
('Poitiers', ST_GeomFromText('POINT(0.340196 46.580260)')),
('Montpellier', ST_GeomFromText('POINT(3.876734 43.611242)')),
('Paris', ST_GeomFromText('POINT(2.349014 48.864716)'));

DELIMITER $
CREATE Procedure getDistances ()
BEGIN
    SELECT * FROM posts;
END$

DELIMITER ;

SHOW PROCEDURE STATUS;

CALL getDistances();

DROP PROCEDURE IF EXISTS getDistances;
DELIMITER $
CREATE PROCEDURE getClosestCity (
    IN city VARCHAR(255),
    OUT closestCity VARCHAR(255) 
)
BEGIN
    SELECT subquery.title INTO closestCity FROM (
        SELECT 
            title, 
            ST_Distance_Sphere(
                location,
                (SELECT location FROM posts WHERE title = city)
            ) as distance
        FROM posts
        WHERE title != city
        ORDER BY distance DESC
        LIMIT 1
    ) as subquery;
END$
Delimiter ;

CALL getClosestCity('Paris',@city);
