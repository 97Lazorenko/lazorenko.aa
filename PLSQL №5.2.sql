create or replace function get_doctors_spec2(
    p_spec_id in number)
return varchar2 as v_text varchar2(300);
begin
    for i in
        (select h.name hn, a.name an, count(d.doctor_id) as количество_врачей,
    case
        when o.ownership_type_id=1 then 'частная'
        when o.ownership_type_id=2 then 'государственная'
        end as форма_собственности,
    case
        when w.end_time is null then ' - '
        else w.end_time
        end as закрытие

    from hospital h left join work_time w on h.hospital_id=w.hospital_id
    inner join ownership_type o on h.ownership_type_id=o.ownership_type_id
    inner join doctor d on d.hospital_id=h.hospital_id
    inner join doctor_spec ds on d.doctor_id=ds.doctor_id
    inner join available a on h.availability_id=a.availability_id

    where (spec_id=p_spec_id or p_spec_id is null) and h.delete_from_the_sys is null
           and w.day=to_char(sysdate, 'd')

    group by h.name, a.name, o.ownership_type_id, w.end_time
    order by case
             when o.ownership_type_id=lazorenko_al.pkg_query_3.c_ownership_type then 1
             else 0 end desc, количество_врачей desc,
             case
             when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
             else 0
             end desc)
    loop
        dbms_output.put_line('название больницы - ' || i.hn || '; сейчас '|| i.an
                                           ||'; число докторов указанной специальности=' || i.количество_врачей ||
                                            chr(10)||
                                           '; форма собственности - '|| i.форма_собственности || '; закрывается в ' || i.закрытие);
    end loop;
    return v_text;
    end;

--ЕЁ ПРОБА
declare
v_text varchar2(300);
begin
v_text:=lazorenko_al.get_doctors_spec2(2);
dbms_output.put_line(v_text);
end;


--ПАКЕТ ДЛЯ ЗАПРСА 3
create or replace package lazorenko_al.pkg_query_3_v_2
as
    c_ownership_type constant number := 1;

    function get_doctors_spec2(
    p_spec_id in number)
    return varchar2;

end;

--ЕГО ТЕЛО
create or replace package body lazorenko_al.pkg_query_3_v_2
as
    function get_doctors_spec2(
    p_spec_id in number)
    return varchar2 as v_text varchar2(300);
    begin
    for i in (select h.name hn, a.name an, count(d.doctor_id) as количество_врачей,
    case
        when o.ownership_type_id=1 then 'частная'
        when o.ownership_type_id=2 then 'государственная'
        end as форма_собственности,
    case
        when w.end_time is null then ' - '
        else w.end_time
        end as закрытие

    from hospital h left join work_time w on h.hospital_id=w.hospital_id
    inner join ownership_type o on h.ownership_type_id=o.ownership_type_id
    inner join doctor d on d.hospital_id=h.hospital_id
    inner join doctor_spec ds on d.doctor_id=ds.doctor_id
    inner join available a on h.availability_id=a.availability_id

    where (spec_id=p_spec_id or p_spec_id is null) and h.delete_from_the_sys is null
           and w.day=to_char(sysdate, 'd')

    group by h.name, a.name, o.ownership_type_id, w.end_time
    order by case
             when o.ownership_type_id=lazorenko_al.pkg_query_3.c_ownership_type then 1
             else 0 end desc, количество_врачей desc,
             case
             when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
             else 0
             end desc)
    loop
        dbms_output.put_line('название больницы - ' || i.hn || '; сейчас '|| i.an
                                           ||'; число докторов указанной специальности=' || i.количество_врачей ||
                                            chr(10)||
                                           '; форма собственности - '|| i.форма_собственности || '; закрывается в ' || i.закрытие);
    end loop;
    return v_text;
    end;
end;

--ЕГО ПРОБА
declare
v_text varchar2(400);
begin
v_text:=lazorenko_al.pkg_query_3_v_2.get_doctors_spec2(1);
dbms_output.put_line(v_text);
end;