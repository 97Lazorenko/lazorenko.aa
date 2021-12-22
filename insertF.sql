insert into LAZORENKO_AL.region (region_id, name)
values (default, 'Кемеровская область');
insert into LAZORENKO_AL.region (region_id, name)
values (default, 'Новосибирская область');
insert into LAZORENKO_AL.region (region_id, name)
values (default, 'Красноярский край');

insert into LAZORENKO_AL.city (city_id, NAMES, region_id)
values (default, 'Кемерово', 1);
insert into LAZORENKO_AL.city (city_id, NAMES, region_id)
values (default, 'Новокузнецк', 1);
insert into LAZORENKO_AL.city (city_id, NAMES, region_id)
values (default, 'Новосибирск', 2);
insert into LAZORENKO_AL.city (city_id, NAMES, region_id)
values (default, 'Красноярск', 3);

insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'КемМед', 1);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'Атлант', 1);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'НКМед', 2);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'Health', 2);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'СибМед', 3);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'НСМед', 3);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'Здоровье', 3);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'К-Мед', 4);
insert into LAZORENKO_AL.med_org (med_org_id, name, city_id)
values (default, 'СеверМед', 4);

insert into LAZORENKO_AL.available (availability_id, name)
values (default, 'Доступна');
insert into LAZORENKO_AL.available (availability_id, name)
values (default, 'Не доступна');

insert into LAZORENKO_AL.ownership_type (ownership_type_id, name)
values (default, 'частная');
insert into LAZORENKO_AL.ownership_type (ownership_type_id, name)
values (default, 'государственная');

insert into LAZORENKO_AL.mon_fri_open (mf_open_time_id, open)
values (default, '8:00');
insert into LAZORENKO_AL.mon_fri_open (mf_open_time_id, open)
values (default, '9:00');
insert into LAZORENKO_AL.mon_fri_open (mf_open_time_id, open)
values (default, '10:00');

insert into LAZORENKO_AL.mon_fri_close (mf_close_time_id, close)
values (default, '18:00');
insert into LAZORENKO_AL.mon_fri_close (mf_close_time_id, close)
values (default, '19:00');
insert into LAZORENKO_AL.mon_fri_close (mf_close_time_id, close)
values (default, '20:00');

insert into LAZORENKO_AL.sat_sun_open(ss_open_time_id, open)
values (default, '9:00');
insert into LAZORENKO_AL.sat_sun_open(ss_open_time_id, open)
values (default, '10:00');
insert into LAZORENKO_AL.sat_sun_open(ss_open_time_id, open)
values (default, NULL);

insert into LAZORENKO_AL.sat_sun_close(ss_close_time_id, close)
values (default, '16:00');
insert into LAZORENKO_AL.sat_sun_close(ss_close_time_id, close)
values (default, '17:00');
insert into LAZORENKO_AL.sat_sun_close(ss_close_time_id, close)
values (default, NULL);

insert into LAZORENKO_AL.work_time(work_time_id, mf_open_time_id, mf_close_time_id, ss_open_time_id, ss_close_time_id)
values (default, 21, 2, 3, 3);
insert into LAZORENKO_AL.work_time(work_time_id, mf_open_time_id, mf_close_time_id, ss_open_time_id, ss_close_time_id)
values (default, 21, 1, 1, 1);
insert into LAZORENKO_AL.work_time(work_time_id, mf_open_time_id, mf_close_time_id, ss_open_time_id, ss_close_time_id)
values (default, 22, 2, 2, 2);
insert into LAZORENKO_AL.work_time(work_time_id, mf_open_time_id, mf_close_time_id, ss_open_time_id, ss_close_time_id)
values (default, 23, 3, 3, 3);

insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница1', 1, 1, 1, 1, '22/10/2015', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница2', 3, 2, 1, 1, '10/02/2018', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница3', 2, 1, 2, 2, '12/04/2018', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница4', 1, 1, 3, 1, '20/10/2015', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница5', 3, 2, 3, 1, '15/02/2018', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница6', 2, 1, 4, 2, '19/03/2018', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница7', 1, 1, 5, 1, '27/10/2015', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница8', 3, 2, 6, 1, '11/02/2018', '26/10/2020');
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница9', 2, 1, 7, 2, '14/04/2018', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница10', 2, 1, 8, 2, '22/10/2015', null);
insert into LAZORENKO_AL.hospital(hospital_id, name, work_time_id, availability_id, med_org_id, ownership_type_id, enter_into_the_sys, delete_from_the_sys)
values (default, 'больница11', 3, 1, 9, 1, '10/02/2018', null);

insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 1);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 1);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 1);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 2);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 2);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 2);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 3);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 3);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 3);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 3);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 4);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 4);
insert into LAZORENKO_AL.zone(zone_id, city_id)
values (default, 4);

insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов', 4, 4, 1, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров', 4, 2, 1, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров', 4, 5, 1, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова', 4, 3, 1, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов1', 5, 2, 2, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров1', 5, 5, 2, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров1', 5, 6, 2, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова1', 5, 7, 3, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов2', 6, 7, 3, '12/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров2', 6, 8, 3, '12/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров2', 6, 5, 3, '12/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова2', 6, 9, 3, '12/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов3', 7, 2, 4, '20/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров3', 7, 15, 4, '20/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров3', 7, 3, 4, '20/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова3', 7, 4, 4, '20/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов4', 8, 4, 5, '15/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров4', 8, 5, 5, '15/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров4', 8, 5, 5, '15/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова4', 8, 6, 5, '15/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов5', 9, 8, 6, '19/03/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров5', 9, 9, 6, '19/03/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров5', 9, 9, 6, '19/03/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова5', 9, 6, 6, '19/03/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов6', 10, 6, 7, '27/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров6', 10, 5, 7, '27/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров6', 10, 4, 7, '27/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова6', 10, 4, 7, '27/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов7', 11, 2, 8, '11/02/2018', '26/10/2020');
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров7', 11, 2, 8, '11/02/2018', '26/10/2020');
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров7', 11, 8, 8, '11/02/2018', '26/10/2020');
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова7', 11, 5, 8, '11/02/2018', '26/10/2020');
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов8', 12, 5, 9, '14/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров8', 12, 4, 9, '14/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров8', 12, 7, 10, '14/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова8', 12, 6, 10, '14/04/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов9', 13, 7, 11, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров9', 13, 6, 11, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров9', 13, 10, 11, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова9', 13, 20, 11, '22/10/2015', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Иванов10', 14, 13, 12, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Петров10', 14, 12, 12, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Сидоров10', 14, 11, 13, '10/02/2018', null);
insert into LAZORENKO_AL.doctor(doctor_id, name, hospital_id, qualification, zone_id, hiring_date, dismiss_date)
values (default, 'Климова10', 14, 2, 13, '10/02/2018', null);

insert into LAZORENKO_AL.age_groups(age_group_id, name)
values (default, 'младенцы');
insert into LAZORENKO_AL.age_groups(age_group_id, name)
values (default, 'дети');
insert into LAZORENKO_AL.age_groups(age_group_id, name)
values (default, 'взрослые');
insert into LAZORENKO_AL.age_groups(age_group_id, name)
values (default, 'пенсионеры');

insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (0, 1);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (1, 1);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (2, 1);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (3, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (4, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (5, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (6, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (7, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (8, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (9, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (10, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (11, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (12, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (13, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (14, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (15, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (16, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (17, 2);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (18, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (19, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (20, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (21, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (22, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (23, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (24, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (25, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (26, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (27, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (28, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (29, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (30, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (31, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (32, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (33, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (34, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (35, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (36, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (37, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (38, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (39, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (40, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (41, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (42, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (43, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (44, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (45, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (46, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (47, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (48, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (49, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (50, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (51, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (52, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (53, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (54, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (55, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (56, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (57, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (58, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (59, 3);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (60, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (61, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (62, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (63, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (64, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (65, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (66, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (67, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (68, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (69, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (70, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (71, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (72, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (73, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (74, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (75, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (76, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (77, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (78, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (79, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (80, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (81, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (82, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (83, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (84, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (85, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (86, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (87, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (88, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (89, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (90, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (91, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (92, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (93, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (94, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (95, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (96, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (97, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (98, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (99, 4);
insert into LAZORENKO_AL.ages(age_id, age_group_id)
values (100, 4);

insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'педиатр', '30/01/2015', null);
insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'лор', '30/01/2015', null);
insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'аллерголог', '30/01/2015', null);
insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'травматолог', '30/01/2015', null);
insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'уролог', '30/01/2015', null);
insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'гениколог', '30/01/2015', null);
insert into LAZORENKO_AL.specialisation(spec_id, name, enter_into_the_sys, delete_from_the_sys)
values (default, 'терапевт', '30/01/2015', '26/10/2021');

insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 3, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 3, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 4, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 5, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 6, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 7, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 8, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 9, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 10, 6);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 11, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 11, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 12, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 13, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 14, 6);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 15, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 16, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 17, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 18, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 19, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 20, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 21, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 22, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 23, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 24, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 25, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 26, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 27, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 28, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 29, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 30, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 31, 7);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 32, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 33, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 34, 6);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 35, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 36, 1);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 37, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 38, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 39, 2);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 40, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 41, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 42, 4);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 43, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 44, 3);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 45, 5);
insert into LAZORENKO_AL.doctor_spec(doctor_spec_id, doctor_id, spec_id)
values (default, 46, 2);

insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 1, 1);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 1, 2);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 2, 2);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 2, 3);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 2, 4);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 3, 2);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 3, 3);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 3, 4);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 4, 2);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 4, 3);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 4, 4);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 5, 2);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 5, 3);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 5, 4);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 6, 2);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 6, 3);
insert into LAZORENKO_AL.age_spec(age_spec_id, spec_id, age_group_id)
values (default, 6, 4);

insert into LAZORENKO_AL.sex(sex_id, name)
values (default, 'мужской');
insert into LAZORENKO_AL.sex(sex_id, name)
values (default, 'женский');

insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 1, 1);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 2, 1);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 1, 2);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 2, 2);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 1, 3);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 2, 3);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 1, 4);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 2, 4);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 1, 5);
insert into LAZORENKO_AL.sex_spec(sex_spec_id, sex_id, spec_id)
values (default, 2, 6);

insert into LAZORENKO_AL.ticket_status(ticket_stat_id, name)
values (default, 'открыт');
insert into LAZORENKO_AL.ticket_status(ticket_stat_id, name)
values (default, 'закрыт');

insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '10/10/2021 14:00:00', '10/10/2021 14:30:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 2, '10/10/2021 14:00:00', '10/10/2021 14:30:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '20/10/2021 14:00:00', '20/10/2021 14:30:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '20/10/2021 14:30:00', '20/10/2021 15:00:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '20/10/2021 15:00:00', '20/10/2021 15:30:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 4, 1, '16/10/2021 14:00:00', '16/10/2021 14:30:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 4, 1, '20/10/2021 14:00:00', '20/10/2021 14:30:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '13/10/2021 11:30:00', '13/10/2021 12:00:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '20/11/2021 11:30:00', '13/10/2021 12:00:00');
insert into LAZORENKO_AL.ticket(ticket_id, doctor_id, ticket_stat_id, appointment_beg, appointment_end)
values (default, 3, 1, '23/11/2021 11:30:00', '13/10/2021 12:00:00');

insert into LAZORENKO_AL.account(account_id, name)
values (default, 'user1');
insert into LAZORENKO_AL.account(account_id, name)
values (default, 'user2');
insert into LAZORENKO_AL.account(account_id, name)
values (default, 'user3');

insert into LAZORENKO_AL.patient(patient_id, last_name, first_name, petronymic, born_date, docs, tel_number, sex_id, zone_id)
values (default, 'petrov', 'ivan', 'ivanovich', '23/10/1980', '3478 494053', '+798099999999', 1, 1);
insert into LAZORENKO_AL.patient(patient_id, last_name, first_name, petronymic, born_date, docs, tel_number, sex_id, zone_id)
values (default, 'ivanov', 'petr', null, '25/09/1984', '3478 407553', '+79095559999', 1, 1);
insert into LAZORENKO_AL.patient(patient_id, last_name, first_name, petronymic, born_date, docs, tel_number, sex_id, zone_id)
values (default, 'karpova', 'anna', 'borisovna', '01/05/1990', '3454 467853', null, 2, 2);

insert into LAZORENKO_AL.record_status(record_stat_id, name)
values (default, 'действует');
insert into LAZORENKO_AL.record_status(record_stat_id, name)
values (default, 'отменено');
insert into LAZORENKO_AL.record_status(record_stat_id, name)
values (default, 'исполнено');

insert into LAZORENKO_AL.records(record_id, record_stat_id, patient_id, ticket_id)
values (default, 1, 1, 22);
insert into LAZORENKO_AL.records(record_id, record_stat_id, patient_id, ticket_id)
values (default, 2, 1, 23);
insert into LAZORENKO_AL.records(record_id, record_stat_id, patient_id, ticket_id)
values (default, 1, 3, 24);
insert into LAZORENKO_AL.records(record_id, record_stat_id, patient_id, ticket_id)
values (default, 1, 1, 27);

