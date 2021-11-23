select *
    from (
        select
            er.id_log,
            er.sh_dt,
            er.object_name,
            er.params,

            (select error
            from json_table(er.params, '$' columns (
                error varchar2(100) path '$.error'
            ))) error,

            (select value
            from json_table(er.params, '$' columns (
                value varchar2(100) path '$.value'
            ))) value

        from (
            select *
            from lazorenko_al.error_log er
            where er.params like '{"%'  --если у вас всё-таки будет там лежать и не nosql в перемешку
           and trunc(er.sh_dt) = trunc(to_date('23.11.2021','dd.mm.yyyy'))
        ) er
    ) jt
where jt.params like /*'%string%'*/'%10%' and jt.object_name='LAZORENKO_AL.WRITE_TO_RECORDS'
;