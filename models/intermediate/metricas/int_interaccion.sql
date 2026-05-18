{{
    config(
        materialized="incremental",
        incremental_strategy="append",
        on_schema_change="append_new_columns",
    )
}}

with
    source as (
        select *
        from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
        {% if is_incremental() %}
            where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})
        {% endif %}
    ),

    renombrar as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["post_id", "tipo_interaccion"]) }}
            as id_interaccion,
            {{ dbt_utils.generate_surrogate_key(["post_id"]) }} as id_post,
            {{ dbt_utils.generate_surrogate_key(["tipo_interaccion"]) }}
            as id_tipo_interaccion,
            cantidad_interaccion as total_interaccion,
            created_at,
            updated_at
        from source
    )

select *
from renombrar
