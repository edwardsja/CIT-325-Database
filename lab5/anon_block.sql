 DECLARE

CURSOR c is 
  SELECT ra.rating_agency_id, ra.rating, ra.rating_agency FROM rating_agency ra;

CREATE
TYPE rating_agency_tab is TABLE OF rating_agency_obj;
/

lv_rating_agency_tab  RATING_AGENCY_TAB := rating_agency_tab();

BEGIN

FOR i in 1..1 LOOP 
  OPEN c;
  lv_rating_agency_tab.EXTEND;
  FETCH c
  INTO 
     lv_rating_agency_tab( lv_rating_agency_tab.COUNT)( 
                        lv_rating_agency_id
                      , lv_rating
                      , lv_rating_agency );
    CLOSE c;
  
END LOOP;

FOR i in 1..lv_rating_agency_tab.COUNT LOOP 
  UPDATE item
  SET rating_agency_id = lv_rating_agency_tab(i).rating_agency_id
  WHERE item.item_rating = lv_rating_agency_tab(i).lv_rating AND item.item_rating_agency = lv_rating_agency_tab(i).lv_rating_agency; 
END LOOP;

END;
/
