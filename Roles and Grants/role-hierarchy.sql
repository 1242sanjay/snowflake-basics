-- role should be created using security admin
select current_account(), current_role(), current_user();
use role securityadmin;

/*
1. PM - This role can create database and everything inside database + warehouse.
2. Dev Team - They can do everything inside the database but can not create a new database or warehouse.
3. Analyst - They can do read all the data from tables and views but nothing more than that.
4. QA - They can do read all the data from tables and views but nothing more than that.
*/

create role "DE_PM_ROLE" comment = 'This is project manager role for sales project';
grant role "DE_PM_ROLE" to role "SECURITYADMIN";

create role "DE_DEV_TEAM" comment = 'This is development team';
grant role "DE_DEV_TEAM" to role "DE_PM_ROLE";

create role "DE_ANALYST" comment = 'This is analyst team';
grant role "DE_ANALYST" to role "DE_PM_ROLE";

create role "DE_QA" comment = 'This is analyst team';
grant role "DE_QA" to role "DE_ANALYST";

-- We can see the role hierarchy in snowsight

-- Let's create users, for user creation we should use useradmin role
use role useradmin;
create user pm_user password = 'Test@12$4' comment = 'this is a pm pm_user' must_change_password = false;
create user ba_user password = 'Test@12$4' comment = 'this is a ba ba_user' must_change_password = false;
create user qa_user01 password = 'Test@12$4' comment = 'this is a qa qa_user01' must_change_password = false;
create user qa_user02 password = 'Test@12$4' comment = 'this is a qa qa_user02' must_change_password = false;
create user dev_user01 password = 'Test@12$4' comment = 'this is a dev-01 user' must_change_password = false;
create user dev_user02 password = 'Test@12$4' comment = 'this is a dev-02 user' must_change_password = false;
create user dev_user03 password = 'Test@12$4' comment = 'this is a dev-03 user' must_change_password = false;

-- Assign role to user you should always use securityadmin role
use role securityadmin;
grant role DE_PM_ROLE to user pm_user;
grant role DE_ANALYST to user ba_user;
grant role DE_QA to user qa_user01;
grant role DE_QA to user qa_user02;
grant role DE_DEV_TEAM to user dev_user01;
grant role DE_DEV_TEAM to user dev_user02;
grant role DE_DEV_TEAM to user dev_user03;

-- PM role will create warehouse and database (also can create schema, table anything)
use role SYSADMIN;
select current_account(),current_user(), current_role();

grant create warehouse on account to role DE_PM_ROLE;
grant create database on account to role DE_PM_ROLE;

-- Now login with PM user and create/run below queries
-- use role DE_PM_ROLE;

-- create warehouse load_wh 
-- with 
-- warehouse_size = 'xlarge' 
-- warehouse_type = 'standard' 
-- auto_suspend = 300 
-- auto_resume = true 
-- min_cluster_count = 1
-- max_cluster_count = 1 
-- scaling_policy = 'standard';

-- create warehouse adhoc_wh 
-- with 
-- warehouse_size = 'xsmall' 
-- warehouse_type = 'standard' 
-- auto_suspend = 300 
-- auto_resume = true 
-- min_cluster_count = 1
-- max_cluster_count = 1 
-- scaling_policy = 'standard';

-- show warehouses;

-- create database sales_db;
-- create schema sales_schema;
-- create table order_tables (c1 varchar);

-- insert into  order_tables (c1) values ('by role DE_PM_ROLE');
-- select * from order_tables;

-- Now after creating these objects, gave permission to DEV, QA and BA users from your team
grant usage on database sales_db to role DE_DEV_TEAM;
grant all privileges on schema sales_schema to role DE_DEV_TEAM;
grant all privileges on all tables in schema sales_schema to role DE_DEV_TEAM;
grant usage on warehouse load_wh to role DE_DEV_TEAM;
grant usage on warehouse adhoc_wh to role DE_DEV_TEAM;

grant usage on database sales_db to role DE_ANALYST;
grant usage on schema sales_schema to role DE_ANALYST;
grant select on all tables in schema sales_schema to role DE_ANALYST;
grant usage on warehouse adhoc_wh to role DE_ANALYST;

grant usage on database sales_db to role DE_QA;
grant usage on schema sales_schema to role DE_QA;
grant select on all tables in schema sales_schema to role DE_QA;
grant usage on warehouse adhoc_wh to role DE_QA;

grant usage on database sales_db to role DE_DEV_TEAM;
grant all privileges on schema sales_schema to role DE_DEV_TEAM;
grant all privileges on all tables in schema sales_schema to role DE_DEV_TEAM;
