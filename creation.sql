create table LAZORENKO_AL.region (region_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.city (city_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null,
                    region_id number references LAZORENKO_AL.region(region_id) not null
                    );

create table LAZORENKO_AL.ownership_type (ownership_type_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.available (availability_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.med_org (med_org_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null,
                    city_id number references LAZORENKO_AL.city(city_id)
                    );

create table LAZORENKO_AL.mon_fri_open (mf_open_time_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    open date not null
                    );
create table LAZORENKO_AL.mon_fri_close (mf_close_time_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    close date not null
                    );

create table LAZORENKO_AL.sat_san_open (ss_open_time_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    open date null
                    );

create table LAZORENKO_AL.sat_sun_close (ss_close_time_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    close date null
                    );

create table LAZORENKO_AL.work_time (work_time_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    mf_open_time_id number references LAZORENKO_AL.mon_fri_open(mf_open_time_id) not null,
                    mf_close_time_id number references LAZORENKO_AL.mon_fri_close(mf_close_time_id) not null,
                    ss_open_time_id number references LAZORENKO_AL.sat_san_open(ss_open_time_id) not null,
                    ss_close_time_id number references LAZORENKO_AL.sat_sun_close(ss_close_time_id) not null
                    );

create table LAZORENKO_AL.hospital (hospital_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null,
                    work_time_id number references LAZORENKO_AL.work_time(work_time_id) not null,
                    availability_id number references LAZORENKO_AL.available(availability_id) not null,
                    med_org_id number references LAZORENKO_AL.med_org(med_org_id) not null,
                    ownership_type_id number references LAZORENKO_AL.ownership_type(ownership_type_id) not null,
                    enter_into_the_sys date not null,
                    delete_from_the_sys date not null
                    );

create table LAZORENKO_AL.zone (zone_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    city_id number references LAZORENKO_AL.city(city_id) not null
                    );

create table LAZORENKO_AL.doctor (doctor_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null,
                    hospital_id number references LAZORENKO_AL.hospital(hospital_id) not null,
                    qualification number not null,
                    zone_id number references LAZORENKO_AL.zone(zone_id) not null,
                    hiring_date date not null,
                    dismiss_date date not null
                    );

create table LAZORENKO_AL.age_groups (age_group_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.ages (age_id number primary key,
                    age_group_id number references LAZORENKO_AL.age_groups(age_group_id) not null
                    );

create table LAZORENKO_AL.specialisation (spec_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null,
                    enter_into_the_sys date not null,
                    delete_from_the_sys date not null
                    );

create table LAZORENKO_AL.doctor_spec (doctor_spec_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    doctor_id number references LAZORENKO_AL.doctor(doctor_id) not null,
                    spec_id number references LAZORENKO_AL.specialisation(spec_id) not null
                    );

create table age_spec (age_spec_id number generated by default as identity
                      (start with 1 maxvalue 999999999999 minvalue 1 nocycle nocache noorder) primary key,
                      spec_id number references LAZORENKO_AL.specialisation(spec_id),
                      age_group_id number references LAZORENKO_AL.age_groups(age_group_id)
                      );

create table LAZORENKO_AL.sex (sex_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.sex_spec (sex_spec_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    sex_id number references LAZORENKO_AL.sex(sex_id) not null,
                    spec_id number references LAZORENKO_AL.specialisation(spec_id) not null
                    );

create table LAZORENKO_AL.ticket_status (ticket_stat_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.ticket (ticket_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    doctor_id number references LAZORENKO_AL.doctor(doctor_id) not null,
                    ticket_stat_id number references LAZORENKO_AL.ticket_status(ticket_stat_id) not null,
                    appointment_beg date not null,
                    apointment_end date not null
                    );

create table LAZORENKO_AL.account (account_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(100) not null
                    );

create table LAZORENKO_AL.patient (patient_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    last_name varchar2(100) not null,
                    first_name varchar2(100) not null,
                    petronymic varchar2(100) null,
                    born_date date not null,
                    docs varchar2(100) not null,
                    tel_number varchar2(100) null,
                    sex_id number references LAZORENKO_AL.sex(sex_id) not null,
                    zone_id number references LAZORENKO_AL.zone(zone_id) not null
                    );

create table LAZORENKO_AL.record_status (record_stat_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    name varchar2(50) not null
                    );

create table LAZORENKO_AL.records (record_id number generated by default as identity
                    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
                    record_stat_id number references LAZORENKO_AL.record_status(record_stat_id) not null,
                    patient_id number references LAZORENKO_AL.patient(patient_id) not null,
                    ticket_id number references LAZORENKO_AL.ticket(ticket_id) not null
                    );



