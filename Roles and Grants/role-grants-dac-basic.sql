-- Step-1: Create Snowflake User Without Role & Default Role

select current_account(), current_role(), current_user();
use role accountadmin;

-- lets create a user01 and this user will gets default role
CREATE USER user01 
    PASSWORD = 'Test@124' 
    COMMENT = 'this is a trial user with name user01' 
    MUST_CHANGE_PASSWORD = FALSE;

-- Login to new accounts and run below queries
-- select current_role();
-- show grants to role public;
-- create database mytest_db;
-- desc user user01;
-- show grants to user user01;
-- show grants on user user01;

-- Step-2: Create Snowflake User With Multiple Roles
-- create user02 and have multiple roles
CREATE USER user02 
    PASSWORD = 'SnR@mymarch025' 
    DEFAULT_ROLE = "SYSADMIN" 
    MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE "SYSADMIN" TO USER user02;

-- Login to new accounts and run below queries
-- select current_role();
-- show grants to role sysadmin;
-- desc user user02;
-- show grants to user user02;
-- show grants on user user02;

-- adding more roles to user02
-- and refresh the user02 screen and see the result
GRANT ROLE "SECURITYADMIN" TO USER user02;
GRANT ROLE "USERADMIN" TO USER user02;

-- DAC
-- context function
select current_account(), current_role(), current_user();

-- lets list all the users to show the ownership
use role accountadmin;
use role sysadmin;
show users;

-- lets create a database, schema and table to see the owner
create database my_db;
show databases;
create schema my_shema;
show schemas;
create table my_table(c1 varchar);
show tables;

-- Login to user02 accounts and run below queries
-- select current_account(), current_role(), current_user();
-- show databases;
-- use database my_db;
-- show schemas;
-- use schema my_shema;
-- show tables;
-- drop schema my_shema;
-- show schemas;