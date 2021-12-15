
create or replace package lazorenko_al.test_pkg_utilites
as

    --%suite
    --пакет относится к тестам

    --%rollback(manual)
    --управление транзакциями вручную
/*
    --%beforeall
    procedure seed_before_all;
    --запуск перед всеми тестами один раз
*/
    --%afterall
    procedure rollback_after_all;
    --запуск после всех тестов один раз

    --%beforeeach
    procedure print_before_each;
    --запуск перед каждым тестом

    --%aftereach
    procedure print_after_each;
    --запуск после каждого теста

    --пометка что это тест и его нужно запускать
    --%test(проверка получения по id)
    procedure calculate_age_from_date;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(-20391)
    procedure failed_calculate_age_from_date;

end;
/

create or replace package body lazorenko_al.test_pkg_utilites
as
    is_debug boolean := true;
    mock_date date;

    --


    procedure calculate_age_from_date
    as
        v_age number;

        begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_age := lazorenko_al.utilite_repository.calculate_age_from_date(mock_date);

        TOOL_UT3.UT.EXPECT(v_age).TO_EQUAL(1);
    end;

    procedure failed_calculate_age_from_date
    as
        v_age number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_age := lazorenko_al.utilite_repository.calculate_age_from_date(null);
    end;

   procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

    mock_date := sysdate - 365;

    end;

/*

        insert into lazorenko_al.specialisation(
            name,
            enter_into_the_sys,
            delete_from_the_sys,
            min_age,
            max_age,
            sex_id
        )
        values (
            mock_name_spec,
            mock_enter_into_the_sys,
            mock_delete_from_the_sys,
            mock_min_age,
            mock_max_age,
            mock_id_sex
        )
        returning spec_id into mock_id_spec;
    end;
*/
    procedure rollback_after_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
        rollback;
    end;

    procedure print_before_each
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    end;

    procedure print_after_each
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    end;
end;
