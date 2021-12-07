

create or replace package lazorenko_al.pkg_code
as
    c_ok constant integer := 1;
    c_error constant integer := -1;
end;




/*
 FETCH USING
 */



--репозиторий
create or replace function lazorenko_al.repository(
    --p_parameters...
    out_result out number
)
return clob
as

    v_success boolean;
    v_code number;
    v_clob clob;

begin

    /**
      документация к API
      https://app.swaggerhub.com/apis/AntonovAD/DoctorDB/1.0.0
     */

    v_clob := lazorenko_al.HTTP_FETCH(
        p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/doctors',
        p_debug => true,
        out_success => v_success,
        out_code => v_code
    );

    out_result := case when v_success
        then lazorenko_al.pkg_code.c_ok
        else lazorenko_al.pkg_code.c_error
    end;

    return v_clob;

end;
/



declare

    v_result integer;
    v_clob clob;

begin

    v_clob := lazorenko_al.repository(
        out_result => v_result
    );

end;
/

