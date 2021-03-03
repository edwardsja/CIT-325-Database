 -- creating update_item_desc procedure
CREATE OR REPLACE 
PROCEDURE update_item_description
( pv_item_title VARCHAR2 ) IS
  CURSOR c 
  ( cv_item_title VARCHAR2 ) IS
    SELECT i.item_id, i.text_file_name
    FROM   item i INNER JOIN file_list fl
    ON i.text_file_name = fl.file_name
    WHERE REGEXP_LIKE(i.item_title,'^.*'||cv_item_title||'.*$')
    AND    item_type IN
      (SELECT common_lookup_id
       FROM common_lookup
       WHERE common_lookup_table = 'ITEM'
       AND common_lookup_column = 'ITEM_TYPE'
       AND REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'));
BEGIN
    FOR i IN c(pv_item_title) LOOP
      load_clob_from_file( src_file_name     => i.text_file_name
                         , table_name        => 'ITEM'
                         , column_name       => 'ITEM_DESC'
                         , primary_key_name  => 'ITEM_ID'
                         , primary_key_value => TO_CHAR(i.item_id) );
    END LOOP;
END;
/
