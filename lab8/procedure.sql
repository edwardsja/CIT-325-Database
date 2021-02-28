-- STEP 1 AND 2
CREATE OR REPLACE 
PACKAGE contact_package IS
    PROCEDURE insert_contact
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
    , pv_user_name           VARCHAR2 );

    PROCEDURE insert_contact
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
    , pv_user_id           NUMBER := NULL);
END contact_package;
/

CREATE OR REPLACE PACKAGE BODY contact_package IS
    PROCEDURE insert_contact
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
    , pv_user_name           VARCHAR2 ) IS

  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  
  lv_member_id           NUMBER;
  
  lv_creation_date DATE := SYSDATE;
  lv_created_by NUMBER := NVL(pv_user_id, -1);
  lv_last_updated_by NUMBER := NVL(pv_user_id, -1);
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
  RETURN;
END insert_contact;

--id insert_contact
PROCEDURE insert_contact
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
    , pv_user_id           NUMBER := NULL) IS

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
  ,  );  

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
  RETURN;
  END insert_contact;
END contact_package;
/

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date ) 
VALUES 
( 6
, 'BONDSB'
, 1
, 1
, 'Barry'
, 'Bonds'
, 1
, SYSDATE
, 1
, SYSDATE );

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date ) 
VALUES 
( 7
, 'CURRYW'
, 1
, 1
, 'Wardell'
, 'Curry'
, 1
, SYSDATE
, 1
, SYSDATE );

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date ) 
VALUES 
( -1
, 'ANONYMOUS'
, 1
, 1
, NULL
, NULL
, 1
, SYSDATE
, 1
, SYSDATE );

COL system_user_id   FORMAT 9999 HEADING "System|User ID"
COL system_user_name FORMAT A12 HEADING "System|User Name"
COL first_name       FORMAT A10 HEADING "First|Name"
COL middle_initial   FORMAT A2 HEADING "MI"
COL last_name        FORMAT A10 HEADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      last_name
FROM system_user
WHERE last_name IN ('Bonds', 'Curry')
OR    system_user_name = 'ANONYMOUS';


BEGIN
  contact_package.insert_contact(
    pv_first_name => 'Charlie'
  , pv_middle_name => NULL
  , pv_last_name => 'Brown'
  , pv_contact_type => 'CUSTOMER'
  , pv_account_number => 'SLC-000011'     
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
  , pv_user_name        => 'DBA 3'
  );
  contact_package.insert_contact(
    pv_first_name => 'Peppermint'
  , pv_middle_name => NULL
  , pv_last_name => 'Patty'
  , pv_contact_type => 'CUSTOMER'
  , pv_account_number => 'SLC-000011'     
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
  , pv_user_name        => NULL
  );
  contact_package.insert_contact(
    pv_first_name => 'Sally'
  , pv_middle_name => NULL
  , pv_last_name => 'Brown'
  , pv_contact_type => 'CUSTOMER'
  , pv_account_number => 'SLC-000011'     
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
  , pv_user_id          => 6
  );
END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name IN ('Brown','Patty');
