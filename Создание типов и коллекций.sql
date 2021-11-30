--специальность
create or replace type lazorenko_al.t_specialisation as object(
    spec_id number,
    name varchar2(100),
    enter_into_the_sys date,
    delete_from_the_sys date,
    min_age number,
    max_age number,
    sex_id number);

create or replace type lazorenko_al.t_arr_specialisation as table of lazorenko_al.t_specialisation;

--пациент
create or replace type lazorenko_al.t_patient as object(
    patient_id number,
    born_date date,
    sex_id number
);

--добавление собственного конструктора
alter type lazorenko_al.t_patient
add constructor function t_patient(
    patient_id number,
    born_date date,
    sex_id number
) return self as result
cascade;

create or replace type body lazorenko_al.t_patient
as
    constructor function t_patient(
        patient_id number,
        born_date date,
        sex_id number
    )
    return self as result
    as
    begin
        self.patient_id := patient_id;
        self.born_date := born_date;
        self.sex_id := sex_id;
        return;
    end;
end;

create or replace type lazorenko_al.t_arr_patient as table of lazorenko_al.t_patient;

--документы пациента
create or replace type lazorenko_al.t_documents_numbers as object(
    doc_num_id number,
    patient_id number,
    document_id number,
    value varchar2(50)
);

create or replace type lazorenko_al.t_arr_documents_numbers as table of lazorenko_al.t_documents_numbers;

--расширенный пациент (с его документами)

create or replace type lazorenko_al.t_extended_patient as object(
    patient lazorenko_al.t_patient,
    documents_numbers lazorenko_al.t_arr_documents_numbers);

--доктор
create or replace type lazorenko_al.t_doctor as object(
    doctor_id number,
    name varchar2(100),
    hospital_id number,
    zone_id number,
    hiring_date date,
    dismiss_date date);

create or replace type lazorenko_al.t_arr_doctor as table of lazorenko_al.t_doctor;

--регалии доктора
create or replace type lazorenko_al.t_doctor_info as object(
    doctor_info_id number,
    education varchar2(100),
    qualification number,
    salary number,
    rating number,
    reviews varchar2(500),
    doctor_id number);

create or replace type lazorenko_al.t_arr_doctor_info as table of lazorenko_al.t_doctor_info;

--расширенный доктор (с его регалиями)
create or replace type lazorenko_al.t_extended_doctor as object(
    doctor lazorenko_al.t_doctor,
    doctors_info lazorenko_al.t_arr_doctor_info);

--больница
create or replace type lazorenko_al.t_hospital as object(
    hospital_id number,
    name varchar2(100),
    availability_id number,
    med_org_id number,
    ownership_type_id number,
    enter_into_the_sys date,
    delete_from_the_sys date);

create or replace type lazorenko_al.t_arr_hospital as table of lazorenko_al.t_hospital;

--расписание больницы
create or replace type lazorenko_al.t_work_time as object(
    work_time_id number,
    day number,
    begin_time varchar2(100),
    end_time varchar2(100),
    hospital_id number);

create or replace type lazorenko_al.t_arr_work_time as table of lazorenko_al.t_work_time;

--расширенная больница (с ее расписанием)
create or replace type lazorenko_al.t_extended_hospital as object(
    hospital lazorenko_al.t_hospital,
    work_time lazorenko_al.t_arr_work_time);

--талон
create or replace type lazorenko_al.t_tickets as object(
    ticket_id number,
    doctor_id number,
    ticket_stat_id number,
    appointment_beg varchar2(50),
    appointment_end varchar2(50));

create or replace type lazorenko_al.t_arr_tickets as table of lazorenko_al.t_tickets;


--журнальный талон
create or replace type lazorenko_al.t_record as object(
    record_id number,
    record_stat_id number,
    patient_id number,
    ticket_id number);

create or replace type lazorenko_al.t_arr_record as table of lazorenko_al.t_record;


