------------------------------------------------------------------------------------------------------------------------
-------------------------------------CHECK-ФУНКЦИЯ С ОБРАБОТКОЙ И ЛОГИРОВАНИЕМ ОШИБОК-----------------------------------
------------------------------------------------------------------------------------------------------------------------

create or replace function check_age(
    p_patient_id in number,
    p_spec_id in number)
return boolean as
    v_patient lazorenko_al.patient%rowtype;
    v_age number;
    v_count number;

    e_wrong_age exception;
    pragma exception_init (e_wrong_age, -20400);

    begin

    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_age:=lazorenko_al.calculate_age_from_date(v_patient.born_date);

        select count(*)
        into v_count
        from lazorenko_al.specialisation s
        where s.spec_id = p_spec_id
              and (s.min_age <= v_age or s.min_age is null)
              and (s.max_age >= v_age or s.max_age is null);

    if v_count=0 then
       raise_application_error (-20400, 'возраст пациента не соответствует полу специальности');

    end if;

    return v_count>0;

    exception
        when no_data_found then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
        );

        dbms_output.put_line('данный пациент отсутствует в базе больницы');

        return v_count>0;

        when e_wrong_age then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('возраст пациента не соответствует полу специальности');

        return v_count>0;

    end;

--ПРИМЕНЕНИЕ ФУНКЦИИ - ВВОДИМ ID ПАЦИЕНТА, ОТСУТСТВУЮЩЕГО В БД

declare
    v_check number;
begin
    v_check:=sys.diutil.bool_to_int(lazorenko_al.check_age(
    10,6));

    dbms_output.put_line(v_check);

end;

--ПРИМЕНЕНИЕ ФУНКЦИИ - ВВОДИМ ID ПАЦИЕНТА, НЕ ОТВЕЧАЮЩЕГО ВОЗРАСТНЫМ ОГРАНИЧЕНИЯМ ПО СПЕЦИАЛЬНОСТИ

declare
    v_check number;
begin
    v_check:=sys.diutil.bool_to_int(lazorenko_al.check_age(
    7,6));

    dbms_output.put_line(v_check);

end;


------------------------------------------------------------------------------------------------------------------------
-------ФУНКЦИЯ, ВКЛЮЧАЮЩАЯ В СЕБЯ РАЗЛИЧНЫЕ ПРОВЕРКИ ПЕРЕД ЗАПИСЬЮ (БУДЕМ ИСПОЛЬЗОВАТЬ ТОЛЬКО ОДНУ ДЛЯ ПРИМЕРА)---------
------------------------------------------------------------------------------------------------------------------------

create or replace function lazorenko_al.check_for_accept_with_exceptions(
    p_patient_id in number,
    p_spec_id number
    )
return boolean
as
    v_result boolean := true;

    begin

    if (not lazorenko_al.check_age(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    return v_result;
    end;


------------------------------------------------------------------------------------------------------------------------
----------------------ИТОГВАЯ ФУНКЦИЯ ЗАПИСИ ПОСЛЕ ПРОВЕРКИ УСЛОВИЙ-----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

create or replace function lazorenko_al.accept_record_by_rules_with_exceptions(
    v_ticket_id number,
    v_patient_id number,
    v_spec_id number,
    v_result out number,
    v_need_handle boolean)
return  number as
    v_record_id number;
    begin
        if (lazorenko_al.check_for_accept_with_exceptions(
            p_patient_id => v_patient_id,
            p_spec_id => v_spec_id))

        then v_record_id:=lazorenko_al.pkg_write_or_cancel.write_to_records(        --    В данной функции тожу обрабатываются
            p_patient_id => v_patient_id,                                           --    ошибки. Ознакомиться с данным пакетом
            p_ticket_id => v_ticket_id,                                             --    и функцией можно в PLSQL 2
            p_need_handle => v_need_handle);

        end if;

        if sql%found then

        dbms_output.put_line(v_record_id ||' - '||'запись осуществлена успешно');

        end if;

    return v_result;
    end;

--ПРИМЕНЕНИЕ ФУНКЦИИ - ВВОДИМ ID ПАЦИЕНТА, ОТСУТСТВУЮЩЕГО В БД

declare
    v_result number;
begin
    v_result:=lazorenko_al.accept_record_by_rules_with_exceptions(33, 10, 6, v_result, true);

    commit;

end;

--ПРИМЕНЕНИЕ ФУНКЦИИ - ВВОДИМ ID ПАЦИЕНТА, НЕ ОТВЕЧАЮЩЕГО ВОЗРАСТНЫМ ОГРАНИЧЕНИЯМ ПО СПЕЦИАЛЬНОСТИ

declare
    v_result number;
begin
    v_result:=lazorenko_al.accept_record_by_rules_with_exceptions(33, 7, 6, v_result, true);

    commit;

end;

--ПРИМЕНЕНИЕ ФУНКЦИИ - ВВОДИМ ID ТАЛОНА, ОТСУТСТВУЮЩЕГО В БД

declare
    v_result number;
begin
    v_result:=lazorenko_al.accept_record_by_rules_with_exceptions(100, 3, 6, v_result, true);

    commit;

end;



