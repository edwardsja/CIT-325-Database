/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
-- Open log file.
SPOOL apply_plsql_lab5.txt


-- Enter your solution here.
CREATE SEQUENCE rating_agency_s
 START WITH     1001
 INCREMENT BY   1;

CREATE TABLE rating_agency AS
SELECT rating_agency_s.NEXTVAL AS rating_agency_id
,      il.item_rating AS rating
,      il.item_rating_agency AS rating_agency
FROM  (SELECT DISTINCT
              i.item_rating
       ,      i.item_rating_agency
       FROM   item i) il;

ALTER TABLE item 
    ADD rating_agency_id NUMBER(22);
    
    
-- QUERY to check alter worked
SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

CREATE OR REPLACE
TYPE rating_agency_obj IS OBJECT
  ( rating_agency_id  NUMBER
  , rating            VARCHAR2(8)
  , rating_agency     VARCHAR2(4));

  
DECLARE

CURSOR c IS
  SELECT  ra.rating_agency_id
        , ra.string
        , ra.rating_agency 
        FROM rating_agency ra;

CREATE
TYPE rating_agency_tab is TABLE OF rating_agency_obj;

lv_rating_agency_tab  RATING_AGENCY_TAB := rating_agency_tab();
/

BEGIN

FOR i in 1..1 LOOP 
  OPEN c;
  lv_rating_agency_tab.EXTEND;
  
  FETCH c INTO 
     lv_rating_agency_tab( lv_rating_agency_tab.COUNT) :=
        rating_agency_obj( lv_rating_agency_id
                      , lv_rating
                      , lv_rating_agency );
  CLOSE c;
	
END LOOP;

FOR i in 1..lv_rating_agency_tab.COUNT LOOP 
  UPDATE item
  SET rating_agency_id = lv_rating_agency_tab(i).rating_agency_id
  WHERE item.item_rating = lv_rating_agency_tab(i).lv_rating AND item.item_rating_agency = lv_rating_agency_tab(i).lv_rating_agency; 
END LOOP;

END;
/

SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

-- Close log file.
SPOOL OFF

