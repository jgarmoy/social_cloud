with
    source as (select * from {{ ref("int_audiencia_demografica") }}),
    renamed as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    ["username", "genero", "edad_segmento", "pais"]
                )
            }} as id_audiencia,
            {{ dbt_utils.generate_surrogate_key(["username"]) }} as id_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["genero"]) }} as id_genero,
            {{ dbt_utils.generate_surrogate_key(["edad_segmento"]) }} as id_rango_edad,
            {{ dbt_utils.generate_surrogate_key(["pais"]) }} as id_pais,
            fecha_snapshot,
            porcentaje_audiencia as porcentaje,
            seguidores,
            created_at,
            updated_at

        from source
    )

select *
from renamed
