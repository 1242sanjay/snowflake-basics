use role sysadmin;

create database demo;
use demo;

-- this object will be created under a db/schema
-- we need to make sure that it is secure
create or replace secret my_github_secret
    type = password
    username = '1242sanjay'
    password = '<password>'
;

-- display all the secret objects
show secrets;
-- drop secret my_github_secret;

-- create integration object with secure object
create or replace api integration my_git_api_integration
api_provider = git_https_api
api_allowed_prefixes = ('https://github.com/1242sanjay')
allowed_authentication_secrets = (my_github_secret)
enabled = true
;

show api integrations;
show integrations;

create or replace git repository my_github_repo
    api_integration = my_git_api_integration
    git_credentials = my_github_secret
    origin = 'https://github.com/1242sanjay/my_snow_private_repo'
;
