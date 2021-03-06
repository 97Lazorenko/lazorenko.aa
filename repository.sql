

create or replace package lazorenko_al.pkg_code
as
    c_ok constant integer := 1;
    c_error constant integer := -1;
end;



--репозиторий докторов
create or replace function lazorenko_al.repository(
    out_result out number
)
return clob
as

    v_success boolean;
    v_code number;
    v_clob clob;

begin

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




--репозиторий больниц
create or replace function lazorenko_al.repository_hospitals(
    out_result out number
)
return clob
as

    v_success boolean;
    v_code number;
    v_clob clob;

begin

    v_clob := lazorenko_al.HTTP_FETCH(
        p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/hospitals',
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




declare

    v_result integer;
    v_clob clob;

begin

    v_clob := lazorenko_al.repository_hospitals(
        out_result => v_result
    );

end;

--репозиторий специальностей

create or replace function lazorenko_al.repository_specs(
    out_result out number
)
return clob
as

    v_success boolean;
    v_code number;
    v_clob clob;

begin

    v_clob := lazorenko_al.HTTP_FETCH(
        p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/specialties',
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




declare

    v_result integer;
    v_clob clob;

begin

    v_clob := lazorenko_al.repository_specs(
        out_result => v_result
    );

end;
