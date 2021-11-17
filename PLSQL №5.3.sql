
------------------------------------------------------------------------------------------------------------------------
----------------------------------------------ПАКЕТ 1-------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ДЛЯ РАСЧЁТА СРЕДНЕГО ВОЗРАСТА ПАЦИЕНТОВ ОПРЕДЕЛЁННОГО ПОЛА, ОТНОСЯЩИХСЯ К ОПРЕДЕЛЁННОМУ УЧАСТКУ

create or replace function lazorenko_al.avg_age(
    p_zone_id number
)
return number as v_avg_age number;
begin
    select round(avg((sysdate-p.born_date)/365), 1)
    into v_avg_age
    from lazorenko_al.patient p
    where p.zone_id=p_zone_id and p.sex_id=1;
return v_avg_age;
end;


--ПАКЕТ 1

create or replace package lazorenko_al.pkg_1
as
    c_zone_constant constant number:=1;     -----------------------------------------------ПРИМЕНЯЕТСЯ В ПАКЕТЕ 2

    function avg_age(
    p_zone_id number)
    return number;


end;

--ТЕЛО ПАКЕТА 1

create or replace package body lazorenko_al.pkg_1
as
    function avg_age(
    p_zone_id number)
    return number as v_avg_age number;
    begin
    select round(avg((sysdate-p.born_date)/365), 1)
    into v_avg_age
    from lazorenko_al.patient p
    where p.zone_id=p_zone_id and p.sex_id=lazorenko_al.pkg_2.c_sex_constant;
    return v_avg_age;
    end;
end;

------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------ПАКЕТ 2----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ДЛЯ РАСЧЁТА КОЛИЧЕСТВА ВРАЧЕЙ, ОТНОСЯЩИХСЯ К ОПРЕДЕЛЁННОМУ УЧАСТКУ И ОПРЕДЕЛЁННОЙ (ИЛИ НЕТ) БОЛЬНИЦЕ

create or replace function lazorenko_al.count_doctor(
p_hospital_id number default null) return number as v_count_doctor number;
begin
    select count(*)
    into v_count_doctor
    from lazorenko_al.doctor d
    where d.zone_id=lazorenko_al.pkg_1.c_zone_constant and (d.hospital_id=p_hospital_id or p_hospital_id is null);
    return v_count_doctor;
end;


--ПАКЕТ 2

create or replace package lazorenko_al.pkg_2
as
    c_sex_constant constant number:=1;               -----------------------------------------ПРИМЕНЯЕТСЯ В ПАКЕТЕ 1

    function count_doctor(
    p_hospital_id number default null) return number;

end;

--ТЕЛО ПАКЕТА 2

create or replace package body lazorenko_al.pkg_2
as
function count_doctor(
    p_hospital_id number default null) return number as v_count_doctor number;
begin
    select count(*)
    into v_count_doctor
    from lazorenko_al.doctor d
    where d.zone_id=lazorenko_al.pkg_1.c_zone_constant and (d.hospital_id=p_hospital_id or p_hospital_id is null);
    return v_count_doctor;
end;

end;

------------------------------------------------------------------------------------------------------------------------
-------------------------------------------ПРИМЕНЕНИЕ-------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПРИМЕНЕНИЕ ПАКЕТА 1

declare
v_n number;
begin
    v_n:=lazorenko_al.pkg_1.avg_age(1);
    dbms_output.put_line(v_n);
end;

--ПРИМЕНЕНИЕ ПАКЕТА 2

declare
v_n number;
begin
    v_n:=lazorenko_al.pkg_2.count_doctor(null);
    dbms_output.put_line(v_n);
end;