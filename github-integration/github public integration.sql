use role sysadmin;

use demo;

-- create integration object with secure object
create or replace api integration my_public_git_api_integration
api_provider = git_https_api
api_allowed_prefixes = ('https://github.com/1242sanjay')
enabled = true
;

show api integrations;
show integrations;

create or replace git repository my_github_public_repo
    api_integration = my_public_git_api_integration
    origin = 'https://github.com/1242sanjay/my_snow_public_repo'
;

show git repositories;
show git branches in git repository my_github_public_repo;

list @my_github_public_repo/branches/main/;
ls @my_github_public_repo/branches/main/;

-- ls @my_github_public_repo/tags/<tag_name>;

ls @my_github_public_repo/commits/55e4e2294f6133d474cd8e1bec6e4dbb9c04218c;

alter git repository my_github_public_repo fetch;

alter git repository my_github_public_repo set 
comment = 'This is my demo repo';

desc git repository my_github_public_repo;

create or replace tag team_tag
allowed_values 'HR', 'Finance';

alter git repository my_github_public_repo set 
tag team_tag = 'Finance';

desc git repository my_github_public_repo;
show git repositories;

-- execute remote file
-- execute immediate from @my_github_public_repo/branches/main/<folder_name>/<file_name>;

drop git repository my_github_public_repo;
