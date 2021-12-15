
create or replace package lazorenko_al.test_pkg_specs
as

    --%suite
    --пакет относится к тестам

    --%rollback(manual)
    --управление транзакциями вручную

    --%beforeall
    procedure seed_before_all;
    --запуск перед всеми тестами один раз

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
    --%test(проверка на удаление)
    procedure not_deleted_spec_check;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(-20391)
    procedure failed_not_deleted_spec_check;

    --пометка что это тест и его нужно запускать
    --%test(получение строки по id)
    procedure get_specs_with_own_types;

    --%test(ошибка получения по id)
    --%throws(-20809)
    procedure failed_get_specs_with_own_types;

end;
/

create or replace package body lazorenko_al.test_pkg_specs
as
    is_debug boolean := true;
    mock_id_doctor number;
    mock_name_spec varchar2(100);
    mock_id_spec number;
    mock_enter_into_the_sys date;
    mock_delete_from_the_sys date;
    mock_min_age number;
    mock_max_age number;
    mock_id_sex number;
    --


    procedure get_specs_with_own_types
    as
        v_spec lazorenko_al.t_arr_specs;
        begin
    v_spec :=lazorenko_al.pkg_specialisations_repository.get_specs_with_own_types(
       mock_id_doctor
        );
        if v_spec.count>0 then
    for i in v_spec.first..v_spec.last
    loop
    declare
        v_item lazorenko_al.t_specs :=  v_spec(i);
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_spec := lazorenko_al.pkg_specialisations_repository.get_specs_with_own_types(mock_id_doctor);

        TOOL_UT3.UT.EXPECT(v_item.name).TO_EQUAL(mock_name_spec);

    end;
    end loop;
    end if;
end;

    procedure failed_get_specs_with_own_types
    as
        v_spec lazorenko_al.t_arr_specs;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_spec := lazorenko_al.pkg_specialisations_repository.get_specs_with_own_types(-1);
    end;

    procedure not_deleted_spec_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_specialisations_repository.not_deleted_spec_check(mock_id_spec));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_not_deleted_spec_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_specialisations_repository.not_deleted_spec_check(7));
    end;

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

    mock_id_doctor := 50;
    mock_name_spec :='test';
    mock_id_spec :=8;
    mock_enter_into_the_sys :=sysdate - 1000;
    mock_delete_from_the_sys := null;
    mock_min_age := 3;
    mock_max_age := 120;
    mock_id_sex := null;



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
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_SPECS');
end;