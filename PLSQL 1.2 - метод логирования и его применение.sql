------------------------------------------------------------------------------------------------------------------------
---------------------------------------------Метод логирования с автономной транзакцией---------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace procedure lazorenko_al.add_error_log(
    p_object_name varchar2,
    p_params varchar2,
    p_log_type varchar2 default 'common'
)
as
pragma autonomous_transaction;
begin

    insert into lazorenko_al.error_log(object_name, log_type, params)
    values (p_object_name, p_log_type, p_params);

    commit;
end;

------------------------------------------------------------------------------------------------------------------------
--------------------------------------------Пакет, в котором отлавливаем и логируем ошибки------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace package lazorenko_al.pkg_fail
as
    procedure fail_method(
        p_value varchar2,
        p_need_handle boolean
    );
end;
/
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


--ПРОВЕРКА РАБОТОСПОСОБНОСТИ
declare
    v_value varchar2(100) := 'string'; --ОШИБКИ БУДУТ ПОПАДАТЬ В ПЕРВУЮ СЕКЦИЮ ТАБЛИЦЫ
    /*v_value number := 5;*/
begin

   lazorenko_al.pkg_fail.fail_method(
        p_value => v_value,
        p_need_handle => true
    );

    commit;
end;

--ЗАПИСИ ВНОСЯТСЯ
select *
from lazorenko_al.error_log;

------------------------------------------------------------------------------------------------------------------------
------------------------Просмотр секций, её очистка, восстановление инднеса после truncate------------------------------
------------------------------------------------------------------------------------------------------------------------

--ПРОСМАТРИВАЕМ СЕКЦИИ
select * from sys.user_tab_partitions;


--ОЧИСТКА ПЕРВОЙ СЕКЦИИ
alter table lazorenko_al.error_log truncate partition error_log_2021_qrt4;

--ПРОВЕРКА ОЧИСТКИ
select *
from lazorenko_al.error_log;


/*create or replace function lazorenko_al.get_index_name(           --ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ ИМЕНИ ИНДЕКСА
p_name_table varchar2
) return varchar2 as i_index_name varchar2(128);
begin
   select index_name
   into i_index_name
   from user_indexes
   where table_name=p_name_table;
   return i_index_name;
end;*/

declare
    v_index_name varchar2(128);
begin
    v_index_name:=lazorenko_al.get_index_name('ERROR_LOG');

    dbms_output.put_line(v_index_name); --ПОЛУЧАЕМ ИМЯ ИНДЕКСА
end;

--ВОССТАНОВЛЕНИЕ ИНДЕКСА
alter index lazorenko_al.SYS_C0028810 rebuild;

------------------------------------------------------------------------------------------------------------------------
--------------------------------------------ВНЕСЕНИЯ ЗАПИСЕЙ В ДРУГУЮ СЕКЦИЮ--------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--КОРРЕКТИРОВКА МЕТОДА ЛОГИРОВАНИЯ ДЛЯ ВОЗМОЖНОСТИ ВНЕСЕНИЯ ДАННЫХ В НОВУЮ СЕКЦИЮ
create or replace procedure lazorenko_al.add_error_log(
    p_sh_dt date, --БУДЕМ ЯВНО УКАЗЫВАТЬ ДАТУ И ВРЕМЯ
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


--ПРОЦЕДУРА, В КОТОРОЙ ОТЛАВЛИВАЕМ И ЛОГИРУЕМ ОШИБКИ
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
                to_date('2022-03-22 10:00:00', 'yyyy-MM-dd HH:mI:ss'), --ЯВНО УКАЗЫВАЕМ ДАТУ И ВРЕМЯ
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


--ЕЁ ИСПОЛЬЗОВАНИЕ
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

--ЗАПИСИ ВНОСЯТСЯ
select *
from lazorenko_al.error_log;

--ПРОСМАТРИВАЕМ СЕКЦИИ
select * from sys.user_tab_partitions; --НОВАЯ СЕКЦИЯ ПОЯВИЛАСЬ АВТОМАТИЧЕСКИ ЗА СЧЁТ НАСТРОЙКИ СЕКЦИОНИРОВАНИЯ - interval (NUMTOYMINTERVAL(3, 'MONTH'))



/*create or replace function lazorenko_al.get_partition_name(           --ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ ИМЕНИ СЕКЦИИ
p_name_table varchar2,
p_partition_position number
) return varchar2 as v_partition_name varchar2(128);
begin
   select partition_name
   into v_partition_name
   from sys.user_tab_partitions
   where table_name=p_name_table and partition_position=p_partition_position;
   return v_partition_name;
end;*/


declare
    v_partition_name varchar2(128);
begin
    v_partition_name:=lazorenko_al.get_partition_name('ERROR_LOG', 2);
    dbms_output.put_line(v_partition_name);  --ПОЛУЧАЕМ ИМЯ СЕКЦИИ
end;

--ОЧИСТКА ВТОРОЙ СЕКЦИИ
alter table lazorenko_al.error_log truncate partition SYS_P1374;

--ПРОВЕРКА ОЧИСТКИ
select *
from lazorenko_al.error_log;


--ВОССТАНОВЛЕНИЕ ИНДЕКСА
declare
    v_index_name varchar2(128);
begin
    v_index_name:=lazorenko_al.get_index_name('ERROR_LOG');
    dbms_output.put_line(v_index_name); --ПОЛУЧАЕМ ИМЯ ИНДЕКСА
end;

alter index lazorenko_al.SYS_C0028810 rebuild;