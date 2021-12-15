create or replace package lazorenko_al.test_pkg_total_checks
as

    --%suite
    --пакет относится к тестам

    --%rollback(manual)
    --управление транзакциями вручную

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
    --%test(общая проверка при записи)
    procedure check_for_accept_with_exceptions;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(-20666)
    procedure failed_check_for_accept_with_exceptions;

    --пометка что это тест и его нужно запускать
    --%test(обшая проверка при отмене)
    procedure check_cancel;

    --%test(ошибка получения по id)
    --%throws(-20666)
    procedure failed_check_cancel;


end;
/

create or replace package body lazorenko_al.test_pkg_total_checks
as
    is_debug boolean := true;

    --


    procedure check_for_accept_with_exceptions
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_for_accept_with_exceptions(33, 1, 3, 3, 4));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_check_for_accept_with_exceptions
    as
        v_result boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := lazorenko_al.pkg_total_checks_repository.check_for_accept_with_exceptions(28, 3, 5, 4, 4);
    end;

    procedure check_cancel
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_cancel(4, 31, 2));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(0);
    end;

    procedure failed_check_cancel
    as
        v_result boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := lazorenko_al.pkg_total_checks_repository.check_cancel(11, 33, 1);
    end;


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


begin
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_TOTAL_CHECKS');
end;