{{
    config(
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="id_interaccion",
        on_schema_change="append_new_columns",
    )
}}

with
    source as (

        select * from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}

    ),

    renombrar as (

        select
            {{ dbt_utils.generate_surrogate_key(["post_id", "tipo_interaccion"]) }}
            as id_interaccion,

            {{ dbt_utils.generate_surrogate_key(["post_id"]) }} as id_post,

            {{ dbt_utils.generate_surrogate_key(["tipo_interaccion"]) }}
            as id_tipo_interaccion,

            cantidad_interaccion as total_interaccion,
            created_at,
            updated_at,
            _fivetran_synced

        from source

    ),

    deduplicado as (

        select *
        from renombrar

        qualify
            row_number() over (
                partition by id_interaccion order by _fivetran_synced desc
            )
            = 1

    )

select *
from deduplicado
