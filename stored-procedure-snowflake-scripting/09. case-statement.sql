-- Create table
CREATE OR REPLACE TABLE COUNTRY_CODE(
    ID INT PRIMARY KEY AUTOINCREMENT,
    COUNTRY_NAME VARCHAR(255),
    ISO_CODE VARCHAR(3)
);

INSERT INTO COUNTRY_CODE(COUNTRY_NAME, ISO_CODE) VALUES
    ('United States', 'USA'),
    ('China', 'CHN'),
    ('India', 'IND'),
    ('Brazil', 'BRA'),
    ('Russia', 'RUS')
;

select id, country_name, iso_code from country_code;

-- 1. Simple case statement
CREATE OR REPLACE PROCEDURE my_sp_simple_case(input_text text)
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
    CASE input_text
        WHEN 'D' THEN
            delete from country_code;
            RETURN 'Table data deleted.';
        WHEN 'T' THEN
            truncate table country_code;
            RETURN 'Table data truncated';
        ELSE
            RETURN 'Invalid-input';
    END;
END;

CALL my_sp_simple_case('E');


-- 2. searched case statement 
CREATE OR REPLACE PROCEDURE my_sp_searched_case(input_text text)
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
    CASE 
        WHEN input_text = 'D' THEN
            delete from country_code;
            RETURN 'Table data deleted.';
        WHEN input_text = 'T' THEN
            truncate table country_code;
            RETURN 'Table data truncated';
        ELSE
            RETURN 'Invalid-input';
    END;
END;

CALL my_sp_searched_case('E');

