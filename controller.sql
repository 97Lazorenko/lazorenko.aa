
--контроллер

create or replace function lazorenko_al.controller_for_doctors
return clob
as

    v_result integer;
    v_response lazorenko_al.t_arr_doctor := lazorenko_al.t_arr_doctor();
    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_response := lazorenko_al.service_for_doctors(
        out_result => v_result
    );

    --в идеале это нужно обернуть в так называемые resource
    --чтобы переиспользовать сериализацию
    v_json.put('code', v_result);

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item lazorenko_al.t_doctor := v_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_doctor', v_item.doctor_id);
        v_object.put('id_hospital', v_item.hospital_id);
        v_object.put('lname', v_item.name);
        v_object.put('fname', v_item.fname);
        v_object.put('mname', v_item.petronymic);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;

end;




--применение
declare

    v_clob clob;

begin

    v_clob := lazorenko_al.controller_for_record();

    dbms_output.put_line(v_clob);

end;
