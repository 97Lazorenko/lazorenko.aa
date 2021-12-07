/*
 PARSING
 */

create or replace type lazorenko_al.t_doctor as object(
    doctor_id number,
    hospital_id number,
    name varchar(100),
    fname varchar(50),
    petronymic varchar2(50)
);

create or replace type lazorenko_al.t_arr_doctor as table of lazorenko_al.t_doctor;



--сервис
create or replace function lazorenko_al.service(
    out_result out number
)
return lazorenko_al.t_arr_doctor
as

    v_result integer;
    v_clob clob;
    v_response lazorenko_al.t_arr_doctor := lazorenko_al.t_arr_doctor();

begin

    v_clob := lazorenko_al.repository(
        out_result => v_result
    );


    select lazorenko_al.t_doctor(
        doctor_id => r.id_doctor,
        hospital_id => r.id_hospital,
        name => r.lname,
        fname => r.fname,
        petronymic => r.mname
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            --следите за тем чтобы типы и их размерность
            --совпадали с типами в ваших обьектах
            id_doctor number path '$.id_doctor',
            id_hospital number path '$.id_hospital',
            lname varchar2(100) path '$.lname',
            fname varchar2(100) path '$.fname',
            mname varchar2(100) path '$.mname'
    ))) r;

    out_result := v_result;

    return v_response;

end;
/



declare

    v_result integer;
    v_response lazorenko_al.t_arr_doctor := lazorenko_al.t_arr_doctor();

begin

    v_response := lazorenko_al.service(
        out_result => v_result
    );

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
        declare
            v_item lazorenko_al.t_doctor := v_response(i);
        begin
            dbms_output.put_line('id врача: '||v_item.doctor_id ||'  '||'id больницы: '||v_item.hospital_id||'  '||'ФИО: '|| v_item.name|| ' '||v_item.fname||' '||v_item.petronymic);
        end;
    end loop;
    end if;

end;