with
    source as (select * from {{ ref("int_audiencia") }}),

    renamed as (
        select
            id_audiencia,
            id_perfil_social,
            id_genero,
            id_rango_edad,
            id_pais,
            year(fecha_snapshot) * 10000
            + month(fecha_snapshot) * 100
            + day(fecha_snapshot) as id_fecha,
            porcentaje,
            seguidores

        from source
    )

select *
from renamed
