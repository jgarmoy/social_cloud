with source as (select * from {{ ref("int_genero") }})

select id_genero, nombre
from source
