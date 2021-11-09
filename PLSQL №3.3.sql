------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ЗАДАНИЕ №2--------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace procedure lazorenko_al.insert_ticket1(valid_time in out number,
valid_ticket in out number, valid_ticket_status in out number, v_valid_patient_age in out number, valid_sex in out number,
valid_hospital_not_deleted in out number, valid_doctor_not_deleted in out number, valid_spec_not_deleted in out number,
valid_patient_doc in out number, valid_IN_parameters in out number, p_patient_id in out number, p_ticket_id in out number)
as
begin
    case
         when valid_time=1 and valid_ticket=1 and valid_ticket_status=1 and v_valid_patient_age=1
              and valid_sex=1 and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1
              and valid_spec_not_deleted=1 and valid_patient_doc=1 and valid_IN_parameters=1
              then insert into lazorenko_al.records(record_stat_id, patient_id, ticket_id)
                   values(1, p_patient_id, p_ticket_id);
              commit;
              update lazorenko_al.ticket t set t.ticket_stat_id=2 where t.ticket_id=p_ticket_id;
              commit;
              dbms_output.put_line('запись успешно завершена');
         when valid_time=1 and valid_ticket=1 and valid_ticket_status=0 and v_valid_patient_age=1
              and valid_sex=1 and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1
              and valid_spec_not_deleted=1 and valid_patient_doc=1 and valid_IN_parameters=1
              then insert into lazorenko_al.records(record_stat_id, patient_id, ticket_id)
                   values(1, p_patient_id, p_ticket_id);
              commit;
              update lazorenko_al.ticket t set t.ticket_stat_id=2 where t.ticket_id=p_ticket_id;
              commit;
              dbms_output.put_line('запись успешно завершена');
         when valid_time=1 and valid_ticket_status=0 and valid_ticket=0 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('вы уже записаны');
         when valid_time=0 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('талон для записи устарел');
         when valid_time=1 and valid_ticket_status=0 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('талон уже занят');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=0 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('неверная возрастная категория');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=0
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('неверный пол для записи к данному специалисту');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=0 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('больница недоступна');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=0 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('доктор недоступен');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=0
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=0 and valid_patient_doc=1
              and valid_IN_parameters=1
              then dbms_output.put_line('специалист данного профиля недоступен');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=0
              and valid_IN_parameters=1
              then dbms_output.put_line('необходимо внести данные ОМС');
         when valid_time=1 and valid_ticket_status=1 and valid_ticket=1 and v_valid_patient_age=1 and valid_sex=1
              and valid_hospital_not_deleted=1 and valid_doctor_not_deleted=1 and valid_spec_not_deleted=1 and valid_patient_doc=1
              and valid_IN_parameters=0
              then dbms_output.put_line('была допущена ошибка при внесении данных при записи - неправильно сочетаются больница, ' ||
                                        'доктор, специальность, номер талона');
         when valid_time=0 and valid_ticket_status=0 and valid_ticket=0 and v_valid_patient_age=0 and valid_sex=0
              and valid_hospital_not_deleted=0 and valid_doctor_not_deleted=0 and valid_spec_not_deleted=0 and valid_patient_doc=0
              and valid_IN_parameters=0
              then dbms_output.put_line('запись внести невозможно');
         else dbms_output.put_line('запись внести невозможно');
    end case;
end;

--МЕТОД ЗАПИСИ
declare
    p_patient_id number:=1; --может быть равен 1, 2, 3, 7                                   | область допустимых |
    p_ticket_id number:=33; --может принимать значенияв диапозоне от 22 до 35 включительно  | значений приведена |
    p_doctor_id number:=3; --может принимать значения от 3 до 47 включительно               | для пробы          |
    p_spec_id number:=2; --может принимать значения от 1 до 7 включительно                  | разработанного     |
    p_hospital_id number:=4; --может принимать значения от 4 до 14 включительно, а также 16 | метода записи      |
    valid_time number:=lazorenko_al.time_check(p_ticket_id);
    valid_ticket number:=lazorenko_al.ticket_check(p_ticket_id);
    valid_ticket_status number:=lazorenko_al.ticket_status_check(p_ticket_id);
    valid_patient_age number:=lazorenko_al.check_age(p_patient_id, p_doctor_id);
    valid_sex number:=lazorenko_al.sex_check(p_patient_id, p_spec_id);
    valid_hospital_not_deleted number:=lazorenko_al.hospital_check(p_hospital_id);
    valid_doctor_not_deleted number:=lazorenko_al.doctor_check(p_doctor_id);
    valid_spec_not_deleted number:=lazorenko_al.spec_check(p_spec_id);
    valid_patient_doc number:=lazorenko_al.patient_doc_check(p_patient_id);
    valid_IN_parameters number:=lazorenko_al.check_IN_parameters(p_hospital_id, p_doctor_id,
    p_spec_id, p_ticket_id); --ИСПОЛЬЗУЕТСЯ ДЛЯ ПРОВЕРКИ ВВОДИМЫХ ПАРАМЕТРОВ ПРИ ЗАПИСИ НА ПРЕДМЕТ
                                                --ИХ СООТВЕТСТВИЯ
begin
    lazorenko_al.insert_ticket1(valid_time, valid_ticket, valid_ticket_status,
    valid_patient_age, valid_sex, valid_hospital_not_deleted,
    valid_doctor_not_deleted, valid_spec_not_deleted,
    valid_patient_doc, valid_IN_parameters, p_patient_id, p_ticket_id);
end;

--НОВЫЙ ВАРИАНТ
--ФУНКЦИЯ ЗАПИСИ
create or replace function write_to_records(
p_patient_id in number,
p_ticket_id in number)
return lazorenko_al.records.record_id%type as
 v_record_id lazorenko_al.records.record_id%type;
begin
    insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
    values (default, 1, p_patient_id, p_ticket_id)
    returning record_id into v_record_id;
    update lazorenko_al.ticket t set t.ticket_stat_id=2 where t.ticket_id=p_ticket_id;
    commit;
return v_record_id;
end;

declare
v_recored_id number;
begin
v_recored_id:=lazorenko_al.write_to_records(3,33);
dbms_output.put_line(v_recored_id);
end;

--ФУНКЦИЯ ПРОВЕРКИ УСЛОВИЙ ПЕРЕД ЗАПИСЬЮ

create or replace function lazorenko_al.check_for_accept(p_ticket_id in number, out_messages out varchar2
)
return boolean
as
    v_result boolean := true;
begin
    if (not lazorenko_al.ticket_check(
        p_ticket_id => p_ticket_id
    )) then v_result:=false;
    out_messages:=out_messages||chr(10)
    ||'пациент уже записан на этот талон';
end if;
    return v_result;
    end;

    declare
   v_result number;
   v_messages varchar2(100);
begin
    v_result :=sys.diutil.bool_to_int(lazorenko_al.check_for_accept(33, v_messages));
    DBMS_OUTPUT.PUT_LINE(v_messages);
end;

--ФУНКЦИЯ ЗАПИСИ С ПРОВЕРКОЙ УСЛОВИЯ
create or replace function lazorenko_al.accept_record_by_rules(
v_ticket_id number,
v_patient_id number,
v_messages in out varchar2,
v_result out number
) return  lazorenko_al.records.record_id%type as
v_record_id lazorenko_al.records.record_id%type;
begin
 if (lazorenko_al.check_for_accept(
            p_ticket_id => v_ticket_id, out_messages => v_messages))
 then v_record_id:=lazorenko_al.write_to_records(p_patient_id => v_patient_id, p_ticket_id => v_ticket_id);
 dbms_output.put_line(v_record_id ||' - '||'запись осуществлена успешно');
 else v_result:=sys.diutil.bool_to_int(lazorenko_al.check_for_accept(v_ticket_id, v_messages));
 DBMS_OUTPUT.PUT_LINE(v_messages);
end if;
return v_result;
end;

--ПРИМЕНЕНИЕ МЕТОДА ЗАПИСИ
    declare
   v_messages varchar2(100);
   v_result number;
begin
    v_result:=lazorenko_al.accept_record_by_rules(33, 1, v_messages, v_result);
end;