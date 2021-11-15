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
    return lazorenko_al.records.record_id%type;
end;

--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_write_or_cancel
as
    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number
    )
    return lazorenko_al.records.record_id%type as
    v_record_id lazorenko_al.records.record_id%type;

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
v_record:=lazorenko_al.pkg_write_or_cancel.cancel_record(33);  --ОТМЕНА ЗАПИСИ
end;


--ПАКЕТ С ФУНКЦИЯМИ ПРОВЕРКИ УСЛОВИЙ (СООТВЕТСТВИЕ ПОЛА И ВОЗРАСТА СПЕЦИАЛЬНОСТИ)

create or replace package lazorenko_al.pkg_patient_parameters_check
as
    v_patient lazorenko_al.patient%rowtype;
    v_count number;
    v_age number;

    function get_patient_info_by_id(
    p_patient_id number)
    return lazorenko_al.patient%rowtype;

    function calculate_age_from_date(
    p_date date)
    return number;

    function sex_determine(
    p_patient_id number)
    return number;

    function sex_check(
    p_patient_id in number,
    p_spec_id in number)
    return boolean;

    function check_age(
    p_patient_id in number,
    p_spec_id in number)
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

    function sex_determine(
    p_patient_id number)
    return number as
    v_sex number;
    begin
    select p.sex_id
    into v_sex
    from lazorenko_al.patient p
    where p.patient_id=p_patient_id;

    return v_sex;
    end;

    function sex_check(
    p_patient_id in number,
    p_spec_id in number)
    return boolean as
    v_sex number;
    v_count number;
    begin
    v_sex:=lazorenko_al.sex_determine(p_patient_id);
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id and (s.sex_id=v_sex or s.sex_id is null);

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
    end;

end;

--ЕГО ПРОБА

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_patient_parameters_check.check_age(7,2));
dbms_output.put_line(v_check);
end;

declare
v_check number;
begin
v_check:=sys.diutil.bool_to_int(lazorenko_al.pkg_patient_parameters_check.sex_check(2,6));
dbms_output.put_line(v_check);
end;