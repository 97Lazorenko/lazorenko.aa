--репозиторий внешних докторов
create or replace package lazorenko_al.pkg_doctor_remote_repository
as
    function get_doctors_remote(
    out_result out number
    )
    return clob;
end;


create or replace package body lazorenko_al.pkg_doctor_remote_repository
as
    function  get_doctors_remote(
    out_result out number
    )
    return clob
    as

    v_success boolean;
    v_code number;
    v_clob clob;

    begin

    v_clob := lazorenko_al.pkg_client_http.http_fetch(
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
end;


--репозиторий внешних больниц
create or replace package lazorenko_al.pkg_hospital_remote_repository
as
    function get_hospitals_remote(
    out_result out number
    )
    return clob;
end;

--его тело
create or replace package body lazorenko_al.pkg_hospital_remote_repository
as
    function get_hospitals_remote(
    out_result out number
    )
    return clob
    as

    v_success boolean;
    v_code number;
    v_clob clob;

    begin

    v_clob := lazorenko_al.pkg_client_http.http_fetch(
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
end;


--репозиторий внешних специальностей
create or replace package lazorenko_al.pkg_specs_remote_repository
as
    function get_specs_remote(
    out_result out number
    )
    return clob;
end;

--его тело
create or replace package body lazorenko_al.pkg_specs_remote_repository
as
    function get_specs_remote(
    out_result out number
    )
    return clob
    as

    v_success boolean;
    v_code number;
    v_clob clob;

    begin

    v_clob := lazorenko_al.pkg_client_http.http_fetch(
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
end;



--репозиторий всех проверок

create or replace package lazorenko_al.pkg_total_checks_repository
as
    function check_for_accept_with_exceptions(
        p_ticket_id number,
        p_patient_id in number,
        p_spec_id number,
        p_doctor_id number,
        p_hospital_id number
    )
    return boolean;

    function check_cancel(
    p_hospital_id in number,
    p_ticket_id in number,
    p_patient_id in number
    )
    return boolean;

end;


create or replace package body lazorenko_al.pkg_total_checks_repository
as
    function check_for_accept_with_exceptions(
        p_ticket_id number,
        p_patient_id in number,
        p_spec_id number,
        p_doctor_id number,
        p_hospital_id number
    )
    return boolean
    as
    v_result boolean := true;

    e_total exception;
    pragma exception_init (e_total, -20666);

    begin
    if lazorenko_al.accordance_ckeck_repository.check_accordance_of_write_parameters(
        p_hospital_id => p_hospital_id,
        p_doctor_id => p_doctor_id,
        p_spec_id => p_spec_id,
        p_ticket_id => p_ticket_id
        ) is null
    then v_result:=false;
    return v_result;
    end if;

    if lazorenko_al.pkg_patient_repository.get_patient_info_by_id(
        p_patient_id => p_patient_id
        ) is null
    then v_result:=false;
    return v_result;
    end if;

    if lazorenko_al.pkg_ticket_repository.get_ticket_info_by_id(
        p_ticket_id => p_ticket_id
        ) is null
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.pkg_doctor_repository.not_deleted_doctor_check(
        p_doctor_id => p_doctor_id
        ))
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.pkg_specialisations_repository.not_deleted_spec_check(
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.pkg_hospital_repository.not_deleted_hospital_check(
        p_hospital_id => p_hospital_id
        ))
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.pkg_patient_repository.check_age(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.pkg_patient_repository.sex_check(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.pkg_patient_repository.patient_doc_check(
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.pkg_ticket_repository.ticket_check(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.pkg_ticket_repository.ticket_status_check(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.pkg_ticket_repository.time_check(
        p_ticket_id => p_ticket_id
        ))
    then v_result:=false;
    end if;
        if v_result=false then
        raise_application_error (-20666, 'Ошибка верификации входных параметров');
        end if;
    return v_result;
    exception

        when e_total then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Ошибка верификации входных параметров');

    return false;
    end;

    function check_cancel(
    p_hospital_id in number,
    p_ticket_id in number,
    p_patient_id in number
    )
    return boolean
    as
    v_result boolean := true;

    e_total exception;
    pragma exception_init (e_total, -20666);

    begin
    if (not lazorenko_al.accordance_ckeck_repository.check_accordance_for_cancel(
    p_patient_id => p_patient_id,
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
        if v_result=false then
        raise_application_error (-20666, 'Ошибка верификации входных параметров');
        end if;
    return v_result;
    end if;

    if (not lazorenko_al.pkg_ticket_repository.ticket_time_check(
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
    end if;

    if (not lazorenko_al.pkg_hospital_repository.hospital_time_check(
    p_hospital_id => p_hospital_id
    )) then v_result:=false;
    end if;
      if v_result=false then
        raise_application_error (-20666, 'Ошибка верификации входных параметров');
        end if;
    return v_result;

        exception

        when e_total then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Ошибка верификации входных параметров');

    return false;
    end;
end;