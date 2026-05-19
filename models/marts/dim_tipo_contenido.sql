with source as (select * from {{ ref("int_tipo_contenido") }})

select id_tipo_contenido, nombre
from source
