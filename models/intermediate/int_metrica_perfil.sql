with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),

    renamed as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    ["username", "plataforma", "semana_snapshot"]
                )
            }} as id_metrica_perfil,
            {{ dbt_utils.generate_surrogate_key(["username", "plataforma"]) }}
            as id_perfil_social,
            semana_snapshot,
            seguidores,
            alcance_semanal,
            impresiones_semanales,
            visitas_perfil,
            created_at,
            updated_at
        from source
    )

select *
from renamed
