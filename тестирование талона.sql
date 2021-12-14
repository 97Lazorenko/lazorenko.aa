
create or replace package lazorenko_al.test_pkg_ticket
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

    /*
     в любом из before/after тригеров
     можно указать имя другого исполняемого
     обьекта в БД
     */

    --

    --пометка что это тест и его нужно запускать
    --%test(проверка получения по id)
    procedure get_ticket_by_id;

    --%test(проверка получения по id)
    procedure ticket_check;

    --%test(проверка получения по id)
    procedure ticket_status_check;

    --%test(проверка получения по id)
    procedure time_check;

    --%test(проверка получения по id)
    procedure ticket_time_check;

    --%test(проверка получения по id)
    procedure get_ticket_rowtype_by_id;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_ticket_by_id;

     --%test(ошибка получения по id)
    --%throws(-20403)
    procedure failed_check_ticket;

     --%test(ошибка получения по id)
    --%throws(-20403)
    procedure failed_check_ticket_status;

    --%test(ошибка получения по id)
    --%throws(-20404)
    procedure failed_time_check;

    --%test(ошибка получения по id)
    --%throws(-20405)
     procedure failed_ticket_time_check;

    --%test(ошибка получения по id)
    --%throws(-20301)
    procedure failed_get_ticket_rowtype_by_id;

    --%test(тест на foreign_key id_gender)
    --%throws(-01400)
    procedure check_ticket_id_doctor_constraint;

    --%test(тест на foreign_key id_account)
    --%throws(-01400)
    procedure check_ticket_id_stat_constraint;

    --%test(тест на surname is not null)
    --%throws(-01400)
    procedure check_ticket_appointment_constraint;


end;
/

create or replace package body lazorenko_al.test_pkg_ticket
as
    is_debug boolean := true;

    mock_id_ticket number;
    mock_id_doctor number;
    mock_id_ticket_stat number;
    mock_id_patient number;
    mock_appointment_beg varchar2(100);
    mock_appointment_end varchar2(100);
    --

    procedure get_ticket_rowtype_by_id
    as
        v_ticket lazorenko_al.t_arr_ticket;
    begin
    v_ticket :=lazorenko_al.pkg_ticket_repository.get_ticket_with_own_types(
       mock_id_doctor
        );
        if v_ticket.count>0 then
    for i in v_ticket.first..v_ticket.last
    loop
    declare
        v_item lazorenko_al.t_ticket1 :=  v_ticket(i);
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := lazorenko_al.pkg_ticket_repository.get_ticket_with_own_types(mock_id_doctor);

        TOOL_UT3.UT.EXPECT(v_item.ticket_id).TO_EQUAL(mock_id_ticket);

    end;
    end loop;
    end if;
end;

    procedure failed_get_ticket_rowtype_by_id
    as
        v_ticket lazorenko_al.t_arr_ticket;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := lazorenko_al.pkg_ticket_repository.get_ticket_with_own_types(-1);
    end;

    procedure get_ticket_by_id
    as
        v_ticket lazorenko_al.t_tickets;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := lazorenko_al.pkg_ticket_repository.get_ticket_info_by_id(mock_id_ticket);

        TOOL_UT3.UT.EXPECT(v_ticket.ticket_id).TO_EQUAL(mock_id_ticket);

        --больше методов в TOOL_UT3.UT_EXPECTATION
    end;

    procedure ticket_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.ticket_check(mock_id_ticket, mock_id_patient));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);

        --больше методов в TOOL_UT3.UT_EXPECTATION
    end;

    procedure ticket_status_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.ticket_status_check(mock_id_ticket, mock_id_patient));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);

        --больше методов в TOOL_UT3.UT_EXPECTATION
    end;

    procedure time_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.time_check(mock_id_ticket));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);

        --больше методов в TOOL_UT3.UT_EXPECTATION
    end;

    procedure ticket_time_check
    as
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.ticket_time_check(mock_id_ticket));

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(1);

        --больше методов в TOOL_UT3.UT_EXPECTATION
    end;

procedure failed_check_ticket
    as
        v_ticket number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.ticket_check(-1, 1));
    end;

    procedure failed_check_ticket_status
    as
        v_ticket number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.ticket_status_check(-1, 1));
    end;

    procedure failed_time_check
    as
        v_ticket number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.time_check(-1));
    end;

    procedure failed_ticket_time_check
    as
        v_ticket number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := sys.diutil.bool_to_int(lazorenko_al.pkg_ticket_repository.ticket_time_check(27));
    end;

    procedure failed_get_ticket_by_id
    as
        v_ticket lazorenko_al.t_tickets;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := lazorenko_al.pkg_ticket_repository.get_ticket_info_by_id(-1);
    end;

    procedure check_ticket_id_doctor_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into lazorenko_al.ticket(
            doctor_id,
            ticket_stat_id,
            appointment_beg,
            appointment_end
        )
        values (
            null,
            mock_id_ticket_stat,
            mock_appointment_beg,
            mock_appointment_beg
        );
    end;

    procedure check_ticket_id_stat_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into lazorenko_al.ticket(
            doctor_id,
            ticket_stat_id,
            appointment_beg,
            appointment_end
        )
        values (
            mock_id_doctor,
            null,
            mock_appointment_beg,
            mock_appointment_beg
        );
    end;

    procedure check_ticket_appointment_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into lazorenko_al.ticket(
            doctor_id,
            ticket_stat_id,
            appointment_beg,
            appointment_end
        )
        values (
            mock_id_doctor,
            mock_id_ticket_stat,
            null,
            null
        );
    end;

    --

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_id_ticket :=33;
        mock_id_patient :=1;
        mock_id_doctor := 4;
        mock_id_ticket_stat := 1;
        mock_appointment_beg := '2021-12-25 18:00';
        mock_appointment_end := '2021-12-25 19:00';


        insert into lazorenko_al.ticket(
            doctor_id,
            ticket_stat_id,
            appointment_beg,
            appointment_end
        )
        values (
            mock_id_doctor,
            mock_id_ticket_stat,
            mock_appointment_beg,
            mock_appointment_end
        )
        returning ticket_id into mock_id_ticket;
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