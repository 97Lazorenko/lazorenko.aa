select h.name, a.name, o.name, count(doctor_id) as количество_врачей, m.close as по_будням_закрывается_в,
case
    when s.close is null then 'закрыто в выходные'
    else s.close
end as по_выходным_закрывется_в,
case
  when m.close>TO_CHAR(sysdate, 'hh24:mi:ss') and (select to_char(sysdate,'d') from dual) in (1, 2, 3, 4, 5) then 1
  when s.close>TO_CHAR(sysdate, 'hh24:mi:ss') and (select to_char(sysdate,'d') from dual) in (6, 7) then 1
  else 0
end as сейчас_открыто
from hospital h inner join available a using(availability_id)
    inner join ownership_type o using(ownership_type_id) inner join work_time using(work_time_id)
    inner join mon_fri_close m using(mf_close_time_id) inner join sat_sun_close s using(ss_close_time_id)
    inner join doctor using(hospital_id) inner join doctor_spec using(doctor_id)
    inner join specialisation using(spec_id)
where 2=spec_id and h.delete_from_the_sys is null
group by h.name, a.name, o.name, m.close, s.close
order by o.name desc, количество_врачей desc, сейчас_открыто desc;