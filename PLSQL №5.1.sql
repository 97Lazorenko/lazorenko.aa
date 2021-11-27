------------------------------------------------------------------------------------------------------------------------
-------------------------------------------ЗАПИСЬ И ОТМЕНА ЗАПИСИ-------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПАКЕТ С ФУНКЦИЕЙ ЗАПИСИ И ОТМЕНЫ ЗАПИСИ
create or replace package lazorenko_al.pkg_write_or_cancel
as
    c_constant_1 constant number := 1;
                                          --КОНСТАНТЫ БУДУТ ИСПОЛЬЗОВАНЫ В ФУНКЦИЯХ ЗАПИСИ И ОТМЕНЫ
    c_constant_2 constant number := 2;

    v_record_id lazorenko_al.records.record_id%type;

    v_record_id number;

    function cancel_record(
    p_ticket_id in number)
    return number;

    function write_to_records(
    p_patient_id in number,
    p_ticket_id in number)
    return number;
end;

--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_write_or_cancel
as
    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number
    )
    return number as
    v_record_id number;

    begin
    insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
    values (default, lazorenko_al.pkg_const_for_write_or_cancel.c_constant_1, p_patient_id, p_ticket_id)
    returning record_id into v_record_id;

    update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_const_for_write_or_cancel.c_constant_2 where t.ticket_id=p_ticket_id;

    commit;

    return v_record_id;
    end;

    function cancel_record(
    p_ticket_id in number)
    return  number  as
    v_record_id number;

    begin
    update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_const_for_write_or_cancel.c_constant_1 where t.ticket_id=p_ticket_id;

    update lazorenko_al.records r set r.record_stat_id=lazorenko_al.pkg_const_for_write_or_cancel.c_constant_2 where r.ticket_id=p_ticket_id;

    commit;

    return v_record_id;
    end;

end;

--ЕГО ПРОБА

declare
v_record number;
begin
v_record:=lazorenko_al.pkg_write_or_cancel.write_to_records(1,33); --ЗАПИСЬ
end;

declare
v_record number;
begin
v_record:=lazorenko_al.pkg_write_or_cancel.cancel_record(88);  --ОТМЕНА ЗАПИСИ
end;

------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------ПАЦИЕНТ-------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПАКЕТ С ФУНКЦИЯМИ ПРОВЕРКИ УСЛОВИЙ ДЛЯ ПАЦТЕНТА (ПОЛ, ВОЗРАСТ, ДОКУМЕНТЫ ПАЦИЕНТА)

create or replace package lazorenko_al.pkg_patient_parameters_check
as

    function get_patient_info_by_id(
    p_patient_id number)
    return lazorenko_al.patient%rowtype;

    function calculate_age_from_date(
    p_date date)
    return number;

   /* function sex_determine(
    p_patient_id number)
    return number; */

    function sex_check(
    p_patient_id in number,
    p_spec_id in number)
    return boolean;

    function check_age(
    p_patient_id in number,
    p_spec_id in number)
    return boolean;

    function patient_doc_check(
    p_patient_id in number)
    return boolean;

end;

--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_patient_parameters_check
as
    function get_patient_info_by_id(
    p_patient_id number)
    return lazorenko_al.patient%rowtype as
    v_patient lazorenko_al.patient%rowtype;
    begin
    select *
    into v_patient
    from lazorenko_al.patient p
    where p.patient_id = p_patient_id;
    return v_patient;
   exception
                when no_data_found then /* lazorenko_al.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit,
                '{"error":"' || sqlerrm
                ||'","value":"' || p_patient_id
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
        ); */

        dbms_output.put_line('данный пациент отсутствует в базе больницы');
    return v_patient;
    end;

    function calculate_age_from_date(
    p_date date)
    return number as
    v_age number;
    begin
    select months_between(sysdate, p_date)/12
    into v_age
    from dual;

    return v_age;
    end;

   /* function sex_determine(
    p_patient_id number)
    return number as
    v_sex number;
    begin
    select p.sex_id
    into v_sex
    from lazorenko_al.patient p
    where p.patient_id=p_patient_id;
    return v_sex;
    /*exception
        when no_data_found then dbms_output.put_line('данный пациент отсутствует в базе больницы');
    return v_sex;
    end;*/

    function sex_check(
    p_patient_id in number,
    p_spec_id in number)
    return boolean as
    v_sex number;
    v_patient lazorenko_al.patient%rowtype;
    v_count number;
    begin
    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_sex:=v_patient.sex_id;
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id and (s.sex_id=v_sex or s.sex_id is null);
    return v_count>0;
    exception
        when no_data_found then dbms_output.put_line('данный пациент отсутствует в базе больницы');
    return v_count>0;
    end;

    function check_age(
    p_patient_id in number,
    p_spec_id in number)
    return boolean as
    v_patient lazorenko_al.patient%rowtype;
    v_age number;
    v_count number;
    begin
    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_age:=lazorenko_al.calculate_age_from_date(v_patient.born_date);
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id = p_spec_id
          and (s.min_age <= v_age or s.min_age is null)
          and (s.max_age >= v_age or s.max_age is null);
    return v_count>0;
    exception
        when no_data_found then dbms_output.put_line('данный пациент отсутствует в базе больницы');
    return v_count>0;
    end;

    function patient_doc_check(
    p_patient_id in number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count
    from lazorenko_al.documents_numbers dn
    where dn.patient_id=p_patient_id and dn.document_id=4
          and dn.value is not null;

    return v_count>0;
    end;

end;

--ЕГО ПРОБА

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_patient_parameters_check.check_age(
    9,2)); --ПРОВЕРКА ВОЗРАСТА
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_patient_parameters_check.sex_check(
    9,5)); --ПРОВЕРКА ПОЛА
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_patient_parameters_check.patient_doc_check(
    9)); --ПРОВЕРКА НАЛИЧИЯ ПОЛИСА
dbms_output.put_line(v_check);
end;

------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------ТАЛОН----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--ПАКЕТ С ФУНКЦИЯМИ ПРОВЕРКИ УСЛОВИЙ ДЛЯ ТАЛОНА (ПОВТОРНАЯ ЗАПИСЬ, СТАТУС, ВРЕМЯ НАЧАЛА)

create or replace package lazorenko_al.pkg_ticket_parameters_check
as
    c_rec_stat_constant_1 constant number := 1;
    c_rec_stat_constant_2 constant number := 2;
    c_rec_stat_constant_3 constant number := 3;
    c_tick_stat_constant_1 constant number := 1;
    c_tick_stat_constant_2 constant number := 2;

    function ticket_check(
    p_ticket_id in number,
    p_patient_id number)
    return boolean;

    function ticket_status_check(
    p_ticket_id in number,
    p_patient_id number)
    return boolean;

    function time_check(
    p_ticket_id in number)
    return boolean;

end;

--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_ticket_parameters_check
as
    function ticket_check(
    p_ticket_id in number,
    p_patient_id number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count
    from lazorenko_al.records r right join lazorenko_al.ticket t on r.ticket_id=t.ticket_id

    where (r.ticket_id=p_ticket_id and r.record_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_2
                                   /*and (r.patient_id=p_patient_id or r.patient_id<>p_patient_id)*/)
          or (r.ticket_id=p_ticket_id and r.record_stat_id in (lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_1, lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_3)
          and r.patient_id<>p_patient_id)
          or (t.ticket_id=p_ticket_id and r.ticket_id is null and r.patient_id is null);

    return v_count>0;
    end;

    function ticket_status_check(
    p_ticket_id in number,
    p_patient_id number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count
    from lazorenko_al.ticket t left join lazorenko_al.records r on r.ticket_id=t.ticket_id
    where (t.ticket_id=p_ticket_id and t.ticket_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_tick_stat_constant_1)
          or (t.ticket_id=p_ticket_id and t.ticket_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_tick_stat_constant_2
                                      and r.patient_id=p_patient_id);

    return v_count>0;
    end;

    function time_check(
    p_ticket_id in number)
    return boolean as
    v_appointment_beg varchar2(100);
    v_count number;
    begin
    v_appointment_beg:=lazorenko_al.appointment_beg_determine(p_ticket_id);
    select count(*)
    into v_count
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id and v_appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss');
return v_count>0;
end;

end;

--ЕГО ПРОБА

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_parameters_check.ticket_check(
    33, 99)); --ПРОВЕРКА ПОВТОРНОЙ ЗАПИСИ
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_parameters_check.ticket_status_check(
    33,5)); --ПРОВЕРКА СТАТУС ТАЛОНА
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_parameters_check.time_check(
    33)); --ПРОВЕРКА ВРЕМЕНИ НАЧАЛА
dbms_output.put_line(v_check);
end;

------------------------------------------------------------------------------------------------------------------------
-------------------------------------------ВВОДИМЫЕ ПАРАМЕТРЫ-----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПАКЕТ С ФУНКЦИЯМИ ПРОВЕРКИ ВВОДИМЫХ ПАРАМЕТРОВ ДЛЯ ЗАПИСИ И ОТМЕНЫ

create or replace package lazorenko_al.pkg_parameters_check
as
    c_rec_stat_constant_1 constant number := 1;

    function check_IN_parameters(
    p_hospital_id in number,
    p_doctor_id in number,
    p_spec_id in number,
    p_ticket_id in number)
    return boolean;

    function check_IN_parameters2(
    p_patient_id in number,
    p_ticket_id in number)
    return boolean;

end;

--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_parameters_check
as

    function check_IN_parameters(
    p_hospital_id in number,
    p_doctor_id in number,
    p_spec_id in number,
    p_ticket_id in number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count

    from lazorenko_al.hospital h inner join lazorenko_al.doctor d on h.hospital_id=d.hospital_id
    inner join lazorenko_al.doctor_spec ds on d.doctor_id=ds.doctor_id
    inner join lazorenko_al.specialisation s on ds.spec_id=s.spec_id
    inner join lazorenko_al.ticket t on d.doctor_id=t.doctor_id

    where h.hospital_id=p_hospital_id and d.doctor_id=p_doctor_id and s.spec_id=p_spec_id
          and t.ticket_id=p_ticket_id;

    return v_count>0;
    end;

    function check_IN_parameters2(
    p_patient_id in number,
    p_ticket_id in number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count
    from lazorenko_al.records r
    where r.patient_id=p_patient_id and r.ticket_id=p_ticket_id
    and r.record_stat_id=lazorenko_al.pkg_parameters_check.c_rec_stat_constant_1;

    return v_count>0;
    end;

end;

--ЕГО ПРОБА

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_parameters_check.check_IN_parameters(
    5, 3, 2, 33)); --ПРОВЕРКА ВВОДИМЫХ ДЛЯ ЗАПИСИ ПАРАМЕТРОВ (ИХ СООТВЕТСТВИЯ ДРУГ ДРУГУ)
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_parameters_check.check_IN_parameters2(
    2,31)); --ПРОВЕРКА ВВОДИМЫХ ДЛЯ ОТМЕНЕ ЗАПИСИ ПАРАМЕТРОВ (ИХ СООТВЕТСТВИЯ ДРУГ ДРУГУ)
dbms_output.put_line(v_check);
end;


------------------------------------------------------------------------------------------------------------------------
-------------------------------------------УДАЛЕНИЕ И ВРЕМЕННЫЕ ОГРАНИЧЕНИЯ---------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПАКЕТ С ФУНКЦИЯМИ ПРОВЕРКИ НА УДАЛЕНИЕ ВРАЧЕЙ, СПЕЦИАЛЬНОСТЕЙ, БОЛЬНИЦ, И ВРЕМЕНИ ДО ЗАКРЫТИЯ

create or replace package lazorenko_al.pkg_delete_and_time_check
as
    c_time_before_close_constant constant number := 1/12;


    function hospital_time_check(
    p_hospital_id in number)
    return boolean;

    function not_deleted_check(
    p_doctor_id in number)
    return boolean;

end;


--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_delete_and_time_check
as
    function hospital_time_check(
    p_hospital_id in number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count
    from lazorenko_al.work_time w
    where w.end_time>(TO_CHAR(sysdate+lazorenko_al.pkg_delete_and_time_check.c_time_before_close_constant, 'hh24:mi'))
    and w.day in (to_char(sysdate, 'd')) and w.hospital_id=p_hospital_id;

    return v_count>0;
    end;

    function not_deleted_check(
    p_doctor_id in number)
    return boolean as
    v_count number;
    begin
    select count(*)
    into v_count

    from lazorenko_al.doctor d inner join lazorenko_al.hospital h on d.hospital_id=h.hospital_id
    inner join lazorenko_al.doctor_spec ds on d.doctor_id=ds.doctor_id
    inner join lazorenko_al.specialisation s on ds.spec_id=s.spec_id

    where d.doctor_id=p_doctor_id and d.dismiss_date is null and h.delete_from_the_sys is null
          and s.delete_from_the_sys is null;

    return v_count>0;
    end;

end;

--ЕГО ПРОБА

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_delete_and_time_check.hospital_time_check(
    6)); --ПРОВЕРКА ВРЕМЕНИ ДО ЗАКРЫТИЯ
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_delete_and_time_check.not_deleted_check(
    1)); --ПРОВЕРКА НА УДАЛЕНИЕ ВРАЧА, СПЕЦИАЛЬНОЙСТИ, БОЛЬНИЦЫ
dbms_output.put_line(v_check);
end;

