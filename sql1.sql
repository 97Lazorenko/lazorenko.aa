select c.name, r.name
from CITY c inner join REGION r USING(region_id);