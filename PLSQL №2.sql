
--query1

DECLARE
    CURSOR c_get_names
    IS
    select c.name, r.name
from CITY c inner join REGION r USING(region_id);
    v_text LAZORENKO_AL.city.name%TYPE;
    v_text1 LAZORENKO_AL.region.name%TYPE;
BEGIN
    OPEN c_get_names;
    loop
    FETCH c_get_names INTO v_text, v_text1;
    exit when c_get_names%notfound;
    DBMS_OUTPUT.PUT_LINE( v_text ||' - '|| v_text1 );
    end loop;
end;

--query2

DECLARE
    CURSOR c_get_names
    IS
    select distinct s.name
from specialisation s inner join doctor_spec using(spec_id)
    inner join doctor d using(doctor_id)
    inner join hospital h using(hospital_id)
where s.delete_from_the_sys is null and d.dismiss_date is null
                                    and h.delete_from_the_sys is null;
    v_text LAZORENKO_AL.city.name%TYPE;
BEGIN
    OPEN c_get_names;
    loop
    FETCH c_get_names INTO v_text;
    exit when c_get_names%notfound;
    DBMS_OUTPUT.PUT_LINE(v_text);
    end loop;
end;

--query3
DECLARE
    CURSOR c_get_info
    IS
select h.name, a.name, count(doctor_id) as количество_врачей, o.name, w.end_time,
 case
    when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
    else 0
end as сейчас_открыто
from hospital h left join work_time w using(hospital_id)
    inner join ownership_type o using(ownership_type_id)
    inner join doctor using(hospital_id) inner join doctor_spec using(doctor_id)
    inner join available a using(availability_id)
where 2=spec_id and h.delete_from_the_sys is null and w.day in to_char(sysdate, 'd')
group by h.name, a.name, o.name, w.end_time
order by o.name desc, количество_врачей desc, сейчас_открыто desc;
    v_text LAZORENKO_AL.hospital.name%TYPE;
    v1_text LAZORENKO_AL.available.name%TYPE;
    v2_text number;
    v3_text LAZORENKO_AL.ownership_type.name%TYPE;
    v4_text varchar2(200);
    v5_text number;
BEGIN
    OPEN c_get_info;
    loop
    FETCH c_get_info INTO v_text, v1_text, v2_text, v3_text, v4_text, v5_text;
    exit when c_get_info%notfound;
    DBMS_OUTPUT.PUT_LINE(v_text || ' '|| v1_text||' ' || v2_text ||' '|| v3_text || ' ' || v4_text || ' ' || v5_text);
    end loop;
end;

--query4

DECLARE
    CURSOR c_get_info
    IS
    select d.name, s.name, di.qualification,
case
     when d.zone_id=2 then 1 --участок пациента с zone_id=2
     else 0
end as участок_пациента
from doctor d inner join doctor_spec using(doctor_id)
    inner join specialisation s using(spec_id)
    inner join doctors_info di using(doctor_id)
    inner join hospital using(hospital_id)
where 5 = hospital_id and d.dismiss_date is null
order by di.qualification desc, участок_пациента desc;
    v_text LAZORENKO_AL.doctor.name%TYPE;
    v_text1 LAZORENKO_AL.specialisation.name%TYPE;
    v_text2 LAZORENKO_AL.doctors_info.qualification%type;
    v_text3 number;
BEGIN
    OPEN c_get_info;
    loop
    FETCH c_get_info INTO v_text, v_text1, v_text2, v_text3;
    exit when c_get_info%notfound;
    DBMS_OUTPUT.PUT_LINE( v_text ||' - '|| v_text1 || ' ' || v_text2 || ' ' || v_text3);
    end loop;
end;

--query5
DECLARE
    CURSOR c_get_info
    IS
    select t.ticket_id, t.appointment_beg, t.appointment_end
from ticket t
where 3=doctor_id
  and t.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
order by t.appointment_beg;
    v_text LAZORENKO_AL.ticket.ticket_id%TYPE;
    v_text1 LAZORENKO_AL.ticket.appointment_beg%TYPE;
    v_text2 LAZORENKO_AL.ticket.appointment_end%type;
BEGIN
    OPEN c_get_info;
    loop
    FETCH c_get_info INTO v_text, v_text1, v_text2;
    exit when c_get_info%notfound;
    DBMS_OUTPUT.PUT_LINE( v_text ||' - '|| v_text1 || ' ' || v_text2);
    end loop;
end;