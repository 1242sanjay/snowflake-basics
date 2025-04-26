use schema my_db.public;

create or replace transient table employee (
    id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
    doj date,
    designation varchar(100),
    is_billable char(1),
    date_of_birth date,
    office_location varchar(20),
    department_code varchar(5),
    is_manager char(1)
);

insert into employee (id, first_name, last_name, doj, designation, is_billable, date_of_birth, office_location, department_code, is_manager) values
('emp00001', 'Christine', 'Green', '2001-12-24', 'Payroll Administrator', 'N', '1960-10-21', 'loc014', 'FIN', 'Y'),
('emp00002', 'Michael', 'Brown', '2010-07-15', 'HR Specialist', 'Y', '1985-06-12', 'loc011', 'HR', 'N'),
('emp00003', 'Sophia', 'Taylor', '2005-09-20', 'Data Analyst', 'Y', '1990-04-18', 'loc010', 'IT', 'N'),
('emp00004', 'David', 'Wilson', '2018-03-01', 'Marketing Coordinator', 'N', '1988-11-05', 'loc012', 'MKT', 'N'),
('emp00005', 'Emily', 'Martinez', '2016-01-10', 'Software Developer', 'Y', '1993-07-22', 'loc013', 'IT', 'N'),
('emp00006', 'James', 'Johnson', '2003-12-30', 'Finance Manager', 'Y', '1978-09-14', 'loc014', 'FIN', 'Y'),
('emp00007', 'Olivia', 'Clark', '2011-08-25', 'Operations Lead', 'N', '1982-02-28', 'loc015', 'OPS', 'Y'),
('emp00008', 'William', 'Lopez', '2020-05-15', 'Quality Analyst', 'Y', '1996-08-03', 'loc016', 'QA', 'N'),
('emp00009', 'Isabella', 'Harris', '2014-11-18', 'Graphic Designer', 'N', '1989-01-19', 'loc017', 'MKT', 'N'),
('emp00010', 'Thomas', 'Moore', '2009-06-10', 'Database Admin', 'Y', '1984-05-07', 'loc018', 'IT', 'Y'),
('emp00011', 'Mia', 'Garcia', '2013-10-22', 'Project Manager', 'N', '1991-03-11', 'loc019', 'OPS', 'Y')
;

select count(*) from employee where is_manager = 'Y';


DECLARE
    mgr_count number default 0;
    
    -- define a cursor object/variable and assign a query
    my_cursor CURSOR FOR select count(1) as mgr_count from employee where is_manager = 'Y';
BEGIN   
    -- open the cursor and at thisw stage, query is executed
    OPEN my_cursor;

    -- Now, fetch keyword access the 1st row from the cursor
    FETCH my_cursor into mgr_count;

    -- close the cursor
    CLOSE my_cursor;

    -- return the result
    RETURN mgr_count;
END;



-- Iterating through the cursor using for keyword
DECLARE
    mgr_count number default 0;
    my_cursor CURSOR FOR select * from employee;
BEGIN
    LET emp_status text;
    OPEN my_cursor;
    for row_item in my_cursor do
        emp_status := row_item.is_manager;
        if(emp_status = 'Y') then 
            mgr_count := mgr_count +1;
        end if;
    end for cursor_loop;
    CLOSE my_cursor;
    RETURN mgr_count;
END;



DECLARE
    mgr_count number default 0;
    my_cursor CURSOR FOR select * from employee;
BEGIN 
    LET emp_status text;
    OPEN my_cursor;
    FOR row_item in my_cursor DO
        emp_status := row_item.is_manager;
        IF (emp_status = 'Y') THEN
            mgr_count := mgr_count + 1;
        END IF;
        LET inner_cursor CURSOR FOR select * from employee where designation = 'Data Analyst';
        OPEN inner_cursor;
    END FOR cursor_loop;
    CLOSE my_cursor;
    RETURN mgr_count;
END;


-- ResultSet and cursor (no need to open cursor as it directly associated with resultset)
DECLARE
    mgr_count number default 0;
    rs ResultSet default (select * from employee);
    my_cursor CURSOR for rs;
BEGIN
    LET emp_status text;
    for row_item in my_cursor do
        emp_status := row_item.is_manager;
        if(emp_status = 'Y') then 
            mgr_count := mgr_count +1;
        end if;
    end for cursor_loop;
    RETURN mgr_count;
END;
