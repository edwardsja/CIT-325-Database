/*
||  Name:          apply_plsql_lab12.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 13 lab.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab12.txt

-- ... insert your solution here ...

--create obj type
CREATE OR REPLACE
  TYPE item_obj IS OBJECT
  ( title VARCHAR2(60)
  , subtitle VARCHAR2(60)
  , rating   VARCHAR2(8)
  , release_date DATE );
/

desc item_obj;

--create table of obj
CREATE OR REPLACE
  TYPE item_tab IS TABLE of item_obj;
/

desc item_tab;

--create function with dynamic sql
CREATE OR REPLACE
  FUNCTION item_list
  ( pv_start_date  DATE
  , pv_end_date DATE := TRUNC(SYSDATE) + 1) RETURN item_tab IS

    /* Declare a record type. */
    TYPE item_rec IS RECORD
    ( title VARCHAR2(60)
    , subtitle VARCHAR2(60)
    , rating   VARCHAR2(8)
    , release_date DATE );

    /* Declare reference cursor for an NDS cursor. */
    item_cur   SYS_REFCURSOR;

    /* Declare a item row for output from an NDS cursor. */
    item_row   item_REC;
    item_set   ITEM_TAB := item_tab();

    /* Declare dynamic statement. */
    stmt  VARCHAR2(2000);
  BEGIN
    /* Create a dynamic statement. */
    stmt := 'SELECT item_title AS title, item_subtitle AS subtitle, item_rating AS rating, item_release_date AS release_date '
         || 'FROM   item '
         || 'WHERE  item_rating_agency = ''MPAA'' AND item_release_date BETWEEN :pv_start_date AND :pv_end_date ';

    /* Open and read dynamic cursor. */
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP
      /* Fetch the cursror into a item row. */
      FETCH item_cur INTO item_row;
      EXIT WHEN item_cur%NOTFOUND;

      /* Extend space and assign a value collection. */
      item_set.EXTEND;
      item_set(item_set.COUNT) :=
        item_obj( title  => item_row.title
                   , subtitle => item_row.subtitle
                   , rating   => item_row.rating
                   , release_date => item_row.release_date );
    END LOOP;

    /* Return item set. */
    RETURN item_set;
  END item_list;
/

desc item_list;

-- test function
COL title   FORMAT A60 HEADING "TITLE"
COL rating  FORMAT A10 HEADING "RATING"
SELECT   il.title
,        il.rating
FROM     TABLE(item_list(TRUNC(SYSDATE) - 7754)) il
ORDER BY 1, 2;



-- Close log file.
SPOOL OFF
