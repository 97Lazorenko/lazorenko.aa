create or replace package lazorenko_al.pkg_1
as
    p_patient_id number;

    function get_patient_info_by_id(
    p_patient_id number)
    return number;

end;

create or replace package body lazorenko_al.pkg_1
as
    function get_patient_info_by_id(
    p_patient_id number)
    return number as
    v_patient number;
    begin
    select p.patient_id
    into v_patient
    from lazorenko_al.patient p
    where p.patient_id = pkg_2.get_account(2);
    return v_patient;
    end;
end;

create or replace function lazorenko_al.get_account(
p_patient_id number)
return number as
v_account number;
begin
    select a.patient_id
    into v_account
    from lazorenko_al.account a
    where a.patient_id = p_patient_id;
    return v_account;
end;

create or replace package lazorenko_al.pkg_2
as

function get_account(
p_patient_id number)
return number;

end;


create or replace package body lazorenko_al.pkg_2
as

function get_account(
p_patient_id number)
return number as
v_account number;
begin
    select a.account_id
    into v_account
    from lazorenko_al.account a
    where a.patient_id = pkg_1.p_patient_id;
    return v_account;
end;
    end;


declare
v_n number;
begin
    v_n:=lazorenko_al.pkg_1.get_patient_info_by_id(2);
    dbms_output.put_line(v_n);
end;