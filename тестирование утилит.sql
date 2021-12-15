
create or replace package lazorenko_al.test_pkg_utilites
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
    --%test(проверка расчётов)
    procedure calculate_age_from_date;

end;
/

create or replace package body lazorenko_al.test_pkg_utilites
as
    is_debug boolean := true;

    --

    procedure calculate_age_from_date
    as
        v_age number;
        v_date date:= sysdate - 365;

        begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_age := lazorenko_al.utilite_repository.calculate_age_from_date(v_date);

        TOOL_UT3.UT.EXPECT(v_age).TO_EQUAL(1);
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
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_UTILITES');
end;