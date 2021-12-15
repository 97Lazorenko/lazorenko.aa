create or replace package lazorenko_al.test_pkg_accordance
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
    --%test(проверка соответствия при записи)
    procedure check_accordance_of_write_parameters;

    --%test(ошибка получения по id)
    --%throws(-20395)
    procedure failed_check_accordance_of_write_parameters;

    --пометка что это тест и его нужно запускать
    --%test(проверка соответствия при отмене)
    procedure check_accordance_for_cancel;

    --%test(ошибка получения по id)
    --%throws(-20302)
    procedure failed_check_accordance_for_cancel;


end;
/

create or replace package body lazorenko_al.test_pkg_accordance
as
    is_debug boolean := true;

    procedure check_accordance_of_write_parameters
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.accordance_ckeck_repository.check_accordance_of_write_parameters(4, 3, 3, 33));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_check_accordance_of_write_parameters
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.accordance_ckeck_repository.check_accordance_of_write_parameters(4, 3, 3, 330));
    end;

    procedure check_accordance_for_cancel
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.accordance_ckeck_repository.check_accordance_for_cancel(2, 31));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_check_accordance_for_cancel
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.accordance_ckeck_repository.check_accordance_for_cancel(2, 310));
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
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_ACCORDANCE');
end;