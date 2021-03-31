


CREATE OR REPLACE
  TYPE elf_t UNDER base_t
  ( name  VARCHAR2(30)
  , genus VARCHAR2(30) 
  , CONSTRUCTOR FUNCTION elf_t
  ( name  VARCHAR2 
  , genus VARCHAR2 ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER PROCEDURE set_name 
  ( name VARCHAR2 )
  , MEMBER FUNCTION get_genus RETURN VARCHAR2
  , MEMBER PROCEDURE set_genus 
  ( genus VARCHAR2 ) 
, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY elf_t IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION elf_t
  ( name  VARCHAR2 
  , genus VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.name := name;
    self.genus := genus;
    RETURN;
  
  END elf_t;
  
  -- get_name function
  OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN self.name;
    END get_name;
    
  MEMBER PROCEDURE set_name
  ( name VARCHAR2 ) IS
    BEGIN
      self.name := name;
    END set_name;

  MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
    BEGIN
      RETURN self.genus;
    END get_genus;
	
   MEMBER PROCEDURE set_genus
  ( genus VARCHAR2 ) IS
  BEGIN
    self.genus := genus;
  END set_genus;
  
  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN 
      RETURN '['||self.oid||']['||self.name||']['||self.genus||']';
    END to_string;
	
END;
/


QUIT;
