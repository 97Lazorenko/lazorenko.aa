
create or replace package lazorenko_al.test_pkg_patient
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
    --%test(получение строки по id)
    procedure get_by_id;

    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_by_id;

    --пометка что это тест и его нужно запускать
    --%test(проверка возраста)
    procedure check_age;

    --%test(ошибка получения по id)
    --%throws(-20400)
    procedure failed_check_age;

    --%test(проверка пола)
    procedure sex_check;

    --%test(ошибка получения по id)
    --%throws(-20401)
    procedure failed_sex_check;

    --%test(проверка наличия ОМС)
    procedure doc_check;

    --%test(ошибка получения по id)
    --%throws(-20402)
    procedure failed_doc_check;

end;
/

create or replace package body lazorenko_al.test_pkg_patient
as
    is_debug boolean := true;

    mock_id_patient number;
    mock_patient_surname varchar2(100);
    mock_patient_name varchar2(100);
    mock_patient_petronymic varchar2(100);
    mock_patient_date_of_birth date;
    mock_patient_tel varchar2(100);
    mock_patient_id_gender number;
    mock_patient_area number;
    --


    procedure get_by_id
    as
        v_patient lazorenko_al.t_patient2;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := lazorenko_al.pkg_patient_repository.get_patient_info_by_id(mock_id_patient);

        TOOL_UT3.UT.EXPECT(v_patient.patient_id).TO_EQUAL(mock_id_patient);

    end;

    procedure failed_get_by_id
    as
        v_patient lazorenko_al.t_patient2;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := lazorenko_al.pkg_patient_repository.get_patient_info_by_id(-1);
    end;

    procedure check_age
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_patient_repository.check_age(1, 3));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_check_age
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_patient_repository.check_age(7, 3));
    end;

    procedure sex_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_patient_repository.sex_check(3, 6));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_sex_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_patient_repository.sex_check(3, 5));
    end;

    procedure doc_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_patient_repository.patient_doc_check(3));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);
    end;

    procedure failed_doc_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_patient_repository.patient_doc_check(2));
    end;

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_id_patient := 1;
        mock_patient_surname := 'surname';
        mock_patient_name := 'name';
        mock_patient_petronymic := 'petronymic';
        mock_patient_date_of_birth := add_months(sysdate, -(12*20));
        mock_patient_tel :='8-800-5-35-35-35';
        mock_patient_id_gender := 1;
        mock_patient_area := 1;



        insert into lazorenko_al.patient(
            last_name,
            first_name,
            petronymic,
            born_date,
            tel_number,
            sex_id,
            zone_id
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            mock_patient_petronymic,
            mock_patient_date_of_birth,
            mock_patient_tel,
            mock_patient_id_gender,
            mock_patient_area
        )
        returning patient_id into mock_id_patient;
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
/

begin
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_PATIENT');
end;