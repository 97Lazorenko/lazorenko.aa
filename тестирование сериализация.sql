create or replace package lazorenko_al.test_pkg_json
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

    --

    --пометка что это тест и его нужно запускать
    --%test(проверка серилизации)
    procedure json_record;

    --пометка что это тест и его нужно запускать
    --%test(проверка серилизации)
    procedure json_cancel;

end;
/

create or replace package body lazorenko_al.test_pkg_json
as
    is_debug boolean := true;

    procedure json_record
    as
        v_result integer;
        v_response lazorenko_al.t_record;
        v_json json_object_t:= json_object_t();
        v_json_response json_array_t:= json_array_t();
        v_return_clob clob;
    begin
        v_response := lazorenko_al.service_for_records(
        33,
        1,
        true,
        3,
        3,
        4,
        v_result
    );

    if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

    v_json.put('code', v_result);

    if v_response.patient_id is not null then
    declare

        v_object json_object_t:= json_object_t();
    begin
        v_object.put('record_id', v_response.record_id);
        v_object.put('record_stat_id', v_response.record_stat_id);
        v_object.put('ticket_id', v_response.ticket_id);
        v_object.put('patient_id', v_response.patient_id);

        v_json_response.append(v_object);
    end;
    end if;

    v_json.put('response', v_json_response);
    v_return_clob := v_json.to_Clob();

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_EQUAL(to_clob('{"code":1,"response":[{"record_id":'|| v_response.record_id||',"record_stat_id":'
                                                    ||v_response.record_stat_id||',"ticket_id":'||v_response.ticket_id||',"patient_id":'||v_response.patient_id||'}]}'));
    end;

    procedure json_cancel
    as
        v_result integer;
        v_response lazorenko_al.t_record;
        v_json json_object_t:= json_object_t();
        v_json_response json_array_t:= json_array_t();
        v_return_clob clob;
    begin
        v_response := lazorenko_al.service_for_cancel(
        33,
        1,
        4,
        v_result
    );

    if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

    v_json.put('code', v_result);

    if v_response.patient_id is not null then
    declare

        v_object json_object_t:= json_object_t();
    begin
        v_object.put('record_id', v_response.record_id);
        v_object.put('record_stat_id', v_response.record_stat_id);
        v_object.put('ticket_id', v_response.ticket_id);
        v_object.put('patient_id', v_response.patient_id);

        v_json_response.append(v_object);
    end;
    end if;

    v_json.put('response', v_json_response);
    v_return_clob := v_json.to_Clob();

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_EQUAL(to_clob('{"code":1,"response":[{"record_id":'|| v_response.record_id||',"record_stat_id":'
                                                    ||v_response.record_stat_id||',"ticket_id":'||v_response.ticket_id||',"patient_id":'||v_response.patient_id||'}]}'));
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
