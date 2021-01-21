/*
||  Name:          apply_plsql_lab2-2.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
-- SPOOL apply_plsql_lab2-2.txt

-- Enter your solution here.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE
    lv_raw_input    VARCHAR2(30);
    lv_input        VARCHAR2(10);

BEGIN
    lv_raw_input := '&input';
    lv_input     := SUBSTR(lv_raw_input,1,10);
    
    If lv_raw_input is NULL THEN
        dbms_output.put_line('Hello World!');
    ELSIF (LENGTH(lv_raw_input) < 10) THEN
        dbms_output.put_line('Hello '||lv_raw_input||'!');
    ELSE
        dbms_output.put_line('Hello '||lv_input||'!');
    END IF;
END;
/


-- Close log file.
-- SPOOL OFF

QUIT;
