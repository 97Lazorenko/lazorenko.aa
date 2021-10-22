select h.name, a.name, count(doctor_id) as количество_врачей, o.name, w.end_time,
 case
    when w.end_time>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
    else 0
end as сейчас_открыто
from hospital h left join work_time w using(hospital_id)
    inner join ownership_type o using(ownership_type_id)
    inner join doctor using(hospital_id) inner join doctor_spec using(doctor_id)
    inner join available a using(availability_id)
where 2=spec_id and h.delete_from_the_sys is null and w.day in to_char(sysdate, 'd')
group by h.name, a.name, o.name, w.end_time
order by o.name desc, количество_врачей desc, сейчас_открыто desc;