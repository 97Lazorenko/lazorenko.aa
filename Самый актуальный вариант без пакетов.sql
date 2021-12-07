--ССЗДАНИЕ ТИПА, ВОЗВРАЩАЕМОГО ФУНКЦИЯМИ ЗАПИСИ И ОТМЕНЫ
create or replace type lazorenko_al.t_result as object(
    result_value number);

alter type lazorenko_al.t_result
add constructor function t_result(
    result_value number)
return self as result
cascade;

create or replace type body lazorenko_al.t_result
as
    constructor function t_result(
        result_value number
    )
    return self as result
    as
    begin
        self.result_value:= result_value;

        return;
    end;
end;



--ПАКЕТ С ФУНКЦИЯМИ ЗАПИСИ И ОТМЕНЫ ЗАПИСИ С ОТЛОВОМ ОШИЮОК И ЛОГИРОВАНИЕМ
create or replace package lazorenko_al.pkg_write_or_cancel
as
    c_record_or_ticket_stat_first constant number := 1;
                                                          --КОНСТАНТЫ БУДУТ ИСПОЛЬЗОВАНЫ В ФУНКЦИЯХ ЗАПИСИ И ОТМЕНЫ
    c_record_or_ticket_stat_second constant number := 2;

    function cancel_record(
    p_ticket_id in number)
    return lazorenko_al.t_result;

    function write_to_records(
    p_patient_id in number,
    p_ticket_id in number,
    p_need_handle boolean)
    return lazorenko_al.t_result;
end;


create or replace package body lazorenko_al.pkg_write_or_cancel
as
    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number,
         p_need_handle boolean
    )
    return lazorenko_al.t_result as
        v_result lazorenko_al.t_result;

        attempt_to_insert_null_into_not_null exception;
        pragma exception_init (attempt_to_insert_null_into_not_null, -01400);

    begin
        if (p_need_handle) then
            begin
                insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
                values (default, lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first, p_patient_id, p_ticket_id);

                update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
                where t.ticket_id=p_ticket_id;

            exception
                when attempt_to_insert_null_into_not_null then

                    lazorenko_al.add_error_log(
        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm ||'","value":"'
                     ||'","patient_id":"' || p_patient_id ||'","ticket_id":"' || p_ticket_id
                     ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                     ||'"}'
                    );

                    dbms_output.put_line('запись внести невозможно - все поля должны быть заполнены');

                rollback;
                begin
                v_result:=lazorenko_al.t_result(result_value => 0);
                end;
                return v_result;

           end;

        else

            insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
            values (default, lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first, p_patient_id, p_ticket_id);

            update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
            where t.ticket_id=p_ticket_id;

        end if;

      v_result:=lazorenko_al.t_result(result_value => 1);

   return v_result;

    end;

    function cancel_record(
        p_ticket_id in number
    )
    return  lazorenko_al.t_result  as
        v_result lazorenko_al.t_result;

        no_ticket_found exception;
        pragma exception_init (no_ticket_found, -20500);

    begin

            update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first
            where t.ticket_id=p_ticket_id;

            update lazorenko_al.records r set r.record_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
            where r.ticket_id=p_ticket_id;

        if sql%notfound then
        raise_application_error(-20500,'указан неверный талон');
        end if;

        v_result:=lazorenko_al.t_result(result_value  => 1);

        return v_result;

    exception
        when no_ticket_found then

            lazorenko_al.add_error_log(
        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
                      ||'","value":"' || p_ticket_id
                      ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                      ||'"}'
            );

            dbms_output.put_line('указан неверный талон');

        v_result:=lazorenko_al.t_result(result_value  => 0);

        return v_result;

    end;

end;




----------------------------------------------------ИСПОЛЬЗОВАНИЕ-------------------------------------------------------

--ОБЕ ФУНКЦИИ МОГУТ ВОЗВРАЩАТЬ 1 В СЛУЧАЕ УСПЕХА И 0 В СЛУЧАЕ ПРОВАЛА

--ЗАПИСЬ
declare
    v_patient number :=null;
    v_ticket number :=33;
    v_result lazorenko_al.t_result;
begin
   v_result:=lazorenko_al.pkg_write_or_cancel.write_to_records(
        p_patient_id => v_patient,
        p_ticket_id => v_ticket,
        p_need_handle => true
    );
    commit;
   dbms_output.put_line(v_result.result_value);
end;

--ОТМЕНА ЗАПИСИ
declare
    v_ticket number :=null;
    v_result lazorenko_al.t_result;
begin
   v_result:=lazorenko_al.pkg_write_or_cancel.cancel_record(
        p_ticket_id => v_ticket
    );
    commit;
   dbms_output.put_line(v_result.result_value);
end;



------------------------------------------------------------------------------------------------------------------------
-------------------------------------CHECK-ФУНКЦИЯ С ОБРАБОТКОЙ И ЛОГИРОВАНИЕМ ОШИБОК-----------------------------------
------------------------------------------------------------------------------------------------------------------------


--ПРОВЕРКА НА УДАЛЕНИЕ ИЛИ ОТСУТСТВИЕ ДОКТОРА

create or replace function lazorenko_al.not_deleted_doctor_check(
    p_doctor_id in number
)
return boolean
as
    v_count number;

    e_deleted_doctor exception;
    pragma exception_init (e_deleted_doctor, -20390);

begin
    select count(*)
    into v_count
    from lazorenko_al.doctor d
    where d.doctor_id=p_doctor_id and d.dismiss_date is null;

        if v_count=0 then
         raise_application_error (-20390, 'доктор удалён или отсутствует в базе');
        end if;

return v_count>0;

    exception

        when e_deleted_doctor then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","doctor_id":"' || p_doctor_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('доктор удалён или отсутствует в базе');

return false;

end;


--ПРОВЕРКА НА УДАЛЕНИЕ ИЛИ ОТСУТСТВИЕ БОЛЬНИЦЫ

create or replace function lazorenko_al.not_deleted_hospital_check(
    p_hospital_id in number
)
return boolean
as
    v_count number;

    e_deleted_hospital exception;
    pragma exception_init (e_deleted_hospital, -20392);
begin
    select count(*)
    into v_count
    from lazorenko_al.hospital h
    where h.hospital_id=p_hospital_id and h.delete_from_the_sys is null;

        if v_count=0 then
        raise_application_error (-20392, 'больница удалена или отсутствует в базе');
        end if;

return v_count>0;

    exception

        when e_deleted_hospital then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('больница удалена или отсутствует в базе');

return false;

end;


--ПРОВЕРКА НА УДАЛЕНИЕ ИЛИ ОТСУТСТВИЕ СПЕЦИАЛЬНОСТИ

create or replace function lazorenko_al.not_deleted_spec_check(
    p_spec_id in number
)
return boolean
as
    v_count number;

    e_deleted_spec exception;
    pragma exception_init (e_deleted_spec, -20391);

begin
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id and s.delete_from_the_sys is null;

        if v_count=0 then
        raise_application_error (-20391, 'специальность удалена или отсутствует в базе');
        end if;

return v_count>0;

    exception

        when e_deleted_spec then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('специальность удалена или отсутствует в базе');

return false;

end;


--ПРОВЕРКА СООТВЕТСТВИЯ ВВОДИМЫХ ПРИ ЗАПИСИ ПАРАМЕТРОВ

create or replace function lazorenko_al.check_accordance_of_write_parameters(
    p_hospital_id in number,
    p_doctor_id in number,
    p_spec_id in number,
    p_ticket_id in number
)
return boolean
as
    v_count number;

    e_no_accordance exception;
    pragma exception_init (e_no_accordance, -20395);

begin
    select count(*)
    into v_count

    from lazorenko_al.hospital h inner join lazorenko_al.doctor d on h.hospital_id=d.hospital_id
    inner join lazorenko_al.doctor_spec ds on d.doctor_id=ds.doctor_id
    inner join lazorenko_al.specialisation s on ds.spec_id=s.spec_id
    inner join lazorenko_al.ticket t on d.doctor_id=t.doctor_id

    where h.hospital_id=p_hospital_id and d.doctor_id=p_doctor_id and s.spec_id=p_spec_id
          and t.ticket_id=p_ticket_id;

        if v_count=0 then
        raise_application_error (-20395, 'несоответствие вводимых для записи параметров');
        end if;

return v_count>0;

    exception

        when e_no_accordance then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id ||'","doctor_id":"' || p_doctor_id ||'","spec_id":"' || p_spec_id ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('несоответствие вводимых для записи параметров');

return false;

end;


--GET-ФУНКЦИЯ ТАЛОНА

create or replace function lazorenko_al.get_ticket_info_by_id(
    p_ticket_id number
)
return lazorenko_al.t_tickets
as
    v_ticket lazorenko_al.t_tickets;
begin
    select lazorenko_al.t_tickets(
    ticket_id => t.ticket_id,
    doctor_id => t.doctor_id,
    ticket_stat_id => t.ticket_stat_id,
    appointment_beg => t.appointment_beg,
    appointment_end => t.appointment_end
    )
    into v_ticket
    from lazorenko_al.ticket t
    where t.ticket_id = p_ticket_id;


return v_ticket;

    exception
        when no_data_found
        then lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('такого талона не существует');

return null;

end;


--GET-ФУНКЦИЯ ПАЦИЕНТА

create or replace function lazorenko_al.get_patient_info_by_id(
    p_patient_id number
)
return lazorenko_al.t_patient
as
    v_patient lazorenko_al.t_patient;

begin

    select lazorenko_al.t_patient(
        patient_id => p.patient_id,
        born_date => p.born_date,
        sex_id => p.sex_id
    )
    into v_patient
    from lazorenko_al.patient p
    where p.patient_id = p_patient_id;

return v_patient;

    exception
        when no_data_found then
        lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
        );

        dbms_output.put_line('данный пациент отсутствует в базе больницы');

return null;

end;

--ПРОВЕРКА ВОЗРАСТА

create or replace function lazorenko_al.check_age(
    p_patient_id in number,
    p_spec_id in number
)
return boolean
as
    v_patient lazorenko_al.t_patient;
    v_age number;
    v_count number;

    e_wrong_age exception;
    pragma exception_init (e_wrong_age, -20400);

begin

    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_age:=lazorenko_al.calculate_age_from_date(v_patient.born_date);

    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id = p_spec_id
          and (s.min_age <= v_age or s.min_age is null)
          and (s.max_age >= v_age or s.max_age is null);

    if v_count=0 then
       raise_application_error (-20400, 'возраст пациента не соответствует возрасту специальности');
    end if;

    return v_count>0;

    exception

        when e_wrong_age then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('возраст пациента не соответствует возрасту специальности');

    return false;

end;


--ПРОВЕПКА ПОЛА

create or replace function lazorenko_al.sex_check(
    p_patient_id in number,
    p_spec_id in number
)
return boolean
    as
    v_sex number;
    v_patient lazorenko_al.t_patient;
    v_count number;

    e_wrong_sex exception;
    pragma exception_init (e_wrong_sex, -20401);



begin

    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_sex:=v_patient.sex_id;
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id
          and (s.sex_id=v_sex or s.sex_id is null);

    if v_count=0 then
       raise_application_error (-20401, 'пол пациента не соответствует полу специальности');
    return v_count>0;
    end if;

return v_count>0;

    exception
        when e_wrong_sex then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('пол пациента не соответствует полу специальности');

return false;

end;


--ПРОВЕРКА НАЛИЧИЯ ОМС

create or replace function lazorenko_al.patient_doc_check(
    p_patient_id in number
)
return boolean
as
    v_count number;

    e_no_docs exception;
    pragma exception_init (e_no_docs, -20402);

begin
    select count(*)
    into v_count
    from lazorenko_al.documents_numbers dn
    where dn.patient_id=p_patient_id and dn.document_id=4
          and dn.value is not null;

    if v_count=0 then
       raise_application_error (-20402, 'отсутствуют данные по полису ОМС');
    return v_count>0;
    end if;

return v_count>0;

    exception
        when e_no_docs then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('отсутствуют данные по полису ОМС');

return false;

    end;


--ПРОВЕРКА ПОВТОРНОЙ ЗАПИСИ

create or replace function lazorenko_al.ticket_check(
    p_ticket_id in number,
    p_patient_id number
)
return boolean
as
    v_count number;

    e_record_exists exception;
    pragma exception_init (e_record_exists, -20403);

 begin

    select count(*)
    into v_count
    from lazorenko_al.records r right join lazorenko_al.ticket t on r.ticket_id=t.ticket_id

    where (r.ticket_id=p_ticket_id and r.record_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_2
                                   /*and (r.patient_id=p_patient_id or r.patient_id<>p_patient_id)*/)
          or (r.ticket_id=p_ticket_id and r.record_stat_id in (lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_1, lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_3)
          and r.patient_id<>p_patient_id)
          or (t.ticket_id=p_ticket_id and r.ticket_id is null and r.patient_id is null);

        if v_count=0 then
       raise_application_error (-20403, 'Вы уже записаны на данный талон');

return v_count>0;
    end if;

return v_count>0;

    exception
        when e_record_exists then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id||'","patient_id":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Вы уже записаны на данный талон');

return false;

end;


--ПРОВЕРКА СТАТУСА ТАЛОНА

create or replace function lazorenko_al.ticket_status_check(
    p_ticket_id in number,
    p_patient_id number
)
return boolean
as
    v_count number;

    e_wrong_status exception;
    pragma exception_init (e_wrong_status, -20404);

begin

    select count(*)
    into v_count
    from lazorenko_al.ticket t left join lazorenko_al.records r on r.ticket_id=t.ticket_id
    where (t.ticket_id=p_ticket_id and t.ticket_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_tick_stat_constant_1)
          or (t.ticket_id=p_ticket_id and t.ticket_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_tick_stat_constant_2
                                      and r.patient_id=p_patient_id);

        if v_count=0 then
        raise_application_error (-20404, 'Талон закрыт');

        return v_count>0;
        end if;

return v_count>0;

    exception
        when e_wrong_status then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Талон закрыт');

return false;

end;


--ПРОВЕРКА ВРЕМЕНИ ТАЛОНА

create or replace function lazorenko_al.time_check(
    p_ticket_id in number
)
return boolean
as
    v_appointment_beg lazorenko_al.t_tickets;
    v_count number;

    e_wrong_time exception;
    pragma exception_init (e_wrong_time, -20405);

begin

    v_appointment_beg:=lazorenko_al.get_ticket_info_by_id(p_ticket_id);

    select count(*)
    into v_count
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id and v_appointment_beg.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss');

        if v_count=0 then
        raise_application_error (-20405, 'Приём уже завершён');

        return v_count>0;
        end if;

 return v_count>0;

    exception
        when e_wrong_time then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Приём уже завершён');

return false;

end;



------------------------------------------------------------------------------------------------------------------------
-------ФУНКЦИЯ, ВКЛЮЧАЮЩАЯ В СЕБЯ РАЗЛИЧНЫЕ ПРОВЕРКИ ПЕРЕД ЗАПИСЬЮ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

create or replace function lazorenko_al.check_for_accept_with_exceptions(
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
    if lazorenko_al.check_accordance_of_write_parameters(
        p_hospital_id => p_hospital_id,
        p_doctor_id => p_doctor_id,
        p_spec_id => p_spec_id,
        p_ticket_id => p_ticket_id
        ) is null
    then v_result:=false;
    return v_result;
    end if;

    if lazorenko_al.get_patient_info_by_id(
        p_patient_id => p_patient_id
        ) is null
    then v_result:=false;
    return v_result;
    end if;

    if lazorenko_al.get_ticket_info_by_id(
        p_ticket_id => p_ticket_id
        ) is null
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.not_deleted_doctor_check(
        p_doctor_id => p_doctor_id
        ))
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.not_deleted_spec_check(
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.not_deleted_hospital_check(
        p_hospital_id => p_hospital_id
        ))
    then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.check_age(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.sex_check(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.patient_doc_check(
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.ticket_check(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.ticket_status_check(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.time_check(
        p_ticket_id => p_ticket_id
        ))
    then v_result:=false;
    end if;

    return v_result;
    end;

declare
    v_check number;
begin
    v_check:=sys.diutil.bool_to_int(lazorenko_al.check_for_accept_with_exceptions(33, 2, 3, 3, 4));

    dbms_output.put_line(v_check);
end;

------------------------------------------------------------------------------------------------------------------------
----------------------ИТОГВАЯ ФУНКЦИЯ ЗАПИСИ ПОСЛЕ ПРОВЕРКИ УСЛОВИЙ-----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

create or replace function lazorenko_al.accept_record_by_rules_with_exceptions(
    v_ticket_id number,
    v_patient_id number,
    v_spec_id number,
    v_doctor_id number,
    v_hospital_id number,
    v_need_handle boolean)
return number as
    v_result lazorenko_al.t_result;
    begin
        if (lazorenko_al.check_for_accept_with_exceptions(
            p_ticket_id => v_ticket_id,
            p_patient_id => v_patient_id,
            p_spec_id => v_spec_id,
            p_doctor_id => v_doctor_id,
            p_hospital_id => v_hospital_id))

        then v_result:=lazorenko_al.pkg_write_or_cancel.write_to_records(
            p_patient_id => v_patient_id,
            p_ticket_id => v_ticket_id,
            p_need_handle => v_need_handle);

        else v_result:=lazorenko_al.t_result(result_value =>0);

        end if;

    return v_result.result_value;
    end;

--ПРИМЕНЕНИЕ ФУНКЦИИ

declare
    v_result lazorenko_al.t_result;
begin
    v_result:=lazorenko_al.t_result(result_value => lazorenko_al.accept_record_by_rules_with_exceptions(
    33, 1, 3, 3, 4, true));

    commit;
    dbms_output.put_line(v_result.result_value);
end;







------------------------------------------------------------------------------------------------------------------------
---------------------------------ФУНКЦИИ ПРОВЕРКИ УСЛОВИЙ, ОТМЕНЫ ЗАПИСИ И ИТОГОВАЯ ФУНКЦИЯ-----------------------------
-----------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ПРОВЕРКИ ВРЕМЕННЫХ ОГРАНИЧЕНИЙ

create or replace function lazorenko_al.hospital_time_check(
    p_hospital_id in number
)
return boolean
as
    v_count number;

    e_bad_time exception;
    pragma exception_init (e_bad_time, -20300);

begin
    select count(*)
    into v_count
    from lazorenko_al.work_time w
    where w.end_time>(TO_CHAR(sysdate+1/12, 'hh24:mi'))
    and w.day in (to_char(sysdate, 'd')) and w.hospital_id=p_hospital_id;

        if v_count=0 then
        raise_application_error (-20300, 'ошибка - запись можжно отменить не позднее, чем за 2 часа до закрытия больницы');
        end if;

return v_count>0;

    exception

        when e_bad_time then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('ошибка - запись можжно отменить не позднее, чем за 2 часа до закрытия больницы');

return false;

end;



--ФУНКЦИЯ ПРОВЕРКИ ВРЕМЕНИ ПРИЁМА

create or replace function lazorenko_al.ticket_time_check(
    p_ticket_id in number
)
return boolean
as
    v_count number;

    e_old_ticket exception;
    pragma exception_init (e_old_ticket, -20301);

begin

    select count(*)
    into v_count
    from lazorenko_al.ticket t
    where to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')>sysdate
          and t.ticket_id=p_ticket_id;

        if v_count=0 then
        raise_application_error (-20301, 'невозможно оменить устаревший талон');
        end if;

return v_count>0;

    exception

        when e_old_ticket then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('невозможно оменить устаревший талон');

return false;

end;


--ФУНКЦИЯ ПРОВЕРКИ ВВОДИМЫХ ПРИ ОТМЕНЕ ЗАПИСИ ПАРАМЕТРОВ

create or replace function lazorenko_al.check_accordance_for_cancel(
    p_patient_id in number,
    p_ticket_id in number
    )
return boolean
    as
    v_count number;

    e_bad_accordance exception;
    pragma exception_init (e_bad_accordance, -20302);

begin

    select count(*)
    into v_count
    from lazorenko_al.records r
    where r.patient_id=p_patient_id and r.ticket_id=p_ticket_id and r.record_stat_id=1;

        if v_count=0 then
        raise_application_error (-20302, 'у вас отсутствует действующий талон с подобными параметрами или талон закрыт');
        end if;

return v_count>0;

    exception

        when e_bad_accordance then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('у вас отсутствует действующий талон с подобными параметрами или талон закрыт');

return false;

end;


--ФУНКЦИЯ ПРОВЕРКИ УСЛОВИЙ ПЕРЕД ОТМЕНОЙ

create or replace function lazorenko_al.check_cancel(
    p_hospital_id in number,
    p_ticket_id in number,
    p_patient_id in number
)
return boolean
as
    v_result boolean := true;
begin
    if (not lazorenko_al.check_accordance_for_cancel(
    p_patient_id => p_patient_id,
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
    return v_result;
    end if;

    if (not lazorenko_al.ticket_time_check(
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
    end if;

    if (not lazorenko_al.hospital_time_check(
    p_hospital_id => p_hospital_id
    )) then v_result:=false;
    end if;

return v_result;
end;


--ОТМЕНА ЗАПИСИ ПО УСЛОВИЯМ


create or replace function lazorenko_al.cancel_record_by_rules(
    v_ticket_id number,
    v_patient_id number,
    v_hospital_id number
)
return  number
as
    v_result lazorenko_al.t_result;
begin
    if (lazorenko_al.check_cancel(
    p_ticket_id => v_ticket_id,
    p_patient_id => v_patient_id,
    p_hospital_id => v_hospital_id))
    then v_result:=lazorenko_al.pkg_write_or_cancel.cancel_record(p_ticket_id => v_ticket_id);


        else v_result:=lazorenko_al.t_result(result_value =>0);

    end if;

return v_result.result_value;

end;


--ПРИМЕНЕНИЕ МЕТОДА ОТМЕНЫ ЗАПИСИ

declare
    v_result lazorenko_al.t_result;
begin
    v_result:=lazorenko_al.t_result(result_value => lazorenko_al.cancel_record_by_rules(
    33, 1, 4));

    commit;
    dbms_output.put_line(v_result.result_value);

end;

