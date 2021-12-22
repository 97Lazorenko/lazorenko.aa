--контроллер - запись

create or replace function lazorenko_al.json_record(
    p_ticket_id number,
    p_patient_id number,
    p_need_handle boolean default true,
    p_spec_id number,
    p_doctor_id number,
    p_hospital_id number
)
return clob
as

    v_result integer;
    v_response lazorenko_al.t_record;
    v_json json_object_t:= json_object_t();
    v_json_response json_array_t:= json_array_t();
    v_return_clob clob;

begin

    v_response := lazorenko_al.service_for_records(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id,
        p_need_handle => p_need_handle,
        p_spec_id => p_spec_id,
        p_doctor_id => p_doctor_id,
        p_hospital_id => p_hospital_id,
        out_fail => v_result
    );

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

    return v_return_clob;

end;



--его применение

declare

v_clob clob;

begin

    v_clob := lazorenko_al.json_record(
    33, 1, true, 3, 3, 4);

    dbms_output.put_line(v_clob);

end;


--контроллер - отмена записи

create or replace function lazorenko_al.json_cancel(
    p_ticket_id number,
    p_patient_id number,
    p_hospital_id number
)
return clob
as

    v_result integer;
    v_response lazorenko_al.t_record;
    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_response := lazorenko_al.service_for_cancel(
        p_ticket_id => p_ticket_id,
        p_patient_id => p_patient_id,
        p_hospital_id => p_hospital_id,
        out_fail => v_result
    );

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

    return v_return_clob;

end;


--его примеение

declare

    v_clob clob;

begin

    v_clob := lazorenko_al.json_cancel(33, 3, 4);

    dbms_output.put_line(v_clob);

end;



--контроллер - запрос 1
create or replace function lazorenko_al.json_query_1(
    p_region_id number
)
return clob
as

    v_response lazorenko_al.t_arr_city_with_regions;
    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_response := lazorenko_al.service_for_query_1(
    p_region_id => p_region_id
    );
if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item lazorenko_al.t_city_with_regions :=v_response(i);
    begin
 if v_item.city_id is not null then
    loop
     declare
        v_object json_object_t:= json_object_t();

    begin
        v_object.put('names', v_item.names);
        v_object.put('name', v_item.name);

        v_json_response.append(v_object);
    end;
     end loop;
end if;

     v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;

   end;
  end loop;
    end if;
    return v_return_clob;
end;


--его примеение

declare

    v_clob clob;

begin

    v_clob := lazorenko_al.json_query_1(1);

    dbms_output.put_line(v_clob);

end;