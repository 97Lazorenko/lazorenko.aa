create or replace package lazorenko_al.pkg_fail
as
    procedure fail_method(
        p_value varchar2,
        p_need_handle boolean
    );
end;
/



create or replace package body lazorenko_al.pkg_fail
as
    procedure fail_method(
        p_value varchar2,
        p_need_handle boolean
    )
    as
    begin

        if (p_need_handle) then
            begin
                insert into lazorenko_al.test(value)
                values (p_value);

            exception
                when others then

                    lazorenko_al.add_error_log(
                        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
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

        end if;

    end;
end;
/



declare
    v_value varchar2(100) := 'string';
    /*v_value number := 5;*/
begin

   lazorenko_al.pkg_fail.fail_method(
        p_value => v_value,
        p_need_handle => true
    );

    commit;

exception
    when others then

       lazorenko_al.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit,
            '{"error":"' || sqlerrm
            ||'","value":"' || v_value
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );

end;