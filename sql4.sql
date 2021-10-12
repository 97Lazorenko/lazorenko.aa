select d.name, s.name, d.qualification,
CASE d.zone_id
     WHEN 2 THEN 1
     ELSE 0
END AS участок_пациента
from doctor d inner join doctor_spec using(doctor_id)
    inner join specialisation s using(spec_id)
    inner join hospital using(hospital_id)
where 5 = hospital_id and d.dismiss_date is null
order by участок_пациента desc, qualification desc;