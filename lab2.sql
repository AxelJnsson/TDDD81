/*Lab 2 Martin Hörnberg (marho558) Axel Jönsson (axejo347)*/
SOURCE company_schema.sql;
SOURCE company_data.sql;

/*Question 1 List all employees, i.e., all tuples in the jbemployee relation*/
SELECT * FROM jbemployee;

/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
25 rows in set (0,00 sec)
*/

/*Question 2 List all dept. names alphabeticaly*/
SELECT name FROM jbdept ORDER BY name;

/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
19 rows in set (0,00 sec)
*/

/*Question 3 Lists the name of all parts that are not in store currently*/
SELECT name FROM jbparts WHERE qoh=0;

/*
+-------------------+
| name              |
+-------------------+
| card reader       |
| card punch        |
| paper tape reader |
| paper tape punch  |
+-------------------+
4 rows in set (0,00 sec)
*/

/*Question 4 Lists the name of all employees with a salary between 9000 and 10000*/
 SELECT name FROM jbemployee WHERE salary>=9000 AND salary<=10000;

 /*
+----------------+
| name           |
+----------------+
| Edwards, Peter |
| Smythe, Carol  |
| Williams, Judy |
| Thomas, Tom    |
+----------------+
4 rows in set (0,00 sec)
 */

/*Question 5 Lists the name and age of all employees*/
SELECT name,(startyear-birthyear) AS "Age" FROM jbemployee;

/*
+--------------------+------+
| name               | Age  |
+--------------------+------+
| Ross, Stanley      |   18 |
| Ross, Stuart       |    1 |
| Edwards, Peter     |   30 |
| Thompson, Bob      |   40 |
| Smythe, Carol      |   38 |
| Hayes, Evelyn      |   32 |
| Evans, Michael     |   22 |
| Raveen, Lemont     |   24 |
| James, Mary        |   49 |
| Williams, Judy     |   34 |
| Thomas, Tom        |   21 |
| Jones, Tim         |   20 |
| Bullock, J.D.      |    0 |
| Collins, Joanne    |   21 |
| Brunet, Paul C.    |   21 |
| Schmidt, Herman    |   20 |
| Iwano, Masahiro    |   26 |
| Smith, Paul        |   21 |
| Onstad, Richard    |   19 |
| Zugnoni, Arthur A. |   21 |
| Choy, Wanda        |   23 |
| Wallace, Maggie J. |   19 |
| Bailey, Chas M.    |   19 |
| Bono, Sonny        |   24 |
| Schwarz, Jason B.  |   15 |
+--------------------+------+
25 rows in set (0,00 sec)
*/

/*Question 6 Lists the name and of all employees with a last name ending with son*/
SELECT name FROM jbemployee WHERE name LIKE '%son,%';

/*
+---------------+
| name          |
+---------------+
| Thompson, Bob |
+---------------+
1 row in set (0,00 sec)
*/

/*Question 7 Lists all items that was deliverd by Fisher-Price, with subquerries*/
SELECT name FROM jbitem WHERE supplier = (SELECT id FROM jbsupplier WHERE name ="Fisher-Price");

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0,00 sec)
*/

/*Question 8 Lists all items that was deliverd by Fisher-Price, without subquerries*/
SELECT jbitem.name FROM jbitem LEFT JOIN jbsupplier ON jbitem.supplier=jbsupplier.id WHERE jbsupplier.name = "Fisher-Price";

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0,00 sec)
*/

/*Question 9 Lists all the cities with at least one supplier*/
SELECT name FROM jbcity WHERE id IN (SELECT city FROM jbsupplier);

/*
+----------------+
| name           |
+----------------+
| Amherst        |
| Boston         |
| New York       |
| White Plains   |
| Hickville      |
| Atlanta        |
| Madison        |
| Paxton         |
| Dallas         |
| Denver         |
| Salt Lake City |
| Los Angeles    |
| San Diego      |
| San Francisco  |
| Seattle        |
+----------------+
15 rows in set (0,00 sec)
*/

/*Question 10 Lists weight and color of parts heavier than a card reader*/
SELECT name, color FROM jbparts WHERE weight > (SELECT weight FROM jbparts WHERE name = "card reader");

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0,00 sec)
*/

/*Question 11 Lists weight and color of parts heavier than a card reader, without subquerrie*/
 /*KOLLA IGEN PÅ 10 och 11*/
SELECT A.name, A.color FROM jbparts A JOIN jbparts B ON B.name = "card reader" WHERE A.weight > B.weight;

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0,00 sec)
*/

/*Question 12 Lists average weight of all black parts*/
SELECT AVG(weight) FROM jbparts WHERE color = "black";

/*
+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0,00 sec)
*/

/*13*/
SELECT * FROM jbsupplier WHERE city IN (SELECT jbcity.id FROM jbcity WHERE state ='Mass');

/*14*/


/*15*/
CREATE VIEW XXX AS SELECT name FROM jbitem GROUP BY price HAVING price < AVG(price);

/*16 difference between a table and a view*/
/*A table is structued with columns and rows, while a view is a virtual table extracted from a database. A view can join data from several tables.
The view is dynamic and the table is static. What this means is that the view derives the data from the choosen tables and is always up to date.
This basically means that you don't have to tamper with the view if something changes in the table, hence making it dynamic.*/