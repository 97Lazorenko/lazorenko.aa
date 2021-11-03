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