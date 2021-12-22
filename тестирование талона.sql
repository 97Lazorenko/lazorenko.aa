
create or replace package lazorenko_al.test_pkg_ticket
as

    --%suite

    --%rollback(manual)

    --%beforeall
    procedure seed_before_all;

    --%afterall
    procedure rollback_after_all;

    --%beforeeach
    procedure print_before_each;

    --%test(проверка получения по id)
    procedure get_ticket_by_id;

    --%test(повторная запись)
    procedure ticket_check;

    --%test(проверка статуса талона)
    procedure ticket_status_check;

    --%test(проверка времени талона)
    procedure time_check;

    --%test(проверка времени талона при отмене)
    procedure ticket_time_check;

    --%test(получение строки по id)
    procedure get_ticket_rowtype_by_id;

    --%test(тест на foreign_key id_doctor)
    --%throws(-01400)
    procedure check_ticket_id_doctor_constraint;

    --%test(тест на foreign_key id_status)
    --%throws(-01400)
    procedure check_ticket_id_stat_constraint;

    --%test(тест на appointment_beg is not null)
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

    procedure get_ticket_by_id
    as
        v_ticket lazorenko_al.t_tickets;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := lazorenko_al.pkg_ticket_repository.get_ticket_info_by_id(mock_id_ticket);

        TOOL_UT3.UT.EXPECT(v_ticket.ticket_id).TO_EQUAL(mock_id_ticket);

    end;

    procedure ticket_check
    as
        v_result boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := lazorenko_al.pkg_ticket_repository.ticket_check(mock_id_ticket, mock_id_patient);

        TOOL_UT3.UT.EXPECT(v_result).TO_BE_TRUE();

    end;

    procedure ticket_status_check
    as
        v_result boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := lazorenko_al.pkg_ticket_repository.ticket_status_check(mock_id_ticket, mock_id_patient);

        TOOL_UT3.UT.EXPECT(v_result).TO_BE_TRUE();

    end;

    procedure time_check
    as
        v_result boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := lazorenko_al.pkg_ticket_repository.time_check(mock_id_ticket);

        TOOL_UT3.UT.EXPECT(v_result).TO_BE_TRUE();
    end;

    procedure ticket_time_check
    as
        v_result boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result := lazorenko_al.pkg_ticket_repository.ticket_time_check(mock_id_ticket);

        TOOL_UT3.UT.EXPECT(v_result).TO_BE_TRUE();

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

end;
/

begin
    TOOL_UT3.UT.RUN('LAZORENKO_AL.TEST_PKG_TICKET');
end;