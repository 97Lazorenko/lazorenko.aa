select distinct s.name
from specialisation s inner join doctor_spec using(spec_id) inner join doctor using(doctor_id)
where s.delete_from_the_sys is null;