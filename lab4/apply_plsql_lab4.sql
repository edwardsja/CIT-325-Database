/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab4.txt

-- Enter your solution here.
SET SERVEROUTPUT ON

CREATE OR REPLACE 
TYPE lyric IS OBJECT
( day_name VARCHAR2(8)
, gift_name VARCHAR2(24));
/


DECLARE

TYPE gifts IS TABLE OF lyric;
TYPE days IS TABLE OF VARCHAR2(8);

lv_days DAYS := days('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth');

lv_gifts GIFTS := gifts( lyric('and a', 'Partridge in a pear tree')
                       , lyric('Two', 'Turtle doves')
                       , lyric('Three', 'French hens')
                       , lyric('Four', 'Calling Birds')
                       , lyric('Five', 'Golden rings')
                       , lyric('Six', 'Geese a laying')
                       , lyric('Seven', 'Swans a swimming')
                       , lyric('Eight', 'Maids a Milking')
                       , lyric('Nine', 'Ladies dancing')
                       , lyric('Ten', 'Lords a leaping')
                       , lyric('Eleven', 'Pipers piping')
                       , lyric('Twelve', 'Drummers drumming'));
BEGIN 
    FOR i IN 1..lv_gifts.COUNT LOOP
        dbms_output.put_line('On the '||lv_days(i)||' day of Christmas');
        dbms_output.put_line(CHR(13));
        dbms_output.put_line('my true love sent to me:');
        IF i = 1 THEN
            FOR j IN REVERSE 1..i LOOP
            dbms_output.put_line(CHR(13));
            dbms_output.put_line('A '||lv_gifts(j).gift_name);
            END LOOP;
        ELSE
            FOR j IN REVERSE 1..i LOOP
            dbms_output.put_line(CHR(13));
            dbms_output.put_line(lv_gifts(j).day_name||' '||lv_gifts(j).gift_name);
            END LOOP;
        END IF;
    END LOOP;
END;
/
-- Close log file.
SPOOL OFF
