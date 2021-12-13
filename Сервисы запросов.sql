--сервис с запросом 1
create or replace function lazorenko_al.service_for_query_1(
    p_region_id number
)
return lazorenko_al.t_arr_city_with_regions
as
    arr_city_with_regions lazorenko_al.t_arr_city_with_regions:=lazorenko_al.t_arr_city_with_regions();
begin
     arr_city_with_regions := lazorenko_al.pkg_city_repository.get_cities_regions_with_own_type(
         p_region_id => p_region_id);

    if arr_city_with_regions.count>0 then
    for i in arr_city_with_regions.first..arr_city_with_regions.last
    loop
    declare
        v_item lazorenko_al.t_city_with_regions :=arr_city_with_regions(i);
    begin
        dbms_output.put_line(v_item.names || ' - ' || v_item.name);
    end;
    end loop;
    end if;
return arr_city_with_regions;
end;

--его применение
declare
    v_arr_city_with_regions lazorenko_al.t_arr_city_with_regions;
begin
    v_arr_city_with_regions:=lazorenko_al.service_for_query_1(
    1
);
end;



--сервис с запросом 2
create or replace function lazorenko_al.service_for_query_2(
    p_doctor_id in number default null,
    p_hospital_id in number default null
)
return lazorenko_al.t_arr_specs
as
    arr_specs lazorenko_al.t_arr_specs :=lazorenko_al.t_arr_specs();

begin
    arr_specs:=lazorenko_al.pkg_specialisations_repository.get_specs_with_own_types(
        p_doctor_id => p_doctor_id,
        p_hospital_id => p_hospital_id
        );
    if arr_specs.count>0 then
    for i in arr_specs.first..arr_specs.last
    loop
    declare
        v_item lazorenko_al.t_specs :=arr_specs(i);
    begin
        dbms_output.put_line(v_item.name);
    end;
    end loop;
    end if;
    return arr_specs;
end;

--его применение
declare
    v_arr_specs lazorenko_al.t_arr_specs;
begin
    v_arr_specs:=lazorenko_al.service_for_query_2(
    null, 4
);
end;

--сервис с запросом 3
create or replace function lazorenko_al.service_for_query_3(
    p_spec_id number
)
return lazorenko_al.t_arr_hospital_info
as
    arr_hospital_info lazorenko_al.t_arr_hospital_info:=lazorenko_al.t_arr_hospital_info();

begin
    arr_hospital_info :=lazorenko_al.pkg_hospital_repository.get_hospitals_with_own_types(
        p_spec_id => p_spec_id
        );
    if arr_hospital_info.count>0 then
    for i in arr_hospital_info.first..arr_hospital_info.last
    loop
    declare
        v_item lazorenko_al.t_hospital_info := arr_hospital_info(i);
    begin
        dbms_output.put_line('название больницы - ' || v_item.hname || '; сейчас '|| v_item.aname ||'; число докторов указанной специальности=' || v_item.doctor_id
                                 ||chr(10)||'; форма собственности - '|| v_item.ownership_type || '; закрывается в ' || v_item.end_time);
    end;
    end loop;
    end if;
    return arr_hospital_info;
end;

--его применение
declare
    v_arr_hospital_info lazorenko_al.t_arr_hospital_info;
begin
    v_arr_hospital_info:=lazorenko_al.service_for_query_3(
    3
);
end;


--сервис с запросом 4
create or replace function lazorenko_al.service_for_query_4(
    p_hospital_id number,
    p_zone_id number
)
return lazorenko_al.t_arr_doctors_detailed
as
    arr_doctors_detailed lazorenko_al.t_arr_doctors_detailed:=lazorenko_al.t_arr_doctors_detailed();

begin
    arr_doctors_detailed :=lazorenko_al.pkg_doctor_repository.get_doctor_with_own_types(
        p_hospital_id => p_hospital_id,
        p_zone_id => p_zone_id
        );
    if arr_doctors_detailed.count>0 then
    for i in arr_doctors_detailed.first..arr_doctors_detailed.last
    loop
    declare
        v_item lazorenko_al.t_doctors_detailed := arr_doctors_detailed(i);
    begin
        dbms_output.put_line('ФИО врача - ' || v_item.dname ||'; специальность - '|| v_item.sname || '; квалификация - ' || v_item.qualification);
    end;
    end loop;
    end if;
    return arr_doctors_detailed;
end;

--его применение
declare
    v_arr_doctors_detailed lazorenko_al.t_arr_doctors_detailed;
begin
    v_arr_doctors_detailed:=lazorenko_al.service_for_query_4(
    7, 1
);
end;

--сервис с запросом 5
create or replace function lazorenko_al.service_for_query_5(
    p_doctor_id number
)
return lazorenko_al.t_arr_ticket
as
    arr_ticket lazorenko_al.t_arr_ticket:=lazorenko_al.t_arr_ticket();

begin
    arr_ticket :=lazorenko_al.pkg_ticket_repository.get_ticket_with_own_types(
       p_doctor_id => p_doctor_id
        );
    if  arr_ticket.count>0 then
    for i in  arr_ticket.first.. arr_ticket.last
    loop
    declare
        v_item lazorenko_al.t_ticket1 :=  arr_ticket(i);
    begin
        dbms_output.put_line('id талона - ' ||v_item.ticket_id || '; врач - ' || v_item.name ||'; начало приёма - '||
                             v_item.appointment_beg || '; конец приёма - ' || v_item.appointment_end);
    end;
    end loop;
    end if;
    return arr_ticket;
end;

--его применение
declare
    v_arr_ticket lazorenko_al.t_arr_ticket;
begin
    v_arr_ticket:=lazorenko_al.service_for_query_5(
    3
);
end;

--сервис с запросом 6
create or replace function lazorenko_al.service_for_query_6(
    p_patient_id in number default null,
    p_record_stat_id in number default null
)
return lazorenko_al.t_arr_records
as
    arr_records lazorenko_al.t_arr_records:=lazorenko_al.t_arr_records();

begin
    arr_records :=lazorenko_al.pkg_records_repository.get_records_with_own_types(
        p_patient_id => p_patient_id,
        p_record_stat_id => p_record_stat_id
        );
    if  arr_records.count>0 then
    for i in  arr_records.first.. arr_records.last
    loop
    declare
        v_item lazorenko_al.t_records :=  arr_records(i);
    begin
        dbms_output.put_line('-пациент - '||v_item.last_name ||' '|| v_item.first_name || ' '|| v_item.petronymic
                                 || '; врач - ' || v_item.name || '; статус записи - ' || v_item.rname ||chr(10)||'; начало приёма - '
                                 || v_item.appointment_beg || '; конец приёма - ' || v_item.appointment_end);
    end;
    end loop;
    end if;
    return arr_records;
end;

--его применение
declare
    v_arr_records lazorenko_al.t_arr_records;
begin
    v_arr_records:=lazorenko_al.service_for_query_6(
    null, 2
);
end;