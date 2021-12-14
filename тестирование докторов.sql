


--нейминг test_имя-тестируемого-обьекта
create or replace package lazorenko_al.test_pkg_doctor
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
    procedure get_by_id_1;

    --%test(проверка получения по id)
    procedure get_by_id_2;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_by_id_1;

    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_by_id_2;

end;
/

create or replace package body lazorenko_al.test_pkg_doctor
as
    is_debug boolean := true;

    mock_id_doctor number;
    mock_name varchar2(100);
    mock_id_hospital number;
    mock_id_zone number;
    mock_hiring_date date;
    mock_dismiss_date date;
    mock_fname varchar2(100);
    mock_petronymic varchar2(100);
    --

    procedure get_by_id_1
    as
        v_response number;
begin
    if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    v_response := sys.diutil.bool_to_int(lazorenko_al.pkg_doctor_repository.not_deleted_doctor_check(
         mock_id_doctor));

    TOOL_UT3.UT.EXPECT(1).TO_EQUAL(v_response);

end;

    procedure get_by_id_2
    as
     v_doctor lazorenko_al.t_arr_doctors_detailed;
begin
    v_doctor := lazorenko_al.pkg_doctor_repository.get_doctor_with_own_types(
         mock_id_doctor, mock_id_zone);
    if v_doctor.count>0 then
    for i in v_doctor.first..v_doctor.last
    loop
    declare
        v_item lazorenko_al.t_doctors_detailed := v_doctor(i);
    begin
    if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    v_doctor := lazorenko_al.pkg_doctor_repository.get_doctor_with_own_types(
         mock_id_doctor, mock_id_zone);

    TOOL_UT3.UT.EXPECT(v_item.dname).TO_EQUAL(mock_name);
    end;
    end loop;
    end if;
end;


    procedure failed_get_by_id_1
    as
        v_response number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
     v_response := sys.diutil.bool_to_int(lazorenko_al.pkg_doctor_repository.not_deleted_doctor_check(
         -1));
    end;


        procedure failed_get_by_id_2
    as
        v_doctor lazorenko_al.t_arr_doctors_detailed;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
     v_doctor := lazorenko_al.pkg_doctor_repository.get_doctor_with_own_types(
         -1, -1);
    end;
    --

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

    mock_name := 'test';
    mock_id_hospital := 17;
    mock_id_zone := 1;
    mock_hiring_date := sysdate;
    mock_dismiss_date := null;
    mock_fname := 'test';
    mock_petronymic := 'test';


        insert into lazorenko_al.doctor(
            name,
            hospital_id,
            zone_id,
            hiring_date,
            dismiss_date,
            fname,
            petronymic
        )
        values (
            mock_name,
            mock_id_hospital,
            mock_id_zone,
            mock_hiring_date,
            mock_dismiss_date,
            mock_fname,
            mock_petronymic
        )
        returning doctor_id into mock_id_doctor;
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