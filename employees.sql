--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 
--  Modified 2/16/2016 by Ian Beaver for PostgreSQL

DROP DATABASE IF EXISTS employees;
CREATE DATABASE employees;
\c employees;

CREATE OR REPLACE FUNCTION r(error_message text) RETURNS void AS $$
BEGIN
    RAISE INFO '%', error_message;
END;
$$ language plpgsql;

SELECT r('CLEANING OLD STRUCTRE');

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

CREATE TYPE MF AS ENUM ('M', 'F');

SELECT r('CREATING DATABASE STRUCTURE');

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      MF              NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE INDEX employees_emp_no_idx ON employees (emp_no);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);

CREATE UNIQUE INDEX departments_dept_no_idx ON departments (dept_no);
CREATE INDEX departments_dept_name_idx ON departments (dept_name);

CREATE TABLE dept_manager (
   dept_no      CHAR(4)         NOT NULL,
   emp_no       INT             NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE INDEX dept_manager_emp_no_idx ON dept_manager (emp_no);
CREATE INDEX dept_manager_dept_no_idx ON dept_manager (dept_no);
CREATE INDEX dept_manager_emp_no_dept_no_idx ON dept_manager (emp_no,dept_no);

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE INDEX dept_emp_emp_no_idx ON dept_emp (emp_no);
CREATE INDEX dept_emp_dept_no_idx ON dept_emp (dept_no);
CREATE INDEX dept_emp_emp_no_dept_no_idx ON dept_emp (emp_no,dept_no);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title,from_date)
);

CREATE INDEX titles_emp_no_idx ON titles (emp_no);
CREATE INDEX titles_emp_no_title_from_date_idx ON titles (emp_no,title,from_date);

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
);

CREATE INDEX salaries_emp_no_idx ON salaries (emp_no);
CREATE INDEX salaries_emp_no_from_date_idx ON salaries (emp_no,from_date);

SELECT r('LOADING departments');
\i load_departments.dump;
SELECT r('LOADING employees');
\i load_employees.dump;
SELECT r('LOADING dept_emp');
\i load_dept_emp.dump;
SELECT r('LOADING dept_manager');
\i load_dept_manager.dump;
SELECT r('LOADING titles');
\i load_titles.dump;
SELECT r('LOADING salaries');
\i load_salaries.dump;
