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

/*13 Weight and name for all parts sold by suppliers in Mass*/
SELECT A.name, SUM(C.weight*B.quan) FROM jbsupplier A JOIN jbsupply B ON B.supplier = A.id JOIN jbparts C ON C.id = B.part WHERE city IN (SELECT jbcity.id FROM jbcity WHERE state ='Mass') GROUP BY A.name;

/*
+--------------+----------------------+
| name         | SUM(C.weight*B.quan) |
+--------------+----------------------+
| DEC          |                 3120 |
| Fisher-Price |              1135000 |
+--------------+----------------------+
2 rows in set (0,01 sec)
*/

/*14 Created a new table calle temp, similar to jbitem, and filled it with all the items that cost less than the average item*/
CREATE TABLE temp ( id int, name VARCHAR(50), dept int, price int, qoh int, supplier int, primary key (id), FOREIGN KEY (supplier) REFERENCES jbsupplier (id), FOREIGN
KEY (dept) REFERENCES jbdept (id));

INSERT INTO temp SELECT * FROM jbitem WHERE price <(SELECT AVG(price) FROM jbitem);

SELECT * FROM temp;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0,01 sec)
*/


/*15 Created a view that contains all the items that cost less than the average item*/
CREATE VIEW temp_view AS SELECT * FROM temp;
 SELECT * FROM temp_view;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0,00 sec)
*/

/*16 difference between a table and a view*/
/*A table is structued with columns and rows, while a view is a virtual table extracted from a database. A view can join data from several tables.
The view is dynamic and the table is static. What this means is that the view derives the data from the choosen tables and is always up to date.
This basically means that you don't have to tamper with the view if something changes in the table, hence making it dynamic.*/

/*17 A view that contains the total sum of all products that have been sold*/
CREATE VIEW debit_view AS SELECT A.id, SUM(B.quantity*C.price) FROM jbdebit A, jbsale B, jbitem C WHERE A.id = B.debit AND B.item = C.id  GROUP
BY A.id;

SELECT * FROM debit_view;

/*
+--------+-------------------------+
| id     | SUM(B.quantity*C.price) |
+--------+-------------------------+
| 100581 |                    2050 |
| 100582 |                    1000 |
| 100586 |                   13446 |
| 100592 |                     650 |
| 100593 |                     430 |
| 100594 |                    3295 |
+--------+-------------------------+
6 rows in set (0,00 sec)
*/

/*18 Does the same thing as in the previous point, with the difference that the JOIN clause is captured in the SELECT clause. 
The choice of JOIN was made base on the fact that the inner JOIN removes rows that don't match, 
this is helpful since we are not interested in those rows.*/
CREATE VIEW debit_view2_0 AS SELECT A.id, SUM(B.quantity*C.price) FROM jbdebit A JOIN jbsale B ON A.id = B.debit JOIN jbitem C ON B.item = C.id
GROUP BY A.id;

SELECT * FROM debit_view2_0;

/*
+--------+-------------------------+
| id     | SUM(B.quantity*C.price) |
+--------+-------------------------+
| 100581 |                    2050 |
| 100582 |                    1000 |
| 100586 |                   13446 |
| 100592 |                     650 |
| 100593 |                     430 |
| 100594 |                    3295 |
+--------+-------------------------+
6 rows in set (0,00 sec)
*/

/*19*/
DELETE FROM jbsale WHERE item IN (SELECT A.id FROM jbitem A, jbsupplier B, jbcity C WHERE C.id = B.city AND A.supplier = B.id AND C.name = "Los Angeles");

DELETE FROM jbitem WHERE supplier = (SELECT id FROM jbsupplier WHERE city = (SELECT id FROM jbcity WHERE name = "Los Angeles"));

DROP TABLE temp;

DELETE FROM jbsupplier WHERE city = (SELECT id FROM jbcity WHERE name = "Los Angeles");

SELECT * FROM jbsupplier;

/*
+-----+--------------+------+
| id  | name         | city |
+-----+--------------+------+
|   5 | Amdahl       |  921 |
|  15 | White Stag   |  106 |
|  20 | Wormley      |  118 |
|  33 | Levi-Strauss |  941 |
|  42 | Whitman's    |  802 |
|  62 | Data General |  303 |
|  67 | Edger        |  841 |
|  89 | Fisher-Price |   21 |
| 122 | White Paper  |  981 |
| 125 | Playskool    |  752 |
| 213 | Cannon       |  303 |
| 241 | IBM          |  100 |
| 440 | Spooley      |  609 |
| 475 | DEC          |   10 |
| 999 | A E Neumann  |  537 |
+-----+--------------+------+
15 rows in set (0,00 sec)
*/
