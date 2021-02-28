/*
||  Name:          apply_plsql_lab8.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 9 lab.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- drops function and procedure insert_contact
BEGIN
  FOR i IN (SELECT uo.object_type
             ,      uo.object_name
             FROM   user_objects uo
             WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
     EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
   END LOOP;
 END;
/

-- DBA 1, 2, 3, 4
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

-- Open log file.
SPOOL apply_plsql_lab8.txt

-- Enter your solution here.
@/home/student/Data/cit325/lab8/procedure.sql
@/home/student/Data/cit325/lab8/functions.sql


-- Close log file.
SPOOL OFF
