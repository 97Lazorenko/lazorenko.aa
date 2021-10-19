--Сделайте выборку одного поля из таблицы. запишите результат в переменную: строковую и числовую
declare
    v_salary number;
begin
    select di.salary
    into v_salary
    from LAZORENKO_AL.doctors_info di
    where doctor_id=13;
dbms_output.put_line(v_salary);
    end;

declare
    v_region_name varchar2(50);
begin
    select r.name
    into v_region_name
    from LAZORENKO_AL.region r
    where region_id=1;
dbms_output.put_line(v_region_name);
    end;

--Заведите заранее переменные для участия в запросе. создайте запрос на получение чего-то where переменная

declare
    v_availability number;
    v_delete_from_the_sys date;
    v_hospital_id number;
    begin
    v_availability :=2;
    v_delete_from_the_sys :='26-10-2020';
    select h.hospital_id
    into v_hospital_id
    from lazorenko_al.hospital h
    where h.availability_id=v_availability and h.delete_from_the_sys=v_delete_from_the_sys;
    dbms_output.put_line(v_hospital_id);
end;

--Заведите булеву переменную. создайте запрос который имеет разный результат в зависимости от бул переменной.
-- всеми известными способами
declare
              v_is_patient_zone boolean;
              begin
              case
                  when lazorenko_al.patient.zone_id=1
                  then v_is_patient_zone :=true;
                  when lazorenko_al.patient.zone_id=2
                  then v_is_patient_zone :=false;
                  else v_is_patient_zone :=null;
              end case;
              begin
              v_is_patient_zone :=true;
              select p.zone_id
              from lazorenko_al.patient p;
              dbms_output.put_line(v_is_patient_zone);
              exit;

-- Заведите заранее переменные даты. создайте выборку между датами, за сегодня. в день за неделю назад.
-- Сделайте тоже самое но через преобразрование даты из строки

--1)
 --за сегодня
 declare
v_today_date date;
v_another_date date;
v_count_appointment number;
    begin
v_today_date :=sysdate;
v_another_date :='02-09-21';
select count(*) a
into v_count_appointment
from ticket t
where doctor_id=3 and appointment_beg>to_char(v_another_date, 'yyyy-mm-dd hh24:mi:ss')
and appointment_beg<to_char(v_today_date, 'yyyy-mm-dd hh24:mi:ss');
dbms_output.put_line(v_count_appointment);
end;

 --в день за неделю назад
declare
v_today_date date;
v_another_date date;
v_count_appointment number;
    begin
v_today_date :=sysdate-7;
v_another_date :='02-09-2021';
select count(*) a
into v_count_appointment
from ticket t
where doctor_id=3 and appointment_beg>to_char(v_another_date, 'yyyy-mm-dd hh24:mi:ss')
and appointment_beg<to_char(v_today_date, 'yyyy-mm-dd hh24:mi:ss');
dbms_output.put_line(v_count_appointment);
end;

 --2) с преобразованием строк в дату
 --за сегодня
 declare
v_today_date date;
v_another_date date;
v_count_appointment number;
    begin
v_today_date :=sysdate;
v_another_date :='02-09-2021';
select count(*) a
into v_count_appointment
from ticket t
where doctor_id=3 and to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')>v_another_date
and to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')<v_today_date;
dbms_output.put_line(v_count_appointment);
end;

 --в день за неделю назад
 declare
v_today_date date;
v_another_date date;
v_count_appointment number;
    begin
v_today_date :=sysdate-7;
v_another_date :='02-09-2021';
select count(*) a
into v_count_appointment
from ticket t
where doctor_id=3 and to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')>v_another_date
and to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')<v_today_date;
dbms_output.put_line(v_count_appointment);
end;

--Заведите заранее переменную типа строки. создайте выборку забирающуюю ровну одну строку.
-- выведите в консоль результат

declare
v_patient LAZORENKO_AL.patient%rowtype;
begin
    select *
    into v_patient.patient_id, v_patient.last_name, v_patient.first_name,
        v_patient.petronymic, v_patient.born_date, v_patient.tel_number, v_patient.sex_id, v_patient.zone_id
    from patient p
    where p.patient_id=1;
dbms_output.put_line(v_patient.patient_id || ' ' || v_patient.last_name || ' ' || v_patient.first_name
                         || ' ' || v_patient.petronymic || ' ' || v_patient.born_date || ' ' ||
                     v_patient.tel_number || ' ' || v_patient.sex_id || ' ' || v_patient.zone_id);
end;



--Завести заранее переменную массива строк. сделать выборку на массив строк. записать в переменную.
-- вывести каждую строку в цикле в консоль
declare
type arr_type is table of lazorenko_al.patient%rowtype
index by binary_integer;
arr_something arr_type;
arr_patient_id number;
begin
select *
into arr_patient_id, arr_something.last_name, arr_something.first_name,
     arr_something.petronymic, arr_something.born_date, arr_something.tel_number,
     arr_something.sex_id, arr_something.zone_id
from lazorenko_al.patient p;
end;
