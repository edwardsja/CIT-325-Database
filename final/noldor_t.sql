
CREATE OR REPLACE
  TYPE noldor_t UNDER elf_t
  ( elfkind VARCHAR2(30)  
  , CONSTRUCTOR FUNCTION noldor_t
  ( elfkind VARCHAR2 ) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_elfkind RETURN VARCHAR2
  , MEMBER PROCEDURE set_elfkind
  ( elfkind VARCHAR2 ) )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY noldor_t IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION noldor_t
  ( elfkind VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.elfkind := elfkind;
    RETURN;
  
  END noldor_t;
  
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
