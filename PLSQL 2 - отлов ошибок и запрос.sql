------------------------------------------------------------------------------------------------------------------------
---------------------------------------------Метод логирования с автономной транзакцией---------------------------------
------------------------------------------------------------------------------------------------------------------------



-- НЕОБХОДИМО ПЕРЕСОЗДАТЬ МЕТОД, ПОСКОЛЬКУ ОН ПОДВЕРГАЛСЯ ПРЕОБРАЗОВАНИЯМ В ПРЕДЫДУЩЕМ ШАГЕ

create or replace procedure lazorenko_al.add_error_log(
    p_object_name varchar2,
    p_params varchar2,
    p_log_type varchar2 default 'common'
    )
as
    pragma autonomous_transaction;

begin

    insert into lazorenko_al.error_log(object_name, log_type, params)

    values (p_object_name, p_log_type, p_params);

    commit;

end;

------------------------------------------------------------------------------------------------------------------------
---------------------------------------------Отлов и логирование ошибок-------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


--ПРОВЕРКА ПОЛА С ОТЛОВОМ ОШИБОК И ЛОГИРОВАНИЕМ

create or replace function sex_check(
    p_patient_id in number,
    p_spec_id in number)
return boolean as
    v_sex number;
    v_count number;
    v_patient lazorenko_al.patient%rowtype;

    begin

    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_sex:=v_patient.sex_id;

    select count(*)
        into v_count
        from lazorenko_al.specialisation s
        where s.spec_id=p_spec_id and (s.sex_id=v_sex or s.sex_id is null);

    return v_count>0;

      exception

        when no_data_found then lazorenko_al.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit,
                '{"error":"' || sqlerrm
                ||'","value":"' || p_patient_id
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
        );

        dbms_output.put_line('данный пациент отсутствует в базе больницы');

    return v_count>0;

    end;

--ИСПОЛЬЗОВАНИЕ

declare
    v_check number;
begin
    v_check:=sys.diutil.bool_to_int(lazorenko_al.sex_check(
    10,5)); --ПРОВЕРКА ПОЛА

    dbms_output.put_line(v_check);

end;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПРОВЕРКА ВОЗРАСТА С ОТЛОВОМ ОШИБОК И ЛОГИРОВАНИЕМ

create or replace function check_age(
    p_patient_id in number,
    p_spec_id in number)
return boolean as
    v_patient lazorenko_al.patient%rowtype;
    v_age number;
    v_count number;

    begin
    v_patient:=lazorenko_al.get_patient_info_by_id(p_patient_id);
    v_age:=lazorenko_al.calculate_age_from_date(v_patient.born_date);

        select count(*)
        into v_count
        from lazorenko_al.specialisation s
        where s.spec_id = p_spec_id
               and (s.min_age <= v_age or s.min_age is null)
               and (s.max_age >= v_age or s.max_age is null);

    return v_count>0;

      exception
        when no_data_found then lazorenko_al.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit,
                '{"error":"' || sqlerrm
                ||'","value":"' || p_patient_id
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
        );

        dbms_output.put_line('данный пациент отсутствует в базе больницы');

    return v_count>0;
    end;

--ИСПОЛЬЗОВАНИЕ

declare
    v_check number;
begin
    v_check:=sys.diutil.bool_to_int(lazorenko_al.check_age(
    10,5)); --ПРОВЕРКА ВОЗРАСТА

    dbms_output.put_line(v_check);
end;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


--ПАКЕТ С ФУНКЦИЯМИ ЗАПИСИ И ОТМЕНЫ ЗАПИСИ С ОТЛОВОМ ОШИЮОК И ЛОГИРОВАНИЕМ

create or replace package lazorenko_al.pkg_write_or_cancel
as
    c_record_or_ticket_stat_first constant number := 1;
                                                          --КОНСТАНТЫ БУДУТ ИСПОЛЬЗОВАНЫ В ФУНКЦИЯХ ЗАПИСИ И ОТМЕНЫ
    c_record_or_ticket_stat_second constant number := 2;

    v_record_id lazorenko_al.records.record_id%type;

    v_record_id number;

    function cancel_record(
    p_ticket_id in number)
    return number;

    function write_to_records(
    p_patient_id in number,
    p_ticket_id in number,
    p_need_handle boolean)
    return number;
end;

create or replace package body lazorenko_al.pkg_write_or_cancel
as
    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number,
         p_need_handle boolean
    )
    return number as
        v_record_id number;

        no_patient_found_or_wrong_ticket exception;
        pragma exception_init (no_patient_found_or_wrong_ticket, -02291);

    begin
        if (p_need_handle) then
            begin
                insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
                values (default, lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first, p_patient_id, p_ticket_id)
                returning ticket_id into v_record_id;

                update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
                where t.ticket_id=p_ticket_id;

            exception
                when no_patient_found_or_wrong_ticket then

                    lazorenko_al.add_error_log(
        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm ||'","value":"'
                     || p_patient_id
                     ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                     ||'"}'
                    );

                    dbms_output.put_line('запись внести невозможно - укажите другого пациента или талон');

                rollback;

                return v_record_id;

            end;
        else

            insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)

            values (default, lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first, p_patient_id, p_ticket_id)

            returning ticket_id into v_record_id;

            update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
            where t.ticket_id=p_ticket_id;

        end if;

            return v_record_id;

    end;

    function cancel_record(
        p_ticket_id in number
    )
    return  number  as
        v_record_id number;

        no_ticket_found exception;
        pragma exception_init (no_ticket_found, -20500);

    begin

            update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first
            where t.ticket_id=p_ticket_id;

            update lazorenko_al.records r set r.record_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
            where r.ticket_id=p_ticket_id;

        if sql%notfound then

            raise_application_error(-20500,'указан неверный талон');

        end if;

        return v_record_id;

    exception
        when no_ticket_found then

            lazorenko_al.add_error_log(
        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
                      ||'","value":"' || p_ticket_id
                      ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                      ||'"}'
            );

            dbms_output.put_line('указан неверный номер талона');

        return v_record_id;

    end;

end;


----------------------------------------------------ИСПОЛЬЗОВАНИЕ-------------------------------------------------------

--ЗАПИСЬ
declare
    v_patient number := 10;
    v_ticket number :=33;
    v_record number;
begin
   v_record:=lazorenko_al.pkg_write_or_cancel.write_to_records(
        p_patient_id => v_patient,
        p_ticket_id => v_ticket,
        p_need_handle => true
    );
    commit;
end;

--ОТМЕНА ЗАПИСИ
declare
    v_ticket number :=111;
    v_record number;
begin
   v_record:=lazorenko_al.pkg_write_or_cancel.cancel_record(
        p_ticket_id => v_ticket
    );
    commit;
end;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ЗАПРОС К ЛОГУ-----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
select *
    from (
        select
            er.id_log,
            er.sh_dt,
            er.object_name,
            er.params,

            (select error
            from json_table(er.params, '$' columns (
                error varchar2(100) path '$.error'
            ))) error,

            (select value
            from json_table(er.params, '$' columns (
                value varchar2(100) path '$.value'
            ))) value

        from (
            select *
            from lazorenko_al.error_log er
            where er.params like '{"%'
           and trunc(er.sh_dt) between trunc(to_date('23.11.2021','dd.mm.yyyy')) and trunc(to_date('27.11.2021','dd.mm.yyyy'))
        ) er
    ) jt
where jt.params like '%1%' and jt.object_name like 'LAZORENKO_AL.PKG_WRITE_OR_CANCEL%'
;