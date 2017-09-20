MAIN

    CONSTANT c_gmaps = "https://www.google.com/maps"
    DEFINE c_gmaps_with_apikey STRING
    DEFINE title STRING
    
    DEFINE loc_rec RECORD
               loc_pick STRING,
               loc_title STRING,
               loc_map STRING
           END RECORD

    OPTIONS INPUT WRAP
    
    OPEN FORM f1 FROM "wc_googlemaps"
    DISPLAY FORM f1

    IF ui.Interface.getFrontEndName() = "GBC" THEN
      LET c_gmaps_with_apikey = c_gmaps || "/embed/v1/place?key=" || fgl_getenv("GOOGLE_MAP_API_KEY")
    ELSE
      LET c_gmaps_with_apikey = c_gmaps || "/place?key=" || fgl_getenv("GOOGLE_MAP_API_KEY")
    END IF

    LET loc_rec.loc_pick = "My+Location"
    
    LET loc_rec.loc_map = c_gmaps_with_apikey || "&q=" || loc_rec.loc_pick

    --LET loc_rec.loc_title = "You are looking at a map of : " || loc_rec.loc_pick
    
    INPUT BY NAME loc_rec.* WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED)

          BEFORE INPUT
             TRY
              CALL ui.Interface.frontCall("webcomponent", "call",["formonly.loc_map", "eval", "document.title"],[title] )
              LET loc_rec.loc_title = title
             CATCH
              MESSAGE "Wecomponent frontcall didn't execute correctly"
              LET loc_rec.loc_title = "Google Maps API"
            END TRY
             
          ON ACTION googlemapsearch
            LET loc_rec.loc_map = c_gmaps_with_apikey || "&q=" || loc_rec.loc_pick
            NEXT FIELD loc_map
          ON CHANGE loc_map
            TRY
              --CALL ui.Interface.frontCall("webcomponent", "getTitle",["formonly.loc_map"], [title] )
              CALL ui.Interface.frontCall("webcomponent", "call",["formonly.loc_map", "eval", "document.title"],[title] )
              LET loc_rec.loc_title = title
            CATCH
              MESSAGE "Wecomponent frontcall didn't execute correctly"
              LET loc_rec.loc_title = "Google Maps API"
            END TRY
            

          --ON ACTION cancel
            
    END INPUT
END MAIN