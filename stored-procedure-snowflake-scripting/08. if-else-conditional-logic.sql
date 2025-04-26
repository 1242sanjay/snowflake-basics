-- following stored procedure calculate the sales bonus based on sales value
-- case-1
CREATE OR REPLACE PROCEDURE calculate_sales_bonus01(sales_value number(10, 2))
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    sales_target number(10, 2) default 1000;
    default_bonus_amt number(10, 2) default 50;
BEGIN
    IF (sales_value > sales_target) THEN
        bonus_amt := (sales_value - sales_target) * 0.1;
    END IF;

    RETURN bonus_amt;
END;

call calculate_sales_bonus01(1500);
call calculate_sales_bonus01(2000);
call calculate_sales_bonus01(0);


-- case-2
CREATE OR REPLACE PROCEDURE calculate_sales_bonus02(sales_value number(10, 2))
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    sales_target number(10, 2) default 1000;
    default_bonus_amt number(10, 2) default 50;
BEGIN
    IF (sales_value > sales_target) THEN
        bonus_amt := (sales_value - sales_target) * 0.1;
    ELSE 
        bonus_amt := default_bonus_amt;
    END IF;

    RETURN bonus_amt;
END;

call calculate_sales_bonus02(1500);
call calculate_sales_bonus02(2000);
call calculate_sales_bonus02(0);

-- case-3
CREATE OR REPLACE PROCEDURE calculate_sales_bonus03(sales_value number(10, 2))
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    
    -- 3 level of sales target
    sales_target_level1 number(10, 2) default 1000;
    sales_target_level2 number(10, 2) default 2000;
    sales_target_level3 number(10, 2) default 5000;

    -- default bonus amount
    default_bonus_amt number(10, 2) default 10;
BEGIN
    IF (sales_value > sales_target_level3) THEN
        -- 30% bonus
        bonus_amt := (sales_value - sales_target_level1) * 0.3;
    ELSEIF (sales_value > sales_target_level2) THEN
        -- 15% bonus
        bonus_amt := (sales_value - sales_target_level1) * 0.15;
    ELSEIF (sales_value > sales_target_level1) THEN
        -- 10% bonus
        bonus_amt := (sales_value - sales_target_level1) * 0.10;
    ELSE
        -- default bonus
        bonus_amt := default_bonus_amt;
    END IF;

    RETURN bonus_amt;
END;

call calculate_sales_bonus03(5500);  -- (5500-1000)x 30% = 1350
call calculate_sales_bonus03(3500);  -- (3500-1000)x 15% = 375
call calculate_sales_bonus03(1500);  -- (1500-1000)x 10% = 50
call calculate_sales_bonus03(500);  -- (1500-1000)x 10% = 10


-- case-4
CREATE OR REPLACE PROCEDURE calculate_sales_bonus04(sales_value number(10, 2))
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    
    -- 3 level of sales target
    sales_target_level1 number(10, 2) default 1000;
    sales_target_level2 number(10, 2) default 2000;
    sales_target_level3 number(10, 2) default 5000;

    -- default bonus amount
    default_bonus_amt number(10, 2) default 10;
BEGIN
    IF (sales_value > sales_target_level3) THEN
        -- 30% bonus
        return (sales_value - sales_target_level1) * 0.3;
    ELSEIF (sales_value > sales_target_level2) THEN
        -- 15% bonus
        return (sales_value - sales_target_level1) * 0.15;
    ELSEIF (sales_value > sales_target_level1) THEN
        -- 10% bonus
        return (sales_value - sales_target_level1) * 0.10;
    ELSE
        -- default bonus
        return default_bonus_amt;
    END IF;
END;

call calculate_sales_bonus04(5500);  -- (5500-1000)x 30% = 1350
call calculate_sales_bonus04(3500);  -- (3500-1000)x 15% = 375
call calculate_sales_bonus04(1500);  -- (1500-1000)x 10% = 50
call calculate_sales_bonus04(500);  -- (1500-1000)x 10% = 10


-- case-5
CREATE OR REPLACE PROCEDURE calculate_sales_bonus05(sales_value number)
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    sales_target number(10, 0) default 1000;
BEGIN
    IF(sales_value > 0) THEN 
        IF(sales_value > sales_target) THEN
            bonus_amt := (sales_value - sales_target) * 0.1;
        END IF;
        return bonus_amt;
    END IF;
    return bonus_amt;
END;

call calculate_sales_bonus05(2000);



-- case-6
CREATE OR REPLACE PROCEDURE calculate_sales_bonus06(sales_value number)
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    sales_target number(10, 0) default 1000;
    current_month number(2) default month(current_date());
BEGIN
    IF(sales_value > 0 AND current_month = 1) THEN 
        return 500;
    ELSE
        return (sales_value - sales_target) * 0.1;
    END IF;
END;

call calculate_sales_bonus06(2000);



-- case-7
CREATE OR REPLACE PROCEDURE calculate_sales_bonus07(sales_value number, last_sales_dt date)
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    sales_target number(10, 0) default 1000;
    current_dt date default current_date();
BEGIN
    IF(sales_value > 0 AND last_sales_dt = current_dt) THEN 
        return 500;
    ELSE
        return (sales_value - sales_target) * 0.1;
    END IF;
END;

call calculate_sales_bonus07(2000, current_date);
call calculate_sales_bonus07(2000, '2024-01-21');


-- case-8
CREATE OR REPLACE PROCEDURE calculate_sales_bonus08(flag boolean)
RETURNS NUMBER(10, 2)
LANGUAGE SQL
AS
DECLARE
    bonus_amt number(10, 2) default 0;
    sales_target number(10, 0) default 1000;
BEGIN
    LET sales_value := 2000;
    IF (flag) THEN
        IF(sales_value > sales_target) THEN 
            return (sales_value - sales_target) * 0.1;
        END IF;
    END IF;
    RETURN bonus_amt;
END;

call calculate_sales_bonus08(1);
call calculate_sales_bonus08(-1);
call calculate_sales_bonus08(0);
call calculate_sales_bonus08(True);
call calculate_sales_bonus08(false);
