select t.ticket_id, t.appointment_beg, t.appointment_end
from ticket t
where 3=doctor_id
  and t.appointment_beg>to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
order by t.appointment_beg;
