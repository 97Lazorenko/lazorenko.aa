------------------------------------------------------------------------------------------------------------------------
---------------------------------ФУНКЦИИ ПРОВЕРКИ УСЛОВИЙ, ОТМЕНЫ ЗАПИСИ И ИТОГОВАЯ ФУНКЦИЯ-----------------------------
-----------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ПРОВЕРКИ ВРЕМЕННЫХ ОГРАНИЧЕНИЙ

create or replace function lazorenko_al.hospital_time_check(
    p_hospital_id in number)
return boolean as
    v_count number;
begin
    select count(*)
    into v_count
    from lazorenko_al.work_time w
    where w.end_time>(TO_CHAR(sysdate, 'hh24:mi'))
    and w.day in (to_char(sysdate, 'd')) and w.hospital_id=p_hospital_id;

return v_count>0;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ

declare
    valid_time_for_cancel number;
begin
    valid_time_for_cancel :=sys.diutil.bool_to_int(lazorenko_al.hospital_time_check(13));
    dbms_output.put_line( valid_time_for_cancel);
end;

--ФУНКЦИЯ ПРОВЕРКИ ВРЕМЕНИ ПРИЁМА

create or replace function lazorenko_al.ticket_time_check(
    p_ticket_id in number)
return boolean as
    v_count number;
begin
    select count(*)
    into v_count
    from lazorenko_al.ticket t
    where to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')>sysdate+1/12
          and t.ticket_id=p_ticket_id;

return v_count>0;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ

declare
    valid_time_for_cancel number;
begin
    valid_time_for_cancel :=sys.diutil.bool_to_int(lazorenko_al.ticket_time_check(33));
    dbms_output.put_line( valid_time_for_cancel);
end;

--ФУНКЦИЯ ПРОВЕРКИ ВВОДИМЫХ ПРИ ЗАПИСИ ПАРАМЕТРОВ

create or replace function lazorenko_al.check_IN_parameters2(
    p_patient_id in number,
    p_ticket_id in number)
return boolean as
    v_count number;
begin
    select count(*)
    into v_count
    from lazorenko_al.records r
    where r.patient_id=p_patient_id and r.ticket_id=p_ticket_id and r.record_stat_id=1;

return v_count>0;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ

declare
    valid_IN_parameters2 number;
begin
    valid_IN_parameters2 :=sys.diutil.bool_to_int(lazorenko_al.check_IN_parameters2(1, 30));
    dbms_output.put_line( valid_IN_parameters2);
end;

------------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ПРОВЕРКИ УСЛОВИЙ ПЕРЕД ОТМЕНОЙ

create or replace function lazorenko_al.check_for_cancel(
    p_hospital_id in number,
    p_ticket_id in number,
    p_patient_id in number,
    out_messages out varchar2
)
return boolean
as
    v_result boolean := true;
begin
    if (not lazorenko_al.check_IN_parameters2(
    p_patient_id => p_patient_id,
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'у вас отсутствует действующий талон с подобными параметрами или талон закрыт';
    end if;

    if (not lazorenko_al.ticket_time_check(
    p_ticket_id => p_ticket_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'приём уже завершился';
    end if;

    if (not lazorenko_al.hospital_time_check(
    p_hospital_id => p_hospital_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'не соблюдены ограничения по времени работы больницы';
    end if;

return v_result;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ

declare
    v_result number;
    v_messages varchar2(500);
begin
    v_result :=sys.diutil.bool_to_int(lazorenko_al.check_for_cancel(
    4, 27, 1, v_messages));
    dbms_output.put_line(v_messages);
end;

------------------------------------------------------------------------------------------------------------------------

--ФУНКЦИЯ ОТМЕНЫ ЗАПИСИ

create or replace function lazorenko_al.cancel_record(
    p_ticket_id in number)
return  number  as
    v_record_id number;
begin
     update lazorenko_al.ticket t set t.ticket_stat_id=1 where t.ticket_id=p_ticket_id;
     update lazorenko_al.records r set r.record_stat_id=2 where r.ticket_id=p_ticket_id;
     commit;
return v_record_id;
end;

--ТЕСТИРОВАНИЕ ЕЁ РАБОТОСПОСОБНОСТИ

declare
   v_record_id number;
begin
   v_record_id:=lazorenko_al.cancel_record(33);
   dbms_output.put_line(v_record_id);
end;

------------------------------------------------------------------------------------------------------------------------

--ОТМЕНА ЗАПИСИ ПО УСЛОВИЯМ

create or replace function lazorenko_al.cancel_record_by_rules(
    v_ticket_id number,
    v_patient_id number,
    v_hospital_id number,
    v_messages in out varchar2,
    v_result out number)
return  lazorenko_al.records.record_id%type as
    v_record_id lazorenko_al.records.record_id%type;
begin
    if (lazorenko_al.check_for_cancel(
    p_ticket_id => v_ticket_id,
    p_patient_id => v_patient_id,
    p_hospital_id => v_hospital_id,
    out_messages => v_messages))
    then v_record_id:=lazorenko_al.cancel_record(p_ticket_id => v_ticket_id);
    dbms_output.put_line(v_record_id ||' - '||'запись отменена');

    else v_result:=sys.diutil.bool_to_int(lazorenko_al.check_for_cancel(v_hospital_id,
                                                                           v_ticket_id,
                                                                           v_patient_id,
                                                                           v_messages));
    dbms_output.put_line(v_messages);
end if;
return v_result;
end;


--ПРИМЕНЕНИЕ МЕТОДА ОТМЕНЫ ЗАПИСИ

declare
    v_messages varchar2(500);
    v_result number;
begin
    v_result:=lazorenko_al.cancel_record_by_rules(
    33, 1, 4,
    v_messages, v_result);
end;