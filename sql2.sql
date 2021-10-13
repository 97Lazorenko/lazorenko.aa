select distinct s.name
from specialisation s inner join doctor_spec using(spec_id)
    inner join doctor d using(doctor_id)
    inner join hospital h using(hospital_id)
where s.delete_from_the_sys is null and d.dismiss_date is null
                                    and h.delete_from_the_sys is null;