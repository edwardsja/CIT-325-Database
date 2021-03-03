-- STEP 3
CREATE OR REPLACE 
PACKAGE contact_package IS
    FUNCTION insert_contact
    ( pv_first_name          VARCHAR2
    , pv_middle_name         VARCHAR2
    , pv_last_name           VARCHAR2
    , pv_contact_type        VARCHAR2
    , pv_account_number      VARCHAR2
    , pv_member_type         VARCHAR2
    , pv_credit_card_number  VARCHAR2
    , pv_credit_card_type    VARCHAR2
    , pv_city                VARCHAR2
    , pv_state_province      VARCHAR2
    , pv_postal_code         VARCHAR2
    , pv_address_type        VARCHAR2
    , pv_country_code        VARCHAR2
    , pv_area_code           VARCHAR2
    , pv_telephone_number    VARCHAR2
    , pv_telephone_type      VARCHAR2
    , pv_user_name           VARCHAR2 ) RETURN NUMBER;

    FUNCTION insert_contact
    ( pv_first_name          VARCHAR2
    , pv_middle_name         VARCHAR2
    , pv_last_name           VARCHAR2
    , pv_contact_type        VARCHAR2
    , pv_account_number      VARCHAR2
    , pv_member_type         VARCHAR2
    , pv_credit_card_number  VARCHAR2
    , pv_credit_card_type    VARCHAR2
    , pv_city                VARCHAR2
    , pv_state_province      VARCHAR2
    , pv_postal_code         VARCHAR2
    , pv_address_type        VARCHAR2
    , pv_country_code        VARCHAR2
    , pv_area_code           VARCHAR2
    , pv_telephone_number    VARCHAR2
    , pv_telephone_type      VARCHAR2
    , pv_user_id           NUMBER := NULL) RETURN NUMBER;
END contact_package;
/

CREATE OR REPLACE PACKAGE BODY contact_package IS
    FUNCTION insert_contact
     ( pv_first_name          VARCHAR2
    , pv_middle_name         VARCHAR2
    , pv_last_name           VARCHAR2
    , pv_contact_type        VARCHAR2
    , pv_account_number      VARCHAR2
    , pv_member_type         VARCHAR2
    , pv_credit_card_number  VARCHAR2
    , pv_credit_card_type    VARCHAR2
    , pv_city                VARCHAR2
    , pv_state_province      VARCHAR2
    , pv_postal_code         VARCHAR2
    , pv_address_type        VARCHAR2
    , pv_country_code        VARCHAR2
    , pv_area_code           VARCHAR2
    , pv_telephone_number    VARCHAR2
    , pv_telephone_type      VARCHAR2
    , pv_user_name           VARCHAR2 ) RETURN NUMBER IS

  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  
  lv_member_id           NUMBER;
  
  lv_creation_date DATE := SYSDATE;
  lv_created_by NUMBER := 1;
  lv_last_updated_by NUMBER := 1;
  lv_last_update_date DATE := SYSDATE;
  
  CURSOR get_lookup_type
    ( cv_table_name VARCHAR2
    , cv_column_name VARCHAR2
    , cv_type_name VARCHAR2 ) IS
      SELECT common_lookup_id
      FROM common_lookup
      WHERE common_lookup_table = cv_table_name
      AND common_lookup_column = cv_column_name
      AND common_lookup_type = cv_type_name;
      
  CURSOR get_member
  ( cv_account_number VARCHAR2 ) IS
    SELECT m.member_id
    FROM member m
    WHERE m.account_number = cv_account_number;
      
  
BEGIN

SAVEPOINT before_inserts;

FOR i IN get_lookup_type('MEMBER','MEMBER_TYPE',pv_member_type) LOOP
  lv_member_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type) LOOP
  lv_credit_card_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('CONTACT','CONTACT_TYPE',pv_contact_type) LOOP
  lv_contact_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('ADDRESS','ADDRESS_TYPE',pv_address_type) LOOP
  lv_address_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type) LOOP
  lv_telephone_type := i.common_lookup_id;
END LOOP;

OPEN get_member(pv_account_number);
FETCH get_member INTO lv_member_id;

IF get_member%NOTFOUND THEN
    INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_created_by
        , lv_creation_date
        , lv_last_updated_by
        , lv_last_update_date );
END IF;

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  INSERT INTO address
  ( address_id
  , contact_id
  , address_type
  , city
  , state_province
  , postal_code
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  INSERT INTO telephone
  ( telephone_id
  , contact_id
  , address_id
  , telephone_type
  , country_code
  , area_code
  , telephone_number
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );                             -- LAST_UPDATE_DATE
  
  
  --If any error, it is caught here and function returns 0 to indicate failure
  COMMIT;
-- EXCEPTION 
--   WHEN OTHERS THEN
--     dbms_output.put_line(SQLERRM);
--     ROLLBACK TO before_inserts;
--     RETURN 0;

  -- if no exeption occurs, inserts must have succeeded, so return 1 to indicate success
  RETURN 1;
END insert_contact;

--id insert_contact
FUNCTION insert_contact
    ( pv_first_name          VARCHAR2
    , pv_middle_name         VARCHAR2
    , pv_last_name           VARCHAR2
    , pv_contact_type        VARCHAR2
    , pv_account_number      VARCHAR2
    , pv_member_type         VARCHAR2
    , pv_credit_card_number  VARCHAR2
    , pv_credit_card_type    VARCHAR2
    , pv_city                VARCHAR2
    , pv_state_province      VARCHAR2
    , pv_postal_code         VARCHAR2
    , pv_address_type        VARCHAR2
    , pv_country_code        VARCHAR2
    , pv_area_code           VARCHAR2
    , pv_telephone_number    VARCHAR2
    , pv_telephone_type      VARCHAR2
    , pv_user_id           NUMBER := NULL) RETURN NUMBER IS

  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  
  lv_creation_date DATE := SYSDATE;
  lv_created_by NUMBER := NVL(pv_user_id, -1);
  lv_last_updated_by NUMBER := NVL(pv_user_id, -1);
  lv_last_update_date DATE := SYSDATE;
  
  lv_member_id           NUMBER;
  
  CURSOR get_lookup_type
    ( cv_table_name VARCHAR2
    , cv_column_name VARCHAR2
    , cv_type_name VARCHAR2 ) IS
      SELECT common_lookup_id
      FROM common_lookup
      WHERE common_lookup_table = cv_table_name
      AND common_lookup_column = cv_column_name
      AND common_lookup_type = cv_type_name;
  
  CURSOR get_member
  ( cv_account_number VARCHAR2 ) IS
    SELECT m.member_id
    FROM member m
    WHERE m.account_number = cv_account_number;
BEGIN

SAVEPOINT before_inserts;

FOR i IN get_lookup_type('MEMBER','MEMBER_TYPE',pv_member_type) LOOP
  lv_member_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type) LOOP
  lv_credit_card_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('CONTACT','CONTACT_TYPE',pv_contact_type) LOOP
  lv_contact_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('ADDRESS','ADDRESS_TYPE',pv_address_type) LOOP
  lv_address_type := i.common_lookup_id;
END LOOP;

FOR i IN get_lookup_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type) LOOP
  lv_telephone_type := i.common_lookup_id;
END LOOP;

OPEN get_member(pv_account_number);
FETCH get_member INTO lv_member_id;

IF get_member%NOTFOUND THEN

INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  , lv_member_type
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );
END IF;

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  INSERT INTO address
  ( address_id
  , contact_id
  , address_type
  , city
  , state_province
  , postal_code
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by 
  , lv_last_update_date );  

  INSERT INTO telephone
  ( telephone_id
  , contact_id
  , address_id
  , telephone_type
  , country_code
  , area_code
  , telephone_number
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );                             -- LAST_UPDATE_DATE
  
  
  --If any error, it is caught here and function returns 0 to indicate failure
  COMMIT;
-- EXCEPTION 
--   WHEN OTHERS THEN
--     dbms_output.put_line(SQLERRM);
--     ROLLBACK TO before_inserts;
--     RETURN 0;

  -- if no exeption occurs, inserts must have succeeded, so return 1 to indicate success
  RETURN 1;
  END insert_contact;
END contact_package;
/

BEGIN 
  IF contact_package.insert_contact(
    pv_first_name => 'Shirley'
  , pv_middle_name => NULL
  , pv_last_name => 'Partridge'
  , pv_contact_type => 'CUSTOMER'
  , pv_account_number => 'SLC-000012'     
  , pv_member_type => 'GROUP'
  , pv_credit_card_number => '8888-6666-8888-4444'  
  , pv_credit_card_type => 'VISA_CARD'
  , pv_city             => 'Lehi'
  , pv_state_province   => 'Utah'   
  , pv_postal_code      => '84043'
  , pv_address_type     => 'HOME' 
  , pv_country_code     => '001'
  , pv_area_code        => '207'  
  , pv_telephone_number => '877-4321'
  , pv_telephone_type   => 'HOME'  
  , pv_user_name        => 'DBA 3' ) = 1 THEN
    dbms_output.put_line('Insert function succeeds.');
  END IF;
END;
/

BEGIN 
  IF contact_package.insert_contact(
    pv_first_name => 'Keith'
  , pv_middle_name => NULL
  , pv_last_name => 'Partridge'
  , pv_contact_type => 'CUSTOMER'
  , pv_account_number => 'SLC-000012'     
  , pv_member_type => 'GROUP'
  , pv_credit_card_number => '8888-6666-8888-4444'  
  , pv_credit_card_type => 'VISA_CARD'
  , pv_city             => 'Lehi'
  , pv_state_province   => 'Utah'   
  , pv_postal_code      => '84043'
  , pv_address_type     => 'HOME' 
  , pv_country_code     => '001'
  , pv_area_code        => '207'  
  , pv_telephone_number => '877-4321'
  , pv_telephone_type   => 'HOME'  
  , pv_user_id        => 6 ) = 1 THEN
    dbms_output.put_line('Insert function succeeds.');
  END IF;
END;
/

BEGIN 
  IF contact_package.insert_contact(
    pv_first_name => 'Laurie'
  , pv_middle_name => NULL
  , pv_last_name => 'Partridge'
  , pv_contact_type => 'CUSTOMER'
  , pv_account_number => 'SLC-000012'     
  , pv_member_type => 'GROUP'
  , pv_credit_card_number => '8888-6666-8888-4444'  
  , pv_credit_card_type => 'VISA_CARD'
  , pv_city             => 'Lehi'
  , pv_state_province   => 'Utah'   
  , pv_postal_code      => '84043'
  , pv_address_type     => 'HOME' 
  , pv_country_code     => '001'
  , pv_area_code        => '207'  
  , pv_telephone_number => '877-4321'
  , pv_telephone_type   => 'HOME'  
  , pv_user_id        => -1 ) = 1 THEN
    dbms_output.put_line('Insert function succeeds.');
  END IF;
END;
/
