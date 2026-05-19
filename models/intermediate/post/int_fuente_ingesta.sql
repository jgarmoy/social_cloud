with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
    ),

    generar_surrogate_key as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["source_api"]) }} as id_fuente_ingesta,
            source_api as nombre
        from source
    )

select *
from generar_surrogate_key
