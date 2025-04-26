use role securityadmin;
create role "ANALYTICS_HEAD" comment = 'this is analytics head';
grant role "ANALYTICS_HEAD" to role "SECURITYADMIN";

create role "SALE_PRJ_PM" comment = 'this is project manager role for sales project';
create role "MAKETING_PRJ_PM" comment = 'this is project manager role for marketing project';

grant role "SALE_PRJ_PM" to role "ANALYTICS_HEAD";
grant role "MAKETING_PRJ_PM" to role "ANALYTICS_HEAD";

create role "SALE_PRJ_DEV_TEAM" comment = 'this is developoment team for sales project';
create role "MAKETING_PRJ_DEV_TEAM" comment = 'this is developoment team marketing project';

grant role "SALE_PRJ_DEV_TEAM" to role "SALE_PRJ_PM";
grant role "MAKETING_PRJ_DEV_TEAM" to role "MAKETING_PRJ_PM";

create role "SALE_PRJ_ANALYST" comment = 'this is analyst role for sales project';
create role "MAKETING_PRJ_ANALYST" comment = 'this is analyst role for sales project';

grant role "SALE_PRJ_ANALYST" to role "SALE_PRJ_DEV_TEAM";
grant role "MAKETING_PRJ_ANALYST" to role "MAKETING_PRJ_DEV_TEAM";


create role "SALE_PRJ_QA" comment = 'this is qa role for sales project';
create role "MAKETING_PRJ_QA" comment = 'this is qa role for marketing project';

grant role "SALE_PRJ_QA" to role "SALE_PRJ_ANALYST";
grant role "MAKETING_PRJ_QA" to role "MAKETING_PRJ_ANALYST";


use role userdmin;
create user head_analytics password = 'Test@12$4' comment = 'this is a head_analytics' must_change_password = false;
create user pm_user_01 password = 'Test@12$4' comment = 'this is a pm pm_user_01' must_change_password = false;
create user pm_user_02 password = 'Test@12$4' comment = 'this is a pm pm_user_02' must_change_password = false;
create user pm_user_03 password = 'Test@12$4' comment = 'this is a pm pm_user_03' must_change_password = false;
create user pm_user_04 password = 'Test@12$4' comment = 'this is a pm pm_user_04' must_change_password = false;
create user ba_user_01 password = 'Test@12$4' comment = 'this is a ba ba_user_01' must_change_password = false;
create user ba_user_02 password = 'Test@12$4' comment = 'this is a ba ba_user_02' must_change_password = false;
create user qa_user011 password = 'Test@12$4' comment = 'this is a qa qa_user011' must_change_password = false;
create user qa_user012 password = 'Test@12$4' comment = 'this is a qa qa_user012' must_change_password = false;
create user dev_user11 password = 'Test@12$4' comment = 'this is a dev-011 user' must_change_password = false;
create user dev_user22 password = 'Test@12$4' comment = 'this is a dev-22 user' must_change_password = false;
create user dev_user33 password = 'Test@12$4' comment = 'this is a dev-33 user' must_change_password = false;
create user dev_user44 password = 'Test@12$4' comment = 'this is a dev-044 user' must_change_password = false;
create user dev_user55 password = 'Test@12$4' comment = 'this is a dev-55 user' must_change_password = false;



use role securityadmin;

grant role "ANALYTICS_HEAD" to user head_analytics;
grant role "SALE_PRJ_PM" to user pm_user_01;
grant role "SALE_PRJ_PM" to user pm_user_02;
grant role "MAKETING_PRJ_PM" to user pm_user_03;
grant role "MAKETING_PRJ_PM" to user pm_user_04;

grant role "SALE_PRJ_DEV_TEAM" to user dev_user11;
grant role "SALE_PRJ_DEV_TEAM" to user dev_user22;
grant role "SALE_PRJ_DEV_TEAM" to user dev_user33;
grant role "SALE_PRJ_DEV_TEAM" to user dev_user44;

grant role "MAKETING_PRJ_DEV_TEAM" to user dev_user33;
grant role "MAKETING_PRJ_DEV_TEAM" to user dev_user44;
grant role "MAKETING_PRJ_DEV_TEAM" to user dev_user55;

grant role "SALE_PRJ_ANALYST" to user ba_user_01;
grant role "SALE_PRJ_ANALYST" to user ba_user_02;
grant role "MAKETING_PRJ_ANALYST" to user ba_user_01;
grant role "MAKETING_PRJ_ANALYST" to user ba_user_02;

grant role "SALE_PRJ_QA" to user qa_user011;
grant role "SALE_PRJ_QA" to user qa_user012;
grant role "MAKETING_PRJ_QA" to user qa_user011;
grant role "MAKETING_PRJ_QA" to user qa_user012;
    
use role sysadmin;
grant create warehouse  on account to role "ANALYTICS_HEAD";
grant create database on account to role "ANALYTICS_HEAD";

use role useradmin;
alter user  head_analytics set DEFAULT_ROLE='ANALYTICS_HEAD';
alter user  head_analytics set  DEFAULT_SECONDARY_ROLES = ( 'ALL' );



use role useradmin;
create user sam password = 'Test@12$4' comment = 'this sahred resource' must_change_password = false;

-- switch to the securityadmin role 
use role securityadmin;
grant role "MAKETING_PRJ_DEV_TEAM" to user sam;

-- assign sam a new role called sales project qa
grant role "SALE_PRJ_QA" to user sam;

-- set his primary role as marketing project dev team member
alter user  sam set DEFAULT_ROLE='MAKETING_PRJ_DEV_TEAM';

-- his secondary role as all means marketing + sales
alter user  sam set DEFAULT_SECONDARY_ROLES = ( 'ALL' );