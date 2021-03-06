------------------------------------------------------------------------------------------------------------------------
-------------------------------------CHECK-ФУНКЦИЯ С ОБРАБОТКОЙ И ЛОГИРОВАНИЕМ ОШИБОК-----------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace function lazorenko_al.ticket_is_real(
    p_ticket_id in number)
return boolean as
    v_count number;

    begin
    select t.ticket_id
    into v_count
    from lazorenko_al.ticket t
    where t.ticket_id=p_ticket_id;
    return v_count>0;
    exception
        when no_data_found
        then lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('такого талона не существует');

        return false;
    end;




create or replace function check_age(
    p_patient_id in number,
    p_spec_id in number)
return boolean as
    v_patient lazorenko_al.t_patient;
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
       raise_application_error (-20400, 'возраст пациента не соответствует возрасту специальности');

    end if;
        return v_count>0;
    exception

        when e_wrong_age then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('возраст пациента не соответствует возрасту специальности');

        return false;

    end;


    create or replace function sex_check(
    p_patient_id in number,
    p_spec_id in number)
    return boolean as
    v_sex number;
    v_patient lazorenko_al.t_patient;
    v_count number;

    e_wrong_sex exception;
    pragma exception_init (e_wrong_sex, -20401);


    begin
    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_sex:=v_patient.sex_id;
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id and (s.sex_id=v_sex or s.sex_id is null);
    if v_count=0 then
       raise_application_error (-20401, 'пол пациента не соответствует полу специальности');
    return v_count>0;
    end if;
        return v_count>0;
    exception

        when e_wrong_sex then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('пол пациента не соответствует полу специальности');

        return false;

    end;


    create or replace function patient_doc_check(
    p_patient_id in number)
    return boolean as
    v_count number;

    e_no_docs exception;
    pragma exception_init (e_no_docs, -20402);

    begin
    select count(*)
    into v_count
    from lazorenko_al.documents_numbers dn
    where dn.patient_id=p_patient_id and dn.document_id=4
          and dn.value is not null;
    if v_count=0 then
       raise_application_error (-20402, 'отсутствуют данные по полису ОМС');
    return v_count>0;
    end if;
        return v_count>0;
    exception

        when e_no_docs then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit,
        '{"error":"' || sqlerrm
                  ||'","value":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('отсутствуют данные по полису ОМС');

        return false;

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
    p_ticket_id number,
    p_patient_id in number,
    p_spec_id number
    )
return boolean
as
    v_result boolean := true;

    begin
    if (not lazorenko_al.ticket_is_real(
        p_ticket_id => p_ticket_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.check_age(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.sex_check(
        p_patient_id => p_patient_id,
        p_spec_id => p_spec_id
        ))
    then v_result:=false;
    end if;

    if (not lazorenko_al.patient_doc_check(
        p_patient_id => p_patient_id
        ))
    then v_result:=false;
    end if;

    return v_result;
    end;

declare
    v_check number;
begin
    v_check:=sys.diutil.bool_to_int(lazorenko_al.check_for_accept_with_exceptions(330, 1, 2));

    dbms_output.put_line(v_check);
end;
------------------------------------------------------------------------------------------------------------------------
----------------------ИТОГВАЯ ФУНКЦИЯ ЗАПИСИ ПОСЛЕ ПРОВЕРКИ УСЛОВИЙ-----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

create or replace function lazorenko_al.accept_record_by_rules_with_exceptions(
    v_ticket_id number,
    v_patient_id number,
    v_spec_id number,
    v_need_handle boolean)
return  number as
    v_result number;
    begin
        if (lazorenko_al.check_for_accept_with_exceptions(
            p_ticket_id => v_ticket_id,
            p_patient_id => v_patient_id,
            p_spec_id => v_spec_id))

        then v_result:=lazorenko_al.pkg_write_or_cancel.write_to_records(
            p_patient_id => v_patient_id,
            p_ticket_id => v_ticket_id,
            p_need_handle => v_need_handle);
    --return v_result;
       --else v_result:=0;

        end if;

    return v_result;
    end;

--ПРИМЕНЕНИЕ ФУНКЦИИ

declare
    v_result number;
begin
    v_result:=lazorenko_al.accept_record_by_rules_with_exceptions(
    33, 1, 2, true);

    commit;
    dbms_output.put_line(v_result);
end;




------------------------------------------------------------------------------------------------------------------------
---------------------------------------------ОТВЕТ НА ВОПРОС------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
/*
    В целом вариант со сбросом ошибки оказался достаточно интересным решением. С одной стороны, по функциональности он
 явно не уступает прежнему варианту, где с помощью dbms_output.put_line в случае провала проверки выводились
 уведомления, содержащие соответствующую информацию. Кроме того, за счёт логирования сбрасываемых ошибок
 у нас появляется ценная информация, которая может быть использована для доработки скриптов или в иных целях (например,
 аналитических - при доработке таблицы логов).
    С другой стороны, такой вариант показался мне более трудоёмким, потребовалось подойти с большим вниманием к
подготоаке скриптов. Возможно это связано с необходимостью переработки прежних скриптов, а также с новизной (для меня)
темы обработки исключений.
 */


