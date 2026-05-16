with source as (select * from {{ ref("int_tipo_interaccion") }})

select id_tipo_interaccion, nombre
from source
