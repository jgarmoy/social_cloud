with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),

    generar_surrogate_key as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["plataforma"]) }} as id_red_social,
            plataforma as nombre
        from source
    )

select *
from generar_surrogate_key
