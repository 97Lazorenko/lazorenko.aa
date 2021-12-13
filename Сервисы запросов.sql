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

