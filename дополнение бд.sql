alter table LAZORENKO_AL.patient drop column docs;

create table patient_docs (
    docs_id number generated always as identity (
        start with 1 maxvalue 999999999999 minvalue 1 nocycle nocache noorder) primary key,
        passport varchar2(100),
        inipa  varchar2(100),
        itn varchar2(100),
        patient_id number references LAZORENKO_AL.patient(patient_id)
        );

insert into LAZORENKO_AL.patient_docs(passport, inipa, itn, patient_id)
values ('3217 475785', '999888777666555', '888777666555', 1);
insert into LAZORENKO_AL.patient_docs(passport, inipa, itn, patient_id)
values ('3219 758497', '999777555333111', '111222333444', 2);
insert into LAZORENKO_AL.patient_docs(passport, inipa, itn, patient_id)
values ('3218 460985', '222444666888777', '000888777555', 3);


alter table LAZORENKO_AL.doctor drop column qualification;

create table doctors_info (
    doctor_info_id number generated always as identity (
        start with 1 maxvalue 999999999999 minvalue 1 nocycle nocache noorder) primary key,
        education varchar2(500) not null,
        qualification number not null,
        salary number not null,
        rating number,
        reviews varchar2(500),
        doctor_id number references LAZORENKO_AL.doctor(doctor_id) not null
);

