--репозиторий городов
create or replace package lazorenko_al.pkg_city_repository
as
    function get_cities_regions_with_own_type(
    p_region_id in number default null
    )
    return lazorenko_al.t_arr_city_with_regions;
end;

create or replace package body lazorenko_al.pkg_city_repository
as
    function get_cities_regions_with_own_type(
    p_region_id in number default null
    )
    return lazorenko_al.t_arr_city_with_regions
    as
    arr_city_with_regions lazorenko_al.t_arr_city_with_regions:=lazorenko_al.t_arr_city_with_regions();

    e_no_city exception;
    pragma exception_init (e_no_city, -20388);

    begin

        select lazorenko_al.t_city_with_regions(
            city_id => c.city_id,
            names => c.names,
            region_id => c.region_id,
            name =>r.name)
        bulk collect into arr_city_with_regions

        from lazorenko_al.city c
        inner join lazorenko_al.region r on c.region_id=r.region_id

        where p_region_id=c.region_id
          or p_region_id is null;

        if arr_city_with_regions.first is null then
        raise_application_error (-20388, 'Неверно указан регион');
        end if;

    return arr_city_with_regions;

    end;

end;


--репозиторий врача

create or replace package lazorenko_al.pkg_doctor_repository
as

    function not_deleted_doctor_check(
    p_doctor_id in number
    )
    return boolean;

    function get_doctor_with_own_types(
    p_hospital_id in number,
    p_zone_id in number
    )
    return lazorenko_al.t_arr_doctor_detailed;

end;


create or replace package body lazorenko_al.pkg_doctor_repository
as
    function not_deleted_doctor_check(
    p_doctor_id in number
    )
    return boolean
    as
    v_count number;

    e_deleted_doctor exception;
    pragma exception_init (e_deleted_doctor, -20390);

        begin
        select count(*)
        into v_count
        from lazorenko_al.doctor d
        where d.doctor_id=p_doctor_id and d.dismiss_date is null;

        if v_count=0 then
         raise_application_error (-20390, 'доктор удалён или отсутствует в базе');
        end if;

    return v_count>0;

    exception

        when e_deleted_doctor then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","doctor_id":"' || p_doctor_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('доктор удалён или отсутствует в базе');

    return false;

    end;

    function get_doctor_with_own_types(
    p_hospital_id in number,
    p_zone_id in number
    )
    return lazorenko_al.t_arr_doctor_detailed
    as
    arr_doctors_detailed lazorenko_al.t_arr_doctor_detailed:=lazorenko_al.t_arr_doctor_detailed();

    e_no_doctor exception;
    pragma exception_init (e_no_doctor, -20660);

    begin

        select lazorenko_al.t_doctor_detailed(
            dname => d.name,
            sname => s.name,
            qualification => di.qualification)
        bulk collect into arr_doctors_detailed
        from doctor d inner join doctor_spec using(doctor_id)
        inner join specialisation s using(spec_id)
        inner join doctors_info di using(doctor_id)
        inner join hospital using(hospital_id)

        where (hospital_id=p_hospital_id or p_hospital_id is null) and d.dismiss_date is null

        order by di.qualification desc,
             case
             when d.zone_id=p_zone_id then 1
             else 0 end desc;

        if arr_doctors_detailed.first is null then
        raise_application_error (-20660, 'Неверно указана больница');
        end if;

    return arr_doctors_detailed;
    end;

end;

--репозиторий больницы

create or replace package lazorenko_al.pkg_hospital_repository
as
    function not_deleted_hospital_check(
    p_hospital_id in number
    )
    return boolean;

    function get_hospitals_with_own_types(
    p_spec_id number
    )
    return lazorenko_al.t_arr_hospital_info;

    function hospital_time_check(
    p_hospital_id in number
    )
    return boolean;

end;


create or replace package body lazorenko_al.pkg_hospital_repository
as
    function not_deleted_hospital_check(
    p_hospital_id in number
    )
    return boolean
    as
    v_count number;

    e_deleted_hospital exception;
    pragma exception_init (e_deleted_hospital, -20392);
    begin
        select count(*)
        into v_count
        from lazorenko_al.hospital h
        where h.hospital_id=p_hospital_id and h.delete_from_the_sys is null;

        if v_count=0 then
        raise_application_error (-20392, 'больница удалена или отсутствует в базе');
        end if;

    return v_count>0;

    exception

        when e_deleted_hospital then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('больница удалена или отсутствует в базе');

    return false;
    end;

    function get_hospitals_with_own_types(
    p_spec_id number
    )
    return lazorenko_al.t_arr_hospital_info
    as
    arr_hospital_info lazorenko_al.t_arr_hospital_info:=lazorenko_al.t_arr_hospital_info();

    no_hospital_found exception;
    pragma exception_init (no_hospital_found, -20800);

    begin
        select lazorenko_al.t_hospital_info(
            hname => h.name,
            aname => a.name,
            doctor_id => count(d.doctor_id),
            ownership_type =>
        case
            when o.ownership_type_id=1 then 'частная'
            when o.ownership_type_id=2 then 'государственная'
            end,
            end_time =>
        case
            when w.end_time is null then ' - '
            else w.end_time
            end)
        bulk collect into arr_hospital_info
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
             else 0 end desc, count(d.doctor_id) desc,
             case
             when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
             else 0
             end desc;

        if arr_hospital_info.first is null then
        raise_application_error(-20800,'указана неверная специальность');
        end if;

            return arr_hospital_info;
   exception

        when no_hospital_found then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('По заданным параметрам ничего не найдено');

    return arr_hospital_info;

    end;

    function hospital_time_check(
    p_hospital_id in number
    )
    return boolean
    as
    v_count number;

    e_bad_time exception;
    pragma exception_init (e_bad_time, -20300);

    begin
    select count(*)
    into v_count
    from lazorenko_al.work_time w
    where w.end_time>to_char(sysdate, 'hh24:mi')--(TO_CHAR(sysdate+1/12, 'hh24:mi'))
    and w.day in (to_char(sysdate, 'd')) and w.hospital_id=p_hospital_id;

        if v_count=0 then
        raise_application_error (-20300, 'ошибка - запись можжно отменить не позднее, чем за 2 часа до закрытия больницы');
        end if;

    return v_count>0;

    exception

        when e_bad_time then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('ошибка - запись можжно отменить не позднее, чем за 2 часа до закрытия больницы');

    return false;

    end;
end;

--репозиториий специальностей
create or replace package lazorenko_al.pkg_specialisations_repository
as
    function not_deleted_spec_check(
    p_spec_id in number
    )
    return boolean;

    function get_specs_with_own_types(
    p_doctor_id in number default null,
    p_hospital_id in number default null
    )
    return lazorenko_al.t_arr_specs;

end;


create or replace package body lazorenko_al.pkg_specialisations_repository
as
    function not_deleted_spec_check(
    p_spec_id in number
    )
    return boolean
    as
    v_count number;

    e_deleted_spec exception;
    pragma exception_init (e_deleted_spec, -20391);

    begin
        select count(*)
        into v_count
        from lazorenko_al.specialisation s
        where s.spec_id=p_spec_id and s.delete_from_the_sys is null;

            if v_count=0 then
            raise_application_error (-20391, 'специальность удалена или отсутствует в базе');
            end if;

    return v_count>0;

    exception

        when e_deleted_spec then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('специальность удалена или отсутствует в базе');

    return false;
    end;

    function get_specs_with_own_types(
    p_doctor_id in number default null,
    p_hospital_id in number default null
    )
    return lazorenko_al.t_arr_specs
    as
        arr_specs lazorenko_al.t_arr_specs :=lazorenko_al.t_arr_specs();

        no_spec_found exception;
        pragma exception_init (no_spec_found, -20809);

    begin

        select lazorenko_al.t_specs(
            name => s.name)
        bulk collect into arr_specs
        from specialisation s inner join doctor_spec using(spec_id)
        inner join doctor d using(doctor_id)
        inner join hospital h using(hospital_id)

        where s.delete_from_the_sys is null and d.dismiss_date is null and h.delete_from_the_sys is null
          and (p_hospital_id=hospital_id or p_hospital_id is null)
          and (p_doctor_id=doctor_id or p_doctor_id is null);

        if arr_specs.first is null then
        raise_application_error(-20809,'указаны неверный врач или больница');
        end if;

    return arr_specs;

    end;
end;


--репозиторий талона

create or replace package lazorenko_al.pkg_ticket_repository
as
    function get_ticket_with_own_types(
    p_doctor_id number
    )
    return lazorenko_al.t_arr_ticket;

    function get_ticket_info_by_id(
    p_ticket_id number
    )
    return lazorenko_al.t_tickets;

    function ticket_check(
    p_ticket_id in number,
    p_patient_id number
    )
    return boolean;

    function ticket_status_check(
    p_ticket_id in number,
    p_patient_id number
    )
    return boolean;

    function time_check(
    p_ticket_id in number
    )
    return boolean;

    function ticket_time_check(
    p_ticket_id in number
    )
    return boolean;

end;

create or replace package body lazorenko_al.pkg_ticket_repository
as
    function get_ticket_with_own_types(
    p_doctor_id number
    )
    return lazorenko_al.t_arr_ticket
    as
    arr_ticket lazorenko_al.t_arr_ticket:=lazorenko_al.t_arr_ticket();
    e_no_ticket exception;
    pragma exception_init (e_no_ticket, -20659);

    begin

        select lazorenko_al.t_ticket1(
            ticket_id => t.ticket_id,
            name => d.name,
            appointment_beg => t.appointment_beg,
            appointment_end => t.appointment_end)
        bulk collect into arr_ticket
        from ticket t right join doctor d using(doctor_id)
        where (doctor_id=p_doctor_id or p_doctor_id is null) and t.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
        order by t.appointment_beg;

        if arr_ticket.first is null then
        raise_application_error (-20659, 'Неверно указан доктор');
        end if;

    return arr_ticket;

    end;

    function get_ticket_info_by_id(
    p_ticket_id number
    )
    return lazorenko_al.t_tickets
    as
    v_ticket lazorenko_al.t_tickets;

    begin
        select lazorenko_al.t_tickets(
        ticket_id => t.ticket_id,
        doctor_id => t.doctor_id,
        ticket_stat_id => t.ticket_stat_id,
        appointment_beg => t.appointment_beg,
        appointment_end => t.appointment_end
        )
        into v_ticket
        from lazorenko_al.ticket t
        where t.ticket_id = p_ticket_id;


    return v_ticket;

        exception
        when no_data_found
        then lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('такого талона не существует');

    return null;

    end;

    function ticket_check(
    p_ticket_id in number,
    p_patient_id number
    )
    return boolean
    as
    v_count number;

    e_record_exists exception;
    pragma exception_init (e_record_exists, -20403);

    begin

        select count(*)
        into v_count
        from lazorenko_al.records r right join lazorenko_al.ticket t on r.ticket_id=t.ticket_id

        where (r.ticket_id=p_ticket_id and r.record_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_2)
          or (r.ticket_id=p_ticket_id and r.record_stat_id in (lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_1, lazorenko_al.pkg_ticket_parameters_check.c_rec_stat_constant_3)
          and r.patient_id<>p_patient_id)
          or (t.ticket_id=p_ticket_id and r.ticket_id is null and r.patient_id is null);

       if v_count=0 then
       raise_application_error (-20403, 'Вы уже записаны на данный талон');

    return v_count>0;
        end if;

    return v_count>0;

        exception
        when e_record_exists then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id||'","patient_id":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Вы уже записаны на данный талон');

    return false;

    end;


    function ticket_status_check(
    p_ticket_id in number,
    p_patient_id number
    )
    return boolean
    as
    v_count number;

    e_wrong_status exception;
    pragma exception_init (e_wrong_status, -20404);

    begin

        select count(*)
        into v_count
        from lazorenko_al.ticket t left join lazorenko_al.records r on r.ticket_id=t.ticket_id
        where (t.ticket_id=p_ticket_id and t.ticket_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_tick_stat_constant_1)
          or (t.ticket_id=p_ticket_id and t.ticket_stat_id=lazorenko_al.pkg_ticket_parameters_check.c_tick_stat_constant_2
                                      and r.patient_id=p_patient_id);

        if v_count=0 then
        raise_application_error (-20404, 'Талон закрыт');

        return v_count>0;
        end if;

    return v_count>0;

        exception
        when e_wrong_status then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Талон закрыт');

    return false;

    end;

    function time_check(
    p_ticket_id in number
    )
    return boolean
    as
    v_appointment_beg lazorenko_al.t_tickets;
    v_count number;

    e_wrong_time exception;
    pragma exception_init (e_wrong_time, -20405);

    begin

    v_appointment_beg:=lazorenko_al.ticket_repository.get_ticket_info_by_id(p_ticket_id);

        select count(*)
        into v_count
        from lazorenko_al.ticket t
        where t.ticket_id=p_ticket_id and v_appointment_beg.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss');

        if v_count=0 then
        raise_application_error (-20405, 'Приём уже завершён');

        return v_count>0;
        end if;

    return v_count>0;

        exception
        when e_wrong_time then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('Приём уже завершён');

    return false;

    end;

    function ticket_time_check(
    p_ticket_id in number
    )
    return boolean
    as
    v_count number;

    e_old_ticket exception;
    pragma exception_init (e_old_ticket, -20301);

    begin

    select count(*)
    into v_count
    from lazorenko_al.ticket t
    where to_date(appointment_beg, 'yyyy-mm-dd hh24:mi:ss')>sysdate
          and t.ticket_id=p_ticket_id;

        if v_count=0 then
        raise_application_error (-20301, 'невозможно оменить устаревший талон');
        end if;

    return v_count>0;

    exception

        when e_old_ticket then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('невозможно оменить устаревший талон');

    return false;

    end;
end;


--репозиторий утилит

create or replace package lazorenko_al.utilite_repository
as
    function calculate_age_from_date(
    p_date date
    )
    return number;

end;

create or replace package body lazorenko_al.utilite_repository
as
    function calculate_age_from_date(
    p_date date
    )
    return number
    as
    v_age number;
    begin
    select months_between(sysdate, p_date)/12
    into v_age
    from dual;

    return v_age;
    end;
end;


--репозиторий пациента
create or replace package lazorenko_al.pkg_patient_repository
as
    function get_patient_info_by_id(
    p_patient_id number
    )
    return lazorenko_al.t_patient2;

    function check_age(
    p_patient_id in number,
    p_spec_id in number
    )
    return boolean;

    function sex_check(
    p_patient_id in number,
    p_spec_id in number
    )
    return boolean;

    function patient_doc_check(
    p_patient_id in number
    )
    return boolean;

end;

create or replace package body lazorenko_al.pkg_patient_repository
as
    function get_patient_info_by_id(
    p_patient_id number
    )
    return lazorenko_al.t_patient2
    as
    v_patient lazorenko_al.t_patient2;

    begin

        select lazorenko_al.t_patient2(
            patient_id => p.patient_id,
            last_name => p.last_name,
            first_name => p.first_name,
            petronymic => p.petronymic,
            born_date => p.born_date,
            tel_number => p.tel_number,
            sex_id => p.sex_id,
            zone_id => p.zone_id
        )
        into v_patient
        from lazorenko_al.patient p
        where p.patient_id = p_patient_id;

    return v_patient;

        exception
        when no_data_found then
        lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
        );

        dbms_output.put_line('данный пациент отсутствует в базе больницы');

    return null;
    end;

    function check_age(
    p_patient_id in number,
    p_spec_id in number
    )
    return boolean
    as
    v_patient lazorenko_al.t_patient2;
    v_age number;
    v_count number;

    e_wrong_age exception;
    pragma exception_init (e_wrong_age, -20400);

    begin

    v_patient:=lazorenko_al.pkg_patient_repository.get_patient_info_by_id(p_patient_id);
    v_age:=lazorenko_al.utilite_repository.calculate_age_from_date(v_patient.born_date);

        select count(*)
        into v_count
        from lazorenko_al.specialisation s
        where s.spec_id = p_spec_id
          and (s.min_age <= v_age or s.min_age is null)
          and (s.max_age >= v_age or s.max_age is null);

    if v_count=0 then
       raise_application_error (-20400, 'возраст пациента не соответствует возрасту специальности');
    end if;

    return v_count>0;

    exception

        when e_wrong_age then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('возраст пациента не соответствует возрасту специальности');

    return false;

    end;


    function sex_check(
    p_patient_id in number,
    p_spec_id in number
    )
    return boolean
    as
    v_sex number;
    v_patient lazorenko_al.t_patient2;
    v_count number;

    e_wrong_sex exception;
    pragma exception_init (e_wrong_sex, -20401);

    begin

    v_patient:=lazorenko_al.pkg_patient_repository.get_patient_info_by_id(p_patient_id);
    v_sex:=v_patient.sex_id;
    select count(*)
    into v_count
    from lazorenko_al.specialisation s
    where s.spec_id=p_spec_id
          and (s.sex_id=v_sex or s.sex_id is null);

    if v_count=0 then
       raise_application_error (-20401, 'пол пациента не соответствует полу специальности');
    return v_count>0;
    end if;

    return v_count>0;

    exception
        when e_wrong_sex then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id ||'","spec_id":"' || p_spec_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('пол пациента не соответствует полу специальности');

    return false;

    end;


    function patient_doc_check(
    p_patient_id in number
    )
    return boolean
    as
    v_count number;

    e_no_docs exception;
    pragma exception_init (e_no_docs, -20402);

    begin
        select count(*)
        into v_count
        from lazorenko_al.documents_numbers dn
        where dn.patient_id=p_patient_id and dn.document_id=4
          and dn.value is not null;

    if v_count=0 then
       raise_application_error (-20402, 'отсутствуют данные по полису ОМС');
    return v_count>0;
    end if;

    return v_count>0;

    exception
        when e_no_docs then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('отсутствуют данные по полису ОМС');

    return false;

    end;
end;

--репозиторий журнала

create or replace package lazorenko_al.pkg_records_repository
as
    function get_record(
    p_ticket_id number
    )
    return lazorenko_al.t_record;

    function get_records_with_own_types(
    p_patient_id in number default null,
    p_record_stat_id in number default null
    )
    return lazorenko_al.t_arr_records;

end;

create or replace package body lazorenko_al.pkg_records_repository
as
    function get_record(
    p_ticket_id number
    )
    return lazorenko_al.t_record
    as
    v_response lazorenko_al.t_record;

    begin
        select lazorenko_al.t_record(
            record_id => r.record_id,
            record_stat_id => r.record_stat_id,
            patient_id => r.patient_id,
            ticket_id => r.ticket_id)
        into v_response
        from lazorenko_al.records r
        where r.ticket_id=p_ticket_id;
    return v_response;
    end;

    function get_records_with_own_types(
    p_patient_id in number default null,
    p_record_stat_id in number default null
    )
    return lazorenko_al.t_arr_records
    as
    arr_records lazorenko_al.t_arr_records:=lazorenko_al.t_arr_records();

    begin

        select lazorenko_al.t_records(
            last_name => last_name,
            first_name => first_name,
            petronymic => p.petronymic,
            name => d.name,
            rname => record_status.name,
            appointment_beg => appointment_beg,
            appointment_end => appointment_end)
        bulk collect into arr_records
        from lazorenko_al.patient p left join lazorenko_al.records using(patient_id)
        inner join record_status using(record_stat_id)
        inner join ticket using(ticket_id)
        inner join lazorenko_al.doctor d using(doctor_id)

        where (patient_id=p_patient_id or p_patient_id is null) and (record_stat_id=p_record_stat_id or p_record_stat_id is null);

    return arr_records;
    end;
end;


--репозиторий проверки соответствия

create or replace package lazorenko_al.accordance_ckeck_repository
as
    function check_accordance_of_write_parameters(
    p_hospital_id in number,
    p_doctor_id in number,
    p_spec_id in number,
    p_ticket_id in number
    )
    return boolean;

    function check_accordance_for_cancel(
    p_patient_id in number,
    p_ticket_id in number
    )
    return boolean;

end;

create or replace package body lazorenko_al.accordance_ckeck_repository
as
    function check_accordance_of_write_parameters(
    p_hospital_id in number,
    p_doctor_id in number,
    p_spec_id in number,
    p_ticket_id in number
    )
    return boolean
    as
    v_count number;

    e_no_accordance exception;
    pragma exception_init (e_no_accordance, -20395);

    begin
    select count(*)
    into v_count

    from lazorenko_al.hospital h inner join lazorenko_al.doctor d on h.hospital_id=d.hospital_id
    inner join lazorenko_al.doctor_spec ds on d.doctor_id=ds.doctor_id
    inner join lazorenko_al.specialisation s on ds.spec_id=s.spec_id
    inner join lazorenko_al.ticket t on d.doctor_id=t.doctor_id

    where h.hospital_id=p_hospital_id and d.doctor_id=p_doctor_id and s.spec_id=p_spec_id
          and t.ticket_id=p_ticket_id;

        if v_count=0 then
        raise_application_error (-20395, 'несоответствие вводимых для записи параметров');
        end if;

    return v_count>0;

    exception

        when e_no_accordance then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","hospital_id":"' || p_hospital_id ||'","doctor_id":"' || p_doctor_id ||'","spec_id":"' || p_spec_id ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('несоответствие вводимых для записи параметров');

    return false;
    end;

    function check_accordance_for_cancel(
    p_patient_id in number,
    p_ticket_id in number
    )
    return boolean
    as
    v_count number;

    e_bad_accordance exception;
    pragma exception_init (e_bad_accordance, -20302);

    begin

    select count(*)
    into v_count
    from lazorenko_al.records r
    where r.patient_id=p_patient_id and r.ticket_id=p_ticket_id and r.record_stat_id=1;

        if v_count=0 then
        raise_application_error (-20302, 'у вас отсутствует действующий талон с подобными параметрами или талон закрыт');
        end if;

    return v_count>0;

    exception

        when e_bad_accordance then
            lazorenko_al.add_error_log(
    $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
        '{"error":"' || sqlerrm
                  ||'","value":"' ||'","patient_id":"' || p_patient_id ||'","ticket_id":"' || p_ticket_id
                  ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                  ||'"}'
            );

            dbms_output.put_line('у вас отсутствует действующий талон с подобными параметрами или талон закрыт');

    return false;

    end;
end;

--репозиторий записи и отмены
create or replace package lazorenko_al.pkg_write_or_cancel_repository
as
    c_record_or_ticket_stat_first constant number := 1;
                                                          --КОНСТАНТЫ БУДУТ ИСПОЛЬЗОВАНЫ В ФУНКЦИЯХ ЗАПИСИ И ОТМЕНЫ
    c_record_or_ticket_stat_second constant number := 2;

    function cancel_record(
    p_ticket_id in number)
    return lazorenko_al.t_result;

    function write_to_records(
    p_patient_id in number,
    p_ticket_id in number,
    p_need_handle boolean)
    return lazorenko_al.t_result;
end;


create or replace package body lazorenko_al.pkg_write_or_cancel_repository
as
    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number,
         p_need_handle boolean
    )
    return lazorenko_al.t_result as
        v_result lazorenko_al.t_result;

        attempt_to_insert_null_into_not_null exception;
        pragma exception_init (attempt_to_insert_null_into_not_null, -01400);

    begin
        if (p_need_handle) then
            begin
                insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
                values (default, lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first, p_patient_id, p_ticket_id);

                update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
                where t.ticket_id=p_ticket_id;

            exception
                when attempt_to_insert_null_into_not_null then

                    lazorenko_al.add_error_log(
        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm ||'","value":"'
                     ||'","patient_id":"' || p_patient_id ||'","ticket_id":"' || p_ticket_id
                     ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                     ||'"}'
                    );

                    dbms_output.put_line('запись внести невозможно - все поля должны быть заполнены');

                rollback;
                begin
                v_result:=lazorenko_al.t_result(result_value => 0);
                end;
                return v_result;

           end;

        else

            insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
            values (default, lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first, p_patient_id, p_ticket_id);

            update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
            where t.ticket_id=p_ticket_id;

        end if;

      v_result:=lazorenko_al.t_result(result_value => 1);

   return v_result;

    end;

    function cancel_record(
        p_ticket_id in number
    )
    return  lazorenko_al.t_result  as
        v_result lazorenko_al.t_result;

        no_ticket_found exception;
        pragma exception_init (no_ticket_found, -20500);

    begin

            update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_first
            where t.ticket_id=p_ticket_id;

            update lazorenko_al.records r set r.record_stat_id=lazorenko_al.pkg_write_or_cancel.c_record_or_ticket_stat_second
            where r.ticket_id=p_ticket_id;

        if sql%notfound then
        raise_application_error(-20500,'указан неверный талон');
        end if;

        v_result:=lazorenko_al.t_result(result_value  => 1);

        return v_result;

    exception
        when no_ticket_found then

            lazorenko_al.add_error_log(
        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
                      ||'","value":"' || p_ticket_id
                      ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                      ||'"}'
            );

            dbms_output.put_line('указан неверный талон');

        v_result:=lazorenko_al.t_result(result_value  => 0);

        return v_result;

    end;

end;