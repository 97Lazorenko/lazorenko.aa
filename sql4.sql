select d.name, s.name, di.qualification,
case
     when d.zone_id=2 then 1 --участок пациента с zone_id=2
     else 0
end as участок_пациента
from doctor d inner join doctor_spec using(doctor_id)
    inner join specialisation s using(spec_id)
    inner join doctors_info di using(doctor_id)
    inner join hospital using(hospital_id)
where 5 = hospital_id and d.dismiss_date is null
order by участок_пациента desc, di.qualification desc;



