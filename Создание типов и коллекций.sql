--специальность
create or replace type lazorenko_al.t_specialisation as object(  --вместо row%type
    spec_id number,
    name varchar2(100),
    enter_into_the_sys date,
    delete_from_the_sys date,
    min_age number,
    max_age number,
    sex_id number);

create or replace type lazorenko_al.t_arr_specialisation as table of lazorenko_al.t_specialisation; --массив

--пациент
create or replace type lazorenko_al.t_patient2 as object(  --вместо row%type
    patient_id number,
    last_name varchar2(100),
    first_name varchar2(100),
    petronymic varchar2(100),
    born_date date,
    tel_number varchar2(100),
    sex_id number,
    zone_id number
);


alter type lazorenko_al.t_patient2  --добавление собственного конструктора
add constructor function t_patient2(
    patient_id number,
    last_name varchar2,
    first_name varchar2,
    petronymic varchar2,
    born_date date,
    tel_number varchar2,
    sex_id number,
    zone_id number
) return self as result
cascade;

create or replace type body lazorenko_al.t_patient2  --его тело
as
    constructor function t_patient2(
        patient_id number,
        last_name varchar2,
        first_name varchar2,
        petronymic varchar2,
        born_date date,
        tel_number varchar2,
        sex_id number,
        zone_id number
        )
    return self as result
    as
    begin
        self.patient_id := patient_id;
        self.last_name := last_name;
        self.first_name := first_name;
        self.petronymic := petronymic;
        self.born_date := born_date;
        self.tel_number := tel_number;
        self.sex_id := sex_id;
        self.zone_id := zone_id;
        return;
    end;
end;

create or replace type lazorenko_al.t_arr_patient2 as table of lazorenko_al.t_patient2;  --массив

--документы пациента
create or replace type lazorenko_al.t_documents_numbers as object(  --вместо row%type
    doc_num_id number,
    patient_id number,
    document_id number,
    value varchar2(50)
);

create or replace type lazorenko_al.t_arr_documents_numbers as table of lazorenko_al.t_documents_numbers;  --массив

--расширенный пациент (с его документами)

create or replace type lazorenko_al.t_extended_patient as object(
    patient lazorenko_al.t_patient,
    documents_numbers lazorenko_al.t_arr_documents_numbers);

--доктор
create or replace type lazorenko_al.t_doctor as object(  --вместо row%type
    doctor_id number,
    name varchar2(100),
    hospital_id number,
    zone_id number,
    hiring_date date,
    dismiss_date date);

create or replace type lazorenko_al.t_arr_doctor as table of lazorenko_al.t_doctor;  --массив

--регалии доктора
create or replace type lazorenko_al.t_doctor_info as object(  --вместо row%type
    doctor_info_id number,
    education varchar2(100),
    qualification number,
    salary number,
    rating number,
    reviews varchar2(500),
    doctor_id number);

create or replace type lazorenko_al.t_arr_doctor_info as table of lazorenko_al.t_doctor_info;  --массив

--расширенный доктор (с его регалиями)
create or replace type lazorenko_al.t_extended_doctor as object(
    doctor lazorenko_al.t_doctor,
    doctors_info lazorenko_al.t_arr_doctor_info);

--больница
create or replace type lazorenko_al.t_hospital as object(  --вместо row%type
    hospital_id number,
    name varchar2(100),
    availability_id number,
    med_org_id number,
    ownership_type_id number,
    enter_into_the_sys date,
    delete_from_the_sys date);

create or replace type lazorenko_al.t_arr_hospital as table of lazorenko_al.t_hospital;  --массив

--расписание больницы
create or replace type lazorenko_al.t_work_time as object(  --вместо row%type
    work_time_id number,
    day number,
    begin_time varchar2(100),
    end_time varchar2(100),
    hospital_id number);

create or replace type lazorenko_al.t_arr_work_time as table of lazorenko_al.t_work_time;  --массив

--расширенная больница (с ее расписанием)
create or replace type lazorenko_al.t_extended_hospital as object(
    hospital lazorenko_al.t_hospital,
    work_time lazorenko_al.t_arr_work_time);

--талон
create or replace type lazorenko_al.t_tickets as object(  --вместо row%type
    ticket_id number,
    doctor_id number,
    ticket_stat_id number,
    appointment_beg varchar2(50),
    appointment_end varchar2(50));

create or replace type lazorenko_al.t_arr_tickets as table of lazorenko_al.t_tickets;  --массив


--журнальный талон
create or replace type lazorenko_al.t_record as object(  --вместо row%type
    record_id number,
    record_stat_id number,
    patient_id number,
    ticket_id number);

alter type lazorenko_al.t_record  --добавление собственного конструктора
add constructor function t_record(
    record_id number,
    record_stat_id number,
    patient_id number,
    ticket_id number
) return self as result
cascade;

create or replace type body lazorenko_al.t_record  --его тело
as
    constructor function t_record(
    record_id number,
    record_stat_id number,
    patient_id number,
    ticket_id number
    )
    return self as result
    as
    begin
        self.record_id := record_id;
        self.record_stat_id:= record_stat_id;
        self.patient_id := patient_id;
        self.ticket_id := ticket_id;
        return;
    end;
end;


create or replace type lazorenko_al.t_arr_record as table of lazorenko_al.t_record;  --массив

alter type lazorenko_al.t_tickets  --добавление собственного конструктора
add constructor function t_tickets(
    ticket_id number,
    doctor_id number,
    ticket_stat_id number,
    appointment_beg varchar2,
    appointment_end varchar2
) return self as result
cascade;

create or replace type body lazorenko_al.t_tickets  --его тело
as
    constructor function t_tickets(
    ticket_id number,
    doctor_id number,
    ticket_stat_id number,
    appointment_beg varchar2,
    appointment_end varchar2
    )
    return self as result
    as
    begin
        self.ticket_id := ticket_id;
        self.doctor_id:= doctor_id;
        self.ticket_stat_id := ticket_stat_id;
        self.appointment_beg := appointment_beg;
        self.appointment_end := appointment_end;
        return;
    end;
end;





create or replace type lazorenko_al.t_hospitals as object(
    id_hospital number,
    name varchar2(100),
    address varchar2(100),
    id_town number);

create or replace type lazorenko_al.t_arr_hospitals as table of lazorenko_al.t_hospitals;




create or replace type lazorenko_al.t_new_specs as object(
    id_specialty number,
    name varchar2(100),
    id_hospital number);

create or replace type lazorenko_al.t_arr_new_specs as table of lazorenko_al.t_new_specs;