-----------------------------------------------------------------------------------------------------------------------
----------------------------------------------ЗАДАНИЕ №3---------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ПРОВЕРКИ ВРЕМЕННЫХ ОГРАНИЧЕНИЙ
create or replace function lazorenko_al.cancel_check(p_hospital_id in number, p_ticket_id in number)
return number as
valid_time_for_cancel number;
begin
select case
when to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')>sysdate+1/12
and t.ticket_id=p_ticket_id
and TO_CHAR(sysdate, 'hh24:mi:ss')<(select w.end_time
             from lazorenko_al.work_time w where w.day in (to_char(sysdate, 'd'))
                                           and w.hospital_id=p_hospital_id) then 1
else 0 end
into valid_time_for_cancel
from lazorenko_al.ticket t
where t.ticket_id=p_ticket_id;
return valid_time_for_cancel;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ
declare
   valid_time_for_cancel number;
begin
    valid_time_for_cancel :=lazorenko_al.cancel_check(4, 33);
    DBMS_OUTPUT.PUT_LINE( valid_time_for_cancel);
end;

--ФУНКЦИЯ ПРОВЕРКИ ВВОДИМЫХ ПРИ ЗАПИСИ ПАРАМЕТРОВ
create or replace function lazorenko_al.check_IN_parameters2(p_patient_id in number, p_ticket_id in number)
return number as
valid_IN_parameters2 number;
begin
select count(*)
into valid_IN_parameters2
from lazorenko_al.records r
where r.patient_id=p_patient_id and r.ticket_id=p_ticket_id and r.record_stat_id=1;
return valid_IN_parameters2;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ
declare
   valid_IN_parameters2 number;
begin
    valid_IN_parameters2 :=lazorenko_al.check_IN_parameters2(1, 33);
    DBMS_OUTPUT.PUT_LINE( valid_IN_parameters2);
end;

--СОЗДАНИЕ ПРОЦЕДУРЫ ДЛЯ ОТМЕНЫ ЗАПИСИ
create or replace procedure lazorenko_al.cancel_record(valid_time_for_cancel in out number,
valid_IN_parameters2 in out number, p_ticket_id in out number)
as
begin
case
     when valid_time_for_cancel=1 and valid_IN_parameters2=1
     then update lazorenko_al.ticket t set t.ticket_stat_id=1 where t.ticket_id=p_ticket_id;
     update lazorenko_al.records r set r.record_stat_id=2 where r.ticket_id=p_ticket_id;
     commit;
     dbms_output.put_line('запись успешно отменена');
     else dbms_output.put_line('ошибка отмены записи');
end case;
end;

--ОТМЕНА ЗАПИСИ
declare
    p_hospital_id number:=4;
    p_ticket_id number:=33;
    p_patient_id number:=1;
    valid_time_for_cancel number:=lazorenko_al.cancel_check(p_hospital_id, p_ticket_id);
    valid_IN_parameters2 number:=lazorenko_al.check_IN_parameters2(p_patient_id,p_ticket_id);
begin
    lazorenko_al.cancel_record(valid_time_for_cancel, valid_IN_parameters2,  p_ticket_id);
end;
