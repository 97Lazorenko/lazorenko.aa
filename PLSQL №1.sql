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
    v_doctor_id number;
    v_name_doctor varchar2(50);
    begin
    v_doctor_id :=5;
    select d.name
    into v_name_doctor
    from LAZORENKO_AL.doctor d
    where doctor_id=v_doctor_id;
dbms_output.put_line(v_name_doctor);
end;

--Заведите булеву переменную. создайте запрос который имеет разный результат в зависимости от бул переменной. всеми известными способами
declare
    v_bool_ number;
    v_name_doctor varchar2(50);
    begin
    v_doctor_id :=5;
    select d.name
    into v_name_doctor
    from LAZORENKO_AL.doctor d
    where doctor_id=v_doctor_id;
dbms_output.put_line(v_name_doctor);
end;


-- Заведите заранее переменные даты. создайте выборку между датами, за сегодня. в день за неделю назад.
-- Сделайте тоже самое но через преобразрование даты из строки
declare
    v_today_date date;
    v_ticket_id number;
    begin
    v_today_date :=sysdate;
  select t.ticket_id
  into v_ticket_id
from ticket t inner join doctor d using(doctor_id)
where 3=doctor_id
  and t.appointment_beg>to_char(v_today_date);
end;


--Заведите заранее переменную типа строки. создайте выборку забирающуюю ровну одну строку. выведите в консоль результат

