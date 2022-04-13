
drop table if exists flight cascade;
drop table if exists pays cascade;
drop table if exists reservation cascade;
drop table if exists contact_person cascade;
drop table if exists credit_card_holder cascade;
drop table if exists passengerBooking cascade;
drop table if exists booking cascade;
drop table if exists passenger cascade;
drop table if exists weekly_schedule cascade;
drop table if exists route cascade;
drop table if exists airport cascade;
drop table if exists day cascade;
drop table if exists year cascade;


drop procedure if exists addYear;
drop procedure if exists addDay;
drop procedure if exists addDestination;
drop procedure if exists addRoute;
drop procedure if exists addFlight;

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
booked_passengers integer,
week integer,
FOREIGN KEY (ws_id) REFERENCES weekly_schedule(id)
);

CREATE TABLE reservation(
reservation_nr integer PRIMARY KEY,
nr_of_passengers integer
);

CREATE TABLE passenger (
passport_nr integer PRIMARY KEY,
name varchar(30)
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
DECLARE route_id integer;
DECLARE temp_ws_id integer;
SET route_id = (SELECT route_id FROM route A WHERE A.departure_airport_code = departure_airport_code AND A.arrival_airport_code = arrival_airport_code AND A.year=year);
INSERT INTO weekly_schedule (year, day, route_id, time_of_dept)
VALUES (year, day, route_id, departure_time);

-- while loop for 52 weeks
SET temp_ws_id =(SELECT id FROM weekly_schedule WHERE route_id=route_id); 
insert_flights:
WHILE temp_week <= 52 DO
INSERT INTO flight(ws_id, week)
VALUES(temp_ws_id, temp_week);
SET temp_week = temp_week + 1;
END WHILE insert_flights;

END //


CREATE PROCEDURE addReservation(IN departure_airport_code varchar(3),
 IN arrival_airport_code varchar(3), IN year integer, IN week integer, IN day varchar(10),
 IN time time, IN number_of_passengers integer, IN output_reservation_nr integer)
 BEGIN
 
 
 
 END //



-- Functions

CREATE FUNCTION calculateFreeSeats(flightnumber int) RETURNS INTEGER

BEGIN
DECLARE seatsLeft INT;

SET seatsLeft = 40 - (SELECT booked_passengers FROM flight WHERE flightnumber = flight_nr);


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