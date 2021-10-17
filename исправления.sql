create table LAZORENKO_AL.work_time (
    work_time_id number generated by default as identity
    (start with 1 maxvalue 999999999999999 minvalue 1 nocycle nocache noorder) primary key,
    day varchar2(100),
    begin_time varchar2(100) null,
    end_time varchar2(100) null,
    hospital_id number references LAZORENKO_AL.hospital(hospital_id) not null
);

insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '18:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '18:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '18:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '18:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '18:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '16:00', 4);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '18:00', 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '18:00', 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '18:00', 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '18:00', 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '18:00', 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', null, null, 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', null, null, 5);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '8:00', '18:00', 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '8:00', '18:00', 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '8:00', '18:00', 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '8:00', '18:00', 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '8:00', '18:00', 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '9:00', '16:00', 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', null, null, 6);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '18:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '18:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '18:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '18:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '18:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '16:00', 7);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '18:00', 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '18:00', 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '18:00', 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '18:00', 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '18:00', 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', null, null, 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', null, null, 8);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '18:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '18:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '18:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '18:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '18:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '16:00', 9);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '8:00', '17:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '8:00', '17:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '8:00', '17:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '8:00', '17:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '8:00', '17:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '9:00', '16:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '15:00', 10);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '20:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '20:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '20:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '20:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '20:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '15:00', 11);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '7:00', '18:00', 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '7:00', '18:00', 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '7:00', '18:00', 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '7:00', '18:00', 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '7:00', '18:00', 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', null, null, 12);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '18:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '18:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '18:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '18:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '18:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '16:00', 13);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Monday', '9:00', '20:00', 14);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Tuesday', '9:00', '20:00', 14);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Wednesday', '9:00', '20:00', 14);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Thursday', '9:00', '20:00', 14);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Friday', '9:00', '20:00', 14);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Saturday', '10:00', '17:00', 14);
insert into LAZORENKO_AL.work_time(day, begin_time, end_time, hospital_id)
values('Sunday', '10:00', '15:00', 14);