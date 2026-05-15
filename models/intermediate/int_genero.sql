with
    source as (select * from {{ ref("int_audiencia_demografica") }}),
    
    generar_surrogate_key as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["genero"]) }} as id_genero,
            genero as nombre
        from source
    )

select *
from generar_surrogate_key
