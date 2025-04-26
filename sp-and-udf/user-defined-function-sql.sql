-- Basic SQL scalar UDF
create function pi_udf()
returns float
as '3.14::float'
;

select pi_udf();


-- expression with SELECT statement
CREATE TABLE purchases (number_sold INTEGER, wholesale_price NUMBER(7,2), retail_price NUMBER(7,2));
INSERT INTO purchases (number_sold, wholesale_price, retail_price) VALUES 
   (3,  10.00,  20.00),
   (5, 100.00, 200.00)
   ;


create or replace function profit()
returns number(11, 2)
as 
$$
select sum((retail_price-wholesale_price)*number_sold) from purchases
$$;

select profit();


-- UDF in a WITH clause
CREATE TABLE circles (diameter FLOAT);

INSERT INTO circles (diameter) VALUES
    (2.0),
    (4.0);

CREATE FUNCTION diameter_to_radius(f FLOAT) 
  RETURNS FLOAT
  AS 
  $$ f / 2 $$
  ;

with radii as (
select diameter_to_radius(diameter) as radius from circles
)
select radius from radii order by 1
;


-- JOIN operation
CREATE TABLE orders (product_ID varchar, quantity integer, price numeric(11, 2), buyer_info varchar);
CREATE TABLE inventory (product_ID varchar, quantity integer, price numeric(11, 2), vendor_info varchar);
INSERT INTO inventory (product_ID, quantity, price, vendor_info) VALUES 
  ('X24 Bicycle', 4, 1000.00, 'HelloVelo'),
  ('GreenStar Helmet', 8, 50.00, 'MellowVelo'),
  ('SoundFX', 5, 20.00, 'Annoying FX Corporation');
INSERT INTO orders (product_id, quantity, price, buyer_info) VALUES 
  ('X24 Bicycle', 1, 1500.00, 'Jennifer Juniper'),
  ('GreenStar Helmet', 1, 75.00, 'Donovan Liege'),
  ('GreenStar Helmet', 1, 75.00, 'Montgomery Python');


CREATE FUNCTION store_profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
  SELECT SUM( (o.price - i.price) * o.quantity) 
    FROM orders AS o, inventory AS i 
    WHERE o.product_id = i.product_id
  $$
  ;

  SELECT store_profit();


 -- Using SQL variables in a UDF
SET id_threshold = (SELECT COUNT(*)/2 FROM table1);

CREATE OR REPLACE FUNCTION my_filter_function()
RETURNS TABLE (id int)
AS
$$
SELECT id FROM table1 WHERE id > $id_threshold
$$
;