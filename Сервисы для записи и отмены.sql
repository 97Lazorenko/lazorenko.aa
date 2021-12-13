

--сервис для записи
create or replace function lazorenko_al.service_for_records(
    p_ticket_id number,
    p_patient_id number,
    p_need_handle boolean,
    p_spec_id number,
    p_doctor_id number,
    p_hospital_id number,
    out_fail out number
)
return lazorenko_al.t_record
as

    v_result_check number;
    v_result_write lazorenko_al.t_result;
    v_response lazorenko_al.t_record;

begin
    v_result_check := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_for_accept_with_exceptions(
    p_ticket_id => p_ticket_id,
    p_patient_id => p_patient_id,
    p_spec_id => p_spec_id,
    p_doctor_id => p_doctor_id,
    p_hospital_id => p_hospital_id--,
    --out_result => v_result_check
    ));


    if v_result_check>0
        then v_result_write:=lazorenko_al.pkg_write_or_cancel_repository.write_to_records(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id,
        p_need_handle => p_need_handle);

        commit;

        v_response:=lazorenko_al.pkg_records_repository.get_record(
        p_ticket_id => p_ticket_id
        );
        /*select lazorenko_al.t_record(
        record_id => r.record_id,
        record_stat_id => r.record_stat_id,
        patient_id => r.patient_id,
        ticket_id => r.ticket_id)
        into v_response
        from lazorenko_al.records r
        where r.ticket_id=p_ticket_id; */

        out_fail:=v_result_check;

        return v_response;

    else out_fail:=v_result_check;

    end if;
return v_response;
end;
/


--Применение

declare

    v_response lazorenko_al.t_record;
    v_fail number;

begin

    v_response := lazorenko_al.service_for_records(
        33, 1, true, 3, 3, 4, v_fail)
    ;

            dbms_output.put_line(v_response.record_id || ' '|| v_response.record_stat_id||' '||v_response.ticket_id||' '||v_response.patient_id);
            dbms_output.put_line(v_fail);
end;


--сервис для отмены записи

create or replace function lazorenko_al.service_for_cancel(
    p_ticket_id number,
    p_patient_id number,
    p_hospital_id number,
    out_fail out number
)
return lazorenko_al.t_record
as

    v_result_check number;
    v_result_write lazorenko_al.t_result;
    v_response lazorenko_al.t_record;

begin

    v_result_check := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_cancel(
    p_hospital_id => p_hospital_id,
    p_ticket_id => p_ticket_id,
    p_patient_id => p_patient_id--,
    --out_result => v_result_check
    ));


    if v_result_check>0
        then v_result_write:=lazorenko_al.pkg_write_or_cancel_repository.cancel_record(
        p_ticket_id => p_ticket_id);

        commit;

        v_response:=lazorenko_al.pkg_records_repository.get_record(
        p_ticket_id => p_ticket_id
        );

        out_fail:=v_result_check;

        return v_response;

    else out_fail:=v_result_check;

    end if;
return v_response;
end;
/


--Применение

declare

    v_response lazorenko_al.t_record;
    v_fail number;

begin

    v_response := lazorenko_al.service_for_cancel(
        33, 1, 4, v_fail)
    ;

            dbms_output.put_line(v_response.record_id || ' '|| v_response.record_stat_id||' '||v_response.ticket_id||' '||v_response.patient_id);
            dbms_output.put_line(v_fail);
end;