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

insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 3, 35000, 7, null, 3);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 5, 36000, 8, null, 4);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 4, 30000, 6, null, 5);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 4, 40000, 5, null, 6);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 3, 30000, 5, null, 7);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 3, 35000, 7, null, 8);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 4, 36000, 8, null, 9);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 4, 30000, 6, null, 10);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 8, 40000, 5, null, 11);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 3, 30000, 5, null, 12);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 3, 35000, 7, null, 13);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 4, 36000, 8, null, 14);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 4, 30000, 6, null, 15);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 5, 40000, 5, null, 16);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 4, 30000, 5, null, 17);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 5, 35000, 7, null, 18);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 4, 36000, 8, null, 19);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 4, 30000, 6, null, 20);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 7, 40000, 5, null, 21);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет6', 3, 30000, 5, null, 22);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 4, 35000, 7, null, 23);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 4, 36000, 8, null, 24);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 4, 30000, 6, null, 25);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 8, 40000, 5, null, 26);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 3, 30000, 5, null, 27);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет5', 6, 35000, 7, null, 28);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет1', 4, 36000, 8, null, 29);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 4, 30000, 6, null, 30);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 7, 40000, 5, null, 31);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 4, 30000, 5, null, 32);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 4, 35000, 7, null, 33);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 5, 36000, 8, null, 34);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 4, 30000, 6, null, 35);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 6, 40000, 5, null, 36);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет6', 3, 28000, 5, null, 37);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет2', 8, 50000, 7, null, 38);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 7, 46000, 8, null, 39);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 6, 38000, 6, null, 40);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет5', 5, 40000, 5, null, 41);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 4, 35000, 5, null, 42);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет4', 3, 45000, 7, null, 43);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 15, 66000, 8, null, 44);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 5, 35000, 6, null, 45);
insert into LAZORENKO_AL.doctors_info(education, qualification, salary, rating, reviews, doctor_id)
values ('университет3', 15, 50000, 5, null, 46);



------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------АКТУАЛЬНЫЕ ИЗМЕНЕНИЯ------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
insert into LAZORENKO_AL.hospital(name, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values ('тест', 1, 1, 1, default, null);

insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, zone_id, hiring_date, dismiss_date)
values (default, 'тест', 16, 2, '2018/03/12', null);

insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 47, 2);

