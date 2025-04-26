Skip to main content
Skip to editor
Skip to results
Site
Worksheets
Selection deleted
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
-- how to use into keyword 
CREATE OR REPLACE PROCEDURE my_procedure_into()
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    -- following works
    min_balance number(10, 2) default 0.00;
    max_balance number(10, 2) default 0.00;
BEGIN
    -- using colon notation and into keyword
    select min(c_acctbal), max(c_acctbal) into :min_balance, :max_balance from snowflake_sample_data.tpch_sf1.customer;

    -- return the variable
    return max_balance;
END;

desc procedure my_procedure_into();

call my_procedure_into();


DECLARE
    -- following works
    min_balance number(10, 2) default 0.00;
    max_balance number(10, 2) default 0.00;
BEGIN
    -- using colon notation and into keyword
    select min(c_acctbal), max(c_acctbal) into min_balance, max_balance from snowflake_sample_data.tpch_sf1.customer;

    -- return the variable
    return min_balance;
END;

Query Details
Query duration
442ms
Rows
1
Query ID
01bbabb2-3202-e757-0006-05c6002e99ea
anonymous block
100% filled

Sorted by descending
