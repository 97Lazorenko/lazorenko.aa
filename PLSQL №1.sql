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
    v_hospital_name varchar2(50);
    begin
    v_availability :=2;
    v_delete_from_the_sys :='26-10-2020';
    select h.name
    into v_hospital_name
    from lazorenko_al.hospital h
    where h.availability_id=v_availability and h.delete_from_the_sys=v_delete_from_the_sys;
    dbms_output.put_line(v_hospital_name);
end;

--Заведите булеву переменную. создайте запрос который имеет разный результат в зависимости от бул переменной.
-- всеми известными способами

declare
v_salary_is_more_than_avg boolean;
v_doctor_id number;
v_result_salary number;
v_avg_salary number;
begin
    v_salary_is_more_than_avg :=true;
CASE
    when v_salary_is_more_than_avg=true
    then v_doctor_id :=11;
    when v_salary_is_more_than_avg=false
    then v_doctor_id :=3;
    else v_doctor_id :=1;
end CASE;
    select di.salary
    into v_result_salary
    from lazorenko_al.doctors_info di
    where di.doctor_id=v_doctor_id;
select round(avg(salary), 1) as avg_salary
into v_avg_salary
from lazorenko_al.doctors_info;
    dbms_output.put_line('зарплата конкретного врача, равная' || ' ' || v_result_salary ||', '|| 'больше средней зарплаты, равной' || ' ' || v_avg_salary);
    END;



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
    into v_patient
    from patient p
    where p.patient_id=1;
dbms_output.put_line(v_patient.patient_id || ' ' || v_patient.last_name || ' ' || v_patient.first_name
                         || ' ' || v_patient.petronymic || ' ' || v_patient.born_date || ' ' ||
                     v_patient.tel_number || ' ' || v_patient.sex_id || ' ' || v_patient.zone_id);
end;



--Завести заранее переменную массива строк. сделать выборку на массив строк. записать в переменную.
-- вывести каждую строку в цикле в консоль

declare
type arr_type is table of number
index by binary_integer;
arr arr_type;
a binary_integer;
begin
arr(1) := 1;
arr(2) := 2;
arr(3) := 3;
 a := arr.first;
  loop
    dbms_output.put_line(arr(a));
  exit when a = arr.last;
   a := arr.next(a);
  end loop;
end;

declare
type arr_type is table of varchar2(2000)
index by binary_integer;
a_index binary_integer :=1;
a1_index binary_integer :=1;
a2_index binary_integer :=1;
a_doctor arr_type;
a_doctor1 arr_type;
a_doctor2 arr_type;
begin
select d.doctor_id, d.name, d.hiring_date
bulk collect into a_doctor, a_doctor1, a_doctor2
from lazorenko_al.doctor d;
a_index :=a_doctor.first;
a1_index :=a_doctor.first;
a2_index :=a_doctor.first;
loop
    exit when a_index = a_doctor.last and a1_index = a_doctor1.last and a2_index = a_doctor2.last;
    dbms_output.put_line('id доктора=' || a_doctor(a_index) || ' ' ||'Фамилия='
                             || a_doctor1(a1_index) || ' '||'дата найма='|| a_doctor2(a2_index));
    a_index := a_doctor.next(a_index);
    a1_index := a_doctor1.next(a1_index);
    a2_index := a_doctor2.next(a2_index);
    end loop;
end;