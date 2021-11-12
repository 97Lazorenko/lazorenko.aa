create or replace package lazorenko_al.pkg_const_for_write_or_cancel
as
    c_constant_1 constant number := 1;

    c_constant_2 constant number := 2;

    v_record_id lazorenko_al.records.record_id%type;

    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number)
    return lazorenko_al.records.record_id%type;

    function lazorenko_al.cancel_record(
    p_ticket_id in number)
return v_record_id number;
end;

    create or replace package body lazorenko_al.pkg_const_for_write_or_cancel
as
    function write_to_records(
         p_patient_id in number,
         p_ticket_id in number
    )
    return lazorenko_al.records.record_id%type as
    v_record_id lazorenko_al.records.record_id%type;

    begin
    insert into lazorenko_al.records(record_id, record_stat_id, patient_id, ticket_id)
    values (default, LAZORENKO_AL.PKG_CONST_FOR_WRITE_OR_CANCEL.c_write_record_stat_id_constant, p_patient_id, p_ticket_id)
    returning record_id into v_record_id;

    update lazorenko_al.ticket t set t.ticket_stat_id=lazorenko_al.PKG_CONST_FOR_WRITE_OR_CANCEL.c_write_update_ticket_stat_id_constant where t.ticket_id=p_ticket_id;

    commit;

return v_record_id;
end;

end;

declare
v_record number;
begin
v_record:=lazorenko_al.pkg_const_for_write_or_cancel.write_to_records(1,33);
end;