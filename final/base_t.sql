-- ======================================================================
--  Name:    base_t.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

-- Open log file.
SPOOL base_t.txt

--create object
CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oid   NUMBER
  , oname VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t
    ( oid    NUMBER
    , oname  VARCHAR2 )
    RETURN SELF AS RESULT
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname 
    ( oname VARCHAR2 )
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/

-- object body
CREATE OR REPLACE
  TYPE BODY base_t IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION base_t
  ( oid    NUMBER
  , oname  VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.oid := oid;
    self.oname := oname;
    RETURN;
  END base_t;
  
  -- get_oname function
  MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
      RETURN self.oname;
    END get_oname;
	
  -- set_oname function
  MEMBER PROCEDURE set_oname
  ( oname VARCHAR2 ) IS
  BEGIN
    self.oname := oname;
  END set_oname;
  
  MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN NULL;
  END get_name;
	
  /* Implement a to_string function. */
  MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oname||']';
  END to_string;
END;
/



-- Close log file.
SPOOL OFF

-- Quit SQL*Plus session.
QUIT;
