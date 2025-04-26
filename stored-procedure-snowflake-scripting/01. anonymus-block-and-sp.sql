-- use role sysadmin;
-- use database my_db;
-- create or replace schema sp;

-- simple tax calculation - anonymus block
DECLARE
    tax_amt number(10, 2) DEFAULT 0.00;
    base_salary_slab number(10, 2) DEFAULT 300000.00;
    
BEGIN
    -- gross salary and tax percentage value
    LET gross_salary number(10, 2) :=1000000.00;
    LET tax_slab number(3, 2) := 0.20;

    -- taxable salary to be calculated
    LET taxable_salary number(10, 2) := 0.00;

    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN 
        taxable_salary := (gross_salary - base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
END;


-- Same logic inside a stored procedure
CREATE OR REPLACE PROCEDURE calculate_tax()
RETURNS FLOAT
LANGUAGE SQL
AS
DECLARE
    tax_amt number(10, 2) DEFAULT 0.00;
    base_salary_slab number(10, 2) DEFAULT 300000.00;
    
BEGIN
    -- gross salary and tax percentage value
    LET gross_salary number(10, 2) :=1000000.00;
    LET tax_slab number(3, 2) := 0.20;

    -- taxable salary to be calculated
    LET taxable_salary number(10, 2) := 0.00;

    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN 
        taxable_salary := (gross_salary - base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
END;

-- call the stored procedure
call calculate_tax();


-- DECLARE block is optional    
BEGIN
    LET tax_amt number(10, 2) DEFAULT 0.00;
    LET base_salary_slab number(10, 2) DEFAULT 300000.00;
    LET gross_salary number(10, 2) :=1000000.00;
    LET tax_slab number(3, 2) := 0.20;
    LET taxable_salary number(10, 2) := 0.00;

    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN 
        taxable_salary := (gross_salary - base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
END;


-- if we are running these anonymus block/sored procedure in snowsql cli then need to mention EXECUTE IMMEDIATE and encapsulate the block in $$.
EXECUTE IMMEDIATE 
$$
DECLARE
    tax_amt number(10, 2) DEFAULT 0.00;
    base_salary_slab number(10, 2) DEFAULT 300000.00;
    
BEGIN
    -- gross salary and tax percentage value
    LET gross_salary number(10, 2) :=1000000.00;
    LET tax_slab number(3, 2) := 0.20;

    -- taxable salary to be calculated
    LET taxable_salary number(10, 2) := 0.00;

    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN 
        taxable_salary := (gross_salary - base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
END;
$$
;

CREATE OR REPLACE PROCEDURE calculate_tax_01()
RETURNS FLOAT
LANGUAGE SQL
AS
$$
DECLARE
    tax_amt number(10, 2) DEFAULT 0.00;
    base_salary_slab number(10, 2) DEFAULT 300000.00;
    
BEGIN
    -- gross salary and tax percentage value
    LET gross_salary number(10, 2) :=1000000.00;
    LET tax_slab number(3, 2) := 0.20;

    -- taxable salary to be calculated
    LET taxable_salary number(10, 2) := 0.00;

    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN 
        taxable_salary := (gross_salary - base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
END;
$$;

CALL calculate_tax_01();


