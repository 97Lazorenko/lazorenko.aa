---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------- СТАТИЧЕСКИЕ КУРСОРЫ
---------------------------------------------------------------------------------------------------------------------------------------------------
--query1

DECLARE
    v_region_id number :=1;
    CURSOR c_get_names
    IS
    select c.name, r.name
from lazorenko_al.city c inner join lazorenko_al.region r USING(region_id)
    where v_region_id=region_id;
    type record1 is record (cname varchar2(100), rname varchar2(100));
    v_city_region record1;
BEGIN
    OPEN c_get_names;
    loop
    FETCH c_get_names INTO v_city_region;
    exit when c_get_names%notfound;
    DBMS_OUTPUT.PUT_LINE( v_city_region.cname ||' - '|| v_city_region.rname);
    end loop;
end;

--query2

DECLARE
    v_hospital_id number :=6;
    CURSOR c_get_names
    IS
    select distinct s.name
from specialisation s inner join doctor_spec using(spec_id)
    inner join doctor d using(doctor_id)
    inner join hospital h using(hospital_id)
where s.delete_from_the_sys is null and d.dismiss_date is null
and h.delete_from_the_sys is null and v_hospital_id=hospital_id;
    v_spec_name LAZORENKO_AL.specialisation.name%TYPE;
BEGIN
    OPEN c_get_names;
    loop
    FETCH c_get_names INTO v_spec_name;
    exit when c_get_names%notfound;
    DBMS_OUTPUT.PUT_LINE(v_spec_name);
    end loop;
end;

--query3
DECLARE
    v_spec_id number :=2;
    CURSOR c_get_info
    IS
select h.name, a.name, count(doctor_id) as количество_врачей, o.name,
case
    when w.end_time is null then ' - '
    else w.end_time
end as закрытие
from hospital h left join work_time w using(hospital_id)
    inner join ownership_type o using(ownership_type_id)
    inner join doctor using(hospital_id) inner join doctor_spec using(doctor_id)
    inner join available a using(availability_id)
where spec_id=v_spec_id and h.delete_from_the_sys is null and w.day in to_char(sysdate, 'd')
group by h.name, a.name, o.name, w.end_time
order by o.name desc, количество_врачей desc, case
    when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
    else 0
end desc;
    type record1 is record (hname varchar2(100), aname varchar2(100), doctor_count number, oname varchar2(100), end_time varchar2(100));
    v_hospital_time record1;
BEGIN
    OPEN c_get_info;
    loop
    FETCH c_get_info INTO v_hospital_time;
    exit when c_get_info%notfound;
    DBMS_OUTPUT.PUT_LINE('название больницы - ' || v_hospital_time.hname || '; сейчас '|| v_hospital_time.aname||'; число докторов указанной специальности='
                             || v_hospital_time.doctor_count ||'; форма собственности - '|| v_hospital_time.oname || '; закрывается в ' || v_hospital_time.end_time);
    end loop;
end;

--query4

DECLARE
    v_hospital_id number :=5;
    v_zone_id number :=2;
    CURSOR c_get_info
    IS
    select d.name, s.name, di.qualification
from doctor d inner join doctor_spec using(doctor_id)
    inner join specialisation s using(spec_id)
    inner join doctors_info di using(doctor_id)
    inner join hospital using(hospital_id)
where hospital_id=v_hospital_id and d.dismiss_date is null
order by di.qualification desc,
     case
     when d.zone_id=v_zone_id then 1
     else 0 end desc;
    type record1 is record (dname varchar2(100), spname varchar2(100), qualification number);
    v_doctor record1;
BEGIN
    OPEN c_get_info;
    loop
    FETCH c_get_info INTO v_doctor;
    exit when c_get_info%notfound;
    DBMS_OUTPUT.PUT_LINE('ФИО врача - ' || v_doctor.dname ||'; специальность - '|| v_doctor.spname || '; квалификация - ' || v_doctor.qualification);
    end loop;
end;

--query5
DECLARE
    v_doctor_id number :=3;
    CURSOR c_get_info
    IS
    select t.ticket_id, d.name, t.appointment_beg, t.appointment_end
    from ticket t right join doctor d using(doctor_id)
    where doctor_id=v_doctor_id
    and t.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
    order by t.appointment_beg;
    type record1 is record (ticket_id number, dname varchar2(100), appointment_beg varchar2(100), appointment_end varchar2(100));
    v_ticket record1;
    BEGIN
        OPEN c_get_info;
        loop
        FETCH c_get_info INTO v_ticket;
        exit when c_get_info%notfound;
        DBMS_OUTPUT.PUT_LINE('id талона - ' ||v_ticket.ticket_id || '; врач - ' ||v_ticket.dname ||'; начало приёма - '||
                             v_ticket.appointment_beg || '; конец приёма - ' || v_ticket.appointment_end);
        end loop;
    end;

--query 6
DECLARE
    v_doc number :=1;
    type record1 is record (last_name varchar2(100), first_name varchar2(100),
    petronymic varchar2(100), name varchar2(100), value varchar2(100));
    v_patient record1;
    CURSOR c_get_names
    IS
    select p.last_name, p.first_name, p.petronymic, d.name,
    case
    when dn.value is null then 'не указано'
    else dn.value
end as документ
from lazorenko_al.patient p inner join lazorenko_al.documents_numbers dn using(patient_id)
    right join lazorenko_al.documents d using(document_id)
    where document_id=v_doc;
BEGIN
    OPEN c_get_names;
    loop
    FETCH c_get_names INTO v_patient;
    exit when c_get_names%notfound;
    DBMS_OUTPUT.PUT_LINE('ФИ(О) пациента - ' ||v_patient.last_name ||' '|| v_patient.first_name
                         || ' ' || v_patient.petronymic || '; документ - ' || v_patient.name || '; значение - ' || v_patient.value);
    end loop;
end;





--query 7

DECLARE
    v_hospital_id number :=10;
    CURSOR c_get_info
    IS
select
case
    when w.day=1 then 'понедельник'
    when w.day=2 then 'вторник    '
    when w.day=3 then 'среда      '
    when w.day=4 then 'четверг    '
    when w.day=5 then 'пятница    '
    when w.day=6 then 'суббота    '
    when w.day=7 then 'воскресенье'
end as день_недели,
case
    when w.begin_time is null then 'не указано'
    else w.begin_time
end as время_открытия,
case
    when w.end_time is null then 'не указано'
    else w.end_time
end as время_закрытия
from hospital h left join work_time w using(hospital_id) inner join available a using(availability_id)
where hospital_id=v_hospital_id and h.delete_from_the_sys is null
order by w.day;
    type record1 is record (day varchar2(50), begin_time varchar2(100), end_time varchar2(100));
    v_record_beg_end record1;
BEGIN
    OPEN c_get_info;
    loop
    FETCH c_get_info INTO v_record_beg_end;
    exit when c_get_info%notfound;
    DBMS_OUTPUT.PUT_LINE(v_record_beg_end.day || '  ' || 'время открытия - ' || v_record_beg_end.begin_time || '; ' || 'время закрытия - ' || v_record_beg_end.end_time);
    end loop;
end;

--query 8

DECLARE
    v_pat_id number :=1; --есть 3 пацента, их id варьируются от 1 до 3 включительно;
    v_record_stat number :=1; --1 - действующая запись, 2 - отменённая запись, 3 - исполненная запись;
    type record1 is record(last_name varchar2(100), first_name varchar2(100),
    petronymic varchar2(100), dname varchar2(100), rec_stat varchar2(50), appointment_beg varchar2(100), appointment_end varchar2(100));
    v_patient record1;
    CURSOR c_get_names
    IS
    select last_name, first_name, petronymic, d.name, record_status.name, appointment_beg, appointment_end
from lazorenko_al.patient p left join lazorenko_al.records using(patient_id) inner join record_status using(record_stat_id) inner join ticket using(ticket_id)
    inner join lazorenko_al.doctor d using(doctor_id)
    where patient_id=v_pat_id and record_stat_id=v_record_stat;
BEGIN
    OPEN c_get_names;
    loop
    FETCH c_get_names INTO v_patient;
    exit when c_get_names%notfound;
    DBMS_OUTPUT.PUT_LINE('пациент - '|| v_patient.last_name ||' '|| v_patient.first_name || ' ' || v_patient.petronymic || '; врач - ' ||
                          v_patient.dname || '; статус записи - ' || v_patient.rec_stat || '; начало приёма - '
                             || v_patient.appointment_beg || '; конец приёма - ' || v_patient.appointment_end);
    end loop;
end;

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------- С ПАРАМЕТРАМИ
---------------------------------------------------------------------------------------------------------------------------------------------------