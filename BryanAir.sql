SET FOREIGN_KEY_CHECKS = 0;
drop table if exists reserved cascade;

drop table if exists pays cascade;

drop table if exists CR_has cascade;
drop table if exists contact_person cascade;
drop table if exists credit_card_holder cascade;
drop table if exists passengerBooking cascade;
drop table if exists booking cascade;
drop table if exists passenger cascade;

drop table if exists flight cascade;
drop table if exists reservation cascade;
drop table if exists weekly_schedule cascade;
drop table if exists route cascade;
drop table if exists airport cascade;
drop table if exists day cascade;
drop table if exists year cascade;

SET FOREIGN_KEY_CHECKS = 1;

drop procedure if exists addYear;
drop procedure if exists addDay;
drop procedure if exists addDestination;
drop procedure if exists addRoute;
drop procedure if exists addFlight;
drop procedure if exists addReservation;
drop procedure if exists addPassenger;
drop procedure if exists addContact;
drop procedure if exists addPayment;

drop function if exists calculateFreeSeats;
drop function if exists calculatePrice;

drop trigger if exists createTicketNr;

CREATE TABLE airport(
airport_code varchar(3) PRIMARY KEY,
name varchar(30),
country varchar(30)
);

CREATE TABLE year(
year integer PRIMARY KEY,
profit_factor double
);

CREATE TABLE day(
day varchar(10) PRIMARY KEY,
year integer,
week_day_factor double,
FOREIGN KEY (year) REFERENCES year(year)
);

CREATE TABLE route (
route_id integer PRIMARY KEY auto_increment,
departure_airport_code varchar(3),
arrival_airport_code varchar(3),
year integer,
routeprice double,
FOREIGN KEY (departure_airport_code) REFERENCES airport(airport_code),
FOREIGN KEY (arrival_airport_code) REFERENCES airport(airport_code),
FOREIGN KEY (year) REFERENCES year(year)
);

CREATE TABLE weekly_schedule(
id integer PRIMARY KEY auto_increment,
year integer,
day varchar(10),
route_id integer,
time_of_dept time,
FOREIGN KEY (day) REFERENCES day(day),
FOREIGN KEY (year) REFERENCES year(year),
FOREIGN KEY (route_id) REFERENCES route(route_id)
);

CREATE TABLE flight(
flight_nr integer PRIMARY KEY auto_increment,
ws_id integer,
booked_passengers integer default 40,
week integer,
FOREIGN KEY (ws_id) REFERENCES weekly_schedule(id)
);

CREATE TABLE reservation(
reservation_nr integer PRIMARY KEY auto_increment,
nr_of_passengers integer
);

CREATE TABLE passenger (
passport_nr integer PRIMARY KEY,
name varchar(30),
reservation_nr integer,
FOREIGN KEY (reservation_nr) REFERENCES reservation(reservation_nr)
);

CREATE TABLE contact_person (
phone_nr bigint,
email varchar(30),
pass_nr integer PRIMARY KEY,
FOREIGN KEY (pass_nr) REFERENCES passenger(passport_nr)
);

CREATE TABLE credit_card_holder(
card_nr bigint PRIMARY KEY,
name varchar(30) 
);

CREATE TABLE booking (
booking_id integer PRIMARY KEY auto_increment,
price double
);

CREATE TABLE passengerBooking (
ticket_nr integer PRIMARY KEY,
booking_id integer,
passport_nr integer,
FOREIGN KEY (passport_nr) REFERENCES passenger(passport_nr),
FOREIGN KEY (booking_id) REFERENCES booking(booking_id)

);

CREATE TABLE pays (
booking_id integer PRIMARY KEY,
card_nr bigint,
reservation_nr integer,
FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
FOREIGN KEY (card_nr) REFERENCES credit_card_holder(card_nr),
FOREIGN KEY (reservation_nr) REFERENCES reservation(reservation_nr)

);

CREATE TABLE reserved (
reservation_nr integer PRIMARY KEY,
flight_nr integer,
FOREIGN KEY (reservation_nr) REFERENCES reservation(reservation_nr),
FOREIGN KEY (flight_nr) REFERENCES flight(flight_nr)
);

CREATE TABLE CR_has (
reservation_nr integer PRIMARY KEY,
passport_nr integer,
FOREIGN KEY (reservation_nr) REFERENCES reservation(reservation_nr),
FOREIGN KEY (passport_nr) REFERENCES contact_person(pass_nr)
);


/*
Procedures
*/

delimiter //

CREATE PROCEDURE addYear(IN year INTEGER, IN factor DOUBLE)
BEGIN
INSERT INTO year(year, profit_factor)
VALUES (year, factor);
END //

CREATE PROCEDURE addDay(IN year INTEGER, IN day varchar(10), IN factor DOUBLE)
BEGIN
INSERT INTO day (year, day, week_day_factor)
VALUES (year, day, factor);
END //

CREATE PROCEDURE addDestination(IN airport_code varchar(3), IN name varchar(30), IN country varchar(30))
BEGIN
INSERT INTO airport (airport_code, name, country)
VALUES (airport_code, name, country);
END //

CREATE PROCEDURE addRoute(IN departure_airport_code varchar(3), IN arrival_airport_code varchar(3), IN year integer, IN routeprice double)
BEGIN
INSERT INTO route (departure_airport_code, arrival_airport_code, year, routeprice)
VALUES (departure_airport_code, arrival_airport_code, year, routeprice);
END //

CREATE PROCEDURE addFlight(IN departure_airport_code varchar(3), IN arrival_airport_code varchar(3), IN year integer, IN day varchar(10), IN departure_time time)
BEGIN
-- DECLARE id integer;
DECLARE temp_week integer default 1;
DECLARE temp_route_id integer;
DECLARE temp_ws_id integer;

SET temp_route_id = (SELECT C.route_id FROM route C WHERE 
C.departure_airport_code = departure_airport_code AND C.arrival_airport_code = arrival_airport_code AND C.year = year);

INSERT INTO weekly_schedule (year, day, route_id, time_of_dept)
VALUES (year, day, temp_route_id, departure_time);

-- while loop for 52 weeks
SET temp_ws_id = last_insert_id();
insert_flights:
WHILE temp_week <= 52 DO
INSERT INTO flight(ws_id, week)
VALUES(temp_ws_id, temp_week);
SET temp_week = temp_week + 1;
END WHILE insert_flights;

END //


CREATE PROCEDURE addReservation(IN departure_airport_code varchar(3),
 IN arrival_airport_code varchar(3), IN year integer, IN week integer, IN day varchar(10),
 IN dept_time time, IN number_of_passengers integer, OUT output_reservation_nr integer)
 
 BEGIN
 DECLARE temp_route_id integer;
 DECLARE temp_ws_id integer;
 DECLARE temp_flight_nr integer;
 
--  SET temp_flight_nr = (SELECT A.flight_nr FROM flight A WHERE A.week = week AND A.ws_id = 
--  (SELECT B.id FROM weekly_schedule B WHERE B.day = day AND B.year = year AND 
--  B.route_id = (SELECT C.route_id FROM route C WHERE 
--  C.departure_airport_code = departure_airport_code AND C.arrival_airport_code = arrival_airport_code AND C.year = year))); 

SET temp_route_id = (SELECT C.route_id FROM route C WHERE 
C.departure_airport_code = departure_airport_code AND C.arrival_airport_code = arrival_airport_code AND C.year = year);

SET temp_ws_id = (
SELECT A.id FROM weekly_schedule A WHERE A.route_id = temp_route_id AND A.day = day AND A.year = year AND
A.time_of_dept = dept_time);

SET temp_flight_nr = (SELECT A.flight_nr FROM flight A WHERE A.ws_id = temp_ws_id AND A.week = week);

IF temp_flight_nr IS NOT NULL THEN

IF calculateFreeSeats(temp_flight_nr) >= number_of_passengers THEN

INSERT INTO reservation(nr_of_passengers) VALUES (number_of_passengers);
SET output_reservation_nr = last_insert_id();
-- SELECT LAST_INSERT_INTO() INTO output_reservation_nr;
ELSE
SELECT "There are not enough empty seats" AS "Message";
END IF;
ELSE
SELECT "There exist no flight for the given route, date and time" AS "Message";
END IF;

 
 END //


CREATE PROCEDURE addPassenger(IN reservation_nr integer, IN passport_number integer, IN name varchar(30))

BEGIN
IF EXISTS (SELECT A.reservation_nr FROM reservation A WHERE A.reservation_nr = reservation_nr) THEN
INSERT INTO passenger(passport_nr, name, reservation_nr) VALUES (passport_number, name, reservation_nr);
ELSE
SELECT "The given reservation number does not exist" AS "Message";
END IF;


END //

CREATE PROCEDURE addContact(IN reservation_nr integer, IN passport_number integer, IN email varchar(30), IN phone bigint)

BEGIN
IF EXISTS (SELECT A.passport_nr FROM passenger A WHERE A.reservation_nr = reservation_nr AND A.passport_nr = passport_number) THEN
INSERT INTO contact_person(phone_nr, email, pass_number) VALUES (phone, email, passport_number);
ELSE 
SELECT "The person is not a passenger on the reservation" AS "Message";
END IF;

END //

CREATE PROCEDURE addPayment(IN reservation_nr integer, IN cardholder_name varchar(30), IN credit_card_number bigint)

BEGIN
DECLARE flight_nr integer;
DECLARE nr_of_passengers integer;
DECLARE price integer;

IF EXISTS (SELECT A.reservation_nr FROM reservation A WHERE A.reservation_nr = reservation_nr) THEN
	IF EXISTS (SELECT A.passport_nr FROM CR_has A WHERE A.reservation_nr = reservation_nr) THEN
          SET flight_nr = (SELECT A.flight_nr FROM reserved A WHERE A.reservation_nr = reservation_nr);
         
    SET nr_of_passengers =(SELECT A.nr_of_passengers FROM reservation A WHERE A.reservation_nr = reservation_nr);
		IF nr_of_passengers <= calculateFreeSeats(flight_nr) THEN
        SET price = calculatePrice(fligth_nr);
        INSERT INTO booking(price) VALUES (price);
        INSERT INTO credit_card_holder(card_nr, name) VALUES (credit_card_number ,cardholder_name);
        ELSE 
        SELECT "There are not enough seats available on the flight anymore, deleting reservation" AS "Message";
		END IF;
	ELSE 
    SELECT "The reservation has no contact yet" AS "Message";
    END IF;
ELSE
SELECT "The given reservation number does not exist" AS "Message";
END IF;

END //

-- Functions

CREATE FUNCTION calculateFreeSeats(flightnumber int) RETURNS INTEGER

BEGIN
DECLARE seatsLeft integer;

SET seatsLeft =(SELECT booked_passengers FROM flight WHERE flightnumber = flight_nr);

RETURN seatsLeft;

END //

CREATE FUNCTION calculatePrice(flightnumber int) RETURNS DOUBLE

BEGIN
DECLARE finalPrice DOUBLE;
DECLARE rPrice DOUBLE;
DECLARE wDayFactor DOUBLE;
DECLARE bPassengers INT;
DECLARE pFactor DOUBLE;
DECLARE routeID int;
DECLARE wsID int;
DECLARE wDay varchar(10);
DECLARE temp_year INT;

SET wsID = (SELECT ws_id FROM flight WHERE flightnumber = flight_nr);
SET routeID = (SELECT route_id FROM weekly_schedule WHERE wsID = id);

SET rPrice = (SELECT routeprice FROM route WHERE routeID = route_id);
SET wDay = (SELECT day FROM weekly_schedule WHERE wsID = id);
SET temp_year = (SELECT year FROM weekly_schedule WHERE wsID = id);
SET wDayFactor = (SELECT week_day_factor FROM day WHERE day = day AND temp_year = year);
SET pFactor = (SELECT profit_factor FROM year WHERE temp_year = year);
SET bPassengers = (SELECT booked_passengers FROM flight WHERE flightnumber = flight_nr);

SET finalPrice = rPrice*wDayFactor*((bPassengers+1)/40)*pFactor;

RETURN finalPrice;

END //

-- Trigger

CREATE TRIGGER createTicketNr 
AFTER INSERT ON pays
FOR EACH ROW
INSERT INTO passengerBooking
SET ACTION = 'insert',
passengerBooking.ticket_nr = rand();
//
