with source as (select * from {{ ref("int_fuente_ingesta") }})

select id_fuente_ingesta, nombre
from source
