
--ФУНКЦИЯ ЗАПИСИ

create or replace function write_to_records(
p_patient_id in number,
p_ticket_id in number)
return lazorenko_al.records.record_id%type as
v_record_id lazorenko_al.records.record_id%type;
begin
    insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
    values (default, 1, p_patient_id, p_ticket_id)

    returning record_id into v_record_id;

    update lazorenko_al.ticket t set t.ticket_stat_id=2 where t.ticket_id=p_ticket_id;

    commit;
    return v_record_id;
end;

declare
v_recored_id number;
begin
v_recored_id:=lazorenko_al.write_to_records(3,33);
dbms_output.put_line(v_recored_id);
end;

--ФУНКЦИЯ ПРОВЕРКИ УСЛОВИЙ ПЕРЕД ЗАПИСЬЮ

create or replace function lazorenko_al.check_for_accept(
p_ticket_id in number,
p_patient_id in number,
p_spec_id in number,
p_doctor_id in number,
p_hospital_id in number,
p_lazy_check in boolean default false,
out_messages out varchar2
)
return boolean
as
    v_result boolean := true;
begin
    if (not lazorenko_al.check_IN_parameters(
    p_hospital_id => p_hospital_id,
    p_doctor_id => p_doctor_id,
    p_spec_id => p_spec_id,
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'несоответствие врача и специальности или врача и больницы или выбранного талона и врача';
    if (p_lazy_check) then return v_result; end if;
    end if;
    if (not lazorenko_al.patient_doc_check(
    p_patient_id => p_patient_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'отсутсвуют данные о полисе ОМС пациента';
    end if;
    if (not lazorenko_al.not_deleted_check(
    p_doctor_id => p_doctor_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'больница, врач или специальность удалены';
    end if;
    if (not lazorenko_al.time_check(
        p_ticket_id => p_ticket_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'данный приём уже завершился';
    end if;
    if (not lazorenko_al.sex_check(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'пол пациента не соответствует полу специальности';
    end if;
    if (not lazorenko_al.check_age(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'возраст пациента не соответствует возрасту специальности';
    end if;
    if (not lazorenko_al.ticket_check(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'пациент уже был записан на этот талон';
    end if;
    if (not lazorenko_al.ticket_status_check(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'талон закрыт';
end if;
    return v_result;
    end;

declare
   v_result number;
   v_messages varchar2(500);
begin
    v_result :=sys.diutil.bool_to_int(lazorenko_al.check_for_accept(
    27, 7, 6, 3, 5, true,v_messages));
    dbms_output.put_line(v_messages);
end;

--ФУНКЦИЯ ЗАПИСИ С ПРОВЕРКОЙ УСЛОВИЯ

create or replace function lazorenko_al.accept_record_by_rules(
v_ticket_id number,
v_patient_id number,
v_spec_id number,
v_doctor_id number,
v_hospital_id number,
v_lazy_check boolean,
v_messages in out varchar2,
v_result out number
) return  lazorenko_al.records.record_id%type as
v_record_id lazorenko_al.records.record_id%type;
begin
 if (lazorenko_al.check_for_accept(
            p_ticket_id => v_ticket_id,
            p_patient_id => v_patient_id,
            p_spec_id => v_spec_id,
            p_doctor_id => v_doctor_id,
            p_hospital_id => v_hospital_id,
            p_lazy_check => v_lazy_check,
            out_messages => v_messages))
 then v_record_id:=lazorenko_al.write_to_records(p_patient_id => v_patient_id,
                                                 p_ticket_id => v_ticket_id);

 dbms_output.put_line(v_record_id ||' - '||'запись осуществлена успешно');

 else v_result:=sys.diutil.bool_to_int(lazorenko_al.check_for_accept(v_ticket_id,
                                                                        v_patient_id,
                                                                        v_spec_id,
                                                                        v_doctor_id,
                                                                        v_hospital_id,
                                                                        v_lazy_check,
                                                                        v_messages));
 dbms_output.put_line(v_messages);
end if;
return v_result;
end;

--ПРИМЕНЕНИЕ МЕТОДА ЗАПИСИ
declare
   v_messages varchar2(500);
   v_result number;
begin
    v_result:=lazorenko_al.accept_record_by_rules(
    27, 2, 6, 31, 5, false,
    v_messages, v_result);
end;