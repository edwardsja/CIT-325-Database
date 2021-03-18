/*
||  Name:          apply_plsql_lab11.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

--@/home/student/Data/cit325/lib/cleanup_oracle.sql
--@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab10.txt

-- ... insert your solution here ...

-- alter item table
ALTER TABLE item
ADD text_file_name VARCHAR2(40);


DROP TABLE logger;

-- create logging tables
CREATE TABLE logger
( logger_id  NUMBER NOT NULL
, old_item_id    NUMBER
, old_item_barcode  VARCHAR2(20)
, old_item_type     NUMBER
, old_item_title    VARCHAR2(60)
, old_item_subtitle VARCHAR2(60)
, old_item_rating   VARCHAR2(8)
, old_item_rating_agency  VARCHAR2(4)
, old_item_release_date   DATE
, old_created_by    NUMBER
, old_creation_date DATE
, old_last_updated_by NUMBER
, old_last_update_date DATE
, old_text_file_name  VARCHAR2(40)
, new_item_id    NUMBER
, new_item_barcode  VARCHAR2(20)
, new_item_type     NUMBER
, new_item_title    VARCHAR2(60)
, new_item_subtitle VARCHAR2(60)
, new_item_rating   VARCHAR2(8)
, new_item_rating_agency  VARCHAR2(4)
, new_item_release_date   DATE
, new_created_by    NUMBER
, new_creation_date DATE
, new_last_updated_by NUMBER
, new_last_update_date DATE
, new_text_file_name  VARCHAR2(40)
, CONSTRAINT logger_pk PRIMARY KEY (logger_id));

DESC logger;

DROP SEQUENCE logger_s;

CREATE SEQUENCE logger_s;

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item i WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP

    INSERT INTO logger
	( logger_id
	, old_item_id
	, old_item_title
	, new_item_id
	, new_item_title )
	VALUES 
	( logger_s.NEXTVAL
	, i.item_id
	, i.item_title
	, i.item_id
	, i.item_title );

  END LOOP;
END;
/

-- Query the logger table. 
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- crate log package with overloaded procedures
CREATE OR REPLACE
  PACKAGE manage_item IS

  PROCEDURE item_insert
  ( pv_new_item_id    NUMBER
  , pv_new_item_barcode  VARCHAR2
  , pv_new_item_type     NUMBER
  , pv_new_item_title    VARCHAR2
  , pv_new_item_subtitle VARCHAR2
  , pv_new_item_rating   VARCHAR2
  , pv_new_item_rating_agency  VARCHAR2
  , pv_new_item_release_date   DATE
  , pv_new_created_by    NUMBER
  , pv_new_creation_date DATE
  , pv_new_last_updated_by NUMBER
  , pv_new_last_update_date DATE
  , pv_new_text_file_name  VARCHAR2 );
  
  PROCEDURE item_insert
  ( pv_old_item_id    NUMBER
  , pv_old_item_barcode  VARCHAR2
  , pv_old_item_type     NUMBER
  , pv_old_item_title    VARCHAR2
  , pv_old_item_subtitle VARCHAR2
  , pv_old_item_rating   VARCHAR2
  , pv_old_item_rating_agency  VARCHAR2
  , pv_old_item_release_date   DATE
  , pv_old_created_by    NUMBER
  , pv_old_creation_date DATE
  , pv_old_last_updated_by NUMBER
  , pv_old_last_update_date DATE
  , pv_old_text_file_name  VARCHAR2
  , pv_new_item_id    NUMBER
  , pv_new_item_barcode  VARCHAR2
  , pv_new_item_type     NUMBER
  , pv_new_item_title    VARCHAR2
  , pv_new_item_subtitle VARCHAR2
  , pv_new_item_rating   VARCHAR2
  , pv_new_item_rating_agency  VARCHAR2
  , pv_new_item_release_date   DATE
  , pv_new_created_by    NUMBER
  , pv_new_creation_date DATE
  , pv_new_last_updated_by NUMBER
  , pv_new_last_update_date DATE
  , pv_new_text_file_name  VARCHAR2);
  
  PROCEDURE item_insert
  ( pv_old_item_id    NUMBER
  , pv_old_item_barcode  VARCHAR2
  , pv_old_item_type     NUMBER
  , pv_old_item_title    VARCHAR2
  , pv_old_item_subtitle VARCHAR2
  , pv_old_item_rating   VARCHAR2
  , pv_old_item_rating_agency  VARCHAR2
  , pv_old_item_release_date   DATE
  , pv_old_created_by    NUMBER
  , pv_old_creation_date DATE
  , pv_old_last_updated_by NUMBER
  , pv_old_last_update_date DATE
  , pv_old_text_file_name  VARCHAR2 );
 END manage_item;
 /
 
 DESC manage_item;
 
  -- package body
 CREATE OR REPLACE
  PACKAGE BODY manage_item IS

  -- INSERT procedure
  PROCEDURE item_insert
  ( pv_new_item_id    NUMBER
  , pv_new_item_barcode  VARCHAR2
  , pv_new_item_type     NUMBER
  , pv_new_item_title    VARCHAR2
  , pv_new_item_subtitle VARCHAR2
  , pv_new_item_rating   VARCHAR2
  , pv_new_item_rating_agency  VARCHAR2
  , pv_new_item_release_date   DATE
  , pv_new_created_by    NUMBER
  , pv_new_creation_date DATE
  , pv_new_last_updated_by NUMBER
  , pv_new_last_update_date DATE
  , pv_new_text_file_name  VARCHAR2 ) IS

    /* Set an autonomous transaction. */
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* Insert log entry for an avenger. */
    manage_item.item_insert(
        pv_old_item_id    => null
      , pv_old_item_barcode  => null
      , pv_old_item_type     => null
      , pv_old_item_title    => null
      , pv_old_item_subtitle => null
      , pv_old_item_rating   => null
      , pv_old_item_rating_agency  => null
	  , pv_old_item_release_date   => null
      , pv_old_created_by    => null
      , pv_old_creation_date => null
	  , pv_old_last_updated_by => null
	  , pv_old_last_update_date => null
	  , pv_old_text_file_name  => null
      , pv_new_item_id    => pv_new_item_id
      , pv_new_item_barcode => pv_new_item_barcode
      , pv_new_item_type   =>  pv_new_item_type
      , pv_new_item_title   => pv_new_item_title
      , pv_new_item_subtitle => pv_new_item_subtitle
      , pv_new_item_rating   => pv_new_item_rating
      , pv_new_item_rating_agency => pv_new_item_rating_agency
      , pv_new_item_release_date  => pv_new_item_release_date
      , pv_new_created_by   => pv_new_created_by
      , pv_new_creation_date  => pv_new_creation_date
      , pv_new_last_updated_by => pv_new_last_updated_by
      , pv_new_last_update_date => pv_new_last_update_date
      , pv_new_text_file_name => pv_new_text_file_name);
  EXCEPTION
    /* Exception handler. */
    WHEN OTHERS THEN
     RETURN;
  END item_insert;
  
  

  -- UPDATE procedure
  PROCEDURE item_insert
  ( pv_old_item_id    NUMBER
  , pv_old_item_barcode  VARCHAR2
  , pv_old_item_type     NUMBER
  , pv_old_item_title    VARCHAR2
  , pv_old_item_subtitle VARCHAR2
  , pv_old_item_rating   VARCHAR2
  , pv_old_item_rating_agency  VARCHAR2
  , pv_old_item_release_date   DATE
  , pv_old_created_by    NUMBER
  , pv_old_creation_date DATE
  , pv_old_last_updated_by NUMBER
  , pv_old_last_update_date DATE
  , pv_old_text_file_name  VARCHAR2
  , pv_new_item_id    NUMBER
  , pv_new_item_barcode  VARCHAR2
  , pv_new_item_type     NUMBER
  , pv_new_item_title    VARCHAR2
  , pv_new_item_subtitle VARCHAR2
  , pv_new_item_rating   VARCHAR2
  , pv_new_item_rating_agency  VARCHAR2
  , pv_new_item_release_date   DATE
  , pv_new_created_by    NUMBER
  , pv_new_creation_date DATE
  , pv_new_last_updated_by NUMBER
  , pv_new_last_update_date DATE
  , pv_new_text_file_name  VARCHAR2 ) IS

    /* Declare local logging value. */
    lv_logger_id  NUMBER;

    /* Set an autonomous transaction. */
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* Get a sequence. */
    lv_logger_id := logger_s.NEXTVAL;

    /* Set a savepoint. */
    SAVEPOINT starting;

    /* Insert log entry for an avenger. */
    INSERT INTO logger
    ( logger_id
	, old_item_id 
    , old_item_barcode  
    , old_item_type    
    , old_item_title  
    , old_item_subtitle 
    , old_item_rating  
    , old_item_rating_agency  
    , old_item_release_date   
    , old_created_by   
    , old_creation_date 
    , old_last_updated_by 
    , old_last_update_date 
    , old_text_file_name 
    , new_item_id    
    , new_item_barcode 
    , new_item_type     
    , new_item_title  
    , new_item_subtitle 
    , new_item_rating   
    , new_item_rating_agency  
    , new_item_release_date   
    , new_created_by    
    , new_creation_date 
    , new_last_updated_by
    , new_last_update_date 
    , new_text_file_name )
    VALUES
    ( lv_logger_id
	, pv_old_item_id    
    , pv_old_item_barcode  
    , pv_old_item_type     
    , pv_old_item_title    
    , pv_old_item_subtitle 
    , pv_old_item_rating   
    , pv_old_item_rating_agency  
    , pv_old_item_release_date   
    , pv_old_created_by    
    , pv_old_creation_date 
    , pv_old_last_updated_by 
    , pv_old_last_update_date 
    , pv_old_text_file_name  
    , pv_new_item_id    
    , pv_new_item_barcode  
    , pv_new_item_type     
    , pv_new_item_title    
    , pv_new_item_subtitle 
    , pv_new_item_rating   
    , pv_new_item_rating_agency  
    , pv_new_item_release_date   
    , pv_new_created_by    
    , pv_new_creation_date 
    , pv_new_last_updated_by 
    , pv_new_last_update_date 
    , pv_new_text_file_name  );

    /* Commit the independent write. */
    COMMIT;
  EXCEPTION
    /* Exception handler. */
    WHEN OTHERS THEN
      ROLLBACK TO starting;
      RETURN;
  END item_insert;
  
  

  -- DELETE procedure
  PROCEDURE item_insert
  ( pv_old_item_id    NUMBER
  , pv_old_item_barcode  VARCHAR2
  , pv_old_item_type     NUMBER
  , pv_old_item_title    VARCHAR2
  , pv_old_item_subtitle VARCHAR2
  , pv_old_item_rating   VARCHAR2
  , pv_old_item_rating_agency  VARCHAR2
  , pv_old_item_release_date   DATE
  , pv_old_created_by    NUMBER
  , pv_old_creation_date DATE
  , pv_old_last_updated_by NUMBER
  , pv_old_last_update_date DATE
  , pv_old_text_file_name  VARCHAR2 ) IS

    /* Set an autonomous transaction. */
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* Insert log entry for an avenger. */
    manage_item.item_insert(
        pv_old_item_id    => pv_old_item_id
      , pv_old_item_barcode => pv_old_item_barcode
      , pv_old_item_type   =>  pv_old_item_type
      , pv_old_item_title   => pv_old_item_title
      , pv_old_item_subtitle => pv_old_item_subtitle
      , pv_old_item_rating   => pv_old_item_rating
      , pv_old_item_rating_agency => pv_old_item_rating_agency
      , pv_old_item_release_date  => pv_old_item_release_date
      , pv_old_created_by   => pv_old_created_by
      , pv_old_creation_date  => pv_old_creation_date
      , pv_old_last_updated_by => pv_old_last_updated_by
      , pv_old_last_update_date => pv_old_last_update_date
      , pv_old_text_file_name => pv_old_text_file_name
	  , pv_new_item_id    => null
      , pv_new_item_barcode  => null
      , pv_new_item_type     => null
      , pv_new_item_title    => null
      , pv_new_item_subtitle => null
      , pv_new_item_rating   => null
      , pv_new_item_rating_agency  => null
	  , pv_new_item_release_date   => null
      , pv_new_created_by    => null
      , pv_new_creation_date => null
	  , pv_new_last_updated_by => null
	  , pv_new_last_update_date => null
	  , pv_new_text_file_name  => null );
  EXCEPTION
    /* Exception handler. */
    WHEN OTHERS THEN
     RETURN;
  END item_insert;
END manage_item;
/

-- verify logger table works with a test UPDATE, INSERT, and DELETE
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP

	-- insert
    manage_item.item_insert(
	    pv_new_item_id    => i.item_id
      , pv_new_item_barcode  => null
      , pv_new_item_type     => null
      , pv_new_item_title    => i.item_title || '-Inserted'
      , pv_new_item_subtitle => null
      , pv_new_item_rating   => null
      , pv_new_item_rating_agency  => null
	  , pv_new_item_release_date   => null
      , pv_new_created_by    => null
      , pv_new_creation_date => null
	  , pv_new_last_updated_by => null
	  , pv_new_last_update_date => null
	  , pv_new_text_file_name  => null );
	  
	 -- insert
	 manage_item.item_insert(
	    pv_old_item_id    => i.item_id
      , pv_old_item_barcode  => null
      , pv_old_item_type     => null
      , pv_old_item_title    => i.item_title
      , pv_old_item_subtitle => null
      , pv_old_item_rating   => null
      , pv_old_item_rating_agency  => null
	  , pv_old_item_release_date   => null
      , pv_old_created_by    => null
      , pv_old_creation_date => null
	  , pv_old_last_updated_by => null
	  , pv_old_last_update_date => null
	  , pv_old_text_file_name  => null
	  , pv_new_item_id    => i.item_id
      , pv_new_item_barcode  => null
      , pv_new_item_type     => null
      , pv_new_item_title    => i.item_title || '-Changed'
      , pv_new_item_subtitle => null
      , pv_new_item_rating   => null
      , pv_new_item_rating_agency  => null
	  , pv_new_item_release_date   => null
      , pv_new_created_by    => null
      , pv_new_creation_date => null
	  , pv_new_last_updated_by => null
	  , pv_new_last_update_date => null
	  , pv_new_text_file_name  => null );
	  
	  -- delete
	 manage_item.item_insert(
	    pv_old_item_id    => i.item_id
      , pv_old_item_barcode  => null
      , pv_old_item_type     => null
      , pv_old_item_title    => i.item_title || '-Deleted'
      , pv_old_item_subtitle => null
      , pv_old_item_rating   => null
      , pv_old_item_rating_agency  => null
	  , pv_old_item_release_date   => null
      , pv_old_created_by    => null
      , pv_old_creation_date => null
	  , pv_old_last_updated_by => null
	  , pv_old_last_update_date => null
	  , pv_old_text_file_name  => null );

  END LOOP;
END;
/

-- Query the logger table. 
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- create triggers
CREATE OR REPLACE TRIGGER item_trig
BEFORE INSERT OR UPDATE
ON item
FOR EACH ROW
DECLARE
  lv_input_title VARCHAR2(60);
  lv_title VARCHAR2(60);
  lv_subtitle VARCHAR(60);
BEGIN
	IF INSERTING THEN
			/* Assign the title */
	  lv_input_title := SUBSTR(:new.item_title,1,40);

	  /* Check for a subtitle. */
	  IF REGEXP_INSTR(lv_input_title,':') > 0 AND
		 REGEXP_INSTR(lv_input_title,':') = LENGTH(lv_input_title) THEN
		/* Shave off the colon. */
		lv_title   := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
	  ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
		/* Split the string into two parts. */
		lv_title    := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
		lv_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
	  ELSE
		/* Assign the input value as the title. */
		lv_title := lv_input_title;
	  END IF;
	  manage_item.item_insert(
	    pv_new_item_id    => :new.item_id
      , pv_new_item_barcode  => :new.item_barcode
      , pv_new_item_type     => :new.item_type
      , pv_new_item_title    => lv_title
      , pv_new_item_subtitle => lv_subtitle
      , pv_new_item_rating   => :new.item_rating
      , pv_new_item_rating_agency  => :new.item_rating_agency
	  , pv_new_item_release_date   => :new.item_release_date
      , pv_new_created_by    => :new.created_by
      , pv_new_creation_date => :new.creation_date
	  , pv_new_last_updated_by => :new.last_updated_by
	  , pv_new_last_update_date => :new.last_update_date
	  , pv_new_text_file_name  => :new.text_file_name );
	ELSIF UPDATING THEN
		manage_item.item_insert(
		    pv_old_item_id    => :old.item_id
		  , pv_old_item_barcode  => :old.item_barcode
		  , pv_old_item_type     => :old.item_type
		  , pv_old_item_title    => :old.item_title
		  , pv_old_item_subtitle => :old.item_subtitle
		  , pv_old_item_rating   => :old.item_rating
          , pv_old_item_rating_agency  => :old.item_rating_agency
		  , pv_old_item_release_date   => :old.item_release_date
          , pv_old_created_by    => :old.created_by
          , pv_old_creation_date => :old.creation_date
	      , pv_old_last_updated_by => :old.last_updated_by
	      , pv_old_last_update_date => :old.last_update_date
	      , pv_old_text_file_name  => :old.text_file_name
		  , pv_new_item_id    => :new.item_id
		  , pv_new_item_barcode  => :new.item_barcode
		  , pv_new_item_type     => :new.item_type
		  , pv_new_item_title    => :new.item_title
		  , pv_new_item_subtitle => :new.item_subtitle
		  , pv_new_item_rating   => :new.item_rating
          , pv_new_item_rating_agency  => :new.item_rating_agency
		  , pv_new_item_release_date   => :new.item_release_date
          , pv_new_created_by    => :new.created_by
          , pv_new_creation_date => :new.creation_date
	      , pv_new_last_updated_by => :new.last_updated_by
	      , pv_new_last_update_date => :new.last_update_date
	      , pv_new_text_file_name  => :new.text_file_name  );
	END IF;
END item_trig;
/

CREATE OR REPLACE TRIGGER item_delete_trig
BEFORE DELETE
ON item
FOR EACH ROW
BEGIN
  manage_item.item_insert(
		pv_old_item_id    => :old.item_id
	  , pv_old_item_barcode  => :old.item_barcode
	  , pv_old_item_type     => :old.item_type
	  , pv_old_item_title    => :old.item_title
	  , pv_old_item_subtitle => :old.item_subtitle
	  , pv_old_item_rating   => :old.item_rating
	  , pv_old_item_rating_agency  => :old.item_rating_agency
	  , pv_old_item_release_date   => :old.item_release_date
	  , pv_old_created_by    => :old.created_by
	  , pv_old_creation_date => :old.creation_date
	  , pv_old_last_updated_by => :old.last_updated_by
	  , pv_old_last_update_date => :old.last_update_date
	  , pv_old_text_file_name  => :old.text_file_name );
END item_delete_trig;
/

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_desc
, item_rating
, item_rating_agency
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_s1.NEXTVAL
, 'B01AT251XY'
, 1014
, 'Bourne Legacy:'
, 'Bourne Legacy'
, 'PG-13'
, 'MPAA'
, '05-APR-2016'
, 3
, SYSDATE
, 3
, SYSDATE );

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_desc
, item_rating
, item_rating_agency
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_s1.NEXTVAL
, 'B018FK66TU'
, 1014
, 'Star War: The Force Awakens'
, 'Star Wars 7'
, 'PG-13'
, 'MPAA'
, '05-APR-2016'
, 3
, SYSDATE
, 3
, SYSDATE );

UPDATE item
SET item_title = 'Star Wars: The Force Awakens'
WHERE item_title = 'Star War: The Force Awakens';

DELETE FROM item
WHERE item_title = 'Star Wars: The Force Awakens';

/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Close log file.
SPOOL OFF
