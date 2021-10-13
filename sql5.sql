select t.ticket_id, t.appointment_beg, t.appointment_end
from ticket t inner join doctor d using(doctor_id)
where 3=doctor_id
  and t.appointment_beg>to_char(sysdate, 'dd/MM/yyyy hh24:mi:ss')
order by t.appointment_beg;