
CREATE OR REPLACE
  TYPE teleri_t UNDER elf_t
  ( elfkind VARCHAR2(30)  
  , CONSTRUCTOR FUNCTION teleri_t
  ( elfkind VARCHAR2 ) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_elfkind RETURN VARCHAR2
  , MEMBER PROCEDURE set_elfkind
  ( elfkind VARCHAR2 ) )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY teleri_t IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION teleri_t
  ( elfkind VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.elfkind := elfkind;
    RETURN;
  
  END teleri_t;
  
  MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
    BEGIN
      RETURN self.elfkind;
    END get_elfkind;
	
  MEMBER PROCEDURE set_elfkind
  ( elfkind VARCHAR2 ) IS
  BEGIN
    self.elfkind := elfkind;
  END set_elfkind;
	
END;
/

QUIT;
