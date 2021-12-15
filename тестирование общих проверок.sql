create or replace package lazorenko_al.test_pkg_total_checks
as
    /*
     нельзя писать комментарии:
     - на той же строке с аннотацией
     - между аннотацией и связанной с ней процедурой
     */


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


    /*
     в любом из before/after тригеров
     можно указать имя другого исполняемого
     обьекта в БД
     */

    --

    --пометка что это тест и его нужно запускать
    --%test(проверка получения по id)
    procedure check_for_accept_with_exceptions;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(-20395)
    procedure failed_check_for_accept_with_exceptions;

    --пометка что это тест и его нужно запускать
    --%test(проверка получения по id)
    procedure check_cancel;

    --%test(ошибка получения по id)
    --%throws(-20302)
    procedure failed_check_cancel;


end;
/

create or replace package body lazorenko_al.test_pkg_total_checks
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
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_for_accept_with_exceptions(28, 3, 5, 4, 4));
    end;

    procedure check_cancel
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_cancel(4, 33, 2));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(0);
    end;

    procedure failed_check_cancel
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_total_checks_repository.check_cancel(4, 33, 1));
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
