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
        select
            {{ dbt_utils.generate_surrogate_key(["post_id"]) }} as id_post,
            post_id as codigo_post,
            raw_json_id,
            {{ dbt_utils.generate_surrogate_key(["username", "plataforma"]) }}
            as id_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["tipo_contenido"]) }}
            as id_tipo_contenido,
            {{ dbt_utils.generate_surrogate_key(["source_api"]) }} as id_fuente_ingesta,
            es_campania_bf as es_campania,
            fecha_publicacion,
            descripcion_en,
            patrocinado,
            visualizaciones_post as visualizaciones,
            alcance_post as alcance,
            impresiones_post as impresiones,
            engagement_total,
            created_at,
            updated_at,
            _fivetran_synced
        from source
        qualify row_number() over (partition by post_id order by updated_at desc) = 1
    )

select *
from renombrar
