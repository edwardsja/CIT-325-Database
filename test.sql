 
SPOOL test.txt
 
 SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
 
DECLARE
TYPE grades IS VARRAY(10) OF CHAR(1);
lv_grades GRADES := grades('B','C','A','A','C','D','B');
BEGIN
-- dbms_output.put_line(
--     'Count ['||lv_grades.COUNT||'] '||
--     'Limit ['||lv_grades.LIMIT||']');
--     
-- lv_grades.EXTEND;
-- 
-- dbms_output.put_line(
--     'Count ['||lv_grades.COUNT||'] '||
--     'Limit ['||lv_grades.LIMIT||']');
--     
-- lv_grades(lv_grades.COUNT) := 'F';

FOR i IN 1..lv_grades.COUNT LOOP
    dbms_output.put_line(lv_grades(i));
END LOOP;
END;
/
SPOOL OFF
