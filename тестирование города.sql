


--нейминг test_имя-тестируемого-обьекта
create or replace package lazorenko_al.test_pkg_city
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
    procedure get_by_id;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_by_id;

end;
/

create or replace package body lazorenko_al.test_pkg_city
as
    is_debug boolean := true;

    mock_id_city number;
    mock_names varchar2(100);
    mock_id_region number;
    --

    procedure get_by_id
    as
        v_cities lazorenko_al.t_arr_city_with_regions;
begin
    v_cities := lazorenko_al.pkg_city_repository.get_cities_regions_with_own_type(
         mock_id_region);
     if v_cities.count>0 then
    for i in v_cities.first..v_cities.last
    loop
    declare
        v_item lazorenko_al.t_city_with_regions :=v_cities(i);
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
     v_cities := lazorenko_al.pkg_city_repository.get_cities_regions_with_own_type(
         mock_id_region);
    TOOL_UT3.UT.EXPECT(v_item.names).TO_EQUAL(mock_names);
    end;
    end loop;
    end if;

end;


    procedure failed_get_by_id
    as
        v_cities lazorenko_al.t_arr_city_with_regions;
    begin

        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
     v_cities := lazorenko_al.pkg_city_repository.get_cities_regions_with_own_type(
         -1);
    end;
    --

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_names := '1';
        mock_id_region := 5;


        insert into lazorenko_al.city(
            names,
            region_id
        )
        values (
            mock_names,
            mock_id_region
        )
        returning city_id into mock_id_city;
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