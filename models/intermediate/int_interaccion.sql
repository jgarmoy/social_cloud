with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
    ),
    renamed as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["post_id", "tipo_interaccion"]) }}
            as id_interaccion,
            {{ dbt_utils.generate_surrogate_key(["post_id"]) }}
            as id_post,
            {{ dbt_utils.generate_surrogate_key(["tipo_interaccion"]) }}
            as id_tipo_interaccion,
            cantidad_interaccion as total_interaccion
        from source
    )

select *
from renamed
