with
    source as (select * from {{ ref("int_audiencia_demografica") }}),

    renamed as (
        select
            -- Explicar que hice esto porque al principio con fecha snapshot tenía
            -- colisiones ya que no eran unicas
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "username",
                        "plataforma",
                        "genero",
                        "edad_segmento",
                        "pais",
                        "fecha_snapshot",
                    ]
                )
            }} as id_audiencia,
            {{ dbt_utils.generate_surrogate_key(["username", "plataforma"]) }}
            as id_perfil_social,
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
