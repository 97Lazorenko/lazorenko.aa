------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------ЗАДАНИЕ №2---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПРОВЕРКА ВОЗРАСТА

create or replace function lazorenko_al.check_age(p_patient_id in number, p_doctor_id in number)
return number
as
v_valid_patient_age number;
begin
select case
     when l.age_group_id=ags.age_group_id and p_doctor_id=d.doctor_id then 1
     else 0
     end as valid_age
into v_valid_patient_age
from (select case
when (sysdate-p.born_date)/365 between 0 and 2 then 1
when (sysdate-p.born_date)/365 between 3 and 17 then 2
when (sysdate-p.born_date)/365 between 18 and 59 then 3
when (sysdate-p.born_date)/365 between 60 and 100 then 4
else 0 end as age_group_id
from lazorenko_al.patient p where p.patient_id=p_patient_id) l
left join lazorenko_al.age_spec ags on l.age_group_id=ags.age_group_id
inner join lazorenko_al.specialisation s on s.spec_id=ags.spec_id
inner join lazorenko_al.doctor_spec ds on s.spec_id=ds.spec_id
inner join lazorenko_al.doctor d on ds.doctor_id=d.doctor_id
where rownum=1
order by valid_age desc;
return v_valid_patient_age;
end;

declare
   v_valid_patient_age number;
begin
    v_valid_patient_age :=lazorenko_al.check_age(7, 3);
    DBMS_OUTPUT.PUT_LINE( v_valid_patient_age);
end;


--ПРОВЕРКА ПОЛА

create or replace function lazorenko_al.sex_check(p_patient_id in number, p_spec_id in number)
return number as
valid_sex number;
begin
    select
       case when sx.sex_id is not null and s.spec_id=p_spec_id then 1
       else 0
       end as valid_sex
    into valid_sex
from (select sex_id from lazorenko_al.patient where patient_id=p_patient_id) p left join lazorenko_al.SEX_SPEC sx on p.sex_id=sx.sex_id
right join lazorenko_al.specialisation s on s.spec_id=sx.spec_id
where s.spec_id=p_spec_id
order by valid_sex desc;
    return valid_sex;
end;

declare
   valid_sex number;
begin
    valid_sex :=lazorenko_al.sex_check(7, 5);
    DBMS_OUTPUT.PUT_LINE( valid_sex);
end;

--ПРОВЕРКА СТАТУСА ТАЛОНА
create or replace function lazorenko_al.ticket_status_check(p_ticket_id in number)
return number as
valid_ticket_status number;
begin
    select
           case
               when t.ticket_stat_id=1 then 1
               when t.ticket_stat_id=2 then 0
           end
    into valid_ticket_status
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id;
return valid_ticket_status;
end;

declare
   valid_ticket_status number;
begin
    valid_ticket_status :=lazorenko_al.ticket_status_check(33);
    DBMS_OUTPUT.PUT_LINE( valid_ticket_status);
end;

--ПРОВЕРКА ПОВТОРНОЙ ЗАПИСИ
create or replace function lazorenko_al.ticket_check(p_ticket_id in number)
return number as
valid_ticket number;
begin
    select
           case
               when r.ticket_id is null then 1
               when t.ticket_id=r.ticket_id and r.record_stat_id=2 then 1
               when r.ticket_id=t.ticket_id and r.record_stat_id in (1, 3) then 0
           end
    into valid_ticket
    from lazorenko_al.ticket t left join lazorenko_al.records r on t.ticket_id=r.ticket_id
    where t.ticket_id=p_ticket_id;
return valid_ticket;
end;

declare
   valid_ticket number;
begin
    valid_ticket :=lazorenko_al.ticket_check(33);
    DBMS_OUTPUT.PUT_LINE( valid_ticket);
end;

--ПРОВЕРКА ВРЕМЕНИ
create or replace function lazorenko_al.time_check(p_ticket_id in number)
return number as
valid_time number;
begin
    select case
        when t.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') then 1
        when t.appointment_beg<to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') then 0
        end  as valid_time
    into valid_time
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id;
return valid_time;
end;

declare
   valid_time number;
begin
    valid_time :=lazorenko_al.time_check(33);
    DBMS_OUTPUT.PUT_LINE( valid_time);
end;

--ПРОВЕРКА НА УДАЛЕНИЕ (БОЛЬНИЦА)
create or replace function lazorenko_al.hospital_check(p_hospital_id in number)
return number as
valid_hospital_not_deleted number;
begin
    select case
        when h.hospital_id=p_hospital_id and h.delete_from_the_sys is null then 1
        when h.hospital_id=p_hospital_id and h.delete_from_the_sys is not null then 0
        end
    into valid_hospital_not_deleted
    from lazorenko_al.hospital h
    where h.hospital_id=p_hospital_id;
return valid_hospital_not_deleted;
end;

declare
   valid_hospital_not_deleted number;
begin
    valid_hospital_not_deleted :=lazorenko_al.hospital_check(11);
    DBMS_OUTPUT.PUT_LINE( valid_hospital_not_deleted);
end;

--ПРОВЕРКА НА УДАЛЕНИЕ (ВРАЧ)
create or replace function lazorenko_al.doctor_check(p_doctor_id in number)
return number as
valid_doctor_not_deleted number;
begin
    select case
        when d.doctor_id=p_doctor_id and d.dismiss_date is null then 1
        when d.doctor_id=p_doctor_id and d.dismiss_date is not null then 0
        end
    into valid_doctor_not_deleted
    from lazorenko_al.doctor d
    where d.doctor_id=p_doctor_id;
return valid_doctor_not_deleted;
end;

declare
   valid_doctor_not_deleted number;
begin
    valid_doctor_not_deleted :=lazorenko_al.doctor_check(31);
    DBMS_OUTPUT.PUT_LINE( valid_doctor_not_deleted);
end;

--ПРОВЕРКА НА УДАЛЕНИЕ (СПЕЦИАЛЬНОСТЬ)

create or replace function lazorenko_al.spec_check(p_spec_id in number)
return number as
valid_spec_not_deleted number;
begin
    select case
        when s.spec_id=p_spec_id and s.delete_from_the_sys is null then 1
        when s.spec_id=p_spec_id and s.delete_from_the_sys is not null then 0
        end
    into valid_spec_not_deleted
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id;
return valid_spec_not_deleted;
end;

declare
   valid_spec_not_deleted number;
begin
    valid_spec_not_deleted :=lazorenko_al.spec_check(2);
    DBMS_OUTPUT.PUT_LINE( valid_spec_not_deleted);
end;

--ПРОВЕРКА НАЛИЧИЯ ПОЛИСА
create or replace function lazorenko_al.patient_doc_check(p_patient_id in number)
return number as
valid_patient_doc number;
begin
    select case
        when ds.patient_id=p_patient_id and ds.value is not null then 1
        when ds.patient_id=p_patient_id and ds.value is null then 0
        end
    into valid_patient_doc
    from lazorenko_al.documents_numbers ds
    where ds.patient_id=p_patient_id and ds.document_id=4;
return valid_patient_doc;
end;

declare
   valid_patient_doc number;
begin
    valid_patient_doc :=lazorenko_al.patient_doc_check(1);
    DBMS_OUTPUT.PUT_LINE(valid_patient_doc);
end;

--ДОПОЛНИТЕЛЬНАЯ ПРОВЕРКА НА СООТВЕТСТВИЕ ВВОДИМЫХ БОЛЬНИЦ, ДОКТОРОВ, СПЕЦИАЛЬНОСТЕЙ И ТАЛОНОВ НА ЗАПИСЬ

create or replace function lazorenko_al.check_IN_parameters(p_hospital_id in number, p_doctor_id in number,
p_spec_id in number, p_ticket_id in number)
return number as
valid_IN_parameters number;
begin
select count(*)
into valid_IN_parameters
from lazorenko_al.hospital h inner join lazorenko_al.doctor d on h.hospital_id=d.hospital_id
inner join lazorenko_al.doctor_spec ds on d.doctor_id=ds.doctor_id
inner join lazorenko_al.specialisation s on ds.spec_id=s.spec_id
inner join lazorenko_al.ticket t on d.doctor_id=t.doctor_id
where h.hospital_id=p_hospital_id and d.doctor_id=p_doctor_id and s.spec_id=p_spec_id
and t.ticket_id=p_ticket_id;
return valid_IN_parameters;
end;

declare
   valid_IN_parameters number;
begin
    valid_IN_parameters :=lazorenko_al.check_IN_parameters(5,3,2,33);
    DBMS_OUTPUT.PUT_LINE(valid_IN_parameters);
end;