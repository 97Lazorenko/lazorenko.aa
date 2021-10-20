select a.last_name, a.first_name, b.name
from (select p.last_name, p.first_name, p.petronymic,
       case
       when round((sysdate-p.born_date)/365) between 0 and 2 then 1
       when round((sysdate-p.born_date)/365) between 3 and 17 then 2
       when round((sysdate-p.born_date)/365) between 18 and 59 then 3
       when round((sysdate-p.born_date)/365) between 60 and 100 then 2
       end as patient_age_group
from lazorenko_al.patient p) a inner join lazorenko_al.age_groups b on b.age_group_id=a.patient_age_group;