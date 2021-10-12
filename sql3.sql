select h.name, a.name, o.name, count(doctor_id) as количество_врачей, m.close, s.close,
case
  when m.close>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
  when s.close>TO_CHAR(sysdate, 'hh24:mi:ss') then 1
  else 0
end as сейчас_открыто
from hospital h inner join available a using(availability_id)
    inner join ownership_type o using(ownership_type_id) inner join work_time using(work_time_id)
    inner join mon_fri_close m using(mf_close_time_id) inner join sat_sun_close s using(ss_close_time_id)
    inner join doctor using(hospital_id) inner join doctor_spec using(doctor_id)
    inner join specialisation using(spec_id)
where 2=spec_id
group by h.name, a.name, o.name, m.close, s.close
order by o.name desc, количество_врачей desc, сейчас_открыто desc;