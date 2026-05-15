with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
    ),
    generar_surrogate_key as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["tipo_interaccion"]) }}
            as id_tipo_interaccion,
            tipo_interaccion as nombre
        from source
    )

select *
from generar_surrogate_key
