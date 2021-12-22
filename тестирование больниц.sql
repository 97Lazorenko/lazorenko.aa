
create or replace package lazorenko_al.test_pkg_hospital
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
    --%test(проверка получения  строки по id)
    procedure get_hospitals_with_own_types;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(-20800)
    procedure failed_get_hospitals_with_own_types;

    --пометка что это тест и его нужно запускать
    --%test(проверка на удаление)
    procedure not_deleted_hospital_check;

    --%test(ошибка получения по id)
    --%throws(-20392)
    procedure failed_not_deleted_hospital_check;

    --%test(проверка пвремени работы)
    procedure hospital_time_check;

    --%test(ошибка получения по id)
    --%throws(-20300)
    procedure failed_hospital_time_check;

end;
/

create or replace package body lazorenko_al.test_pkg_hospital
as
    is_debug boolean := true;

    mock_id_hospital number;
    mock_hname varchar2(100);
    mock_id_availability number;
    mock_id_med_org number;
    mock_id_doctor number;
    mock_id_ownership_type number;
    mock_enter_into_the_sys date;
    mock_delete_from_the_sys date;
    mock_id_spec number;

    --


    procedure get_hospitals_with_own_types
    as
        v_hospital lazorenko_al.t_arr_hospital_info;
        begin
    v_hospital :=lazorenko_al.pkg_hospital_repository.get_hospitals_with_own_types(
       mock_id_spec
        );
        if v_hospital.count>0 then
    for i in v_hospital.first..v_hospital.last
    loop
    declare
        v_item lazorenko_al.t_hospital_info :=  v_hospital(i);
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_hospital := lazorenko_al.pkg_hospital_repository.get_hospitals_with_own_types(mock_id_spec);

        TOOL_UT3.UT.EXPECT(v_item.doctor_id).TO_EQUAL(mock_id_doctor);

    end;
    end loop;
    end if;
end;

    procedure failed_get_hospitals_with_own_types
    as
        v_patient lazorenko_al.t_arr_hospital_info;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := lazorenko_al.pkg_hospital_repository.get_hospitals_with_own_types(-1);
    end;

    procedure not_deleted_hospital_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_hospital_repository.not_deleted_hospital_check(4));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_not_deleted_hospital_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_hospital_repository.not_deleted_hospital_check(11));
    end;

    procedure hospital_time_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_hospital_repository.hospital_time_check(5));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_hospital_time_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_hospital_repository.hospital_time_check(-1));
    end;

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

    mock_id_hospital :=50;
    mock_hname :='test';
    mock_id_availability :=1;
    mock_id_doctor :=2;
    mock_id_med_org :=1;
    mock_id_ownership_type :=1;
    mock_enter_into_the_sys :=sysdate - 1000;
    mock_delete_from_the_sys := null;
    mock_id_spec :=3;




        insert into lazorenko_al.hospital(
            name,
            availability_id,
            med_org_id,
            ownership_type_id,
            enter_into_the_sys,
            delete_from_the_sys
        )
        values (
            mock_hname,
            mock_id_availability,
            mock_id_med_org,
            mock_id_ownership_type,
            mock_enter_into_the_sys,
            mock_delete_from_the_sys
        )
        returning hospital_id into mock_id_hospital;
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
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_HOSPITAL');
end;