create table lazorenko_al.error_log(
    id_log number generated by default as identity
    (start with 1 maxvalue 9999999999999999999999999999 minvalue 1 nocycle nocache noorder) primary key,

    sh_user varchar2(50) default user,
    sh_dt date default sysdate,
    object_name varchar2(200),
    log_type varchar2(1000),
    params varchar2(4000))
    partition by range (sh_dt)
    interval (NUMTOYMINTERVAL(3, 'MONTH'))
(
    partition error_log_2021_qrt4 values less than (to_date('22.02.2022 00:00', 'dd.mm.yyyy hh24:mi'))
);


select * from sys.user_part_tables;
select * from sys.user_tab_partitions;

drop table lazorenko_al.error_log purge;









create or replace procedure lazorenko_al.add_error_log(
    p_sh_dt date,
    p_object_name varchar2,
    p_params varchar2,
    p_log_type varchar2 default 'common'
)
as
pragma autonomous_transaction;
begin

    insert into lazorenko_al.error_log(sh_dt, object_name, log_type, params)
    values (p_sh_dt, p_object_name, p_log_type, p_params);

    commit;
end;


create table lazorenko_al.test(
    value number
);


create or replace procedure lazorenko_al.fail_method(
    p_value varchar2,
    p_need_handle boolean
)
as
begin
    if (p_need_handle) then
    begin
        insert into lazorenko_al.test(value)
        values (p_value);

        insert into lazorenko_al.test(value)
        values (p_value);

    exception
        when others then

            lazorenko_al.add_error_log(
                to_date('2022-03-22 10:00:00', 'yyyy-MM-dd HH:mI:ss'),
                $$plsql_unit_owner||'.'||$$plsql_unit,
                '{"error":"' || sqlerrm
                ||'","value":"' || p_value
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );

    rollback;

    end;
    else
        insert into lazorenko_al.test(value)
        values (p_value);
        commit;
    end if;

end;



declare
    v_value varchar2(100) := 'string';
    /*v_value number := 3;*/
begin

    lazorenko_al.fail_method(
        p_value => v_value,
        p_need_handle => true
    );

    commit;

end;