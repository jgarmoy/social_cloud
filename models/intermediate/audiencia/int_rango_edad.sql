with
    source as (select * from {{ ref("int_audiencia_demografica") }}),

    rango_edad_procesados as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["edad_segmento"]) }} as id_rango_edad,
            coalesce(edad_segmento, 'Desconocido') as rango_edad,
            case
                when edad_segmento ilike '%-%'
                then cast(split(edad_segmento, '-')[0] as integer)
                when edad_segmento ilike '%+'
                then cast(split(edad_segmento, '+')[0] as integer)
            end as edad_min,
            case
                when edad_segmento ilike '%-%'
                then cast(split(edad_segmento, '-')[1] as integer)
            end as edad_max
        from source
    )

select *
from rango_edad_procesados
