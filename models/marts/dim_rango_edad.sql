with source as (select * from {{ ref("int_rango_edad") }})

select id_rango_edad, rango_edad, edad_min, edad_max
from source
