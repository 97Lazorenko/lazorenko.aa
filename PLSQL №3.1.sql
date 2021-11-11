-----------------------------------------------------------------------------------------------------------------------
------------------------------------------ЗАДАНИЕ №1-------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

--ЗАПРОС 1 - ФУНКЦИЯ
create or replace function lazorenko_al.get_cities_regions(
p_region_id in number default null)
return sys_refcursor
as
    v_cursor_1 sys_refcursor;
begin
open v_cursor_1 for
    select c.name, r.name
    from lazorenko_al.city c inner join lazorenko_al.region r USING(region_id)
    where p_region_id=region_id or p_region_id is null;

return v_cursor_1;
end;

declare
    type record1 is record (cname varchar2(100), rname varchar2(100));
    v_city_region record1;
    v_cursor_1 sys_refcursor;
begin
    v_cursor_1 :=lazorenko_al.get_cities_regions();
    loop
    FETCH v_cursor_1 INTO v_city_region;
    exit when v_cursor_1%notfound;
    DBMS_OUTPUT.PUT_LINE( v_city_region.cname ||' - '|| v_city_region.rname);
    end loop;
    close v_cursor_1;
end;

--ЗАПРОС 1 - ПРОЦЕДУРА
create or replace procedure lazorenko_al.get_get_cities_regions(
    p_region_id in number,
    out_cursor out sys_refcursor)
as
begin
    open out_cursor for
    select c.name, r.name
    from lazorenko_al.city c inner join lazorenko_al.region r USING(region_id)
    where p_region_id=region_id or p_region_id is null;
end;

declare
    v_cursor sys_refcursor;
    type record1 is record (cname varchar2(100), rname varchar2(100));
    v_city_region record1;
begin
    lazorenko_al.get_get_cities_regions(2, v_cursor);
    loop
        fetch v_cursor into v_city_region;
        exit when v_cursor%notfound;
        dbms_output.put_line (v_city_region.cname ||' - '|| v_city_region.rname);
    end loop;
    close v_cursor;
end;

--ЗАПРОС 2 - ФУНКЦИЯ

create or replace function lazorenko_al.get_specs(p_hospital_id in number default null)
return sys_refcursor as
    v_cursor_1 sys_refcursor;
begin
open v_cursor_1 for
    select distinct s.name

    from specialisation s inner join doctor_spec using(spec_id)
    inner join doctor d using(doctor_id)
    inner join hospital h using(hospital_id)

    where s.delete_from_the_sys is null and d.dismiss_date is null and h.delete_from_the_sys is null
          and (p_hospital_id=hospital_id or p_hospital_id is null);

return v_cursor_1;
end;

declare
    type record2 is record (spec_name varchar2(50));
    v_spec_name record2;
    v_cursor_1 sys_refcursor;
begin
    v_cursor_1 :=lazorenko_al.get_specs();
    loop
    FETCH v_cursor_1 INTO v_spec_name;
    exit when v_cursor_1%notfound;
    DBMS_OUTPUT.PUT_LINE( v_spec_name.spec_name);
    end loop;
    close v_cursor_1;
end;

--ЗАПРОС 2 - ПРОЦЕДУРА
create or replace procedure lazorenko_al.get_get_specs(
    p_hospital_id in number,
    out_cursor out sys_refcursor)
as
begin
open out_cursor for
    select distinct s.name

    from specialisation s inner join doctor_spec using(spec_id)
    inner join doctor d using(doctor_id)
    inner join hospital h using(hospital_id)

    where s.delete_from_the_sys is null and d.dismiss_date is null and h.delete_from_the_sys is null
          and (p_hospital_id=hospital_id or p_hospital_id is null);
end;

declare
    v_cursor sys_refcursor;
    type record2 is record (spec_name varchar2(50));
    v_spec_name record2;
begin
    lazorenko_al.get_get_specs(7,v_cursor);
    loop
        fetch v_cursor into v_spec_name;
        exit when v_cursor%notfound;
        dbms_output.put_line (v_spec_name.spec_name);
    end loop;
    close v_cursor;
end;

--ЗАПРОС 3 - ПРОЦЕДУРА
create or replace procedure lazorenko_al.get_doctors_specs(
    p_spec_id in number,
    out_cursor out sys_refcursor)
as
begin
open out_cursor for
    select h.name, a.name, count(d.doctor_id) as количество_врачей,
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
             when o.ownership_type_id=1 then 1
             else 0 end desc, количество_врачей desc,
             case
             when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
             else 0
             end desc;
end;

declare
    v_cursor sys_refcursor;
    type record3 is record (hname varchar2(100), aname varchar2(100), doctor_count number, oname varchar2(100), end_time varchar2(100));
    v_hospital_time record3;
begin
    lazorenko_al.get_doctors_specs(4,v_cursor);
    loop
        fetch v_cursor into v_hospital_time;
        exit when v_cursor%notfound;
        dbms_output.put_line ('название больницы - ' || v_hospital_time.hname || '; сейчас '|| v_hospital_time.aname
                             ||'; число докторов указанной специальности=' || v_hospital_time.doctor_count ||
                         '; форма собственности - '|| v_hospital_time.oname || '; закрывается в ' || v_hospital_time.end_time);
    end loop;
    close v_cursor;
end;

--ЗАПРОС 4 - ФУНКЦИЯ

create or replace function lazorenko_al.get_doctor(
    p_hospital_id in number,
    p_zone_id in number)
return sys_refcursor
as
    v_cursor_1 sys_refcursor;
begin
open v_cursor_1 for
    select d.name, s.name, di.qualification

    from doctor d inner join doctor_spec using(doctor_id)
    inner join specialisation s using(spec_id)
    inner join doctors_info di using(doctor_id)
    inner join hospital using(hospital_id)

    where (hospital_id=p_hospital_id or p_hospital_id is null) and d.dismiss_date is null

    order by di.qualification desc,
             case
             when d.zone_id=p_zone_id then 1
             else 0 end desc;

return v_cursor_1;
end;

declare
    type record4 is record (dname varchar2(100), spname varchar2(100), qualification number);
    v_doctor record4;
    v_cursor_1 sys_refcursor;
begin
    v_cursor_1 :=lazorenko_al.get_doctor(6, 2);
    loop
    FETCH v_cursor_1 INTO v_doctor;
    exit when v_cursor_1%notfound;
    DBMS_OUTPUT.PUT_LINE( 'ФИО врача - ' || v_doctor.dname ||'; специальность - '||
                          v_doctor.spname || '; квалификация - ' || v_doctor.qualification);
    end loop;
    close v_cursor_1;
end;

--ЗАПРОС 5 - ПРОЦЕДУРА
create or replace procedure lazorenko_al.get_ticket(
    v_doctor_id in number,
    out_cursor out sys_refcursor)
as
begin
open out_cursor for
    select t.ticket_id, d.name, t.appointment_beg, t.appointment_end
    from ticket t right join doctor d using(doctor_id)
    where (doctor_id=v_doctor_id or v_doctor_id is null) and t.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
    order by t.appointment_beg;
end;

declare
    v_cursor sys_refcursor;
    type record5 is record (ticket_id number, dname varchar2(100), appointment_beg varchar2(100), appointment_end varchar2(100));
    v_ticket record5;
begin
    lazorenko_al.get_ticket(4,v_cursor);
    loop
        fetch v_cursor into v_ticket;
        exit when v_cursor%notfound;
        dbms_output.put_line ('id талона - ' ||v_ticket.ticket_id || '; врач - ' ||v_ticket.dname ||'; начало приёма - '||
                             v_ticket.appointment_beg || '; конец приёма - ' || v_ticket.appointment_end);
    end loop;
    close v_cursor;
end;

--ЗАПРОС 6 - ФУНКЦИЯ

create or replace function lazorenko_al.get_documents(
    p_document_id in number default null)
return sys_refcursor
as
    v_cursor_1 sys_refcursor;
begin
open v_cursor_1 for
    select p.last_name, p.first_name, p.petronymic, d.name,
    case
           when dn.value is null then 'не указано'
           else dn.value
           end as документ

    from lazorenko_al.patient p inner join lazorenko_al.documents_numbers dn using(patient_id)
    right join lazorenko_al.documents d using(document_id)

    where document_id=p_document_id or p_document_id is null
    order by p.last_name;

return v_cursor_1;
end;

declare
    type record6 is record (last_name varchar2(100), first_name varchar2(100),
    petronymic varchar2(100), name varchar2(100), value varchar2(100));
    v_patient record6;
    v_cursor_1 sys_refcursor;
begin
    v_cursor_1 :=lazorenko_al.get_documents();
    loop
    FETCH v_cursor_1 INTO v_patient;
    exit when v_cursor_1%notfound;
    DBMS_OUTPUT.PUT_LINE( 'ФИ(О) пациента - ' ||v_patient.last_name ||' '|| v_patient.first_name
                         || ' ' || v_patient.petronymic || '; документ - ' || v_patient.name || '; значение - ' || v_patient.value);
    end loop;
    close v_cursor_1;
end;

--ЗАПРОС 7 - ПРОЦЕДУРА
create or replace procedure lazorenko_al.get_worktime(
    p_hospital_id in number,
    out_cursor out sys_refcursor)
as
begin
open out_cursor for
    select h.name,
    case w.day
           when 1 then 'понедельник'
           when 2 then 'вторник    '
           when 3 then 'среда      '
           when 4 then 'четверг    '
           when 5 then 'пятница    '
           when 6 then 'суббота    '
           when 7 then 'воскресенье'
           end as день_недели,
    case
           when w.begin_time is null then 'не указано'
           else w.begin_time
           end as время_открытия,
    case
           when w.end_time is null then 'не указано'
           else w.end_time
           end as время_закрытия

    from hospital h left join work_time w using(hospital_id)
    inner join available a using(availability_id)

    where (hospital_id=p_hospital_id or p_hospital_id is null) and h.delete_from_the_sys is null
    order by w.day, h.name;
end;

declare
    v_cursor sys_refcursor;
    type record7 is record (name varchar2(100), day varchar2(50), begin_time varchar2(100), end_time varchar2(100));
    v_record_beg_end record7;
begin
    lazorenko_al.get_worktime(5,v_cursor);
    loop
        fetch v_cursor into v_record_beg_end;
        exit when v_cursor%notfound;
        dbms_output.put_line ('название мед.учреждения - '|| v_record_beg_end.name||' '||v_record_beg_end.day
                                  || '  ' || 'время открытия - ' || v_record_beg_end.begin_time || '; время закрытия - '
                                  || v_record_beg_end.end_time);
    end loop;
    close v_cursor;
end;

--ЗАПРОС 8 - ФУНКЦИЯ
create or replace function lazorenko_al.get_records(
    p_patient_id in number default null,
    p_record_stat_id in number default null)
return sys_refcursor as
    v_cursor_1 sys_refcursor;
begin
open v_cursor_1 for
    select last_name, first_name, petronymic, d.name, record_status.name, appointment_beg, appointment_end
    from lazorenko_al.patient p left join lazorenko_al.records using(patient_id)
    inner join record_status using(record_stat_id)
    inner join ticket using(ticket_id)
    inner join lazorenko_al.doctor d using(doctor_id)

    where (patient_id=p_patient_id or p_patient_id is null) and (record_stat_id=p_record_stat_id or p_record_stat_id is null);

return v_cursor_1;
end;

declare
type record8 is record(last_name varchar2(100), first_name varchar2(100),
    petronymic varchar2(100), dname varchar2(100), rec_stat varchar2(50), appointment_beg varchar2(100), appointment_end varchar2(100));
    v_patient record8;
    v_cursor_1 sys_refcursor;
begin
    v_cursor_1 :=lazorenko_al.get_records();
    loop
    FETCH v_cursor_1 INTO v_patient;
    exit when v_cursor_1%notfound;
    DBMS_OUTPUT.PUT_LINE( 'пациент - '|| v_patient.last_name ||' '|| v_patient.first_name || ' ' || v_patient.petronymic
    || '; врач - ' || v_patient.dname || '; статус записи - ' || v_patient.rec_stat || '; начало приёма - '
    || v_patient.appointment_beg || '; конец приёма - ' || v_patient.appointment_end);
    end loop;
    close v_cursor_1;
end;
