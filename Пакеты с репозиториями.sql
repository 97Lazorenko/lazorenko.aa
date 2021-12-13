--репозиторий внешних докторов
create or replace package lazorenko_al.pkg_doctor_remote_repository
as
    function get_doctors_remote(
    out_result out number
    )
    return clob;
end;

--его тело
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

    return v_result;
    end;

    function check_cancel(
    p_hospital_id in number,
    p_ticket_id in number,
    p_patient_id in number
    )
    return boolean
    as
    v_result boolean := true;
    begin
    if (not lazorenko_al.accordance_ckeck_repository.check_accordance_for_cancel(
    p_patient_id => p_patient_id,
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
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

    return v_result;
    end;
end;









/*
--пакет с репозиториями записи/отмены записи
create or replace package lazorenko_al.pkg_write_or_cancel_repository
as

    function repository_recording(
    p_ticket_id number,
    p_patient_id number
    )
    return lazorenko_al.t_result;

    function repository_cancel_record(
    p_ticket_id number
    )
    return lazorenko_al.t_result;

end;

--тело пакета
create or replace package body lazorenko_al.pkg_write_or_cancel_repository
as
    function repository_recording(
    p_ticket_id number,
    p_patient_id number
    )
    return lazorenko_al.t_result as
        v_result lazorenko_al.t_result;

    begin
        v_result:=lazorenko_al.pkg_write_or_cancel.write_to_records(
        p_patient_id => p_patient_id,
        p_ticket_id => p_ticket_id,
        p_need_handle => true
    );
    return v_result;

    end;

    function repository_cancel_record(
    p_ticket_id number
    )
    return lazorenko_al.t_result as
        v_result lazorenko_al.t_result;

    begin
        v_result:=lazorenko_al.pkg_write_or_cancel.cancel_record(
        p_ticket_id => p_ticket_id
        );
    return v_result;

    end;
end;

--пакет с проверками условий перед записью
create or replace package lazorenko_al.pkg_check_before_write_repository
as
    function repository_with_checks(
    p_ticket_id number,
    p_patient_id number,
    p_spec_id number,
    p_doctor_id number,
    p_hospital_id number,
    out_result out number
    )
    return number;
end;

--его тело
create or replace package body lazorenko_al.pkg_check_before_write_repository
as
    function repository_with_checks(
    p_ticket_id number,
    p_patient_id number,
    p_spec_id number,
    p_doctor_id number,
    p_hospital_id number,
    out_result out number
    )
    return number
    as v_result boolean;

    begin

    v_result:=lazorenko_al.check_for_accept_with_exceptions(
    p_ticket_id => p_ticket_id,
    p_patient_id => p_patient_id,
    p_spec_id => p_spec_id,
    p_doctor_id => p_doctor_id,
    p_hospital_id => p_hospital_id);

    out_result := case when sys.diutil.bool_to_int(v_result)>0
        then lazorenko_al.pkg_code.c_ok
        else lazorenko_al.pkg_code.c_error
    end;

    return out_result;

    end;

end;

--пакет с проверками условий перед отменой записи
create or replace package lazorenko_al.pkg_check_before_cancel_repository
as
    function repository_with_checks_before_cancel(
    p_hospital_id number,
    p_ticket_id number,
    p_patient_id number,
    out_result out number
    )
    return number;
end;

--его тело
create or replace package body lazorenko_al.pkg_check_before_cancel_repository
as
    function repository_with_checks_before_cancel(
    p_hospital_id number,
    p_ticket_id number,
    p_patient_id number,
    out_result out number
    )
    return number
    as v_result boolean;

    begin

    v_result:=lazorenko_al.check_cancel(
    p_hospital_id => p_hospital_id,
    p_ticket_id => p_ticket_id,
    p_patient_id => p_patient_id);

    out_result := case when sys.diutil.bool_to_int(v_result)>0
        then lazorenko_al.pkg_code.c_ok
        else lazorenko_al.pkg_code.c_error
    end;

    return out_result;

    end;
end;