------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------ЗАДАНИЕ №2---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--НОВЫЙ ВАРИАНТ
--ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ - ДАННЫЕ ПАЦИЕНТА
create or replace function lazorenko_al.get_patient_info_by_id(
    p_patient_id number
)
return lazorenko_al.patient%rowtype
as
    v_patient lazorenko_al.patient%rowtype;
begin
    select *
    into v_patient
    from lazorenko_al.patient p
    where p.patient_id = p_patient_id;

    return v_patient;
end;

--ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ - РАСЧЁТ ВОЗРАСТА
create or replace function lazorenko_al.calculate_age_from_date(
    p_date date
)
return number
as
    v_age number;
begin
    select months_between(sysdate, p_date)/12
    into v_age
    from dual;

    return v_age;
end;

--ПРОВЕРКА ВОЗРАСТА
create or replace function lazorenko_al.check_age(p_patient_id in number, p_spec_id in number)
return boolean
as
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

declare
   v_valid_patient_age number;
begin
    v_valid_patient_age :=sys.diutil.bool_to_int(lazorenko_al.check_age(2, 3));
    DBMS_OUTPUT.PUT_LINE( v_valid_patient_age);
end;


--ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ - ОПРЕДЕЛЕНИЕ ПОЛА ПАЦИЕНТА
create or replace function lazorenko_al.sex_determine(
    p_patient_id number
)
return number
as
    v_sex number;
begin
    select p.sex_id
    into v_sex
    from lazorenko_al.patient p
    where p.patient_id=p_patient_id;

    return v_sex;
end;


--ПРОВЕРКА ПОЛА

create or replace function lazorenko_al.sex_check(p_patient_id in number, p_spec_id in number)
return boolean
as
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

declare
   v_valid_sex number;
begin
    v_valid_sex :=sys.diutil.bool_to_int(lazorenko_al.sex_check(2, 2));
    DBMS_OUTPUT.PUT_LINE( v_valid_sex);
end;

--ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ - ДАННЫЕ ТАЛОНА
create or replace function lazorenko_al.get_ticket_info_by_id(
    p_ticket_id number
)
return lazorenko_al.ticket%rowtype
as
    v_ticket lazorenko_al.ticket%rowtype;
begin
    select *
    into v_ticket
    from lazorenko_al.ticket t
    where t.ticket_id = p_ticket_id;

    return v_ticket;
end;

--ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ - ОПРЕДЕЛЕНИЕ СТАТУСА ТАЛОНА
create or replace function lazorenko_al.ticket_status_determine(
    p_ticket_id number
)
return number
as
    v_ticket_status number;
begin
    select t.ticket_stat_id
    into v_ticket_status
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id;

    return v_ticket_status;
end;

--ПРОВЕРКА СТАТУСА ТАЛОНА
create or replace function lazorenko_al.ticket_status_check(p_ticket_id in number)
return boolean as
    v_ticket_status number;
    v_count number;
begin
    v_ticket_status:=lazorenko_al.ticket_status_determine(p_ticket_id);
    select count(*)
    into v_count
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id and t.ticket_stat_id=1;
return v_count>0;
end;

declare
   v_valid_ticket_stat number;
begin
    v_valid_ticket_stat :=sys.diutil.bool_to_int(lazorenko_al.ticket_status_check(32));
    DBMS_OUTPUT.PUT_LINE( v_valid_ticket_stat);
end;

--ПРОВЕРКА ПОВТОРНОЙ ЗАПИСИ
create or replace function lazorenko_al.ticket_check(p_ticket_id in number)
return boolean as
v_count number;
begin
    select count(*)
    into v_count
    from lazorenko_al.records r right join lazorenko_al.ticket t on r.ticket_id=t.ticket_id
    where (r.ticket_id=p_ticket_id and r.record_stat_id=2)
          or (t.ticket_id=p_ticket_id and r.ticket_id is null);
return v_count>0;
end;

declare
   v_valid_ticket number;
begin
    v_valid_ticket :=sys.diutil.bool_to_int(lazorenko_al.ticket_check(32));
    DBMS_OUTPUT.PUT_LINE( v_valid_ticket);
end;

--ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ - ОПРЕДЕЛЕНИЕ ВРЕМЕНИ НАЧАЛА ТАЛОНА
create or replace function lazorenko_al.appointment_beg_determine(
    p_ticket_id number
)
return char
as
    v_appointment_beg varchar2(100);
begin
    select t.appointment_beg
    into v_appointment_beg
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id;

    return v_appointment_beg;
end;
drop function lazorenko_al.appointment_beg_determine;

--ПРОВЕРКА ВРЕМЕНИ
create or replace function lazorenko_al.time_check(p_ticket_id in number)
return boolean
as
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

declare
   valid_time number;
begin
    valid_time :=sys.diutil.bool_to_int(lazorenko_al.time_check(33));
    DBMS_OUTPUT.PUT_LINE( valid_time);
end;

--ПРОВЕРКА НА УДАЛЕНИЕ ВРАЧА, БОЛЬНИЦЫ, СПЕЦИАЛЬНОСТИ
create or replace function lazorenko_al.not_deleted_check(p_doctor_id in number)
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

declare
   valid_doctor_hospital_spec number;
begin
    valid_doctor_hospital_spec :=sys.diutil.bool_to_int(lazorenko_al.not_deleted_check(3));
    DBMS_OUTPUT.PUT_LINE( valid_doctor_hospital_spec);
end;


--ПРОВЕРКА НАЛИЧИЯ ПОЛИСА
create or replace function lazorenko_al.patient_doc_check(p_patient_id in number)
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

declare
   valid_docs number;
begin
    valid_docs :=sys.diutil.bool_to_int(lazorenko_al.patient_doc_check(1));
    DBMS_OUTPUT.PUT_LINE( valid_docs);
end;

--ДОПОЛНИТЕЛЬНАЯ ПРОВЕРКА НА СООТВЕТСТВИЕ ВВОДИМЫХ БОЛЬНИЦ, ДОКТОРОВ, СПЕЦИАЛЬНОСТЕЙ И ТАЛОНОВ

create or replace function lazorenko_al.check_IN_parameters(p_hospital_id in number, p_doctor_id in number,
p_spec_id in number, p_ticket_id in number)
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

declare
   valid_parameters number;
begin
    valid_parameters :=sys.diutil.bool_to_int(lazorenko_al.check_IN_parameters(4, 3, 2, 33));
    DBMS_OUTPUT.PUT_LINE( valid_parameters);
end;